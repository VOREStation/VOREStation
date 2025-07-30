/*

               ,
             _/((
    _.---. .'   `\     meow
  .'      `     ^ T=
 /     \       .--'
|      /       )'-.
; ,   <__..-(   '-.)
 \ \-.__)    ``--._)
  '.'-.__.-.
    '-...-'

This has:

* The prefixes used in the commands
* Various macros for flags etc

*/


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

//used to snag attributes from a command prefix - verbose, whether it's picky, etc.
#define COMMAND_PREFIX_CONFIG list(\
	COMMAND_PREFIX_TARGET_EVERY = list(COMMAND_CONFIG_VERBOSE = FALSE, COMMAND_CONFIG_CONSUMES_TARGET = TRUE), /* >@@ */\
	COMMAND_PREFIX_TARGET_ALL  = list(COMMAND_CONFIG_VERBOSE = FALSE, COMMAND_CONFIG_CONSUMES_TARGET = FALSE), /* >@ */\
	COMMAND_PREFIX_TARGET_SELF = list(COMMAND_CONFIG_VERBOSE = FALSE, COMMAND_CONFIG_CONSUMES_TARGET = TRUE),  /* >< */\
	COMMAND_PREFIX_TARGET_NOT  = list(COMMAND_CONFIG_VERBOSE = FALSE, COMMAND_CONFIG_CONSUMES_TARGET = FALSE), /* >! */\
	COMMAND_PREFIX_TARGET_ONCE = list(COMMAND_CONFIG_VERBOSE = TRUE, COMMAND_CONFIG_CONSUMES_TARGET = FALSE)   /* > */\
)

#define COMMAND_FLAG_VERBOSE "--verbose"
#define COMMAND_FLAG_VERBOSE_ALT "--v"
#define IS_COMMAND_FLAG_VERBOSE(flag) (lowertext(flag) == COMMAND_FLAG_VERBOSE || lowertext(flag) == COMMAND_FLAG_VERBOSE_ALT)

//do we start with "--"?
#define IS_GLOBAL_COMMAND_FLAG(flag) (!!findtext(flag, "--", 1, LAZYLEN("--")+1))


//what we set the target token to if it's a consumes_target
#define COMMAND_VALUE_TARGET_CONSUMED "HANDLED_FROM_PREFIX"

#define TOKEN_INDEX_PREFIX 1
#define TOKEN_INDEX_TARGET 2
#define TOKEN_INDEX_COMMAND 3 //args are any >3

//for the actual "tokenized" stuff
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
