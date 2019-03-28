/*
	TODO README
*/

var/list/fusion_cores = list()

#define MAX_FIELD_STR 1000
#define MIN_FIELD_STR 1

/obj/machinery/power/fusion_core
	name = "\improper R-UST Mk. 8 Tokamak core"
	desc = "An enormous solenoid for generating extremely high power electromagnetic fields. It includes a kinetic energy harvester."
	icon = 'icons/obj/machines/power/fusion.dmi'
	icon_state = "core0"
	density = 1
	use_power = 1
	idle_power_usage = 50
	active_power_usage = 500 //multiplied by field strength
	anchored = 0

	circuit = /obj/item/weapon/circuitboard/fusion_core

	var/obj/effect/fusion_em_field/owned_field
	var/field_strength = 1//0.01
	var/id_tag

/obj/machinery/power/fusion_core/mapped
	anchored = 1

/obj/machinery/power/fusion_core/Initialize()
	. = ..()
	fusion_cores += src
	default_apply_parts()

/obj/machinery/power/fusion_core/mapped/Initialize()
	. = ..()
	connect_to_network()

/obj/machinery/power/fusion_core/Destroy()
	for(var/obj/machinery/computer/fusion_core_control/FCC in machines)
		FCC.connected_devices -= src
		if(FCC.cur_viewed_device == src)
			FCC.cur_viewed_device = null
	fusion_cores -= src
	return ..()

/obj/machinery/power/fusion_core/process()
	if((stat & BROKEN) || !powernet || !owned_field)
		Shutdown()
	if(owned_field)
		spawn(1)
			owned_field.stability_monitor()
			owned_field.radiation_scale()
			owned_field.temp_dump()
			owned_field.temp_color()

/obj/machinery/power/fusion_core/Topic(href, href_list)
	if(..())
		return 1
	if(href_list["str"])
		var/dif = text2num(href_list["str"])
		field_strength = min(max(field_strength + dif, MIN_FIELD_STR), MAX_FIELD_STR)
		active_power_usage = 500 * field_strength
		if(owned_field)
			owned_field.ChangeFieldStrength(field_strength)

/obj/machinery/power/fusion_core/proc/Startup()
	if(owned_field)
		return
	owned_field = new(loc, src)
	owned_field.ChangeFieldStrength(field_strength)
	icon_state = "core1"
	use_power = 2
	. = 1

/obj/machinery/power/fusion_core/proc/Shutdown(var/force_rupture)
	if(owned_field)
		icon_state = "core0"
		if(force_rupture || owned_field.plasma_temperature > 1000)
			owned_field.MRC()
		else
			owned_field.RadiateAll()
		qdel(owned_field)
		owned_field = null
	use_power = 1

/obj/machinery/power/fusion_core/proc/AddParticles(var/name, var/quantity = 1)
	if(owned_field)
		owned_field.AddParticles(name, quantity)
		. = 1

/obj/machinery/power/fusion_core/bullet_act(var/obj/item/projectile/Proj)
	if(owned_field)
		. = owned_field.bullet_act(Proj)

/obj/machinery/power/fusion_core/proc/set_strength(var/value)
	value = CLAMP(value, MIN_FIELD_STR, MAX_FIELD_STR)
	field_strength = value
	active_power_usage = 5 * value
	if(owned_field)
		owned_field.ChangeFieldStrength(value)

/obj/machinery/power/fusion_core/attack_hand(var/mob/user)
	if(!Adjacent(user)) // As funny as it was for the AI to hug-kill the tokamak field from a distance...
		return
	visible_message("<span class='notice'>\The [user] hugs \the [src] to make it feel better!</span>")
	if(owned_field)
		Shutdown()

/obj/machinery/power/fusion_core/attackby(var/obj/item/W, var/mob/user)

	if(owned_field)
		to_chat(user,"<span class='warning'>Shut \the [src] off first!</span>")
		return

	if(default_deconstruction_screwdriver(user, W))
		return
	if(default_deconstruction_crowbar(user, W))
		return
	if(default_part_replacement(user, W))
		return

	if(istype(W, /obj/item/device/multitool))
		var/new_ident = input("Enter a new ident tag.", "Fusion Core", id_tag) as null|text
		if(new_ident && user.Adjacent(src))
			id_tag = new_ident
		return

	if(default_unfasten_wrench(user, W))
		return

	return ..()

/obj/machinery/power/fusion_core/proc/jumpstart(var/field_temperature)
	field_strength = 501 // Generally a good size.
	Startup()
	if(!owned_field)
		return FALSE
	owned_field.plasma_temperature = field_temperature
	return TRUE