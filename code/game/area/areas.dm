// Areas.dm

GLOBAL_LIST_EMPTY(areas_by_type)

/area
	var/fire = null
	var/atmos = 1
	var/atmosalm = 0
	var/poweralm = 1
	var/party = null
	level = null
	name = "Unknown"
	icon = 'icons/turf/areas.dmi'
	icon_state = "unknown"
	plane = PLANE_LIGHTING_ABOVE //In case we color them
	luminosity = 0
	mouse_opacity = 0
	var/lightswitch = 1

	var/eject = null

	var/debug = 0
	var/requires_power = 1
	var/always_unpowered = 0	//this gets overriden to 1 for space in area/New()

	// Power channel status - Is it currently energized?
	var/power_equip = TRUE
	var/power_light = TRUE
	var/power_environ = TRUE

	// Oneoff power usage - Used once and cleared each power cycle
	var/oneoff_equip = 0
	var/oneoff_light = 0
	var/oneoff_environ = 0

	// Continuous "static" power usage - Do not update these directly!
	var/static_equip = 0
	var/static_light = 0
	var/static_environ = 0

	var/music = null
	var/has_gravity = 1 // Don't check this var directly; use get_gravity() instead
	var/obj/machinery/power/apc/apc = null
	var/no_air = null
//	var/list/lights				// list of all lights on this area
	var/list/all_doors = null		//Added by Strumpetplaya - Alarm Change - Contains a list of doors adjacent to this area
	var/list/all_arfgs = null		//Similar, but a list of all arfgs adjacent to this area
	var/firedoors_closed = 0
	var/arfgs_active = 0
	var/list/ambience = list()
	var/list/forced_ambience = null
	var/sound_env = STANDARD_STATION
	var/turf/base_turf //The base turf type of the area, which can be used to override the z-level's base turf

/area/New()
	// Used by the maploader, this must be done in New, not init
	GLOB.areas_by_type[type] = src
	return ..()

/area/Initialize(mapload)
	. = ..()
	luminosity = !(dynamic_lighting)
	icon_state = ""
	return INITIALIZE_HINT_LATELOAD // Areas tradiationally are initialized AFTER other atoms.

/area/LateInitialize()
	if(!requires_power || !apc)
		power_light = 0
		power_equip = 0
		power_environ = 0
	power_change()		// all machines set to current power level, also updates lighting icon
	if(flag_check(AREA_NO_SPOILERS))
		set_spoiler_obfuscation(TRUE)

// Changes the area of T to A. Do not do this manually.
// Area is expected to be a non-null instance.
/proc/ChangeArea(var/turf/T, var/area/A)
	if(!istype(A))
		CRASH("Area change attempt failed: invalid area supplied.")
	var/area/old_area = get_area(T)
	if(old_area == A)
		return
	// NOTE: BayStation calles area.Exited/Entered for the TURF T.  So far we don't do that.s
	// NOTE: There probably won't be any atoms in these turfs, but just in case we should call these procs.
	A.contents.Add(T)
	if(old_area)
		// Handle dynamic lighting update if
		if(SSlighting.subsystem_initialized && T.dynamic_lighting && old_area.dynamic_lighting != A.dynamic_lighting)
			if(A.dynamic_lighting)
				T.lighting_build_overlay()
			else
				T.lighting_clear_overlay()
		for(var/atom/movable/AM in T)
			old_area.Exited(AM, A)
	for(var/atom/movable/AM in T)
		A.Entered(AM, old_area)
	for(var/obj/machinery/M in T)
		M.area_changed(old_area, A)

/area/proc/get_contents()
	return contents

/area/proc/get_cameras()
	var/list/cameras = list()
	for (var/obj/machinery/camera/C in src)
		cameras += C
	return cameras

/area/proc/atmosalert(danger_level, var/alarm_source)
	if (danger_level == 0)
		atmosphere_alarm.clearAlarm(src, alarm_source)
	else
		var/obj/machinery/alarm/atmosalarm = alarm_source //maybe other things can trigger these, who knows
		if(istype(atmosalarm))
			atmosphere_alarm.triggerAlarm(src, alarm_source, severity = danger_level, hidden = atmosalarm.alarms_hidden)
		else
			atmosphere_alarm.triggerAlarm(src, alarm_source, severity = danger_level)

	//Check all the alarms before lowering atmosalm. Raising is perfectly fine.
	for (var/obj/machinery/alarm/AA in src)
		if (!(AA.stat & (NOPOWER|BROKEN)) && !AA.shorted && AA.report_danger_level)
			danger_level = max(danger_level, AA.danger_level)

	if(danger_level != atmosalm)
		atmosalm = danger_level
		//closing the doors on red and opening on green provides a bit of hysteresis that will hopefully prevent fire doors from opening and closing repeatedly due to noise
		if (danger_level < 1 || danger_level >= 2)
			firedoors_update()

		for (var/obj/machinery/alarm/AA in src)
			AA.update_icon()

		return 1
	return 0

// Either close or open firedoors and arfgs depending on current alert statuses
/area/proc/firedoors_update()
	if(fire || party || atmosalm)
		firedoors_close()
		arfgs_activate()
		// VOREStation Edit - Make the lights colored!
		if(fire)
			for(var/obj/machinery/light/L in src)
				L.set_alert_fire()
		else if(atmosalm)
			for(var/obj/machinery/light/L in src)
				L.set_alert_atmos()
		// VOREStation Edit End
	else
		firedoors_open()
		arfgs_deactivate()
		// VOREStation Edit - Put the lights back!
		for(var/obj/machinery/light/L in src)
			L.reset_alert()
		// VOREStation Edit End

// Close all firedoors in the area
/area/proc/firedoors_close()
	if(!firedoors_closed)
		firedoors_closed = TRUE
		if(!all_doors)
			return
		for(var/obj/machinery/door/firedoor/E in all_doors)
			if(!E.blocked)
				if(E.operating)
					E.nextstate = FIREDOOR_CLOSED
				else if(!E.density)
					spawn(0)
						E.close()

// Open all firedoors in the area
/area/proc/firedoors_open()
	if(firedoors_closed)
		firedoors_closed = FALSE
		if(!all_doors)
			return
		for(var/obj/machinery/door/firedoor/E in all_doors)
			if(!E.blocked)
				if(E.operating)
					E.nextstate = FIREDOOR_OPEN
				else if(E.density)
					spawn(0)
						E.open()

// Activate all retention fields!
/area/proc/arfgs_activate()
	if(!arfgs_active)
		arfgs_active = TRUE
		if(!all_arfgs)
			return
		for(var/obj/machinery/atmospheric_field_generator/E in all_arfgs)
			E.generate_field() //don't need to check powered state like doors, the arfgs handles it on its end
			E.wasactive = TRUE

// Deactivate retention fields!
/area/proc/arfgs_deactivate()
	if(arfgs_active)
		arfgs_active = FALSE
		if(!all_arfgs)
			return
		for(var/obj/machinery/atmospheric_field_generator/E in all_arfgs)
			E.disable_field()
			E.wasactive = FALSE

/area/proc/fire_alert()
	if(!fire)
		fire = 1	//used for firedoor checks
		update_icon()
		firedoors_update()

/area/proc/fire_reset()
	if (fire)
		fire = 0	//used for firedoor checks
		update_icon()
		firedoors_update()

/area/proc/readyalert()
	if(!eject)
		eject = 1
		update_icon()
	return

/area/proc/readyreset()
	if(eject)
		eject = 0
		update_icon()
	return

/area/proc/partyalert()
	if (!( party ))
		party = 1
		update_icon()
		firedoors_update()
	return

/area/proc/partyreset()
	if (party)
		party = 0
		update_icon()
		firedoors_update()
	return

/area/update_icon()
	if ((fire || eject || party) && (!requires_power||power_environ) && !istype(src, /area/space))//If it doesn't require power, can still activate this proc.
		if(fire && !eject && !party)
			icon_state = null // Let lights take care of it
		/*else if(atmosalm && !fire && !eject && !party)
			icon_state = "bluenew"*/
		else if(!fire && eject && !party)
			icon_state = "red"
		else if(party && !fire && !eject)
			icon_state = "party"
		else
			icon_state = "blue-red"
	else
	//	new lighting behaviour with obj lights
		icon_state = null

/area/proc/powered(var/chan)		// return true if the area has power to given channel

	if(!requires_power)
		return 1
	if(always_unpowered)
		return 0
	switch(chan)
		if(EQUIP)
			return power_equip
		if(LIGHT)
			return power_light
		if(ENVIRON)
			return power_environ

	return 0

// called when power status changes
/area/proc/power_change()
	for(var/obj/machinery/M in src)	// for each machine in the area
		M.power_change()			// reverify power status (to update icons etc.)
	if (fire || eject || party)
		update_icon()

/area/proc/usage(var/chan, var/include_static = TRUE)
	var/used = 0
	switch(chan)
		if(LIGHT)
			used += oneoff_light + (include_static * static_light)
		if(EQUIP)
			used += oneoff_equip + (include_static * static_equip)
		if(ENVIRON)
			used += oneoff_environ + (include_static * static_environ)
		if(TOTAL)
			used += oneoff_light + (include_static * static_light)
			used += oneoff_equip + (include_static * static_equip)
			used += oneoff_environ + (include_static * static_environ)
	return used

// Helper for APCs; will generally be called every tick.
/area/proc/clear_usage()
	oneoff_equip = 0
	oneoff_light = 0
	oneoff_environ = 0

// Use this for a one-time power draw from the area, typically for non-machines.
/area/proc/use_power_oneoff(var/amount, var/chan)
	switch(chan)
		if(EQUIP)
			oneoff_equip += amount
		if(LIGHT)
			oneoff_light += amount
		if(ENVIRON)
			oneoff_environ += amount
	return amount

// This is used by machines to properly update the area of power changes.
/area/proc/power_use_change(old_amount, new_amount, chan)
	use_power_static(new_amount - old_amount, chan) // Simultaneously subtract old_amount and add new_amount.

// Not a proc you want to use directly unless you know what you are doing; see use_power_oneoff above instead.
/area/proc/use_power_static(var/amount, var/chan)
	switch(chan)
		if(EQUIP)
			static_equip += amount
		if(LIGHT)
			static_light += amount
		if(ENVIRON)
			static_environ += amount

// This recomputes the continued power usage; can be used for testing or error recovery, but is not called every tick.
/area/proc/retally_power()
	static_equip = 0
	static_light = 0
	static_environ = 0
	for(var/obj/machinery/M in src)
		switch(M.power_channel)
			if(EQUIP)
				static_equip += M.get_power_usage()
			if(LIGHT)
				static_light += M.get_power_usage()
			if(ENVIRON)
				static_environ += M.get_power_usage()

//////////////////////////////////////////////////////////////////

/area/vv_get_dropdown()
	. = ..()
	VV_DROPDOWN_OPTION("check_static_power", "Check Static Power")

/area/vv_do_topic(list/href_list)
	. = ..()
	IF_VV_OPTION("check_static_power")
		if(!check_rights(R_DEBUG))
			return
		src.check_static_power(usr)
		href_list["datumrefresh"] = "\ref[src]"

// Debugging proc to report if static power is correct or not.
/area/proc/check_static_power(var/user)
	set name = "Check Static Power"
	var/actual_static_equip = static_equip
	var/actual_static_light = static_light
	var/actual_static_environ = static_environ
	retally_power()
	if(user)
		var/list/report = list("[src] ([type]) static power tally:")
		report += "EQUIP:   Actual: [actual_static_equip] Correct: [static_equip] Difference: [actual_static_equip - static_equip]"
		report += "LIGHT:   Actual: [actual_static_light] Correct: [static_light] Difference: [actual_static_light - static_light]"
		report += "ENVIRON: Actual: [actual_static_environ] Correct: [static_environ] Difference: [actual_static_environ - static_environ]"
		to_chat(user, report.Join("\n"))
	return (actual_static_equip == static_equip && actual_static_light == static_light && actual_static_environ == static_environ)

//////////////////////////////////////////////////////////////////

var/list/mob/living/forced_ambiance_list = new

/area/Entered(mob/M)
	if(!istype(M) || !M.ckey)
		return

	if(!isliving(M))
		M.lastarea = src
		return

	var/mob/living/L = M
	if(!L.lastarea)
		L.lastarea = src
	var/area/oldarea = L.lastarea
	if((oldarea.get_gravity() == 0) && (get_gravity() == 1) && (L.m_intent == I_RUN)) // Being ready when you change areas gives you a chance to avoid falling all together.
		thunk(L)
		L.update_floating( L.Check_Dense_Object() )

	L.lastarea = src
	L.lastareachange = world.time
	play_ambience(L, initial = TRUE)
	if(flag_check(AREA_NO_SPOILERS))
		L.disable_spoiler_vision()
	check_phase_shift(M)	//RS Port #658

/area/proc/play_ambience(var/mob/living/L, initial = TRUE)
	// Ambience goes down here -- make sure to list each area seperately for ease of adding things in later, thanks! Note: areas adjacent to each other should have the same sounds to prevent cutoff when possible.- LastyScratch
	if(!L?.read_preference(/datum/preference/toggle/play_ambience))
		return

	var/volume_mod = L.get_preference_volume_channel(VOLUME_CHANNEL_AMBIENCE)

	// If we previously were in an area with force-played ambiance, stop it.
	if((L in forced_ambiance_list) && initial)
		L << sound(null, channel = CHANNEL_AMBIENCE_FORCED)
		forced_ambiance_list -= L

	if(forced_ambience)
		if(L in forced_ambiance_list)
			return
		if(forced_ambience.len)
			forced_ambiance_list |= L
			var/sound/chosen_ambiance = pick(forced_ambience)
			if(!istype(chosen_ambiance))
				chosen_ambiance = sound(chosen_ambiance, repeat = 1, wait = 0, volume = 25, channel = CHANNEL_AMBIENCE_FORCED)
			chosen_ambiance.volume *= volume_mod
			L << chosen_ambiance
		else
			L << sound(null, channel = CHANNEL_AMBIENCE_FORCED)
	else if(src.ambience && src.ambience.len)
		var/ambience_odds = L.read_preference(/datum/preference/numeric/ambience_chance)
		if(prob(ambience_odds) && (world.time >= L.client.time_last_ambience_played + 1 MINUTE))
			var/sound = pick(ambience)
			L << sound(sound, repeat = 0, wait = 0, volume = 50 * volume_mod, channel = CHANNEL_AMBIENCE)
			L.client.time_last_ambience_played = world.time

/area/proc/gravitychange(var/gravitystate = 0)
	src.has_gravity = gravitystate

	for(var/mob/M in src)
		if(get_gravity())
			thunk(M)
		M.update_floating( M.Check_Dense_Object() )
		M.update_gravity(get_gravity())

/area/proc/thunk(mob)
	if(istype(get_turf(mob), /turf/space)) // Can't fall onto nothing.
		return

	if(istype(mob,/mob/living/carbon/human/))
		var/mob/living/carbon/human/H = mob
		if(H.buckled)
			return // Being buckled to something solid keeps you in place.
		if(istype(H.shoes, /obj/item/clothing/shoes/magboots) && (H.shoes.item_flags & NOSLIP))
			return
		if(H.is_incorporeal()) // VOREstation edit - Phaseshifted beings should not be affected by gravity
			return
		if(H.species.can_zero_g_move || H.species.can_space_freemove)
			return

		if(H.m_intent == I_RUN)
			H.AdjustStunned(6)
			H.AdjustWeakened(6)
		else
			H.AdjustStunned(3)
			H.AdjustWeakened(3)
		to_chat(mob, span_notice("The sudden appearance of gravity makes you fall to the floor!"))
		playsound(mob, "bodyfall", 50, 1)

/area/proc/prison_break(break_lights = TRUE, open_doors = TRUE, open_blast_doors = TRUE)
	var/obj/machinery/power/apc/theAPC = get_apc()
	if(theAPC && theAPC.operating)
		if(break_lights)
			for(var/obj/machinery/power/apc/temp_apc in src)
				temp_apc.overload_lighting(70)
		if(open_doors)
			for(var/obj/machinery/door/airlock/temp_airlock in src)
				temp_airlock.prison_open()
			for(var/obj/machinery/door/window/temp_windoor in src)
				temp_windoor.open()
		if(open_blast_doors)
			for(var/obj/machinery/door/blast/temp_blast in src)
				temp_blast.open()

/area/get_gravity()
	return has_gravity

/area/space/get_gravity()
	return 0

/proc/get_gravity(atom/AT, turf/T)
	if(!T)
		T = get_turf(AT)
	var/area/A = get_area(T)
	if(A && A.get_gravity())
		return 1
	return 0

/area/proc/shuttle_arrived()
	return TRUE

/area/proc/shuttle_departed()
	return TRUE

/area/AllowDrop()
	CRASH("Bad op: area/AllowDrop() called")

/area/drop_location()
	CRASH("Bad op: area/drop_location() called")

/*Adding a wizard area teleport list because motherfucking lag -- Urist*/
/*I am far too lazy to make it a proper list of areas so I'll just make it run the usual telepot routine at the start of the game*/
var/list/teleportlocs = list()

/hook/startup/proc/setupTeleportLocs()
	for(var/area/AR in world)
		if(istype(AR, /area/shuttle) || istype(AR, /area/syndicate_station) || istype(AR, /area/wizard_station)) continue
		if(teleportlocs.Find(AR.name)) continue
		var/turf/picked = pick(get_area_turfs(AR.type))
		if (picked.z in using_map.station_levels)
			teleportlocs += AR.name
			teleportlocs[AR.name] = AR

	teleportlocs = sortAssoc(teleportlocs)

	return 1

var/list/ghostteleportlocs = list()

/hook/startup/proc/setupGhostTeleportLocs()
	for(var/area/AR in world)
		if(ghostteleportlocs.Find(AR.name)) continue
		if(istype(AR, /area/aisat) || istype(AR, /area/derelict) || istype(AR, /area/tdome) || istype(AR, /area/shuttle/specops/centcom))
			ghostteleportlocs += AR.name
			ghostteleportlocs[AR.name] = AR
		var/turf/picked = pick(get_area_turfs(AR.type))
		if (picked.z in using_map.player_levels)
			ghostteleportlocs += AR.name
			ghostteleportlocs[AR.name] = AR

	ghostteleportlocs = sortAssoc(ghostteleportlocs)

	return 1

/area/proc/get_name()
	if(flag_check(AREA_SECRET_NAME))
		return "Unknown Area"
	return name

GLOBAL_DATUM(spoiler_obfuscation_image, /image)

/area/proc/set_spoiler_obfuscation(should_obfuscate)
	if(!GLOB.spoiler_obfuscation_image)
		GLOB.spoiler_obfuscation_image = image(icon = 'icons/misc/static.dmi')
		GLOB.spoiler_obfuscation_image.plane = PLANE_MESONS

	if(should_obfuscate)
		add_overlay(GLOB.spoiler_obfuscation_image)
	else
		cut_overlay(GLOB.spoiler_obfuscation_image)

/area/proc/flag_check(var/flag, var/match_all = FALSE)
    if(match_all)
        return (flags & flag) == flag
    return flags & flag

// RS Port #658 Start
/area/proc/check_phase_shift(var/mob/ourmob)
	if(!flag_check(AREA_BLOCK_PHASE_SHIFT) || !ourmob.is_incorporeal())
		return
	if(!isliving(ourmob))
		return
	if(ourmob.client?.holder)
		return
	if(issimplekin(ourmob))
		var/mob/living/simple_mob/shadekin/SK = ourmob
		if(SK.ability_flags & AB_PHASE_SHIFTED)
			SK.phase_in(SK.loc)
	if(ishuman(ourmob))
		var/mob/living/carbon/human/SK = ourmob
		if(SK.ability_flags & AB_PHASE_SHIFTED)
			SK.phase_in(SK.loc)
// RS Port #658 End

/area/proc/isAlwaysIndoors()
	return FALSE

/area/shuttle/isAlwaysIndoors()
	return TRUE

/area/turbolift/isAlwaysIndoors()
	return TRUE
