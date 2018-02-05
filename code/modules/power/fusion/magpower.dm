#define ENERGY_PER_K 20
#define MINIMUM_PLASMA_TEMPERATURE 10000

/obj/machinery/power/hydromagnetic_trap
	name = "\improper hydromagnetic trap"
	desc = "A device for extracting power from high-energy plasma in toroidal fields."
	icon = 'icons/obj/machines/power/fusion.dmi'
	icon_state = "mag_trap0"
	anchored = 1
	var/list/things_in_range = list()//what is in a radius of us?
	var/list/fields_in_range = list()//What EM fields are in that radius?
	var/list/active_field = list()//Our active field.
	var/active = 0 //are we even on?
	var/id_tag //needed for !!rasins!!

/obj/machinery/power/hydromagnetic_trap/process()
	if(!powernet && anchored == 1)
		return
	spawn(1)
		Active()
		Search()

/obj/machinery/power/hydromagnetic_trap/proc/Search()//let's not have +100 instances of the same field in active_field.
	things_in_range = range(7, src)
	var/obj/effect/fusion_em_field/FFF
	for (FFF in things_in_range)
		fields_in_range.Add(FFF)
	for (FFF in fields_in_range)
		if (active_field.len > 0)
			return
		else if (active_field.len == 0)
			Link()
	return

/obj/machinery/power/hydromagnetic_trap/proc/Link() //discover our EM field
	var/obj/effect/fusion_em_field/FFF
	for(FFF in fields_in_range)
		if (FFF.id_tag != id_tag)
			return
		active_field += FFF
		active = 1
	return

/obj/machinery/power/hydromagnetic_trap/proc/Active()//POWERRRRR
	var/obj/effect/fusion_em_field/FF
	if (active == 0)
		return
	for (FF in active_field)
		if (FF.plasma_temperature >= MINIMUM_PLASMA_TEMPERATURE)
			icon_state = "mag_trap1"
			add_avail(ENERGY_PER_K * FF.plasma_temperature)
		if (FF.plasma_temperature <= MINIMUM_PLASMA_TEMPERATURE)
			icon_state = "mag_trap0"
	return
