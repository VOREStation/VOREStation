#!/bin/bash

source _build_dependencies.sh

RED='\033[0;31m'
NC='\033[0m'
FAILED=0

#Checking for step_x/step_y defined in any maps anywhere.
(! grep 'step_[xy]' maps/**/*.dmm)
retVal=$?
if [ $retVal -ne 0 ]; then
  echo -e "${RED}The variables 'step_x' and 'step_y' are present on a map, and they 'break' movement ingame.${NC}"
  FAILED=1
fi

#Checking for 'tag' set to something on maps
(! grep -Pn '( |\t|;|{)tag( ?)=' maps/**/*.dmm)
retVal=$?
if [ $retVal -ne 0 ]; then
  echo -e "${RED}A map has 'tag' set on an atom. It may cause problems and should be removed.${NC}"
  FAILED=1
fi

#Checking for broken HTML tags (didn't close the quote for class)
(! grep -En "<\s*span\s+class\s*=\s*('[^'>]+|[^'>]+')\s*>" **/*.dm)
retVal=$?
if [ $retVal -ne 0 ]; then
  echo -e "${RED}A broken span tag class is present (check quotes).${NC}"
  FAILED=1
fi

#Checking for any 'checked' maps that include 'test'
(! grep 'maps\\.*test.*' *.dme)
retVal=$?
if [ $retVal -ne 0 ]; then
  echo -e "${RED}A map containing the word 'test' is included. This is not allowed to be committed.${NC}"
  FAILED=1
fi

#Check for weird indentation in any .dm files
awk -f tools/indentation.awk **/*.dm
retVal=$?
if [ $retVal -ne 0 ]; then
  echo -e "${RED}Indention testing failed. Please see results and fix indentation.${NC}"
  FAILED=1
fi

#Checking for a change to html/changelogs/example.yml
md5sum -c - <<< "ea467b7b75774b41ecdf35e07091d96f *html/changelogs/example.yml"
retVal=$?
if [ $retVal -ne 0 ]; then
  echo -e "${RED}Do not modify the example.yml changelog file.${NC}"
  FAILED=1
fi

#Checking for color macros
(num=`grep -E '\\\\(red|blue|green|black|b|i[^mc])' **/*.dm | wc -l`; echo "$num escapes (expecting ${MACRO_COUNT} or less)"; [ $num -le ${MACRO_COUNT} ])
retVal=$?
if [ $retVal -ne 0 ]; then
  echo -e "${RED}Do not use any byond color macros (such as \blue), they are deprecated.${NC}"
  FAILED=1
fi

#Checking for missed tags
python tools/TagMatcher/tag-matcher.py ../..
retVal=$?
if [ $retVal -ne 0 ]; then
  echo -e "${RED}Some HTML tags are missing their opening/closing partners. Please correct this.${NC}"
  FAILED=1
fi

# Quit with our status code
exit $FAILED
