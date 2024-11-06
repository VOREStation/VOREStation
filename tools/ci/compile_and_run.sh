#!/bin/bash

RED='\033[0;31m'
NC='\033[0m'

source $HOME/BYOND/byond/bin/byondsetup

# Clean up between steps so Juke doesn't refuse to recompile with different -D options
rm vorestation.dmb

# Copy example configs
cp config/example/* config/

# Compile a copy of the codebase, and print errors as Github Actions annotations
tools/build/build --ci dm -DCIBUILDING -DCITESTING ${EXTRA_ARGS}
exitVal=$?

# Compile failed on map_test
if [ $exitVal -gt 0 ]; then
  echo "${RED}Errors were produced during CI with arguments ${EXTRA_ARGS}, please review CI logs.${NC}"
  exit 1
fi

# If we're running, run
if [ $RUN -eq 1 ];
then
  DreamDaemon $BASENAME.dmb -invisible -trusted -core 2>&1 | tee log.txt;
  grep "All Unit Tests Passed" log.txt || exit 1
  grep "Caught 0 Runtimes" log.txt || exit 1
fi
