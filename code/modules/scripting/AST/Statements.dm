/*
	File: Statement Types
*/
/*
	Class: statement
	An object representing a single instruction run by an interpreter.
*/
/node/statement
/*
	Class: FunctionCall
	Represents a call to a function.
*/
//
/node/statement/FunctionCall
	var/func_name
	var/node/identifier/object
	var/list/parameters=list()

/*
	Class: FunctionDefinition
	Defines a function.
*/
//
/node/statement/FunctionDefinition
	var/func_name
	var/list/parameters=list()
	var/node/BlockDefinition/FunctionBlock/block

/*
	Class: VariableAssignment
	Sets a variable in an accessible scope to the given value if one exists, otherwise initializes a new local variable to the given value.

	Notes:
	If a variable with the same name exists in a higher block, the value will be assigned to it. If not,
	a new variable is created in the current block. To force creation of a new variable, use <VariableDeclaration>.

	See Also:
	- <VariableDeclaration>
*/
//
/node/statement/VariableAssignment
	var/node/identifier/object
	var/node/identifier/var_name
	var/node/expression/value

/*
	Class: VariableDeclaration
	Intializes a local variable to a null value.

	See Also:
	- <VariableAssignment>
*/
//
/node/statement/VariableDeclaration
	var/node/identifier/object
	var/node/identifier/var_name

/*
	Class: IfStatement
*/
//
/node/statement/IfStatement
	var/node/BlockDefinition/block
	var/node/BlockDefinition/else_block // may be null
	var/node/expression/cond

/*
	Class: WhileLoop
	Loops while a given condition is true.
*/
//
/node/statement/WhileLoop
	var/node/BlockDefinition/block
	var/node/expression/cond

/*
	Class: ForLoop
	Loops while test is true, initializing a variable, increasing the variable
*/
/node/statement/ForLoop
	var/node/BlockDefinition/block
	var/node/expression/test
	var/node/expression/init
	var/node/expression/increment

/*
	Class: BreakStatement
	Ends a loop.
*/
//
/node/statement/BreakStatement

/*
	Class: ContinueStatement
	Skips to the next iteration of a loop.
*/
//
/node/statement/ContinueStatement

/*
	Class: ReturnStatement
	Ends the function and returns a value.
*/
//
/node/statement/ReturnStatement
	var/node/expression/value
