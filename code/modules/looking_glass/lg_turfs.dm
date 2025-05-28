/decl/flooring/looking_glass
	name = "looking glass surface"
	desc = "Too expensive to replace. Don't break it!"
	icon = 'icons/turf/flooring/lg_origin.dmi'
	icon_base = "origin"
	build_type = null
	damage_temperature = T0C+200


/turf/simulated/floor/looking_glass
	name = "looking glass surface"
	icon = 'icons/turf/flooring/lg_origin.dmi'
	icon_state = "origin_arrow"
	initial_flooring = /decl/flooring/looking_glass
	appearance_flags = TILE_BOUND
	dynamic_lighting = FALSE
	flags = TURF_ACID_IMMUNE

	var/center = FALSE
	var/optional = FALSE

/turf/simulated/floor/looking_glass/center
	center = TRUE
	icon_state = "origin_center"

/turf/simulated/floor/looking_glass/optional
	center = TRUE
	optional = TRUE
	icon_state = "origin_optional_arrow"

/turf/simulated/floor/looking_glass/proc/activate()
	set waitfor = FALSE

	icon_state = "origin_switching"

	animate(src, color = "#000000", time = 3 SECONDS)

	sleep(3 SECONDS)

	var/new_x = 0
	var/new_y = 0

	if(dir & NORTH)
		new_y = 112
	else if(dir & SOUTH)
		new_y = -112

	if(dir & EAST)
		new_x = 112
	else if(dir & WEST)
		new_x = -112

	var/matrix/M = matrix()
	var/mutable_appearance/MA = new (src)

	if(!center)
		var/horizontal = (dir & (WEST|EAST))
		var/vertical = (dir & (NORTH|SOUTH))
		M.Scale(horizontal ? 8 : 1, vertical ? 8 : 1)
		M.Translate(new_x, new_y)
		MA.opacity = 1
		if(!optional)
			MA.density = TRUE

	MA.icon_state = "origin_active"
	MA.plane = PLANE_LOOKINGGLASS
	MA.layer = 0
	appearance = MA

	animate(src, color = "#FFFFFF", transform = M, time = 3 SECONDS)

/turf/simulated/floor/looking_glass/proc/deactivate()
	set waitfor = FALSE

	animate(src, color = "#000000", transform = matrix(), time = 3 SECONDS)

	sleep(3 SECONDS)
	var/mutable_appearance/MA = new (src)
	MA.opacity = 0
	MA.density = FALSE
	MA.icon_state = "origin_switching"
	MA.plane = initial(plane)
	MA.layer = initial(layer)
	appearance = MA

	animate(src, color = null, time = 3 SECONDS)
	sleep(3 SECONDS)
	icon_state = "origin"
