/*
	File: AST Nodes
	An abstract syntax tree (AST) is a representation of source code in a computer-friendly format. It is composed of nodes,
	each of which represents a certain part of the source code. For example, an <IfStatement> node represents an if statement in the
	script's source code. Because it is a representation of the source code in memory, it is independent of any specific scripting language.
	This allows a script in any language for which a parser exists to be run by the interpreter.

	The AST is produced by an <n_Parser> object. It consists of a <GlobalBlock> with an arbitrary amount of statements. These statements are
	run in order by an <n_Interpreter> object. A statement may in turn run another block (such as an if statement might if its condition is
	met).

	Articles:
	- <http://en.wikipedia.org/wiki/Abstract_syntax_tree>
*/
var
	const
/*
	Constants: Operator Precedence
	OOP_OR				- Logical or
	OOP_AND				- Logical and
	OOP_BIT				- Bitwise operations
	OOP_EQUAL			- Equality checks
	OOP_COMPARE		- Greater than, less then, etc
	OOP_ADD				- Addition and subtraction
	OOP_MULTIPLY	- Multiplication and division
	OOP_POW				- Exponents
	OOP_UNARY			- Unary Operators
	OOP_GROUP			- Parentheses
*/
		OOP_OR      = 							1   //||
		OOP_AND     = OOP_OR			+ 1   	//&&
		OOP_BIT     = OOP_AND			+ 1   //&, |
		OOP_EQUAL   = OOP_BIT			+ 1   //==, !=
		OOP_COMPARE = OOP_EQUAL		+ 1   //>, <, >=, <=
		OOP_ADD     = OOP_COMPARE	+ 1 	//+, -
		OOP_MULTIPLY= OOP_ADD			+ 1   //*, /, %
		OOP_POW     = OOP_MULTIPLY+ 1		//^
		OOP_UNARY   = OOP_POW			+ 1   //!
		OOP_GROUP   = OOP_UNARY		+ 1   //()

/*
	Class: node
*/
/node/proc/ToString()
	return "[src.type]"
/*
	Class: identifier
*/
/node/identifier
	var/id_name

/node/identifier/New(id)
	.=..()
	src.id_name=id

/node/identifier/ToString()
	return id_name

/*
	Class: expression
*/
/node/expression
/*
	Class: operator
	See <Binary Operators> and <Unary Operators> for subtypes.
*/
/node/expression/op
	var/node/expression/exp
	var/tmp/name
	var/tmp/precedence

/node/expression/op/New()
	.=..()
	if(!src.name) src.name="[src.type]"

/node/expression/op/ToString()
	return "operator: [name]"

/*
	Class: FunctionCall
*/
/node/expression/FunctionCall
	//Function calls can also be expressions or statements.
	var/func_name
	var/node/identifier/object
	var/list/parameters = list()

/*
	Class: literal
*/
/node/expression/value/literal
	var/value

/node/expression/value/literal/New(value)
	.=..()
	src.value=value

/node/expression/value/literal/ToString()
	return src.value

/*
	Class: variable
*/
/node/expression/value/variable
	var/node/object		//Either a node/identifier or another node/expression/value/variable which points to the object
	var/node/identifier/id


/node/expression/value/variable/New(ident)
	.=..()
	id=ident
	if(istext(id))id=new(id)

/node/expression/value/variable/ToString()
	return src.id.ToString()

/*
	Class: reference
*/
/node/expression/value/reference
	var/datum/value

/node/expression/value/reference/New(value)
	.=..()
	src.value=value

/node/expression/value/reference/ToString()
	return "ref: [src.value] ([src.value.type])"
