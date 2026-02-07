#!/usr/bin/env python3
"""
Hostlist Compressor with Strict Validation
Based on Cats-Team Hostlist-Compressor & JS Validation Logic
"""
from __future__ import annotations

import argparse
import logging
import re
import sys
from dataclasses import dataclass
from pathlib import Path
from typing import List, Optional, Set, Tuple

# --- Constants & Regex ---

# Adblock Syntax
DOMAIN_PREFIX = "||"
DOMAIN_SEPARATOR = "^"
WILDCARD = "*"
WILDCARD_PART = "*."

# Supported Modifiers (from JS logic)
ANY_PATTERN_MODIFIER = {"denyallow", "badfilter", "client"}
SUPPORTED_MODIFIERS = {
    "important", "~important", "ctag", "dnstype", "dnsrewrite",
    *ANY_PATTERN_MODIFIER
}

# Regex Patterns
RE_ETC_HOSTS = re.compile(r"^\s*((?:#|!)?\s*\d+\.\d+\.\d+\.\d+\s+([\w\.-]+\s*)+)")
RE_IP_LIKE = re.compile(r"^\|?\|?\d{1,3}(?:\.\d{1,3}){3}\^?$")
RE_VALID_DOMAIN_CHARS = re.compile(r"^[a-zA-Z0-9\-.*|^]+$")
RE_ADBLOCK_SIMPLE = re.compile(r"^\|\|[\w\.\-\*]+\^$")
RE_DOMAIN_SUFFIX_LIST = re.compile(r"^DOMAIN(?:-SUFFIX)?,\s*([\w\.\-\*]+)\s*$", re.IGNORECASE)

# Output Filter: Standard adblock domain rule (||domain.com^)
RE_OUTPUT_FILTER = re.compile(
    r"^\|\|(?:\*|(?:\*\.)?[a-z0-9*](?:[a-z0-9*\-]{0,61}[a-z0-9*])?)(?:\.[a-z0-9*](?:[a-z0-9*\-]{0,61}[a-z0-9*])?)+\^$",
    re.IGNORECASE
)

# --- Logging Configuration (Modified) ---
logging.basicConfig(
    level=logging.INFO,
    format="[%(levelname)s] %(asctime)s - %(message)s",
    datefmt="%Y-%m-%d %H:%M:%S"
)
logger = logging.getLogger(__name__)

@dataclass
class AdblockRule:
    rule_text: str
    can_compress: bool
    hostname: Optional[str]
    original_text: str

# --- Logic Ported from JavaScript (Validator) ---

class RuleValidator:
    """
    Port of the JavaScript Validator class.
    Performs strict validation and cleans up invalid rules + preceding comments.
    """
    def __init__(self, allow_ip: bool = False):
        self.allow_ip = allow_ip
        self._prev_removed = False

    @staticmethod
    def is_comment(line: str) -> bool:
        return line.lstrip().startswith(('!', '#'))

    def _valid_hostname(self, hostname: str, rule_text: str, has_limit_mod: bool) -> bool:
        """Checks if hostname is valid. Imitates tldts logic with standard lib."""
        hostname = hostname.strip().lower()
        
        if not hostname:
            return False

        # IP Check
        is_ip = bool(re.match(r"^\d{1,3}(\.\d{1,3}){3}$", hostname))
        if is_ip and not self.allow_ip:
            logger.debug(f"Invalid hostname (IP not allowed): {hostname} in {rule_text}")
            return False

        # Public Suffix Check (Heuristic approximation for stdlib)
        if '.' not in hostname and not is_ip and not has_limit_mod and hostname != "localhost":
            logger.debug(f"Matching whole TLD/Suffix not allowed: {hostname} in {rule_text}")
            return False

        return True

    def _valid_etc_hosts(self, rule: str) -> bool:
        parts = rule.split()
        # Remove comments/IP
        hosts = [p for p in parts if not p.startswith(('#', '!'))]
        if len(hosts) < 2: 
            return False
        
        hostnames = hosts[1:] # 0 is IP
        return all(self._valid_hostname(h, rule, False) for h in hostnames)

    def _valid_adblock(self, rule: str) -> bool:
        # 1. Parse Modifiers (Simplified parser)
        has_limit_mod = False
        if '$' in rule:
            try:
                base, opts = rule.split('$', 1)
                options = opts.split(',')
                for opt in options:
                    name = opt.split('=', 1)[0].strip()
                    if name not in SUPPORTED_MODIFIERS:
                        logger.debug(f"Unsupported modifier {name}: {rule}")
                        return False
                    if name in ANY_PATTERN_MODIFIER:
                        has_limit_mod = True
            except ValueError:
                return False
        else:
            base = rule

        trimmed_pattern = base.strip()

        # 2. Length Check
        if len(trimmed_pattern) < 5:
            logger.debug(f"Rule too short: {rule}")
            return False

        # 3. Char Check (Skip regex rules /.../)
        if not (trimmed_pattern.startswith('/') and trimmed_pattern.endswith('/')):
            to_test = trimmed_pattern.lstrip(':/') # Handle ://
            if not RE_VALID_DOMAIN_CHARS.match(to_test):
                logger.debug(f"Invalid chars in rule: {rule}")
                return False

        # 4. Domain Validation
        # Check standard ||domain^ pattern
        if trimmed_pattern.startswith(DOMAIN_PREFIX) and DOMAIN_SEPARATOR in trimmed_pattern:
            sep_idx = trimmed_pattern.find(DOMAIN_SEPARATOR)
            wild_idx = trimmed_pattern.find(WILDCARD)
            
            # Invalid: ||example.org^test*
            if wild_idx != -1 and wild_idx > sep_idx:
                return False

            domain_part = trimmed_pattern[len(DOMAIN_PREFIX):sep_idx]

            # Handle wildcards
            if wild_idx != -1:
                # Logic: If ||*.example.com^, check example.com
                if domain_part.startswith(WILDCARD_PART):
                    clean_domain = domain_part.replace(WILDCARD_PART, "")
                    if '.' not in clean_domain:
                         return self._valid_hostname(clean_domain, rule, has_limit_mod)
                    return True 
                return True 

            if not self._valid_hostname(domain_part, rule, has_limit_mod):
                return False
            
            # Check trailing garbage (except |)
            if len(trimmed_pattern) > sep_idx + 1 and trimmed_pattern[sep_idx+1] != '|':
                return False

        return True

    def is_valid(self, rule: str) -> bool:
        if not rule.strip() or self.is_comment(rule):
            return True
        if RE_ETC_HOSTS.match(rule):
            return self._valid_etc_hosts(rule)
        return self._valid_adblock(rule)

    def validate(self, rules: List[str]) -> Tuple[List[str], List[str]]:
        """
        Main validation loop (Backwards iteration).
        Returns: (valid_rules, removed_lines_for_logging)
        """
        filtered = list(rules)
        removed_log = []
        
        # Iterate backwards
        for i in range(len(filtered) - 1, -1, -1):
            line = filtered[i]
            is_valid_rule = self.is_valid(line)
            is_empty_or_comment = not line.strip() or self.is_comment(line)

            if not is_valid_rule:
                self._prev_removed = True
                removed_log.append(line)
                del filtered[i]
            elif self._prev_removed and is_empty_or_comment:
                del filtered[i]
            else:
                self._prev_removed = False
        
        return filtered, removed_log

# --- Compression Logic (Optimized) ---

def parse_rule(rule_text: str) -> List[AdblockRule]:
    """Convert raw text to AdblockRule objects."""
    rule_text = rule_text.strip()
    res = []
    
    # 1. Domain Lists (DOMAIN, example.com)
    m_domain = RE_DOMAIN_SUFFIX_LIST.match(rule_text)
    if m_domain:
        host = m_domain.group(1)
        if not RE_IP_LIKE.match(host):
            res.append(AdblockRule(f"||{host}^", True, host, rule_text))
        return res

    # 2. /etc/hosts
    if RE_ETC_HOSTS.match(rule_text):
        parts = rule_text.split()
        hosts = [p for p in parts if p and not p.startswith(('#', '!'))][1:]
        for h in hosts:
            if not RE_IP_LIKE.match(h):
                res.append(AdblockRule(f"||{h}^", True, h, rule_text))
        return res

    # 3. Pure Domain (example.com) - strict check
    if RE_VALID_DOMAIN_CHARS.match(rule_text) and '.' in rule_text and not rule_text.startswith('/') and not rule_text.startswith('||'):
         if not RE_IP_LIKE.match(rule_text):
             res.append(AdblockRule(f"||{rule_text}^", True, rule_text, rule_text))
         return res

    # 4. Standard Adblock matches ||...^
    if rule_text.startswith("||") and rule_text.endswith("^"):
        inner = rule_text[2:-1]
        # Only allow plain domains to be "Compressible", wildcards fall to fallback
        if not RE_IP_LIKE.match(inner) and '*' not in inner:
            res.append(AdblockRule(rule_text, True, inner, rule_text))
            return res

    # Fallback: Uncompressible (includes Wildcards, RegEx, or Invalid Formats)
    res.append(AdblockRule(rule_text, False, None, rule_text))
    return res

def compress_rules(rules: List[str], include_wildcards: bool) -> Tuple[List[str], List[str]]:
    """Compress validated rules."""
    seen_hosts: Set[str] = set()
    compressible: List[AdblockRule] = []
    filtered_text: List[str] = []
    kept_wildcards: List[str] = []

    # Phase 1: Classification & Deduplication
    for line in rules:
        parsed_list = parse_rule(line)
        if not parsed_list:
            filtered_text.append(line)
            continue

        for r in parsed_list:
            if r.can_compress and r.hostname:
                if r.hostname not in seen_hosts:
                    compressible.append(r)
                    seen_hosts.add(r.hostname)
                else:
                    filtered_text.append(r.original_text)
            else:
                # Handle non-compressible (Raw processing)
                is_cmt = r.rule_text.lstrip().startswith(('!', '#'))
                if include_wildcards and '*' in r.rule_text and not is_cmt:
                    kept_wildcards.append(r.rule_text)
                else:
                    filtered_text.append(r.original_text)

    # Phase 2: Redundancy Removal & Output Construction
    final_list: List[str] = []
    
    for r in compressible:
        parts = r.hostname.split('.')
        covered = False
        # Check all parent domains
        for i in range(1, len(parts)):
            parent = ".".join(parts[i:])
            if parent in seen_hosts:
                covered = True
                break
        
        if covered:
            filtered_text.append(r.original_text)
        else:
            if RE_OUTPUT_FILTER.match(r.rule_text):
                final_list.append(r.rule_text)
            else:
                 filtered_text.append(r.original_text)

    # Phase 3: Final Merge and STRICT ENFORCEMENT
    merged_output = final_list + kept_wildcards
    strictly_validated_output: List[str] = []

    for rule in merged_output:
        if RE_OUTPUT_FILTER.match(rule):
            strictly_validated_output.append(rule)
        else:
            filtered_text.append(rule)

    return strictly_validated_output, filtered_text

# --- Main CLI ---

def main() -> int:
    parser = argparse.ArgumentParser(description="Strict Hostlist Compressor")
    parser.add_argument("input", nargs="?", default="-", help="Input file (stdin default)")
    parser.add_argument("-o", "--output", help="Output file")
    parser.add_argument("-i", "--in-place", action="store_true", help="Modify input file")
    parser.add_argument("--filtered", help="Save filtered rules to file")
    parser.add_argument("--include-wildcards", action="store_true", help="Keep wildcard rules")
    
    args = parser.parse_args()

    # 1. Input Reading
    try:
        if args.input == "-":
            if args.in_place:
                logger.error("Cannot use --in-place with stdin")
                return 1
            content = sys.stdin.read().splitlines()
        else:
            content = Path(args.input).read_text(encoding="utf-8").splitlines()
    except Exception as e:
        logger.error(f"Read error: {e}")
        return 1

    # 2. Strict Validation (The JS Logic)
    validator = RuleValidator(allow_ip=False)
    valid_content, validation_filtered = validator.validate(content)
    
    logger.info(f"验证域名: {len(content)} -> {len(valid_content)} (移除 {len(validation_filtered)} 条)")

    # 3. Compression
    compressed, compression_filtered = compress_rules(valid_content, args.include_wildcards)
    
    all_filtered = validation_filtered + compression_filtered 

    logger.info(f"压缩完成 - {len(content)} -> {len(compressed)} (移除 {len(all_filtered)} 条)")

    # 4. Output
    output_lines = "\n".join(compressed) + "\n"
    
    try:
        if args.in_place and args.input != "-":
            Path(args.input).write_text(output_lines, encoding="utf-8", newline="\n")
        elif args.output:
            Path(args.output).write_text(output_lines, encoding="utf-8", newline="\n")
        else:
            sys.stdout.write(output_lines)

        if args.filtered:
            Path(args.filtered).write_text("\n".join(all_filtered) + "\n", encoding="utf-8", newline="\n")
            
    except Exception as e:
        logger.error(f"Write error: {e}")
        return 1
        
    return 0

if __name__ == "__main__":
    sys.exit(main())