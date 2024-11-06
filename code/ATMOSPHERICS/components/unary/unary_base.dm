/obj/machinery/atmospherics/unary
	dir = SOUTH
	initialize_directions = SOUTH
	construction_type = /obj/item/pipe/directional
	pipe_flags = PIPING_DEFAULT_LAYER_ONLY|PIPING_ONE_PER_TURF
	//layer = TURF_LAYER+0.1

	var/datum/gas_mixture/air_contents

	var/obj/machinery/atmospherics/node

	var/datum/pipe_network/network

	var/welded = 0 //defining this here for ventcrawl stuff

/obj/machinery/atmospherics/unary/Initialize()
	. = ..()

	air_contents = new
	air_contents.volume = 200

/obj/machinery/atmospherics/unary/init_dir()
	initialize_directions = dir

// Housekeeping and pipe network stuff below
/obj/machinery/atmospherics/unary/get_neighbor_nodes_for_init()
	return list(node)

/obj/machinery/atmospherics/unary/network_expand(datum/pipe_network/new_network, obj/machinery/atmospherics/pipe/reference)
	if(reference == node)
		network = new_network

	if(new_network.normal_members.Find(src))
		return 0

	new_network.normal_members += src

	return null

/obj/machinery/atmospherics/unary/Destroy()
	. = ..()

	if(node)
		node.disconnect(src)
		qdel(network)

	node = null

/obj/machinery/atmospherics/unary/atmos_init()
	if(node)
		return

	var/node_connect = dir

	for(var/obj/machinery/atmospherics/target in get_step(src,node_connect))
		if(can_be_node(target, 1))
			node = target
			break

	update_icon()
	update_underlays()

/obj/machinery/atmospherics/unary/build_network()
	if(!network && node)
		network = new /datum/pipe_network()
		network.normal_members += src
		network.build_network(node, src)


/obj/machinery/atmospherics/unary/return_network(obj/machinery/atmospherics/reference)
	build_network()

	if(reference==node)
		return network

	return null

/obj/machinery/atmospherics/unary/reassign_network(datum/pipe_network/old_network, datum/pipe_network/new_network)
	if(network == old_network)
		network = new_network

	return 1

/obj/machinery/atmospherics/unary/return_network_air(datum/pipe_network/reference)
	var/list/results = list()

	if(network == reference)
		results += air_contents

	return results

/obj/machinery/atmospherics/unary/disconnect(obj/machinery/atmospherics/reference)
	if(reference==node)
		qdel(network)
		node = null

	update_icon()
	update_underlays()

	return null

// Check if there are any other atmos machines in the same turf that will block this machine from initializing.
// Intended for use when a frame-constructable machine (i.e. not made from pipe fittings) wants to wrench down and connect.
// Returns TRUE if something is blocking, FALSE if its okay to continue.
/obj/machinery/atmospherics/unary/proc/check_for_obstacles()
	for(var/obj/machinery/atmospherics/M in loc)
		if(M == src) continue
		if((M.pipe_flags & pipe_flags & PIPING_ONE_PER_TURF))	//Only one dense/requires density object per tile, eg connectors/cryo/heater/coolers.
			visible_message(span_warning("\The [src]'s cannot be connected, something is hogging the tile!"))
			return TRUE
		if((M.piping_layer != piping_layer) && !((M.pipe_flags | flags) & PIPING_ALL_LAYER)) // Pipes on different layers can't block each other unless they are ALL_LAYER
			continue
		if(M.get_init_dirs() & get_init_dirs())	// matches at least one direction on either type of pipe
			visible_message(span_warning("\The [src]'s connector can't be connected, there is already a pipe at that location!"))
			return TRUE
	return FALSE
