//not macros in the traditional sense. these are aliases that're stored on a node. super simple stuff, name = "command goes here". there's no validity checking or anything.
/datum/commandline_network_command/macro
	name = "macro"

/datum/commandline_network_command/macro/Initialize()
	. = ..()
	dispatch_table = list()
	COMMAND_ACTION_DEFINE("clear",clear,0)
	COMMAND_ACTION_DEFINE("add",add,3)
	COMMAND_ACTION_DEFINE("remove",remove,2)

/datum/commandline_network_command/macro/proc/clear(COMMAND_ACTION_PARAMS)
	logs.set_log(from,"cleared macros on [from.name].")
	from.macros = list()
	return

/datum/commandline_network_command/macro/proc/add(COMMAND_ACTION_PARAMS)
	var/list/arguments = LAZYACCESS(sorted_tokens,COMMAND_ARGUMENT_ARGUMENTS)
	var/alias = arguments[2]
	var/content = arguments[3]
	logs.set_log(from,"Macro [alias] with command [content] has been added to the [from.name] macro registry.")
	from.macros[alias] = content
	return

/datum/commandline_network_command/macro/proc/remove(COMMAND_ACTION_PARAMS)
	var/list/arguments = LAZYACCESS(sorted_tokens,COMMAND_ARGUMENT_ARGUMENTS)
	var/alias = arguments[2]
	if(alias in from.macros)
		from.macros.Remove(alias)
		logs.set_log(from,"Macro [alias] successfully removed from [from.name] macro registry.")
	else
		logs.set_log(from,"Err: Unable to remove macro from [from.name]: Alias [alias] does not exist.", COMMAND_OUTPUT_ERROR)

/datum/commandline_network_command/macro/getHelpText(datum/commandline_network_node/homenode, arguments, verbose, direct)
	if(direct)
		return {"Defines and manages a node's command macros: shorthand aliases for longer commands.
Syntax: >macro add|remove alias ">command here"
- Macros simplify command usage and can be referenced in commands from this node.
- Double quotes are required around the full command to ensure proper parsing.
- add requires both an alias and a full command; remove needs only the alias.
"}
	if(verbose)
		return "Lets you create or remove shorthand macros that map to full commands. Used in UI and CLI from this node. Quotes around the full command are mandatory. ae: \">command here \"."

	return "Creates or deletes aliases that represent larger commands."
