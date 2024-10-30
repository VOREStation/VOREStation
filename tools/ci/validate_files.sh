#!/bin/bash
set -euo pipefail

# nb: must be bash to support shopt globstar
shopt -s globstar extglob

source _build_dependencies.sh

# ANSI Colors
RED='\033[0;31m'
GREEN="\033[0;32m"
BLUE="\033[0;34m"
NC='\033[0m' # No color

FAILED=0

# check for ripgrep
if command -v rg >/dev/null 2>&1; then
	grep=rg
	pcre2_support=1
	if [ ! rg -P '' >/dev/null 2>&1 ] ; then
		pcre2_support=0
	fi
	code_files="code/**/**.dm"
	map_files="maps/**/**.dmm"
	# shuttle_map_files="_maps/shuttles/**.dmm"
	# code_x_515="code/**/!(__byond_version_compat).dm"
else
	pcre2_support=0
	grep=grep
	code_files="-r --include=code/**/**.dm"
	map_files="-r --include=maps/**/**.dmm"
	# shuttle_map_files="-r --include=_maps/shuttles/**.dmm"
	# code_x_515="-r --include=code/**/!(__byond_version_compat).dm"
fi

echo -e "${BLUE}Using grep provider at $(which $grep)${NC}"

part=0
section() {
	echo -e "${BLUE}Checking for $1${NC}..."
	part=0
}

part() {
	part=$((part+1))
	padded=$(printf "%02d" $part)
	echo -e "${GREEN} $padded- $1${NC}"
}

section "map issues"

part "step_[xy]"
#Checking for step_x/step_y defined in any maps anywhere.
(! $grep 'step_[xy]' $map_files)
retVal=$?
if [ $retVal -ne 0 ]; then
  echo -e "${RED}The variables 'step_x' and 'step_y' are present on a map, and they 'break' movement ingame.${NC}"
  FAILED=1
fi

part "test map included"
#Checking for any 'checked' maps that include 'test'
(! $grep 'maps\\.*test.*' *.dme)
retVal=$?
if [ $retVal -ne 0 ]; then
  echo -e "${RED}A map containing the word 'test' is included. This is not allowed to be committed.${NC}"
  FAILED=1
fi

section "code issues"

part "indentation"
echo -e "${RED}DISABLED"
#Check for weird indentation in any .dm files
# awk -f tools/indentation.awk $code_files
# retVal=$?
# if [ $retVal -ne 0 ]; then
#   echo -e "${RED}Indention testing failed. Please see results and fix indentation.${NC}"
#   FAILED=1
# fi

part "improperly pathed static lists"
if $grep -i 'var/list/static/.*' $code_files; then
	echo
	echo -e "${RED}ERROR: Found incorrect static list definition 'var/list/static/', it should be 'var/static/list/' instead.${NC}"
	st=1
fi;

part "changelog"
#Checking for a change to html/changelogs/example.yml
md5sum -c - <<< "ea467b7b75774b41ecdf35e07091d96f *html/changelogs/example.yml"
retVal=$?
if [ $retVal -ne 0 ]; then
  echo -e "${RED}Do not modify the example.yml changelog file.${NC}"
  FAILED=1
fi

part "color macros"
#Checking for color macros
(num=`$grep -n '\\\\(red|blue|green|black|b|i[^mnc])' $code_files | wc -l`; echo "$num escapes (expecting ${MACRO_COUNT} or less)"; [ $num -le ${MACRO_COUNT} ])
retVal=$?
if [ $retVal -ne 0 ]; then
  echo -e "${RED}Do not use any byond color macros (such as \blue), they are deprecated.${NC}"
  FAILED=1
fi

part "html tag matching"
#Checking for missed tags
echo -e "${RED}DISABLED"
# python tools/TagMatcher/tag-matcher.py ../..
# retVal=$?
# if [ $retVal -ne 0 ]; then
#   echo -e "${RED}Some HTML tags are missing their opening/closing partners. Please correct this.${NC}"
#   FAILED=1
# fi

if [ "$pcre2_support" -eq 1 ]; then
	section "regexes requiring PCRE2"

	part "tag"
	#Checking for 'tag' set to something on maps
	(! $grep -Pn '( |\t|;|{)tag( ?)=' $map_files)
	retVal=$?
	if [ $retVal -ne 0 ]; then
		echo -e "${RED}A map has 'tag' set on an atom. It may cause problems and should be removed.${NC}"
		FAILED=1
	fi

	part "broken html"
	# echo -e "${RED}DISABLED"
	#Checking for broken HTML tags (didn't close the quote for class)
	(! $grep -Pn "<\s*span\s+class\s*=\s*('[^'>]+|[^'>]+')\s*>" $code_files)
	retVal=$?
	if [ $retVal -ne 0 ]; then
		echo -e "${RED}A broken span tag class is present (check quotes).${NC}"
		FAILED=1
	fi
else
	echo -e "${RED}pcre2 not supported, skipping checks requiring pcre2"
	echo -e "if you want to run these checks install ripgrep with pcre2 support.${NC}"
fi

if [ $FAILED = 0 ]; then
    echo
    echo -e "${GREEN}No errors found using $grep!${NC}"
else
    echo
    echo -e "${RED}Errors found, please fix them and try again.${NC}"
fi

# Quit with our status code
exit $FAILED
