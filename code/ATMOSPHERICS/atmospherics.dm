/*
Quick overview:

Pipes combine to form pipelines
Pipelines and other atmospheric objects combine to form pipe_networks
	Note: A single pipe_network represents a completely open space

Pipes -> Pipelines
Pipelines + Other Objects -> Pipe network

*/
/obj/machinery/atmospherics
	anchored = TRUE
	idle_power_usage = 0
	active_power_usage = 0
	power_channel = ENVIRON
	var/nodealert = 0
	var/power_rating //the maximum amount of power the machine can use to do work, affects how powerful the machine is, in Watts
	
	unacidable = TRUE
	layer = ATMOS_LAYER
	plane = PLATING_PLANE

	var/pipe_flags = PIPING_DEFAULT_LAYER_ONLY // Allow other layers by exception basis.
	var/connect_types = CONNECT_TYPE_REGULAR
	var/piping_layer = PIPING_LAYER_DEFAULT // This will replace icon_connect_type at some point ~Leshana
	var/icon_connect_type = "" //"-supply" or "-scrubbers"
	var/construction_type = null // Type path of the pipe item when this is deconstructed.
	var/pipe_state // icon_state as a pipe item

	var/initialize_directions = 0
	var/pipe_color

	var/static/datum/pipe_icon_manager/icon_manager
	var/obj/machinery/atmospherics/node1
	var/obj/machinery/atmospherics/node2

/obj/machinery/atmospherics/New(loc, newdir)
	..()
	if(!icon_manager)
		icon_manager = new()
	if(!isnull(newdir))
		set_dir(newdir)
	if(!pipe_color)
		pipe_color = color
	color = null

	if(!pipe_color_check(pipe_color))
		pipe_color = null
	init_dir()

/obj/machinery/atmospherics/examine_icon()
	return icon(icon=initial(icon),icon_state=initial(icon_state))

// This is used to set up what directions pipes will connect to.  Should be called inside New() and whenever a dir changes.
/obj/machinery/atmospherics/proc/init_dir()
	return

// Get ALL initialize_directions - Some types (HE pipes etc) combine two vars together for this.
/obj/machinery/atmospherics/proc/get_init_dirs()
	return initialize_directions

// Get the direction each node is facing to connect.
// It now returns as a list so it can be fetched nicely, each entry corresponds to node of same number.
/obj/machinery/atmospherics/proc/get_node_connect_dirs()
	return

// Initializes nodes by looking at neighboring atmospherics machinery to connect to.
// When we're being constructed at runtime, atmos_init() is called by the construction code.
// When dynamically loading a map atmos_init is called by the maploader (initTemplateBounds proc)
// But during initial world creation its called by the master_controller.
// TODO - Consolidate these different ways of being called once SSatoms is created.
/obj/machinery/atmospherics/proc/atmos_init()
	return

/** Check if target is an acceptable target to connect as a node from this machine. */
/obj/machinery/atmospherics/proc/can_be_node(obj/machinery/atmospherics/target, node_num)
	return (target.initialize_directions & get_dir(target,src)) && check_connectable(target) && target.check_connectable(src)

/** Check if this machine is willing to connect with the target machine. */
/obj/machinery/atmospherics/proc/check_connectable(obj/machinery/atmospherics/target)
	return (src.connect_types & target.connect_types)

/obj/machinery/atmospherics/attackby(atom/A, mob/user as mob)
	if(istype(A, /obj/item/device/pipe_painter))
		return
	..()

/obj/machinery/atmospherics/proc/add_underlay(var/turf/T, var/obj/machinery/atmospherics/node, var/direction, var/icon_connect_type)
	if(node)
		if(!T.is_plating() && node.level == 1 && istype(node, /obj/machinery/atmospherics/pipe))
			//underlays += icon_manager.get_atmos_icon("underlay_down", direction, color_cache_name(node))
			underlays += icon_manager.get_atmos_icon("underlay", direction, color_cache_name(node), "down" + icon_connect_type)
		else
			//underlays += icon_manager.get_atmos_icon("underlay_intact", direction, color_cache_name(node))
			underlays += icon_manager.get_atmos_icon("underlay", direction, color_cache_name(node), "intact" + icon_connect_type)
	else
		//underlays += icon_manager.get_atmos_icon("underlay_exposed", direction, pipe_color)
		underlays += icon_manager.get_atmos_icon("underlay", direction, color_cache_name(node), "exposed" + icon_connect_type)

/obj/machinery/atmospherics/proc/update_underlays()
	if(check_icon_cache())
		return 1
	else
		return 0

/obj/machinery/atmospherics/proc/check_icon_cache(var/safety = 0)
	if(!istype(icon_manager))
		if(!safety) //to prevent infinite loops
			icon_manager = new()
			check_icon_cache(1)
		return 0

	return 1

/obj/machinery/atmospherics/proc/color_cache_name(var/obj/machinery/atmospherics/node)
	//Don't use this for standard pipes
	if(!istype(node))
		return null

	return node.pipe_color

/obj/machinery/atmospherics/process()
	last_flow_rate = 0
	last_power_draw = 0

	build_network()

/obj/machinery/atmospherics/proc/network_expand(datum/pipe_network/new_network, obj/machinery/atmospherics/pipe/reference)
	// Check to see if should be added to network. Add self if so and adjust variables appropriately.
	// Note don't forget to have neighbors look as well!

	return null

/obj/machinery/atmospherics/proc/build_network()
	// Called to build a network from this node

	return null

/obj/machinery/atmospherics/proc/return_network(obj/machinery/atmospherics/reference)
	// Returns pipe_network associated with connection to reference
	// Notes: should create network if necessary
	// Should never return null

	return null

/obj/machinery/atmospherics/proc/reassign_network(datum/pipe_network/old_network, datum/pipe_network/new_network)
	// Used when two pipe_networks are combining

/obj/machinery/atmospherics/proc/return_network_air(datum/pipe_network/reference)
	// Return a list of gas_mixture(s) in the object
	//		associated with reference pipe_network for use in rebuilding the networks gases list
	// Is permitted to return null

/obj/machinery/atmospherics/proc/disconnect(obj/machinery/atmospherics/reference)

/obj/machinery/atmospherics/update_icon()
	return null

/obj/machinery/atmospherics/proc/can_unwrench()
	var/datum/gas_mixture/int_air = return_air()
	var/datum/gas_mixture/env_air = loc.return_air()
	if((int_air.return_pressure()-env_air.return_pressure()) > 2*ONE_ATMOSPHERE)
		return 0
	return 1

// Deconstruct into a pipe item.
/obj/machinery/atmospherics/proc/deconstruct()
	if(QDELETED(src))
		return
	if(construction_type)
		var/obj/item/pipe/I = new construction_type(loc, null, null, src)
		I.setPipingLayer(piping_layer)
		transfer_fingerprints_to(I)
	qdel(src)

// Return a list of nodes which we should call atmos_init() and build_network() during on_construction()
/obj/machinery/atmospherics/proc/get_neighbor_nodes_for_init()
	return null

// Called on construction (i.e from pipe item) but not on initialization
/obj/machinery/atmospherics/proc/on_construction(obj_color, set_layer)
	pipe_color = obj_color
	setPipingLayer(set_layer)
	// TODO - M.connect_types = src.connect_types - Or otherwise copy from item? Or figure it out from piping layer?
	var/turf/T = get_turf(src)
	level = !T.is_plating() ? 2 : 1
	atmos_init()
	if(QDELETED(src))
		return // TODO - Eventually should get rid of the need for this.
	build_network()
	var/list/nodes = get_neighbor_nodes_for_init()
	for(var/obj/machinery/atmospherics/A in nodes)
		A.atmos_init()
		A.build_network()
	// TODO - Should we do src.build_network() before or after the nodes?
	// We've historically done before, but /tg does after. TODO research if there is a difference.

// This sets our piping layer.  Hopefully its cool.
/obj/machinery/atmospherics/proc/setPipingLayer(new_layer)
	if(pipe_flags & (PIPING_DEFAULT_LAYER_ONLY|PIPING_ALL_LAYER))
		new_layer = PIPING_LAYER_DEFAULT
	piping_layer = new_layer
	// Do it the Polaris way
	switch(piping_layer)
		if(PIPING_LAYER_SCRUBBER)
			icon_state = "[icon_state]-scrubbers"
			connect_types = CONNECT_TYPE_SCRUBBER
			layer = PIPES_SCRUBBER_LAYER
			icon_connect_type = "-scrubbers"
		if(PIPING_LAYER_SUPPLY)
			icon_state = "[icon_state]-supply"
			connect_types = CONNECT_TYPE_SUPPLY
			layer = PIPES_SUPPLY_LAYER
			icon_connect_type = "-supply"
		if(PIPING_LAYER_FUEL)
			icon_state = "[icon_state]-fuel"
			connect_types = CONNECT_TYPE_FUEL
			layer = PIPES_FUEL_LAYER
			icon_connect_type = "-fuel"
		if(PIPING_LAYER_AUX)
			icon_state = "[icon_state]-aux"
			connect_types = CONNECT_TYPE_AUX
			layer = PIPES_AUX_LAYER
			icon_connect_type = "-aux"
	if(pipe_flags & PIPING_ALL_LAYER)
		connect_types = CONNECT_TYPE_REGULAR|CONNECT_TYPE_SUPPLY|CONNECT_TYPE_SCRUBBER|CONNECT_TYPE_FUEL|CONNECT_TYPE_AUX
	// Or if we were to do it the TG way...
	// pixel_x = PIPE_PIXEL_OFFSET_X(piping_layer)
	// pixel_y = PIPE_PIXEL_OFFSET_Y(piping_layer)
	// layer = initial(layer) + PIPE_LAYER_OFFSET(piping_layer)
