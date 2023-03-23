/turf/simulated/floor/lava
	name = "lava"
	desc = "A pool of molten rock."
	description_info = "Molten rock is extremly dangerous, as it will cause massive harm to anything that touches it.<br>\
	A firesuit cannot fully protect from contact with molten rock."
	gender = PLURAL // So it says "That's some lava." on examine.
	icon = 'icons/turf/outdoors.dmi'
	icon_state = "lava"
	edge_blending_priority = -1
	light_range = 2
	light_power = 0.75
	light_color = LIGHT_COLOR_LAVA
	light_on = TRUE
	movement_cost = 2
	can_build_into_floor = TRUE
	can_be_plated = FALSE
	can_dirty = FALSE
	initial_flooring = /decl/flooring/lava // Defining this in case someone DOES step on lava and survive. Somehow.
	flags = TURF_ACID_IMMUNE

/turf/simulated/floor/lava/outdoors
	outdoors = OUTDOORS_YES

// For maximum pedantry.
/turf/simulated/floor/lava/Initialize()
	if(!is_outdoors())
		name = "magma"
	update_icon()
	update_light()
	return ..()

/turf/simulated/floor/lava/make_outdoors()
	..()
	name = "lava"

/turf/simulated/floor/lava/make_indoors()
	..()
	name = "magma"

/turf/simulated/floor/lava/make_plating(place_product, defer_icon_update)
	return

/turf/simulated/floor/lava/set_flooring(decl/flooring/newflooring, initializing)
	if(newflooring?.type == initial_flooring)
		return ..()
	return

/turf/simulated/floor/lava/ex_act(severity)
	return

/turf/simulated/floor/lava/Entered(atom/movable/AM)
	if(burn_stuff(AM))
		START_PROCESSING(SSturfs, src)

/turf/simulated/floor/lava/hitby(atom/movable/AM)
	if(burn_stuff(AM))
		START_PROCESSING(SSturfs, src)

/turf/simulated/floor/lava/process()
	if(!burn_stuff())
		return PROCESS_KILL

/turf/simulated/floor/lava/proc/is_safe()
	//if anything matching this typecache is found in the lava, we don't burn things
	var/static/list/lava_safeties_typecache = typecacheof(list(/obj/structure/catwalk))
	var/list/found_safeties = typecache_filter_list(contents, lava_safeties_typecache)
	return LAZYLEN(found_safeties)

/turf/simulated/floor/lava/proc/burn_stuff(atom/movable/AM)
	. = FALSE

	if(is_safe())
		return FALSE

	var/thing_to_check = src
	if(AM)
		thing_to_check = list(AM)

	for(var/thing in thing_to_check)
		if(isobj(thing))
			var/obj/O = thing
			if(O.throwing || O.is_incorporeal())
				continue
			. = TRUE
			O.lava_act()

		else if(isliving(thing))
			var/mob/living/L = thing
			if(L.hovering || L.throwing || L.is_incorporeal()) // Flying over the lava. We're just gonna pretend convection doesn't exist.
				continue
			. = TRUE
			L.lava_act()

// Lava that does nothing at all.
/turf/simulated/floor/lava/harmless/burn_stuff(atom/movable/AM)
	return FALSE

// Tells AI mobs to not suicide by pathing into lava if it would hurt them.
/turf/simulated/floor/lava/is_safe_to_enter(mob/living/L)
	if(!is_safe() && !L.hovering)
		return FALSE
	return ..()