#!/bin/bash
set -euo pipefail

source _build_dependencies.sh

source ~/.nvm/nvm.sh
nvm use $NODE_VERSION
cd tgui
chmod +x bin/tgui
bin/tgui --lint
bin/tgui --test
yarn tgui:prettier
cd ..
