/obj/machinery/atmospherics/tvalve
	icon = 'icons/atmos/tvalve.dmi'
	icon_state = "map_tvalve0"
	construction_type = /obj/item/pipe/trinary/flippable
	pipe_state = "mtvalve"

	name = "manual switching valve"
	desc = "A pipe valve"

	level = 1
	dir = SOUTH
	initialize_directions = SOUTH|NORTH|WEST

	var/state = 0 // 0 = go straight, 1 = go to side

	var/mirrored = FALSE
	var/tee = FALSE // Note: Tee not actually supported for T-valves: no sprites

	// like a trinary component, node1 is input, node2 is side output, node3 is straight output
	var/obj/machinery/atmospherics/node3

	var/datum/pipe_network/network_node1
	var/datum/pipe_network/network_node2
	var/datum/pipe_network/network_node3

/obj/machinery/atmospherics/tvalve/bypass
	icon_state = "map_tvalve1"
	state = 1

/obj/machinery/atmospherics/tvalve/update_icon(animation)
	if(animation)
		flick("tvalve[mirrored ? "m" : ""][src.state][!src.state]",src)
	else
		icon_state = "tvalve[mirrored ? "m" : ""][state]"

/obj/machinery/atmospherics/tvalve/update_underlays()
	if(..())
		underlays.Cut()
		var/turf/T = get_turf(src)
		if(!istype(T))
			return
		var/list/node_connects = get_node_connect_dirs()
		add_underlay(T, node1, node_connects[1])
		add_underlay(T, node2, node_connects[2])
		add_underlay(T, node3, node_connects[3])

/obj/machinery/atmospherics/tvalve/hide(var/i)
	update_underlays()

/obj/machinery/atmospherics/tvalve/init_dir()
	initialize_directions = get_initialize_directions_trinary(dir, mirrored)

/obj/machinery/atmospherics/tvalve/get_neighbor_nodes_for_init()
	return list(node1, node2, node3)

/obj/machinery/atmospherics/tvalve/network_expand(datum/pipe_network/new_network, obj/machinery/atmospherics/pipe/reference)
	if(reference == node1)
		network_node1 = new_network
		if(state)
			network_node2 = new_network
		else
			network_node3 = new_network
	else if(reference == node2)
		network_node2 = new_network
		if(state)
			network_node1 = new_network
	else if(reference == node3)
		network_node3 = new_network
		if(!state)
			network_node1 = new_network

	if(new_network.normal_members.Find(src))
		return 0

	new_network.normal_members += src

	if(state)
		if(reference == node1)
			if(node2)
				return node2.network_expand(new_network, src)
		else if(reference == node2)
			if(node1)
				return node1.network_expand(new_network, src)
	else
		if(reference == node1)
			if(node3)
				return node3.network_expand(new_network, src)
		else if(reference == node3)
			if(node1)
				return node1.network_expand(new_network, src)

	return null

/obj/machinery/atmospherics/tvalve/Destroy()
	. = ..()

	if(node1)
		node1.disconnect(src)
		qdel(network_node1)
	if(node2)
		node2.disconnect(src)
		qdel(network_node2)
	if(node3)
		node3.disconnect(src)
		qdel(network_node3)

	node1 = null
	node2 = null
	node3 = null

/obj/machinery/atmospherics/tvalve/proc/go_to_side()

	if(state) return 0

	state = 1
	update_icon()

	if(network_node1)
		qdel(network_node1)
	if(network_node3)
		qdel(network_node3)
	build_network()

	if(network_node1&&network_node2)
		network_node1.merge(network_node2)
		network_node2 = network_node1

	if(network_node1)
		network_node1.update = 1
	else if(network_node2)
		network_node2.update = 1

	return 1

/obj/machinery/atmospherics/tvalve/proc/go_straight()

	if(!state)
		return 0

	state = 0
	update_icon()

	if(network_node1)
		qdel(network_node1)
	if(network_node2)
		qdel(network_node2)
	build_network()

	if(network_node1&&network_node3)
		network_node1.merge(network_node3)
		network_node3 = network_node1

	if(network_node1)
		network_node1.update = 1
	else if(network_node3)
		network_node3.update = 1

	return 1

/obj/machinery/atmospherics/tvalve/attack_ai(mob/user as mob)
	return

/obj/machinery/atmospherics/tvalve/attack_hand(mob/user as mob)
	src.add_fingerprint(usr)
	update_icon(1)
	sleep(10)
	if (src.state)
		src.go_straight()
	else
		src.go_to_side()

/obj/machinery/atmospherics/tvalve/process()
	..()
	. = PROCESS_KILL

	return

/obj/machinery/atmospherics/tvalve/get_node_connect_dirs()
	return get_node_connect_dirs_trinary(dir, mirrored)

/obj/machinery/atmospherics/tvalve/atmos_init()
	if(node1 && node2 && node3)
		return

	var/list/node_connects = get_node_connect_dirs()

	STANDARD_ATMOS_CHOOSE_NODE(1, node_connects[1])
	STANDARD_ATMOS_CHOOSE_NODE(2, node_connects[2])
	STANDARD_ATMOS_CHOOSE_NODE(3, node_connects[3])

	update_icon()
	update_underlays()

/obj/machinery/atmospherics/tvalve/build_network()
	if(!network_node1 && node1)
		network_node1 = new /datum/pipe_network()
		network_node1.normal_members += src
		network_node1.build_network(node1, src)

	if(!network_node2 && node2)
		network_node2 = new /datum/pipe_network()
		network_node2.normal_members += src
		network_node2.build_network(node2, src)

	if(!network_node3 && node3)
		network_node3 = new /datum/pipe_network()
		network_node3.normal_members += src
		network_node3.build_network(node3, src)


/obj/machinery/atmospherics/tvalve/return_network(obj/machinery/atmospherics/reference)
	build_network()

	if(reference==node1)
		return network_node1

	if(reference==node2)
		return network_node2

	if(reference==node3)
		return network_node3

	return null

/obj/machinery/atmospherics/tvalve/reassign_network(datum/pipe_network/old_network, datum/pipe_network/new_network)
	if(network_node1 == old_network)
		network_node1 = new_network
	if(network_node2 == old_network)
		network_node2 = new_network
	if(network_node3 == old_network)
		network_node3 = new_network

	return 1

/obj/machinery/atmospherics/tvalve/return_network_air(datum/network/reference)
	return null

/obj/machinery/atmospherics/tvalve/disconnect(obj/machinery/atmospherics/reference)
	if(reference==node1)
		qdel(network_node1)
		node1 = null

	else if(reference==node2)
		qdel(network_node2)
		node2 = null

	else if(reference==node3)
		qdel(network_node3)
		node2 = null

	update_underlays()

	return null

/obj/machinery/atmospherics/tvalve/digital		// can be controlled by AI
	name = "digital switching valve"
	desc = "A digitally controlled valve."
	icon = 'icons/atmos/digital_tvalve.dmi'
	pipe_state = "dtvalve"

	var/frequency = 0
	var/id = null
	var/datum/radio_frequency/radio_connection

/obj/machinery/atmospherics/tvalve/digital/Destroy()
	unregister_radio(src, frequency)
	. = ..()

/obj/machinery/atmospherics/tvalve/digital/bypass
	icon_state = "map_tvalve1"
	state = 1

/obj/machinery/atmospherics/tvalve/digital/power_change()
	var/old_stat = stat
	..()
	if(old_stat != stat)
		update_icon()

/obj/machinery/atmospherics/tvalve/digital/update_icon()
	..()
	if(!powered())
		icon_state = "tvalve[mirrored ? "m" : ""]nopower"

/obj/machinery/atmospherics/tvalve/digital/attack_ai(mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/atmospherics/tvalve/digital/attack_hand(mob/user as mob)
	if(!powered())
		return
	if(!src.allowed(user))
		to_chat(user, "<span class='warning'>Access denied.</span>")
		return
	..()

//Radio remote control

/obj/machinery/atmospherics/tvalve/digital/proc/set_frequency(new_frequency)
	radio_controller.remove_object(src, frequency)
	frequency = new_frequency
	if(frequency)
		radio_connection = radio_controller.add_object(src, frequency, RADIO_ATMOSIA)



/obj/machinery/atmospherics/tvalve/digital/Initialize()
	. = ..()
	if(frequency)
		set_frequency(frequency)

/obj/machinery/atmospherics/tvalve/digital/receive_signal(datum/signal/signal)
	if(!signal.data["tag"] || (signal.data["tag"] != id))
		return 0

	switch(signal.data["command"])
		if("valve_open")
			if(!state)
				go_to_side()

		if("valve_close")
			if(state)
				go_straight()

		if("valve_toggle")
			if(state)
				go_straight()
			else
				go_to_side()

/obj/machinery/atmospherics/tvalve/attackby(var/obj/item/weapon/W as obj, var/mob/user as mob)
	if (!W.is_wrench())
		return ..()
	if (istype(src, /obj/machinery/atmospherics/tvalve/digital))
		to_chat(user, "<span class='warning'>You cannot unwrench \the [src], it's too complicated.</span>")
		return 1
	if(!can_unwrench())
		to_chat(user, "<span class='warnng'>You cannot unwrench \the [src], it too exerted due to internal pressure.</span>")
		add_fingerprint(user)
		return 1
	playsound(src, W.usesound, 50, 1)
	to_chat(user, "<span class='notice'>You begin to unfasten \the [src]...</span>")
	if (do_after(user, 40 * W.toolspeed))
		user.visible_message( \
			"<span class='notice'>\The [user] unfastens \the [src].</span>", \
			"<span class='notice'>You have unfastened \the [src].</span>", \
			"You hear a ratchet.")
		deconstruct()

/obj/machinery/atmospherics/tvalve/mirrored
	icon_state = "map_tvalvem0"
	mirrored = TRUE

/obj/machinery/atmospherics/tvalve/mirrored/bypass
	icon_state = "map_tvalvem1"
	state = 1

/obj/machinery/atmospherics/tvalve/digital/mirrored
	icon_state = "map_tvalvem0"
	mirrored = TRUE

/obj/machinery/atmospherics/tvalve/digital/mirrored/bypass
	icon_state = "map_tvalvem1"
	state = 1
