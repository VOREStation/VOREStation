//Define all tape types in policetape.dm
/obj/item/taperoll
	name = "tape roll"
	icon = 'icons/policetape.dmi'
	icon_state = "tape"
	w_class = ITEMSIZE_SMALL

	toolspeed = 3 //You can use it in surgery. It's stupid, but you can.

	var/turf/start
	var/turf/end
	var/tape_type = /obj/item/tape
	var/icon_base = "tape"

	var/apply_tape = FALSE

/obj/item/taperoll/Initialize()
	. = ..()
	if(apply_tape)
		var/turf/T = get_turf(src)
		if(!T)
			return
		var/obj/machinery/door/door = locate(/obj/machinery/door) in T
		if((door == /obj/machinery/door/airlock) || (door == /obj/machinery/door/firedoor))
			afterattack(door, null, TRUE)
		return INITIALIZE_HINT_QDEL


var/list/image/hazard_overlays
var/list/tape_roll_applications = list()

/obj/item/tape
	name = "tape"
	icon = 'icons/policetape.dmi'
	icon_state = "tape"
	anchored = TRUE
	layer = WINDOW_LAYER
	var/lifted = 0
	var/crumpled = 0
	var/tape_dir = 0
	var/icon_base = "tape"

/obj/item/tape/update_icon()
	//Possible directional bitflags: 0 (AIRLOCK), 1 (NORTH), 2 (SOUTH), 4 (EAST), 8 (WEST), 3 (VERTICAL), 12 (HORIZONTAL)
	switch (tape_dir)
		if(0)  // AIRLOCK
			icon_state = "[icon_base]_door_[crumpled]"
		if(3)  // VERTICAL
			icon_state = "[icon_base]_v_[crumpled]"
		if(12) // HORIZONTAL
			icon_state = "[icon_base]_h_[crumpled]"
		else   // END POINT (1|2|4|8)
			icon_state = "[icon_base]_dir_[crumpled]"
			dir = tape_dir

/obj/item/tape/New()
	..()
	if(!hazard_overlays)
		hazard_overlays = list()
		hazard_overlays["[NORTH]"]	= new/image('icons/effects/warning_stripes.dmi', icon_state = "N")
		hazard_overlays["[EAST]"]	= new/image('icons/effects/warning_stripes.dmi', icon_state = "E")
		hazard_overlays["[SOUTH]"]	= new/image('icons/effects/warning_stripes.dmi', icon_state = "S")
		hazard_overlays["[WEST]"]	= new/image('icons/effects/warning_stripes.dmi', icon_state = "W")
	update_icon()

/obj/item/taperoll/medical
	name = "medical tape"
	desc = "A roll of medical tape used to block off patients from the public."
	tape_type = /obj/item/tape/medical
	color = COLOR_WHITE

/obj/item/tape/medical
	name = "medical tape"
	desc = "A length of medical tape.  Do not cross."
	req_access = list(access_medical)
	color = COLOR_WHITE

/obj/item/taperoll/police
	name = "police tape"
	desc = "A roll of police tape used to block off crime scenes from the public."
	tape_type = /obj/item/tape/police
	color = COLOR_RED_LIGHT

/obj/item/tape/police
	name = "police tape"
	desc = "A length of police tape.  Do not cross."
	req_access = list(access_security)
	color = COLOR_RED_LIGHT

/obj/item/taperoll/engineering
	name = "engineering tape"
	desc = "A roll of engineering tape used to block off working areas from the public."
	tape_type = /obj/item/tape/engineering
	color = COLOR_YELLOW

/obj/item/taperoll/engineering/applied
	apply_tape = TRUE

/obj/item/tape/engineering
	name = "engineering tape"
	desc = "A length of engineering tape. Better not cross it."
	req_one_access = list(access_engine,access_atmospherics)
	color = COLOR_YELLOW

/obj/item/taperoll/atmos
	name = "atmospherics tape"
	desc = "A roll of atmospherics tape used to block off working areas from the public."
	tape_type = /obj/item/tape/atmos
	color = COLOR_DEEP_SKY_BLUE

/obj/item/tape/atmos
	name = "atmospherics tape"
	desc = "A length of atmospherics tape. Better not cross it."
	req_one_access = list(access_engine,access_atmospherics)
	color = COLOR_DEEP_SKY_BLUE

/obj/item/taperoll/update_icon()
	cut_overlays()
	var/image/overlay = image(icon = src.icon)
	overlay.appearance_flags = RESET_COLOR
	if(ismob(loc))
		if(!start)
			overlay.icon_state = "start"
		else
			overlay.icon_state = "stop"
		add_overlay(overlay)


/obj/item/taperoll/dropped(mob/user)
	update_icon()
	return ..()

/obj/item/taperoll/pickup(mob/user)
	update_icon()
	return ..()

/obj/item/taperoll/attack_hand()
	update_icon()
	return ..()

/obj/item/taperoll/attack_self(mob/user as mob)
	if(!start)
		start = get_turf(src)
		to_chat(user, span_notice("You place the first end of \the [src]."))
		update_icon()
	else
		end = get_turf(src)
		if(start.y != end.y && start.x != end.x || start.z != end.z)
			start = null
			update_icon()
			to_chat(user, span_notice("\The [src] can only be laid horizontally or vertically."))
			return

		if(start == end)
			// spread tape in all directions, provided there is a wall/window
			var/turf/T
			var/possible_dirs = 0
			for(var/dir in cardinal)
				T = get_step(start, dir)
				if(T && T.density)
					possible_dirs |= dir
				else
					for(var/obj/structure/window/W in T)
						if(W.is_fulltile() || W.dir == reverse_dir[dir])
							possible_dirs |= dir
			for(var/obj/structure/window/window in start)
				if(istype(window) && !window.is_fulltile())
					possible_dirs |= window.dir
			if(!possible_dirs)
				start = null
				update_icon()
				to_chat(user, span_notice("You can't place \the [src] here."))
				return
			if(possible_dirs & (NORTH|SOUTH))
				var/obj/item/tape/TP = new tape_type(start)
				for(var/dir in list(NORTH, SOUTH))
					if (possible_dirs & dir)
						TP.tape_dir += dir
				TP.update_icon()
			if(possible_dirs & (EAST|WEST))
				var/obj/item/tape/TP = new tape_type(start)
				for(var/dir in list(EAST, WEST))
					if (possible_dirs & dir)
						TP.tape_dir += dir
				TP.update_icon()
			start = null
			update_icon()
			to_chat(user, span_notice("You finish placing \the [src]."))
			return

		var/turf/cur = start
		var/orientation = get_dir(start, end)
		var/dir = 0
		switch(orientation)
			if(NORTH, SOUTH)	dir = NORTH|SOUTH	// North-South taping
			if(EAST,   WEST)	dir =  EAST|WEST	// East-West taping

		var/can_place = 1
		while (can_place)
			if(cur.density == 1)
				can_place = 0
			else if (istype(cur, /turf/space))
				can_place = 0
			else
				for(var/obj/O in cur)
					if(istype(O, /obj/structure/window))
						var/obj/structure/window/window = O
						if(window.is_fulltile())
							can_place = 0
							break
						if(cur == start)
							if(window.dir == orientation)
								can_place = 0
								break
							else
								continue
						else if(cur == end)
							if(window.dir == reverse_dir[orientation])
								can_place = 0
								break
							else
								continue
						else if (window.dir == reverse_dir[orientation] || window.dir == orientation)
							can_place = 0
							break
						else
							continue
					if(O.density)
						can_place = 0
						break
			if(cur == end)
				break
			cur = get_step_towards(cur,end)
		if (!can_place)
			start = null
			update_icon()
			to_chat(user, span_warning("You can't run \the [src] through that!"))
			return

		cur = start
		var/tapetest
		var/tape_dir
		while (1)
			tapetest = 0
			tape_dir = dir
			if(cur == start)
				var/turf/T = get_step(start, reverse_dir[orientation])
				if(T && !T.density)
					tape_dir = orientation
					for(var/obj/structure/window/W in T)
						if(W.is_fulltile() || W.dir == orientation)
							tape_dir = dir
				for(var/obj/structure/window/window in cur)
					if(istype(window) && !window.is_fulltile() && window.dir == reverse_dir[orientation])
						tape_dir = dir
			else if(cur == end)
				var/turf/T = get_step(end, orientation)
				if(T && !T.density)
					tape_dir = reverse_dir[orientation]
					for(var/obj/structure/window/W in T)
						if(W.is_fulltile() || W.dir == reverse_dir[orientation])
							tape_dir = dir
				for(var/obj/structure/window/window in cur)
					if(istype(window) && !window.is_fulltile() && window.dir == orientation)
						tape_dir = dir
			for(var/obj/item/tape/T in cur)
				if((T.tape_dir == tape_dir) && (T.icon_base == icon_base))
					tapetest = 1
					break
			if(!tapetest)
				var/obj/item/tape/T = new tape_type(cur)
				T.tape_dir = tape_dir
				T.update_icon()
				if(tape_dir & SOUTH)
					T.layer += 0.1 // Must always show above other tapes
			if(cur == end)
				break
			cur = get_step_towards(cur,end)
		start = null
		update_icon()
		to_chat(user, span_notice("You finish placing \the [src]."))
		return

/obj/item/taperoll/afterattack(var/atom/A, mob/user as mob, proximity)
	if(!proximity)
		return

	if (istype(A, /obj/machinery/door))
		var/turf/T = get_turf(A)
		if(locate(/obj/item/tape, A.loc))
			to_chat(user, "There's already tape over that door!")
		else
			var/obj/item/tape/P = new tape_type(T)
			P.update_icon()
			P.layer = WINDOW_LAYER
			to_chat(user, span_notice("You finish placing \the [src]."))

	if (istype(A, /turf/simulated/floor) ||istype(A, /turf/unsimulated/floor))
		var/turf/F = A
		var/direction = user.loc == F ? user.dir : turn(user.dir, 180)
		var/icon/hazard_overlay = hazard_overlays["[direction]"]
		if(tape_roll_applications[F] == null)
			tape_roll_applications[F] = 0

		if(tape_roll_applications[F] & direction) // hazard_overlay in F.overlays wouldn't work.
			user.visible_message("\The [user] uses the adhesive of \the [src] to remove area markings from \the [F].", "You use the adhesive of \the [src] to remove area markings from \the [F].")
			F.cut_overlay(hazard_overlay)
			tape_roll_applications[F] &= ~direction
		else
			user.visible_message("\The [user] applied \the [src] on \the [F] to create area markings.", "You apply \the [src] on \the [F] to create area markings.")
			F.add_overlay(hazard_overlay)
			tape_roll_applications[F] |= direction
		return

/obj/item/tape/proc/crumple()
	if(!crumpled)
		crumpled = 1
		update_icon()
		name = "crumpled [name]"

/obj/item/tape/CanPass(atom/movable/mover, turf/target)
	if(!lifted && ismob(mover))
		var/mob/M = mover
		add_fingerprint(M)
		if(!allowed(M))	//only select few learn art of not crumpling the tape
			to_chat(M, span_warning("You are not supposed to go past \the [src]..."))
			if(M.a_intent == I_HELP && !(isanimal(M)))
				return FALSE
			crumple()
	return ..()

/obj/item/tape/attackby(obj/item/W as obj, mob/user as mob)
	breaktape(user)

/obj/item/tape/attack_hand(mob/user as mob)
	if (user.a_intent == I_HELP && src.allowed(user))
		user.show_viewers(span_infoplain(span_bold("\The [user]") + " lifts \the [src], allowing passage."))
		for(var/obj/item/tape/T in gettapeline())
			T.lift(100) //~10 seconds
	else
		breaktape(user)

/obj/item/tape/proc/lift(time)
	lifted = 1
	plane = MOB_PLANE
	layer = ABOVE_MOB_LAYER
	spawn(time)
		lifted = 0
		reset_plane_and_layer()

// Returns a list of all tape objects connected to src, including itself.
/obj/item/tape/proc/gettapeline()
	var/list/dirs = list()
	if(tape_dir & NORTH)
		dirs += NORTH
	if(tape_dir & SOUTH)
		dirs += SOUTH
	if(tape_dir & WEST)
		dirs += WEST
	if(tape_dir & EAST)
		dirs += EAST

	var/list/obj/item/tape/tapeline = list()
	for (var/obj/item/tape/T in get_turf(src))
		tapeline += T
	for(var/dir in dirs)
		var/turf/cur = get_step(src, dir)
		var/not_found = 0
		while (!not_found)
			not_found = 1
			for (var/obj/item/tape/T in cur)
				tapeline += T
				not_found = 0
			cur = get_step(cur, dir)
	return tapeline

/obj/item/tape/proc/breaktape(mob/user)
	if(user.a_intent == I_HELP)
		to_chat(user, span_warning("You refrain from breaking \the [src]."))
		return
	user.visible_message(span_bold("\The [user]") + "breaks \the [src]!",span_notice("You break \the [src]."))

	for (var/obj/item/tape/T in gettapeline())
		if(T == src)
			continue
		if(T.tape_dir & get_dir(T, src))
			qdel(T)

	qdel(src) //TODO: Dropping a trash item holding fibers/fingerprints of all broken tape parts
	return
