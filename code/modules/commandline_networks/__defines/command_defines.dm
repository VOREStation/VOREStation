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
