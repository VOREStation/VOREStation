/*
	File: Errors
*/
/*
	Class: scriptError
	An error scanning or parsing the source code.
*/
/scriptError
	var/message /// A message describing the problem.
/scriptError/New(msg=null)
	if(msg)message=msg

/scriptError/BadToken
	message="Unexpected token: "
	var/token/token
/scriptError/BadToken/New(token/t)
	token=t
	if(t&&t.line) message="[t.line]: [message]"
	if(istype(t))message+="[t.value]"
	else message+="[t]"

/scriptError/InvalidID
	parent_type=/scriptError/BadToken
	message="Invalid identifier name: "

/scriptError/ReservedWord
	parent_type=/scriptError/BadToken
	message="Identifer using reserved word: "

/scriptError/BadNumber
	parent_type=/scriptError/BadToken
	message = "Bad number: "

/scriptError/BadReturn
	var/token/token
	message = "Unexpected return statement outside of a function."
/scriptError/BadReturn/New(token/t)
	src.token=t

/scriptError/EndOfFile
	message = "Unexpected end of file."

/scriptError/ExpectedToken
	message="Expected: '"
/scriptError/ExpectedToken/New(id, token/T)
	if(T && T.line) message="[T.line]: [message]"
	message+="[id]'. "
	if(T)message+="Found '[T.value]'."


/scriptError/UnterminatedComment
	message="Unterminated multi-line comment statement: expected */"

/scriptError/DuplicateFunction
	message="Function defined twice."
/scriptError/DuplicateFunction/New(name, token/t)
	message="Function '[name]' defined twice."

/*
	Class: runtimeError
	An error thrown by the interpreter in running the script.
*/
/runtimeError
	var/name
	var/message /// A basic description as to what went wrong.
	var/stack/stack

/**
 * Proc: ToString
 * Returns a description of the error suitable for showing to the user.
 */
/runtimeError/proc/ToString()
	. = "[name]: [message]"
	if(!stack.Top()) return
	.+="\nStack:"
	while(stack.Top())
		var/node/statement/FunctionCall/stmt=stack.Pop()
		. += "\n\t [stmt.func_name]()"

/runtimeError/TypeMismatch
	name="TypeMismatchError"
/runtimeError/TypeMismatch/New(op, a, b)
	message="Type mismatch: '[a]' [op] '[b]'"

/runtimeError/UnexpectedReturn
	name="UnexpectedReturnError"
	message="Unexpected return statement."

/runtimeError/UnknownInstruction
	name="UnknownInstructionError"
	message="Unknown instruction type. This may be due to incompatible compiler and interpreter versions or a lack of implementation."

/runtimeError/UndefinedVariable
	name="UndefinedVariableError"
/runtimeError/UndefinedVariable/New(variable)
	message="Variable '[variable]' has not been declared."

/runtimeError/UndefinedFunction
	name="UndefinedFunctionError"
/runtimeError/UndefinedFunction/New(function)
	message="Function '[function]()' has not been defined."

/runtimeError/DuplicateVariableDeclaration
	name="DuplicateVariableError"
/runtimeError/DuplicateVariableDeclaration/New(variable)
	message="Variable '[variable]' was already declared."

/runtimeError/IterationLimitReached
	name="MaxIterationError"
	message="A loop has reached its maximum number of iterations."

/runtimeError/RecursionLimitReached
	name="MaxRecursionError"
	message="The maximum amount of recursion has been reached."

/runtimeError/DivisionByZero
	name="DivideByZeroError"
	message="Division by zero attempted."

/runtimeError/MaxCPU
	name="MaxComputationalUse"
	message="Maximum amount of computational cycles reached (>= 1000)."
