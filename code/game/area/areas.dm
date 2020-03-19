// Areas.dm

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

	var/power_equip = 1
	var/power_light = 1
	var/power_environ = 1
	var/music = null
	var/used_equip = 0
	var/used_light = 0
	var/used_environ = 0

	var/has_gravity = 1
	var/secret_name = FALSE // This tells certain things that display areas' names that they shouldn't display this area's name.
	var/obj/machinery/power/apc/apc = null
	var/no_air = null
//	var/list/lights				// list of all lights on this area
	var/list/all_doors = null		//Added by Strumpetplaya - Alarm Change - Contains a list of doors adjacent to this area
	var/firedoors_closed = 0
	var/list/ambience = list()
	var/list/forced_ambience = null
	var/sound_env = STANDARD_STATION
	var/turf/base_turf //The base turf type of the area, which can be used to override the z-level's base turf
	var/forbid_events = FALSE // If true, random events will not start inside this area.

/area/Initialize()
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
	return INITIALIZE_HINT_LATELOAD

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
		if(T.dynamic_lighting && old_area.dynamic_lighting != A.dynamic_lighting)
			if(A.dynamic_lighting)
				T.lighting_build_overlay()
			else
				T.lighting_clear_overlay()
		for(var/atom/movable/AM in T)
			old_area.Exited(AM, A)
	for(var/atom/movable/AM in T)
		A.Entered(AM, old_area)
	for(var/obj/machinery/M in T)
		M.power_change()

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

// Either close or open firedoors depending on current alert statuses
/area/proc/firedoors_update()
	if(fire || party || atmosalm)
		firedoors_close()
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


/area/proc/fire_alert()
	if(!fire)
		fire = 1	//used for firedoor checks
		updateicon()
		firedoors_update()

/area/proc/fire_reset()
	if (fire)
		fire = 0	//used for firedoor checks
		updateicon()
		firedoors_update()

/area/proc/readyalert()
	if(!eject)
		eject = 1
		updateicon()
	return

/area/proc/readyreset()
	if(eject)
		eject = 0
		updateicon()
	return

/area/proc/partyalert()
	if (!( party ))
		party = 1
		updateicon()
		firedoors_update()
	return

/area/proc/partyreset()
	if (party)
		party = 0
		updateicon()
		firedoors_update()
	return

/area/proc/updateicon()
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


/*
#define EQUIP 1
#define LIGHT 2
#define ENVIRON 3
*/

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
		updateicon()

/area/proc/usage(var/chan)
	var/used = 0
	switch(chan)
		if(LIGHT)
			used += used_light
		if(EQUIP)
			used += used_equip
		if(ENVIRON)
			used += used_environ
		if(TOTAL)
			used += used_light + used_equip + used_environ
	return used

/area/proc/clear_usage()
	used_equip = 0
	used_light = 0
	used_environ = 0

/area/proc/use_power(var/amount, var/chan)
	switch(chan)
		if(EQUIP)
			used_equip += amount
		if(LIGHT)
			used_light += amount
		if(ENVIRON)
			used_environ += amount


var/list/mob/living/forced_ambiance_list = new

/area/Entered(A)
	if(!istype(A,/mob/living))	return

	var/mob/living/L = A
	if(!L.ckey)	return

	if(!L.lastarea)
		L.lastarea = get_area(L.loc)
	var/area/newarea = get_area(L.loc)
	var/area/oldarea = L.lastarea
	if((oldarea.has_gravity == 0) && (newarea.has_gravity == 1) && (L.m_intent == "run")) // Being ready when you change areas gives you a chance to avoid falling all together.
		thunk(L)
		L.update_floating( L.Check_Dense_Object() )

	L.lastarea = newarea
	play_ambience(L)

/area/proc/play_ambience(var/mob/living/L)
	// Ambience goes down here -- make sure to list each area seperately for ease of adding things in later, thanks! Note: areas adjacent to each other should have the same sounds to prevent cutoff when possible.- LastyScratch
	if(!(L && L.is_preference_enabled(/datum/client_preference/play_ambiance)))	return

	// If we previously were in an area with force-played ambiance, stop it.
	if(L in forced_ambiance_list)
		L << sound(null, channel = CHANNEL_AMBIENCE_FORCED)
		forced_ambiance_list -= L

	if(forced_ambience)
		if(forced_ambience.len)
			forced_ambiance_list |= L
			var/sound/chosen_ambiance = pick(forced_ambience)
			if(!istype(chosen_ambiance))
				chosen_ambiance = sound(chosen_ambiance, repeat = 1, wait = 0, volume = 25, channel = CHANNEL_AMBIENCE_FORCED)
			L << chosen_ambiance
		else
			L << sound(null, channel = CHANNEL_AMBIENCE_FORCED)
	else if(src.ambience.len && prob(35))
		if((world.time >= L.client.time_last_ambience_played + 1 MINUTE))
			var/sound = pick(ambience)
			L << sound(sound, repeat = 0, wait = 0, volume = 50, channel = CHANNEL_AMBIENCE)
			L.client.time_last_ambience_played = world.time

/area/proc/gravitychange(var/gravitystate = 0)
	src.has_gravity = gravitystate

	for(var/mob/M in src)
		if(has_gravity)
			thunk(M)
		M.update_floating( M.Check_Dense_Object() )

/area/proc/thunk(mob)
	if(istype(get_turf(mob), /turf/space)) // Can't fall onto nothing.
		return

	if(istype(mob,/mob/living/carbon/human/))
		var/mob/living/carbon/human/H = mob
		if(H.buckled)
			return // Being buckled to something solid keeps you in place.
		if(istype(H.shoes, /obj/item/clothing/shoes/magboots) && (H.shoes.item_flags & NOSLIP))
			return

		if(H.m_intent == "run")
			H.AdjustStunned(6)
			H.AdjustWeakened(6)
		else
			H.AdjustStunned(3)
			H.AdjustWeakened(3)
		to_chat(mob, "<span class='notice'>The sudden appearance of gravity makes you fall to the floor!</span>")
		playsound(get_turf(src), "bodyfall", 50, 1)

/area/proc/prison_break()
	var/obj/machinery/power/apc/theAPC = get_apc()
	if(theAPC.operating)
		for(var/obj/machinery/power/apc/temp_apc in src)
			temp_apc.overload_lighting(70)
		for(var/obj/machinery/door/airlock/temp_airlock in src)
			temp_airlock.prison_open()
		for(var/obj/machinery/door/window/temp_windoor in src)
			temp_windoor.open()
		for(var/obj/machinery/door/blast/temp_blast in src)
			temp_blast.open()

/area/has_gravity()
	return has_gravity

/area/space/has_gravity()
	return 0

/proc/has_gravity(atom/AT, turf/T)
	if(!T)
		T = get_turf(AT)
	var/area/A = get_area(T)
	if(A && A.has_gravity())
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
	if(secret_name)
		return "Unknown Area"
	return name