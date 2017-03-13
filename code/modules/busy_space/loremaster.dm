//I AM THE LOREMASTER, ARE YOU THE GATEKEEPER?

var/datum/lore/loremaster/loremaster = new/datum/lore/loremaster

/datum/lore/loremaster
	var/list/orgs = list()

/datum/lore/loremaster/New()
	var/paths //Just reuse this a bunch of times.

	paths = typesof(/datum/lore/org) - /datum/lore/org
	for(var/path in paths)
		var/datum/lore/org/instance = new path()
		orgs[path] = instance
