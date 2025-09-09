// Disposal pipes
/obj/structure/disposalpipe
	icon = 'icons/obj/pipes/disposal.dmi'
	name = "disposal pipe"
	desc = "An underfloor disposal pipe."
	anchored = TRUE
	density = FALSE
	unacidable = TRUE

	level = 1			// underfloor only
	var/dpdir = 0		// bitmask of pipe directions
	dir = 0				// dir will contain dominant direction for junction pipes
	var/health = 10 	// health points 0-10
	plane = PLATING_PLANE
	layer = DISPOSAL_LAYER	// slightly lower than wires and other pipes
	var/base_icon_state	// initial icon state on map
	var/sortType = ""
	var/subtype = 0

// new pipe, set the icon_state as on map
/obj/structure/disposalpipe/Initialize(mapload)
	. = ..()
	base_icon_state = icon_state

// pipe is deleted
// ensure if holder is present, it is expelled
/obj/structure/disposalpipe/Destroy()
	var/obj/structure/disposalholder/H = locate() in src
	if(H)
		// holder was present
		H.active = FALSE
		var/turf/T = get_turf(src)
		if(T.density)
			// deleting pipe is inside a dense turf (wall)
			// this is unlikely, but just dump out everything into the turf in case

			for(var/atom/movable/AM in H)
				AM.forceMove(T)
				AM.pipe_eject(0)
			qdel(H)
			..()
			return

		// otherwise, do normal expel from turf
		if(H)
			expel(H, T, 0)
	. = ..()

// returns the direction of the next pipe object, given the entrance dir
// by default, returns the bitmask of remaining directions
/obj/structure/disposalpipe/proc/nextdir(var/fromdir)
	return dpdir & (~turn(fromdir, 180))

// transfer the holder through this pipe segment
// overriden for special behaviour
//
/obj/structure/disposalpipe/proc/transfer(var/obj/structure/disposalholder/H)
	var/nextdir = nextdir(H.dir)
	H.set_dir(nextdir)
	var/turf/T = H.nextloc()
	var/obj/structure/disposalpipe/P = H.findpipe(T)

	if(P)
		// find other holder in next loc, if inactive merge it with current
		var/obj/structure/disposalholder/H2 = locate() in P
		if(H2 && !H2.active)
			H.merge(H2)

		H.forceMove(P)
	else			// if wasn't a pipe, then set loc to turf
		H.forceMove(T)
		return null

	return P


// update the icon_state to reflect hidden status
/obj/structure/disposalpipe/proc/update()
	var/turf/T = src.loc
	hide(!T.is_plating() && !istype(T,/turf/space))	// space never hides pipes

// hide called by levelupdate if turf intact status changes
// change visibility status and force update of icon
/obj/structure/disposalpipe/hide(var/intact)
	invisibility = intact ? INVISIBILITY_ABSTRACT : INVISIBILITY_NONE	// hide if floor is intact
	update_icon()

// update actual icon_state depending on visibility
// if invisible, append "f" to icon_state to show faded version
// this will be revealed if a T-scanner is used
// if visible, use regular icon_state
/obj/structure/disposalpipe/update_icon()
/*	if(invisibility)	//we hide things with alpha now, no need for transparent icons
		icon_state = "[base_icon_state]f"
	else
		icon_state = base_icon_state*/
	icon_state = base_icon_state
	return


// expel the held objects into a turf
// called when there is a break in the pipe
/obj/structure/disposalpipe/proc/expel(var/obj/structure/disposalholder/H, var/turf/T, var/direction)
	if(!istype(H))
		return

	// Empty the holder if it is expelled into a dense turf.
	// Leaving it intact and sitting in a wall is stupid.
	if(T.density)
		for(var/atom/movable/AM in H)
			AM.loc = T
			AM.pipe_eject(0)
		qdel(H)
		return

	if(!T.is_plating() && istype(T,/turf/simulated/floor)) //intact floor, pop the tile
		var/turf/simulated/floor/F = T
		F.break_tile()
		new /obj/item/stack/tile(H)	// add to holder so it will be thrown with other stuff

	var/turf/target
	if(direction)		// direction is specified
		if(istype(T, /turf/space)) // if ended in space, then range is unlimited
			target = get_edge_target_turf(T, direction)
		else						// otherwise limit to 10 tiles
			target = get_ranged_target_turf(T, direction, 10)

		playsound(src, 'sound/machines/hiss.ogg', 50, 0, 0)
		if(H)
			for(var/atom/movable/AM in H)
				AM.forceMove(T)
				AM.pipe_eject(direction)
				spawn(1)
					if(AM)
						AM.throw_at(target, 100, 1)
			H.vent_gas(T)
			qdel(H)

	else	// no specified direction, so throw in random direction

		playsound(src, 'sound/machines/hiss.ogg', 50, 0, 0)
		if(H)
			for(var/atom/movable/AM in H)
				target = get_offset_target_turf(T, rand(5)-rand(5), rand(5)-rand(5))

				AM.forceMove(T)
				AM.pipe_eject(0)
				spawn(1)
					if(AM)
						AM.throw_at(target, 5, 1)

			H.vent_gas(T)	// all gas vent to turf
			qdel(H)

	return

// call to break the pipe
// will expel any holder inside at the time
// then delete the pipe
// remains : set to leave broken pipe pieces in place
/obj/structure/disposalpipe/proc/broken(var/remains = 0)
	if(remains)
		for(var/D in GLOB.cardinal)
			if(D & dpdir)
				var/obj/structure/disposalpipe/broken/P = new(src.loc)
				P.set_dir(D)

	src.invisibility = INVISIBILITY_ABSTRACT	// make invisible (since we won't delete the pipe immediately)
	var/obj/structure/disposalholder/H = locate() in src
	if(H)
		// holder was present
		H.active = FALSE
		var/turf/T = get_turf(src)
		if(T.density)
			// broken pipe is inside a dense turf (wall)
			// this is unlikely, but just dump out everything into the turf in case

			for(var/atom/movable/AM in H)
				AM.forceMove(T)
				AM.pipe_eject(0)
			qdel(H)
			return

		// otherwise, do normal expel from turf
		if(H)
			expel(H, T, 0)

	spawn(2)	// delete pipe after 2 ticks to ensure expel proc finished
		qdel(src)


// pipe affected by explosion
/obj/structure/disposalpipe/ex_act(severity)

	switch(severity)
		if(1.0)
			broken(0)
			return
		if(2.0)
			health -= rand(5,15)
			healthcheck()
			return
		if(3.0)
			health -= rand(0,15)
			healthcheck()
			return


	// test health for brokenness
/obj/structure/disposalpipe/proc/healthcheck()
	if(health < -2)
		broken(0)
	else if(health<1)
		broken(1)
	return

	//attack by item
	//weldingtool: unfasten and convert to obj/disposalconstruct

/obj/structure/disposalpipe/attackby(var/obj/item/I, var/mob/user)

	var/turf/T = src.loc
	if(!T.is_plating())
		return		// prevent interaction with T-scanner revealed pipes
	src.add_fingerprint(user)
	if(I.has_tool_quality(TOOL_WELDER))
		var/obj/item/weldingtool/W = I.get_welder()
		if(W.remove_fuel(0,user))
			playsound(src, W.usesound, 100, 1)
			to_chat(user, "You start slicing [src]....")
			if(do_after(user, 2 SECONDS * W.toolspeed, target = src))
				if(!src || !W.isOn()) return
				to_chat(user, "You slice [src]")
				welded()
			else
				to_chat(user, "You must stay still while welding the pipe.")
		else
			to_chat(user, "You need more welding fuel to cut the pipe.")
			return

	// called when pipe is cut with welder
/obj/structure/disposalpipe/proc/welded()

	var/obj/structure/disposalconstruct/C = new (src.loc)
	switch(base_icon_state)
		if("pipe-s")
			C.ptype = 0
		if("pipe-c")
			C.ptype = 1
		if("pipe-j1")
			C.ptype = 2
		if("pipe-j2")
			C.ptype = 3
		if("pipe-y")
			C.ptype = 4
		if("pipe-t")
			C.ptype = 5
		if("pipe-j1s")
			C.ptype = 9
			C.sortType = sortType
		if("pipe-j2s")
			C.ptype = 10
			C.sortType = sortType
///// Z-Level stuff
		if("pipe-u")
			C.ptype = 11
		if("pipe-d")
			C.ptype = 12
///// Z-Level stuff
		if("pipe-tagger")
			C.ptype = 13
		if("pipe-tagger-partial")
			C.ptype = 14
	C.subtype = src.subtype
	src.transfer_fingerprints_to(C)
	C.set_dir(dir)
	C.density = FALSE
	C.anchored = TRUE
	C.update()

	qdel(src)

// pipe is deleted
// ensure if holder is present, it is expelled
/obj/structure/disposalpipe/Destroy()
	var/obj/structure/disposalholder/H = locate() in src
	if(H)
		// holder was present
		H.active = FALSE
		var/turf/T = get_turf(src)
		if(T.density)
			// deleting pipe is inside a dense turf (wall)
			// this is unlikely, but just dump out everything into the turf in case

			for(var/atom/movable/AM in H)
				AM.forceMove(T)
				AM.pipe_eject(0)
			qdel(H)
			..()
			return

		// otherwise, do normal expel from turf
		if(H)
			expel(H, T, 0)
	. = ..()

/obj/structure/disposalpipe/hides_under_flooring()
	return 1

// *** TEST verb
//client/verb/dispstop()
//	for(var/obj/structure/disposalholder/H in world)
//		H.active = 0

// a straight or bent segment
/obj/structure/disposalpipe/segment
	icon_state = "pipe-s"

/obj/structure/disposalpipe/segment/Initialize(mapload)
	. = ..()
	if(icon_state == "pipe-s")
		dpdir = dir | turn(dir, 180)
	else
		dpdir = dir | turn(dir, -90)

	update()

///// Z-Level stuff
/obj/structure/disposalpipe/up
	icon_state = "pipe-u"

/obj/structure/disposalpipe/up/Initialize(mapload)
	. = ..()
	dpdir = dir
	update()

/obj/structure/disposalpipe/up/nextdir(var/fromdir)
	var/nextdir
	if(fromdir == 11)
		nextdir = dir
	else
		nextdir = 12
	return nextdir

/obj/structure/disposalpipe/up/transfer(var/obj/structure/disposalholder/H)
	var/nextdir = nextdir(H.dir)
	H.set_dir(nextdir)

	var/turf/T
	var/obj/structure/disposalpipe/P

	if(nextdir == 12)
		T = GetAbove(src)
		if(!T)
			H.forceMove(loc)
			return
		else
			for(var/obj/structure/disposalpipe/down/F in T)
				P = F

	else
		T = get_step(src.loc, H.dir)
		P = H.findpipe(T)

	if(P)
		// find other holder in next loc, if inactive merge it with current
		var/obj/structure/disposalholder/H2 = locate() in P
		if(H2 && !H2.active)
			H.merge(H2)

		H.forceMove(P)
	else			// if wasn't a pipe, then set loc to turf
		H.forceMove(T)
		return null

	return P

/obj/structure/disposalpipe/down
	icon_state = "pipe-d"

/obj/structure/disposalpipe/down/Initialize(mapload)
	. = ..()
	dpdir = dir
	update()

/obj/structure/disposalpipe/down/nextdir(var/fromdir)
	var/nextdir
	if(fromdir == 12)
		nextdir = dir
	else
		nextdir = 11
	return nextdir

/obj/structure/disposalpipe/down/transfer(var/obj/structure/disposalholder/H)
	var/nextdir = nextdir(H.dir)
	H.dir = nextdir

	var/turf/T
	var/obj/structure/disposalpipe/P

	if(nextdir == 11)
		T = GetBelow(src)
		if(!T)
			H.forceMove(src.loc)
			return
		else
			for(var/obj/structure/disposalpipe/up/F in T)
				P = F

	else
		T = get_step(src.loc, H.dir)
		P = H.findpipe(T)

	if(P)
		// find other holder in next loc, if inactive merge it with current
		var/obj/structure/disposalholder/H2 = locate() in P
		if(H2 && !H2.active)
			H.merge(H2)

		H.forceMove(P)
	else			// if wasn't a pipe, then set loc to turf
		H.forceMove(T)
		return null

	return P
///// Z-Level stuff

/obj/structure/disposalpipe/junction/yjunction
	icon_state = "pipe-y"

//a three-way junction with dir being the dominant direction
/obj/structure/disposalpipe/junction
	icon_state = "pipe-j1"

/obj/structure/disposalpipe/junction/Initialize(mapload)
	. = ..()
	if(icon_state == "pipe-j1")
		dpdir = dir | turn(dir, -90) | turn(dir,180)
	else if(icon_state == "pipe-j2")
		dpdir = dir | turn(dir, 90) | turn(dir,180)
	else // pipe-y
		dpdir = dir | turn(dir,90) | turn(dir, -90)
	update()
	return


// next direction to move
// if coming in from secondary dirs, then next is primary dir
// if coming in from primary dir, then next is equal chance of other dirs

/obj/structure/disposalpipe/junction/nextdir(var/fromdir)
	var/flipdir = turn(fromdir, 180)
	if(flipdir != dir)	// came from secondary dir
		return dir		// so exit through primary
	else				// came from primary
						// so need to choose either secondary exit
		var/mask = ..(fromdir)

		// find a bit which is set
		var/setbit = 0
		if(mask & NORTH)
			setbit = NORTH
		else if(mask & SOUTH)
			setbit = SOUTH
		else if(mask & EAST)
			setbit = EAST
		else
			setbit = WEST

		if(prob(50))	// 50% chance to choose the found bit or the other one
			return setbit
		else
			return mask & (~setbit)


/obj/structure/disposalpipe/tagger
	name = "package tagger"
	icon_state = "pipe-tagger"
	var/sort_tag = ""
	var/partial = 0

/obj/structure/disposalpipe/tagger/proc/updatedesc()
	desc = initial(desc)
	if(sort_tag)
		desc += "\nIt's tagging objects with the '[sort_tag]' tag."

/obj/structure/disposalpipe/tagger/proc/updatename()
	if(sort_tag)
		name = "[initial(name)] ([sort_tag])"
	else
		name = initial(name)

/obj/structure/disposalpipe/tagger/Initialize(mapload)
	. = ..()
	dpdir = dir | turn(dir, 180)
	if(sort_tag) GLOB.tagger_locations |= list("[sort_tag]" = get_z(src))
	updatename()
	updatedesc()
	update()

/obj/structure/disposalpipe/tagger/attackby(var/obj/item/I, var/mob/user)
	if(..())
		return

	if(istype(I, /obj/item/destTagger))
		var/obj/item/destTagger/O = I

		if(O.currTag)// Tag set
			sort_tag = O.currTag
			playsound(src, 'sound/machines/twobeep.ogg', 100, 1)
			to_chat(user, span_blue("Changed tag to '[sort_tag]'."))
			updatename()
			updatedesc()

/obj/structure/disposalpipe/tagger/transfer(var/obj/structure/disposalholder/H)
	if(sort_tag)
		if(partial)
			H.setpartialtag(sort_tag)
		else
			H.settag(sort_tag)
	return ..()

/obj/structure/disposalpipe/tagger/partial //needs two passes to tag
	name = "partial package tagger"
	icon_state = "pipe-tagger-partial"
	partial = 1

//a three-way junction that sorts objects
/obj/structure/disposalpipe/sortjunction
	name = "sorting junction"
	icon_state = "pipe-j1s"
	desc = "An underfloor disposal pipe with a package sorting mechanism."

	var/sortdir = 0

	var/last_sort = FALSE
	var/sort_scan = TRUE
	var/panel_open = FALSE
	var/datum/wires/wires = null // ...Why isnt this defined on /atom...

/obj/structure/disposalpipe/sortjunction/proc/updatedesc()
	desc = initial(desc)
	if(sortType)
		desc += "\nIt's filtering objects with the '[sortType]' tag."

/obj/structure/disposalpipe/sortjunction/proc/updatename()
	if(sortType)
		name = "[initial(name)] ([sortType])"
	else
		name = initial(name)

/obj/structure/disposalpipe/sortjunction/Destroy()
	QDEL_NULL(wires)
	. = ..()

/obj/structure/disposalpipe/sortjunction/proc/updatedir()
	var/negdir = turn(dir, 180)

	if(icon_state == "pipe-j1s")
		sortdir = turn(dir, -90)
	else if(icon_state == "pipe-j2s")
		sortdir = turn(dir, 90)

	dpdir = sortdir | dir | negdir

/obj/structure/disposalpipe/sortjunction/Initialize(mapload)
	. = ..()
	if(sortType) GLOB.tagger_locations |= list("[sortType]" = get_z(src))

	wires = new /datum/wires/disposals(src)

	updatedir()
	updatename()
	updatedesc()
	update()

/obj/structure/disposalpipe/sortjunction/attackby(var/obj/item/I, var/mob/user)
	if(..())
		return

	if(I.has_tool_quality(TOOL_SCREWDRIVER)) //Who is screwdriver_act()?
		panel_open = !panel_open
		playsound(src, I.usesound, 100, 1)
		to_chat(user, span_notice("You [panel_open ? "open" : "close"] the wire panel."))
		update_icon()
		return

	if(panel_open && is_wire_tool(I))
		wires.Interact(user)
		return TRUE

	if(istype(I, /obj/item/destTagger))
		var/obj/item/destTagger/O = I

		if(O.currTag)// Tag set
			sortType = O.currTag
			playsound(src, 'sound/machines/twobeep.ogg', 100, 1)
			to_chat(user, span_blue("Changed filter to '[sortType]'."))
			updatename()
			updatedesc()

/obj/structure/disposalpipe/sortjunction/proc/divert_check(var/checkTag)
	return sortType == checkTag

// next direction to move
// if coming in from negdir then next is primary dir or sortdir
// if coming in from dir, Then next is negdir or sortdir
// if coming in from sortdir, always go to posdir

/obj/structure/disposalpipe/sortjunction/nextdir(var/fromdir, var/sortTag)
	if(sort_scan)
		if(divert_check(sortTag))
			if(!wires.is_cut(WIRE_SORT_SIDE))
				last_sort = TRUE
		else
			if(!wires.is_cut(WIRE_SORT_FORWARD))
				last_sort = FALSE
	if(fromdir != sortdir && last_sort)
		return sortdir
		// so go with the flow to positive direction
	return dir

/obj/structure/disposalpipe/sortjunction/proc/reset_scan()
	if(!wires.is_cut(WIRE_SORT_SCAN))
		sort_scan = TRUE

/obj/structure/disposalpipe/sortjunction/transfer(var/obj/structure/disposalholder/H)
	var/nextdir = nextdir(H.dir, H.destinationTag)
	H.set_dir(nextdir)
	var/turf/T = H.nextloc()
	var/obj/structure/disposalpipe/P = H.findpipe(T)

	if(P)
		// find other holder in next loc, if inactive merge it with current
		var/obj/structure/disposalholder/H2 = locate() in P
		if(H2 && !H2.active)
			H.merge(H2)

		H.forceMove(P)
	else			// if wasn't a pipe, then set loc to turf
		H.forceMove(T)
		return null

	return P

/obj/structure/disposalpipe/sortjunction/update_icon()
	cut_overlays()
	. = ..()
	if(panel_open)
		add_overlay("[icon_state]-open")

//a three-way junction that filters all wrapped and tagged items
/obj/structure/disposalpipe/sortjunction/wildcard
	name = "wildcard sorting junction"
	desc = "An underfloor disposal pipe which filters all wrapped and tagged items."
	subtype = 1

/obj/structure/disposalpipe/sortjunction/wildcard/divert_check(var/checkTag)
	return checkTag != ""

//junction that filters all untagged items
/obj/structure/disposalpipe/sortjunction/untagged
	name = "untagged sorting junction"
	desc = "An underfloor disposal pipe which filters all untagged items."
	subtype = 2

/obj/structure/disposalpipe/sortjunction/untagged/divert_check(var/checkTag)
	return checkTag == ""

/obj/structure/disposalpipe/sortjunction/flipped //for easier and cleaner mapping
	icon_state = "pipe-j2s"

/obj/structure/disposalpipe/sortjunction/wildcard/flipped
	icon_state = "pipe-j2s"

/obj/structure/disposalpipe/sortjunction/untagged/flipped
	icon_state = "pipe-j2s"

//a trunk joining to a disposal bin or outlet on the same turf
/obj/structure/disposalpipe/trunk
	icon_state = "pipe-t"

/obj/structure/disposalpipe/trunk/Initialize(mapload)
	..()
	dpdir = dir
	return INITIALIZE_HINT_LATELOAD

/obj/structure/disposalpipe/trunk/LateInitialize()
	update()

// Override attackby so we disallow trunkremoval when somethings ontop
/obj/structure/disposalpipe/trunk/attackby(var/obj/item/I, var/mob/user)
	//Disposal constructors
	var/obj/structure/disposalconstruct/C = locate() in src.loc
	if(C && C.anchored)
		return

	var/turf/T = src.loc
	if(!T.is_plating())
		return		// prevent interaction with T-scanner revealed pipes
	src.add_fingerprint(user)
	if(I.has_tool_quality(TOOL_WELDER))
		var/obj/item/weldingtool/W = I.get_welder()

		if(W.remove_fuel(0,user))
			playsound(src, W.usesound, 100, 1)
			// check if anything changed over 2 seconds
			var/turf/uloc = user.loc
			var/atom/wloc = W.loc
			to_chat(user, "Slicing the disposal pipe.")
			sleep(30)
			if(!W.isOn()) return
			if(user.loc == uloc && wloc == W.loc)
				welded()
			else
				to_chat(user, "You must stay still while welding the pipe.")
		else
			to_chat(user, "You need more welding fuel to cut the pipe.")
			return

	// would transfer to next pipe segment, but we are in a trunk
	// if not entering from disposal bin,
	// transfer to linked object (outlet or bin)

/obj/structure/disposalpipe/trunk/transfer(var/obj/structure/disposalholder/H)
	if(H.dir == DOWN)		// we just entered from a disposer
		return ..()		// so do base transfer proc

	// Find a disposal handler component
	var/transfered = FALSE
	var/turf/T = get_turf(src)
	for(var/obj/O in T)
		if(SEND_SIGNAL(O,COMSIG_DISPOSAL_RECEIVING,H))
			transfered = TRUE
			break
	if(!transfered) // Check if anything handled it, will be deleted if so.
		expel(H, T, 0) // expel at turf if nothing handled it

	return null

// nextdir
/obj/structure/disposalpipe/trunk/nextdir(var/fromdir)
	if(fromdir == DOWN)
		return dir
	else
		return 0

// a broken pipe
/obj/structure/disposalpipe/broken
	icon_state = "pipe-b"
	dpdir = 0		// broken pipes have dpdir=0 so they're not found as 'real' pipes
					// i.e. will be treated as an empty turf
	desc = "A broken piece of disposal pipe."

/obj/structure/disposalpipe/broken/Initialize(mapload)
	. = ..()
	update()

// called when welded
// for broken pipe, remove and turn into scrap
/obj/structure/disposalpipe/broken/welded()
//	var/obj/item/scrap/S = new(src.loc)
//	S.set_components(200,0,0)
	qdel(src)



// called when movable is expelled from a disposal pipe or outlet
// by default does nothing, override for special behaviour
/atom/movable/proc/pipe_eject(var/direction)
	return

// check if mob has client, if so restore client view on eject
/mob/pipe_eject(var/direction)
	if (src.client)
		src.client.perspective = MOB_PERSPECTIVE
		src.client.eye = src

	return

/obj/effect/decal/cleanable/blood/gibs/pipe_eject(var/direction)
	var/list/dirs
	if(direction)
		dirs = list( direction, turn(direction, -45), turn(direction, 45))
	else
		dirs = GLOB.alldirs.Copy()

	src.streak(dirs)

/obj/effect/decal/cleanable/blood/gibs/robot/pipe_eject(var/direction)
	var/list/dirs
	if(direction)
		dirs = list( direction, turn(direction, -45), turn(direction, 45))
	else
		dirs = GLOB.alldirs.Copy()

	src.streak(dirs)
