//Not a "core" command in the sense of it being on every node, but it's important so here it stays

/datum/commandline_network_command/set_active_network
	name = "settarget"

/datum/commandline_network_command/set_active_network/getHelpText(datum/commandline_network_node/homenode, arguments, verbose, direct)
	if(direct)
		return {"
Sets the active network connection for remote communication.
Usage: >settarget NETWORKNAME
- The specified network becomes the active target for broadcasted commands.
- Requires an established physical connection to the network.
"}
	if(verbose)
		return {"
Selects a network for remote command targeting. Must be physically connected to use. Ensures subsequent commands are sent to the chosen network."}

	return "sets a target network for sending remote commands. Requires connection."


/datum/commandline_network_command/set_active_network/runCommand(var/datum/commandline_network_node/source, var/datum/commandline_network_node/from, var/list/sorted_tokens, var/datum/commandline_log_entry/logs, var/verbose = FALSE)
	if(!from.owner)
		logs.set_log(from,"Err: Originating Node Not Part Of Network",COMMAND_OUTPUT_ERROR)
		return

	var/list/arguments = LAZYACCESS(sorted_tokens,COMMAND_ARGUMENT_ARGUMENTS)
	var/target = arguments[1] //we don't give a shit about anything else, or flags, or anything really
	if(!target)
		if(verbose)
			var/x = ""
			for(var/y in from.owner.connected_networks)
				x += y + ", "
			logs.set_log(from,"Err: No Target Network Alias Provided: Avaliable Options: [x].",COMMAND_OUTPUT_ERROR)
			return

		logs.set_log(from,"Err: No Target Network Alias Provided",COMMAND_OUTPUT_ERROR)
		return

	if(!(target in from.owner.connected_networks))
		if(verbose)
			var/x = ""
			for(var/y in from.owner.connected_networks)
				x += y.name + ", "
			logs.set_log(from,"Err: Invalid Target Alias \"[target]\". Avaliable Options: [x]",COMMAND_OUTPUT_ERROR)
			return
		else
			logs.set_log(from,"Err: Invalid Target Alias \"[target]\".",COMMAND_OUTPUT_ERROR)
			return
	from.owner.targetted_network = from.owner.connected_networks[target]
	logs.set_log(from,"Target Network Set To: [target].")
