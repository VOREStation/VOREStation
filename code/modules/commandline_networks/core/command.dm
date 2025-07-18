//commands are static & instantiated once by the subsystem
/datum/commandline_network_command
	var/name = "unnamed command"

	//command "actions" (ae, first arg) to table. Configure using COMMAND_ACTION_DEFINE on init
	var/list/dispatch_table

	//if we have this we'll always call it and not check the dispatch table, this is for commands that don't have actions (actions being stuff like macro add|remove|etc)
	var/datum/callback/standalone //define this in init if we are a "standalone" command with no actions, or a singular action that doesn't
	var/min_args_standalone = 1 //change this to reflect any standalone def
	var/no_args_return_log = 0 //1 = show usage on no args, 2 = show nonverbose help, 3 = show verbose help
	var/usage_example

	//need an origin object
	var/requires_source = FALSE

//dispatch table is defined on a per-command basis w/ minimum arguments
// commandSpec["clear"]  = list(CALLBACK(PROC), MINIMUM_ARGUMENTS)
// not strictly needed if you need or want to do weird shit with a command, but this helps
// with the simple boilerplate.

//check code/modules/commandline_networks/core/core_commands/help.dm for the expected usecase.
//note that arguments may be null.
/datum/commandline_network_command/proc/getHelpText(var/datum/commandline_network_node/homenode,var/list/arguments, var/verbose = FALSE, var/direct = FALSE, var/usage = FALSE)
	return "There is no documentation avaliable for this command."

/datum/commandline_network_command/proc/Initialize()
	return

/datum/commandline_network_command/proc/getAlias(var/datum/commandline_network_node/sourceNode)
	return name

/*
source: what node sent the command?
from: what node are we running the command on?
arguments: what arguments were given? -> full list of tokens.
*/
#define ERROR_NO_FROM "FUCK!! Command sent without owner! You likely need a priest. you should never see this."
#define ERROR_NO_SOURCE "Err: Command sent with invalid origin"
#define ERROR_MISSING_TABLE "Err: Command Binary in invalid state"

#define ERROR_ARGUMENT_NOT_IN_TABLE(possible) "Err: Invalid action. Valid actions: [possible]"
#define ERROR_NO_ARGUMENTS_NON_STANDALONE "Err: This command requires arguments. use help for usage."

#define ERROR_NOT_ENOUGH_ARGUMENTS(action,minarguments) "Err: Insufficient arguments provided for [action]. Required: [minarguments]"

/datum/commandline_network_command/proc/runCommand(var/datum/commandline_network_node/source, var/datum/commandline_network_node/from, var/list/sorted_tokens, var/datum/commandline_log_entry/logs, var/verbose = FALSE)
	SHOULD_CALL_PARENT(FALSE) //if you're overwriting logic you probably don't wanna call this anyway. if you DO feel free to comment this out

	var/list/arguments = LAZYACCESS(sorted_tokens,COMMAND_ARGUMENT_ARGUMENTS)

	if(!from) //FUCK FUCK FUCK FUCK
		logs.set_log(src,ERROR_NO_FROM,COMMAND_OUTPUT_ERROR) //TODO: add "command output FUCKED"
		return

	if(requires_source && source == null)
		logs.set_log(from,ERROR_NO_SOURCE,COMMAND_OUTPUT_ERROR)
		return

	if(standalone)
		if(arguments.len-1 >= min_args_standalone)
			standalone.Invoke(source,from,sorted_tokens,logs,verbose)
		else
			logs.set_log(from,ERROR_NOT_ENOUGH_ARGUMENTS(sorted_tokens[COMMAND_ARGUMENT_COMMAND],min_args_standalone),COMMAND_OUTPUT_ERROR)
		return

	if(!dispatch_table.len)
		logs.set_log(from,ERROR_MISSING_TABLE,COMMAND_OUTPUT_ERROR)
		return




	var/argument_count = arguments.len-1 //-1. we don't have a dedicated "action" token
	if(argument_count < 1)
		logs.set_log(from,ERROR_NO_ARGUMENTS_NON_STANDALONE,COMMAND_OUTPUT_ERROR)
		return

	//>target command action argument argument etc

	var/action = arguments[1]
	if(ckey(action) in dispatch_table)
		var/list/dispatch = dispatch_table[ckey(action)]
		var/datum/callback/to_dispatch = dispatch[1]
		var/min_args = dispatch[2]
		if(argument_count-1 < min_args)
			logs.set_log(from,ERROR_NOT_ENOUGH_ARGUMENTS(action,min_args),COMMAND_OUTPUT_ERROR)
			return
		//TODO: replace this with an addtimer for node latency
		to_dispatch.Invoke(source,from,sorted_tokens,logs,verbose)
		return

	else
		var/possible = ""
		for(var/dispatch_token in dispatch_table)
			possible += "[dispatch_token], "

		logs.set_log(from,ERROR_ARGUMENT_NOT_IN_TABLE(possible),COMMAND_OUTPUT_ERROR)
		return
