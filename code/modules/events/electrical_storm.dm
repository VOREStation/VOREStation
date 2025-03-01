/datum/event/electrical_storm
	announceWhen = 0		// Warn them shortly before it begins.
	startWhen = 30			// 1 minute
	endWhen = 60			// Set in setup()
	has_skybox_image = TRUE
	var/tmp/lightning_color
	var/tmp/list/valid_apcs		// List of valid APCs.

/datum/event/electrical_storm/get_skybox_image()
	if(!lightning_color)
		lightning_color = pick("#ffd98c", "#ebc7ff", "#bdfcff", "#bdd2ff", "#b0ffca", "#ff8178", "#ad74cc")
	var/image/res = image('icons/skybox/electrobox.dmi', "lightning")
	res.color = lightning_color
	res.appearance_flags = RESET_COLOR
	res.blend_mode = BLEND_ADD
	return res

/datum/event/electrical_storm/announce()
	..()
	switch(severity)
		if(EVENT_LEVEL_MUNDANE)
			command_announcement.Announce("A minor electrical storm has been detected near the [location_name()]. Please watch out for possible electrical discharges.", "[location_name()] Sensor Array")
		if(EVENT_LEVEL_MODERATE)
			command_announcement.Announce("The [location_name()] is about to pass through an electrical storm. Please secure sensitive electrical equipment until the storm passes.", "[location_name()] Sensor Array")
		if(EVENT_LEVEL_MAJOR)
			command_announcement.Announce("Alert. A strong electrical storm has been detected in proximity of the [location_name()]. It is recommended to immediately secure sensitive electrical equipment until the storm passes.", "[location_name()] Sensor Array")

/datum/event/electrical_storm/start()
	..()
	valid_apcs = list()
	for(var/obj/machinery/power/apc/A in GLOB.apcs)
		if(A.z in affecting_z)
			valid_apcs.Add(A)
	endWhen = (severity * 60) + startWhen

/datum/event/electrical_storm/tick()
	..()
	// See if shields can stop it first
	var/list/shields = list()
	for(var/obj/machinery/power/shield_generator/G in GLOB.machines)
		if((G.z in affecting_z) && G.running && G.check_flag(MODEFLAG_EM))
			shields += G
	if(shields.len)
		var/obj/machinery/power/shield_generator/shield_gen = pick(shields)
		//Minor breaches aren't enough to let through frying amounts of power
		if(shield_gen.deal_shield_damage(30 * severity, SHIELD_DAMTYPE_EM) <= SHIELD_BREACHED_MINOR)
			return
	if(!valid_apcs.len)
		//	log_debug("No valid APCs found for electrical storm event ship=[victim]!")		// Let's not spam poor people with debug logs on (me)
		return
	var/list/picked_apcs = list()
	for(var/i=0, i< severity * 2, i++) // up to 2/4/6 APCs per tick depending on severity
		picked_apcs |= pick(valid_apcs)
	for(var/obj/machinery/power/apc/T in picked_apcs)
		affect_apc(T)

/datum/event/electrical_storm/proc/affect_apc(var/obj/machinery/power/apc/T)
	// Main breaker is turned off. Consider this APC protected.
	if(!T.operating)
		return

	// Decent chance to overload lighting circuit.
	if(prob(8 * severity))	//over double the original chance (3), because it's now only a one-in-four to blow the lights out entirely
		if(prob(75))	//flicker 'em
			for(var/obj/machinery/light/L in T.area)
				L.flicker(15)
		else	//blast 'em!
			T.overload_lighting()

	// Relatively small chance to emag the apc as apc_damage event does.
	if(prob(0.2 * severity))
		T.emagged = 1
		T.update_icon()

// Overmap version
/datum/event/electrical_storm/overmap/announce()
	return
