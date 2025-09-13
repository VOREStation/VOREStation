// virtual disposal object
// travels through pipes in lieu of actual items
// contents will be items flushed by the disposal
// this allows the gas flushed to be tracked

/obj/structure/disposalholder
	invisibility = INVISIBILITY_ABSTRACT
	var/datum/gas_mixture/gas = null	// gas used to flush, will appear at exit point
	var/active = FALSE	// true if the holder is moving, otherwise inactive
	var/count = 2048	//*** can travel 2048 steps before going inactive (in case of loops)
	var/destinationTag = "" // changes if contains a delivery container
	var/hasmob = FALSE //If it contains a mob
	var/partialTag = "" //set by a partial tagger the first time round, then put in destinationTag if it goes through again.
	dir = 0

	// initialize a holder from the contents of a disposal unit
/obj/structure/disposalholder/proc/init(list/flush_list, datum/gas_mixture/flush_gas)
	gas = flush_gas// transfer gas resv. into holder object -- let's be explicit about the data this proc consumes, please.

	//Check for any living mobs trigger hasmob.
	//hasmob effects whether the package goes to cargo or its tagged destination.
	for(var/mob/living/M in flush_list)
		if(M.stat != DEAD && !istype(M,/mob/living/silicon/robot/drone))
			hasmob = TRUE
		if(M.client)
			M.client.perspective = EYE_PERSPECTIVE
			M.client.eye = src

	//Checks 1 contents level deep. This means that players can be sent through disposals...
	//...but it should require a second person to open the package. (i.e. person inside a wrapped locker)
	for(var/obj/O in flush_list)
		if(!O.contents)
			continue
		for(var/mob/living/M in O.contents)
			if(M && M.stat != DEAD && !istype(M,/mob/living/silicon/robot/drone))
				hasmob = TRUE

	// now everything inside the disposal gets put into the holder
	// note AM since can contain mobs or objs
	for(var/atom/movable/AM in flush_list)
		AM.forceMove(src)
		// Mail will use it's sorting tag if dropped into disposals
		if(istype(AM, /obj/structure/bigDelivery) && !hasmob)
			var/obj/structure/bigDelivery/T = AM
			src.destinationTag = T.sortTag
		if(istype(AM, /obj/item/smallDelivery) && !hasmob)
			var/obj/item/smallDelivery/T = AM
			src.destinationTag = T.sortTag
		if(istype(AM, /obj/item/mail) && !hasmob)
			var/obj/item/mail/T = AM
			src.destinationTag = T.sortTag
		// Drones can mail themselves through maint.
		if(istype(AM, /mob/living/silicon/robot/drone))
			var/mob/living/silicon/robot/drone/drone = AM
			src.destinationTag = drone.mail_destination

// movement process, persists while holder is moving through pipes
/obj/structure/disposalholder/proc/move()
	if(!active)
		return

	// Clonk n' bonk
	if(hasmob && prob(3))
		for(var/mob/living/H in src)
			if(!istype(H,/mob/living/silicon/robot/drone)) //Drones use the mailing code to move through the disposal system,
				H.take_overall_damage(20, 0, "Blunt Trauma")//horribly maim any living creature jumping down disposals.  c'est la vie

	// Transfer to next segment
	var/obj/structure/disposalpipe/last = loc
	var/obj/structure/disposalpipe/curr = last.transfer(src)
	if(!active)
		return // Handled by a machine connected to a trunk during transfer()
	if(!curr)
		last.expel(src, get_turf(loc), dir)
		return

	// Onto the next segment
	if(!(count--))
		active = FALSE
		return
	addtimer(CALLBACK(src, PROC_REF(move)), 1, TIMER_DELETE_ME)


// find the turf which should contain the next pipe
/obj/structure/disposalholder/proc/nextloc()
	return get_step(loc,dir)

// find a matching pipe on a turf
/obj/structure/disposalholder/proc/findpipe(turf/T)
	if(!T)
		return null
	var/fdir = turn(dir, 180)	// flip the movement direction
	for(var/obj/structure/disposalpipe/P in T)
		if(fdir & P.dpdir)		// find pipe direction mask that matches flipped dir
			return P
	// if no matching pipe, return null
	return null

// merge two holder objects
// used when a a holder meets a stuck holder
/obj/structure/disposalholder/proc/merge(obj/structure/disposalholder/other)
	for(var/atom/movable/AM in other)
		AM.forceMove(src)		// move everything in other holder to this one
		if(ismob(AM))
			var/mob/M = AM
			if(M.client)	// if a client mob, update eye to follow this holder
				M.client.eye = src
	qdel(other)

/obj/structure/disposalholder/proc/settag(new_tag)
	destinationTag = new_tag

/obj/structure/disposalholder/proc/setpartialtag(new_tag)
	if(partialTag == new_tag)
		destinationTag = new_tag
		partialTag = ""
	else
		partialTag = new_tag


// called when player tries to move while in a pipe
/obj/structure/disposalholder/relaymove(mob/living/user)
	if(!isliving(user))
		return

	if(user.stat || user.last_special <= world.time)
		return
	user.last_special = world.time+100

	if(QDELETED(src))
		return

	for(var/mob/M in hearers(get_turf(src)))
		to_chat(M, "<FONT size=[max(0, 5 - get_dist(src, M))]>CLONG, clong!</FONT>")
	playsound(src, 'sound/effects/clang.ogg', 50, 0, 0)

	// called to vent all gas in holder to a location
/obj/structure/disposalholder/proc/vent_gas(atom/location)
	location.assume_air(gas)  // vent all gas to turf
	return

/obj/structure/disposalholder/Destroy()
	QDEL_NULL(gas)
	if(contents.len)
		var/turf/qdelloc = get_turf(src)
		if(qdelloc)
			for(var/atom/movable/AM in contents)
				AM.forceMove(qdelloc)
		else
			log_and_message_admins("A disposal holder was deleted with contents in nullspace") //ideally, this should never happen

	active = FALSE
	return ..()
