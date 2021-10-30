/*
	Class: scope
	A runtime instance of a block. Used internally by the interpreter.
*/
/scope/
	var/scope/parent = null
	var/node/BlockDefinition/block
	var/list/functions
	var/list/variables

/scope/New(node/BlockDefinition/B, scope/parent)
	src.block = B
	src.parent = parent
	src.variables = B.initial_variables.Copy()
	src.functions = B.functions.Copy()
	.=..()