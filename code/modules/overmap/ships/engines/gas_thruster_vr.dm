//These connect at the corner 2 steps and 3 steps in the dir from their loc
/obj/machinery/atmospherics/unary/engine/bigger
	name = "large rocket nozzle"
	desc = "Advanced rocket nozzle, expelling gas at hypersonic velocities to propel the ship."
	icon = 'icons/turf/shuttle_parts64.dmi'
	icon_state = "engine_off"

	volume_per_burn = 30
	charge_per_burn = 6000
	boot_time = 70

	bound_width = 64
	bound_height = 64

/obj/machinery/atmospherics/unary/engine/bigger/atmos_init()
	if(node)
		return

	var/node_connect = dir
	var/turf/one_step = get_step(src,node_connect)

	for(var/obj/machinery/atmospherics/target in get_step(one_step,node_connect))
		if(can_be_node(target, 1))
			node = target
			break

	update_icon()
	update_underlays()

/obj/machinery/atmospherics/unary/engine/bigger/burn()
	. = ..()
	if(.)
		icon_state = "engine_on"
		spawn(2 SECONDS)
			icon_state = initial(icon_state)

/obj/machinery/atmospherics/unary/engine/biggest
	name = "huge rocket nozzle"
	desc = "Enormous rocket nozzle, expelling gas at hypersonic velocities to propel the ship."
	icon = 'icons/turf/shuttle_parts96.dmi'
	icon_state = "engine_off"

	volume_per_burn = 50
	charge_per_burn = 10000
	boot_time = 100

	bound_width = 96
	bound_height = 96

/obj/machinery/atmospherics/unary/engine/biggest/burn()
	. = ..()
	if(.)
		icon_state = "engine_on"
		spawn(2 SECONDS)
			icon_state = initial(icon_state)

/obj/machinery/atmospherics/unary/engine/biggest/atmos_init()
	if(node)
		return

	var/node_connect = dir
	var/turf/one_step = get_step(src,node_connect)
	var/turf/two_step = get_step(one_step,node_connect)

	for(var/obj/machinery/atmospherics/target in get_step(two_step,node_connect))
		if(can_be_node(target, 1))
			node = target
			break

	update_icon()
	update_underlays()
