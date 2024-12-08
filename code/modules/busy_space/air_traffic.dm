//Cactus, Speedbird, Dynasty, oh my
//Also, massive additions/refactors by Killian, because the original incarnation was full of holes

//minimum and maximum message delays, typically tracked in seconds
#define MIN_MSG_DELAY 3
#define MAX_MSG_DELAY 6

var/datum/lore/atc_controller/atc = new/datum/lore/atc_controller

/datum/lore/atc_controller
	var/delay_min = 45 MINUTES			//How long between ATC traffic, minimum
	var/delay_max = 90 MINUTES			//Ditto, maximum
							//Shorter delays means more traffic, which gives the impression of a busier system, but also means a lot more radio noise
	var/backoff_delay = 5 MINUTES			//How long to back off if we can't talk and want to.  Default is 5 mins.
	var/initial_delay = 15 MINUTES			//How long to wait before sending the first message of the shift.
	var/next_message = 45 MINUTES			//When the next message should happen in world.time
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
	spawn(5 SECONDS) //Lots of lag at the start of a shift. Yes, the following lines *have* to be indented or they're not delayed by the spawn properly.
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
	sleep(rand(MIN_MSG_DELAY,MAX_MSG_DELAY) SECONDS)
	msg("[using_map.shuttle_name] departing [using_map.dock_name] for [using_map.station_name] on routine transfer route. Estimated time to arrival: ten minutes.","[using_map.shuttle_name]")

/datum/lore/atc_controller/proc/random_convo(var/force_chatter_type)
	var/one = pick(loremaster.organizations) //These will pick an index, not an instance
	var/two = pick(loremaster.organizations)

	var/datum/lore/organization/source = loremaster.organizations[one] //Resolve to the instances
	var/datum/lore/organization/secondary = loremaster.organizations[two] //repurposed for new fun stuff

	//Let's get some mission parameters, pick our first ship
	var/name = source.name					//get the name
	var/owner = source.short_name				//Use the short name
	var/prefix = pick(source.ship_prefixes)			//Pick a random prefix
	var/firstid = "[rand(0,9)][rand(0,9)][rand(0,9)][rand(0,9)]"
	var/mission = source.ship_prefixes[prefix]		//The value of the prefix is the mission type that prefix does
	var/shipname = pick(source.ship_names)			//Pick a random ship name
	var/destname = pick(source.destination_names)		//destination is where?
	var/slogan = pick(source.slogans)			//god help you all
	var/org_type = source.org_type				//which group do we belong to?

	//pick our second ship
	//var/secondname = secondary.name			//not used atm, commented out to suppress errors
	var/secondowner = secondary.short_name
	var/secondprefix = pick(secondary.ship_prefixes)	//Pick a random prefix
	var/secondid = "[rand(0,9)][rand(0,9)][rand(0,9)][rand(0,9)]"
	var/secondshipname = pick(secondary.ship_names)		//Pick a random ship name
	var/org_type2 = secondary.org_type

	//DEBUG BLOCK
	//to_world("DEBUG OUTPUT 1: [name], [owner], [prefix], [firstid], [mission], [shipname], [org_type], [destname]")
	//to_world("DEBUG OUTPUT 2: [secondowner], [secondprefix], [secondid], [secondshipname], [org_type2]")
	//to_world("DEBUG OUTPUT 3: Chose [chatter_type]")
	//DEBUG BLOCK ENDS

	var/combined_first_name = "[prefix] [firstid] |[shipname]|"	//formal traffic control identifier for use in messages
	var/short_first_name = "[prefix] |[shipname]|"	//special variant for certain events
	var/comm_first_name = "[owner] [shipname]"	//corpname + shipname for speaker identity in log
	var/combined_second_name = "[secondprefix] [secondid] |[secondshipname]|"
	var/comm_second_name = "[secondowner] [secondshipname]"
	//var/short_second_name = "[secondprefix] |[secondshipname]|"	//not actually used for now

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
	else if((org_type == "government" || org_type == "neutral" || org_type == "military" || org_type == "corporate" || org_type == "system defense" || org_type == "spacer") && org_type2 == "pirate") //this is ugly but when I tried to do it with !='s it fired for pirate-v-pirate, still not sure why. might as well stick it up here so it takes priority over other combos.
		chatter_type = "distress"
	else if(org_type == "corporate") //corporate-specific subset for the slogan event. despite the relatively high weight it was still quite rare in tests.
		chatter_type = pick(5;"emerg",25;"policescan",25;"traveladvisory",30;"pathwarning",180;"dockingrequestgeneric",30;"undockingrequest","normal",30;"undockingdenied",50;"slogan",25;"civvieleaks",25;"report_to_dock")
	else if((org_type == "government" || org_type == "neutral" || org_type == "military"))
		chatter_type = pick(5;"emerg",25;"policescan",25;"traveladvisory",30;"pathwarning",180;"dockingrequestgeneric",30;"undockingrequest","normal",30;"undockingdenied",25;"civvieleaks",25;"report_to_dock")
	else if(org_type == "spacer")
		chatter_type = pick(5;"emerg",15;"policescan",15;"traveladvisory",5;"pathwarning",150;"dockingrequestgeneric",30;"undockingrequest","normal",10;"undockingdenied",25;"civvieleaks",25;"report_to_dock")

	//the following filters *always* fire their 'unique' event when they're tripped, simply because the conditions behind them are quite rare to begin with
	else if(org_type == "smuggler" && org_type2 != "system defense") //just straight up funnel smugglers into always being caught, otherwise we get them asking for traffic info and stuff
		chatter_type = "policeflee"
	else if(org_type == "smuggler" && org_type2 == "system defense") //ditto, if an SDF ship catches them
		chatter_type = "policeshipflee"
	else if((org_type == "smuggler" || org_type == "pirate") && (org_type2 == "system defense" || org_type2 == "military")) //if we roll this combo instead, time for the SDF or Mercs to do their fucking jobs
		chatter_type = "policeshipcombat"
	else if((org_type == "smuggler" || org_type == "pirate") && org_type2 != "system defense") //but if we roll THIS combo, time to alert the SDF to get off their asses
		chatter_type = "hostiledetected"
	//SDF-specific events that need to filter based on the second party (basically just the following SDF-unique list with the soft-result ship scan thrown in)
	else if(org_type == "system defense" && (org_type2 == "government" || org_type2 == "neutral" || org_type2 == "military" || org_type2 == "corporate" || org_type2 == "spacer")) //let's see if we can narrow this down, I didn't see many ship-to-ship scans
		chatter_type = pick(75;"policeshipscan","sdfpatrolupdate",75;"sdfendingpatrol",180;"dockingrequestgeneric",20;"undockingrequest",75;"sdfbeginpatrol",50;"normal",10;"civvieleaks",70;"sdfchatter")
	//SDF-specific events that don't require the secondary at all, in the event that we manage to roll SDF + hostile/smuggler or something
	else if(org_type == "system defense")
		chatter_type = pick("sdfpatrolupdate",60;"sdfendingpatrol",120;"dockingrequestgeneric",20;"undockingrequest",80;"sdfbeginpatrol","normal","sdfchatter")
	//if we somehow don't match any of the other existing filters once we've run through all of them
	else
		chatter_type = pick(5;"emerg",25;"policescan",25;"traveladvisory",30;"pathwarning",90;"dockingrequestgeneric",30;"undockingrequest",30;"undockingdenied","normal",25;"civvieleaks")
	//I probably should do some kind of pass here to work through all the possible combinations of major factors and see if the filtering list needs reordering or modifying, but I really can't be arsed

	var/yes = prob(90) //Chance for them to say yes vs no

	var/request = pick(requests)
	var/callname = "[using_map.dock_name] Control"
	var/response = requests[request][yes ? 1 : 2] //1 is yes, 2 is no
	var/number = rand(1,42)
	var/zone = pick("Alpha","Beta","Gamma","Delta","Epsilon","Zeta","Eta","Theta","Iota","Kappa","Lambda","Mu","Nu","Xi","Omicron","Pi","Rho","Sigma","Tau","Upsilon","Phi","Chi","Psi","Omega")
	//fallbacks in case someone sets the dock_type on the map datum to null- it defaults to "station" normally
	var/landing_zone = "LZ [zone]"
	var/landing_type = "landing zone"
	var/landing_move = "landing request"
	var/landing_short = "land"
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

	// what you're about to witness is what feels like an extremely kludgy rework of the system, but it's more 'flexible' and allows events that aren't just ship-stc-ship
	// something more elegant could probably be done, but it won't be done by somebody as half-competent as me
	switch(chatter_type)
		//mayday call
		if("emerg")
			var/problem = pick("We have hull breaches on multiple decks","We have unknown hostile life forms on board","Our primary drive is failing","We have [pick("asteroids","space debris")] impacting the hull","We're experiencing a total loss of engine power","We have hostile ships closing fast","There's smoke [pick("in the cockpit","on the bridge")]","We have unidentified boarders","Our reaction control system is malfunctioning and we're losing stability","Our life support [pick("is failing","has failed")]")
			msg("+[pick("Mayday, mayday, mayday!","Mayday, mayday!","Mayday! Mayday!")]+ [combined_first_name], declaring an emergency! [problem]!","[comm_first_name]")
			sleep(rand(MIN_MSG_DELAY,MAX_MSG_DELAY) SECONDS)
			msg("[combined_first_name], [callname]. Switch to emergency responder channel [ertchannel].")
			sleep(rand(MIN_MSG_DELAY,MAX_MSG_DELAY) SECONDS)
			msg("[callname], [combined_first_name] switching now.","[comm_first_name]")
		//Control scan event: soft outcome
		if("policescan")
			var/confirm = pick("Understood","Roger that","Affirmative","Very well","Copy that")
			var/complain = pick("I hope this doesn't take too long.","Can we hurry this up?","Make it quick.","This better not take too long.","Is this really necessary?","I'm sure you'll find everything to be in order, Control.")
			var/completed = pick("You're free to proceed.","Everything looks fine, carry on.","You're clear, move along.","Apologies for the delay, you're clear.","Switch to channel [sdfchannel] and await further instruction.")
			msg("[combined_first_name], [callname], your [pick("ship","vessel","starship")] has been flagged for routine inspection. Hold position and prepare to be scanned.")
			sleep(rand(MIN_MSG_DELAY,MAX_MSG_DELAY) SECONDS)
			msg("[confirm] [callname], holding position.","[comm_first_name]")
			sleep(rand(MIN_MSG_DELAY,MAX_MSG_DELAY) SECONDS)
			msg("Your compliance is appreciated, [combined_first_name]. Scan commencing.")
			sleep(rand(MIN_MSG_DELAY,MAX_MSG_DELAY)*2 SECONDS)
			msg(complain,"[comm_first_name]")
			sleep(rand(MIN_MSG_DELAY,MAX_MSG_DELAY)*3 SECONDS)
			msg("[combined_first_name], [callname]. Scan complete. [completed]")
		//Control scan event: hard outcome
		if("policeflee")
			var/uhoh = pick("No can do chief, we got places to be.","Sorry but we've got places to be.","Not happening.","Ah fuck, who ratted us out this time?!","You'll never take me alive!","Hey, I have a cloaking device! You can't see me!","I'm going to need to ask for a refund on that stealth drive...","I'm afraid I can't do that, Control.","Ah |hell|.","Fuck!","This isn't the ship you're looking for.","Well. This is awkward.","Uh oh.","I surrender!","Ah f- |ditch the containers!| +Now!+","Unless you have something a little +bigger+ in your torpedo tubes, we're |not| turning around!")
			msg("Unknown [pick("ship","vessel","starship")], [callname], identify yourself and submit to a full inspection. Flying without an active transponder is a violation of interstellar shipping regulations.")
			sleep(rand(MIN_MSG_DELAY,MAX_MSG_DELAY) SECONDS)
			msg("[uhoh]","Unknown Vessel")
			sleep(rand(MIN_MSG_DELAY,MAX_MSG_DELAY) SECONDS)
			msg("[using_map.starsys_name] Defense Control to all local assets: vector to interdict and detain [prefix], temporary callsign |[shipname]|. Control out.","[using_map.starsys_name] Defense Control")
		//SDF scan event: soft outcome
		if("policeshipscan")
			var/confirm = pick("Understood","Roger that","Affirmative")
			var/complain = pick("I hope this doesn't take too long.","Can we hurry this up?","Make it quick.","This better not take too long.","Is this really necessary?","I'm sure you'll find everything to be in order, officer.")
			var/completed = pick("You're free to proceed.","Everything looks fine, carry on.","You're clear. Move along.","Apologies for the delay, you're clear.","Switch to channel [sdfchannel] and await further instruction.")
			msg("[combined_second_name], [combined_first_name], your [pick("ship","vessel","starship")] has been flagged for routine inspection. Hold position and prepare to be scanned.","[comm_first_name]")
			sleep(rand(MIN_MSG_DELAY,MAX_MSG_DELAY) SECONDS)
			msg("[confirm] [combined_first_name], holding position.","[comm_second_name]")
			sleep(rand(MIN_MSG_DELAY,MAX_MSG_DELAY) SECONDS)
			msg("Your compliance is appreciated, [combined_second_name]. Scan commencing.","[comm_first_name]")
			sleep(rand(MIN_MSG_DELAY,MAX_MSG_DELAY)*2 SECONDS)
			msg(complain,"[comm_second_name]")
			sleep(rand(MIN_MSG_DELAY,MAX_MSG_DELAY)*3 SECONDS)
			msg("[combined_second_name], [combined_first_name]. Scan complete. [completed]","[comm_first_name]")
		//SDF scan event: hard outcome
		if("policeshipflee")
			var/uhoh = pick("No can do chief, we got places to be.","Sorry but we've got places to be.","Not happening.","Ah fuck, who ratted us out this time?!","You'll never take me alive!","Hey, I have a cloaking device! You can't see me!","I'm going to need to ask for a refund on that stealth drive...","I'm afraid I can't do that, |[shipname]|.","Ah |hell|.","Fuck!","This isn't the ship you're looking for.","Well. This is awkward.","Uh oh.","I surrender!","Ah f- |ditch the containers!| +Now!+","Unless you have something a little +bigger+ in your torpedo tubes, we're |not| turning around!")
			msg("Unknown [pick("ship","vessel","starship")], [combined_second_name], identify yourself and submit to a full inspection. Flying without an active transponder is a violation of interstellar shipping regulations.","[comm_second_name]")
			sleep(rand(MIN_MSG_DELAY,MAX_MSG_DELAY) SECONDS)
			msg("[uhoh]","Unknown Vessel")
			sleep(rand(MIN_MSG_DELAY,MAX_MSG_DELAY) SECONDS)
			msg("[using_map.starsys_name] Defense Control,  [combined_second_name]. We have a [prefix] here, please advise.","[comm_second_name]")
			sleep(rand(MIN_MSG_DELAY,MAX_MSG_DELAY) SECONDS)
			msg("Defense Control copies, [combined_second_name], reinforcements are en route. Switch further communications to encrypted band [sdfchannel].","[using_map.starsys_name] Defense Control")
		//SDF scan event: engage primary in combat! fairly rare since it needs a pirate/vox + SDF roll
		if("policeshipcombat")
			var/battlestatus = pick("requesting reinforcements.","we need backup! Now!","holding steady.","we're holding our own for now.","we have them on the run.","they're trying to make a run for it!","we have them right where we want them.","we're badly outgunned!","we have them outgunned.","we're outnumbered here!","we have them outnumbered.","this'll be a cakewalk.",10;"notify their next of kin.")
			msg("[using_map.starsys_name] Defense Control,  [combined_second_name], engaging [combined_first_name] [pick("near route","in sector")] [rand(1,100)], [battlestatus]","[comm_second_name]")
			sleep(rand(MIN_MSG_DELAY,MAX_MSG_DELAY) SECONDS)
			msg("[using_map.starsys_name] Defense Control copies, [combined_second_name]. Keep us updated.","[using_map.starsys_name] Defense Control")
		//SDF event: patrol update
		if("sdfpatrolupdate")
			var/statusupdate = pick("nothing unusual so far","nothing of note","everything looks clear so far","ran off some [pick("pirates","scavengers")] near route [pick(1,100)], [pick("no","minor")] damage sustained, continuing patrol","situation normal, no suspicious activity yet","minor incident on route [pick(1,100)]","Code 7-X [pick("on route","in sector")] [pick(1,100)], situation is under control","seeing a lot of traffic on route [pick(1,100)]","caught a couple of smugglers [pick("on route","in sector")] [pick(1,100)]","sustained some damage in a skirmish just now, we're heading back for repairs")
			msg("[using_map.starsys_name] Defense Control,  [combined_first_name] reporting in, [statusupdate], over.","[comm_first_name]")
			sleep(rand(MIN_MSG_DELAY,MAX_MSG_DELAY) SECONDS)
			msg("[using_map.starsys_name] Defense Control copies, [combined_first_name]. Keep us updated, out.","[using_map.starsys_name] Defense Control")
		//SDF event: end patrol
		if("sdfendingpatrol")
			var/appreciation = pick("Copy","Understood","Affirmative","10-4","Roger that")
			var/dockingplan = pick("Starting final approach now.","Commencing landing procedures.","Autopilot engaged.","Approach vector locked in.","In the pipe, five by five.")
			msg("[callname], [combined_first_name], returning from our system patrol route, requesting permission to [landing_short].","[comm_first_name]")
			sleep(rand(MIN_MSG_DELAY,MAX_MSG_DELAY) SECONDS)
			msg("[combined_first_name], [callname]. Permission granted, proceed to [landing_zone]. Follow the green lights on your way in.")
			sleep(rand(MIN_MSG_DELAY,MAX_MSG_DELAY) SECONDS)
			msg("[appreciation], [callname]. [dockingplan]","[comm_first_name]")
		//SDF event: general chatter
		if("sdfchatter")
			var/chain = pick("codecheck","commscheck")
			switch(chain)
				if("codecheck")
					msg("Check. Check. |Check|. Uhhh... check? Wait. Wait! Hold on. Yeah, okay, I gotta call this one in.","[comm_first_name]")
					sleep(rand(MIN_MSG_DELAY,MAX_MSG_DELAY) SECONDS)
					msg("[callname], confirm auth-code... [rand(1,9)][rand(1,9)][rand(1,9)]-[pick("Alpha","Beta","Gamma","Delta","Epsilon","Zeta","Eta","Theta","Iota","Kappa","Lambda","Mu","Nu","Xi","Omicron","Pi","Rho","Sigma","Tau","Upsilon","Phi","Chi","Psi","Omega")]?","[comm_first_name]")
					sleep(rand(MIN_MSG_DELAY,MAX_MSG_DELAY) SECONDS)
					msg("One moment...")
					sleep(rand(MIN_MSG_DELAY,MAX_MSG_DELAY)*2 SECONDS)
					msg("Yeah, that code checks out [combined_first_name].")
					sleep(rand(MIN_MSG_DELAY,MAX_MSG_DELAY) SECONDS)
					msg("|(sigh)| Copy that Control. You! Move along!","[comm_first_name]")
				if("commscheck")
					msg("Control this is [combined_first_name], we're getting some interference in our area. [pick("How's our line?","Do you read?","How copy, over?")]","[comm_first_name]")
					sleep(rand(MIN_MSG_DELAY,MAX_MSG_DELAY) SECONDS)
					msg("Control reads you loud and clear [combined_first_name].","[using_map.starsys_name] Defense Control")
					sleep(rand(MIN_MSG_DELAY,MAX_MSG_DELAY) SECONDS)
					msg("[pick("Copy that","Thanks,","Roger that")] Control. [combined_first_name] out.","[comm_first_name]")
		//Civil event: leaky chatter
		if("civvieleaks")
			var/commleak = pick("thatsmywife","missingkit","pipeleaks","weirdsmell","weirdsmell2","scug","teppi")
			switch(commleak)
				if("thatsmywife")
					msg("-so then I says to him, |that's no [pick("space carp","space shark","vox","garbage scow","freight liner","cargo hauler","superlifter")], that's my +wife!+| And he-","[comm_first_name]")
				if("missingkit")
					msg("-did you get the kit from down on deck [rand(1,4)]? I need th-","[comm_first_name]")
				if("pipeleaks")
					msg("I swear if these pipes keep leaking I'm going to-","[comm_first_name]")
				if("weirdsmell")
					msg("-and where the hell is that smell coming fr-","[comm_first_name]")
				if("weirdsmell2")
					msg("-hat in the [pick("three","five","seven","nine")] hells did you |eat| [pick("ensign","crewman")]? This compartment reeks of-","[comm_first_name]")
				if("scug")
					msg("-and if that weird cat of yours keeps crawling into the pipes we-","[comm_first_name]")
				if("teppi")
					msg("-at are we supposed to do with this damn cow?","[comm_first_name]")
					sleep(rand(MIN_MSG_DELAY,MAX_MSG_DELAY) SECONDS)
					msg("I don't think it's a cow, sir, it looks more like a-","[comm_first_name]")
			sleep(rand(MIN_MSG_DELAY,MAX_MSG_DELAY) SECONDS)
			msg("[combined_first_name], your internal comms are leaking[pick("."," again.",", again.",". |Again|.")]")
			sleep(rand(MIN_MSG_DELAY,MAX_MSG_DELAY) SECONDS)
			msg("Sorry Control, won't happen again.","[comm_first_name]")
		//DefCon event: hostile found
		if("hostiledetected")
			var/orders = pick("Engage on sight","Engage with caution","Engage with extreme prejudice","Engage at will","Search and destroy","Bring them in alive, if possible","Interdict and detain","Keep your eyes peeled","Bring them in, dead or alive","Stay alert")
			msg("This is [using_map.starsys_name] Defense Control to all SDF assets. Priority update follows.","[using_map.starsys_name] Defense Control")
			sleep(rand(MIN_MSG_DELAY,MAX_MSG_DELAY) SECONDS)
			msg("Be on the lookout for [short_first_name], last sighted [pick("near route","in sector","near sector")] [rand(1,100)]. [orders]. DefCon, out.","[using_map.starsys_name] Defense Control")
		//Ship event: distress call, under attack
		if("distress")
			var/state = pick(66;"calm",34;"panic")
			switch(state)
				if("calm")
					msg("[using_map.starsys_name] Defense Control, [combined_first_name].","[comm_first_name]")
					sleep(rand(MIN_MSG_DELAY,MAX_MSG_DELAY) SECONDS)
					msg("[combined_first_name], [using_map.starsys_name] Defense Control.","[using_map.starsys_name] Defense Control")
					sleep(rand(MIN_MSG_DELAY,MAX_MSG_DELAY) SECONDS)
					msg("Another vessel in our area is moving [pick("aggressively","suspiciously","erratically","unpredictably","with clear hostile intent")], please advise? Forwarding sensor data now.","[comm_first_name]","[comm_first_name]")
					sleep(rand(MIN_MSG_DELAY,MAX_MSG_DELAY) SECONDS)
					msg("[combined_first_name], [using_map.starsys_name] Defense Control copies. Sensor data matches logged profile for [secondprefix] |[secondshipname]|. SDF units are en route to your location.","[using_map.starsys_name] Defense Control")
					sleep(rand(MIN_MSG_DELAY,MAX_MSG_DELAY) SECONDS)
					msg("[pick("Appreciated","Copy that","Understood")], Control. Switching to [sdfchannel] to coordinate.","[comm_first_name]")
				if("panic")
					msg("+Mayday, mayday, mayday!+ This is [combined_first_name] declaring an emergency! We are under attack! Requesting immediate assistance!","[comm_first_name]")
					sleep(rand(MIN_MSG_DELAY,MAX_MSG_DELAY) SECONDS)
					msg("[combined_first_name], [using_map.starsys_name] Defense Control. SDF is en route, contact on [sdfchannel].")
					sleep(rand(MIN_MSG_DELAY,MAX_MSG_DELAY) SECONDS)
					msg("[pick("Copy that","Understood")] [using_map.starsys_name] Defense Control, switching now!","[comm_first_name]")
		//Control event: travel advisory
		if("traveladvisory")
			var/flightwarning = pick("Solar flare activity is spiking and expected to cause issues along main flight lanes [rand(1,33)], [rand(34,67)], and [rand(68,100)]","Pirate activity is on the rise, stay close to System Defense vessels","We're seeing a rise in illegal salvage operations, please report any unusual activity to the nearest SDF vessel via channel [sdfchannel]","A quarantined [pick("fleet","convoy")] is passing through the system along route [rand(1,100)], please observe minimum safe distance","A prison [pick("fleet","convoy")] is passing through the system along route [rand(1,100)], please observe minimum safe distance","Traffic volume is higher than normal, expect processing delays","Anomalous bluespace activity detected [pick("along route [rand(1,100)]","in sector [rand(1,100)]")], exercise caution","Smugglers have been particularly active lately, expect increased security scans","Depots are currently experiencing a fuel shortage, expect delays and higher rates","Asteroid mining has displaced debris dangerously close to main flight lanes on route [rand(1,100)], watch for potential impactors","A [pick("fuel tanker","cargo liner","passenger liner","freighter","transport ship","mining barge","salvage trawler")] has collided with [pick("a fuel tanker","a cargo liner","a passenger liner","a freighter","a transport ship","a mining barge","a salvage trawler","a meteoroid","a cluster of space debris","an asteroid","an ice-rich comet")] near route [rand(1,100)], watch for debris and do not impede emergency service vessels","A [pick("fuel tanker","cargo liner","passenger liner","freighter","transport ship","mining barge","salvage trawler")] on route [rand(1,100)] has experienced total engine failure. Emergency response teams are en route, please observe minimum safe distances and do not impede emergency service vessels","Transit routes have been recalculated to adjust for planetary drift. Please synch your astronav computers as soon as possible to avoid delays and difficulties","[pick("Bounty hunters","System Defense officers","Mercenaries")] are currently searching for a wanted fugitive, report any sightings of suspicious activity to System Defense via channel [sdfchannel]",10;"It's space [pick("carp","shark")] breeding season. [pick("Stars","Skies","Gods","God","Goddess","Fates")] have mercy on you all","We're reading [pick("void","drive","sensor")] echoes that are consistent with illegal cloaking devices, be alert for suspicious activity in your sector")
			msg("[callname], all vessels in the [using_map.starsys_name] system. Priority travel advisory follows.")
			sleep(rand(MIN_MSG_DELAY,MAX_MSG_DELAY) SECONDS)
			msg("[flightwarning]. Control out.")
		//Control event: warning to a specific vessel
		if("pathwarning")
			var/navhazard = pick("a pocket of intense radiation","a pocket of unstable gas","a debris field","a secure installation","an active combat zone","a quarantined ship","a quarantined installation","a quarantined sector","a live-fire SDF training exercise","an ongoing Search & Rescue operation","a hazardous derelict","an intense electrical storm","an intense ion storm","a shoal of space carp","a pack of space sharks","an asteroid infested with gnat hives","a protected space ray habitat","a region with anomalous bluespace activity","a rogue comet")
			var/confirm = pick("Understood","Roger that","Affirmative","Our bad","Thanks for the heads up")
			msg("[combined_first_name], [callname]. Your [pick("ship","vessel","starship")] is approaching [navhazard], observe minimum safe distance and adjust your heading appropriately.")
			sleep(rand(MIN_MSG_DELAY,MAX_MSG_DELAY) SECONDS)
			msg("[confirm] [callname], adjusting course.","[comm_first_name]")
			sleep(rand(MIN_MSG_DELAY,MAX_MSG_DELAY) SECONDS)
			msg("Your compliance is appreciated, [combined_first_name].")
		//Control event: personnel report to dock
		if("report_to_dock")
			var/situation_type = pick("medical","security","engineering","animal control","hazmat")
			msg("This is [using_map.dock_name] Tower. Would a free [situation_type] team please report to [landing_zone] immediately. This is not a drill.")
			sleep(rand(MIN_MSG_DELAY,MAX_MSG_DELAY)*10 SECONDS)
			msg("Repeat, any free [situation_type] team, report to [landing_zone] immediately. This is +not+ a drill.")
		//Ship event: docking request (generic)
		if("dockingrequestgeneric")
			var/request_type = pick(100;"generic",50;"delayed",80;"supply",30;"repair",30;"medical",30;"security")
			var/appreciation = pick("Much appreciated","Many thanks","Understood","Perfect, thank you","Excellent, thanks","Great","Copy that")
			var/dockingplan = pick("Starting final approach now.","Commencing landing procedures.","Autopilot engaged.","Approach vector locked in.","In the pipe, five by five.")
			switch(request_type)
				if("generic")
					msg("[callname], [combined_first_name], [pick("stopping by","passing through")] on our way to [destname], requesting permission to [landing_short].","[comm_first_name]")
					sleep(rand(MIN_MSG_DELAY,MAX_MSG_DELAY) SECONDS)
					msg("[combined_first_name], [callname]. Permission granted, proceed to [landing_zone]. Follow the green lights on your way in.")
				if("delayed")
					var/reason = pick(
							"we don't have any free [landing_type]s right now, please [pick("stand by for a couple of minutes","hold for a few minutes")]",
							"you're too far away, please close to ten thousand meters","we're seeing heavy traffic around the [landing_type]s right now, please [pick("stand by for a couple of minutes","hold for a few minutes")]","ground crews are currently clearing up [pick("loose containers","a fuel spill")] to free up one of our [landing_type]s, please [pick("stand by for a couple of minutes","hold for a few minutes")]","another vessel has aerospace priority right now, please [pick("stand by for a couple of minutes","hold for a few minutes")]")
					msg("[callname], [combined_first_name], [pick("stopping by","passing through")] on our way to [destname], requesting permission to [landing_short].","[comm_first_name]")
					sleep(rand(MIN_MSG_DELAY,MAX_MSG_DELAY) SECONDS)
					msg("[combined_first_name], [callname]. Request denied, [reason] and resubmit your request.")
					sleep(rand(MIN_MSG_DELAY,MAX_MSG_DELAY) SECONDS)
					msg("Understood, [callname].","[comm_first_name]")
					sleep(rand(MIN_MSG_DELAY,MAX_MSG_DELAY)*60 SECONDS)
					msg("[callname], [combined_first_name], resubmitting [landing_move].","[comm_first_name]")
					sleep (5 SECONDS)
					msg("[combined_first_name], [callname]. Everything appears to be in order now, permission granted, proceed to [landing_zone]. Follow the green lights on your way in.")
				if("supply")
					var/preintensifier = pick(75;"getting ",75;"running ","",15;"like, ") //whitespace hack, sometimes they'll add a preintensifier, but not always
					var/intensifier = pick("very","pretty","critically","extremely","dangerously","desperately","kinda","a little","a bit","rather","sorta")
					var/low_thing = pick("ammunition","munitions","clean water","food","spare parts","medical supplies","reaction mass","gas","hydrogen fuel","phoron fuel","fuel",10;"tea",10;"coffee",10;"soda",10;"pizza",10;"beer",10;"booze",10;"vodka",10;"snacks") //low chance of a less serious shortage
					appreciation = pick("Much appreciated","Many thanks","Understood","You're a lifesaver","We owe you one","I owe you one","Perfect, thank you")
					msg("[callname], [combined_first_name]. We're [preintensifier][intensifier] low on [low_thing]. Requesting permission to [landing_short] for resupply.","[comm_first_name]")
					sleep(rand(MIN_MSG_DELAY,MAX_MSG_DELAY) SECONDS)
					msg("[combined_first_name], [callname]. Permission granted, proceed to [landing_zone]. Follow the green lights on your way in.")
				if("repair")
					var/damagestate = pick("We've experienced some hull damage","We're suffering minor system malfunctions","We're having some [pick("weird","strange","odd","unusual")] technical issues","We're overdue maintenance","We have several minor space debris impacts","We've got some battle damage here","Our reactor output is fluctuating","We're hearing some weird noises from the [pick("engines","pipes","ducting","HVAC")]","We just got caught in a solar flare","We had a close call with an asteroid","We have a [pick("minor","mild","major","serious")] [pick("fuel","water","oxygen","gas")] leak","We have depressurized compartments","We have a hull breach","One of our [pick("hydraulic","pneumatic")] systems has depressurized","Our [pick("life support","water recycling system","navcomp","shield generator","reaction control system","auto-repair system","repair drone controller","artificial gravity generator","environmental control system","master control system")] is [pick("failing","acting up","on the fritz","shorting out","glitching out","freaking out","malfunctioning")]")
					appreciation = pick("Much appreciated","Many thanks","Understood","You're a lifesaver","We owe you one","I owe you one","Perfect, thank you")
					msg("[callname], [combined_first_name]. [damagestate]. Requesting permission to [landing_short] for repairs and maintenance.","[comm_first_name]")
					sleep(rand(MIN_MSG_DELAY,MAX_MSG_DELAY) SECONDS)
					msg("[combined_first_name], [callname]. Permission granted, proceed to [landing_zone]. Follow the green lights on your way in. Repair crews are standing by, contact them on channel [engchannel].")
				if("medical")
					var/species = pick("human","humanoid","unathi","lizard","tajaran","feline","skrell","akula","promethean","sergal","synthetic","robotic","teshari","avian","vulpkanin","canine","vox","zorren","hybrid","mixed-species","vox","grey","alien",5;"catslug")
					var/medicalstate = pick("multiple casualties","several cases of radiation sickness","an unknown virus","an unknown infection","a critically injured VIP","sick refugees","multiple cases of food poisoning","injured [pick("","[species] ")]passengers","sick [pick("","[species] ")]passengers","injured engineers","wounded marines","a delicate situation","a pregnant passenger","injured [pick("","[species] ")]castaways","recovered escape pods","unknown escape pods")
					appreciation = pick("Much appreciated","Many thanks","Understood","You're a lifesaver","We owe you one","I owe you one","Perfect, thank you")
					msg("[callname], [combined_first_name]. We have [medicalstate] on board. Requesting permission to [landing_short] for medical assistance.","[comm_first_name]")
					sleep(rand(MIN_MSG_DELAY,MAX_MSG_DELAY) SECONDS)
					msg("[combined_first_name], [callname]. Permission granted, proceed to [landing_zone]. Follow the green lights on your way in. Medtechs are standing by, contact them on channel [medchannel].")
				if("security")
					var/species = pick("human","humanoid","unathi","lizard","tajaran","feline","skrell","akula","promethean","sergal","synthetic","robotic","teshari","avian","vulpkanin","canine","vox","zorren","hybrid","mixed-species","vox","grey","alien",5;"catslug")
					var/securitystate = pick("several [species] convicts","a captured pirate","a wanted criminal","[species] stowaways","incompetent [species] shipjackers","a delicate situation","a disorderly passenger","disorderly [species] passengers","ex-mutineers","stolen goods","[pick("a container","containers")] full of [pick("confiscated contraband","stolen goods")]",5;"a very lost shadekin",10;"some kinda big wooly critter",15;"a buncha lost-looking uh... cat... slug... |things?|",10;"a raging case of [pick("spiders","crabs","geese","gnats","sharks","carp")]") //gotta have a little something to lighten the mood now and then
					appreciation = pick("Much appreciated","Many thanks","Understood","You're a lifesaver","Perfect, thank you")
					msg("[callname], [combined_first_name]. We have [securitystate] on board and require security assistance. Requesting permission to [landing_short].","[comm_first_name]")
					sleep(rand(MIN_MSG_DELAY,MAX_MSG_DELAY) SECONDS)
					msg("[combined_first_name], [callname]. Permission granted, proceed to [landing_zone]. Follow the green lights on your way in. Security teams are standing by, contact them on channel [secchannel].")
			sleep(rand(MIN_MSG_DELAY,MAX_MSG_DELAY) SECONDS)
			msg("[appreciation], [callname]. [dockingplan]","[comm_first_name]")
		//Ship event: undocking request
		if("undockingrequest")
			var/request_type = pick(150;"generic",50;"delayed")
			var/takeoff = pick("depart","launch")
			var/safetravels = pick("Fly safe out there","Good luck","Safe travels","See you next week","Godspeed","Stars guide you")
			var/thanks = pick("Appreciated","Thanks","Don't worry about us","We'll be fine","You too","So long")
			msg("[callname], [combined_first_name], requesting permission to [takeoff] from [landing_zone].","[comm_first_name]")
			sleep(rand(MIN_MSG_DELAY,MAX_MSG_DELAY) SECONDS)
			switch(request_type)
				if("generic")
					msg("[combined_first_name], [callname]. Permission granted. Docking clamps released. [safetravels].")
				if("delayed")
					var/denialreason = pick("Docking clamp malfunction, please hold","Fuel lines have not been secured","Ground crew are still on the pad","Loose containers are on the pad","Exhaust deflectors are not yet in position, please hold","There's heavy traffic right now, it's not safe for your vessel to launch","Another vessel has aerospace priority at this moment","Port officials are still aboard")
					msg("Negative [combined_first_name], request denied. [denialreason]. Try again in a few minutes.")
					sleep(rand(MIN_MSG_DELAY,MAX_MSG_DELAY)*60 SECONDS)
					msg("[callname], [combined_first_name], re-requesting permission to depart from [landing_zone].","[comm_first_name]")
					sleep(rand(MIN_MSG_DELAY,MAX_MSG_DELAY) SECONDS)
					msg("[combined_first_name], [callname]. Everything appears to be in order now, permission granted. Docking clamps released. [safetravels].")
			sleep(rand(MIN_MSG_DELAY,MAX_MSG_DELAY) SECONDS)
			msg("[thanks], [callname]. This is [combined_first_name] setting course for [destname], out.","[comm_first_name]")
		//SDF event: starting patrol
		if("sdfbeginpatrol")
			var/safetravels = pick("Fly safe out there","Good luck","Good hunting","Safe travels","Godspeed","Stars guide you")
			var/thanks = pick("Appreciated","Thanks","Don't worry about us","We'll be fine","You too")
			var/takeoff = pick("depart","launch","take off","dust off")
			msg("[callname], [combined_first_name], requesting permission to [takeoff] from [landing_zone] to begin system patrol.","[comm_first_name]")
			sleep(rand(MIN_MSG_DELAY,MAX_MSG_DELAY) SECONDS)
			msg("[combined_first_name], [callname]. Permission granted. Docking clamps released. [safetravels].")
			sleep(rand(MIN_MSG_DELAY,MAX_MSG_DELAY) SECONDS)
			msg("[thanks], [callname]. This is [combined_first_name] beginning system patrol, out.","[comm_first_name]")
		//Ship event: undocking request (denied)
		if("undockingdenied")
			var/takeoff = pick("depart","launch")
			var/denialreason = pick("Security is requesting a full cargo inspection","Your ship has been impounded for multiple [pick("security","safety")] violations","Your ship is currently under quarantine lockdown","We have reason to believe there's an issue with your papers","Security personnel are currently searching for a fugitive and have ordered all outbound ships remain grounded until further notice")
			msg("[callname], [combined_first_name], requesting permission to [takeoff] from [landing_zone].","[comm_first_name]")
			sleep(rand(MIN_MSG_DELAY,MAX_MSG_DELAY) SECONDS)
			msg("Negative [combined_first_name], request denied. [denialreason].")
		if("slogan")
			msg("The following is a sponsored message from [name].","Facility PA")
			sleep(5 SECONDS)
			msg("[slogan]","Facility PA")
		else //time for generic message
			msg("[callname], [combined_first_name] on [mission] [pick(mission_noun)] to [destname], requesting [request].","[comm_first_name]")
			sleep(rand(MIN_MSG_DELAY,MAX_MSG_DELAY) SECONDS)
			msg("[combined_first_name], [callname], [response].")
			sleep(rand(MIN_MSG_DELAY,MAX_MSG_DELAY) SECONDS)
			msg("[callname], [yes ? "thank you" : "understood"], out.","[comm_first_name]")
	return //oops, forgot to restore this

/*	//OLD BLOCK, for reference
	//Ship sends request to ATC
	msg(full_request,"[comm_first_name]"
	sleep(rand(MIN_MSG_DELAY,MAX_MSG_DELAY) SECONDS)
	//ATC sends response to ship
	msg(full_response)
	sleep(rand(MIN_MSG_DELAY,MAX_MSG_DELAY) SECONDS)
	//Ship sends response to ATC
	msg(full_closure,"[comm_first_name]")
	return
*/

#undef MIN_MSG_DELAY
#undef MAX_MSG_DELAY
