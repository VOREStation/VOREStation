/obj/machinery/atmospherics/trinary
	dir = SOUTH
	initialize_directions = SOUTH|NORTH|WEST
	use_power = 0

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
	switch(dir)
		if(NORTH)
			initialize_directions = EAST|NORTH|SOUTH
		if(SOUTH)
			initialize_directions = SOUTH|WEST|NORTH
		if(EAST)
			initialize_directions = EAST|WEST|SOUTH
		if(WEST)
			initialize_directions = WEST|NORTH|EAST

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

// Housekeeping and pipe network stuff below
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
	var/node1_connect = turn(dir, 180)
	var/node2_connect = turn(dir, -90)
	var/node3_connect = dir
	return list(node1_connect, node2_connect, node3_connect)

/obj/machinery/atmospherics/trinary/atmos_init()
	if(node1 && node2 && node3)
		return

	var/list/node_connects = get_node_connect_dirs()

	for(var/obj/machinery/atmospherics/target in get_step(src,node_connects[1]))
		if(target.initialize_directions & get_dir(target,src))
			if (check_connect_types(target,src))
				node1 = target
				break
	for(var/obj/machinery/atmospherics/target in get_step(src,node_connects[2]))
		if(target.initialize_directions & get_dir(target,src))
			if (check_connect_types(target,src))
				node2 = target
				break
	for(var/obj/machinery/atmospherics/target in get_step(src,node_connects[3]))
		if(target.initialize_directions & get_dir(target,src))
			if (check_connect_types(target,src))
				node3 = target
				break

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