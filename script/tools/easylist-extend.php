<?php
/**
 * easylist extend
 *
 * @file easylist-extend.php
 * @date 2021-05-01 23:14:30
 * @author gently
 *
 */
set_time_limit(0);

error_reporting(7);
date_default_timezone_set('Asia/Shanghai');
define('START_TIME', microtime(true));
define('ROOT_DIR', dirname(__DIR__) . '/');
const LIB_DIR = ROOT_DIR . 'lib/';

$black_domain_list = require_once LIB_DIR . 'black_domain_list.php';
require_once LIB_DIR . 'addressMaker.class.php';
const WILDCARD_SRC = ROOT_DIR . 'origin-files/wildcard-src-easylist.txt';
const WHITERULE_SRC = ROOT_DIR . 'origin-files/whiterule-src-easylist.txt';

$ARR_MERGED_WILD_LIST = array(
);

$ARR_REGEX_LIST = array(
);

//对通配符匹配或正则匹配增加的额外赦免规则
$ARR_WHITE_RULE_LIST = array(
  '@@||t.uc.cn^' => 0, //夸克網盤登陸
);

//针对上游赦免规则anti-AD不予赦免的规则，即赦免名单的黑名单
$ARR_WHITE_RULE_BLK_LIST = array(
);

//针对上游通配符规则中anti-AD不予采信的规则，即通配符黑名单
$ARR_WILD_BLK_LIST = array(
);

if(PHP_SAPI != 'cli'){
    die('nothing.');
}

$src_file = '';
try{
    $file = $argv[1];
    $src_file = ROOT_DIR . $file;
}catch(Exception $e){
    echo "get args failed.", $e->getMessage(), "\n";
    die(0);
}

if(empty($src_file) || !is_file($src_file)){
    echo 'src_file:', $src_file, ' is not found.';
    die(0);
}

if(!is_file(WILDCARD_SRC) || !is_file(WHITERULE_SRC)){
    echo 'key file is not found.';
    die(0);
}

$wild_fp = fopen(WILDCARD_SRC, 'r');
$arr_wild_src = array();

while(!feof($wild_fp)){
    $wild_row = fgets($wild_fp, 512);
    if(empty($wild_row)){
        continue;
    }
    if(!preg_match('/^\|\|?([\w\-\.\*]+?)\^(\$([^=]+?,)?(image|third-party|script)(,[^=]+)?)?$/', $wild_row, $matches)){
        continue;
    }

    if(array_key_exists($matches[1], $ARR_WILD_BLK_LIST)){
        continue;
    }

    $matched = false;
    // TODO 此处匹配似乎还不够完美，需再次斟酌
    foreach($ARR_REGEX_LIST as $regex_str => $regex_row){
        if(preg_match($regex_str, str_replace('*', '', $matches[1]))){
            $matched = true;
            break;
        }
    }
    if($matched){
        continue;
    }
    $arr_wild_src[$matches[1]] = [];
}
fclose($wild_fp);

$arr_wild_src = array_merge($arr_wild_src, $ARR_MERGED_WILD_LIST);

$written_size = $line_count = 0;

$src_content = file_get_contents($src_file);
$attached_content = '';
$tmp_replaced_content = '';

//按需写入白名单规则
$whiterule = file(WHITERULE_SRC, FILE_SKIP_EMPTY_LINES | FILE_IGNORE_NEW_LINES);
$whiterule = array_fill_keys($whiterule, 0);
$ARR_WHITE_RULE_LIST = array_merge($whiterule, $ARR_WHITE_RULE_LIST);
$wrote_whitelist = [];
$remained_white_rule = [];
foreach($ARR_WHITE_RULE_LIST as $row => $v){
    if(empty($row) || substr($row, 0, 1) !== '@' || substr($row, 1, 1) !== '@'){
        continue;
    }
    $matches = array();
    if(!preg_match('/^@@\|\|([0-9a-z\.\-\*]+?)\^/', $row, $matches)){
        continue;
    }

    if(array_key_exists("@@||${matches[1]}^", $ARR_WHITE_RULE_BLK_LIST)){
        continue;
    }

    if(array_key_exists($matches[1], $wrote_whitelist)){
        continue;
    }

    if($v === 1){
        $wrote_whitelist[$matches[1]] = null;
        $attached_content .= "@@||${matches[1]}^\n";
        $line_count++;
        continue;
    }

    $origin_white_rule = $matches[1];
    $wrote_whitelist[$origin_white_rule] = null;
    $matches[1] = str_replace('*', '.abc.', $matches[1]);
    $matches[1] = str_replace('..', '.', $matches[1]);
    $extract_domain = addressMaker::extract_main_domain($matches[1]);
    if(!$extract_domain){
        $extract_domain = $matches[1];
    }

    // TODO 3级或以上域名加白2级域名的情况未纳入
    if(strpos($src_content, '|' . $extract_domain) === false){
        $remained_white_rule[$origin_white_rule] = 1;
        continue;
    }

    $attached_content .= "@@||${origin_white_rule}^\n";
    $line_count++;
}

unset($wrote_whitelist);

// 清洗正则表达式匹配
foreach($ARR_REGEX_LIST as $regex_str => $regex_row){
    $php_regex = str_replace(array('/^', '$/'), array('/^\|\|', '\^'), $regex_str);
    $php_regex = preg_replace('/(.+?[^$])\/$/', '\1.*\^', $php_regex);
    $php_regex .= "\n/m";

    $tmp_replaced_content = preg_replace($php_regex, '', $src_content);
    if($tmp_replaced_content === $src_content){
        continue;
    }
    $src_content = $tmp_replaced_content;
    $tmp_replaced_content = '';
    $attached_content .= $regex_str;
    if($regex_row && is_array($regex_row) && $regex_row['m']){
        $attached_content .= $regex_row['m'];
    }
    $attached_content .= "\n";
    $line_count++;

    foreach($remained_white_rule as $rmk => $rmv){
        if(preg_match($php_regex, '||' . str_replace('*', '123', $rmk) . "^\n\n")){
            $attached_content .= '@@||' . $rmk . "^\n";
            $line_count++;
            unset($remained_white_rule[$rmk]);
        }
    }
}

// 清洗*号模糊匹配
$wrote_wild_list = array();
foreach($arr_wild_src as $wild_rule => $wild_value){

    if(array_key_exists($wild_rule, $wrote_wild_list)){
        continue;
    }

    $php_regex = '/^\|\|(\S+\.)?' . str_replace(array('.', '*', '-'), array('\\.', '.*', '\\-'), $wild_rule) . "\^\n/m";
    $tmp_replaced_content = preg_replace($php_regex, '', $src_content);
    if($tmp_replaced_content == $src_content){
        continue;
    }

    $wrote_wild_list[$wild_rule] = 1;

    $src_content = $tmp_replaced_content;
    $tmp_replaced_content = '';
    $attached_content .= '||' . $wild_rule;
    if($wild_value && is_array($wild_value) && $wild_value['m']){
        $attached_content .= '^' . $wild_value['m'] . "\n";
    }else{
        $attached_content .= "^\n";
    }

    $line_count++;

    foreach($remained_white_rule as $rmk => $rmv){
        if(preg_match($php_regex, '||' . str_replace('*', '123', $rmk) . "^\n\n")){
            $attached_content .= '@@||' . $rmk . "^\n";
            $line_count++;
            unset($remained_white_rule[$rmk]);
        }
    }
}

$line_count += substr_count($src_content, "\n");
$correct_magic = preg_match_all("/^\!.+?$/m", $src_content);
$src_content = str_replace("!Total lines: 00000\n", '!Total lines: ' . ($line_count - $correct_magic) . "\n" . $attached_content, $src_content);

file_put_contents($src_file, $src_content);
file_put_contents($src_file . '.md5', md5_file($src_file));
echo 'Time cost:', microtime(true) - START_TIME, "s, at ", date('m-d H:i:s'), "\n";
