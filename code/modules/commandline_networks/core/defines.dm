#define TOKEN_INDEX_PREFIX 1
#define TOKEN_INDEX_TARGET 2
#define TOKEN_INDEX_COMMAND 3 //args are any >3


#define COMMAND_ARGUMENT_PREFIX "prefix"
#define COMMAND_ARGUMENT_TARGET "target"
#define COMMAND_ARGUMENT_COMMAND "command"
#define COMMAND_ARGUMENT_FLAGS "flags"
#define COMMAND_ARGUMENT_FLAGS_GLOBAL "global_flags"
#define COMMAND_ARGUMENT_ARGUMENTS "arguments"
#define COMMAND_ARGUMENT_RAW "raw"


#define COMMAND_ARGUMENT_NAME "name" //token name, in the arg_flags list

/*
the datastruct for commands is as follows

	list(
		COMMAND_ARGUMENT_PREFIX = ">", (or whatever)
		COMMAND_ARGUMENT_TARGET = "l_foot", (or whatever - node name, target flag, do not matta)
		COMMAND_ARGUMENT_COMMAND = "help",
		COMMAND_ARGUMENT_ARGUMENTS = list("argument1","argument2") etc
		COMMAND_ARGUMENT_ARGUMENT_FLAGS = list("name",list(flags)), list("name",list(flags)) etc - index of above will always match
		COMMAND_ARGUMENT_FLAGS = list(--v, --t, --asdags) //flags are globally applied to the command when using --, singular dashes apply it to the last argument.
		COMMAND_ARGUMENT_RAW = list(all tokens)
		)

*/

/*
DEFAULT NAMES
*/

#define COMMAND_VALUE_TARGET_CONSUMED "HANDLED_FROM_PREFIX"
#define COMMAND_NODE_DEFAULT_NAME "Unknown Network Node"

/*
Prefixes: what commands need to start with. determines the scope of targetting
*/

//target the first option that matches the target query
#define COMMAND_PREFIX_TARGET_ONCE ">"

//target ALL options that match the target query
#define COMMAND_PREFIX_TARGET_ALL ">@"

//ignore the target entirely, forward to every node in the network
#define COMMAND_PREFIX_TARGET_EVERY ">@@"

//target self, mainly for proxies & getting help from the terminal
#define COMMAND_PREFIX_TARGET_SELF "><"

//target everything that does NOT match the critera
#define COMMAND_PREFIX_TARGET_NOT ">!"

//if you are for whatever reason adding prefixes, make sure they're in ORDER from fattest to lowest character count
#define ALL_COMMAND_PREFIXES list(\
	COMMAND_PREFIX_TARGET_EVERY, /* >@@ */\
	COMMAND_PREFIX_TARGET_ALL,   /* >@ */\
	COMMAND_PREFIX_TARGET_SELF,  /* >< */\
	COMMAND_PREFIX_TARGET_NOT,   /* >! */\
	COMMAND_PREFIX_TARGET_ONCE   /* > */\
)

#define COMMAND_CONFIG_VERBOSE "verbose"
#define COMMAND_CONFIG_CONSUMES_TARGET "consumes_target"

//how each prefix acts in terms of config - verbose can be enabled via the --verbose or --v flags at a parser level

#define COMMAND_PREFIX_CONFIG list(\
	COMMAND_PREFIX_TARGET_EVERY = list(COMMAND_CONFIG_VERBOSE = FALSE, COMMAND_CONFIG_CONSUMES_TARGET = TRUE), /* >@@ */\
	COMMAND_PREFIX_TARGET_ALL  = list(COMMAND_CONFIG_VERBOSE = FALSE, COMMAND_CONFIG_CONSUMES_TARGET = FALSE),   /* >@ */\
	COMMAND_PREFIX_TARGET_SELF = list(COMMAND_CONFIG_VERBOSE = FALSE, COMMAND_CONFIG_CONSUMES_TARGET = TRUE),  /* >< */\
	COMMAND_PREFIX_TARGET_NOT  = list(COMMAND_CONFIG_VERBOSE = FALSE, COMMAND_CONFIG_CONSUMES_TARGET = FALSE),   /* >! */\
	COMMAND_PREFIX_TARGET_ONCE = list(COMMAND_CONFIG_VERBOSE = TRUE, COMMAND_CONFIG_CONSUMES_TARGET = FALSE)  /* > */\
)


#define COMMAND_FLAG_VERBOSE "--verbose"
#define COMMAND_FLAG_VERBOSE_ALT "--v"
#define IS_COMMAND_FLAG_VERBOSE(flag) (lowertext(flag) == COMMAND_FLAG_VERBOSE || lowertext(flag) == COMMAND_FLAG_VERBOSE_ALT)

//do we start with "--"?
#define IS_GLOBAL_COMMAND_FLAG(flag) (!!findtext(flag, "--", 1, LAZYLEN("--")+1))

//default commands, not every command needs a define but it'd be nice

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

//how many queued commands we can have before a crash
#define COMMAND_NETWORK_DEFAULT_MAX_CACHE 128

//network type, bitflag.
#define NETWORK_TYPE_GENERIC 1
#define NETWORK_TYPE_HUMAN 2 //prosthetics, robots, implants, oh my.


//default commands
#define COMMAND_NETWORK_DEFAULTS list(/datum/commandline_network_command/event,/datum/commandline_network_command/help,/datum/commandline_network_command/proxy,/datum/commandline_network_command/shutdown,/datum/commandline_network_command/reboot)

#define COMMAND_RESULT_INVALID "Err: Invalid Command Syntax"
#define COMMAND_RESULT_NO_TARGET "Err: No Target Was Provided."
#define COMMAND_RESULT_NO_PREFIX "Err: Invalid Entry Format."
#define COMMAND_RESULT_NO_COMMAND "Err: No Command."
#define COMMAND_RESULT_MISSING_SELF "Err: Self-Command from invalid source."
#define COMMAND_RESULT_TOO_SHORT "Err: Incomplete Command"
#define COMMAND_RESULT_NO_FOUND_TARGETS(name) "Err: [name] invalid target."
#define COMMAND_RESULT_NO_COMMAND_IN_NODE(name, command) "Err: command [command] not present in node [name]."
#define COMMAND_RESULT_UNKNOWN_PREFIX(prefix) "Err: Unknown Command Prefix \"[prefix]\" | Valid Prefixes: >@@, >@, ><, >!, >"

//while there's nothing nessicarily stopping people from mixing and matching node/network types & their locations
// it's probably best to keep it self contained?
#define CMD_LOC_HEAD "head"
#define CMD_LOC_EYES "eyes"

#define CMD_LOC_TORSO "torso"
#define CMD_LOC_SPINE  "spine"
#define CMD_LOC_GROIN "groin"

#define CMD_LOC_LEGS "legs"
#define CMD_LOC_L_LEG "l_leg"
#define CMD_LOC_R_LEG "r_leg"
#define CMD_LOC_FEET "feet"
#define CMD_LOC_R_FOOT "r_foot"
#define CMD_LOC_L_FOOT "l_foot"

#define CMD_LOC_ARMS "arms"
#define CMD_LOC_HANDS "hands"
#define CMD_LOC_L_ARM "l_arm"
#define CMD_LOC_R_ARM "r_arm"

#define CMD_LOC_L_HAND "l_hand"
#define CMD_LOC_R_HAND "r_hand"

#define CMD_LOC_HEART "heart"
#define CMD_LOC_LUNGS "lungs"
#define CMD_LOC_BRAIN "brain"
#define CMD_LOC_LIVER "liver"
#define CMD_LOC_KIDNEYS "kidneys"
#define CMD_LOC_APPENDIX "appendix"
#define CMD_LOC_VOICE "larynx"
#define CMD_LOC_SPLEEN "spleen"
#define CMD_LOC_STOMACH "stomach"
#define CMD_LOC_INTESTINE "intestine"
