//not macros in the traditional sense. these are aliases that're stored on a node. super simple stuff, name = "command goes here". there's no validity checking or anything.
/datum/commandline_network_command/event
	name = "event"

/datum/commandline_network_command/macro/getHelpText(datum/commandline_network_node/homenode, arguments, verbose, direct)
	if(direct)
		return {"Defines and manages a node's command macros: shorthand aliases for longer commands.
Syntax: >event add|remove alias ">command here"
- Macros simplify command usage and can be referenced in commands from this node.
- Double quotes are required around the full command to ensure proper parsing.
- add requires both an alias and a full command; remove needs only the alias.
"}
	if(verbose)
		return "Lets you create or remove shorthand macros that map to full commands. Used in UI and CLI from this node. Quotes around the full command are mandatory. ae: \">command here \"."

	return "Creates or deletes aliases that represent larger commands."

/datum/commandline_network_command/macro/runCommand(datum/commandline_network_node/source, datum/commandline_network_node/from, list/sorted_tokens, datum/commandline_log_entry/logs, verbose)
	if(!from)
		if(source) //gulp!
			logs.set_log(source,COMMAND_RESULT_MISSING_NODE,COMMAND_OUTPUT_ERROR)

	var/list/arguments = LAZYACCESS(sorted_tokens,COMMAND_ARGUMENT_ARGUMENTS)
	var/action = arguments[1] //first argument is expected to be add/remove/clear
	if(action == "clear")
		logs.set_log(from,"cleared macros on [from.name].")
		from.macros = list()
		return

	if(!(action in list("add", "remove")))
		logs.set_log(from,"Err: invalid argument [action] provided, valid: add, remove, clear",COMMAND_OUTPUT_ERROR)
		return

	// add alias "command here "

	var/total_args = arguments.len
	if((total_args < 2) && action == "remove") //we at minimum need an action (add, remove) and a target for those actions.
		logs.set_log(from,"Err: Insufficient arguments provided for removal. Required: action, alias",COMMAND_OUTPUT_ERROR)
		return

	var/alias = arguments[2]
	if(action == "remove")
		if(alias in from.macros)
			from.macros.Remove(alias)
			logs.set_log(from,"Macro [alias] successfully removed from [from.name] macro registry")


	if((total_args < 3) && action == "add") //adding needs an action, alias, and a command
		logs.set_log(from,"Err: Insufficent arguments provided for macro addition. Required: action, alias, command",COMMAND_OUTPUT_ERROR)
		return

	var/content = arguments[3]
	if(action == "add")
		logs.set_log(from,"Macro [alias] with command [content] has been added to the [from.name] macro registry")
		from.macros[alias] = content
		return


/*
>target event add "nameofevent" "command" "condition" //conditions aren't always used
>target event remove "nameofevent" index //index is optional, if not provided remove the latest one
>target event list "nameofevent"
>target event clear
*/
