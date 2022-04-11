#define CONSTRUCTION_UNANCHORED 0
#define CONSTRUCTION_WRENCHED 1
#define CONSTRUCTION_WELDED 2

/obj/structure/ladder_assembly
	name = "ladder assembly"
	icon = 'icons/obj/structures_vr.dmi'
	icon_state = "ladder00"
	density = FALSE
	opacity = 0
	anchored = FALSE
	w_class = ITEMSIZE_HUGE

	var/state = 0
	var/created_name = null

/obj/structure/ladder_assembly/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/weapon/pen))
		var/t = sanitizeSafe(input(user, "Enter the name for the ladder.", "Ladder Name", src.created_name), MAX_NAME_LEN)
		if(in_range(src, user))
			created_name = t
		return

	else if(istype(get_area(src), /area/shuttle))
		to_chat(user, "<span class='warning'>\The [src] cannot be constructed on a shuttle.</span>")
		return
	if(W.is_wrench())
		switch(state)
			if(CONSTRUCTION_UNANCHORED)
				state = CONSTRUCTION_WRENCHED
				playsound(src, 'sound/items/Ratchet.ogg', 75, 1)
				user.visible_message("\The [user] secures \the [src]'s reinforcing bolts.", \
					"You secure the reinforcing bolts.", \
					"You hear a ratchet")
				src.anchored = TRUE
			if(CONSTRUCTION_WRENCHED)
				state = CONSTRUCTION_UNANCHORED
				playsound(src, 'sound/items/Ratchet.ogg', 75, 1)
				user.visible_message("\The [user] unsecures \the [src]'s reinforcing bolts.", \
					"You undo the reinforcing bolts.", \
					"You hear a ratchet")
				src.anchored = FALSE
			if(CONSTRUCTION_WELDED)
				to_chat(user, "<span class='warning'>\The [src] needs to be unwelded.</span>")
		return

	if(istype(W, /obj/item/weapon/weldingtool))
		var/obj/item/weapon/weldingtool/WT = W
		switch(state)
			if(CONSTRUCTION_UNANCHORED)
				to_chat(user, "<span class='warning'>The refinforcing bolts need to be secured.</span>")
			if(CONSTRUCTION_WRENCHED)
				if(WT.remove_fuel(0, user))
					playsound(src, 'sound/items/Welder2.ogg', 50, 1)
					user.visible_message("\The [user] starts to weld \the [src] to the floor.", \
						"You start to weld \the [src] to the floor.", \
						"You hear welding")
					if(do_after(user, 2 SECONDS))
						if(QDELETED(src) || !WT.isOn()) return
						state = CONSTRUCTION_WELDED
						to_chat(user, "You weld \the [src] to the floor.")
						try_construct(user)
				else
					to_chat(user, "<span class='warning'>You need more welding fuel to complete this task.</span>")
			if(CONSTRUCTION_WELDED)
				if(WT.remove_fuel(0, user))
					playsound(src, 'sound/items/Welder2.ogg', 50, 1)
					user.visible_message("\The [user] starts to cut \the [src] free from the floor.", \
						"You start to cut \the [src] free from the floor.", \
						"You hear welding")
					if(do_after(user, 2 SECONDS))
						if(QDELETED(src) || !WT.isOn()) return
						state = CONSTRUCTION_WRENCHED
						to_chat(user, "You cut \the [src] free from the floor.")
				else
					to_chat(user, "<span class='warning'>You need more welding fuel to complete this task.</span>")
		return

// Try to construct this into a real stairway.
// It must have a matching ladder assembly above and/or below, and both must be welded in place
// NOTE - Currently this design only supports three story tall ladders.  Its fine for our map tho.
// A better way would search upwards until finding the top, then call a proc on that to build the string.
/obj/structure/ladder_assembly/proc/try_construct(mob/user)
	var/obj/structure/ladder_assembly/below
	var/obj/structure/ladder_assembly/above

	for(var/direction in list(DOWN, UP))
		var/turf/T = get_zstep(src, direction)
		if(!T) continue
		var/obj/structure/ladder_assembly/LA = locate(/obj/structure/ladder_assembly, T)
		if(!LA) continue
		if(direction == DOWN && (src.z in using_map.below_blocked_levels)) continue
		if(direction == UP && (LA.z in using_map.below_blocked_levels)) continue
		if(LA.state != CONSTRUCTION_WELDED)
			to_chat(user, "<span class='warning'>\The [LA] [direction == UP ? "above" : "below"] must be secured and welded.</span>")
			return
		if(direction == UP)
			above = LA
		if(direction == DOWN)
			below = LA

	if(!above && !below)
		to_chat(user, "<span class='notice'>\The [src] is ready to be connected to from above or below.</span>")
		return

	// Construct them from bottom to top, because they initialize from top to bottom.
	// If we made bottom last, nothing would initialize it.
	var/obj/structure/ladder_assembly/me = src
	src = null // So we can delete ourselves etc.

	if(below)
		var/obj/structure/ladder/L = new(get_turf(below))
		L.allowed_directions = UP
		if(below.created_name) L.name = below.created_name
		L.Initialize()
		qdel(below)

	if(me)
		var/obj/structure/ladder/L = new(get_turf(me))
		L.allowed_directions = (below ? DOWN : 0) | (above ? UP : 0)
		if(me.created_name) L.name = me.created_name
		L.Initialize()
		qdel(me)

	if(above)
		var/obj/structure/ladder/L = new(get_turf(above))
		L.allowed_directions = DOWN
		if(above.created_name) L.name = above.created_name
		L.Initialize()
		qdel(above)

// Make them constructable in hand
/datum/material/steel/generate_recipes()
	..()
	recipes += new/datum/stack_recipe("ladder assembly", /obj/structure/ladder_assembly, 4, time = 50, one_per_turf = 1, on_floor = 1)

#undef CONSTRUCTION_UNANCHORED
#undef CONSTRUCTION_WRENCHED
#undef CONSTRUCTION_WELDED
