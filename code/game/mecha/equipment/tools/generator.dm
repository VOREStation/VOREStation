/obj/item/mecha_parts/mecha_equipment/generator
	name = "phoron generator"
	desc = "Generates power using solid phoron as fuel. Pollutes the environment."
	icon_state = "tesla"
	origin_tech = list(TECH_PHORON = 2, TECH_POWER = 2, TECH_ENGINEERING = 1)
	equip_cooldown = 10
	energy_drain = 0
	range = MELEE
	var/coeff = 100
	var/obj/item/stack/material/fuel
	var/fuel_type = /obj/item/stack/material/phoron
	var/max_fuel = 150000
	var/fuel_per_cycle_idle = 100
	var/fuel_per_cycle_active = 500
	var/power_per_cycle = 20

	equip_type = EQUIP_UTILITY

/obj/item/mecha_parts/mecha_equipment/generator/Initialize(mapload)
	. = ..()
	fuel = new fuel_type(src, 0)

/obj/item/mecha_parts/mecha_equipment/generator/Destroy()
	qdel(fuel)
	return ..()

/obj/item/mecha_parts/mecha_equipment/generator/process()
	if(!chassis)
		set_ready_state(TRUE)
		return PROCESS_KILL
	if(fuel.get_amount() <= 0)
		log_message("Deactivated - no fuel.")
		set_ready_state(TRUE)
		return PROCESS_KILL
	var/cur_charge = chassis.get_charge()
	if(isnull(cur_charge))
		set_ready_state(TRUE)
		occupant_message("No powercell detected.")
		log_message("Deactivated.")
		return PROCESS_KILL
	var/use_fuel = fuel_per_cycle_idle
	if(cur_charge<chassis.cell.maxcharge)
		use_fuel = fuel_per_cycle_active
		chassis.give_power(power_per_cycle)
	fuel.set_amount(min(use_fuel/fuel.perunit, fuel.get_amount()), TRUE) // allows fuel to get to 0
	update_equip_info()

/obj/item/mecha_parts/mecha_equipment/generator/detach()
	STOP_PROCESSING(SSfastprocess, src)
	..()
	return


/obj/item/mecha_parts/mecha_equipment/generator/Topic(href, href_list)
	..()
	if(href_list["toggle"])
		if(datum_flags & DF_ISPROCESSING)
			STOP_PROCESSING(SSfastprocess, src)
			set_ready_state(TRUE)
			log_message("Deactivated.")
		else
			START_PROCESSING(SSfastprocess, src)
			set_ready_state(FALSE)
			log_message("Activated.")
	return

/obj/item/mecha_parts/mecha_equipment/generator/get_equip_info()
	var/output = ..()
	if(output)
		return "[output] \[[fuel]: [round(fuel.get_amount()*fuel.perunit,0.1)] cm<sup>3</sup>\] - <a href='byond://?src=\ref[src];toggle=1'>[(datum_flags & DF_ISPROCESSING)?"Dea":"A"]ctivate</a>"
	return

/obj/item/mecha_parts/mecha_equipment/generator/action(target)
	if(chassis)
		var/result = load_fuel(target)
		var/message
		if(isnull(result))
			message = span_warning("[fuel] traces in target minimal. [target] cannot be used as fuel.")
		else if(!result)
			message = "Unit is full."
		else
			message = "[result] unit\s of [fuel] successfully loaded."
			send_byjax(chassis.occupant,"exosuit.browser","\ref[src]",src.get_equip_info())
		occupant_message(message)
	return

/obj/item/mecha_parts/mecha_equipment/generator/proc/load_fuel(var/obj/item/stack/material/P)
	if(P.type == fuel.type && P.get_amount())
		var/to_load = max(max_fuel - fuel.get_amount()*fuel.perunit,0)
		if(to_load)
			var/units = min(max(round(to_load / P.perunit),1),P.get_amount())
			if(units)
				fuel.add(units)
				P.use(units)
				return units
		else
			return 0
	return

/obj/item/mecha_parts/mecha_equipment/generator/attackby(weapon,mob/user)
	var/result = load_fuel(weapon)
	if(isnull(result))
		user.visible_message("[user] tries to shove [weapon] into [src]. What a dumb-ass.",span_warning("[fuel] traces minimal. [weapon] cannot be used as fuel."))
	else if(!result)
		to_chat(user, "Unit is full.")
	else
		user.visible_message("[user] loads [src] with [fuel].","[result] unit\s of [fuel] successfully loaded.")
	return

/obj/item/mecha_parts/mecha_equipment/generator/critfail()
	..()
	var/turf/simulated/T = get_turf(src)
	if(!T)
		return
	var/datum/gas_mixture/GM = new
	if(prob(10))
		T.assume_gas(GAS_PHORON, 100, 1500+T0C)
		T.visible_message("The [src] suddenly disgorges a cloud of heated phoron.")
		destroy()
	else
		T.assume_gas(GAS_PHORON, 5, istype(T) ? T.air.temperature : T20C)
		T.visible_message("The [src] suddenly disgorges a cloud of phoron.")
	T.assume_air(GM)
	return


/obj/item/mecha_parts/mecha_equipment/generator/nuclear
	name = "\improper ExoNuclear reactor"
	desc = "Generates power using uranium. Pollutes the environment."
	icon_state = "tesla"
	origin_tech = list(TECH_POWER = 3, TECH_ENGINEERING = 3)
	max_fuel = 50000
	fuel_per_cycle_idle = 10
	fuel_per_cycle_active = 30
	power_per_cycle = 50
	fuel_type = /obj/item/stack/material/uranium
	var/rad_per_cycle = 0.3

/obj/item/mecha_parts/mecha_equipment/generator/nuclear/process()
	if(..())
		SSradiation.radiate(src, (rad_per_cycle * 3))
	return

/obj/item/mecha_parts/mecha_equipment/generator/nuclear/critfail()
	return
