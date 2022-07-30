//
// Heat Exchanging Pipes - Behave like simple pipes
//
/obj/machinery/atmospherics/pipe/simple/heat_exchanging
	icon = 'icons/atmos/heat.dmi'
	icon_state = "intact"
	pipe_icon = "hepipe"
	color = "#404040"
	level = 2
	connect_types = CONNECT_TYPE_HE
	pipe_flags = PIPING_DEFAULT_LAYER_ONLY
	construction_type = /obj/item/pipe/binary/bendable
	pipe_state = "he"

	layer = PIPES_HE_LAYER
	var/initialize_directions_he
	var/surface = 2	//surface area in m^2
	var/icon_temperature = T20C //stop small changes in temperature causing an icon refresh

	minimum_temperature_difference = 20
	thermal_conductivity = OPEN_HEAT_TRANSFER_COEFFICIENT

	buckle_lying = 1

	// BubbleWrap
/obj/machinery/atmospherics/pipe/simple/heat_exchanging/New()
	..()
// BubbleWrap END
	color = "#404040" //we don't make use of the fancy overlay system for colours, use this to set the default.

/obj/machinery/atmospherics/pipe/simple/heat_exchanging/init_dir()
	..()
	initialize_directions_he = initialize_directions	// The auto-detection from /pipe is good enough for a simple HE pipe
	initialize_directions = 0

/obj/machinery/atmospherics/pipe/simple/heat_exchanging/get_init_dirs()
	return ..() | initialize_directions_he

// Use initialize_directions_he to connect to neighbors instead.
/obj/machinery/atmospherics/pipe/simple/heat_exchanging/can_be_node(var/obj/machinery/atmospherics/pipe/simple/heat_exchanging/target)
	if(!istype(target))
		return FALSE
	return (target.initialize_directions_he & get_dir(target,src)) && check_connectable(target) && target.check_connectable(src)

/obj/machinery/atmospherics/pipe/simple/heat_exchanging/atmos_init()
	normalize_dir()
	var/node1_dir
	var/node2_dir

	for(var/direction in cardinal)
		if(direction&initialize_directions_he)
			if (!node1_dir)
				node1_dir = direction
			else if (!node2_dir)
				node2_dir = direction

	for(var/obj/machinery/atmospherics/pipe/simple/heat_exchanging/target in get_step(src,node1_dir))
		if(can_be_node(target, 1))
			node1 = target
			break
	for(var/obj/machinery/atmospherics/pipe/simple/heat_exchanging/target in get_step(src,node2_dir))
		if(can_be_node(target, 2))
			node2 = target
			break
	if(!node1 && !node2)
		qdel(src)
		return

	update_icon()
	handle_leaking()
	return

/obj/machinery/atmospherics/pipe/simple/heat_exchanging/set_leaking(var/new_leaking) // They already process, no need for manual processing toggles.
	if(new_leaking && !leaking)
		leaking = TRUE
		if(parent)
			parent.leaks |= src
			if(parent.network)
				parent.network.leaks |= src
	else if (!new_leaking && leaking)
		leaking = FALSE
		if(parent)
			parent.leaks -= src
			if(parent.network)
				parent.network.leaks -= src

/obj/machinery/atmospherics/pipe/simple/heat_exchanging/process()
	if(!parent)
		..()
	else
		if(leaking)
			parent.mingle_with_turf(loc, volume)
		var/datum/gas_mixture/pipe_air = return_air()
		if(istype(loc, /turf/simulated/))
			var/environment_temperature = 0
			if(loc:blocks_air)
				environment_temperature = loc:temperature
			else
				var/datum/gas_mixture/environment = loc.return_air()
				environment_temperature = environment.temperature
			var/turf/simulated/loc_as_turf = loc
			if((abs(environment_temperature-pipe_air.temperature) > minimum_temperature_difference) || (loc_as_turf.special_temperature))
				parent.temperature_interact(loc, volume, thermal_conductivity)
		else if(istype(loc, /turf/space/))
			parent.radiate_heat_to_space(surface, 1)

		if(has_buckled_mobs())
			for(var/mob/living/L as anything in buckled_mobs)
				var/hc = pipe_air.heat_capacity()
				var/avg_temp = (pipe_air.temperature * hc + L.bodytemperature * 3500) / (hc + 3500)
				pipe_air.temperature = avg_temp
				L.bodytemperature = avg_temp

				var/heat_limit = 1000

				var/mob/living/carbon/human/H = L
				if(istype(H) && H.species)
					heat_limit = H.species.heat_level_3

				if(pipe_air.temperature > heat_limit + 1)
					L.apply_damage(4 * log(pipe_air.temperature - heat_limit), BURN, BP_TORSO, used_weapon = "Excessive Heat")

		//fancy radiation glowing
		if(pipe_air.temperature && (icon_temperature > 500 || pipe_air.temperature > 500)) //start glowing at 500K
			if(abs(pipe_air.temperature - icon_temperature) > 10)
				icon_temperature = pipe_air.temperature

				var/h_r = heat2color_r(icon_temperature)
				var/h_g = heat2color_g(icon_temperature)
				var/h_b = heat2color_b(icon_temperature)

				if(icon_temperature < 2000) //scale up overlay until 2000K
					var/scale = (icon_temperature - 500) / 1500
					h_r = 64 + (h_r - 64)*scale
					h_g = 64 + (h_g - 64)*scale
					h_b = 64 + (h_b - 64)*scale

				animate(src, color = rgb(h_r, h_g, h_b), time = 20, easing = SINE_EASING)

//
// Heat Exchange Junction - Interfaces HE pipes to normal pipes
//
/obj/machinery/atmospherics/pipe/simple/heat_exchanging/junction
	desc = "An adaptor to transfer gasses between regular pipes and heat transferring ones. It doesn't conduct heat all that well."
	icon = 'icons/atmos/junction.dmi'
	icon_state = "intact"
	pipe_icon = "hejunction"
	level = 2
	connect_types = CONNECT_TYPE_REGULAR|CONNECT_TYPE_HE
	construction_type = /obj/item/pipe/directional
	pipe_state = "junction"
	minimum_temperature_difference = 300
	thermal_conductivity = WALL_HEAT_TRANSFER_COEFFICIENT

/obj/machinery/atmospherics/pipe/simple/heat_exchanging/junction/init_dir()
	..()
	switch ( dir )
		if ( SOUTH )
			initialize_directions = NORTH
			initialize_directions_he = SOUTH
		if ( NORTH )
			initialize_directions = SOUTH
			initialize_directions_he = NORTH
		if ( EAST )
			initialize_directions = WEST
			initialize_directions_he = EAST
		if ( WEST )
			initialize_directions = EAST
			initialize_directions_he = WEST

	// Allow ourselves to make connections to either HE or normal pipes depending on which node we are doing.
/obj/machinery/atmospherics/pipe/simple/heat_exchanging/junction/can_be_node(obj/machinery/atmospherics/target, node_num)
	var/target_initialize_directions
	switch(node_num)
		if(1)
			target_initialize_directions = target.initialize_directions // Node1 is towards normal pipes
		if(2)
			var/obj/machinery/atmospherics/pipe/simple/heat_exchanging/H = target
			if(!istype(H))
				return FALSE
			target_initialize_directions = H.initialize_directions_he  // Node2 is towards HE pies.
	return (target_initialize_directions & get_dir(target,src)) && check_connectable(target) && target.check_connectable(src)

/obj/machinery/atmospherics/pipe/simple/heat_exchanging/junction/atmos_init()
	for(var/obj/machinery/atmospherics/target in get_step(src,initialize_directions))
		if(target.initialize_directions & get_dir(target,src))
			node1 = target
			break
	for(var/obj/machinery/atmospherics/pipe/simple/heat_exchanging/target in get_step(src,initialize_directions_he))
		if(target.initialize_directions_he & get_dir(target,src))
			node2 = target
			break

	if(!node1&&!node2)
		qdel(src)
		return

	update_icon()
	handle_leaking()
	return
