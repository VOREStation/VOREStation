// Disposal pipe construction
// This is the pipe that you drag around, not the attached ones.

/obj/structure/disposalconstruct

	name = "disposal pipe segment"
	desc = "A huge pipe segment used for constructing disposal systems."
	icon = 'icons/obj/pipes/disposal.dmi'
	icon_state = "conpipe-s"
	anchored = FALSE
	density = FALSE
	pressure_resistance = 5*ONE_ATMOSPHERE
	matter = list(MAT_STEEL = 1850)
	level = 2
	var/sortType = ""
	var/ptype = 0
	var/subtype = 0
	var/dpdir = 0	// directions as disposalpipe
	var/base_state = "pipe-s"

/obj/structure/disposalconstruct/New(var/newturf, var/newtype, var/newdir, var/flipped, var/newsubtype)
	..(newturf)
	ptype = newtype
	dir = newdir
	// Disposals handle "bent"/"corner" strangely, handle this specially.
	if(ptype == DISPOSAL_PIPE_STRAIGHT && (dir in cornerdirs))
		ptype = DISPOSAL_PIPE_CORNER
		switch(dir)
			if(NORTHWEST)
				dir = WEST
			if(NORTHEAST)
				dir = NORTH
			if(SOUTHWEST)
				dir = SOUTH
			if(SOUTHEAST)
				dir = EAST

	switch(ptype)
		if(DISPOSAL_PIPE_BIN, DISPOSAL_PIPE_OUTLET, DISPOSAL_PIPE_CHUTE)
			density = TRUE
		if(DISPOSAL_PIPE_SORTER, DISPOSAL_PIPE_SORTER_FLIPPED)
			subtype = newsubtype

	if(flipped)
		do_a_flip()
	else
		update() // do_a_flip() calls update anyway, so, lazy way of catching unupdated pipe!

// update iconstate and dpdir due to dir and type
/obj/structure/disposalconstruct/proc/update()
	var/flip = turn(dir, 180)
	var/left = turn(dir, 90)
	var/right = turn(dir, -90)

	switch(ptype)
		if(DISPOSAL_PIPE_STRAIGHT)
			base_state = "pipe-s"
			dpdir = dir | flip
		if(DISPOSAL_PIPE_CORNER)
			base_state = "pipe-c"
			dpdir = dir | right
		if(DISPOSAL_PIPE_JUNCTION)
			base_state = "pipe-j1"
			dpdir = dir | right | flip
		if(DISPOSAL_PIPE_JUNCTION_FLIPPED)
			base_state = "pipe-j2"
			dpdir = dir | left | flip
		if(DISPOSAL_PIPE_JUNCTION_Y)
			base_state = "pipe-y"
			dpdir = dir | left | right
		if(DISPOSAL_PIPE_TRUNK)
			base_state = "pipe-t"
			dpdir = dir
		 // disposal bin has only one dir, thus we don't need to care about setting it
		if(DISPOSAL_PIPE_BIN)
			if(anchored)
				base_state = "disposal"
			else
				base_state = "condisposal"
		if(DISPOSAL_PIPE_OUTLET)
			base_state = "outlet"
			dpdir = dir
		if(DISPOSAL_PIPE_CHUTE)
			base_state = "intake"
			dpdir = dir
		if(DISPOSAL_PIPE_SORTER)
			base_state = "pipe-j1s"
			dpdir = dir | right | flip
		if(DISPOSAL_PIPE_SORTER_FLIPPED)
			base_state = "pipe-j2s"
			dpdir = dir | left | flip
		if(DISPOSAL_PIPE_UPWARD)
			base_state = "pipe-u"
			dpdir = dir
		if(DISPOSAL_PIPE_DOWNWARD)
			base_state = "pipe-d"
			dpdir = dir
		if(DISPOSAL_PIPE_TAGGER)
			base_state = "pipe-tagger"
			dpdir = dir | flip
		if(DISPOSAL_PIPE_TAGGER_PARTIAL)
			base_state = "pipe-tagger-partial"
			dpdir = dir | flip

	if(!(ptype in list(DISPOSAL_PIPE_BIN, DISPOSAL_PIPE_OUTLET, DISPOSAL_PIPE_CHUTE, DISPOSAL_PIPE_UPWARD, DISPOSAL_PIPE_DOWNWARD, DISPOSAL_PIPE_TAGGER, DISPOSAL_PIPE_TAGGER_PARTIAL)))
		icon_state = "con[base_state]"
	else
		icon_state = base_state

	if(invisibility)				// if invisible, fade icon
		alpha = 128
	else
		alpha = 255
		//otherwise burying half-finished pipes under floors causes them to half-fade

// hide called by levelupdate if turf intact status changes
// change visibility status and force update of icon
/obj/structure/disposalconstruct/hide(var/intact)
	invisibility = (intact && level==1) ? 101: 0	// hide if floor is intact
	update()


// flip and rotate verbs
/obj/structure/disposalconstruct/verb/rotate_clockwise()
	set category = "Object"
	set name = "Rotate Pipe Clockwise"
	set src in view(1)

	if(usr.stat)
		return

	if(anchored)
		to_chat(usr, "You must unfasten the pipe before rotating it.")
		return

	src.set_dir(turn(src.dir, 270))
	update()

/obj/structure/disposalconstruct/verb/flip()
	set category = "Object"
	set name = "Flip Pipe"
	set src in view(1)
	if(usr.stat)
		return

	if(anchored)
		to_chat(usr, "You must unfasten the pipe before flipping it.")
		return

	do_a_flip()

/obj/structure/disposalconstruct/proc/do_a_flip()
	switch(ptype)
		if(DISPOSAL_PIPE_JUNCTION)
			ptype = DISPOSAL_PIPE_JUNCTION_FLIPPED
		if(DISPOSAL_PIPE_JUNCTION_FLIPPED)
			ptype = DISPOSAL_PIPE_JUNCTION
		if(DISPOSAL_PIPE_SORTER)
			ptype = DISPOSAL_PIPE_SORTER_FLIPPED
		if(DISPOSAL_PIPE_SORTER_FLIPPED)
			ptype = DISPOSAL_PIPE_SORTER

	update()

// returns the type path of disposalpipe corresponding to this item dtype
/obj/structure/disposalconstruct/proc/dpipetype()
	switch(ptype)
		if(DISPOSAL_PIPE_STRAIGHT,DISPOSAL_PIPE_CORNER)
			return /obj/structure/disposalpipe/segment
		if(DISPOSAL_PIPE_JUNCTION,DISPOSAL_PIPE_JUNCTION_FLIPPED,DISPOSAL_PIPE_JUNCTION_Y)
			return /obj/structure/disposalpipe/junction
		if(DISPOSAL_PIPE_TRUNK)
			return /obj/structure/disposalpipe/trunk
		if(DISPOSAL_PIPE_BIN)
			return /obj/machinery/disposal
		if(DISPOSAL_PIPE_OUTLET)
			return /obj/structure/disposaloutlet
		if(DISPOSAL_PIPE_CHUTE)
			return /obj/machinery/disposal/deliveryChute
		if(DISPOSAL_PIPE_SORTER)
			switch(subtype)
				if(DISPOSAL_SORT_NORMAL)
					return /obj/structure/disposalpipe/sortjunction
				if(DISPOSAL_SORT_WILDCARD)
					return /obj/structure/disposalpipe/sortjunction/wildcard
				if(DISPOSAL_SORT_UNTAGGED)
					return /obj/structure/disposalpipe/sortjunction/untagged
		if(DISPOSAL_PIPE_SORTER_FLIPPED)
			switch(subtype)
				if(DISPOSAL_SORT_NORMAL)
					return /obj/structure/disposalpipe/sortjunction/flipped
				if(DISPOSAL_SORT_WILDCARD)
					return /obj/structure/disposalpipe/sortjunction/wildcard/flipped
				if(DISPOSAL_SORT_UNTAGGED)
					return /obj/structure/disposalpipe/sortjunction/untagged/flipped
		if(DISPOSAL_PIPE_UPWARD)
			return /obj/structure/disposalpipe/up
		if(DISPOSAL_PIPE_DOWNWARD)
			return /obj/structure/disposalpipe/down
		if(DISPOSAL_PIPE_TAGGER)
			return /obj/structure/disposalpipe/tagger
		if(DISPOSAL_PIPE_TAGGER_PARTIAL)
			return /obj/structure/disposalpipe/tagger/partial
	return



// attackby item
// wrench: (un)anchor
// weldingtool: convert to real pipe
/obj/structure/disposalconstruct/attackby(var/obj/item/I, var/mob/user)
	var/nicetype = "pipe"
	var/ispipe = 0 // Indicates if we should change the level of this pipe
	src.add_fingerprint(user)
	switch(ptype)
		if(DISPOSAL_PIPE_BIN)
			nicetype = "disposal bin"
		if(DISPOSAL_PIPE_OUTLET)
			nicetype = "disposal outlet"
		if(DISPOSAL_PIPE_CHUTE)
			nicetype = "delivery chute"
		if(DISPOSAL_PIPE_SORTER, DISPOSAL_PIPE_SORTER_FLIPPED)
			switch(subtype)
				if(DISPOSAL_SORT_NORMAL)
					nicetype = "sorting pipe"
				if(DISPOSAL_SORT_WILDCARD)
					nicetype = "wildcard sorting pipe"
				if(DISPOSAL_SORT_UNTAGGED)
					nicetype = "untagged sorting pipe"
			ispipe = 1
		if(DISPOSAL_PIPE_TAGGER)
			nicetype = "tagging pipe"
			ispipe = 1
		if(DISPOSAL_PIPE_TAGGER_PARTIAL)
			nicetype = "partial tagging pipe"
			ispipe = 1
		else
			nicetype = "pipe"
			ispipe = 1

	var/turf/T = src.loc
	if(!T.is_plating())
		to_chat(user, "You can only attach the [nicetype] if the floor plating is removed.")
		return

	var/obj/structure/disposalpipe/CP = locate() in T

	// wrench: (un)anchor
	if(I.is_wrench())
		if(anchored)
			anchored = FALSE
			if(ispipe)
				level = 2
				density = FALSE
			else
				density = TRUE
			to_chat(user, "You detach the [nicetype] from the underfloor.")
		else
			if(ptype == DISPOSAL_PIPE_BIN || ptype == DISPOSAL_PIPE_OUTLET || ptype == DISPOSAL_PIPE_CHUTE) // Disposal or outlet
				if(CP) // There's something there
					if(!istype(CP,/obj/structure/disposalpipe/trunk))
						to_chat(user, "The [nicetype] requires a trunk underneath it in order to work.")
						return
				else // Nothing under, fuck.
					to_chat(user, "The [nicetype] requires a trunk underneath it in order to work.")
					return
			else
				if(CP)
					update()
					var/pdir = CP.dpdir
					if(istype(CP, /obj/structure/disposalpipe/broken))
						pdir = CP.dir
					if(pdir & dpdir)
						to_chat(user, "There is already a [nicetype] at that location.")
						return

			anchored = TRUE
			if(ispipe)
				level = 1 // We don't want disposal bins to disappear under the floors
				density = FALSE
			else
				density = TRUE // We don't want disposal bins or outlets to go density 0
			to_chat(user, "You attach the [nicetype] to the underfloor.")
		playsound(src, I.usesound, 100, 1)
		update()

	// weldingtool: convert to real pipe
	else if(istype(I, /obj/item/weapon/weldingtool))
		if(anchored)
			var/obj/item/weapon/weldingtool/W = I
			if(W.remove_fuel(0,user))
				playsound(src, W.usesound, 100, 1)
				to_chat(user, "Welding the [nicetype] in place.")
				if(do_after(user, 20 * W.toolspeed))
					if(!src || !W.isOn()) return
					to_chat(user, "The [nicetype] has been welded in place!")
					update() // TODO: Make this neat
					if(ispipe) // Pipe

						var/pipetype = dpipetype()
						var/obj/structure/disposalpipe/P = new pipetype(src.loc)
						src.transfer_fingerprints_to(P)
						P.base_icon_state = base_state
						P.set_dir(dir)
						P.dpdir = dpdir
						P.update_icon()

						//Needs some special treatment ;)
						if(ptype==DISPOSAL_PIPE_SORTER || ptype==DISPOSAL_PIPE_SORTER_FLIPPED)
							var/obj/structure/disposalpipe/sortjunction/SortP = P
							SortP.sortType = sortType
							SortP.updatedir()
							SortP.updatedesc()
							SortP.updatename()

					else if(ptype==DISPOSAL_PIPE_BIN)
						var/obj/machinery/disposal/P = new /obj/machinery/disposal(src.loc)
						src.transfer_fingerprints_to(P)
						P.mode = 0 // start with pump off

					else if(ptype==DISPOSAL_PIPE_OUTLET)
						var/obj/structure/disposaloutlet/P = new /obj/structure/disposaloutlet(src.loc)
						src.transfer_fingerprints_to(P)
						P.set_dir(dir)
						P.target = get_ranged_target_turf(src, dir, 10) //TODO: replace this with a proc parameter or other cleaner
						var/obj/structure/disposalpipe/trunk/Trunk = CP
						Trunk.linked = P

					else if(ptype==DISPOSAL_PIPE_CHUTE)
						var/obj/machinery/disposal/deliveryChute/P = new /obj/machinery/disposal/deliveryChute(src.loc)
						src.transfer_fingerprints_to(P)
						P.set_dir(dir)

					qdel(src)
					return
			else
				to_chat(user, "You need more welding fuel to complete this task.")
				return
		else
			to_chat(user, "You need to attach it to the plating first!")
			return

/obj/structure/disposalconstruct/hides_under_flooring()
	if(anchored)
		return 1
	else
		return 0

// VOREStation Add Start - Helper procs for RCD
/obj/structure/disposalconstruct/proc/is_pipe()
	return (ptype != DISPOSAL_PIPE_BIN && ptype != DISPOSAL_PIPE_OUTLET && ptype != DISPOSAL_PIPE_CHUTE)

//helper proc that makes sure you can place the construct (i.e no dense objects stacking)
/obj/structure/disposalconstruct/proc/can_place()
	if(is_pipe())
		return TRUE

	for(var/obj/structure/disposalconstruct/DC in get_turf(src))
		if(DC == src)
			continue

		if(!DC.is_pipe()) //there's already a chute/outlet/bin there
			return FALSE

	return TRUE
// VOREStation Add End
