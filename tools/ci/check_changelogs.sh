#!/bin/bash
set -euo pipefail

md5sum -c - <<< "0c56937110d88f750a32d9075ddaab8b *html/changelogs/example.yml"
python3 tools/ss13_genchangelog.py html/changelogs
