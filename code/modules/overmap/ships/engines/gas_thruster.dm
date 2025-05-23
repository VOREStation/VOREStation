//Gas nozzle engine
/datum/ship_engine/gas_thruster
	name = "gas thruster"
	var/obj/machinery/atmospherics/unary/engine/nozzle

/datum/ship_engine/gas_thruster/New(var/obj/machinery/_holder)
	..()
	nozzle = _holder

/datum/ship_engine/gas_thruster/Destroy()
	nozzle = null
	. = ..()

/datum/ship_engine/gas_thruster/get_status()
	return nozzle.get_status()

/datum/ship_engine/gas_thruster/get_thrust()
	return nozzle.get_thrust()

/datum/ship_engine/gas_thruster/burn()
	return nozzle.burn()

/datum/ship_engine/gas_thruster/set_thrust_limit(var/new_limit)
	nozzle.thrust_limit = new_limit

/datum/ship_engine/gas_thruster/get_thrust_limit()
	return nozzle.thrust_limit

/datum/ship_engine/gas_thruster/is_on()
	if(nozzle.use_power && nozzle.operable())
		if(nozzle.next_on > world.time)
			return -1
		else
			return 1
	return 0

/datum/ship_engine/gas_thruster/toggle()
	if(nozzle.use_power)
		nozzle.update_use_power(USE_POWER_OFF)
	else
		if(nozzle.blockage)
			if(nozzle.check_blockage())
				return
		nozzle.update_use_power(USE_POWER_IDLE)
		if(nozzle.stat & NOPOWER)//try again
			nozzle.power_change()
		if(nozzle.is_on())//if everything is in working order, start booting!
			nozzle.next_on = world.time + nozzle.boot_time

/datum/ship_engine/gas_thruster/can_burn()
	return nozzle.is_on() && nozzle.check_fuel()

//Actual thermal nozzle engine object

/obj/machinery/atmospherics/unary/engine
	name = "rocket nozzle"
	desc = "Simple rocket nozzle, expelling gas at hypersonic velocities to propell the ship."
	icon = 'icons/turf/shuttle_parts.dmi'
	icon_state = "nozzle"
	opacity = 1
	density = TRUE
	can_atmos_pass = ATMOS_PASS_NO
	connect_types = CONNECT_TYPE_REGULAR|CONNECT_TYPE_FUEL

	// construct_state = /decl/machine_construction/default/panel_closed
	// maximum_component_parts = list(/obj/item/stock_parts = 6)//don't want too many, let upgraded component shine
	// uncreated_component_parts = list(/obj/item/stock_parts/power/apc/buildable = 1)

	use_power = USE_POWER_OFF
	power_channel = EQUIP
	idle_power_usage = 1000

	var/datum/ship_engine/gas_thruster/controller
	var/thrust_limit = 1		//Value between 1 and 0 to limit the resulting thrust
	var/volume_per_burn = 15	//20 litres(with bin)
	var/charge_per_burn = 3600
	var/boot_time = 35
	var/next_on
	var/blockage

/obj/machinery/atmospherics/unary/engine/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	return 0

/obj/machinery/atmospherics/unary/engine/Initialize(mapload)
	. = ..()
	controller = new(src)
	update_nearby_tiles(need_rebuild=1)

	for(var/obj/effect/overmap/visitable/ship/S as anything in SSshuttles.ships)
		if(S.check_ownership(src))
			S.engines |= controller
			if(dir != S.fore_dir)
				set_broken(TRUE)
			break

/obj/machinery/atmospherics/unary/engine/Destroy()
	QDEL_NULL(controller)
	update_nearby_tiles()
	. = ..()

/obj/machinery/atmospherics/unary/engine/proc/get_status()
	. = list()
	.+= "Location: [get_area(src)]."
	if(stat & NOPOWER)
		.+= list(list("Insufficient power to operate.", "bad"))
	if(!check_fuel())
		.+= list(list("Insufficient fuel for a burn.", "bad"))
	if(stat & BROKEN)
		.+= list(list("Inoperable engine configuration.", "bad"))
	if(blockage)
		.+= list(list("Obstruction of airflow detected.", "bad"))

	.+= "Propellant total mass: [round(air_contents.get_mass(),0.01)] kg."
	.+= "Propellant used per burn: [round(air_contents.get_mass() * volume_per_burn * thrust_limit / air_contents.volume,0.01)] kg."
	.+= "Propellant pressure: [round(air_contents.return_pressure()/1000,0.1)] MPa."

/obj/machinery/atmospherics/unary/engine/power_change()
	. = ..()
	if(stat & NOPOWER)
		update_use_power(USE_POWER_OFF)

/obj/machinery/atmospherics/unary/engine/proc/is_on()
	return use_power && operable() && (next_on < world.time)

/obj/machinery/atmospherics/unary/engine/proc/check_fuel()
	return air_contents.total_moles > 5 // minimum fuel usage is five moles, for EXTREMELY hot mix or super low pressure

/obj/machinery/atmospherics/unary/engine/proc/get_thrust()
	if(!is_on() || !check_fuel())
		return 0
	var/used_part = volume_per_burn * thrust_limit / air_contents.volume
	. = calculate_thrust(air_contents, used_part)
	return

/obj/machinery/atmospherics/unary/engine/proc/check_blockage()
	blockage = FALSE
	var/exhaust_dir = reverse_direction(dir)
	var/turf/A = get_step(src, exhaust_dir)
	var/turf/B = A
	while(isturf(A) && !(istype(A, /turf/space) || isopenspace(A)))
		if((B.c_airblock(A)) & AIR_BLOCKED)
			blockage = TRUE
			break
		B = A
		A = get_step(A, exhaust_dir)
	return blockage

/obj/machinery/atmospherics/unary/engine/proc/burn()
	if(!is_on())
		return 0
	if(!check_fuel() || (use_power_oneoff(charge_per_burn) < charge_per_burn) || check_blockage())
		audible_message(src,span_warning("[src] coughs once and goes silent!"), runemessage = "sputtercough")
		update_use_power(USE_POWER_OFF)
		return 0

	var/datum/gas_mixture/removed = air_contents.remove_ratio(volume_per_burn * thrust_limit / air_contents.volume)
	if(!removed)
		return 0
	. = calculate_thrust(removed)
	playsound(src, 'sound/machines/thruster.ogg', 100 * thrust_limit, 0, world.view * 4, 0.1)
	if(network)
		network.update = 1

	var/exhaust_dir = reverse_direction(dir)
	var/turf/T = get_step(src,exhaust_dir)
	if(T)
		T.assume_air(removed)
		new/obj/effect/engine_exhaust(T, exhaust_dir, air_contents.check_combustability() && air_contents.temperature >= PHORON_MINIMUM_BURN_TEMPERATURE)

/obj/machinery/atmospherics/unary/engine/proc/calculate_thrust(datum/gas_mixture/propellant, used_part = 1)
	return round(sqrt(propellant.get_mass() * used_part * sqrt(air_contents.return_pressure()/200)),0.1)

/obj/machinery/atmospherics/unary/engine/RefreshParts()
	..()
	//allows them to upgrade the max limit of fuel intake (which only gives diminishing returns) for increase in max thrust but massive reduction in fuel economy
	var/bin_upgrade = 5 * CLAMP(total_component_rating_of_type(/obj/item/stock_parts/matter_bin), 0, 6)//5 litre per rank
	volume_per_burn = bin_upgrade ? initial(volume_per_burn) + bin_upgrade : 2 //Penalty missing part: 10% fuel use, no thrust
	boot_time = bin_upgrade ? initial(boot_time) - bin_upgrade : initial(boot_time) * 2
	//energy cost - thb all of this is to limit the use of back up batteries
	var/energy_upgrade = CLAMP(total_component_rating_of_type(/obj/item/stock_parts/capacitor), 0.1, 6)
	charge_per_burn = initial(charge_per_burn) / energy_upgrade
	change_power_consumption(initial(idle_power_usage) / energy_upgrade, USE_POWER_IDLE)

//Exhaust effect
/obj/effect/engine_exhaust
	name = "engine exhaust"
	icon = 'icons/effects/effects.dmi'
	icon_state = "smoke"
	light_color = "#ed9200"
	anchored = TRUE

/obj/effect/engine_exhaust/New(var/turf/nloc, var/ndir, var/flame)
	..(nloc)
	if(flame)
		icon_state = "exhaust"
		nloc.hotspot_expose(1000,125)
		set_light(0.5, 3)
	set_dir(ndir)
	QDEL_IN(src, 20)

/obj/item/circuitboard/unary_atmos/engine //why don't we move this elsewhere?
	name = T_BOARD("gas thruster")
	icon_state = "mcontroller"
	build_path = /obj/machinery/atmospherics/unary/engine
	origin_tech = list(TECH_POWER = 1, TECH_ENGINEERING = 2)
	req_components = list(
		/obj/item/stack/cable_coil = 30,
		/obj/item/pipe = 2,
		/obj/item/stock_parts/matter_bin = 1,
		/obj/item/stock_parts/capacitor = 2)

// Not Implemented - Variant that pulls power from cables.  Too complicated without bay's power components.
// /obj/machinery/atmospherics/unary/engine/terminal
// 	base_type = /obj/machinery/atmospherics/unary/engine
// 	stock_part_presets = list(/decl/stock_part_preset/terminal_setup)
// 	uncreated_component_parts = list(/obj/item/stock_parts/power/terminal/buildable = 1)
