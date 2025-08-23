/datum/event/clang
	announceWhen 	= 1
	startWhen		= 10
	endWhen			= 35

/datum/event/clang/announce()
	command_announcement.Announce("Attention [station_name()]. Unknown ultra-dense high-velocity object entering stratosphere!", "General Alert")
	if(seclevel2num(get_security_level()) < SEC_LEVEL_BLUE)
		set_security_level(SEC_LEVEL_BLUE) // OHNO

/datum/event/clang/end()
	command_announcement.Announce("What the fuck was that?!", "General Alert")

/datum/event/clang/start()
	affecting_z = global.using_map.station_levels

	var/startz = pick(affecting_z)
	var/startx = 0
	var/starty = 0
	var/endy = 0
	var/endx = 0
	var/startside = pick(GLOB.cardinal)
	/* //If you have a wide map, enable the below.
	if(prob(50))
		startside = pick(list(EAST,WEST))
	*/
	/* //If you have a tall map, enable the below.
	if(prob(50))
		startside = pick(list(NORTH,SOUTH))
	*/

	// Random pos along an edge with a percent buffer to prevent corner spawns
	var/wid = world.maxx * 0.05
	var/hig = world.maxy * 0.05
	var/map_l = wid
	var/map_r = world.maxx - wid
	var/map_b = hig
	var/map_t = world.maxy - hig

	var/deviance = 2
	switch(startside)
		if(NORTH)
			starty = world.maxy - 2
			startx = rand(map_l, map_r)
			endy = 1
			endx = startx + rand(-deviance,deviance)
		if(EAST)
			starty = rand(map_b, map_t)
			startx = world.maxx - 2
			endy = starty + rand(-deviance,deviance)
			endx = 1
		if(SOUTH)
			starty = 2
			startx = rand(map_l, map_r)
			endy = world.maxy - 2
			endx = startx + rand(-deviance,deviance)
		if(WEST)
			starty = rand(map_b, map_t)
			startx = 2
			endy = starty + rand(-deviance,deviance)
			endx = world.maxx - 2

	//rod time!
	var/turf/start = locate(startx, starty, startz)
	var/obj/effect/immovablerod/immrod = new /obj/effect/immovablerod(start)
	immrod.TakeFlight(locate(endx, endy, startz))

/obj/effect/immovablerod
	name = "Immovable Rod"
	desc = "What the fuck is that?"
	icon = 'icons/obj/objects.dmi'
	icon_state = "immrod"
	density = TRUE
	anchored = TRUE
	movement_type = UNSTOPPABLE
	var/turf/despawn_loc = null
	var/has_hunted_unlucky = FALSE

/obj/effect/immovablerod/proc/TakeFlight(var/turf/end)
	despawn_loc = end
	walk_towards(src, despawn_loc, 1)
	explosion(loc, 2, 3, 5) // start out with a bang

	// Get steps needed and then await that to despawn
	var/despawn_time = sqrt(((end.x - loc.x)**2) + ((end.y - loc.y)**2)) // distance of a line...
	QDEL_IN(src, despawn_time + 5 SECONDS) //Give a small extra time before we disappear entirely.

/obj/effect/immovablerod/Bump(atom/clong)

	if(!istype(clong, /turf/simulated/shuttle)) //Skip shuttles without actually deleting the rod
		if (istype(clong, /turf) && !istype(clong, /turf/unsimulated))
			if(clong.density)
				clong.ex_act(2)
				for (var/mob/O in hearers(src, null))
					O.show_message("CLANG", 2)
				if(prob(25))
					explosion(clong, 1, 2, 4) // really spice it up

		else if (istype(clong, /obj))
			if(clong.density)
				clong.ex_act(2)
				for (var/mob/O in hearers(src, null))
					O.show_message("CLANG", 2)

		else if (istype(clong, /mob))
			if(clong.density || prob(10))
				clong.ex_act(2)

		else
			qdel(src)

	if(despawn_loc != null && (src.x == despawn_loc.x && src.y == despawn_loc.y))
		qdel(src)
		return

	if(prob(10) && !has_hunted_unlucky)
		hunt_unlucky()

/obj/effect/immovablerod/proc/hunt_unlucky()
	for(var/mob/living/unlucky_bugger in orange(7,src))
		if(HAS_TRAIT(unlucky_bugger, TRAIT_UNLUCKY))
			has_hunted_unlucky = TRUE
			walk(src, 0)
			//stone_grinding.ogg
			addtimer(CALLBACK(src, PROC_REF(fetch_boy), unlucky_bugger), 1 SECOND, TIMER_DELETE_ME)
			break

/obj/effect/immovablerod/proc/fetch_boy(unlucky_bugger)
	walk_towards(src, unlucky_bugger, 1)
	addtimer(CALLBACK(src, PROC_REF(resume_path)), 2 SECONDS, TIMER_DELETE_ME)

/obj/effect/immovablerod/proc/resume_path()
	walk(src, 0)
	walk_towards(src, despawn_loc, 1)

/obj/effect/immovablerod/Destroy()
	walk(src, 0) // Because we might have called walk_towards, we must stop the walk loop or BYOND keeps an internal reference to us forever.
	return ..()
