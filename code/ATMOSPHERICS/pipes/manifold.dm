//
// Manifold Pipes - Three way "T" joints
//
/obj/machinery/atmospherics/pipe/manifold
	icon = 'icons/atmos/manifold.dmi'
	icon_state = ""
	name = "pipe manifold"
	desc = "A manifold composed of regular pipes"

	volume = ATMOS_DEFAULT_VOLUME_PIPE * 1.5

	dir = SOUTH
	initialize_directions = EAST|NORTH|WEST

	construction_type = /obj/item/pipe/trinary
	pipe_state = "manifold"

	var/obj/machinery/atmospherics/node3

	level = 1

/obj/machinery/atmospherics/pipe/manifold/Initialize(mapload)
	. = ..()
	alpha = 255
	icon = null

/obj/machinery/atmospherics/pipe/manifold/init_dir()
	switch(dir)
		if(NORTH)
			initialize_directions = EAST|SOUTH|WEST
		if(SOUTH)
			initialize_directions = WEST|NORTH|EAST
		if(EAST)
			initialize_directions = SOUTH|WEST|NORTH
		if(WEST)
			initialize_directions = NORTH|EAST|SOUTH

/obj/machinery/atmospherics/pipe/manifold/pipeline_expansion()
	return list(node1, node2, node3)

/obj/machinery/atmospherics/pipe/manifold/Destroy()
	if(node1)
		node1.disconnect(src)
		node1 = null
	if(node2)
		node2.disconnect(src)
		node2 = null
	if(node3)
		node3.disconnect(src)
		node3 = null

	. = ..()

/obj/machinery/atmospherics/pipe/manifold/disconnect(obj/machinery/atmospherics/reference)
	if(reference == node1)
		if(istype(node1, /obj/machinery/atmospherics/pipe))
			qdel(parent)
		node1 = null

	if(reference == node2)
		if(istype(node2, /obj/machinery/atmospherics/pipe))
			qdel(parent)
		node2 = null

	if(reference == node3)
		if(istype(node3, /obj/machinery/atmospherics/pipe))
			qdel(parent)
		node3 = null

	update_icon()
	handle_leaking()

	..()

/obj/machinery/atmospherics/pipe/manifold/handle_leaking()
	if(node1 && node2 && node3)
		set_leaking(FALSE)
	else
		set_leaking(TRUE)

/obj/machinery/atmospherics/pipe/manifold/process()
	if(!parent)
		..()
	else if(leaking)
		parent.mingle_with_turf(loc, volume)
	else
		. = PROCESS_KILL

/obj/machinery/atmospherics/pipe/manifold/change_color(var/new_color)
	..()
	//for updating connected atmos device pipes (i.e. vents, manifolds, etc)
	if(node1)
		node1.update_underlays()
	if(node2)
		node2.update_underlays()
	if(node3)
		node3.update_underlays()

/obj/machinery/atmospherics/pipe/manifold/update_icon(var/safety = 0)
	if(!check_icon_cache())
		return

	alpha = 255

	cut_overlays()
	add_overlay(icon_manager.get_atmos_icon("manifold", , pipe_color, "core" + icon_connect_type))
	add_overlay(icon_manager.get_atmos_icon("manifold", , , "clamps" + icon_connect_type))
	underlays.Cut()

	var/turf/T = get_turf(src)

	// Unfortunately our nodes are not in consistent directions (see atmos_init()) so do the dance...
	var/list/directions = list(NORTH, SOUTH, EAST, WEST) // UN-connected directions
	directions -= dir
	if(node1)
		var/node1_direction = get_dir(src, node1)
		add_underlay(T, node1, node1_direction, icon_connect_type)
		directions -= node1_direction
	if(node2)
		var/node2_direction = get_dir(src, node2)
		add_underlay(T, node2, node2_direction, icon_connect_type)
		directions -= node2_direction
	if(node3)
		var/node3_direction = get_dir(src, node3)
		add_underlay(T, node3, node3_direction, icon_connect_type)
		directions -= node3_direction


	for(var/D in directions)
		add_underlay(T,,D,icon_connect_type)


/obj/machinery/atmospherics/pipe/manifold/update_underlays()
	..()
	update_icon()

/obj/machinery/atmospherics/pipe/manifold/atmos_init()
	var/connect_directions = (NORTH|SOUTH|EAST|WEST)&(~dir)

	for(var/direction in cardinal)
		if(direction&connect_directions)
			for(var/obj/machinery/atmospherics/target in get_step(src,direction))
				if (can_be_node(target, 1))
					node1 = target
					connect_directions &= ~direction
					break
			if (node1)
				break


	for(var/direction in cardinal)
		if(direction&connect_directions)
			for(var/obj/machinery/atmospherics/target in get_step(src,direction))
				if (can_be_node(target, 2))
					node2 = target
					connect_directions &= ~direction
					break
			if (node2)
				break


	for(var/direction in cardinal)
		if(direction&connect_directions)
			for(var/obj/machinery/atmospherics/target in get_step(src,direction))
				if (can_be_node(target, 3))
					node3 = target
					connect_directions &= ~direction
					break
			if (node3)
				break

	if(!node1 && !node2 && !node3)
		qdel(src)
		return

	var/turf/T = get_turf(src)
	if(level == 1 && !T.is_plating()) hide(1)
	update_icon()
	handle_leaking()

/obj/machinery/atmospherics/pipe/manifold/visible
	icon_state = "map"
	level = 2

/obj/machinery/atmospherics/pipe/manifold/visible/scrubbers
	name="Scrubbers pipe manifold"
	desc = "A manifold composed of scrubbers pipes"
	icon_state = "map-scrubbers"
	connect_types = CONNECT_TYPE_SCRUBBER
	piping_layer = PIPING_LAYER_SCRUBBER
	layer = PIPES_SCRUBBER_LAYER
	icon_connect_type = "-scrubbers"
	color = PIPE_COLOR_RED

/obj/machinery/atmospherics/pipe/manifold/visible/supply
	name="Air supply pipe manifold"
	desc = "A manifold composed of supply pipes"
	icon_state = "map-supply"
	connect_types = CONNECT_TYPE_SUPPLY
	piping_layer = PIPING_LAYER_SUPPLY
	layer = PIPES_SUPPLY_LAYER
	icon_connect_type = "-supply"
	color = PIPE_COLOR_BLUE

/obj/machinery/atmospherics/pipe/manifold/visible/fuel
	name="Fuel pipe manifold"
	desc = "A manifold composed of fuel pipes"
	icon_state = "map-fuel"
	connect_types = CONNECT_TYPE_FUEL
	piping_layer = PIPING_LAYER_FUEL
	layer = PIPES_FUEL_LAYER
	icon_connect_type = "-fuel"
	color = PIPE_COLOR_YELLOW

/obj/machinery/atmospherics/pipe/manifold/visible/aux
	name="Aux pipe manifold"
	desc = "A manifold composed of aux pipes"
	icon_state = "map-aux"
	connect_types = CONNECT_TYPE_AUX
	piping_layer = PIPING_LAYER_AUX
	layer = PIPES_AUX_LAYER
	icon_connect_type = "-aux"
	color = PIPE_COLOR_CYAN

/obj/machinery/atmospherics/pipe/manifold/visible/yellow
	color = PIPE_COLOR_YELLOW

/obj/machinery/atmospherics/pipe/manifold/visible/cyan
	color = PIPE_COLOR_CYAN

/obj/machinery/atmospherics/pipe/manifold/visible/green
	color = PIPE_COLOR_GREEN

/obj/machinery/atmospherics/pipe/manifold/visible/black
	color = PIPE_COLOR_BLACK

/obj/machinery/atmospherics/pipe/manifold/visible/red
	color = PIPE_COLOR_RED

/obj/machinery/atmospherics/pipe/manifold/visible/blue
	color = PIPE_COLOR_BLUE

/obj/machinery/atmospherics/pipe/manifold/visible/purple
	color = PIPE_COLOR_PURPLE

/obj/machinery/atmospherics/pipe/manifold/hidden
	icon_state = "map"
	level = 1
	alpha = 128		//set for the benefit of mapping - this is reset to opaque when the pipe is spawned in game

/obj/machinery/atmospherics/pipe/manifold/hidden/scrubbers
	name="Scrubbers pipe manifold"
	desc = "A manifold composed of scrubbers pipes"
	icon_state = "map-scrubbers"
	connect_types = CONNECT_TYPE_SCRUBBER
	piping_layer = PIPING_LAYER_SCRUBBER
	layer = PIPES_SCRUBBER_LAYER
	icon_connect_type = "-scrubbers"
	color = PIPE_COLOR_RED

/obj/machinery/atmospherics/pipe/manifold/hidden/supply
	name="Air supply pipe manifold"
	desc = "A manifold composed of supply pipes"
	icon_state = "map-supply"
	connect_types = CONNECT_TYPE_SUPPLY
	piping_layer = PIPING_LAYER_SUPPLY
	layer = PIPES_SUPPLY_LAYER
	icon_connect_type = "-supply"
	color = PIPE_COLOR_BLUE

/obj/machinery/atmospherics/pipe/manifold/hidden/fuel
	name="Fuel pipe manifold"
	desc = "A manifold composed of fuel pipes"
	icon_state = "map-fuel"
	connect_types = CONNECT_TYPE_FUEL
	piping_layer = PIPING_LAYER_FUEL
	layer = PIPES_FUEL_LAYER
	icon_connect_type = "-fuel"
	color = PIPE_COLOR_YELLOW

/obj/machinery/atmospherics/pipe/manifold/hidden/aux
	name="Aux pipe manifold"
	desc = "A manifold composed of aux pipes"
	icon_state = "map-aux"
	connect_types = CONNECT_TYPE_AUX
	piping_layer = PIPING_LAYER_AUX
	layer = PIPES_AUX_LAYER
	icon_connect_type = "-aux"
	color = PIPE_COLOR_CYAN

/obj/machinery/atmospherics/pipe/manifold/hidden/yellow
	color = PIPE_COLOR_YELLOW

/obj/machinery/atmospherics/pipe/manifold/hidden/cyan
	color = PIPE_COLOR_CYAN

/obj/machinery/atmospherics/pipe/manifold/hidden/green
	color = PIPE_COLOR_GREEN

/obj/machinery/atmospherics/pipe/manifold/hidden/black
	color = PIPE_COLOR_BLACK

/obj/machinery/atmospherics/pipe/manifold/hidden/red
	color = PIPE_COLOR_RED

/obj/machinery/atmospherics/pipe/manifold/hidden/blue
	color = PIPE_COLOR_BLUE

/obj/machinery/atmospherics/pipe/manifold/hidden/purple
	color = PIPE_COLOR_PURPLE
