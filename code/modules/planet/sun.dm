/datum/sun_holder
	var/atom/movable/sun_visuals/sun
	var/datum/planet/our_planet

	var/our_color = "#FFFFFF"
	var/our_brightness = 1.0

/datum/sun_holder/New(var/source)
	sun = new(null)
	our_planet = source

/datum/sun_holder/proc/update_color(new_color)
	// Doesn't save much work, but might save a smidge of client work
	if(our_color == new_color)
		return

	// Visible change
	our_color = new_color
	sun.set_color(new_color)

/datum/sun_holder/proc/update_brightness(new_brightness, list/turfs)
	// Doesn't save much work, but might save a smidge of client work
	if(our_brightness == new_brightness)
		return

	// Store the old for math
	. = our_brightness
	our_brightness = new_brightness

	// Visible change
	sun.set_alpha(round(CLAMP01(our_brightness)*255,1))

	// Update dynamic lumcount so darksight and stuff works
	var/difference = . - our_brightness
	for(var/turf/T as anything in turfs)
		T.dynamic_lumcount -= difference

/datum/sun_holder/proc/apply_to_turf(turf/T)
	if(sun in T.vis_contents)
		warning("Was asked to add fake sun to [T.x], [T.y], [T.z] despite already having us in it's vis contents")
		return
	sun.apply_to_turf(T)

/datum/sun_holder/proc/remove_from_turf(turf/T)
	if(!(sun in T.vis_contents))
		// warning("Was asked to remove fake sun from [T.x], [T.y], [T.z] despite it not having us in it's vis contents") // Disable the warning
		return
	sun.remove_from_turf(T)

/datum/sun_holder/proc/rainbow()
	var/end = world.time + 30 SECONDS

	var/col_index = 1

	var/list/colors = list("#ff5d5d","#ffd17b","#ffff5e","#7eff7e","#6868ff","#b753ff","#d08fff","#ffffff")
	var/original_brightness = sun.alpha/255
	var/original_color = sun.color

	update_brightness(0.8)

	while(world.time < end)
		update_color(colors[col_index])
		if(++col_index > colors.len)
			col_index = 1
		sleep(3)

	update_brightness(original_brightness)
	update_color(original_color)

// Holds a full white icon that can be mutated to make sun on the O_LIGHTING plane
/atom/movable/sun_visuals
	icon = 'icons/effects/effects.dmi'
	icon_state = "white"
	plane = PLANE_O_LIGHTING_VISUAL
	mouse_opacity = 0
	alpha = 0
	color = "#FFFFFF"

	var/turfs_providing_spreads = list()
	var/spreads = list()

/atom/movable/sun_visuals/Initialize(mapload)
	. = ..()
	spreads["1"] = new /atom/movable/sun_visuals_overlap(src, NORTH, "white_gradient")
	spreads["2"] = new /atom/movable/sun_visuals_overlap(src, SOUTH, "white_gradient")
	spreads["4"] = new /atom/movable/sun_visuals_overlap(src, EAST, "white_gradient")
	spreads["8"] = new /atom/movable/sun_visuals_overlap(src, WEST, "white_gradient")

	spreads["i5"] = new /atom/movable/sun_visuals_overlap(src, NORTHEAST, "white_inner")
	spreads["i6"] = new /atom/movable/sun_visuals_overlap(src, SOUTHEAST, "white_inner")
	spreads["i9"] = new /atom/movable/sun_visuals_overlap(src, NORTHWEST, "white_inner")
	spreads["i10"] = new /atom/movable/sun_visuals_overlap(src, SOUTHWEST, "white_inner")

	spreads["o5"] = new /atom/movable/sun_visuals_overlap(src, NORTHEAST, "white_outer")
	spreads["o6"] = new /atom/movable/sun_visuals_overlap(src, SOUTHEAST, "white_outer")
	spreads["o9"] = new /atom/movable/sun_visuals_overlap(src, NORTHWEST, "white_outer")
	spreads["o10"] = new /atom/movable/sun_visuals_overlap(src, SOUTHWEST, "white_outer")

/atom/movable/sun_visuals/proc/set_color(new_color)
	src.color = new_color
	for(var/key in spreads)
		var/atom/movable/sun_visuals_overlap/SVO = spreads[key]
		SVO.color = new_color

/atom/movable/sun_visuals/proc/set_alpha(new_alpha)
	src.alpha = new_alpha
	for(var/key in spreads)
		var/atom/movable/sun_visuals_overlap/SVO = spreads[key]
		SVO.alpha = new_alpha

/atom/movable/sun_visuals/proc/apply_to_turf(var/turf/T)
	T.vis_contents += src
	T.dynamic_lumcount += 0.5
	T.set_luminosity(1, TRUE)

	var/list/localspreads
	// Test for corners
	for(var/direction in cornerdirs)
		var/turf/dirturf = get_step(T, direction)
		if(dirturf && !dirturf.is_outdoors())
			var/turf/TL = get_step(T, turn(direction, -45))
			var/turf/TR = get_step(T, turn(direction, 45))

			// If outdoors at 45 degrees are the same, then this is a corner
			if(TL && TR && TL.is_outdoors() == TR.is_outdoors())
				var/atom/movable/sun_visuals_overlap/OL
				// Outer corner
				if(TL.is_outdoors())
					OL = spreads["o[direction]"]
				// Inner corner
				else
					OL = spreads["i[direction]"]
				dirturf.vis_contents += OL
				dirturf.set_luminosity(1)
				dirturf.outdoors_adjacent = TRUE
				LAZYINITLIST(localspreads)
				LAZYINITLIST(localspreads[dirturf])
				LAZYADD(localspreads[dirturf], OL)

	// Take all orthagonals
	for(var/direction in cardinal)
		var/turf/dirturf = get_step(T, direction)
		if(dirturf && !dirturf.is_outdoors())
			var/turf/TL = get_step(T, turn(direction, -45))
			var/turf/TR = get_step(T, turn(direction, 45))
			// End of a wall, the corner will handle it
			if(TL && TR && TL.is_outdoors() != TR.is_outdoors())
				continue
			var/atom/movable/sun_visuals_overlap/OL = spreads["[direction]"]
			dirturf.vis_contents += OL
			dirturf.set_luminosity(1)
			dirturf.outdoors_adjacent = TRUE
			LAZYINITLIST(localspreads)
			LAZYINITLIST(localspreads[dirturf])
			LAZYADD(localspreads[dirturf], OL)

	if(LAZYLEN(localspreads))
		turfs_providing_spreads[T] = localspreads

/atom/movable/sun_visuals/proc/remove_from_turf(var/turf/T)
	T.vis_contents -= src
	T.dynamic_lumcount -= 0.5
	T.set_luminosity(0, TRUE)
	var/list/applied = turfs_providing_spreads[T]
	if(LAZYLEN(applied))
		for(var/turf/old as anything in applied)
			old.vis_contents -= applied[old]
			var/old_lit = FALSE
			for(var/direction in alldirs)
				var/turf/CT = get_step(old, direction)
				if(CT && CT.is_outdoors())
					old_lit = TRUE
				if(!old_lit)
					old.outdoors_adjacent = TRUE
					old.set_luminosity(0)
			applied -= old
		turfs_providing_spreads -= T
		applied.Cut()

/atom/movable/sun_visuals_overlap
	icon = 'icons/effects/effects.dmi'
	icon_state = null
	plane = PLANE_O_LIGHTING_VISUAL
	mouse_opacity = 0
	alpha = 0
	color = "#FFFFFF"

/atom/movable/sun_visuals_overlap/Initialize(mapload, newdir, newstate)
	. = ..()
	icon_state = newstate
	dir = newdir
