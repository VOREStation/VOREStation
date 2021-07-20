//
// Crashable shuttle. Boom etc.
//

/datum/shuttle
	var/list/crash_locations = null
	var/crash_message = "Oops. The shuttle blew up."	// Announcement made when shuttle crashes

/datum/shuttle/New()
	if(crash_locations)
		var/crash_location_ids = crash_locations
		crash_locations = list()
		for(var/location_tag in crash_location_ids)
			var/obj/effect/shuttle_landmark/L = SSshuttles.get_landmark(location_tag)
			if(L)
				crash_locations += L
	..()

// Return 0 to let the jump continue, 1 to abort the jump.
// Default implementation checks if the shuttle should crash and if so crashes it.
/datum/shuttle/proc/process_longjump(var/obj/effect/shuttle_landmark/intended_destination)
	if(should_crash(intended_destination))
		do_crash(intended_destination)
		return 1

// Decide if this is the time we crash.  Return true for yes
/datum/shuttle/proc/should_crash(var/obj/effect/shuttle_landmark/intended_destination)
	return FALSE

// Actually crash the shuttle
/datum/shuttle/proc/do_crash(var/obj/effect/shuttle_landmark/intended_destination)
	// Choose the target
	var/obj/effect/shuttle_landmark/target = pick(crash_locations)
	ASSERT(istype(target))

	// Blow up the target area?
	//command_announcement.Announce(departure_message,(announcer ? announcer : "[using_map.boss_name]"))

	//What people are we dealing with here
	var/list/victims = list()
	for(var/area/A in shuttle_area)
		for(var/mob/living/L in A)
			victims += L
			spawn(0)
				shake_camera(L,2 SECONDS,4)

	//SHAKA SHAKA SHAKA
	sleep(2 SECONDS)

	// Move the shuttle
	if (!attempt_move(target))
		return // Lucky!

	// Hide people
	for(var/mob/living/L as anything in victims)
		victims[L] = get_turf(L)
		L.Sleeping(rand(10,20))
		L.Life()
		L.loc = null

	// Blow up the shuttle
	var/list/shuttle_turfs = list()
	for(var/area/A in shuttle_area)
		shuttle_turfs += get_area_turfs(A)
	var/turf/epicenter = pick(shuttle_turfs)
	var/boomsize = shuttle_turfs.len / 10 // Bigger shuttle = bigger boom
	explosion(epicenter, 0, boomsize, boomsize*2, boomsize*3)
	moving_status = SHUTTLE_CRASHED
	command_announcement.Announce("[crash_message]", "Shuttle Alert")

	// Put people back
	for(var/mob/living/L as anything in victims)
		L.loc = victims[L]
		L.adjustBruteLoss(5)
		L.adjustBruteLoss(10)
		L.adjustBruteLoss(15)
