//like the other core commands, this one is on EVERY* Node. the help command essentially just:
// * Lists every alias in the node
// * if Verbose (determined via targetting, more than 1 = nonverbose) lists a brief primer of what it is

/datum/commandline_network_command/help
	name = "help"

/datum/commandline_network_command/help/Initialize()
	. = ..()
	standalone = COMMAND_STANDALONE_ACTION_DEFINE(getHelp,0)

/datum/commandline_network_command/help/proc/getHelp(COMMAND_ACTION_PARAMS)
	var/response = "Documentation for Network Node \"[from]\": \n" //TODO
	var/list/arguments = LAZYACCESS(sorted_tokens,COMMAND_ARGUMENT_ARGUMENTS)
	if(arguments.len >= 1) //we assume that the arguments are noted
		var/targetted_command = arguments[1]
		if(targetted_command in from.commands)
			var/datum/commandline_network_command/command = SScommandline_networks.GetCachedCommand(from.commands[targetted_command])
			response = command.getHelpText(from,sorted_tokens,arguments[COMMAND_ARGUMENT_COMMAND],FALSE,TRUE,FALSE)
			logs.set_log(source,response)
			return
		else
			logs.set_log(source,"Err: Command [targetted_command] not found in [from].",COMMAND_OUTPUT_ERROR)
			return
	if(from.desc && (verbose && !from.desc_verbose))
		response += from.desc + "\n\n"
	//default to verbose if there's no desc on the node
	if(from.desc_verbose && (verbose || !from.desc))
		response += from.desc_verbose + "\n\n"

	for(var/commandalias in from.commands)
		var/datum/commandline_network_command/command = SScommandline_networks.GetCachedCommand(from.commands[commandalias])
		if(command) //(var/datum/commandline_network_node/homenode,var/list/tokens, var/alias_used, var/verbose = FALSE, var/direct = FALSE, var/usage = FALSE)
			response += "[commandalias]: [command.getHelpText(from,sorted_tokens,arguments[COMMAND_ARGUMENT_COMMAND],verbose,FALSE,FALSE)] \n\n"
	logs.set_log(source,response)


/datum/commandline_network_command/help/getHelpText(homenode,arguments,alias_used,verbose,direct,usage)
	var/usage_example = "usage: >target [alias_used] command --verbose, where command and --verbose are optional."

	if(direct)
		return {"retrieves information about a node (if avaliable) and the commands attached to it.
		[usage_example]

when a command is provided and is on the node, it will provide more detailed information than \"verbose\" (but no other information), whereas
when \"verbose\" is provided as a flag, it shows all commands more detailed than the overview it gives when the flag is not provided."}

	if(verbose)
		return {"Displays help for a target node.
Without arguments, shows brief summaries of each command.
[usage_example]
Use --verbose to expand all descriptions. Supplying a specific command shows detailed info for that command alone.
"}
	if(usage)
		return usage_example

	return "Shows help info for target node & its commands. Use --verbose for detailed output or specify a command for focused help."

/*
//getHelpText

Direct -
	Help:
	This is a command that shows you information regarding a node and its availible commands.
	Syntax: >target help alias--v
	--v, if provided, forces all commands on the node to provide the full text.
	alias, if provided, only shows information regarding a specific command on the node, and shows it as verbose.

Verbose:
	Help: Show Detailed Command & Node Information. Usage: >target help alias(optional) --v(optional). Ex: >< help help -v

NonVerbose

	Help: Show Node/Command Info


*/
