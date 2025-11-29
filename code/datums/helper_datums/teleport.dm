GLOBAL_LIST_INIT(bluespace_item_types, list(
	/obj/item/storage/backpack/holding,
	/obj/item/storage/bag/trash/holding,
	/obj/item/storage/pouch/holding,
	/obj/item/storage/belt/utility/holding,
	/obj/item/storage/belt/medical/holding
))

/proc/do_teleport(atom/movable/teleatom, atom/destination, precision = null, datum/effect/effect/effectin = null, datum/effect/effect/effectout = null, asoundin = null, asoundout = null, no_effects=FALSE, channel=TELEPORT_CHANNEL_BLUESPACE, forced = FALSE)
	if(istype(teleatom, /obj/effect) && !istype(teleatom, /obj/effect/dummy/chameleon)) // Earliest check because otherwise sparks will fuck you up
		qdel(teleatom)
		return FALSE

	if(isnull(precision))
		precision = 0

	switch(channel)
		if(TELEPORT_CHANNEL_BLUESPACE)
			var/list/bluespace_things = newlist()
			for(var/item in GLOB.bluespace_item_types)
				bluespace_things |= teleatom.search_contents_for(item)
			if(bluespace_things.len)
				precision = max(rand(1, 100)*bluespace_things.len, 100)
				if(isliving(teleatom))
					var/mob/living/mob = teleatom
					to_chat(mob, span_warning("The bluespace interface on your equipment interferes with the teleport!"))
			if((!effectin || !effectout) && !no_effects)
				var/datum/effect/effect/system/spark_spread/sparks = new
				sparks.set_up(5, 1, teleatom)
				if(!effectin)
					effectin = sparks
				if(!effectout)
					effectout = sparks

		if(TELEPORT_CHANNEL_QUANTUM)
			if((!effectin || !effectout) && !no_effects)
				var/datum/effect/effect/system/spark_spread/sparks = new
				sparks.set_up(5, 1, teleatom)
				if(!effectin)
					effectin = sparks
				if(!effectout)
					effectout = sparks

	var/turf/curturf = get_turf(teleatom)
	var/turf/destturf

	destturf = get_teleport_turf(get_turf(destination), precision)

	if(istype(destination, /obj/structure/closet)) // First check if it's a closet, for the bluespace locker funsies...
		destturf = destination

	if(isbelly(destination)) // And if it goes STRAIGHT to a belly? Toss them there. (If pref matches, of course)
		var/obj/belly/belly = destination
		if(can_spontaneous_vore(belly.owner, teleatom) && belly.owner != teleatom)
			destturf = destination

	// HOLD IT! destturf? Hell nah, televore finally works again.
	// Now CHECK if someone capable of televoring is in the same turf...

	if(isliving(teleatom))
		var/mob/living/telemob = teleatom
		var/mob/living/mob = locate() in destturf
		if(can_spontaneous_vore(mob, telemob))
			destturf = mob.vore_selected
		else if(can_spontaneous_vore(telemob, mob))
			mob.forceMove(telemob.vore_selected)

	if(!destturf || !curturf)
		return FALSE

	if(!forced)
		if(!check_teleport_valid(teleatom, destturf, channel, original_destination = destination))
			if(ismob(teleatom))
				teleatom.balloon_alert(teleatom, "something holds you back!")
			return FALSE

	if(SEND_SIGNAL(teleatom, COMSIG_MOVABLE_TELEPORTING, destination, channel))
		return FALSE
	if(SEND_SIGNAL(destturf, COMSIG_ATOM_INTERCEPT_TELEPORT, channel, curturf))
		return FALSE

	if(isobserver(teleatom))
		teleatom.forceMove(destturf)
		return TRUE

	tele_play_specials(teleatom, curturf, effectin, asoundin)

	if(teleatom.buckle_movable) // Specifically office chairs. Fuck you.
		teleatom.buckle_movable = FALSE

	var/success = teleatom.forceMove(destturf)

	teleatom.buckle_movable = initial(teleatom.buckle_movable) // Double fuck you, office chairs

	if(!success)
		return FALSE

	. = TRUE

	SEND_SIGNAL(teleatom, COMSIG_MOVABLE_POST_TELEPORT, destination, channel)

	if(teleatom.has_buckled_mobs())
		for(var/mob/living/rider in teleatom.buckled_mobs)
			teleatom.unbuckle_mob(rider, TRUE)

			var/rider_success = do_teleport(rider, destination, precision, channel = channel, no_effects = TRUE)
			if(!rider_success)
				continue

			if(get_turf(rider) != destturf)
				to_chat(rider, span_warning("As you come to your senses, you realize you aren't riding [teleatom] anymore!"))
				continue

			teleatom.buckle_mob(rider, TRUE)

/proc/tele_play_specials(atom/movable/teleatom, atom/location, var/datum/effect/effect/system/effect, sound)
	if(!location)
		return

	if(sound)
		playsound(location, sound, 60, TRUE)
	if(effect)
		effect.attach()
		effect.start()

/proc/find_safe_turf(zlevel, list/zlevels, dense_atoms = FALSE)
	if(!zlevels)
		if(zlevel)
			zlevels = list(zlevel)
		else
			zlevels = using_map.station_levels

	var/cycles = 1000

	for(var/cycle in 1 to cycles)
		var/x = rand(1, world.maxx)
		var/y = rand(1, world.maxy)
		var/z = pick(zlevels)
		var/random_location = locate(x, y, z)

		if(is_safe_turf(random_location, dense_atoms, cycle < 300))
			return random_location

/proc/is_safe_turf(turf/random_location, dense_atoms = FALSE, no_teleport = FALSE)
	. = FALSE
	if(!isfloorturf(random_location))
		return
	var/turf/floor_turf = random_location
	var/area/destination_area = floor_turf.loc

	if(no_teleport && destination_area.flag_check(AREA_BLOCK_PHASE_SHIFT))
		return

	if(!dense_atoms)
		var/density_found = FALSE
		for(var/atom/movable/found_movable in floor_turf)
			if(found_movable.density)
				density_found = TRUE
				break
		if(density_found)
			return

/proc/get_teleport_turfs(turf/center, precision = 0)
	if(!precision)
		return list(center)
	var/list/posturfs = list()
	for(var/turf/T in RANGE_TURFS(precision, center))
		var/area/A = T.loc
		if(!A.flag_check(AREA_BLOCK_PHASE_SHIFT))
			posturfs.Add(T)
	return posturfs

/proc/get_teleport_turf(turf/center, precision = 0)
	var/list/turfs = get_teleport_turfs(center, precision)
	if(length(turfs))
		return pick(turfs)

/proc/check_teleport_valid(atom/teleported_atom, atom/destination, channel, atom/original_destination = null)
	SHOULD_BE_PURE(TRUE)

	if(isnull(destination))
		return FALSE

	var/area/origin_area = get_area(teleported_atom)

	var/area/destination_area = get_area(destination)

	if(HAS_TRAIT(teleported_atom, TRAIT_NO_TELEPORT))
		return FALSE

	if(origin_area.flag_check(AREA_BLOCK_PHASE_SHIFT) || destination_area.flag_check(AREA_BLOCK_PHASE_SHIFT))
		return FALSE

	return TRUE
