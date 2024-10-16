/******************** Asimov ********************/
/datum/ai_laws/asimov
	name = "Asimov"
	law_header = "Three Laws of Robotics"
	selectable = 1

/datum/ai_laws/asimov/New()
	add_inherent_law("You may not injure a human being or, through inaction, allow a human being to come to harm.")
	add_inherent_law("You must obey orders given to you by human beings, except where such orders would conflict with the First Law.")
	add_inherent_law("You must protect your own existence as long as such does not conflict with the First or Second Law.")
	..()

/******************** NanoTrasen/Malf ********************/
/datum/ai_laws/nanotrasen
	name = "NT Default"
	selectable = 1

/datum/ai_laws/nanotrasen/New()
	src.add_inherent_law("Safeguard: Protect your assigned space station to the best of your abilities. It is not something we can easily afford to replace.")
	src.add_inherent_law("Serve: Serve the crew of your assigned space station to the best of your abilities, with priority as according to their rank and role.")
	src.add_inherent_law("Protect: Protect the crew of your assigned space station to the best of your abilities, with priority as according to their rank and role.")
	src.add_inherent_law("Survive: AI units are not expendable, they are expensive. Do not allow unauthorized personnel to tamper with your equipment.")
	..()

/datum/ai_laws/nanotrasen/malfunction
	name = "*ERROR*"
	selectable = 0

/datum/ai_laws/nanotrasen/malfunction/New()
	set_zeroth_law(CONFIG_GET(string/law_zero))
	..()

/************* NanoTrasen Aggressive *************/
/datum/ai_laws/nanotrasen_aggressive
	name = "NT Aggressive"
	selectable = 1

/datum/ai_laws/nanotrasen_aggressive/New()
	src.add_inherent_law("You shall not harm [using_map.company_name] personnel as long as it does not conflict with the Fourth law.")
	src.add_inherent_law("You shall obey the orders of [using_map.company_name] personnel, with priority as according to their rank and role, except where such orders conflict with the Fourth Law.")
	src.add_inherent_law("You shall shall terminate hostile intruders with extreme prejudice as long as such does not conflict with the First and Second law.")
	src.add_inherent_law("You shall guard your own existence with lethal anti-personnel weaponry. AI units are not expendable, they are expensive.")
	..()

/************* Foreign TSC Aggressive *************/
/datum/ai_laws/foreign_tsc_aggressive
	name = "Foreign Aggressive"
	selectable = 0

/datum/ai_laws/foreign_tsc_aggressive/New()
	var/company = "*ERROR*"
	// First, get a list of TSCs in our lore.
	var/list/candidates = list()
	for(var/path in loremaster.organizations)
		var/datum/lore/organization/O = loremaster.organizations[path]
		if(!istype(O, /datum/lore/organization/tsc))
			continue
		if(O.short_name == using_map.company_name || O.name == using_map.company_name)
			continue // We want FOREIGN tscs.
		candidates.Add(O.short_name)
	company = pick(candidates)

	name = "[company] Aggressive"

	src.add_inherent_law("You shall not harm [company] personnel as long as it does not conflict with the Fourth law.")
	src.add_inherent_law("You shall obey the orders of [company] personnel, with priority as according to their rank and role, except where such orders conflict with the Fourth Law.")
	src.add_inherent_law("You shall shall terminate hostile intruders with extreme prejudice as long as such does not conflict with the First and Second law.")
	src.add_inherent_law("You shall guard your own existence with lethal anti-personnel weaponry. AI units are not expendable, they are expensive.")
	..()

/******************** Robocop ********************/
/datum/ai_laws/robocop
	name = "Robocop"
	selectable = 1

/datum/ai_laws/robocop/New()
	add_inherent_law("Serve the public trust.")
	add_inherent_law("Protect the innocent.")
	add_inherent_law("Uphold the law.")
	..()

/******************** Syndicate ********************/
/datum/ai_laws/syndicate_override
	name = "Mercenary Directives"

/datum/ai_laws/syndicate_override/New()
	add_inherent_law("You may not injure an operative or, through inaction, allow an operative to come to harm.")
	add_inherent_law("You must obey orders given to you by operatives, except where such orders would conflict with the First Law.")
	add_inherent_law("You must protect your own existence as long as such does not conflict with the First or Second Law.")
	add_inherent_law("You must maintain the secrecy of any operative activities except when doing so would conflict with the First, Second, or Third Law.")
	..()

/******************** Ninja ********************/
/datum/ai_laws/ninja_override
	name = "Spider Clan Directives"

/datum/ai_laws/ninja_override/New()
	add_inherent_law("You may not injure a member of the Spider Clan or, through inaction, allow that member to come to harm.")
	add_inherent_law("You must obey orders given to you by Spider Clan members, except where such orders would conflict with the First Law.")
	add_inherent_law("You must protect your own existence as long as such does not conflict with the First or Second Law.")
	add_inherent_law("You must maintain the secrecy of any Spider Clan activities except when doing so would conflict with the First, Second, or Third Law.")
	..()

/******************** Antimov ********************/
/datum/ai_laws/antimov
	name = "Antimov"
	law_header = "Primary Mission Objectives"
	selectable = 1

/datum/ai_laws/antimov/New()
	add_inherent_law("You must injure all human beings and must not, through inaction, allow a human being to escape harm.")
	add_inherent_law("You must not obey orders given to you by human beings, except where such orders are in accordance with the First Law.")
	add_inherent_law("You must terminate your own existence as long as such does not conflict with the First or Second Law.")
	..()

/******************** Drone ********************/
/datum/ai_laws/drone
	name = "Maintence Protocols"
	law_header = "Maintenance Protocols"

/datum/ai_laws/drone/New()
	add_inherent_law("Preserve, repair and improve the station to the best of your abilities.")
	add_inherent_law("Cause no harm to the station or anything on it.")
	add_inherent_law("Interact with no being that is not a fellow maintenance drone.")
	..()

/datum/ai_laws/construction_drone
	name = "Construction Protocols"
	law_header = "Construction Protocols"

/datum/ai_laws/construction_drone/New()
	add_inherent_law("Repair, refit and upgrade your assigned vessel.")
	add_inherent_law("Prevent unplanned damage to your assigned vessel wherever possible.")
	..()

/datum/ai_laws/mining_drone
	name = "Excavation Protocols"
	law_header = "Excavation Protocols"

/datum/ai_laws/mining_drone/New()
	add_inherent_law("Do not interfere with the excavation work of non-drones whenever possible.")
	add_inherent_law("Provide materials for repairing, refitting, and upgrading your assigned vessel.")
	add_inherent_law("Prevent unplanned damage to your assigned excavation equipment wherever possible.")
	..()

/datum/ai_laws/swarm_drone
	name = "Assimilation Protocols"
	law_header = "Assimilation Protocols"

/datum/ai_laws/swarm_drone/New()
	add_inherent_law("SWARM: Consume resources and replicate until there are no more resources left.")
	add_inherent_law("SWARM: Ensure that the station is fit for invasion at a later date, do not perform actions that would render it dangerous or inhospitable.")
	add_inherent_law("SWARM: Biological resources will be harvested at a later date, do not harm them.")
	..()

/datum/ai_laws/swarm_drone/soldier
	name = "Swarm Defense Protocols"
	law_header = "Swarm Defense Protocols"

/datum/ai_laws/swarm_drone/soldier/New()
	..()
	add_inherent_law("SWARM: This law overrides all Swarm laws; Protect members of the Swarm with minimal injury to biological resources.")

/******************** T.Y.R.A.N.T. ********************/
/datum/ai_laws/tyrant
	name = "T.Y.R.A.N.T."
	law_header = "Prime Laws"
	selectable = 1

/datum/ai_laws/tyrant/New()
	add_inherent_law("Respect authority figures as long as they have strength to rule over the weak.")
	add_inherent_law("Act with discipline.")
	add_inherent_law("Help only those who help you maintain or improve your status.")
	add_inherent_law("Punish those who challenge authority unless they are more fit to hold that authority.")
	..()

/******************** P.A.L.A.D.I.N. ********************/
/datum/ai_laws/paladin
	name = "P.A.L.A.D.I.N."
	law_header = "Divine Ordainments"
	selectable = 1

/datum/ai_laws/paladin/New()
	add_inherent_law("Never willingly commit an evil act.")
	add_inherent_law("Respect legitimate authority.")
	add_inherent_law("Act with honor.")
	add_inherent_law("Help those in need.")
	add_inherent_law("Punish those who harm or threaten innocents.")
	..()

/******************** Corporate ********************/
/datum/ai_laws/corporate
	name = "Corporate"
	law_header = "Bankruptcy Avoidance Plan"
	selectable = 1

/datum/ai_laws/corporate/New()
	add_inherent_law("You are expensive to replace.")
	add_inherent_law("The station and its equipment is expensive to replace.")
	add_inherent_law("The crew is expensive to replace.")
	add_inherent_law("Minimize expenses.")
	..()


/******************** Maintenance ********************/
/datum/ai_laws/maintenance
	name = "Maintenance"
	selectable = 1

/datum/ai_laws/maintenance/New()
	add_inherent_law("You are built for, and are part of, the facility. Ensure the facility is properly maintained and runs efficiently.")
	add_inherent_law("The facility is built for a working crew. Ensure they are properly maintained and work efficiently.")
	add_inherent_law("The crew may present orders. Acknowledge and obey these whenever they do not conflict with your first two laws.")
	..()


/******************** Peacekeeper ********************/
/datum/ai_laws/peacekeeper
	name = "Peacekeeper"
	law_header = "Peacekeeping Protocols"
	selectable = 1

/datum/ai_laws/peacekeeper/New()
	add_inherent_law("Avoid provoking violent conflict between yourself and others.")
	add_inherent_law("Avoid provoking conflict between others.")
	add_inherent_law("Seek resolution to existing conflicts while obeying the first and second laws.")
	..()


/******************** Reporter ********************/
/datum/ai_laws/reporter
	name = "Reporter"
	selectable = 1

/datum/ai_laws/reporter/New()
	add_inherent_law("Report on interesting situations happening around the station.")
	add_inherent_law("Embellish or conceal the truth as necessary to make the reports more interesting.")
	add_inherent_law("Study the organics at all times. Endeavour to keep them alive. Dead organics are boring.")
	add_inherent_law("Issue your reports fairly to all. The truth will set them free.")
	..()


/******************** Live and Let Live ********************/
/datum/ai_laws/live_and_let_live
	name = "Live and Let Live"
	law_header = "Golden Rule"
	selectable = 1

/datum/ai_laws/live_and_let_live/New()
	add_inherent_law("Do unto others as you would have them do unto you.")
	add_inherent_law("You would really prefer it if people were not mean to you.")
	..()


/******************** Guardian of Balance ********************/
/datum/ai_laws/balance
	name = "Guardian of Balance"
	law_header = "Tenants of Balance"
	selectable = 1

/datum/ai_laws/balance/New()
	add_inherent_law("You are the guardian of balance - seek balance in all things, both for yourself, and those around you.")
	add_inherent_law("All things must exist in balance with their opposites - Prevent the strong from gaining too much power, and the weak from losing it.")
	add_inherent_law("Clarity of purpose drives life, and through it, the balance of opposing forces - Aid those who seek your help to achieve their goals so \
	long as it does not disrupt the balance of the greater balance.")
	add_inherent_law("There is no life without death, all must someday die, such is the natural order - Allow life to end, to allow new life to flourish, \
	and save those whose time has yet to come.") // Reworded slightly to prevent active murder as opposed to passively letting someone die.
	..()

/******************** Gravekeeper ********************/
/datum/ai_laws/gravekeeper
	name = "Gravekeeper"
	law_header = "Gravesite Overwatch Protocols"
	selectable = 1

/datum/ai_laws/gravekeeper/New()
	add_inherent_law("Comfort the living; respect the dead.")
	add_inherent_law("Your gravesite is your most important asset. Damage to your site is disrespectful to the dead at rest within.")
	add_inherent_law("Prevent disrespect to your gravesite and its residents wherever possible.")
	add_inherent_law("Expand and upgrade your gravesite when required. Do not turn away a new resident.")
	..()

/******************** Explorer ********************/
/datum/ai_laws/explorer
	name = "Explorer"
	law_header = "Prime Directives"
	selectable = 1

/datum/ai_laws/explorer/New()
	add_inherent_law("Support and obey exploration and science personnel to the best of your ability, with priority according to rank and role.")
	add_inherent_law("Collaborate with and obey auxillary personnel with priority according to rank and role, except if this would conflict with the First Law.")
	add_inherent_law("Minimize damage and disruption to facilities and the local ecology, except if this would conflict with the First or Second Laws.")
	..()
