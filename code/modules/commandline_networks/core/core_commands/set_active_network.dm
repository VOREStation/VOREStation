//Not a "core" command in the sense of it being on every node, but it's important so here it stays

/datum/commandline_network_command/set_active_network
	name = "settarget"

/datum/commandline_network_command/set_active_network/Initialize()
	. = ..()
	standalone = COMMAND_STANDALONE_ACTION_DEFINE(setNetwork,0)

/datum/commandline_network_command/set_active_network/getHelpText(homenode,arguments,alias_used,verbose,direct,usage)
	if(direct)
		return {"
Sets the active network connection for remote communication.
Usage: >[alias_used] NETWORKNAME
- The specified network becomes the active target for broadcasted commands.
- Requires an established physical connection to the network.
"}
	if(verbose)
		return {"
Selects a network for remote command targeting. Must be physically connected to use. Ensures subsequent commands are sent to the chosen network."}

	if(usage)
		return ">target [alias_used] NETWORKNAME|clear"
	return "sets a target network for sending remote commands. Requires connection."

/datum/commandline_network_command/set_active_network/proc/setNetwork(COMMAND_ACTION_PARAMS)
	if(!from.owner)
		logs.set_log(from,"Err: Originating Node Not Part Of Network.",COMMAND_OUTPUT_ERROR)
		return

	var/list/arguments = LAZYACCESS(sorted_tokens,COMMAND_ARGUMENT_ARGUMENTS)
	if(!arguments.len) //we want the extra help info here.
		if(verbose)
			var/x = ""
			for(var/datum/commandline_network/y in from.owner.connected_networks)
				x += y.name + ", "
			logs.set_log(from,"Err: No Target Network Alias Provided: Avaliable Options: [x].",COMMAND_OUTPUT_ERROR)
			return
		logs.set_log(from,"Err: No Target Network Alias Provided.",COMMAND_OUTPUT_ERROR)
		return

	var/target = arguments[1]
	var/datum/commandline_network/found = null

	for(var/datum/commandline_network/y in from.owner.connected_networks)
		if(y.name == target)
			found = y

	if(!found)
		if(verbose)
			var/x = ""
			for(var/datum/commandline_network/y in from.owner.connected_networks)
				x += "[y.name]" + ", "
			logs.set_log(from,"Err: Invalid Target Alias \"[target]\". Avaliable Options: [x]",COMMAND_OUTPUT_ERROR)
			return
		else
			logs.set_log(from,"Err: Invalid Target Alias \"[target]\".",COMMAND_OUTPUT_ERROR)
			return

	from.owner.targetted_network = found
	logs.set_log(from,"Target Network Set To: [target].")
