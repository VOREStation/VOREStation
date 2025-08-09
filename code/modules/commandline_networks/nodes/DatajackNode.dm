/datum/commandline_network_node/datajack
	name = "DataJack"
	network_locs = list("jack")
	commands_to_add = list(
		/datum/commandline_network_command/set_active_network,
		/datum/commandline_network_command/macro,
		/datum/commandline_network_command/help
		)
	override_defaults = TRUE //We don't add the defaults...
	flags = CMD_NODE_FLAG_DATAJACK
