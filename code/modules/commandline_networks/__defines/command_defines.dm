/*

    /\_____/\
   /  o   o  \
  ( ==  ^  == )
   )         (
  (           )
 ( (  )   (  ) )
(__(__)___(__)__)

Anything used in the context of commands.
* Names
* Output macros

*/
//might be good to throw on nodes
#define COMMAND_NETWORK_DEFAULTS list(/datum/commandline_network_command/event,/datum/commandline_network_command/help,/datum/commandline_network_command/proxy,/datum/commandline_network_command/shutdown,/datum/commandline_network_command/reboot)

//external facing, use the node this runs on to run a command on another node (but not itself)
#define COMMAND_PROXY "proxy"

//helpies. Node command, essentially lists all the commands on the node (via their node-specific aliases) w/ a blurb of what they do (determined on a per command basis)
#define COMMAND_HELP "help"

//tell the node to shutdown
#define COMMAND_SHUTDOWN "shutdown"

//tell the node to shutdown, and eventually reboot itself
#define COMMAND_REBOOT "reboot"

//event handling for the node
#define COMMAND_EVENT "event"

#define COMMAND_OUTPUT_ERROR "error"
#define COMMAND_OUTPUT_STANDARD "normal"

/*
Uh oh, outputs!
*/

#define COMMAND_RESULT_INVALID "Err: Invalid Command Syntax"

#define COMMAND_RESULT_NO_TARGET "Err: No Target Was Provided."

#define COMMAND_RESULT_MISSING_NODE "Err: invalid node for command - report this to your network administrator"

#define COMMAND_RESULT_NO_PREFIX "Err: Invalid Entry Format."

#define COMMAND_RESULT_NO_COMMAND "Err: No Command."

#define COMMAND_RESULT_MISSING_SELF "Err: Self-Command from invalid source."

#define COMMAND_RESULT_TOO_SHORT "Err: Incomplete Command"

#define COMMAND_RESULT_NO_FOUND_TARGETS(name) "Err: [name] invalid target."

#define COMMAND_RESULT_NO_COMMAND_IN_NODE(name, command) "Err: command [command] not present in node [name]."

#define COMMAND_RESULT_UNKNOWN_PREFIX(prefix) "Err: Unknown Command Prefix \"[prefix]\" - Check legend."

#define COMMAND_ACTION_PARAMS \
var/datum/commandline_network_node/source, \
var/datum/commandline_network_node/from, \
var/list/sorted_tokens, \
var/datum/commandline_log_entry/logs, \
var/verbose

#define COMMAND_ACTION_DEFINE(action,procname,min)  dispatch_table["[ckey(action)]"] = list(CALLBACK(src,PROC_REF(procname)),min)
#define COMMAND_STANDALONE_ACTION_DEFINE(procname,min) standalone = CALLBACK(src,PROC_REF(procname)); min_args_standalone=min

#define ERROR_REQUIRES_MOB: "Err: Endoware not installed in valid target."
#define ERROR_NO_FROM "FUCK!! Command sent without owner! You likely need a priest. you should never see this."
#define ERROR_NO_SOURCE "Err: Command sent with invalid origin"
#define ERROR_MISSING_TABLE "Err: Command Binary in invalid state"

#define ERROR_ARGUMENT_NOT_IN_TABLE(possible) "Err: Invalid action. Valid actions: [possible]"
#define ERROR_NO_ARGUMENTS_NON_STANDALONE "Err: This command requires arguments. use help for usage."

#define ERROR_NOT_ENOUGH_ARGUMENTS(action,minarguments) "Err: Insufficient arguments provided for [action]. Required: [minarguments]"
