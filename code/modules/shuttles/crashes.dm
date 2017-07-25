//
// Crashable shuttle. Boom etc.
//

/datum/shuttle
	var/list/crash_areas = null
	var/crash_message = "Oops. The shuttle blew up."	// Announcement made when shuttle crashes

/datum/shuttle/New()
	if(crash_areas)
		for(var/i in 1 to crash_areas.len)
			crash_areas[i] = locate(crash_areas[i])
	..()

// Return 0 to let the jump continue, 1 to abort the jump.
// Default implementation checks if the shuttle should crash and if so crashes it.
/datum/shuttle/proc/process_longjump(var/area/origin, var/area/intended_destination, var/direction)
	if(should_crash())
		do_crash(origin)
		return 1

// Decide if this is the time we crash.  Return true for yes
/datum/shuttle/proc/should_crash(var/area/origin, var/area/intended_destination, var/direction)
	return FALSE

// Actually crash the shuttle
/datum/shuttle/proc/do_crash(var/area/source)
	// Choose the target
	var/area/target = pick(crash_areas)
	ASSERT(istype(target))

	// Blow up the target area?
	//command_announcement.Announce(departure_message,(announcer ? announcer : "[using_map.boss_name]"))

	//What people are we dealing with here
	var/list/victims = list()
	for(var/mob/living/L in source)
		victims += L
		spawn(0)
			shake_camera(L,2 SECONDS,4)

	//SHAKA SHAKA SHAKA
	sleep(2 SECONDS)

	// Move the shuttle
	move(source, target)

	// Hide people
	for(var/living in victims)
		var/mob/living/L = living
		victims[L] = get_turf(L)
		L.Sleeping(rand(10,20))
		L.Life()
		L.loc = null

	// Blow up the shuttle
	var/list/area_turfs = get_area_turfs(target)
	var/turf/epicenter = pick(area_turfs)
	var/boomsize = area_turfs.len / 10 // Bigger shuttle = bigger boom
	explosion(epicenter, 0, boomsize, boomsize*2, boomsize*3)
	moving_status = SHUTTLE_CRASHED
	command_announcement.Announce("[crash_message]", "Shuttle Alert")

	// Put people back
	for(var/living in victims)
		var/mob/living/L = living
		L.loc = victims[L]
		L.adjustBruteLoss(5)
		L.adjustBruteLoss(10)
		L.adjustBruteLoss(15)
