#!/bin/bash

RED='\033[0;31m'
NC='\033[0m'

source $HOME/BYOND/byond/bin/byondsetup

# Clean up between steps so Juke doesn't refuse to recompile with different -D options
rm vorestation.dmb

# Copy example configs
cp config/example/* config/

# Create spritesheet directory
mkdir -p data/spritesheets

# Compile a copy of the codebase, and print errors as Github Actions annotations
tools/build/build.sh --ci dm -DCIBUILDING -DCITESTING ${EXTRA_ARGS}
exitVal=$?

# Compile failed on map_test
if [ $exitVal -gt 0 ]; then
  echo "${RED}Errors were produced during CI with arguments ${EXTRA_ARGS}, please review CI logs.${NC}"
  exit 1
fi

DreamDaemon vorestation.dmb -close -invisible -trusted -verbose -params "log-directory=ci"

cat data/logs/ci/clean_run.lk
