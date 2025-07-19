/*
This one's a bit complicated, namely, it sends another command, using THIS node as a source. security nightmare? yes. is it intentional? also yes.
some of the high security prosthetics (ae, heart, brain) might not want people to shut them down easily, so this is kind of a noob check / to prevent the
natural footgun of someone accidently doing >@@ shutdown instead of >@@ reboot

note that anything put through here IS put into the
*/

/datum/commandline_network_command/proxy
	name = "proxy"

/datum/commandline_network_command/proxy/getHelpText(datum/commandline_network_node/homenode, list/arguments, alias_used, verbose, direct, usage)
	var/usage_example = ">target [alias_used] \">remoteTarget remoteCommand remoteCommandArguments\""
	if(usage)
		return usage_example

	if(direct)
		return {"
uses a node as a proxy to send another command. this allows you to "bounce" a command using another node - making it seem like the source.
in effect, this is like you're sending the command passed as an argument from the node you're targetting. macro usage is encouraged, but note that
macros will be determined FROM THE NODE IT IS CURRENTLY ON. Assuming they're availiable.

Note that proxies are delegated to the internal processing queue, and lack the command priority of a network input device.
"}
	if(verbose)
		return "Uses the node it is present on to send a command from itself, can be used to bounce commands."

/datum/commandline_network_command/proxy/Initialize()
	standalone = COMMAND_STANDALONE_ACTION_DEFINE(sendProxy,1)

/datum/commandline_network_command/proc/sendProxy(COMMAND_ACTION_PARAMS)
	if(!from.owner)
		logs.set_log("Err: Can not send proxy from node disconnected from network.",COMMAND_OUTPUT_ERROR)
		return
	var/list/arguments = LAZYACCESS(sorted_tokens,COMMAND_ARGUMENT_ARGUMENTS)
	var/command = arguments[2]

	logs.set_log("Invoking command from [from.name]: [command]")
	from.owner.do_command(command)
	//ignore all other arguments
