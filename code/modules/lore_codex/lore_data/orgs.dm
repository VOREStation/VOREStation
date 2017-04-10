// Pulls data from organizations data
/datum/lore/codex/category/auto_org
	var/desired_type = null // Exclude other types of organizations

/datum/lore/codex/category/auto_org/New(var/new_holder, var/new_parent)
	..(new_holder, new_parent)
	for(var/path in loremaster.organizations)
		var/datum/lore/organization/O = loremaster.organizations[path]
		if(!(istype(O, desired_type)))
			continue
		var/datum/lore/codex/page/P = new(holder, src)
		if(!O.name) // Probably the base type, don't make a page for it.
			continue
		P.name = O.name
		P.keywords.Add(O.name, O.short_name)
		if(O.acronym)
			P.keywords.Add(O.acronym)
		P.data = O.desc
		children.Add(P)

/datum/lore/codex/category/auto_org/tsc
	name = "Trans-Stellar Corporations"
	data = "By definition, TSCs are companies which span multiple star systems, however the term is generally reserved for \
	the biggest and most influential of them all.  Some people also categorize the different TSCs into 'major' and 'minor' TSCs."
	desired_type = /datum/lore/organization/tsc

/datum/lore/codex/category/auto_org/gov
	name = "Governments"
	desired_type = /datum/lore/organization/gov

/*
/datum/lore/codex/category/auto_org/mil
	name = "Militaries"
	desired_type = /datum/lore/organization/mil
*/