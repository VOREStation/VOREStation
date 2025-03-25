#!/bin/bash
set -euo pipefail

# nb: must be bash to support shopt globstar
shopt -s globstar extglob

source dependencies.sh

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
	code_x_515="code/**/!(__byond_version_compat).dm"
else
	pcre2_support=0
	grep=grep
	code_files="-r --include=code/**/**.dm"
	map_files="-r --include=maps/**/**.dmm"
	# shuttle_map_files="-r --include=_maps/shuttles/**.dmm"
	code_x_515="-r --include=code/**/!(__byond_version_compat).dm"
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

part "TGM"
if grep -El '^\".+\" = \(.+\)' $map_files;	then
	echo
	echo -e "${RED}ERROR: Non-TGM formatted map detected. Please convert it using Map Merger!${NC}"
	FAILED=1
fi;

part "iconstate tags"
if grep -P '^\ttag = \"icon' $map_files;	then
	echo
	echo -e "${RED}ERROR: tag vars from icon state generation detected in maps, please remove them.${NC}"
	FAILED=1
fi;

part "step_[xy]"
#Checking for step_x/step_y defined in any maps anywhere.
(! $grep 'step_[xy]' $map_files)
retVal=$?
if [ $retVal -ne 0 ]; then
	echo -e "${RED}The variables 'step_x' and 'step_y' are present on a map, and they 'break' movement ingame.${NC}"
	FAILED=1
fi

part "wrongly offset APCs"
if grep -Pzo '/obj/structure/machinery/power/apc[/\w]*?\{\n[^}]*?pixel_[xy] = -?[013-9]\d*?[^\d]*?\s*?\},?\n' $map_files ||
	grep -Pzo '/obj/structure/machinery/power/apc[/\w]*?\{\n[^}]*?pixel_[xy] = -?\d+?[0-46-9][^\d]*?\s*?\},?\n' $map_files ||
	grep -Pzo '/obj/structure/machinery/power/apc[/\w]*?\{\n[^}]*?pixel_[xy] = -?\d{3,1000}[^\d]*?\s*?\},?\n' $map_files ;	then
	echo -e "${RED}ERROR: found an APC with a manually set pixel_x or pixel_y that is not +-25.${NC}"
	FAILED=1
fi;

part "vareditted areas"
if grep -P '^/area/.+[\{]' $map_files;	then
	echo -e "${RED}ERROR: Vareditted /area path use detected in maps, please replace with proper paths.${NC}"
	FAILED=1
fi;

part "base /turf usage"
if grep -P '\W\/turf\s*[,\){]' $map_files; then
	echo
	echo -e "${RED}ERROR: base /turf path use detected in maps, please replace with proper paths.${NC}"
	FAILED=1
fi;

part "test map included"
#Checking for any 'checked' maps that include 'test'
(! $grep 'maps\\.*test.*' *.dme)
retVal=$?
if [ $retVal -ne 0 ]; then
	echo -e "${RED}A map containing the word 'test' is included. This is not allowed to be committed.${NC}"
	FAILED=1
fi

section "code issues"

#part "indentation"
#echo -e "${RED}DISABLED"
#Check for weird indentation in any .dm files
# awk -f tools/indentation.awk $code_files
# retVal=$?
# if [ $retVal -ne 0 ]; then
#	 echo -e "${RED}Indention testing failed. Please see results and fix indentation.${NC}"
#	 FAILED=1
# fi

part "mixed tab/space indentation"
if grep -P '^\t+ [^ *]' $code_files; then
	echo
	echo -e "${RED}ERROR: mixed <tab><space> indentation detected.${NC}"
	FAILED=1
fi;

part "improperly pathed static lists"
if $grep -i 'var/list/static/.*' $code_files; then
	echo
	echo -e "${RED}ERROR: Found incorrect static list definition 'var/list/static/', it should be 'var/static/list/' instead.${NC}"
	st=1
fi;

part "changelog"
#Checking for a change to html/changelogs/example.yml
md5sum -c - <<< "0c56937110d88f750a32d9075ddaab8b *html/changelogs/example.yml"
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

part "typescript react files"
if ls -1 tgui/**/*.jsx 2>/dev/null; then
	echo
	echo -e "${RED}ERROR: JSX file(s) detected, these must be converted to typescript (TSX).${NC}"
	FAILED=1
fi;

part "balloon_alert sanity"
if $grep 'balloon_alert\(".*"\)' $code_files; then
	echo
	echo -e "${RED}ERROR: Found a balloon alert with improper arguments.${NC}"
	FAILED=1
fi;

if $grep 'balloon_alert(.*span_)' $code_files; then
	echo
	echo -e "${RED}ERROR: Balloon alerts should never contain spans.${NC}"
	FAILED=1
fi;

part "balloon_alert idiomatic usage"
if $grep 'balloon_alert\(.*?, ?"[A-Z]' $code_files; then
	echo
	echo -e "${RED}ERROR: Balloon alerts should not start with capital letters. This includes text like 'AI'. If this is a false positive, wrap the text in UNLINT().${NC}"
	FAILED=1
fi;

part ".proc ref syntax"
if $grep '\.proc/' $code_x_515 ; then
	echo
	echo -e "${RED}ERROR: Outdated proc reference use detected in code, please use proc reference helpers.${NC}"
	FAILED=1
fi;

part "ambiguous bitwise or"
if grep -P '^(?:[^\/\n]|\/[^\/\n])*(&[ \t]*\w+[ \t]*\|[ \t]*\w+)' $code_files; then
	echo
	echo -e "${RED}ERROR: Likely operator order mistake with bitwise OR. Use parentheses to specify intention.${NC}"
	FAILED=1
fi;

part "html tag matching"
#Checking for missed tags
python tools/TagMatcher/tag-matcher.py ../..
retVal=$?
if [ $retVal -ne 0 ]; then
	echo -e "${RED}Some HTML tags are missing their opening/closing partners. Please correct this.${NC}"
	FAILED=1
fi

part "proc ref syntax"
if $grep '\.proc/' $code_x_515 ; then
    echo
    echo -e "${RED}ERROR: Outdated proc reference use detected in code, please use proc reference helpers.${NC}"
    FAILED=1
fi;

part "ambiguous bitwise or"
if grep -P '^(?:[^\/\n]|\/[^\/\n])*(&[ \t]*\w+[ \t]*\|[ \t]*\w+)' $code_files; then
	echo
	echo -e "${RED}ERROR: Likely operator order mistake with bitwise OR. Use parentheses to specify intention.${NC}"
	FAILED=1
fi;

if [ "$pcre2_support" -eq 1 ]; then
	section "regexes requiring PCRE2"

	part "empty variable values"
	if $grep -PU '{\n\t},' $map_files; then
		echo
		echo -e "${RED}ERROR: Empty variable value list detected in map file. Please remove the curly brackets entirely.${NC}"
		FAILED=1
	fi;

	part "to_chat sanity"
	if $grep -P 'to_chat\((?!.*,).*\)' $code_files; then
		echo
		echo -e "${RED}ERROR: to_chat() missing arguments.${NC}"
		FAILED=1
	fi;

	part "timer flag sanity"
	if $grep -P 'addtimer\((?=.*TIMER_OVERRIDE)(?!.*TIMER_UNIQUE).*\)' $code_files; then
		echo
		echo -e "${RED}ERROR: TIMER_OVERRIDE used without TIMER_UNIQUE.${NC}"
		FAILED=1
	fi

	part "trailing newlines"
	if $grep -PU '[^\n]$(?!\n)' $code_files; then
		echo
		echo -e "${RED}ERROR: File(s) with no trailing newline detected, please add one.${NC}"
		FAILED=1
	fi

	part "improper atom initialize args"
	if $grep -P '^/(obj|mob|turf|area|atom)/.+/Initialize\((?!mapload).*\)' $code_files; then
		echo
		echo -e "${RED}ERROR: Initialize override without 'mapload' argument.${NC}"
		FAILED=1
	fi;

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

	part "old style hrefs"
	(! $grep -Pn "href[\s='\"\\ ]*\?" $code_files)
	retVal=$?
	if [ $retVal -ne 0 ]; then
		echo -e "${RED}old-style hrefs detected, see ripgrep output.${NC}"
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
