/datum/commandline_network_node/endoware
	desc = "An Installed Endoware Implant"
	desc_verbose = "Wow! this is where extra information goes or something. Fill this out!"
	var/brand = BRAND_UNBRANDED

/datum/commandline_network_command/brand_support
	var/list/brand_to_alias //list!
	var/default_alias //if no name can be found or the node isn't branded

/datum/commandline_network_command/brand_support/getAlias(datum/commandline_network_node/sourceNode)
	if(istype(sourceNode,/datum/commandline_network_node/endoware))
		var/datum/commandline_network_node/endoware/node = sourceNode
		if(LAZYLEN(brand_to_alias) && (node.brand in brand_to_alias))
			return brand_to_alias[node.brand]
		else
			if(default_alias) return default_alias
			else return name
	else return name

/datum/commandline_network_command/brand_support/proc/is_endoware_boilerplate(var/datum/commandline_network_node/from, var/datum/commandline_log_entry/logs)
	var/obj/item/endoware/target = from?.assigned_to
	if(target && istype(target))
		return TRUE
	else
		logs.set_log(from,"err need endoware",COMMAND_OUTPUT_ERROR)
		return FALSE

//we use this a lot, might as well make it generic
/datum/commandline_network_command/brand_support/proc/installed_in_mob_boilerplate(var/datum/commandline_network_node/from, var/datum/commandline_log_entry/logs)
	if(is_endoware_boilerplate(from,logs))
		var/obj/item/endoware/home = from.assigned_to
		if(home.host)
			return TRUE
		else
			logs.set_log(from,"err need to be installed",COMMAND_OUTPUT_ERROR)
			return FALSE

/datum/commandline_network_command/brand_support/proc/installed_in_human_boilerplate(var/datum/commandline_network_node/from, var/datum/commandline_log_entry/logs)
	if(is_endoware_boilerplate(from,logs))
		var/obj/item/endoware/home = from.assigned_to
		if(home.host && ishuman(home.host))
			return TRUE
		else
			logs.set_log(from,"err need to be installed in human",COMMAND_OUTPUT_ERROR)
			return FALSE
