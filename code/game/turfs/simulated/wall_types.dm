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

<<<<<<< HEAD
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
=======
/turf/simulated/wall/phoron
	material = MAT_PHORON

/turf/simulated/wall/sandstone
	material = MAT_SANDSTONE

/turf/simulated/wall/ironphoron
	material = MAT_IRON
	reinf_material = MAT_PHORON

/turf/simulated/wall/golddiamond
	material = MAT_GOLD
	reinf_material = MAT_DIAMOND

/turf/simulated/wall/silvergold
	material = MAT_SILVER
	reinf_material = MAT_GOLD

/turf/simulated/wall/sandstonediamond
	material = MAT_SANDSTONE
	reinf_material = MAT_DIAMOND

/turf/simulated/wall/snowbrick
	material = "packed snow"

/turf/simulated/wall/resin
	material = "resin"
	girder_material = "resin"

/turf/simulated/wall/concrete
	desc = "A wall made out of concrete bricks"
	material = MAT_CONCRETE
	icon_state = "brick"
/turf/simulated/wall/r_concrete
	desc = "A sturdy wall made of concrete and reinforced with plasteel rebar"
	material = MAT_CONCRETE
	reinf_material = MAT_PLASTEELREBAR
	icon_state = "rbrick"
>>>>>>> 67dee1d311d... Merge pull request #8702 from Cerebulon/concreteintegration

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

/turf/simulated/wall/hardwood/Initialize(mapload)
	. = ..(mapload,  MAT_HARDWOOD)

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
		if(!istype(T) || T.material?.icon_base != "hull")
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

/turf/simulated/wall/tgmc
	icon = 'icons/turf/wall_masks_tgmc.dmi'
	wall_masks = 'icons/turf/wall_masks_tgmc.dmi' // not really a MASK per-se, I guess
	icon_state = "metal0"

	var/list/blend_objects = list(/obj/machinery/door)
	var/list/noblend_objects = list(/obj/machinery/door/window, /obj/machinery/door/firedoor)

	var/wall_base_state = "metal"
	var/wall_blend_category = "metal"
	var/force_icon
	var/list/blend_log = list()
	var/strict_blending = FALSE
	var/diagonal_blending = FALSE

// *INHALE
/turf/simulated/wall/tgmc/update_icon()
	if(!damage_overlays[1]) //list hasn't been populated
		generate_overlays()

	cut_overlays()

	if(force_icon)
		icon_state = "[wall_base_state][force_icon]"
	else
		icon_state = "[wall_base_state][wall_connections]"

	if(damage != 0)
		var/integrity = material.integrity
		if(reinf_material)
			integrity += reinf_material.integrity

		var/overlay = round(damage / integrity * damage_overlays.len) + 1
		if(overlay > damage_overlays.len)
			overlay = damage_overlays.len

		add_overlay(damage_overlays[overlay])

/turf/simulated/wall/tgmc/update_connections(propagate)
	if(!material)
		return
	var/dirs = 0
	var/list_to_use = diagonal_blending ? alldirs : cardinal
	main_direction_loop:
		for(var/direction in list_to_use)
			var/turf/simulated/wall/tgmc/W = get_step(src, direction)
			if(strict_blending)
				if(istype(W, src))
					dirs |= direction
				continue main_direction_loop

			var/decided_to_blend = FALSE
			for(var/obj/O in W)
				for(var/b_type in blend_objects)
					if(istype(O, b_type))
						decided_to_blend = TRUE
						for(var/obj/structure/S in W)
							if(istype(S, src))
								decided_to_blend = FALSE
						for(var/nb_type in noblend_objects)
							if(istype(O, nb_type))
								decided_to_blend = FALSE

					if(decided_to_blend)
						blend_log += "Blending with [O] at [direction] because special said to"
						dirs |= direction
						continue main_direction_loop

			for(var/obj/structure/low_wall/WF in W)
				if(can_join_with_low_wall(WF))
					dirs |= direction
					blend_log += "Blending with [WF] at [get_dir(src, WF)] because can join with that low wall"
					continue main_direction_loop

			// Needs to be our type of wall to blend from this point
			if(!istype(W))
				continue
			if(propagate)
				W.update_connections()
				W.update_icon()
			if(W.wall_blend_category == wall_blend_category)
				dirs |= direction
				blend_log += "Blending with [W] at [get_dir(src, W)] because blend category is the same"

	wall_connections = dirs

/turf/simulated/wall/tgmc/can_join_with_low_wall(var/obj/structure/low_wall/WF)
	return istype(WF, /obj/structure/low_wall)

/turf/simulated/wall/tgmc/rwall
	icon_state = "rwall0"
	wall_base_state = "rwall"
	wall_blend_category = "rwall"
/turf/simulated/wall/tgmc/rwall/Initialize(mapload)
	. = ..(mapload, MAT_PLASTEEL,MAT_PLASTEEL)

/turf/simulated/wall/tgmc/gray
	icon_state = "gray0"
	wall_base_state = "gray"
	wall_blend_category = "gray"
/turf/simulated/wall/tgmc/gwall/Initialize(mapload)
	. = ..(mapload, MAT_PLASTEEL,MAT_PLASTEEL)

/turf/simulated/wall/tgmc/darkwall
	icon_state = "darkwall0"
	wall_base_state = "darkwall"
	wall_blend_category = "darkwall"
/turf/simulated/wall/tgmc/darkwall/Initialize(mapload)
	. = ..(mapload, MAT_PLASTEEL,MAT_PLASTEEL)
/turf/simulated/wall/tgmc/darkwall/deco0
	icon_state = "darkwall_deco0"
	force_icon = "_deco0"
/turf/simulated/wall/tgmc/darkwall/deco1
	icon_state = "darkwall_deco1"
	force_icon = "_deco1"
/turf/simulated/wall/tgmc/darkwall/deco2
	icon_state = "darkwall_deco2"
	force_icon = "_deco2"
/turf/simulated/wall/tgmc/darkwall/deco3
	icon_state = "darkwall_deco3"
	force_icon = "_deco3"

/turf/simulated/wall/tgmc/whitewall
	icon_state = "white0"
	wall_base_state = "white"
	wall_blend_category = "white"
/turf/simulated/wall/tgmc/whitewall/Initialize(mapload)
	. = ..(mapload, MAT_STEEL,MAT_PLASTIC)

/turf/simulated/wall/tgmc/durawall
	icon_state = "darkband0"
	wall_base_state = "darkband"
	wall_blend_category = "darkband"
/turf/simulated/wall/tgmc/durawall/Initialize(mapload)
	. = ..(mapload, MAT_DURASTEEL,MAT_DURASTEEL)
/turf/simulated/wall/tgmc/durawall/deco0
	icon_state = "darkband_deco0"
	force_icon = "_deco0"
/turf/simulated/wall/tgmc/durawall/deco1
	icon_state = "darkband_deco1"
	force_icon = "_deco1"
/turf/simulated/wall/tgmc/durawall/deco2
	icon_state = "darkband_deco2"
	force_icon = "_deco2"
/turf/simulated/wall/tgmc/durawall/deco3
	icon_state = "darkband_deco3"
	force_icon = "_deco3"

/turf/simulated/wall/tgmc/sanitary
	icon_state = "whiteband0"
	wall_base_state = "whiteband"
	wall_blend_category = "whiteband"
/turf/simulated/wall/tgmc/sanitary/Initialize(mapload)
	. = ..(mapload, MAT_PLASTEEL,MAT_PLASTEEL)

/turf/simulated/wall/tgmc/chigusa
	icon_state = "chigusa0"
	wall_base_state = "chigusa"
	wall_blend_category = "chigusa"
/turf/simulated/wall/tgmc/chigusa/Initialize(mapload)
	. = ..(mapload, MAT_CHITIN,MAT_CHITIN)
/turf/simulated/wall/tgmc/chigusa/deco0
	icon_state = "chigusa_deco0"
	force_icon = "_deco0"
/turf/simulated/wall/tgmc/chigusa/deco1
	icon_state = "chigusa_deco1"
	force_icon = "_deco1"
/turf/simulated/wall/tgmc/chigusa/deco2
	icon_state = "chigusa_deco2"
	force_icon = "_deco2"

/turf/simulated/wall/tgmc/redstripe
	icon_state = "redstripe0"
	wall_base_state = "redstripe"
	wall_blend_category = "redstripe"
/turf/simulated/wall/tgmc/redstripe/Initialize(mapload)
	. = ..(mapload, MAT_PLASTEELHULL,MAT_PLASTEELHULL)

/turf/simulated/wall/tgmc/redstripe_r
	icon_state = "redstriper0"
	wall_base_state = "redstriper"
	wall_blend_category = "redstriper"
/turf/simulated/wall/tgmc/redstripe_r/Initialize(mapload)
	. = ..(mapload, MAT_DURASTEELHULL,MAT_DURASTEELHULL)

/turf/simulated/wall/tgmc/plain_redstripe
	icon_state = "predstripe0"
	wall_base_state = "predstripe"
	wall_blend_category = "predstripe"
/turf/simulated/wall/tgmc/plain_redstripe/Initialize(mapload)
	. = ..(mapload, MAT_PLASTEEL,MAT_PLASTEEL)

/turf/simulated/wall/tgmc/plain_redstripe_r
	icon_state = "predstriper0"
	wall_base_state = "predstriper"
	wall_blend_category = "predstriper"
/turf/simulated/wall/tgmc/plain_redstripe_r/Initialize(mapload)
	. = ..(mapload, MAT_DURASTEEL,MAT_DURASTEEL)

#define WINDOW_GLASS 0x1
#define WINDOW_RGLASS 0x2
/turf/simulated/wall/tgmc/window
	icon = 'icons/turf/wall_masks_tgmc_win.dmi'
	wall_masks = 'icons/turf/wall_masks_tgmc_win.dmi' // not really a MASK per-se, I guess
	icon_state = "metal_window0"
	wall_base_state = "metal_window"
	wall_blend_category = "metal"

	opacity = 0
	var/window_types = WINDOW_GLASS
	strict_blending = TRUE
	diagonal_blending = TRUE

/turf/simulated/wall/tgmc/window/rwall
	icon_state = "rwall_window0"
	wall_base_state = "rwall_window"
	wall_blend_category = "rwall"
	window_types = WINDOW_RGLASS

/turf/simulated/wall/tgmc/window/rwall
	icon_state = "rwall_rwindow0"
	wall_base_state = "rwall_rwindow"
	wall_blend_category = "rwall"
	window_types = WINDOW_RGLASS

/turf/simulated/wall/tgmc/window/gray
	icon_state = "gray_window0"
	wall_base_state = "gray_window"
	wall_blend_category = "gray"
	window_types = WINDOW_GLASS|WINDOW_RGLASS

/turf/simulated/wall/tgmc/window/gray/reinf
	icon_state = "gray_rwindow0"
	wall_base_state = "gray_rwindow"

/turf/simulated/wall/tgmc/window/white
	icon_state = "white_window0"
	wall_base_state = "white_window"
	wall_blend_category = "white"
	window_types = WINDOW_GLASS|WINDOW_RGLASS
	diagonal_blending = FALSE

/turf/simulated/wall/tgmc/window/white/reinf
	icon_state = "white_rwindow0"
	wall_base_state = "white_rwindow"

/turf/simulated/wall/tgmc/window/chigusa
	icon_state = "chigusa_rwindow0"
	wall_base_state = "chigusa_rwindow"
	wall_blend_category = "chigusa"
	window_types = WINDOW_RGLASS
	diagonal_blending = FALSE

/turf/simulated/wall/tgmc/window/redstripe_r
	icon_state = "predstriper_window0"
	wall_base_state = "predstriper_window"
	wall_blend_category = "predstriper"
	window_types = WINDOW_GLASS|WINDOW_RGLASS

/turf/simulated/wall/tgmc/window/redstripe_r/reinf
	icon_state = "predstriper_rwindow0"
	wall_base_state = "predstriper_rwindow"
	wall_blend_category = "predstriper"

/turf/simulated/wall/tgmc/window/darkwall
	icon_state = "darkwall_window0"
	wall_base_state = "darkwall_window"
	wall_blend_category = "darkwall"
	window_types = WINDOW_GLASS|WINDOW_RGLASS
	diagonal_blending = FALSE

/turf/simulated/wall/tgmc/window/darkwall/reinf
	icon_state = "darkwall_rwindow0"
	wall_base_state = "darkwall_rwindow"

#undef WINDOW_GLASS
#undef WINDOW_RGLASS