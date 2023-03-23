//Cactus, Speedbird, Dynasty, oh my
//Also, massive additions/refactors by Killian, because the original incarnation was full of holes

var/datum/lore/atc_controller/atc = new/datum/lore/atc_controller

/datum/lore/atc_controller
	var/delay_min = 45 MINUTES			//How long between ATC traffic, minimum
	var/delay_max = 90 MINUTES			//Ditto, maximum
							//Shorter delays means more traffic, which gives the impression of a busier system, but also means a lot more radio noise
	var/backoff_delay = 5 MINUTES			//How long to back off if we can't talk and want to.  Default is 5 mins.
	var/initial_delay = 15 MINUTES			//How long to wait before sending the first message of the shift.
	var/next_message = 45 MINUTES			//When the next message should happen in world.time - Making it default to min value
	var/force_chatter_type				//Force a specific type of messages

	var/squelched = 0				//If ATC is squelched currently

	//define a block of frequencies so we can have them be static instead of being random for each call
	var/ertchannel
	var/medchannel
	var/engchannel
	var/secchannel
	var/sdfchannel

/datum/lore/atc_controller/New()
	//generate our static event frequencies for the shift. alternately they can be completely fixed, up in the core block
	ertchannel = "[rand(700,749)].[rand(1,9)]"
	medchannel = "[rand(750,799)].[rand(1,9)]"
	engchannel = "[rand(800,849)].[rand(1,9)]"
	secchannel = "[rand(850,899)].[rand(1,9)]"
	sdfchannel = "[rand(900,999)].[rand(1,9)]"
	spawn(450 SECONDS) //Lots of lag at the start of a shift. Yes, the following lines *have* to be indented or they're not delayed by the spawn properly.
		msg("New shift beginning, resuming traffic control. This shift's Colony Frequencies are as follows: Emergency Responders: [ertchannel]. Medical: [medchannel]. Engineering: [engchannel]. Security: [secchannel]. System Defense: [sdfchannel].")
		next_message = world.time + initial_delay
		process()

/datum/lore/atc_controller/process()
	if(world.time >= next_message)
		if(squelched)
			next_message = world.time + backoff_delay
		else
			next_message = world.time + rand(delay_min,delay_max)
			random_convo()

	spawn(1 MINUTE) //We don't really need high-accuracy here.
		process()

/datum/lore/atc_controller/proc/msg(var/message,var/sender)
	ASSERT(message)
	global_announcer.autosay("[message]", sender ? sender : "[using_map.dock_name] Control")

/datum/lore/atc_controller/proc/reroute_traffic(var/yes = 1)
	if(yes)
		if(!squelched)
			msg("Rerouting traffic away from [using_map.station_name].")
		squelched = 1
	else
		if(squelched)
			msg("Resuming normal traffic routing around [using_map.station_name].")
		squelched = 0

/datum/lore/atc_controller/proc/shift_ending(var/evac = 0)
	msg("[using_map.shuttle_name], this is [using_map.dock_name] Control, you are cleared to complete routine transfer from [using_map.station_name] to [using_map.dock_name].")
	sleep(5 SECONDS)
	msg("[using_map.shuttle_name] departing [using_map.dock_name] for [using_map.station_name] on routine transfer route. Estimated time to arrival: ten minutes.","[using_map.shuttle_name]")

/datum/lore/atc_controller/proc/random_convo()
	var/one = pick(loremaster.organizations) //These will pick an index, not an instance
	var/two = pick(loremaster.organizations)

	var/datum/lore/organization/source = loremaster.organizations[one] //Resolve to the instances
	var/datum/lore/organization/secondary = loremaster.organizations[two] //repurposed for new fun stuff

	//Let's get some mission parameters, pick our first ship
	var/name = source.name					//get the name
	var/owner = source.short_name				//Use the short name
	var/prefix = pick(source.ship_prefixes)			//Pick a random prefix
	var/mission = source.ship_prefixes[prefix]		//The value of the prefix is the mission type that prefix does
	var/shipname = pick(source.ship_names)			//Pick a random ship name
	var/destname = pick(source.destination_names)		//destination is where?
	var/slogan = pick(source.slogans)			//god help you all
	var/org_type = source.org_type				//which group do we belong to?

	//pick our second ship
	//var/secondname = secondary.name			//not used atm, commented out to suppress errors
	var/secondowner = secondary.short_name
	var/secondprefix = pick(secondary.ship_prefixes)	//Pick a random prefix
	var/secondshipname = pick(secondary.ship_names)		//Pick a random ship name
	var/org_type2 = secondary.org_type

	var/combined_first_name = "[owner][prefix] |[shipname]|"
	var/combined_second_name = "[secondowner][secondprefix] |[secondshipname]|"

	var/alt_atc_names = list("[using_map.dock_name] Traffic Control","[using_map.dock_name] TraCon","[using_map.dock_name] System Control","[using_map.dock_name] Star Control","[using_map.dock_name] SysCon","[using_map.dock_name] Tower","[using_map.dock_name] Control","[using_map.dock_name] STC","[using_map.dock_name] StarCon")
	var/mission_noun = pick(source.flight_types)		//pull from a list of owner-specific flight ops, to allow an extra dash of flavor
	if(source.complex_tasks)				//if our source has the complex_tasks flag, regenerate with a two-stage assignment
		mission_noun = "[pick(source.task_types)] [pick(source.flight_types)]"

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

	//Random chance things for variety
	var/chatter_type = "normal"
	if(force_chatter_type)
		chatter_type = force_chatter_type
	else if((org_type == "government" || org_type == "neutral" || org_type == "military" || org_type == "corporate" || org_type == "system defense") && org_type2 == "pirate") //this is ugly but when I tried to do it with !='s it fired for pirate-v-pirate, still not sure why. might as well stick it up here so it takes priority over other combos.
		chatter_type = "distress"
	else if(org_type == "corporate") //corporate-specific subset for the slogan event. despite the relatively high weight it was still quite rare in tests.
		chatter_type = pick(5;"emerg",25;"policescan",25;"traveladvisory",30;"pathwarning",30;"dockingrequestgeneric",30;"dockingrequestdenied",30;"dockingrequestdelayed",30;"dockingrequestsupply",30;"dockingrequestrepair",30;"dockingrequestmedical",30;"dockingrequestsecurity",30;"undockingrequest","normal",30;"undockingdenied",30;"undockingdelayed",300;"slogan")
	else if((org_type == "government" || org_type == "neutral" || org_type == "military"))
		chatter_type = pick(5;"emerg",25;"policescan",25;"traveladvisory",30;"pathwarning",30;"dockingrequestgeneric",30;"dockingrequestdenied",30;"dockingrequestdelayed",30;"dockingrequestsupply",30;"dockingrequestrepair",30;"dockingrequestmedical",30;"dockingrequestsecurity",30;"undockingrequest","normal",30;"undockingdenied",30;"undockingdelayed")
	else if(org_type == "spacer")
		chatter_type = pick(5;"emerg",15;"policescan",15;"traveladvisory",5;"pathwarning",10;"dockingrequestgeneric",30;"dockingrequestdenied",10;"dockingrequestdelayed",30;"dockingrequestsupplly",10;"dockingrequestrepair",20;"dockingrequestmedical",20;"dockingrequestsecurity",30;"undockingrequest","normal",10;"undockingdenied",30;"undockingdelayed")

	//the following filters *always* fire their 'unique' event when they're tripped, simply because the conditions behind them are quite rare to begin with
	else if(org_type == "smuggler" && org_type2 != "system defense") //just straight up funnel smugglers into always being caught, otherwise we get them asking for traffic info and stuff
		chatter_type = "policeflee"
	else if(org_type == "smuggler" && org_type2 == "system defense") //ditto, if an SDF ship catches them
		chatter_type = "policeshipflee"
	else if((org_type == "smuggler" || org_type == "pirate") && org_type2 == "system defense") //if we roll this combo instead, time for the SDF to do their fucking job
		chatter_type = "policeshipcombat"
	else if((org_type == "smuggler" || org_type == "pirate") && org_type2 != "system defense") //but if we roll THIS combo, time to alert the SDF to get off their asses
		chatter_type = "hostiledetected"
	//SDF-specific events that need to filter based on the second party (basically just the following SDF-unique list with the soft-result ship scan thrown in)
	else if(org_type == "system defense" && (org_type == "government" || org_type == "neutral" || org_type == "military" || org_type == "corporate")) //let's see if we can narrow this down, I didn't see many ship-to-ship scans
		chatter_type = pick(75;"policeshipscan","sdfpatrolupdate",75;"sdfendingpatrol",30;"dockingrequestgeneric",30;"dockingrequestdelayed",30;"dockingrequestsupply",30;"dockingrequestrepair",30;"dockingrequestmedical",30;"dockingrequestsecurity",20;"undockingrequest",75;"sdfbeginpatrol",50;"normal")
	//SDF-specific events that don't require the secondary at all, in the event that we manage to roll SDF + hostile/smuggler or something
	else if(org_type == "system defense")
		chatter_type = pick("sdfpatrolupdate",60;"sdfendingpatrol",30;"dockingrequestgeneric",30;"dockingrequestdelayed",30;"dockingrequestsupply",30;"dockingrequestrepair",30;"dockingrequestmedical",30;"dockingrequestsecurity",20;"undockingrequest",80;"sdfbeginpatrol","normal")
	//if we somehow don't match any of the other existing filters once we've run through all of them
	else
		chatter_type = pick(5;"emerg",25;"policescan",25;"traveladvisory",30;"pathwarning",30;"dockingrequestgeneric",30;"dockingrequestdelayed",30;"dockingrequestdenied",30;"dockingrequestsupply",30;"dockingrequestrepair",30;"dockingrequestmedical",30;"dockingrequestsecurity",30;"undockingrequest",30;"undockingdenied",30;"undockingdelayed","normal")
	//I probably should do some kind of pass here to work through all the possible combinations of major factors and see if the filtering list needs reordering or modifying, but I really can't be arsed

	//DEBUG BLOCK
	//to_world("DEBUG OUTPUT 1: [name], [owner], [prefix], [mission], [shipname], [org_type], [destname]")
	//to_world("DEBUG OUTPUT 2: [secondowner], [secondprefix], [secondshipname], [org_type2]")
	//to_world("DEBUG OUTPUT 3: Chose [chatter_type]")
	//DEBUG BLOCK ENDS

	var/yes = prob(90) //Chance for them to say yes vs no

	var/request = pick(requests)
	var/callname = pick(alt_atc_names)
	var/response = requests[request][yes ? 1 : 2] //1 is yes, 2 is no
	var/number = rand(1,42)
	var/zone = pick("Alpha","Beta","Gamma","Delta","Epsilon","Zeta","Eta","Theta","Iota","Kappa","Lambda","Mu","Nu","Xi","Omicron","Pi","Rho","Sigma","Tau","Upsilon","Phi","Chi","Psi","Omega")
	//fallbacks in case someone sets the dock_type on the map datum to null- it defaults to "station" normally
	var/landing_zone = "LZ [zone]"
	var/landing_move = "landing request"
	var/landing_short = "land"
	switch(using_map.dock_type)
		if("surface")		//formal installations with proper facilities
			landing_zone = "landing pad [number]"
			landing_move = "landing request"
			landing_short = "land"
		if("frontier")		//for frontier bases - landing spots are literally just open ground, maybe concrete at best
			landing_zone = "LZ [zone]"
			landing_move = "landing request"
			landing_short = "land"
		if("station")		//standard station pattern
			landing_zone = "docking bay [number]"
			landing_move = "docking request"
			landing_short = "dock"

	// what you're about to witness is what feels like an extremely kludgy rework of the system, but it's more 'flexible' and allows events that aren't just ship-stc-ship
	// something more elegant could probably be done, but it won't be done by somebody as half-competent as me
	switch(chatter_type)
		//mayday call
		if("emerg")
			var/problem = pick("We have hull breaches on multiple decks","We have unknown hostile life forms on board","Our primary drive is failing","We have [pick("asteroids","space debris")] impacting the hull","We're experiencing a total loss of engine power","We have hostile ships closing fast","There's smoke in the cockpit","We have unidentified boarders","Our RCS are malfunctioning and we're losing stability","Our life support [pick("is failing","has failed")]")
			msg("+Mayday, mayday, mayday!+ This is [combined_first_name] declaring an emergency! [problem]!","[prefix] [shipname]")
			sleep(5 SECONDS)
			msg("[combined_first_name], this is [using_map.dock_name] Control, copy. Switch to emergency responder channel [ertchannel].")
			sleep(5 SECONDS)
			msg("Understood [using_map.dock_name] Control, switching now.","[prefix] [shipname]")
		//Control scan event: soft outcome
		if("policescan")
			var/confirm = pick("Understood","Roger that","Affirmative","Very well","Copy that")
			var/complain = pick("I hope this doesn't take too long.","Can we hurry this up?","Make it quick.","This better not take too long.","Is this really necessary?")
			var/completed = pick("You're free to proceed.","Everything looks fine, carry on.","You're clear, move along.","Apologies for the delay, you're clear.","Switch to channel [sdfchannel] and await further instruction.")
			msg("[combined_first_name], this is [using_map.dock_name] Control, your [pick("ship","vessel","starship")] has been flagged for routine inspection. Hold position and prepare to be scanned.")
			sleep(5 SECONDS)
			msg("[confirm] [using_map.dock_name] Control, holding position.","[prefix] [shipname]")
			sleep(5 SECONDS)
			msg("Your compliance is appreciated, [combined_first_name]. Scan commencing.")
			sleep(10 SECONDS)
			msg(complain,"[prefix] [shipname]")
			sleep(15 SECONDS)
			msg("[combined_first_name], this is [using_map.dock_name] Control. Scan complete. [completed]")
		//Control scan event: hard outcome
		if("policeflee")
			var/uhoh = pick("No can do chief, we got places to be.","Sorry but we've got places to be.","Not happening.","Ah fuck, who ratted us out this time?!","You'll never take me alive!","Hey, I have a cloaking device! You can't see me!","I'm going to need to ask for a refund on that stealth drive...","I'm afraid I can't do that, Control.","Ah |hell|.","Fuck!","This isn't the ship you're looking for.","Well. This is awkward.","Uh oh.","I surrender!")
			msg("Unknown [pick("ship","vessel","starship")], this is [using_map.dock_name] Control, identify yourself and submit to a full inspection. Flying without an active transponder is a violation of interstellar shipping regulations.")
			sleep(5 SECONDS)
			msg("[uhoh]","[shipname]")
			sleep(5 SECONDS)
			msg("This is [using_map.starsys_name] Defense Control to all local assets: vector to interdict and detain [combined_first_name]. Control out.","[using_map.starsys_name] Defense Control")
		//SDF scan event: soft outcome
		if("policeshipscan")
			var/confirm = pick("Understood","Roger that","Affirmative")
			var/complain = pick("I hope this doesn't take too long.","Can we hurry this up?","Make it quick.","This better not take too long.","Is this really necessary?")
			var/completed = pick("You're free to proceed.","Everything looks fine, carry on.","You're clear. Move along.","Apologies for the delay, you're clear.","Switch to channel [sdfchannel] and await further instruction.")
			msg("[combined_second_name], this is [combined_first_name], your [pick("ship","vessel","starship")] has been flagged for routine inspection. Hold position and prepare to be scanned.","[prefix] [shipname]")
			sleep(5 SECONDS)
			msg("[confirm] [combined_first_name], holding position.","[secondprefix] [secondshipname]")
			sleep(5 SECONDS)
			msg("Your compliance is appreciated, [combined_second_name]. Scan commencing.","[prefix] [shipname]")
			sleep(10 SECONDS)
			msg(complain,"[secondprefix] [secondshipname]")
			sleep(15 SECONDS)
			msg("[combined_second_name], this is [combined_first_name]. Scan complete. [completed]","[prefix] [shipname]")
		//SDF scan event: hard outcome
		if("policeshipflee")
			var/uhoh = pick("No can do chief, we got places to be.","Sorry but we've got places to be.","Not happening.","Ah fuck, who ratted us out this time?!","You'll never take me alive!","Hey, I have a cloaking device! You can't see me!","I'm going to need to ask for a refund on that stealth drive...","I'm afraid I can't do that, |[shipname]|.","Ah |hell|.","Fuck!","This isn't the ship you're looking for.","Well. This is awkward.","Uh oh.","I surrender!")
			msg("Unknown [pick("ship","vessel","starship")], this is [combined_second_name], identify yourself and submit to a full inspection. Flying without an active transponder is a violation of interstellar shipping regulations.","[secondprefix] [secondshipname]")
			sleep(5 SECONDS)
			msg("[uhoh]","[shipname]")
			sleep(5 SECONDS)
			msg("[using_map.starsys_name] Defense Control, this is [combined_second_name]. We have a situation here, please advise.","[secondprefix] [secondshipname]")
			sleep(5 SECONDS)
			msg("Defense Control copies, [combined_second_name], reinforcements are en route. Switch further communications to encrypted band [sdfchannel].","[using_map.starsys_name] Defense Control")
		//SDF scan event: engage primary in combat! fairly rare since it needs a pirate/vox + SDF roll
		if("policeshipcombat")
			var/battlestatus = pick("requesting reinforcements.","we need backup! Now!","holding steady.","we're holding our own for now.","we have them on the run.","they're trying to make a run for it!","we have them right where we want them.","we're badly outgunned!","we have them outgunned.","we're outnumbered here!","we have them outnumbered.","this'll be a cakewalk.",10;"notify their next of kin.")
			msg("[using_map.starsys_name] Defense Control, this is [combined_second_name], engaging [combined_first_name] [pick("near route","in sector")] [rand(1,100)], [battlestatus]","[secondprefix] [secondshipname]")
			sleep(5 SECONDS)
			msg("[using_map.starsys_name] Defense Control copies, [combined_second_name]. Keep us updated.","[using_map.starsys_name] Defense Control")
		//SDF event: patrol update
		if("sdfpatrolupdate")
			var/statusupdate = pick("nothing unusual so far","nothing of note","everything looks clear so far","ran off some [pick("pirates","marauders")] near route [pick(1,100)], [pick("no","minor")] damage sustained, continuing patrol","situation normal, no suspicious activity yet","minor incident on route [pick(1,100)]","Code 7-X [pick("on route","in sector")] [pick(1,100)], situation is under control","seeing a lot of traffic on route [pick(1,100)]","caught a couple of smugglers [pick("on route","in sector")] [pick(1,100)]","sustained some damage in a skirmish just now, we're heading back for repairs")
			msg("[using_map.starsys_name] Defense Control, this is [combined_first_name] reporting in, [statusupdate], over.","[prefix] [shipname]")
			sleep(5 SECONDS)
			msg("[using_map.starsys_name] Defense Control copies, [combined_first_name]. Keep us updated, out.","[using_map.starsys_name] Defense Control")
		//SDF event: end patrol
		if("sdfendingpatrol")
			var/appreciation = pick("Copy","Understood","Affirmative","10-4","Roger that")
			var/dockingplan = pick("Starting final approach now.","Commencing landing procedures.","Autopilot engaged.","Approach vector locked in.","In the pipe, five by five.")
			msg("[callname], this is [combined_first_name], returning from our system patrol route, requesting permission to [landing_short].","[prefix] [shipname]")
			sleep(5 SECONDS)
			msg("[combined_first_name], this is [using_map.dock_name] Control. Permission granted, proceed to [landing_zone]. Follow the green lights on your way in.")
			sleep(5 SECONDS)
			msg("[appreciation], [using_map.dock_name] Control. [dockingplan]","[prefix] [shipname]")
		//DefCon event: hostile found
		if("hostiledetected")
			var/orders = pick("Engage on sight","Engage with caution","Engage with extreme prejudice","Engage at will","Search and destroy","Bring them in alive, if possible","Interdict and detain","Keep your eyes peeled","Bring them in, dead or alive","Stay alert")
			msg("This is [using_map.starsys_name] Defense Control to all SDF assets. Priority update follows.","[using_map.starsys_name] Defense Control")
			sleep(5 SECONDS)
			msg("Be on the lookout for [combined_first_name], last sighted near route [rand(1,100)]. [orders]. DefCon, out.","[using_map.starsys_name] Defense Control")
		//Ship event: distress call, under attack
		if("distress")
			msg("+Mayday, mayday, mayday!+ This is [combined_first_name] declaring an emergency! We are under attack by [combined_second_name]! Requesting immediate assistance!","[prefix] [shipname]")
			sleep(5 SECONDS)
			msg("[combined_first_name], this is [using_map.starsys_name] Defense Control, copy. SDF is en route, contact on [sdfchannel].")
			sleep(5 SECONDS)
			msg("Understood [using_map.starsys_name] Defense Control, switching now.","[prefix] [shipname]")
		//Control event: travel advisory
		if("traveladvisory")
			var/flightwarning = pick("Solar flare activity is spiking and expected to cause issues along main flight lanes [rand(1,33)], [rand(34,67)], and [rand(68,100)]","Pirate activity is on the rise, stay close to System Defense vessels","We're seeing a rise in illegal salvage operations, please report any unusual activity to the nearest SDF vessel via channel [sdfchannel]","Vox Marauder activity is higher than usual, report any unusual activity to the nearest System Defense vessel","A quarantined [pick("fleet","convoy")] is passing through the system along route [rand(1,100)], please observe minimum safe distance","A prison [pick("fleet","convoy")] is passing through the system along route [rand(1,100)], please observe minimum safe distance","Traffic volume is higher than normal, expect processing delays","Anomalous bluespace activity detected along route [rand(1,100)], exercise caution","Smugglers have been particularly active lately, expect increased security scans","Depots are currently experiencing a fuel shortage, expect delays and higher rates","Asteroid mining has displaced debris dangerously close to main flight lanes on route [rand(1,100)], watch for potential impactors","[pick("Pirate","Vox Marauder")] and System Defense forces are currently engaged in skirmishes throughout the system, please steer clear of any active combat zones","A [pick("fuel tanker","cargo liner","passenger liner","freighter","transport ship")] has collided with a [pick("fuel tanker","cargo liner","passenger liner","freighter","transport ship")] near route [rand(1,100)], watch for debris and do not impede emergency service vessels","A [pick("fuel tanker","cargo liner","passenger liner","freighter","transport ship")] on route [rand(1,100)] has experienced total engine failure. Emergency response teams are en route, please observe minimum safe distances and do not impede emergency service vessels","Transit routes have been recalculated to adjust for planetary drift. Please synch your astronav computers as soon as possible to avoid delays and difficulties","[pick("Bounty hunters","System Defense officers","Mercenaries")] are currently searching for a wanted fugitive, report any sightings of suspicious activity to System Defense via channel [sdfchannel]","Mercenary contractors are currently conducting aggressive [pick("piracy","marauder")] suppression operations",10;"It's space carp breeding season. [pick("Stars","Gods","God","Goddess")] have mercy on you all, because the carp won't")
			msg("This is [using_map.dock_name] Control to all vessels in the [using_map.starsys_name] system. Priority travel advisory follows.")
			sleep(5 SECONDS)
			msg("[flightwarning]. Control out.")
		//Control event: warning to a specific vessel
		if("pathwarning")
			var/navhazard = pick("a pocket of intense radiation","a pocket of unstable gas","a debris field","a secure installation","an active combat zone","a quarantined ship","a quarantined installation","a quarantined sector","a live-fire SDF training exercise","an ongoing Search & Rescue operation")
			var/confirm = pick("Understood","Roger that","Affirmative","Our bad","Thanks for the heads up")
			var/safetravels = pick("Fly safe out there","Good luck","Safe travels","Godspeed","Stars guide you","Don't let it happen again")
			msg("[combined_first_name], this is [using_map.dock_name] Control, your [pick("ship","vessel","starship")] is approaching [navhazard], observe minimum safe distance and adjust your heading appropriately.")
			sleep(5 SECONDS)
			msg("[confirm] [using_map.dock_name] Control, adjusting course.","[prefix] [shipname]")
			sleep(5 SECONDS)
			msg("Your compliance is appreciated, [combined_first_name]. [safetravels].")
		//Ship event: docking request (generic)
		if("dockingrequestgeneric")
			var/appreciation = pick("Much appreciated","Many thanks","Understood","Cheers")
			var/dockingplan = pick("Starting final approach now.","Commencing landing procedures.","Autopilot engaged.","Approach vector locked in.","In the pipe, five by five.")
			msg("[callname], this is [combined_first_name], [pick("stopping by","passing through")] on our way to [destname], requesting permission to [landing_short].","[prefix] [shipname]")
			sleep(5 SECONDS)
			msg("[combined_first_name], this is [using_map.dock_name] Control. Permission granted, proceed to [landing_zone]. Follow the green lights on your way in.")
			sleep(5 SECONDS)
			msg("[appreciation], [using_map.dock_name] Control. [dockingplan]","[prefix] [shipname]")
		//Ship event: docking request (denied)
		if("dockingrequestdenied")
			var/reason = pick("we don't have any landing pads large enough for your vessel","we don't have the necessary facilities for your vessel type or class")
			var/disappointed = pick("That's unfortunate. [combined_first_name], out.","Damn shame. We'll just have to keep moving. [combined_first_name], out.","[combined_first_name], out.")
			msg("[callname], this is [combined_first_name], [pick("stopping by","passing through")] on our way to [destname], requesting permission to [landing_short].","[prefix] [shipname]")
			sleep(5 SECONDS)
			msg("[combined_first_name], this is [using_map.dock_name] Control. Request denied, [reason].")
			sleep(5 SECONDS)
			msg("Understood, [using_map.dock_name] Control. [disappointed]","[prefix] [shipname]")
		//Ship event: docking request (delayed)
		if("dockingrequestdelayed")
			var/reason = pick("we don't have any free landing pads right now, please hold for three minutes","you're too far away, please close to ten thousand meters","we're seeing heavy traffic around the landing pads right now, please hold for three minutes","we're currently cleaning up a fuel spill on one of our free pads, please hold for three minutes","there are loose containers on our free pads, stand by for a couple of minutes whilst we secure them","another vessel has aerospace priority right now, please hold for three minutes")
			var/appreciation = pick("Much appreciated","Many thanks","Understood","Perfect, thank you","Excellent, thanks","Great","Copy that")
			var/dockingplan = pick("Starting final approach now.","Commencing landing procedures.","Autopilot engaged.","Approach vector locked in.","In the pipe, five by five.")
			msg("[callname], this is [combined_first_name], [pick("stopping by","passing through")] on our way to [destname], requesting permission to [landing_short].","[prefix] [shipname]")
			sleep(5 SECONDS)
			msg("[combined_first_name], this is [using_map.dock_name] Control. Request denied, [reason] and resubmit your request.")
			sleep(5 SECONDS)
			msg("Understood, [using_map.dock_name] Control.","[prefix] [shipname]")
			sleep(180 SECONDS)
			msg("[callname], this is [combined_first_name], resubmitting [landing_move].","[prefix] [shipname]")
			sleep (5 SECONDS)
			msg("[combined_first_name], this is [using_map.dock_name] Control. Everything appears to be in order now, permission granted, proceed to [landing_zone]. Follow the green lights on your way in.")
			sleep(5 SECONDS)
			msg("[appreciation], [using_map.dock_name] Control. [dockingplan]","[prefix] [shipname]")
		//Ship event: docking request (resupply)
		if("dockingrequestsupply")
			var/preintensifier = pick(75;"getting ",75;"running ","") //whitespace hack, sometimes they'll add a preintensifier, but not always
			var/intensifier = pick("very","pretty","critically","extremely","dangerously","desperately","kinda","a little","a bit","rather","sorta")
			var/low_thing = pick("ammunition","munitions","clean water","food","spare parts","medical supplies","reaction mass","gas","hydrogen fuel","phoron fuel","fuel",10;"tea",10;"coffee",10;"soda",10;"pizza",10;"beer",10;"booze",10;"vodka",10;"snacks") //low chance of a less serious shortage
			var/appreciation = pick("Much appreciated","Many thanks","Understood","You're a lifesaver","We owe you one","I owe you one","Perfect, thank you")
			var/dockingplan = pick("Starting final approach now.","Commencing landing procedures.","Autopilot engaged.","Approach vector locked in.","In the pipe, five by five.")
			msg("[callname], this is [combined_first_name]. We're [preintensifier][intensifier] low on [low_thing]. Requesting permission to [landing_short] for resupply.","[prefix] [shipname]")
			sleep(5 SECONDS)
			msg("[combined_first_name], this is [using_map.dock_name] Control. Permission granted, proceed to [landing_zone]. Follow the green lights on your way in.")
			sleep(5 SECONDS)
			msg("[appreciation], [using_map.dock_name] Control. [dockingplan]","[prefix] [shipname]")
		//Ship event: docking request (repair/maint)
		if("dockingrequestrepair")
			var/damagestate = pick("We've experienced some hull damage","We're suffering minor system malfunctions","We're having some technical issues","We're overdue maintenance","We have several minor space debris impacts","We've got some battle damage here","Our reactor output is fluctuating","We're hearing some weird noises from the [pick("engines","pipes","ducting","HVAC")]","Our artificial gravity generator has failed","Our life support is failing","Our environmental controls are busted","Our water recycling system has shorted out","Our navcomp is freaking out","Our systems are glitching out","We just got caught in a solar flare","We had a close call with an asteroid","We have a minor [pick("fuel","water","oxygen","gas")] leak","We have depressurized compartments","We have a hull breach","Our shield generator is on the fritz","Our RCS is acting up","One of our [pick("hydraulic","pneumatic")] systems has depressurized","Our repair bots are malfunctioning")
			var/appreciation = pick("Much appreciated","Many thanks","Understood","You're a lifesaver","We owe you one","I owe you one","Perfect, thank you")
			var/dockingplan = pick("Starting final approach now.","Commencing landing procedures.","Autopilot engaged.","Approach vector locked in.","In the pipe, five by five.")
			msg("[callname], this is [combined_first_name]. [damagestate]. Requesting permission to [landing_short] for repairs and maintenance.","[prefix] [shipname]")
			sleep(5 SECONDS)
			msg("[combined_first_name], this is [using_map.dock_name] Control. Permission granted, proceed to [landing_zone]. Follow the green lights on your way in. Repair crews are standing by, contact them on channel [engchannel].")
			sleep(5 SECONDS)
			msg("[appreciation], [using_map.dock_name] Control. [dockingplan]","[prefix] [shipname]")
		//Ship event: docking request (medical)
		if("dockingrequestmedical")
			var/medicalstate = pick("multiple casualties","several cases of radiation sickness","an unknown virus","an unknown infection","a critically injured VIP","sick refugees","multiple cases of food poisoning","injured passengers","sick passengers","injured engineers","wounded marines","a delicate situation","a pregnant passenger","injured castaways","recovered escape pods","unknown escape pods")
			var/appreciation = pick("Much appreciated","Many thanks","Understood","You're a lifesaver","We owe you one","I owe you one","Perfect, thank you")
			var/dockingplan = pick("Starting final approach now.","Commencing landing procedures.","Autopilot engaged.","Approach vector locked in.","In the pipe, five by five.")
			msg("[callname], this is [combined_first_name]. We have [medicalstate] on board. Requesting permission to [landing_short] for medical assistance.","[prefix] [shipname]")
			sleep(5 SECONDS)
			msg("[combined_first_name], this is [using_map.dock_name] Control. Permission granted, proceed to [landing_zone]. Follow the green lights on your way in. Medtechs are standing by, contact them on channel [medchannel].")
			sleep(5 SECONDS)
			msg("[appreciation], [using_map.dock_name] Control. [dockingplan]","[prefix] [shipname]")
		//Ship event: docking request (security)
		if("dockingrequestsecurity")
			var/species = pick("human","unathi","lizard","tajaran","feline","skrell","akula","promethean","sergal","synthetic","robotic","teshari","avian","vulpkanin","canine","vox","zorren","hybrid","mixed-species","vox","grey","alien")
			var/securitystate = pick("several [species] convicts","a captured pirate","a wanted criminal","[species] stowaways","incompetent [species] shipjackers","a delicate situation","a disorderly passenger","disorderly [species] passengers","ex-mutineers","a captured vox marauder","captured vox marauders","stolen goods","a container full of confiscated contraband","containers full of confiscated contraband",5;"a very lost shadekin",5;"a raging case of [pick("spiders","crabs")]") //gotta have a little something to lighten the mood now and then
			var/appreciation = pick("Much appreciated","Many thanks","Understood","You're a lifesaver","Perfect, thank you")
			var/dockingplan = pick("Starting final approach now.","Commencing docking procedures.","Autopilot engaged.","Approach vector locked in.","In the pipe, five by five.")
			msg("[callname], this is [combined_first_name]. We have [securitystate] on board and require security assistance. Requesting permission to [landing_short].","[prefix] [shipname]")
			sleep(5 SECONDS)
			msg("[combined_first_name], this is [using_map.dock_name] Control. Permission granted, proceed to [landing_zone]. Follow the green lights on your way in. Security teams are standing by, contact them on channel [secchannel].")
			sleep(5 SECONDS)
			msg("[appreciation], [using_map.dock_name] Control. [dockingplan]","[prefix] [shipname]")
		//Ship event: undocking request
		if("undockingrequest")
			var/safetravels = pick("Fly safe out there","Good luck","Safe travels","See you next week","Godspeed","Stars guide you")
			var/thanks = pick("Appreciated","Thanks","Don't worry about us","We'll be fine","You too","So long")
			var/takeoff = pick("depart","launch")
			msg("[callname], this is [combined_first_name], requesting permission to [takeoff] from [landing_zone].","[prefix] [shipname]")
			sleep(5 SECONDS)
			msg("[combined_first_name], this is [using_map.dock_name] Control. Permission granted. Docking clamps released. [safetravels].")
			sleep(5 SECONDS)
			msg("[thanks], [using_map.dock_name] Control. This is [combined_first_name] setting course for [destname], out.","[prefix] [shipname]")
		//SDF event: starting patrol
		if("sdfbeginpatrol")
			var/safetravels = pick("Fly safe out there","Good luck","Good hunting","Safe travels","Godspeed","Stars guide you")
			var/thanks = pick("Appreciated","Thanks","Don't worry about us","We'll be fine","You too")
			var/takeoff = pick("depart","launch","take off","dust off")
			msg("[callname], this is [combined_first_name], requesting permission to [takeoff] from [landing_zone] to begin system patrol.","[prefix] [shipname]")
			sleep(5 SECONDS)
			msg("[combined_first_name], this is [using_map.dock_name] Control. Permission granted. Docking clamps released. [safetravels].")
			sleep(5 SECONDS)
			msg("[thanks], [using_map.dock_name] Control. This is [combined_first_name] beginning system patrol, out.","[prefix] [shipname]")
		//Ship event: undocking request (denied)
		if("undockingdenied")
			var/takeoff = pick("depart","launch")
			var/denialreason = pick("Security is requesting a full cargo inspection","Your ship has been impounded for multiple [pick("security","safety")] violations","Your ship is currently under quarantine lockdown","We have reason to believe there's an issue with your papers","Security personnel are currently searching for a fugitive and have ordered all outbound ships remain grounded until further notice")
			msg("[callname], this is [combined_first_name], requesting permission to [takeoff] from [landing_zone].","[prefix] [shipname]")
			sleep(5 SECONDS)
			msg("Negative [combined_first_name], request denied. [denialreason].")
		//Ship event: undocking request (delayed)
		if("undockingdelayed")
			var/denialreason = pick("Docking clamp malfunction, please hold","Fuel lines have not been secured","Ground crew are still on the pad","Loose containers are on the pad","Exhaust deflectors are not yet in position, please hold","There's heavy traffic right now, it's not safe for your vessel to launch","Another vessel has aerospace priority at this moment","Port officials are still aboard")
			var/takeoff = pick("depart","launch")
			var/safetravels = pick("Fly safe out there","Good luck","Safe travels","See you next week","Godspeed","Stars guide you")
			var/thanks = pick("Appreciated","Thanks","Don't worry about us","We'll be fine","You too","So long")
			msg("[callname], this is [combined_first_name], requesting permission to [takeoff] from [landing_zone].","[prefix] [shipname]")
			sleep(5 SECONDS)
			msg("Negative [combined_first_name], request denied. [denialreason]. Try again in three minutes.")
			sleep(180 SECONDS) //yes, three minutes
			msg("[callname], this is [combined_first_name], re-requesting permission to depart from [landing_zone].","[prefix] [shipname]")
			sleep(5 SECONDS)
			msg("[combined_first_name], this is [using_map.dock_name] Control. Everything appears to be in order now, permission granted. Docking clamps released. [safetravels].")
			sleep(5 SECONDS)
			msg("[thanks], [using_map.dock_name] Control. This is [combined_first_name] setting course for [destname], out.","[prefix] [shipname]")
		if("slogan")
			msg("The following is a sponsored message from [name].","Facility PA")
			sleep (5 SECONDS)
			msg("[slogan]","Facility PA")
		else //time for generic message
			msg("[callname], this is [combined_first_name] on [mission] [pick(mission_noun)] to [destname], requesting [request].","[prefix] [shipname]")
			sleep(5 SECONDS)
			msg("[combined_first_name], this is [using_map.dock_name] Control, [response].")
			sleep(5 SECONDS)
			msg("[using_map.dock_name] Control, [yes ? "thank you" : "understood"], out.","[prefix] [shipname]")
	return //oops, forgot to restore this

/*	//OLD BLOCK, for reference
	//Ship sends request to ATC
	msg(full_request,"[prefix] [shipname]"
	sleep(5 SECONDS)
	//ATC sends response to ship
	msg(full_response)
	sleep(5 SECONDS)
	//Ship sends response to ATC
	msg(full_closure,"[prefix] [shipname]")
	return
*/