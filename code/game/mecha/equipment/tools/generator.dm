/obj/item/mecha_parts/mecha_equipment/generator
	name = "phoron generator"
	desc = "Generates power using solid phoron as fuel. Pollutes the environment."
	icon_state = "tesla"
	origin_tech = list(TECH_PHORON = 2, TECH_POWER = 2, TECH_ENGINEERING = 1)
	equip_cooldown = 10
	energy_drain = 0
	range = MELEE
	var/datum/global_iterator/pr_mech_generator
	var/coeff = 100
	var/obj/item/stack/material/fuel
	var/max_fuel = 150000
	var/fuel_per_cycle_idle = 100
	var/fuel_per_cycle_active = 500
	var/power_per_cycle = 20

	equip_type = EQUIP_UTILITY

/obj/item/mecha_parts/mecha_equipment/generator/New()
	..()
	init()
	return

/obj/item/mecha_parts/mecha_equipment/generator/Destroy()
	qdel(pr_mech_generator)
	pr_mech_generator = null
	..()

/obj/item/mecha_parts/mecha_equipment/generator/proc/init()
	fuel = new /obj/item/stack/material/phoron(src)
	fuel.amount = 0
	pr_mech_generator = new /datum/global_iterator/mecha_generator(list(src),0)
	pr_mech_generator.set_delay(equip_cooldown)
	return

/obj/item/mecha_parts/mecha_equipment/generator/detach()
	pr_mech_generator.stop()
	..()
	return


/obj/item/mecha_parts/mecha_equipment/generator/Topic(href, href_list)
	..()
	if(href_list["toggle"])
		if(pr_mech_generator.toggle())
			set_ready_state(0)
			log_message("Activated.")
		else
			set_ready_state(1)
			log_message("Deactivated.")
	return

/obj/item/mecha_parts/mecha_equipment/generator/get_equip_info()
	var/output = ..()
	if(output)
		return "[output] \[[fuel]: [round(fuel.amount*fuel.perunit,0.1)] cm<sup>3</sup>\] - <a href='?src=\ref[src];toggle=1'>[pr_mech_generator.active()?"Dea":"A"]ctivate</a>"
	return

/obj/item/mecha_parts/mecha_equipment/generator/action(target)
	if(chassis)
		var/result = load_fuel(target)
		var/message
		if(isnull(result))
			message = "<span class='warning'>[fuel] traces in target minimal. [target] cannot be used as fuel.</span>"
		else if(!result)
			message = "Unit is full."
		else
			message = "[result] unit\s of [fuel] successfully loaded."
			send_byjax(chassis.occupant,"exosuit.browser","\ref[src]",src.get_equip_info())
		occupant_message(message)
	return

/obj/item/mecha_parts/mecha_equipment/generator/proc/load_fuel(var/obj/item/stack/material/P)
	if(P.type == fuel.type && P.amount)
		var/to_load = max(max_fuel - fuel.amount*fuel.perunit,0)
		if(to_load)
			var/units = min(max(round(to_load / P.perunit),1),P.amount)
			if(units)
				fuel.amount += units
				P.use(units)
				return units
		else
			return 0
	return

/obj/item/mecha_parts/mecha_equipment/generator/attackby(weapon,mob/user)
	var/result = load_fuel(weapon)
	if(isnull(result))
		user.visible_message("[user] tries to shove [weapon] into [src]. What a dumb-ass.","<span class='warning'>[fuel] traces minimal. [weapon] cannot be used as fuel.</span>")
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
		T.assume_gas("phoron", 100, 1500+T0C)
		T.visible_message("The [src] suddenly disgorges a cloud of heated phoron.")
		destroy()
	else
		T.assume_gas("phoron", 5, istype(T) ? T.air.temperature : T20C)
		T.visible_message("The [src] suddenly disgorges a cloud of phoron.")
	T.assume_air(GM)
	return

/datum/global_iterator/mecha_generator

/datum/global_iterator/mecha_generator/process(var/obj/item/mecha_parts/mecha_equipment/generator/EG)
	if(!EG.chassis)
		stop()
		EG.set_ready_state(1)
		return 0
	if(EG.fuel.amount<=0)
		stop()
		EG.log_message("Deactivated - no fuel.")
		EG.set_ready_state(1)
		return 0
	var/cur_charge = EG.chassis.get_charge()
	if(isnull(cur_charge))
		EG.set_ready_state(1)
		EG.occupant_message("No powercell detected.")
		EG.log_message("Deactivated.")
		stop()
		return 0
	var/use_fuel = EG.fuel_per_cycle_idle
	if(cur_charge<EG.chassis.cell.maxcharge)
		use_fuel = EG.fuel_per_cycle_active
		EG.chassis.give_power(EG.power_per_cycle)
	EG.fuel.amount -= min(use_fuel/EG.fuel.perunit,EG.fuel.amount)
	EG.update_equip_info()
	return 1


/obj/item/mecha_parts/mecha_equipment/generator/nuclear
	name = "\improper ExoNuclear reactor"
	desc = "Generates power using uranium. Pollutes the environment."
	icon_state = "tesla"
	origin_tech = list(TECH_POWER = 3, TECH_ENGINEERING = 3)
	max_fuel = 50000
	fuel_per_cycle_idle = 10
	fuel_per_cycle_active = 30
	power_per_cycle = 50
	var/rad_per_cycle = 0.3

/obj/item/mecha_parts/mecha_equipment/generator/nuclear/init()
	fuel = new /obj/item/stack/material/uranium(src)
	fuel.amount = 0
	pr_mech_generator = new /datum/global_iterator/mecha_generator/nuclear(list(src),0)
	pr_mech_generator.set_delay(equip_cooldown)
	return

/obj/item/mecha_parts/mecha_equipment/generator/nuclear/critfail()
	return

/datum/global_iterator/mecha_generator/nuclear

/datum/global_iterator/mecha_generator/nuclear/process(var/obj/item/mecha_parts/mecha_equipment/generator/nuclear/EG)
	if(..())
		SSradiation.radiate(EG, (EG.rad_per_cycle * 3))
	return 1
