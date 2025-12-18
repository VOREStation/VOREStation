/obj/effect/anomaly/bluespace
	name = "bluespace anomaly"
	icon_state = "bluespace"
	density = TRUE
	anomaly_core = /obj/item/assembly/signaler/anomaly/bluespace
	///range from which we can teleport someone
	var/teleport_range = 1
	///Distance we can teleport someone passively
	var/teleport_distance = 4

/obj/effect/anomaly/bluespace/Initialize(mapload, new_lifespan)
	. = ..()
	apply_wibbly_filters(src)

/obj/effect/anomaly/bluespace/anomalyEffect()
	..()
	for(var/mob/living/M in range(teleport_range, src))
		var/susceptibility = GetAnomalySusceptibility(M)
		if(prob(100 * susceptibility))
			do_teleport(M, locate(M.x, M.y, M.z), teleport_distance, channel = TELEPORT_CHANNEL_BLUESPACE)

/obj/effect/anomaly/bluespace/Bumped(atom/movable/AM)
	if(isliving(AM) && prob(100 * GetAnomalySusceptibility(AM)))
		do_teleport(AM, locate(AM.x, AM.y, AM.z), 8, channel = TELEPORT_CHANNEL_BLUESPACE)

/obj/effect/anomaly/bluespace/detonate()
	playsound(src, 'sound/effects/cosmic_energy.ogg', vol = 50)

	var/turf/impact_turf = pick(get_area_turfs(impact_area))
	if(!impact_area)
		return

	var/obj/item/radio/beacon/chosen
	var/list/possible = list()
	for(var/obj/item/radio/beacon in GLOB.all_beacons)
		var/turf/turf = get_turf(beacon)
		if(!turf)
			continue
		if(!check_teleport_valid(src, turf))
			continue
		possible += beacon

	if(possible.len > 0)
		chosen = pick(possible)

	if(!chosen)
		return

	var/turf/beacon_turf = get_turf(chosen)

	playsound(beacon_turf, 'sound/effects/phasein.ogg', 100, TRUE)

	var/datum/announcement/priority/announcement = new/datum/announcement/priority()
	announcement.Announce("Massive bluespace translocation detected", "Anomaly Alert")

	var/list/flashers = list()
	for(var/mob/living/living in viewers(beacon_turf, null))
		if(living.flash_eyes())
			flashers += living

	var/y_distance = beacon_turf.y - impact_turf.y
	var/x_distance = beacon_turf.x - impact_turf.x
	var/list/available_turfs = RANGE_TURFS(12, beacon_turf)
	for(var/atom/movable/movable in urange(12, impact_turf))
		if(istype(movable, /obj/item/radio/beacon) || iseffect(movable) || isEye(movable))
			continue
		if(movable.anchored)
			continue

		var/turf/newloc = locate(movable.x + x_distance, movable.y + y_distance, beacon_turf.z) || pick(available_turfs)
		do_teleport(movable, newloc, no_effects = TRUE)

		if(isliving(movable) && !(movable in flashers))
			var/mob/living/give_sparkles = movable
			give_sparkles.flash_eyes()

/obj/effect/anomaly/bluespace/stabilize(anchor, has_core)
	. = ..()
	teleport_range = 0

/obj/effect/anomaly/bluespace/big
	immortal = TRUE
	teleport_range = 2
	teleport_distance = 12
	anomaly_core = null

/obj/effect/anomaly/bluespace/big/Initialize(mapload, new_lifespan)
	. = ..()
	transform *= 3

/obj/effect/temp_visual/circle_wave/bluespace
	color = COLOR_BLUE_LIGHT
	duration = 1 SECONDS
	amount_to_scale = 5
