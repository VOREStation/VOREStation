/datum/commandline_network_node
	var/name = COMMAND_NODE_DEFAULT_NAME
	var/desc  //shown via help command
	var/desc_verbose //ditto but wordswordswords

	var/datum/commandline_network/owner //not strictly needed, but causes some issues if not set
	var/list/commands = list()

	//stuff like "l_foot" "torso" etc, treat it like flags. p-4d
	var/list/network_locs = list()
	var/list/commands_to_add = list()
	var/override_defaults = FALSE



/datum/commandline_network_node/proc/recieve_command(var/datum/commandline_network_node/source_node, var/list/categorized_tokens, var/datum/commandline_log_entry/logs, var/verbose = FALSE)
	if(categorized_tokens[COMMAND_ARGUMENT_COMMAND] in commands)
		var/datum/commandline_network_command/foundCMD = SScommandline_networks.GetCachedCommand(commands[categorized_tokens[COMMAND_ARGUMENT_COMMAND]])
		return foundCMD.runCommand(source_node,src,categorized_tokens,logs,verbose)
	else
		if(verbose)
			logs.set_log(src,COMMAND_RESULT_NO_COMMAND_IN_NODE(src,categorized_tokens[COMMAND_ARGUMENT_COMMAND]),"error")
			return


/datum/commandline_network_node/proc/on_network_crashed(var/datum/commandline_network/crashed_network)
	return //presumably do stuff. networks can crash when the cache gets full

/datum/commandline_network_node/proc/Initialize()
	SHOULD_CALL_PARENT(TRUE)
	to_chat(world,"INITIATING [src.name]")
	if(!override_defaults)
		commands_to_add.Add(COMMAND_NETWORK_DEFAULTS)

	for(var/commandType in commands_to_add)
		commands[SScommandline_networks.GetCachedCommand(commandType)?.getAlias(src)] = commandType


//TODO
/datum/commandline_network_node/proc/Shutdown()

/datum/commandline_network_node/proc/Startup()

/datum/commandline_network_node/proc/SecurityCheck()

/datum/commandline_network_node/proc/CheckLatency()

/datum/commandline_network_node/proc/LatencyBetween()

/datum/commandline_network_node/proc/IntegrityBetween()

/datum/commandline_network_node/proc/getHelpText(var/verbose)
