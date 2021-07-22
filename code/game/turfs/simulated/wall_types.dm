/turf/simulated/wall/r_wall
	icon_state = "rgeneric"
/turf/simulated/wall/r_wall/Initialize(mapload)
	. = ..(mapload, "plasteel","plasteel") //3strong

/turf/simulated/wall/shull
	icon_state = "hull-steel"
/turf/simulated/wall/shull/Initialize(mapload) //Spaaaace ship.
	. = ..(mapload,  MAT_STEELHULL, null, MAT_STEELHULL)
/turf/simulated/wall/rshull
	icon_state = "hull-r_steel"
/turf/simulated/wall/rshull/Initialize(mapload)
	. = ..(mapload,  MAT_STEELHULL, MAT_STEELHULL, MAT_STEELHULL)
/turf/simulated/wall/pshull
	icon_state = "hull-plasteel"
/turf/simulated/wall/pshull/Initialize(mapload) //Spaaaace-er ship.
	. = ..(mapload,  MAT_PLASTEELHULL, null, MAT_PLASTEELHULL)
/turf/simulated/wall/rpshull
	icon_state = "hull-r_plasteel"
/turf/simulated/wall/rpshull/Initialize(mapload)
	. = ..(mapload,  MAT_PLASTEELHULL, MAT_PLASTEELHULL, MAT_PLASTEELHULL)
/turf/simulated/wall/dshull
	icon_state = "hull-durasteel"
/turf/simulated/wall/dshull/Initialize(mapload) //Spaaaace-est ship.
	. = ..(mapload,  MAT_DURASTEELHULL, null, MAT_DURASTEELHULL)
/turf/simulated/wall/rdshull
	icon_state = "hull-r_durasteel"
/turf/simulated/wall/rdshull/Initialize(mapload)
	. = ..(mapload,  MAT_DURASTEELHULL, MAT_DURASTEELHULL, MAT_DURASTEELHULL)
/turf/simulated/wall/thull
	icon_state = "hull-titanium"
/turf/simulated/wall/thull/Initialize(mapload)
	. = ..(mapload,  MAT_TITANIUMHULL, null, MAT_TITANIUMHULL)
/turf/simulated/wall/rthull
	icon_state = "hull-r_titanium"
/turf/simulated/wall/rthull/Initialize(mapload)
	. = ..(mapload,  MAT_TITANIUMHULL, MAT_TITANIUMHULL, MAT_TITANIUMHULL)

/turf/simulated/wall/cult
	icon_state = "cult"
/turf/simulated/wall/cult/Initialize(mapload)
	. = ..(mapload, "cult","cult2","cult")
/turf/unsimulated/wall/cult
	name = "cult wall"
	desc = "Hideous images dance beneath the surface."
	icon = 'icons/turf/wall_masks.dmi'
	icon_state = "cult"

/turf/simulated/wall/iron/Initialize(mapload)
	. = ..(mapload, "iron")
/turf/simulated/wall/uranium/Initialize(mapload)
	. = ..(mapload, "uranium")
/turf/simulated/wall/diamond/Initialize(mapload)
	. = ..(mapload, "diamond")
/turf/simulated/wall/gold/Initialize(mapload)
	. = ..(mapload, "gold")
/turf/simulated/wall/silver/Initialize(mapload)
	. = ..(mapload, "silver")
/turf/simulated/wall/lead/Initialize(mapload)
	. = ..(mapload, "lead")
/turf/simulated/wall/r_lead/Initialize(mapload)
	. = ..(mapload, "lead", "lead")
/turf/simulated/wall/phoron/Initialize(mapload)
	. = ..(mapload, "phoron")
/turf/simulated/wall/sandstone/Initialize(mapload)
	. = ..(mapload, "sandstone")
/turf/simulated/wall/ironphoron/Initialize(mapload)
	. = ..(mapload, "iron","phoron")
/turf/simulated/wall/golddiamond/Initialize(mapload)
	. = ..(mapload, "gold","diamond")
/turf/simulated/wall/silvergold/Initialize(mapload)
	. = ..(mapload, "silver","gold")
/turf/simulated/wall/sandstonediamond/Initialize(mapload)
	. = ..(mapload, "sandstone","diamond")
/turf/simulated/wall/snowbrick/Initialize(mapload)
	. = ..(mapload, "packed snow")

/turf/simulated/wall/resin/Initialize(mapload)
	. = ..(mapload, "resin",null,"resin")

// Kind of wondering if this is going to bite me in the butt.
/turf/simulated/wall/skipjack/Initialize(mapload)
	. = ..(mapload, "alienalloy")
/turf/simulated/wall/skipjack/attackby()
	return
/turf/simulated/wall/titanium/Initialize(mapload)
	. = ..(mapload, "titanium")

/turf/simulated/wall/durasteel/Initialize(mapload)
	. = ..(mapload, "durasteel", "durasteel")

/turf/simulated/wall/wood/Initialize(mapload)
	. = ..(mapload,  MAT_WOOD)

/turf/simulated/wall/sifwood/Initialize(mapload)
	. = ..(mapload,  MAT_SIFWOOD)

/turf/simulated/wall/log/Initialize(mapload)
	. = ..(mapload,  MAT_LOG)

/turf/simulated/wall/log_sif/Initialize(mapload)
	. = ..(mapload,  MAT_SIFLOG)

// Shuttle Walls
/turf/simulated/shuttle/wall
	name = "autojoin wall"
	icon_state = "light"
	opacity = 1
	density = TRUE
	blocks_air = 1

	var/base_state = "light" //The base iconstate to base sprites on
	var/hard_corner = 0 //Forces hard corners (as opposed to diagonals)
	var/true_name = "wall" //What to rename this to on init

	//Extra things this will try to locate and act like we're joining to. You can put doors, or whatever.
	//Carefully means only if it's on a /turf/simulated/shuttle subtype turf.
	var/static/list/join_carefully = list(
	/obj/structure/grille,
	/obj/machinery/door/blast/regular
	)
	var/static/list/join_always = list(
	/obj/structure/shuttle/engine,
	/obj/structure/shuttle/window,
	/obj/machinery/door/airlock/voidcraft
	)

/turf/simulated/shuttle/wall/hard_corner
	name = "hardcorner wall"
	icon_state = "light-hc"
	hard_corner = 1

/turf/simulated/shuttle/wall/no_join
	icon_state = "light-nj"
	join_group = null

/turf/simulated/shuttle/wall/dark
	icon = 'icons/turf/shuttle_dark.dmi'
	icon_state = "dark"
	base_state = "dark"

/turf/simulated/shuttle/wall/dark/hard_corner
	name = "hardcorner wall"
	icon_state = "dark-hc"
	hard_corner = 1

/turf/simulated/shuttle/wall/dark/no_join
	name = "nojoin wall"
	icon_state = "dark-nj"
	join_group = null

/turf/simulated/shuttle/wall/alien
	icon = 'icons/turf/shuttle_alien.dmi'
	icon_state = "alien"
	base_state = "alien"
	light_range = 3
	light_power = 0.75
	light_color = "#ff0066" // Pink-ish
	light_on = TRUE
	block_tele = TRUE // Will be used for dungeons so this is needed to stop cheesing with handteles.

/turf/simulated/shuttle/wall/alien/Initialize()
	. = ..()
	update_light()

/turf/simulated/shuttle/wall/alien/hard_corner
	name = "hardcorner wall"
	icon_state = "alien-hc"
	hard_corner = 1

/turf/simulated/shuttle/wall/alien/no_join
	name = "nojoin wall"
	icon_state = "alien-nj"
	join_group = null

/turf/simulated/shuttle/wall/Initialize()
	. = ..()

	//To allow mappers to rename shuttle walls to like "redfloor interior" or whatever for ease of use.
	name = true_name

	if(join_group)
		auto_join()
	else
		icon_state = base_state

	if(takes_underlays)
		underlay_update()

/turf/simulated/shuttle/wall/proc/auto_join()
	match_turf(NORTH, NORTH)
	match_turf(EAST, EAST)
	match_turf(SOUTH, SOUTH)
	match_turf(WEST, WEST)

	icon_state = "[base_state][join_flags]"
	if(isDiagonal(join_flags))
		if(hard_corner) //You are using 'hard' (aka full-tile) corners.
			icon_state += "h" //Hard corners have 'h' at the end of the state
		else //Diagonals need an underlay to not look ugly.
			takes_underlays = 1
	else //Everything else doesn't deserve our time!
		takes_underlays = initial(takes_underlays)

	return join_flags

/turf/simulated/shuttle/wall/proc/match_turf(direction, flag, mask=0)
	if((join_flags & mask) == mask)
		var/turf/simulated/shuttle/wall/adj = get_step(src, direction)
		if(istype(adj, /turf/simulated/shuttle/wall) && adj.join_group == src.join_group)
			join_flags |= flag      // turn on the bit flag
			return

		else if(istype(adj, /turf/simulated/shuttle))
			var/turf/simulated/shuttle/adj_cast = adj
			if(adj_cast.join_group == src.join_group)
				var/found
				for(var/E in join_carefully)
					found = locate(E) in adj
					if(found) break
				if(found)
					join_flags |= flag      // turn on the bit flag
					return

		var/always_found
		for(var/E in join_always)
			always_found = locate(E) in adj
			if(always_found) break
		if(always_found)
			join_flags |= flag      // turn on the bit flag
		else
			join_flags &= ~flag     // turn off the bit flag

/turf/simulated/shuttle/wall/voidcraft
	name = "voidcraft wall"
	icon = 'icons/turf/shuttle_void.dmi'
	icon_state = "void"
	base_state = "void"
	var/stripe_color = null // If set, generates a colored stripe overlay.  Accepts #XXXXXX as input.

/turf/simulated/shuttle/wall/voidcraft/hard_corner
	name = "hardcorner wall"
	icon_state = "void-hc"
	hard_corner = 1

/turf/simulated/shuttle/wall/voidcraft/no_join
	name = "nojoin wall"
	icon_state = "void-nj"
	join_group = null

/turf/simulated/shuttle/wall/voidcraft/red
	stripe_color = "#FF0000"

/turf/simulated/shuttle/wall/voidcraft/blue
	stripe_color = "#0000FF"

/turf/simulated/shuttle/wall/voidcraft/green
	stripe_color = "#00FF00"

/turf/simulated/shuttle/wall/voidcraft/Initialize()
	. = ..()
	update_icon()

/turf/simulated/shuttle/wall/voidcraft/update_icon()
	if(stripe_color)
		cut_overlays()
		var/image/I = image(icon = src.icon, icon_state = "o_[icon_state]")
		I.color = stripe_color
		add_overlay(I)

// Fake corners for making hulls look pretty
/obj/structure/hull_corner
	name = "hull corner"
	plane = OBJ_PLANE - 1
	
	icon = 'icons/turf/wall_masks.dmi'
	icon_state = "hull_corner"
	
	anchored = TRUE
	density = TRUE
	breakable = TRUE

/obj/structure/hull_corner/Initialize()
	return INITIALIZE_HINT_LATELOAD

/obj/structure/hull_corner/LateInitialize()
	. = ..()
	update_look()

/obj/structure/hull_corner/proc/get_dirs_to_test()
	return list(dir, turn(dir,90))

/obj/structure/hull_corner/proc/update_look()
	cut_overlays()
	
	var/turf/simulated/wall/T
	for(var/direction in get_dirs_to_test())
		T = get_step(src, direction)
		if(!istype(T))
			continue
		
		name = T.name
		desc = T.desc
		
		var/datum/material/B = T.material
		var/datum/material/R = T.reinf_material
		
		if(B?.icon_colour)
			color = B.icon_colour
		if(R?.icon_colour)
			var/image/I = image(icon, icon_state+"_reinf", dir=dir)
			I.color = R.icon_colour
			add_overlay(I)
		break
	
	if(!T)
		warning("Hull corner at [x],[y] not placed adjacent to a hull it can find.")

/obj/structure/hull_corner/long_vert
	icon = 'icons/turf/wall_masks32x64.dmi'
	bound_height = 64

/obj/structure/hull_corner/long_vert/get_dirs_to_test()
	return list(dir, turn(dir,90), turn(dir,-90))

/obj/structure/hull_corner/long_horiz
	icon = 'icons/turf/wall_masks64x32.dmi'
	bound_width = 64

/obj/structure/hull_corner/long_horiz/get_dirs_to_test()
	return list(dir, turn(dir,90), turn(dir,-90))



// Eris walls
/turf/simulated/wall/eris
	icon = 'icons/turf/wall_masks_eris.dmi'
	icon_state = "generic"
	wall_masks = 'icons/turf/wall_masks_eris.dmi'
	var/list/blend_objects = list(/obj/machinery/door)
	var/list/noblend_objects = list(/obj/machinery/door/window, /obj/machinery/door/firedoor)

/turf/simulated/wall/eris/can_join_with_low_wall(var/obj/structure/low_wall/WF)
	return istype(WF, /obj/structure/low_wall/eris)
/turf/simulated/wall/eris/special_wall_connections(list/dirs, list/inrange)
	..()
	for(var/direction in cardinal)
		var/turf/T = get_step(src, direction)
		var/decided_to_blend = FALSE
		blend_obj_loop:
			for(var/obj/O in T)
				for(var/b_type in blend_objects)
					if(istype(O, b_type))
						decided_to_blend = TRUE
						for(var/obj/structure/S in T)
							if(istype(S, src))
								decided_to_blend = FALSE
						for(var/nb_type in noblend_objects)
							if(istype(O, nb_type))
								decided_to_blend = FALSE

					if(decided_to_blend)
						dirs += direction
						break blend_obj_loop // breaks outer loop

/turf/simulated/wall/eris/r_wall
	icon_state = "rgeneric"
/turf/simulated/wall/eris/r_wall/Initialize(mapload)
	. = ..(mapload, "plasteel","plasteel")

// Bay walls
/turf/simulated/wall/bay
	icon = 'icons/turf/wall_masks_bay.dmi'
	icon_state = "generic"
	wall_masks = 'icons/turf/wall_masks_bay.dmi'
	var/list/blend_objects = list(/obj/machinery/door)
	var/list/noblend_objects = list(/obj/machinery/door/window, /obj/machinery/door/firedoor)

	var/stripe_color // Adds a colored stripe to the walls

/turf/simulated/wall/bay/can_join_with_low_wall(var/obj/structure/low_wall/WF)
	return istype(WF, /obj/structure/low_wall/bay)

/turf/simulated/wall/bay/update_icon()
	. = ..()
	if(stripe_color)
		var/image/I
		for(var/i = 1 to 4)
			I = image(wall_masks, "stripe[wall_connections[i]]", dir = 1<<(i-1))
			I.color = stripe_color
			add_overlay(I)

/turf/simulated/wall/bay/special_wall_connections(list/dirs, list/inrange)
	..()
	for(var/direction in cardinal)
		var/turf/T = get_step(src, direction)
		var/decided_to_blend = FALSE
		blend_obj_loop:
			for(var/obj/O in T)
				for(var/b_type in blend_objects)
					if(istype(O, b_type))
						decided_to_blend = TRUE
						for(var/obj/structure/S in T)
							if(istype(S, src))
								decided_to_blend = FALSE
						for(var/nb_type in noblend_objects)
							if(istype(O, nb_type))
								decided_to_blend = FALSE

					if(decided_to_blend)
						dirs += direction
						break blend_obj_loop // breaks outer loop

/turf/simulated/wall/bay/r_wall
	icon_state = "rgeneric"
/turf/simulated/wall/bay/r_wall/Initialize(mapload)
	. = ..(mapload, "plasteel","plasteel")
