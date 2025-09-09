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

/obj/structure/disposalpipe/junction/nextdir(fromdir)
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

/obj/structure/disposalpipe/sortjunction/attackby(obj/item/I, mob/user)
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

/obj/structure/disposalpipe/sortjunction/proc/divert_check(checkTag)
	return sortType == checkTag

// next direction to move
// if coming in from negdir then next is primary dir or sortdir
// if coming in from dir, Then next is negdir or sortdir
// if coming in from sortdir, always go to posdir

/obj/structure/disposalpipe/sortjunction/nextdir(fromdir, sortTag)
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

/obj/structure/disposalpipe/sortjunction/transfer(obj/structure/disposalholder/H)
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

/obj/structure/disposalpipe/sortjunction/wildcard/divert_check(checkTag)
	return checkTag != ""

//junction that filters all untagged items
/obj/structure/disposalpipe/sortjunction/untagged
	name = "untagged sorting junction"
	desc = "An underfloor disposal pipe which filters all untagged items."
	subtype = 2

/obj/structure/disposalpipe/sortjunction/untagged/divert_check(checkTag)
	return checkTag == ""

/obj/structure/disposalpipe/sortjunction/flipped //for easier and cleaner mapping
	icon_state = "pipe-j2s"

/obj/structure/disposalpipe/sortjunction/wildcard/flipped
	icon_state = "pipe-j2s"

/obj/structure/disposalpipe/sortjunction/untagged/flipped
	icon_state = "pipe-j2s"
