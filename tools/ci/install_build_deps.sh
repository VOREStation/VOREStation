#!/bin/bash
set -euo pipefail

source _build_dependencies.sh

source ~/.nvm/nvm.sh
nvm install $NODE_VERSION
nvm use $NODE_VERSION
npm install --location=global yarn

pip install --user PyYaml -q
pip install --user beautifulsoup4 -q
