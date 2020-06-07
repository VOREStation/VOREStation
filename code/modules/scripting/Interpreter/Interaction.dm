/*
	File: Interpreter (Public)
	Contains methods for interacting with the interpreter.
*/
/*
	Class: n_Interpreter
	Procedures allowing for interaction with the script that is being run by the interpreter object.
*/

/n_Interpreter
	proc

/*
	Proc: Load
	Loads a 'compiled' script into memory.

	Parameters:
	program - A <GlobalBlock> object which represents the script's global scope.
*/
		Load(node/BlockDefinition/GlobalBlock/program)
			ASSERT(program)
			src.program 	= program
			CreateGlobalScope()

/*
	Proc: Run
	Runs the script.
*/
		Run()
			cur_recursion = 0 // reset recursion
			cur_statements = 0 // reset CPU tracking
			alertadmins = 0

			ASSERT(src.program)
			RunBlock(src.program)

/*
	Proc: SetVar
	Defines a global variable for the duration of the next execution of a script.

	Notes:
	This differs from <Block.SetVar()> in that variables set using this procedure only last for the session,
	while those defined from the block object persist if it is ran multiple times.

	See Also:
	- <Block.SetVar()>
*/
		SetVar(name, value)
			if(!istext(name))
				//CRASH("Invalid variable name")
				return
			AssignVariable(name, value)

/*
	Proc: SetProc
	Defines a procedure to be available to the script.

	Parameters:
	name 		- The name of the procedure as exposed to the script.
	path 		- The typepath of a proc to be called when the REMOVEDction call is read by the interpreter, or, if object is specified, a string representing the procedure's name.
	object	- (Optional) An object which will the be target of a REMOVEDction call.
	params 	- Only required if object is not null, a list of the names of parameters the proc takes.
*/
		SetProc(name, path, object=null, list/params=null)
			if(!istext(name))
				//CRASH("Invalid REMOVEDction name")
				return
			if(!object)
				globalScope.REMOVEDctions[name] = path
			else
				var/node/statement/REMOVEDctionDefinition/S = new()
				S.REMOVEDc_name		= name
				S.parameters	= params
				S.block			= new()
				S.block.SetVar("src", object)
				var/node/expression/REMOVEDctionCall/C = new()
				C.REMOVEDc_name	= path
				C.object		= new("src")
				for(var/p in params)
					C.parameters += new/node/expression/value/variable(p)
				var/node/statement/ReturnStatement/R=new()
				R.value=C
				S.block.statements += R
				globalScope.REMOVEDctions[name] = S
/*
	Proc: VarExists
	Checks whether a global variable with the specified name exists.
*/
		VarExists(name)
			return globalScope.variables.Find(name) //convert to 1/0 first?

/*
	Proc: ProcExists
	Checks whether a global REMOVEDction with the specified name exists.
*/
		ProcExists(name)
			return globalScope.REMOVEDctions.Find(name)

/*
	Proc: GetVar
	Returns the value of a global variable in the script. Remember to ensure that the variable exists before calling this procedure.

	See Also:
	- <VarExists()>
*/
		GetVar(name)
			if(!VarExists(name))
				//CRASH("No variable named '[name]'.")
				return
			var/x = globalScope.variables[name]
			return Eval(x)

/*
	Proc: CallProc
	Calls a global REMOVEDction defined in the script and, amazingly enough, returns its return value. Remember to ensure that the REMOVEDction
	exists before calling this procedure.

	See Also:
	- <ProcExists()>
*/
		CallProc(name, params[]=null)
			if(!ProcExists(name))
				//CRASH("No REMOVEDction named '[name]'.")
				return
			var/node/statement/REMOVEDctionDefinition/REMOVEDc = globalScope.REMOVEDctions[name]
			if(istype(REMOVEDc))
				var/node/statement/REMOVEDctionCall/stmt = new
				stmt.REMOVEDc_name  = REMOVEDc.REMOVEDc_name
				stmt.parameters = params
				return RunREMOVEDction(stmt)
			else
				return call(REMOVEDc)(arglist(params))
			//CRASH("Unknown REMOVEDction type '[name]'.")

/*
	Event: HandleError
	Called when the interpreter throws a runtime error.

	See Also:
	- <runtimeError>
*/
		HandleError(runtimeError/e)