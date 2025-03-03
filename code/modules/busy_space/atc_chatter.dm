//minimum and maximum message delays, typically tracked in seconds
#define MIN_MSG_DELAY 3
#define MAX_MSG_DELAY 6

/datum/atc_chatter
	VAR_PROTECTED/phase = 1 // phase of dialog being displayed
	// Docks and zones
	VAR_PROTECTED/yes = FALSE
	VAR_PROTECTED/request = ""
	VAR_PROTECTED/callname = ""
	VAR_PROTECTED/response = ""
	VAR_PROTECTED/number = 1
	VAR_PROTECTED/zone = ""
	VAR_PROTECTED/landing_zone = ""
	VAR_PROTECTED/landing_type = ""
	VAR_PROTECTED/landing_move = ""
	VAR_PROTECTED/landing_short = ""
	// Ship identities
	VAR_PROTECTED/name = ""
	VAR_PROTECTED/owner = ""
	VAR_PROTECTED/prefix = ""
	VAR_PROTECTED/firstid = ""
	VAR_PROTECTED/mission = ""
	VAR_PROTECTED/shipname = ""
	VAR_PROTECTED/destname = ""
	VAR_PROTECTED/slogan = ""
	VAR_PROTECTED/org_type = ""
	// Second ship identity
	VAR_PROTECTED/secondname = ""
	VAR_PROTECTED/secondowner = ""
	VAR_PROTECTED/secondprefix = ""
	VAR_PROTECTED/secondid = ""
	VAR_PROTECTED/secondshipname = ""
	VAR_PROTECTED/org_type2 = ""
	// Combined data
	VAR_PROTECTED/combined_first_name = ""
	VAR_PROTECTED/short_first_name = ""
	VAR_PROTECTED/comm_first_name = ""
	VAR_PROTECTED/combined_second_name = ""
	VAR_PROTECTED/comm_second_name = ""
	VAR_PROTECTED/short_second_name = ""
	VAR_PROTECTED/mission_noun = ""

/datum/atc_chatter/New(var/datum/lore/organization/source, var/datum/lore/organization/secondary)
	if(source && secondary) // Evac shuttle atc passes nothing in and only uses map datum for names!
		/////////////////////////////////////////////////////////////////////
		// Get the docking bay or zone in space the ships are passing into
		/////////////////////////////////////////////////////////////////////
		//First response is 'yes', second is 'no'
		var/requests = list(
					"special flight rules" = list("authorizing special flight rules", "denying special flight rules, not allowed for your traffic class"),
					"current solar weather info" = list("sending you the relevant information via tightbeam", "your request has been queued, stand by"),
					"sector aerospace priority" = list("affirmative, sector aerospace priority is yours", "negative, another vessel in your sector has priority right now"),
					"system traffic info" = list("sending you current traffic info", "request queued, please hold"),
					"refueling information" = list("sending refueling information now", "depots currently experiencing fuel shortages, advise you move on"),
					"a current system time sync" = list("sending time sync ping to you now", "your ship isn't compatible with our time sync, set time manually"),
					"current system starcharts" = list("transmitting current starcharts", "your request is queued, overloaded right now")
					)
		request = pick(requests)
		yes = prob(90) //Chance for them to say yes vs no
		callname = "[using_map.dock_name] Control"
		response = requests[request][yes ? 1 : 2] //1 is yes, 2 is no
		number = rand(1,42)
		zone = pick("Alpha","Beta","Gamma","Delta","Epsilon","Zeta","Eta","Theta","Iota","Kappa","Lambda","Mu","Nu","Xi","Omicron","Pi","Rho","Sigma","Tau","Upsilon","Phi","Chi","Psi","Omega")
		//fallbacks in case someone sets the dock_type on the map datum to null- it defaults to "station" normally
		landing_zone = "LZ [zone]"
		landing_type = "landing zone"
		landing_move = "landing request"
		landing_short = "land"
		switch(using_map.dock_type)
			if("surface")		//formal installations with proper facilities
				landing_zone = "landing pad [number]"
				landing_type = "landing pad"
				landing_move = "landing request"
				landing_short = "land"
				callname = "[using_map.dock_name] Tower"
			if("frontier")		//for frontier bases - landing spots are literally just open ground, maybe concrete at best
				landing_zone = "LZ [zone]"
				landing_type = "landing zone"
				landing_move = "landing request"
				landing_short = "land"
				callname = "[using_map.dock_name] Tower"
			if("station")		//standard station pattern
				landing_zone = "docking bay [number]"
				landing_type = "docking bay"
				landing_move = "docking request"
				landing_short = "dock"
				callname = "[using_map.dock_name] Control"

		/////////////////////////////////////////////////////////////////////
		// Construct the two ships involved from their loremaster organization data
		/////////////////////////////////////////////////////////////////////
		//Let's get some mission parameters, pick our first ship
		name = source.name					//get the name
		owner = source.short_name				//Use the short name
		prefix = pick(source.ship_prefixes)			//Pick a random prefix
		firstid = "[rand(0,9)][rand(0,9)][rand(0,9)][rand(0,9)]"
		mission = source.ship_prefixes[prefix]		//The value of the prefix is the mission type that prefix does
		shipname = pick(source.ship_names)			//Pick a random ship name
		destname = pick(source.destination_names)		//destination is where?
		slogan = pick(source.slogans)			//god help you all
		org_type = source.org_type				//which group do we belong to?
		//pick our second ship
		secondname = secondary.name			//not used atm, commented out to suppress errors
		secondowner = secondary.short_name
		secondprefix = pick(secondary.ship_prefixes)	//Pick a random prefix
		secondid = "[rand(0,9)][rand(0,9)][rand(0,9)][rand(0,9)]"
		secondshipname = pick(secondary.ship_names)		//Pick a random ship name
		org_type2 = secondary.org_type

		//DEBUG BLOCK
		//to_world("DEBUG OUTPUT 1: [name], [owner], [prefix], [firstid], [mission], [shipname], [org_type], [destname]")
		//to_world("DEBUG OUTPUT 2: [secondowner], [secondprefix], [secondid], [secondshipname], [org_type2]")
		//to_world("DEBUG OUTPUT 3: Chose [chatter_type]")
		//DEBUG BLOCK ENDS

		combined_first_name = "[prefix] [firstid] |[shipname]|"	//formal traffic control identifier for use in messages
		short_first_name = "[prefix] |[shipname]|"	//special variant for certain events
		comm_first_name = "[owner] [shipname]"	//corpname + shipname for speaker identity in log
		combined_second_name = "[secondprefix] [secondid] |[secondshipname]|"
		comm_second_name = "[secondowner] [secondshipname]"
		short_second_name = "[secondprefix] |[secondshipname]|"	//not actually used for now

		mission_noun = pick(source.flight_types)		//pull from a list of owner-specific flight ops, to allow an extra dash of flavor
		if(source.complex_tasks)				//if our source has the complex_tasks flag, regenerate with a two-stage assignment
			mission_noun = "[pick(source.task_types)] [pick(source.flight_types)]"

	// Get the ball rolling
	squak()

/datum/atc_chatter/proc/squak()
	PROTECTED_PROC(TRUE)
	// calls acknowledge at each message phase until final, where it qdel(src)
	return

/datum/atc_chatter/proc/next(var/multiplier = 1,var/pr_ref = null)
	SHOULD_NOT_OVERRIDE(TRUE)
	PROTECTED_PROC(TRUE)
	if(!pr_ref) // don't advance the section unless we actually call squak(), otherwise it's a submessage override
		pr_ref = PROC_REF(squak)
		phase++ // next
	addtimer(CALLBACK(src, pr_ref), (rand(MIN_MSG_DELAY,MAX_MSG_DELAY) SECONDS) * multiplier)

/datum/atc_chatter/proc/finish() // Override me if you have any cleanup to do
	SHOULD_CALL_PARENT(TRUE)
	PROTECTED_PROC(TRUE)
	qdel(src)

#undef MIN_MSG_DELAY
#undef MAX_MSG_DELAY
