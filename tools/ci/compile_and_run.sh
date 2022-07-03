#!/bin/bash

RED='\033[0;31m'
NC='\033[0m'

source $HOME/BYOND/byond/bin/byondsetup

# Copy example configs
cp config/example/* config/

# Define any unit test defines that need to run
echo "#define ${TEST_DEFINE} 1" > ${TEST_FILE}

replace=${REPLACE}
# Messy map compile code
if grep -q '#include\ \"maps\\tether\\tether.dm\"' $BASENAME.dme && replace; then
  sed -i 's/#include[[:space:]]\"maps\\tether\\tether.dm\"/#include\ \"maps\\${MAP}\\${MAP}.dm\"/g' $BASENAME.dme
  replace=false
elif grep -q '#include\ \"maps\\stellardelight\\stellardelight.dm\"' $BASENAME.dme && replace; then
  sed -i 's/#include[[:space:]]\"maps\\stellardelight\\stellardelight.dm\"/#include\ \"maps\\${MAP}\\${MAP}.dm\"/g' $BASENAME.dme
  replace=false
elif grep -q '#include\ \"maps\\groundbase\\groundbase.dm\"' $BASENAME.dme && replace; then
  sed -i 's/#include[[:space:]]\"maps\\groundbase\\groundbase.dm\"/#include\ \"maps\\${MAP}\\${MAP}.dm\"/g' $BASENAME.dme
  replace=false
fi

# Compile a copy of the codebase, and print errors as Github Actions annotations
DreamMaker $BASENAME.dme > compile.log
exitVal=$?
cat compile.log
if [ $exitVal -gt 0 ]; then
	sed -E -n 's/^(.+?\.dm):([0-9]+):(error|warning): (.+)$/::\3 file=\1,line=\2::\4/gp' < compile.log
fi

# Compile failed on map_test
if [ $exitVal -gt 0 ] && [ $TEST_DEFINE = "MAP_TEST" ]; then
  echo "${RED}Some POIs appear to contain map-specific objects or code. Please isolate map-specific items/code from POIs.${NC}"
  exit 1
# Compile failed on away_mission_test
elif [ $exitVal -gt 0 ] && [ $TEST_DEFINE = "AWAY_MISSION_TEST" ]; then
  echo "${RED}Some away missions failed to compile. Please check them for missing items/objects by trying to compile them in DreamMaker.${NC}"
  exit 1
# Compile failed on unit_test
elif [ $exitVal -gt 0 ] && [ $TEST_DEFINE = "UNIT_TEST" ]; then
  echo "${RED}Compiling the codebase normally failed. Please review the compile errors and correct them, usually before making your PR.${NC}"
  exit 1
fi

# If we're running, run
if [ $RUN -eq 1 ];
then
  DreamDaemon $BASENAME.dmb -invisible -trusted -core 2>&1 | tee log.txt;
  grep "All Unit Tests Passed" log.txt || exit 1
  grep "Caught 0 Runtimes" log.txt || exit 1
fi
