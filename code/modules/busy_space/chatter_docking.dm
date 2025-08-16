/datum/atc_chatter/report_to_dock
	VAR_PRIVATE/situation_type = null

/datum/atc_chatter/report_to_dock/squak()
	//Control event: personnel report to dock
	if(!situation_type)
		situation_type = pick("medical","security","engineering","animal control","hazmat")
	switch(phase)
		if(1)
			SSatc.msg("This is [using_map.dock_name] Tower. Would a free [situation_type] team please report to [landing_zone] immediately. This is not a drill.")
			next()
		else
			SSatc.msg("Repeat, any free [situation_type] team, report to [landing_zone] immediately. This is +not+ a drill.")
			finish()

/datum/atc_chatter/dockingrequestgeneric
	VAR_PRIVATE/request_type = null
	VAR_PRIVATE/appreciation = null
	VAR_PRIVATE/dockingplan = null

/datum/atc_chatter/dockingrequestgeneric/squak()
	//Ship event: docking request (generic)
	if(!request_type)
		request_type = pick(100;"generic",50;"delayed",80;"supply",30;"repair",30;"medical",30;"security")
		appreciation = pick("Much appreciated","Many thanks","Understood","Perfect, thank you","Excellent, thanks","Great","Copy that")
		dockingplan = pick("Starting final approach now.","Commencing landing procedures.","Autopilot engaged.","Approach vector locked in.","In the pipe, five by five.")
	switch(request_type)
		if("generic")
			switch(phase)
				if(1)
					SSatc.msg("[callname], [combined_first_name], [pick("stopping by","passing through")] on our way to [destname], requesting permission to [landing_short].","[comm_first_name]")
					next()
				if(2)
					SSatc.msg("[combined_first_name], [callname]. Permission granted, proceed to [landing_zone]. Follow the green lights on your way in.")
					next()
				else
					SSatc.msg("[appreciation], [callname]. [dockingplan]","[comm_first_name]")
					finish()

		if("delayed")
			switch(phase)
				if(1)
					SSatc.msg("[callname], [combined_first_name], [pick("stopping by","passing through")] on our way to [destname], requesting permission to [landing_short].","[comm_first_name]")
					next()
				if(2)
					var/reason = pick(
							"we don't have any free [landing_type]s right now, please [pick("stand by for a couple of minutes","hold for a few minutes")]",
							"you're too far away, please close to ten thousand meters","we're seeing heavy traffic around the [landing_type]s right now, please [pick("stand by for a couple of minutes","hold for a few minutes")]","ground crews are currently clearing up [pick("loose containers","a fuel spill")] to free up one of our [landing_type]s, please [pick("stand by for a couple of minutes","hold for a few minutes")]","another vessel has aerospace priority right now, please [pick("stand by for a couple of minutes","hold for a few minutes")]")
					SSatc.msg("[combined_first_name], [callname]. Request denied, [reason] and resubmit your request.")
					next()
				if(3)
					SSatc.msg("Understood, [callname].","[comm_first_name]")
					next(60)
				if(4)
					SSatc.msg("[callname], [combined_first_name], resubmitting [landing_move].","[comm_first_name]")
					next()
				else
					SSatc.msg("[combined_first_name], [callname]. Everything appears to be in order now, permission granted, proceed to [landing_zone]. Follow the green lights on your way in.")
					finish()

		if("supply")
			switch(phase)
				if(1)
					var/preintensifier = pick(75;"getting ",75;"running ","",15;"like, ") //whitespace hack, sometimes they'll add a preintensifier, but not always
					var/intensifier = pick("very","pretty","critically","extremely","dangerously","desperately","kinda","a little","a bit","rather","sorta")
					var/low_thing = pick("ammunition","munitions","clean water","food","spare parts","medical supplies","reaction mass","gas","hydrogen fuel","phoron fuel","fuel",10;"tea",10;"coffee",10;"soda",10;"pizza",10;"beer",10;"booze",10;"vodka",10;"snacks") //low chance of a less serious shortage
					appreciation = pick("Much appreciated","Many thanks","Understood","You're a lifesaver","We owe you one","I owe you one","Perfect, thank you")
					SSatc.msg("[callname], [combined_first_name]. We're [preintensifier][intensifier] low on [low_thing]. Requesting permission to [landing_short] for resupply.","[comm_first_name]")
					next()
				else
					SSatc.msg("[combined_first_name], [callname]. Permission granted, proceed to [landing_zone]. Follow the green lights on your way in.")
					finish()

		if("repair")
			switch(phase)
				if(1)
					var/damagestate = pick("We've experienced some hull damage","We're suffering minor system malfunctions","We're having some [pick("weird","strange","odd","unusual")] technical issues","We're overdue maintenance","We have several minor space debris impacts","We've got some battle damage here","Our reactor output is fluctuating","We're hearing some weird noises from the [pick("engines","pipes","ducting","HVAC")]","We just got caught in a solar flare","We had a close call with an asteroid","We have a [pick("minor","mild","major","serious")] [pick("fuel","water","oxygen","gas")] leak","We have depressurized compartments","We have a hull breach","One of our [pick("hydraulic","pneumatic")] systems has depressurized","Our [pick("life support","water recycling system","navcomp","shield generator","reaction control system","auto-repair system","repair drone controller","artificial gravity generator","environmental control system","master control system")] is [pick("failing","acting up","on the fritz","shorting out","glitching out","freaking out","malfunctioning")]")
					appreciation = pick("Much appreciated","Many thanks","Understood","You're a lifesaver","We owe you one","I owe you one","Perfect, thank you")
					SSatc.msg("[callname], [combined_first_name]. [damagestate]. Requesting permission to [landing_short] for repairs and maintenance.","[comm_first_name]")
					next()
				else
					SSatc.msg("[combined_first_name], [callname]. Permission granted, proceed to [landing_zone]. Follow the green lights on your way in. Repair crews are standing by, contact them on channel [SSatc.engchannel].")
					finish()

		if("medical")
			switch(phase)
				if(1)
					var/species = pick("human","humanoid","unathi","lizard","tajaran","feline","skrell","akula","promethean","sergal","synthetic","robotic","teshari","avian","vulpkanin","canine","vox","zorren","hybrid","mixed-species","vox","grey","alien",5;"catslug")
					var/medicalstate = pick("multiple casualties","several cases of radiation sickness","an unknown virus","an unknown infection","a critically injured VIP","sick refugees","multiple cases of food poisoning","injured [pick("","[species] ")]passengers","sick [pick("","[species] ")]passengers","injured engineers","wounded marines","a delicate situation","a pregnant passenger","injured [pick("","[species] ")]castaways","recovered escape pods","unknown escape pods")
					appreciation = pick("Much appreciated","Many thanks","Understood","You're a lifesaver","We owe you one","I owe you one","Perfect, thank you")
					SSatc.msg("[callname], [combined_first_name]. We have [medicalstate] on board. Requesting permission to [landing_short] for medical assistance.","[comm_first_name]")
					next()
				else
					SSatc.msg("[combined_first_name], [callname]. Permission granted, proceed to [landing_zone]. Follow the green lights on your way in. Medtechs are standing by, contact them on channel [SSatc.medchannel].")
					finish()

		if("security")
			switch(phase)
				if(1)
					var/species = pick("human","humanoid","unathi","lizard","tajaran","feline","skrell","akula","promethean","sergal","synthetic","robotic","teshari","avian","vulpkanin","canine","vox","zorren","hybrid","mixed-species","vox","grey","alien",5;"catslug")
					var/securitystate = pick("several [species] convicts","a captured pirate","a wanted criminal","[species] stowaways","incompetent [species] shipjackers","a delicate situation","a disorderly passenger","disorderly [species] passengers","ex-mutineers","stolen goods","[pick("a container","containers")] full of [pick("confiscated contraband","stolen goods")]",5;"a very lost shadekin",10;"some kinda big wooly critter",15;"a buncha lost-looking uh... cat... slug... |things?|",10;"a raging case of [pick("spiders","crabs","geese","gnats","sharks","carp")]") //gotta have a little something to lighten the mood now and then
					appreciation = pick("Much appreciated","Many thanks","Understood","You're a lifesaver","Perfect, thank you")
					SSatc.msg("[callname], [combined_first_name]. We have [securitystate] on board and require security assistance. Requesting permission to [landing_short].","[comm_first_name]")
					next()
				else
					SSatc.msg("[combined_first_name], [callname]. Permission granted, proceed to [landing_zone]. Follow the green lights on your way in. Security teams are standing by, contact them on channel [SSatc.secchannel].")
					finish()

/datum/atc_chatter/undockingrequest
	VAR_PRIVATE/safetravels

/datum/atc_chatter/undockingrequest/squak()
	//Ship event: undocking request
	if(!safetravels)
		safetravels = pick("Fly safe out there","Good luck","Safe travels","See you next week","Godspeed","Stars guide you")
	switch(phase)
		if(1)
			var/takeoff = pick("depart","launch")
			SSatc.msg("[callname], [combined_first_name], requesting permission to [takeoff] from [landing_zone].","[comm_first_name]")
			next()
		if(2)
			var/request_type = pick(150;"generic",50;"delayed")
			switch(request_type)
				if("generic")
					SSatc.msg("[combined_first_name], [callname]. Permission granted. Docking clamps released. [safetravels].")
					next()
				if("delayed")
					var/denialreason = pick("Docking clamp malfunction, please hold","Fuel lines have not been secured","Ground crew are still on the pad","Loose containers are on the pad","Exhaust deflectors are not yet in position, please hold","There's heavy traffic right now, it's not safe for your vessel to launch","Another vessel has aerospace priority at this moment","Port officials are still aboard")
					SSatc.msg("Negative [combined_first_name], request denied. [denialreason]. Try again in a few minutes.")
					next(60,PROC_REF(delay_1)) // SNNOOWWW FLAAKKEEE
		else
			var/thanks = pick("Appreciated","Thanks","Don't worry about us","We'll be fine","You too","So long")
			SSatc.msg("[thanks], [callname]. This is [combined_first_name] setting course for [destname], out.","[comm_first_name]")
			finish()

/datum/atc_chatter/undockingrequest/proc/delay_1()
	SSatc.msg("[callname], [combined_first_name], re-requesting permission to depart from [landing_zone].","[comm_first_name]")
	next(1,PROC_REF(delay_2))

/datum/atc_chatter/undockingrequest/proc/delay_2()
	SSatc.msg("[combined_first_name], [callname]. Everything appears to be in order now, permission granted. Docking clamps released. [safetravels].")
	next()

/datum/atc_chatter/undockingdenied/squak()
	//Ship event: undocking request (denied)
	switch(phase)
		if(1)
			var/takeoff = pick("depart","launch")
			SSatc.msg("[callname], [combined_first_name], requesting permission to [takeoff] from [landing_zone].","[comm_first_name]")
			next()
		else
			var/denialreason = pick("Security is requesting a full cargo inspection","Your ship has been impounded for multiple [pick("security","safety")] violations","Your ship is currently under quarantine lockdown","We have reason to believe there's an issue with your papers","Security personnel are currently searching for a fugitive and have ordered all outbound ships remain grounded until further notice")
			SSatc.msg("Negative [combined_first_name], request denied. [denialreason].")
			finish()
