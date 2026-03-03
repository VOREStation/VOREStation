/*
File: Options
*/
//Ascii values of characters
#define ASCII_A 65
#define ASCII_Z 90
#define ASCII_LOWER_A 97
#define ASCII_LOWER_Z 122
#define ASCII_DOLLAR 36 // $
#define ASCII_ZERO 48
#define ASCII_NINE 57
#define ASCII_UNDERSCORE 95	// _

/*
	Class: n_scriptOptions
*/
/datum/n_scriptOptions/proc/CanStartID(char) //returns true if the character can start a variable, function, or keyword name (by default letters or an underscore)
	if(!isnum(char))char=text2ascii(char)
	return (char in ASCII_A to ASCII_Z) || (char in ASCII_LOWER_A to ASCII_LOWER_Z) || char==ASCII_UNDERSCORE || char==ASCII_DOLLAR

/datum/n_scriptOptions/proc/IsValidIDChar(char) //returns true if the character can be in the body of a variable, function, or keyword name (by default letters, numbers, and underscore)
	if(!isnum(char))char=text2ascii(char)
	return CanStartID(char) || IsDigit(char)

/datum/n_scriptOptions/proc/IsDigit(char)
	if(!isnum(char))char=text2ascii(char)
	return char in ASCII_ZERO to ASCII_NINE

/datum/n_scriptOptions/proc/IsValidID(id)    //returns true if all the characters in the string are okay to be in an identifier name
	if(!CanStartID(id)) //don't need to grab first char in id, since text2ascii does it automatically
		return 0
	if(length(id)==1) return 1
	for(var/i=2 to length(id))
		if(!IsValidIDChar(copytext(id, i, i+1)))
			return 0
	return 1

/*
	Class: nS_Options
	An implementation of <n_scriptOptions> for the n_Script language.
*/
/datum/n_scriptOptions/nS_Options
	var/list/symbols  		= list("(", ")", "\[", "]", ";", ",", "{", "}")     										//scanner - Characters that can be in symbols
/*
Var: keywords
An associative list used by the parser to parse keywords. Indices are strings which will trigger the keyword when parsed and the
associated values are <nS_Keyword> types of which the <n_Keyword.Parse()> proc will be called.
*/
	var/list/keywords = list(
		"if"		= /datum/n_Keyword/nS_Keyword/kwIf,
		"else"		= /datum/n_Keyword/nS_Keyword/kwElse,
		"while"		= /datum/n_Keyword/nS_Keyword/kwWhile,
		"break"		= /datum/n_Keyword/nS_Keyword/kwBreak,
		"continue"	= /datum/n_Keyword/nS_Keyword/kwContinue,
		"return"	= /datum/n_Keyword/nS_Keyword/kwReturn,
		"def"		= /datum/n_Keyword/nS_Keyword/kwDef
	)

	var/list/assign_operators = list(
		"="  = null,
		"&=" = "&",
		"|=" = "|",
		"`=" = "`",
		"+=" = "+",
		"-=" = "-",
		"*=" = "*",
		"/=" = "/",
		"^=" = "^",
		"%=" = "%"
	)

	var/list/unary_operators =list(
		"!"  = /datum/node/expression/op/unary/LogicalNot,
		"~"  = /datum/node/expression/op/unary/BitwiseNot,
		"-"  = /datum/node/expression/op/unary/Minus
	)

	var/list/binary_operators=list(
		"=="	= /datum/node/expression/op/binary/Equal,
		"!="	= /datum/node/expression/op/binary/NotEqual,
		">"		= /datum/node/expression/op/binary/Greater,
		"<"		= /datum/node/expression/op/binary/Less,
		">="	= /datum/node/expression/op/binary/GreaterOrEqual,
		"<="	= /datum/node/expression/op/binary/LessOrEqual,
		"&&"	= /datum/node/expression/op/binary/LogicalAnd,
		"||"	= /datum/node/expression/op/binary/LogicalOr,
		"&"		= /datum/node/expression/op/binary/BitwiseAnd,
		"|"		= /datum/node/expression/op/binary/BitwiseOr,
		"`"		= /datum/node/expression/op/binary/BitwiseXor,
		"+"		= /datum/node/expression/op/binary/Add,
		"-"		= /datum/node/expression/op/binary/Subtract,
		"*"		= /datum/node/expression/op/binary/Multiply,
		"/"		= /datum/node/expression/op/binary/Divide,
		"^"		= /datum/node/expression/op/binary/Power,
		"%"		= /datum/node/expression/op/binary/Modulo)

/datum/n_scriptOptions/nS_Options/New()
	.=..()
	for(var/O in assign_operators+binary_operators+unary_operators)
		if(!symbols.Find(O)) symbols+=O

#undef ASCII_A
#undef ASCII_Z
#undef ASCII_LOWER_A
#undef ASCII_LOWER_Z
#undef ASCII_DOLLAR
#undef ASCII_ZERO
#undef ASCII_NINE
#undef ASCII_UNDERSCORE
