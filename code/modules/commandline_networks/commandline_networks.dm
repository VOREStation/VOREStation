SUBSYSTEM_DEF(commandline_networks)
	name = "Commandline Networks"
	wait = 1 SECOND
	init_order = INIT_ORDER_DEFAULT
	runlevels = RUNLEVELS_DEFAULT

	var/list/networks = list()
	var/list/command_cache = list()

	var/networks_instantiated = 0 //mostly so the names are always 100% unqiue

	var/max_command_cache = 128



/datum/controller/subsystem/commandline_networks/fire(resumed = 0)
	for(var/datum/commandline_network/network in networks)
		network.process()

/datum/controller/subsystem/commandline_networks/Initialize()
	for(var/commandtype in subtypesof(/datum/commandline_network_command))
		var/datum/commandline_network_command/cmd2cache = new commandtype()
		cmd2cache.Initialize()

		command_cache[cmd2cache.type] = cmd2cache

	return SS_INIT_SUCCESS

/datum/controller/subsystem/commandline_networks/proc/GetCachedCommand(var/commandType) as /datum/commandline_network_command
	var/found = LAZYACCESS(command_cache,commandType)
	to_chat(world,"FETCHING COMMAND: [commandType] | found: [found]")
	return found

/datum/controller/subsystem/commandline_networks/proc/dump()
	return json_encode(command_cache)

/datum/controller/subsystem/commandline_networks/proc/Initialize_Network(var/datum/commandline_network/network)
	network.Initialize()
	networks_instantiated++
