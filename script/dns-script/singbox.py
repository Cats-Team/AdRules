import json
from datetime import datetime

with open('domain.txt', 'r') as file:
    domains = [line.strip() for line in file]

rules = {
    "version": "1",
    "rules": [
        {
            "domain_suffix": domains
        }
    ]
}

with open('adrules-singbox.json', 'w') as file:
    json.dump(rules, file, indent=4)
