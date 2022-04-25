//I AM THE LOREMASTER, ARE YOU THE GATEKEEPER?

var/global/datum/lore/loremaster/loremaster = new/datum/lore/loremaster

/datum/lore/loremaster
	var/list/organizations = list()

/datum/lore/loremaster/New()

	var/list/paths = subtypesof(/datum/lore/organization)
	for(var/path in paths)
		// Some intermediate paths are not real organizations (ex. /datum/lore/organization/mil). Only do ones with names
		var/datum/lore/organization/instance = path
		if(initial(instance.name))
			instance = new path()
			organizations[path] = instance
