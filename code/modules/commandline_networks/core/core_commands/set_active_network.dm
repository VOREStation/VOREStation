//Not a "core" command in the sense of it being on every node, but it's important so here it stays

/datum/commandline_network_command/set_active_network
	name = "settarget"

/datum/commandline_network_command/set_active_network/getHelpText(datum/commandline_network_node/homenode, arguments, verbose)
	if(verbose)
		return "Sets the active network connection for remote network commands. You must have a physical connection to the network in order to select it for broadcasting. Syntax is: settarget NETWORKNAME"
	else return "Set network target"

/datum/commandline_network_command/set_active_network/runCommand(var/datum/commandline_network_node/source, var/datum/commandline_network_node/from, var/list/sorted_tokens, var/datum/commandline_log_entry/logs, var/verbose = FALSE)
	if(!from.owner)
		logs.set_log(from,"Err: Originating Node Not Part Of Network","error")
		return

	var/list/arguments = LAZYACCESS(sorted_tokens,COMMAND_ARGUMENT_ARGUMENTS)
	var/target = arguments[1] //we don't give a shit about anything else, or flags, or anything really
	if(!target)
		if(verbose)
			var/x = ""
			for(var/y in from.owner.connected_networks)
				x += y + ", "
			logs.set_log(from,"Err: No Target Network Alias Provided: Avaliable Options: [x].","error")
			return

		logs.set_log(from,"Err: No Target Network Alias Provided","error")
		return

	if(!(target in from.owner.connected_networks))
		if(verbose)
			var/x = ""
			for(var/y in from.owner.connected_networks)
				x += y + ", "
			logs.set_log(from,"Err: Invalid Target Alias \"[target]\". Avaliable Options: [x]","error")
			return
		else
			logs.set_log(from,"Err: Invalid Target Alias \"[target]\".","error")
			return
	from.owner.targetted_network = from.owner.connected_networks[target]
	logs.set_log(from,"Target Network Set To: [target].")
