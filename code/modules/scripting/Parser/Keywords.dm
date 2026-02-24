//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:33

/*
	File: Keywords
*/
#define KW_FAIL 0 //Fatal error; stop parsing entire script.
#define KW_PASS 1 //OK
#define KW_ERR  2 //Non-fatal error, keyword couldn't be handled properly. Ignore keyword but continue on.
#define KW_WARN 3 //Warning

/*
	Var: inline
	1 if the keyword is in an expression (e.g. the new keyword in many languages), 0 otherwise (such as the if and else keywords).
*/
/datum/n_Keyword
	var/inline
/datum/n_Keyword/New(inline=FALSE)
	src.inline=inline
	return ..()

/*
	Proc: Parse
	Called when the parser finds a keyword in the code.

	Parameters:
	parser - The parser that created this object. You can use the parameter to manipulate the parser in order to add statements and blocks
	to its AST.
*/
/datum/n_Keyword/proc/Parse(datum/n_Parser/parser)

/*
	Class: nS_Keyword
	A keyword in n_Script. By default these include return, if, else, while, and def. To enable or disable a keyword, change the
	<nS_Options.keywords> list.

	Behavior:
	When a parser is expecting a new statement, and a keyword listed in <nS_Options.keywords> is found, it will call the keyword's
	<n_Keyword.Parse()> proc.
*/
//
/datum/n_Keyword/nS_Keyword/New(inline=0)
	if(inline)
		qdel(src)

/datum/n_Keyword/nS_Keyword/kwReturn/Parse(datum/n_Parser/nS_Parser/parser)
	.=KW_PASS
	if(istype(parser.curBlock, /datum/node/BlockDefinition/GlobalBlock))
		parser.errors+=new/datum/scriptError/BadReturn(parser.curToken)
		. = KW_WARN
	var/datum/node/statement/ReturnStatement/stmt=new
	parser.NextToken()   //skip 'return' token
	stmt.value=parser.ParseExpression()
	parser.curBlock.statements+=stmt

/datum/n_Keyword/nS_Keyword/kwIf/Parse(datum/n_Parser/nS_Parser/parser)
	.=KW_PASS
	var/datum/node/statement/IfStatement/stmt=new
	parser.NextToken()  //skip 'if' token
	stmt.cond=parser.ParseParenExpression()
	if(!parser.CheckToken(")", /datum/token/symbol))
		return KW_FAIL
	if(!parser.CheckToken("{", /datum/token/symbol, skip=0)) //Token needs to be preserved for parse loop, so skip=0
		return KW_ERR
	parser.curBlock.statements+=stmt
	stmt.block=new
	parser.AddBlock(stmt.block)

/datum/n_Keyword/nS_Keyword/kwElse/Parse(datum/n_Parser/nS_Parser/parser)
	.=KW_PASS
	var/list/L=parser.curBlock.statements
	var/datum/node/statement/IfStatement/stmt
	if(L&&L.len) stmt=L[L.len] //Get the last statement in the current block
	if(!stmt || !istype(stmt) || stmt.else_block) //Ensure that it is an if statement
		parser.errors+=new/datum/scriptError/ExpectedToken("if statement",parser.curToken)
		return KW_FAIL
	parser.NextToken()         //skip 'else' token
	if(!parser.CheckToken("{", /datum/token/symbol, skip=0))
		return KW_ERR
	stmt.else_block=new()
	parser.AddBlock(stmt.else_block)

/datum/n_Keyword/nS_Keyword/kwWhile/Parse(datum/n_Parser/nS_Parser/parser)
	.=KW_PASS
	var/datum/node/statement/WhileLoop/stmt=new
	parser.NextToken()  //skip 'while' token
	stmt.cond=parser.ParseParenExpression()
	if(!parser.CheckToken(")", /datum/token/symbol))
		return KW_FAIL
	if(!parser.CheckToken("{", /datum/token/symbol, skip=0))
		return KW_ERR
	parser.curBlock.statements+=stmt
	stmt.block=new
	parser.AddBlock(stmt.block)

/datum/n_Keyword/nS_Keyword/kwBreak/Parse(datum/n_Parser/nS_Parser/parser)
	.=KW_PASS
	if(istype(parser.curBlock, /datum/node/BlockDefinition/GlobalBlock))
		parser.errors+=new/datum/scriptError/BadToken(parser.curToken)
		. = KW_WARN
	var/datum/node/statement/BreakStatement/stmt=new
	parser.NextToken()   //skip 'break' token
	parser.curBlock.statements+=stmt

/datum/n_Keyword/nS_Keyword/kwContinue/Parse(datum/n_Parser/nS_Parser/parser)
	.=KW_PASS
	if(istype(parser.curBlock, /datum/node/BlockDefinition/GlobalBlock))
		parser.errors+=new/datum/scriptError/BadToken(parser.curToken)
		. = KW_WARN
	var/datum/node/statement/ContinueStatement/stmt=new
	parser.NextToken()   //skip 'break' token
	parser.curBlock.statements+=stmt

/datum/n_Keyword/nS_Keyword/kwDef/Parse(datum/n_Parser/nS_Parser/parser)
	.=KW_PASS
	var/datum/node/statement/FunctionDefinition/def=new
	parser.NextToken() //skip 'def' token
	if(!parser.options.IsValidID(parser.curToken.value))
		parser.errors+=new/datum/scriptError/InvalidID(parser.curToken)
		return KW_FAIL
	def.func_name=parser.curToken.value
	parser.NextToken()
	if(!parser.CheckToken("(", /datum/token/symbol))
		return KW_FAIL
	while(TRUE) //for now parameters can be separated by whitespace - they don't need a comma in between
		if(istype(parser.curToken, /datum/token/symbol))
			switch(parser.curToken.value)
				if(",")
					parser.NextToken()
				if(")")
					break
				else
					parser.errors+=new/datum/scriptError/BadToken(parser.curToken)
					return KW_ERR

		else if(istype(parser.curToken, /datum/token/word))
			def.parameters+=parser.curToken.value
			parser.NextToken()
		else
			parser.errors+=new/datum/scriptError/InvalidID(parser.curToken)
			return KW_ERR
	if(!parser.CheckToken(")", /datum/token/symbol))
		return KW_FAIL

	if(istype(parser.curToken, /datum/token/end)) //Function prototype
		parser.curBlock.statements+=def
	else if(parser.curToken.value=="{" && istype(parser.curToken, /datum/token/symbol))
		def.block = new
		parser.curBlock.statements+=def
		parser.curBlock.functions[def.func_name]=def
		parser.AddBlock(def.block)
	else
		parser.errors+=new/datum/scriptError/BadToken(parser.curToken)
		return KW_FAIL

#undef KW_FAIL
#undef KW_PASS
#undef KW_ERR
#undef KW_WARN
