//Cactus, Speedbird, Dynasty, oh my
//Also, massive additions/refactors by Killian, because the original incarnation was full of holes
//Originally coded by above, massive refactor here to use datums instead of an if/else mess - Willbird
SUBSYSTEM_DEF(atc)
	name = "Air Traffic Control"
	priority = FIRE_PRIORITY_ATC
	runlevels = RUNLEVEL_GAME

	var/delay_min = 45 MINUTES				//How long between ATC traffic, minimum
	var/delay_max = 90 MINUTES				//Ditto, maximum
							//Shorter delays means more traffic, which gives the impression of a busier system, but also means a lot more radio noise
	var/backoff_delay = 5 MINUTES			//How long to back off if we can't talk and want to.  Default is 5 mins.
	var/initial_delay = 15 MINUTES			//How long to wait before sending the first message of the shift.
	var/squelched = FALSE					//If ATC is squelched currently
	var/first_tick = TRUE

	//define a block of frequencies so we can have them be static instead of being random for each call
	var/ertchannel
	var/medchannel
	var/engchannel
	var/secchannel
	var/sdfchannel

/datum/controller/subsystem/atc/Initialize()
	//generate our static event frequencies for the shift. alternately they can be completely fixed, up in the core block
	ertchannel = "[rand(700,749)].[rand(1,9)]"
	medchannel = "[rand(750,799)].[rand(1,9)]"
	engchannel = "[rand(800,849)].[rand(1,9)]"
	secchannel = "[rand(850,899)].[rand(1,9)]"
	sdfchannel = "[rand(900,999)].[rand(1,9)]"
	admin_notice(span_danger("Air traffic control initialized."))
	wait = 5 SECONDS
	return SS_INIT_SUCCESS

/datum/controller/subsystem/atc/fire()
	if(first_tick)
		first_tick = FALSE
		start_shift()
		wait = initial_delay
		return
	if(squelched)
		wait = backoff_delay
		return
	random_convo()
	wait = rand(delay_min,delay_max)

/datum/controller/subsystem/atc/proc/start_shift() // Override/replace me!
	PRIVATE_PROC(TRUE)
	msg("New shift beginning, resuming traffic control. This shift's Colony Frequencies are as follows: Emergency Responders: [ertchannel]. Medical: [medchannel]. Engineering: [engchannel]. Security: [secchannel]. System Defense: [sdfchannel].")

/datum/controller/subsystem/atc/proc/msg(var/message,var/sender)
	ASSERT(message)
	global_announcer.autosay("[message]", sender ? sender : "[using_map.dock_name] Control")

/datum/controller/subsystem/atc/proc/reroute_traffic(var/yes = 1)
	if(yes)
		if(!squelched)
			msg("Rerouting traffic away from [using_map.station_name].")
		squelched = 1
	else
		if(squelched)
			msg("Resuming normal traffic routing around [using_map.station_name].")
		squelched = 0

/datum/controller/subsystem/atc/proc/shift_ending()
	new /datum/atc_chatter/shift_end(null,null)

/datum/controller/subsystem/atc/proc/random_convo()
	SHOULD_NOT_OVERRIDE(TRUE)
	PRIVATE_PROC(TRUE)

	// Pick from the organizations in the LOREMASTER, so we can find out what these ships are doing
	var/one = pick(loremaster.organizations) //These will pick an index, not an instance
	var/two = pick(loremaster.organizations)
	var/datum/lore/organization/source = loremaster.organizations[one] //Resolve to the instances
	var/datum/lore/organization/secondary = loremaster.organizations[two] //repurposed for new fun stuff

	//Random chance things for variety
	var/path = chatter_box(source.org_type,secondary.org_type)
	new path(source,secondary)

// Override/Replace me downstream if you need different chatter, call parent at end if you want this dialog too! Returns a subtype path of /datum/atc_chatter!
/datum/controller/subsystem/atc/proc/chatter_box(var/org_type,var/org_type2)
	PRIVATE_PROC(TRUE)
	if((org_type == "government" || org_type == "neutral" || org_type == "military" || org_type == "corporate" || org_type == "system defense" || org_type == "spacer") && org_type2 == "pirate") //this is ugly but when I tried to do it with !='s it fired for pirate-v-pirate, still not sure why. might as well stick it up here so it takes priority over other combos.
		return /datum/atc_chatter/distress
	if(org_type == "corporate") //corporate-specific subset for the slogan event. despite the relatively high weight it was still quite rare in tests.
		return pick(5;/datum/atc_chatter/emerg,
					25;/datum/atc_chatter/policescan,
					25;/datum/atc_chatter/traveladvisory,
					30;/datum/atc_chatter/pathwarning,
					180;/datum/atc_chatter/dockingrequestgeneric,
					30;/datum/atc_chatter/undockingrequest,
					/datum/atc_chatter/misc,
					30;/datum/atc_chatter/undockingdenied,
					50;/datum/atc_chatter/slogan,
					25;/datum/atc_chatter/civvieleaks,
					25;/datum/atc_chatter/report_to_dock)
	if((org_type == "government" || org_type == "neutral" || org_type == "military"))
		return pick(5;/datum/atc_chatter/emerg,
					25;/datum/atc_chatter/policescan,
					25;/datum/atc_chatter/traveladvisory,
					30;/datum/atc_chatter/pathwarning,
					180;/datum/atc_chatter/dockingrequestgeneric,
					30;/datum/atc_chatter/undockingrequest,
					/datum/atc_chatter/misc,
					30;/datum/atc_chatter/undockingdenied,
					25;/datum/atc_chatter/civvieleaks,
					25;/datum/atc_chatter/report_to_dock)
	if(org_type == "spacer")
		return pick(5;/datum/atc_chatter/emerg,
					15;/datum/atc_chatter/policescan,
					15;/datum/atc_chatter/traveladvisory,
					5;/datum/atc_chatter/pathwarning,
					150;/datum/atc_chatter/dockingrequestgeneric,
					30;/datum/atc_chatter/undockingrequest,
					/datum/atc_chatter/misc,
					10;/datum/atc_chatter/undockingdenied,
					25;/datum/atc_chatter/civvieleaks,
					25;/datum/atc_chatter/report_to_dock)
	//the following filters *always* fire their 'unique' event when they're tripped, simply because the conditions behind them are quite rare to begin with
	if(org_type == "smuggler" && org_type2 != "system defense") //just straight up funnel smugglers into always being caught, otherwise we get them asking for traffic info and stuff
		return /datum/atc_chatter/policeflee
	if(org_type == "smuggler" && org_type2 == "system defense") //ditto, if an SDF ship catches them
		return /datum/atc_chatter/policeshipflee
	if((org_type == "smuggler" || org_type == "pirate") && (org_type2 == "system defense" || org_type2 == "military")) //if we roll this combo instead, time for the SDF or Mercs to do their fucking jobs
		return /datum/atc_chatter/policeshipcombat
	if((org_type == "smuggler" || org_type == "pirate") && org_type2 != "system defense") //but if we roll THIS combo, time to alert the SDF to get off their asses
		return /datum/atc_chatter/hostiledetected
	//SDF-specific events that need to filter based on the second party (basically just the following SDF-unique list with the soft-result ship scan thrown in)
	if(org_type == "system defense" && (org_type2 == "government" || org_type2 == "neutral" || org_type2 == "military" || org_type2 == "corporate" || org_type2 == "spacer")) //let's see if we can narrow this down, I didn't see many ship-to-ship scans
		return pick(75;/datum/atc_chatter/policeshipscan,
					/datum/atc_chatter/sdfpatrolupdate,
					75;/datum/atc_chatter/sdfendingpatrol,
					180;/datum/atc_chatter/dockingrequestgeneric,
					20;/datum/atc_chatter/undockingrequest,
					75;/datum/atc_chatter/sdfbeginpatrol,
					50;/datum/atc_chatter/misc,
					10;/datum/atc_chatter/civvieleaks,
					70;/datum/atc_chatter/sdfchatter)
	//SDF-specific events that don't require the secondary at all, in the event that we manage to roll SDF + hostile/smuggler or something
	if(org_type == "system defense")
		return pick(/datum/atc_chatter/sdfpatrolupdate,
					60;/datum/atc_chatter/sdfendingpatrol,
					120;/datum/atc_chatter/dockingrequestgeneric,
					20;/datum/atc_chatter/undockingrequest,
					80;/datum/atc_chatter/sdfbeginpatrol,
					/datum/atc_chatter/misc,
					/datum/atc_chatter/sdfchatter)
	//if we somehow don't match any of the other existing filters once we've run through all of them
	return pick(5;/datum/atc_chatter/emerg,
				25;/datum/atc_chatter/policescan,
				25;/datum/atc_chatter/traveladvisory,
				30;/datum/atc_chatter/pathwarning,
				90;/datum/atc_chatter/dockingrequestgeneric,
				30;/datum/atc_chatter/undockingrequest,
				30;/datum/atc_chatter/undockingdenied,
				/datum/atc_chatter/misc,
				25;/datum/atc_chatter/civvieleaks)
