#define ENERGY_PER_K 20
#define MINIMUM_PLASMA_TEMPERATURE 10000

/obj/machinery/power/hydromagnetic_trap
	name = "\improper hydromagnetic trap"
	desc = "A device for extracting power from high-energy plasma in toroidal fields."
	icon = 'icons/obj/machines/power/fusion.dmi'
	icon_state = "mag_trap0"
	anchored = TRUE
	var/list/things_in_range = list()//what is in a radius of us?
	var/list/fields_in_range = list()//What EM fields are in that radius?
	var/list/active_field = list()//Our active field.
	var/active = 0 //are we even on?
	var/id_tag //needed for !!rasins!!

/obj/machinery/power/hydromagnetic_trap/attackby(var/obj/item/W, var/mob/user)
	if(default_unfasten_wrench(user, W))
		return

	return ..()

/obj/machinery/power/hydromagnetic_trap/process()
	if(anchored)
		if(!powernet)
			src.active = 0
			connect_to_network()

		if(powernet)
			spawn(1)
				Active()
				Search()

	else
		if(powernet)
			active_field.Cut()
			disconnect_from_network()

/obj/machinery/power/hydromagnetic_trap/proc/Search()//let's not have +100 instances of the same field in active_field.
	things_in_range = range(7, src)
	for (var/obj/effect/fusion_em_field/FFF in things_in_range)
		fields_in_range.Add(FFF)

	listclearnulls(active_field)
	listclearnulls(fields_in_range)

	for (var/obj/effect/fusion_em_field/FFF in fields_in_range)
		if(get_dist(src, FFF) > 7)
			fields_in_range.Remove(FFF)
			continue

		if (active_field.len > 0)
			return
		else if (active_field.len == 0)
			Link()
	return

/obj/machinery/power/hydromagnetic_trap/proc/Link() //discover our EM field
	var/obj/effect/fusion_em_field/FFF
	for(FFF in fields_in_range)
		active_field += FFF
		active = 1
	return

/obj/machinery/power/hydromagnetic_trap/proc/Active()//POWERRRRR
	if (active == 0)
		return
	for (var/obj/effect/fusion_em_field/FF in active_field)
		if (FF.plasma_temperature >= MINIMUM_PLASMA_TEMPERATURE)
			icon_state = "mag_trap1"
			add_avail(ENERGY_PER_K * FF.plasma_temperature)
		if (FF.plasma_temperature <= MINIMUM_PLASMA_TEMPERATURE)
			icon_state = "mag_trap0"
	return

#undef ENERGY_PER_K
#undef MINIMUM_PLASMA_TEMPERATURE
