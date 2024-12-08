// Pulls data from organizations data
/datum/lore/codex/category/auto_org
	var/desired_type = null
	var/auto_keywords = list()

/datum/lore/codex/category/auto_org/New(var/new_holder, var/new_parent)
	..(new_holder, new_parent)
	keywords += auto_keywords
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
	auto_keywords = list("TSC","TSCs","Trans-Stellar","Trans-Stellar Corporation")
	data = "By definition, TSCs are companies which span multiple star systems, however the term is generally reserved for \
	the biggest and most influential of them all.  Some people also categorize the different TSCs into 'major' and 'minor' TSCs."
	desired_type = /datum/lore/organization/tsc

/datum/lore/codex/category/auto_org/other
	name = "Other Factions"
	auto_keywords = list("SDF","Smuggler","Smugglers","Pirate","Pirates")
	desired_type = /datum/lore/organization/other

/datum/lore/codex/category/auto_org/gov
	name = "Governments"
	auto_keywords = list("Gov","Government","Governments")
	desired_type = /datum/lore/organization/gov

/datum/lore/codex/category/auto_org/mil
	name = "Military Forces & PMCs"
	auto_keywords = list("Mil","Military", "Militaries")
	desired_type = /datum/lore/organization/mil
