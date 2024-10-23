/obj/machinery/atmospherics/trinary
	dir = SOUTH
	initialize_directions = SOUTH|NORTH|WEST
	use_power = USE_POWER_OFF
	pipe_flags = PIPING_DEFAULT_LAYER_ONLY|PIPING_ONE_PER_TURF

	var/mirrored = FALSE
	var/tee = FALSE

	var/datum/gas_mixture/air1
	var/datum/gas_mixture/air2
	var/datum/gas_mixture/air3

	var/obj/machinery/atmospherics/node3

	var/datum/pipe_network/network1
	var/datum/pipe_network/network2
	var/datum/pipe_network/network3

/obj/machinery/atmospherics/trinary/New()
	..()

	air1 = new
	air2 = new
	air3 = new

	air1.volume = 200
	air2.volume = 200
	air3.volume = 200

/obj/machinery/atmospherics/trinary/init_dir()
	initialize_directions = get_initialize_directions_trinary(dir, mirrored, tee)

/obj/machinery/atmospherics/trinary/update_underlays()
	if(..())
		underlays.Cut()
		var/turf/T = get_turf(src)
		if(!istype(T))
			return
		var/list/node_connects = get_node_connect_dirs()
		add_underlay(T, node1, node_connects[1])
		add_underlay(T, node2, node_connects[2])
		add_underlay(T, node3, node_connects[3])

/obj/machinery/atmospherics/trinary/hide(var/i)
	update_underlays()

/obj/machinery/atmospherics/trinary/power_change()
	var/old_stat = stat
	. = ..()
	if(old_stat != stat)
		update_icon()

/obj/machinery/atmospherics/trinary/attackby(var/obj/item/W as obj, var/mob/user as mob)
	if (!W.has_tool_quality(TOOL_WRENCH))
		return ..()
	if(!can_unwrench())
		to_chat(user, span_warning("You cannot unwrench \the [src], it too exerted due to internal pressure."))
		add_fingerprint(user)
		return 1
	playsound(src, W.usesound, 50, 1)
	to_chat(user, span_notice("You begin to unfasten \the [src]..."))
	if (do_after(user, 40 * W.toolspeed))
		user.visible_message( \
			span_infoplain(span_bold("\The [user]") + " unfastens \the [src]."), \
			span_notice("You have unfastened \the [src]."), \
			"You hear a ratchet.")
		deconstruct()

// Housekeeping and pipe network stuff below
/obj/machinery/atmospherics/trinary/get_neighbor_nodes_for_init()
	return list(node1, node2, node3)

/obj/machinery/atmospherics/trinary/network_expand(datum/pipe_network/new_network, obj/machinery/atmospherics/pipe/reference)
	if(reference == node1)
		network1 = new_network

	else if(reference == node2)
		network2 = new_network

	else if (reference == node3)
		network3 = new_network

	if(new_network.normal_members.Find(src))
		return 0

	new_network.normal_members += src

	return null

/obj/machinery/atmospherics/trinary/Destroy()
	. = ..()

	if(node1)
		node1.disconnect(src)
		qdel(network1)
	if(node2)
		node2.disconnect(src)
		qdel(network2)
	if(node3)
		node3.disconnect(src)
		qdel(network3)

	node1 = null
	node2 = null
	node3 = null

// Get the direction each node is facing to connect.
// It now returns as a list so it can be fetched nicely, each entry corresponds to node of same number.
/obj/machinery/atmospherics/trinary/get_node_connect_dirs()
	return get_node_connect_dirs_trinary(dir, mirrored, tee)

/obj/machinery/atmospherics/trinary/atmos_init()
	if(node1 && node2 && node3)
		return

	var/list/node_connects = get_node_connect_dirs()

	STANDARD_ATMOS_CHOOSE_NODE(1, node_connects[1])
	STANDARD_ATMOS_CHOOSE_NODE(2, node_connects[2])
	STANDARD_ATMOS_CHOOSE_NODE(3, node_connects[3])

	update_icon()
	update_underlays()

/obj/machinery/atmospherics/trinary/build_network()
	if(!network1 && node1)
		network1 = new /datum/pipe_network()
		network1.normal_members += src
		network1.build_network(node1, src)

	if(!network2 && node2)
		network2 = new /datum/pipe_network()
		network2.normal_members += src
		network2.build_network(node2, src)

	if(!network3 && node3)
		network3 = new /datum/pipe_network()
		network3.normal_members += src
		network3.build_network(node3, src)


/obj/machinery/atmospherics/trinary/return_network(obj/machinery/atmospherics/reference)
	build_network()

	if(reference==node1)
		return network1

	if(reference==node2)
		return network2

	if(reference==node3)
		return network3

	return null

/obj/machinery/atmospherics/trinary/reassign_network(datum/pipe_network/old_network, datum/pipe_network/new_network)
	if(network1 == old_network)
		network1 = new_network
	if(network2 == old_network)
		network2 = new_network
	if(network3 == old_network)
		network3 = new_network

	return 1

/obj/machinery/atmospherics/trinary/return_network_air(datum/pipe_network/reference)
	var/list/results = list()

	if(network1 == reference)
		results += air1
	if(network2 == reference)
		results += air2
	if(network3 == reference)
		results += air3

	return results

/obj/machinery/atmospherics/trinary/disconnect(obj/machinery/atmospherics/reference)
	if(reference==node1)
		qdel(network1)
		node1 = null

	else if(reference==node2)
		qdel(network2)
		node2 = null

	else if(reference==node3)
		qdel(network3)
		node3 = null

	update_underlays()

	return null

// Trinary init_dir() logic in a separate proc so it can be referenced from "trinary-ish" places like T-Valves
// TODO - Someday refactor those places under atmospherics/trinary
/proc/get_initialize_directions_trinary(var/dir, var/mirrored = FALSE, var/tee = FALSE)
	if(tee)
		switch(dir)
			if(NORTH)
				return EAST|NORTH|WEST
			if(SOUTH)
				return SOUTH|WEST|EAST
			if(EAST)
				return EAST|NORTH|SOUTH
			if(WEST)
				return WEST|NORTH|SOUTH
	else if(mirrored)
		switch(dir)
			if(NORTH)
				return WEST|NORTH|SOUTH
			if(SOUTH)
				return SOUTH|EAST|NORTH
			if(EAST)
				return EAST|WEST|NORTH
			if(WEST)
				return WEST|SOUTH|EAST
	else
		switch(dir)
			if(NORTH)
				return EAST|NORTH|SOUTH
			if(SOUTH)
				return SOUTH|WEST|NORTH
			if(EAST)
				return EAST|WEST|SOUTH
			if(WEST)
				return WEST|NORTH|EAST

// Trinary get_node_connect_dirs() logic in a separate proc so it can be referenced from "trinary-ish" places like T-Valves
/proc/get_node_connect_dirs_trinary(var/dir, var/mirrored = FALSE, var/tee = FALSE)
	var/node1_connect
	var/node2_connect
	var/node3_connect

	if(tee)
		node1_connect = turn(dir, -90)
		node2_connect = turn(dir, 90)
		node3_connect = dir
	else if(mirrored)
		node1_connect = turn(dir, 180)
		node2_connect = turn(dir, 90)
		node3_connect = dir
	else
		node1_connect = turn(dir, 180)
		node2_connect = turn(dir, -90)
		node3_connect = dir
	return list(node1_connect, node2_connect, node3_connect)
