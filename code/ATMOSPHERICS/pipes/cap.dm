//
// Pipe Cap - They go on the end
//
/obj/machinery/atmospherics/pipe/cap
	name = "pipe endcap"
	desc = "An endcap for pipes"
	icon = 'icons/atmos/pipes.dmi'
	icon_state = ""
	level = 2

	volume = 35

	dir = SOUTH
	initialize_directions = SOUTH

	construction_type = /obj/item/pipe/directional
	pipe_state = "cap"

	var/obj/machinery/atmospherics/node

/obj/machinery/atmospherics/pipe/cap/init_dir()
	initialize_directions = dir

/obj/machinery/atmospherics/pipe/cap/pipeline_expansion()
	return list(node)

/obj/machinery/atmospherics/pipe/cap/Destroy()
	if(node)
		node.disconnect(src)
		node = null

	. = ..()

/obj/machinery/atmospherics/pipe/cap/disconnect(obj/machinery/atmospherics/reference)
	if(reference == node)
		if(istype(node, /obj/machinery/atmospherics/pipe))
			qdel(parent)
		node = null

	update_icon()

	..()

/obj/machinery/atmospherics/pipe/cap/change_color(var/new_color)
	..()
	//for updating connected atmos device pipes (i.e. vents, manifolds, etc)
	if(node)
		node.update_underlays()

/obj/machinery/atmospherics/pipe/cap/update_icon(var/safety = 0)
	if(!check_icon_cache())
		return

	alpha = 255

	overlays.Cut()
	overlays += icon_manager.get_atmos_icon("pipe", , pipe_color, "cap[icon_connect_type]")

/obj/machinery/atmospherics/pipe/cap/atmos_init()
	for(var/obj/machinery/atmospherics/target in get_step(src, dir))
		if (can_be_node(target, 1))
			node = target
			break

	var/turf/T = src.loc			// hide if turf is not intact
	if(level == 1 && !T.is_plating()) hide(1)
	update_icon()

/obj/machinery/atmospherics/pipe/cap/can_unwrench()
	return 1

/obj/machinery/atmospherics/pipe/cap/visible
	level = 2
	icon_state = "cap"

/obj/machinery/atmospherics/pipe/cap/visible/scrubbers
	name = "scrubbers pipe endcap"
	desc = "An endcap for scrubbers pipes"
	icon_state = "cap-scrubbers"
	connect_types = CONNECT_TYPE_SCRUBBER
	piping_layer = PIPING_LAYER_SCRUBBER
	layer = PIPES_SCRUBBER_LAYER
	icon_connect_type = "-scrubbers"
	color = PIPE_COLOR_RED

/obj/machinery/atmospherics/pipe/cap/visible/supply
	name = "supply pipe endcap"
	desc = "An endcap for supply pipes"
	icon_state = "cap-supply"
	connect_types = CONNECT_TYPE_SUPPLY
	piping_layer = PIPING_LAYER_SUPPLY
	layer = PIPES_SUPPLY_LAYER
	icon_connect_type = "-supply"
	color = PIPE_COLOR_BLUE

/obj/machinery/atmospherics/pipe/cap/hidden
	level = 1
	icon_state = "cap"
	alpha = 128

/obj/machinery/atmospherics/pipe/cap/hidden/scrubbers
	name = "scrubbers pipe endcap"
	desc = "An endcap for scrubbers pipes"
	icon_state = "cap-f-scrubbers"
	connect_types = CONNECT_TYPE_SCRUBBER
	piping_layer = PIPING_LAYER_SCRUBBER
	layer = PIPES_SCRUBBER_LAYER
	icon_connect_type = "-scrubbers"
	color = PIPE_COLOR_RED

/obj/machinery/atmospherics/pipe/cap/hidden/supply
	name = "supply pipe endcap"
	desc = "An endcap for supply pipes"
	icon_state = "cap-f-supply"
	connect_types = CONNECT_TYPE_SUPPLY
	piping_layer = PIPING_LAYER_SUPPLY
	layer = PIPES_SUPPLY_LAYER
	icon_connect_type = "-supply"
	color = PIPE_COLOR_BLUE
