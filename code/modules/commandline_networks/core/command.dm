//commands are static & instantiated once by the subsystem
/datum/commandline_network_command
	var/name = "unnamed command"

//check code/modules/commandline_networks/core/core_commands/help.dm for the expected usecase
/datum/commandline_network_command/proc/getHelpText(var/datum/commandline_network_node/homenode,var/list/arguments, var/verbose = FALSE, var/direct = FALSE)
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

/datum/commandline_network_command/proc/runCommand(var/datum/commandline_network_node/source, var/datum/commandline_network_node/from, var/list/sorted_tokens, var/datum/commandline_log_entry/logs, var/verbose = FALSE)
	SHOULD_CALL_PARENT(FALSE)

	var/x = "[src.name] command Ran on: [from ? from.name : "NULL"] by: [source ? source.name : "NULL"] with verbosity: [verbose] and arguments: [json_encode(sorted_tokens)]"
	logs.set_log(source,x,COMMAND_OUTPUT_ERROR)
