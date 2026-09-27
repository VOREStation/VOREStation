#define LIST_NODE1 1
#define LIST_NODE2 2

#define REBUILD_UNIVERSAL_NODE_LIST if(!length(universal_nodes)) {universal_nodes = new/list(PIPING_LAYER_AUX);universal_nodes[PIPING_LAYER_SUPPLY] = list(null, null);universal_nodes[PIPING_LAYER_REGULAR] = list(null, null);universal_nodes[PIPING_LAYER_SCRUBBER] = list(null, null);universal_nodes[PIPING_LAYER_FUEL] = list(null, null);universal_nodes[PIPING_LAYER_AUX] = list(null, null);};

//
// Universal Pipe Adapter - Designed for connecting scrubbers, normal, and supply pipes together.
// Visible varient
//
/obj/machinery/atmospherics/pipe/simple/visible/universal
	name="Universal pipe adapter"
	desc = "An adapter for regular, supply and scrubbers pipes"
	connect_types = CONNECT_TYPE_REGULAR|CONNECT_TYPE_SUPPLY|CONNECT_TYPE_SCRUBBER|CONNECT_TYPE_FUEL|CONNECT_TYPE_AUX
	icon_state = "map_universal"
	pipe_flags = PIPING_ALL_LAYER|PIPING_CARDINAL_AUTONORMALIZE
	construction_type = /obj/item/pipe/binary
	pipe_state = "universal"
	var/list/universal_nodes

/obj/machinery/atmospherics/pipe/simple/visible/universal/Destroy()
	. = ..()
	universal_destroy(universal_nodes)

/obj/machinery/atmospherics/pipe/simple/visible/universal/atmos_init()
	REBUILD_UNIVERSAL_NODE_LIST
	universal_atmos_init(universal_nodes)

/obj/machinery/atmospherics/pipe/simple/visible/universal/disconnect(obj/machinery/atmospherics/reference)
	universal_disconnect(universal_nodes, reference)

/obj/machinery/atmospherics/pipe/simple/visible/universal/pipeline_expansion()
	REBUILD_UNIVERSAL_NODE_LIST
	var/list/all_nodes = list()
	for(var/list/sublist in universal_nodes)
		all_nodes += sublist
	return all_nodes

/obj/machinery/atmospherics/pipe/simple/visible/universal/get_neighbor_nodes_for_init()
	return pipeline_expansion()

/obj/machinery/atmospherics/pipe/simple/visible/universal/update_icon(safety = 0)
	universal_node_update_icon(universal_nodes)

/obj/machinery/atmospherics/pipe/simple/visible/universal/update_underlays()
	..()
	update_icon()

/obj/machinery/atmospherics/pipe/simple/visible/universal/relaymove(mob/living/user, direction)
	if(initialize_directions & direction)
		return ..()
	if((NORTH|EAST) & direction)
		user.change_ventcrawl_layer(user.ventcrawl_layer + 1)
	if((SOUTH|WEST) & direction)
		user.change_ventcrawl_layer(user.ventcrawl_layer - 1)
	user.setMoveCooldown(0.25 SECONDS) // So this doesn't instantly slam through all of them

//
// Universal Pipe Adapter - Designed for connecting scrubbers, normal, and supply pipes together.
// Hidden varient
//
/obj/machinery/atmospherics/pipe/simple/hidden/universal
	name="Universal pipe adapter"
	desc = "An adapter for regular, supply and scrubbers pipes"
	connect_types = CONNECT_TYPE_REGULAR|CONNECT_TYPE_SUPPLY|CONNECT_TYPE_SCRUBBER|CONNECT_TYPE_FUEL|CONNECT_TYPE_AUX
	icon_state = "map_universal"
	pipe_flags = PIPING_ALL_LAYER|PIPING_CARDINAL_AUTONORMALIZE
	construction_type = /obj/item/pipe/binary
	pipe_state = "universal"
	var/list/universal_nodes

/obj/machinery/atmospherics/pipe/simple/hidden/universal/Destroy()
	. = ..()
	universal_destroy(universal_nodes)

/obj/machinery/atmospherics/pipe/simple/hidden/universal/atmos_init()
	REBUILD_UNIVERSAL_NODE_LIST
	universal_atmos_init(universal_nodes)

/obj/machinery/atmospherics/pipe/simple/hidden/universal/disconnect(obj/machinery/atmospherics/reference)
	universal_disconnect(universal_nodes, reference)

/obj/machinery/atmospherics/pipe/simple/hidden/universal/pipeline_expansion()
	REBUILD_UNIVERSAL_NODE_LIST
	var/list/all_nodes = list()
	for(var/list/sublist in universal_nodes)
		all_nodes += sublist
	return all_nodes

/obj/machinery/atmospherics/pipe/simple/hidden/universal/get_neighbor_nodes_for_init()
	return pipeline_expansion()

/obj/machinery/atmospherics/pipe/simple/hidden/universal/update_icon(safety = 0)	// Doesn't leak. It's a special pipe.
	universal_node_update_icon(universal_nodes)

/obj/machinery/atmospherics/pipe/simple/hidden/universal/update_underlays()
	..()
	update_icon()

/obj/machinery/atmospherics/pipe/simple/hidden/universal/relaymove(mob/living/user, direction)
	if(initialize_directions & direction)
		return ..()
	if((NORTH|EAST) & direction)
		user.change_ventcrawl_layer(user.ventcrawl_layer + 1)
	if((SOUTH|WEST) & direction)
		user.change_ventcrawl_layer(user.ventcrawl_layer - 1)
	user.setMoveCooldown(0.25 SECONDS) // So this doesn't instantly slam through all of them

/////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Shared universal pipe adaptor procs
//
// TODO : universal should be unified into it's own subtype and changed on all maps with hidden and visible subtypes... this is awful
/////////////////////////////////////////////////////////////////////////////////////////////////////////////
/obj/machinery/atmospherics/pipe/simple/proc/universal_atmos_init(list/universal_nodes)
	normalize_dir()
	var/node1_dir
	var/node2_dir

	for(var/direction in GLOB.cardinal)
		if(direction&initialize_directions)
			if (!node1_dir)
				node1_dir = direction
			else if (!node2_dir)
				node2_dir = direction

	var/has_any_nodes = FALSE
	var/node_index = 0
	for(var/list/node_layer in universal_nodes)
		node_index++ // So we can tell what layer we are on
		// Each node layer expects the target to be on the same layer!
		for(var/obj/machinery/atmospherics/target in get_prioritized_nodes(get_step(src,node1_dir)))
			if(target.piping_layer == node_index && can_be_node(target, 1))
				node_layer[LIST_NODE1] = target
				has_any_nodes = TRUE
				break
		for(var/obj/machinery/atmospherics/target in get_prioritized_nodes(get_step(src,node2_dir)))
			if(target.piping_layer == node_index && can_be_node(target, 2))
				node_layer[LIST_NODE2] = target
				has_any_nodes = TRUE
				break
	if(!has_any_nodes)
		qdel(src)
		return

	var/turf/T = loc
	if(level == 1 && !T.is_plating())
		hide(1)
	update_icon()

/obj/machinery/atmospherics/pipe/simple/proc/universal_destroy(list/universal_nodes)
	if(!universal_nodes)
		return
	for(var/list/sublist in universal_nodes)
		var/obj/machinery/atmospherics/nodeone = sublist[LIST_NODE1]
		var/obj/machinery/atmospherics/nodetwo = sublist[LIST_NODE2]
		nodeone?.disconnect(src)
		nodetwo?.disconnect(src)
		sublist.Cut()
	universal_nodes.Cut()
	universal_nodes = null

/obj/machinery/atmospherics/pipe/simple/proc/universal_disconnect(list/universal_nodes, obj/machinery/atmospherics/reference)
	if(!universal_nodes)
		return
	for(var/list/node_layer in universal_nodes)
		var/obj/machinery/atmospherics/node_one = node_layer[LIST_NODE1]
		var/obj/machinery/atmospherics/node_two = node_layer[LIST_NODE2]

		if(reference == node_one)
			node_one.disconnect(src)
			node_layer[LIST_NODE1] = null

		if(reference == node_two)
			node_two.disconnect(src)
			node_layer[LIST_NODE2] = null

	update_icon()
	return null

/obj/machinery/atmospherics/pipe/simple/proc/universal_node_update_icon(list/universal_nodes)
	alpha = 255

	cut_overlays()
	add_overlay(GLOB.icon_manager.get_atmos_icon("pipe", , pipe_color, "universal"))
	underlays.Cut()

	var/layer_index = 0
	for(var/list/node_layer in universal_nodes)
		layer_index++
		var/obj/machinery/atmospherics/node_one = node_layer[LIST_NODE1]
		var/obj/machinery/atmospherics/node_two = node_layer[LIST_NODE2]

		if (node_one)
			universal_underlays(node_one, null, layer_index)
			if(node_two)
				universal_underlays(node_two, null, layer_index)
			else
				var/node1_dir = get_dir(node_one,src)
				universal_underlays(null, node1_dir, layer_index)
		else if (node_two)
			universal_underlays(node_two, null, layer_index)
		else
			universal_underlays(null, dir, layer_index)
			universal_underlays(null, turn(dir, -180), layer_index)

/obj/machinery/atmospherics/pipe/simple/proc/universal_underlays(obj/machinery/atmospherics/node, direction, layer_index)
	var/turf/T = loc
	if(node)
		direction = get_dir(src,node)
	switch(layer_index)
		if(PIPING_LAYER_SUPPLY)
			add_underlay_adapter(T, node, direction, "-supply")
		if (PIPING_LAYER_SCRUBBER)
			add_underlay_adapter(T, node, direction, "-scrubbers")
		if (PIPING_LAYER_FUEL)
			add_underlay_adapter(T, node, direction, "-fuel")
		if (PIPING_LAYER_AUX)
			add_underlay_adapter(T, node, direction, "-aux")
		else
			add_underlay_adapter(T, node, direction, "")

/obj/machinery/atmospherics/pipe/simple/proc/add_underlay_adapter(turf/T, obj/machinery/atmospherics/node, direction, icon_connect_type) //modified from add_underlay, does not make exposed underlays
	if(node)
		if(!T.is_plating() && node.level == 1 && istype(node, /obj/machinery/atmospherics/pipe))
			underlays += GLOB.icon_manager.get_atmos_icon("underlay", direction, color_cache_name(node), "down" + icon_connect_type)
		else
			underlays += GLOB.icon_manager.get_atmos_icon("underlay", direction, color_cache_name(node), "intact" + icon_connect_type)
	else
		underlays += GLOB.icon_manager.get_atmos_icon("underlay", direction, color_cache_name(node), "retracted" + icon_connect_type)

#undef REBUILD_UNIVERSAL_NODE_LIST

#undef LIST_NODE1
#undef LIST_NODE2
