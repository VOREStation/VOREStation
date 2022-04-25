//
// Universal Pipe Adapter - Designed for connecting scrubbers, normal, and supply pipes together.
//
/obj/machinery/atmospherics/pipe/simple/visible/universal
	name="Universal pipe adapter"
	desc = "An adapter for regular, supply and scrubbers pipes"
	connect_types = CONNECT_TYPE_REGULAR|CONNECT_TYPE_SUPPLY|CONNECT_TYPE_SCRUBBER|CONNECT_TYPE_FUEL|CONNECT_TYPE_AUX
	icon_state = "map_universal"
	pipe_flags = PIPING_ALL_LAYER|PIPING_CARDINAL_AUTONORMALIZE
	construction_type = /obj/item/pipe/binary
	pipe_state = "universal"

/obj/machinery/atmospherics/pipe/simple/visible/universal/update_icon(var/safety = 0)
	if(!check_icon_cache())
		return

	alpha = 255

	cut_overlays()
	add_overlay(icon_manager.get_atmos_icon("pipe", , pipe_color, "universal"))
	underlays.Cut()

	if (node1)
		universal_underlays(node1)
		if(node2)
			universal_underlays(node2)
		else
			var/node1_dir = get_dir(node1,src)
			universal_underlays(,node1_dir)
	else if (node2)
		universal_underlays(node2)
	else
		universal_underlays(,dir)
		universal_underlays(,turn(dir, -180))

/obj/machinery/atmospherics/pipe/simple/visible/universal/update_underlays()
	..()
	update_icon()



/obj/machinery/atmospherics/pipe/simple/hidden/universal
	name="Universal pipe adapter"
	desc = "An adapter for regular, supply and scrubbers pipes"
	connect_types = CONNECT_TYPE_REGULAR|CONNECT_TYPE_SUPPLY|CONNECT_TYPE_SCRUBBER|CONNECT_TYPE_FUEL|CONNECT_TYPE_AUX
	icon_state = "map_universal"
	pipe_flags = PIPING_ALL_LAYER|PIPING_CARDINAL_AUTONORMALIZE
	construction_type = /obj/item/pipe/binary
	pipe_state = "universal"

/obj/machinery/atmospherics/pipe/simple/hidden/universal/update_icon(var/safety = 0)	// Doesn't leak. It's a special pipe.
	if(!check_icon_cache())
		return

	alpha = 255

	cut_overlays()
<<<<<<< HEAD
	add_overlay(icon_manager.get_atmos_icon("pipe", , pipe_color, "universal"))
=======
	var/icon/add = icon_manager.get_atmos_icon("pipe", , pipe_color, "universal")
	add_overlay(add)

>>>>>>> 2a494dcb666... Merge pull request #8530 from Spookerton/cerebulon/ssoverlay
	underlays.Cut()

	if (node1)
		universal_underlays(node1)
		if(node2)
			universal_underlays(node2)
		else
			var/node2_dir = turn(get_dir(src,node1),-180)
			universal_underlays(,node2_dir)
	else if (node2)
		universal_underlays(node2)
		var/node1_dir = turn(get_dir(src,node2),-180)
		universal_underlays(,node1_dir)
	else
		universal_underlays(,dir)
		universal_underlays(,turn(dir, -180))

/obj/machinery/atmospherics/pipe/simple/hidden/universal/update_underlays()
	..()
	update_icon()

/obj/machinery/atmospherics/proc/universal_underlays(var/obj/machinery/atmospherics/node, var/direction)
	var/turf/T = loc
	if(node)
		var/node_dir = get_dir(src,node)
		switch(node.icon_connect_type)
			if("-supply")
				add_underlay_adapter(T, , node_dir, "")
				add_underlay_adapter(T, node, node_dir, "-supply")
				add_underlay_adapter(T, , node_dir, "-scrubbers")
				add_underlay_adapter(T, , node_dir, "-fuel")
				add_underlay_adapter(T, , node_dir, "-aux")
			if ("-scrubbers")
				add_underlay_adapter(T, , node_dir, "")
				add_underlay_adapter(T, , node_dir, "-supply")
				add_underlay_adapter(T, node, node_dir, "-scrubbers")
				add_underlay_adapter(T, , node_dir, "-fuel")
				add_underlay_adapter(T, , node_dir, "-aux")
			if ("-fuel")
				add_underlay_adapter(T, , node_dir, "")
				add_underlay_adapter(T, , node_dir, "-supply")
				add_underlay_adapter(T, , node_dir, "-scrubbers")
				add_underlay_adapter(T, node, node_dir, "-fuel")
				add_underlay_adapter(T, , node_dir, "-aux")
			if ("-aux")
				add_underlay_adapter(T, , node_dir, "")
				add_underlay_adapter(T, , node_dir, "-supply")
				add_underlay_adapter(T, , node_dir, "-scrubbers")
				add_underlay_adapter(T, , node_dir, "-fuel")
				add_underlay_adapter(T, node, node_dir, "-aux")
			else
				add_underlay_adapter(T, node, node_dir, "")
				add_underlay_adapter(T, , node_dir, "-supply")
				add_underlay_adapter(T, , node_dir, "-scrubbers")
				add_underlay_adapter(T, , node_dir, "-fuel")
				add_underlay_adapter(T, , node_dir, "-aux")
	else
		add_underlay_adapter(T, , direction, "-supply")
		add_underlay_adapter(T, , direction, "-scrubbers")
		add_underlay_adapter(T, , direction, "-fuel")
		add_underlay_adapter(T, , direction, "-aux")
		add_underlay_adapter(T, , direction, "")

/obj/machinery/atmospherics/proc/add_underlay_adapter(var/turf/T, var/obj/machinery/atmospherics/node, var/direction, var/icon_connect_type) //modified from add_underlay, does not make exposed underlays
	if(node)
		if(!T.is_plating() && node.level == 1 && istype(node, /obj/machinery/atmospherics/pipe))
			underlays += icon_manager.get_atmos_icon("underlay", direction, color_cache_name(node), "down" + icon_connect_type)
		else
			underlays += icon_manager.get_atmos_icon("underlay", direction, color_cache_name(node), "intact" + icon_connect_type)
	else
		underlays += icon_manager.get_atmos_icon("underlay", direction, color_cache_name(node), "retracted" + icon_connect_type)
