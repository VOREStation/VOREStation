/*
	TODO README
*/

GLOBAL_LIST_EMPTY(fusion_cores)

#define MAX_FIELD_STR 1000
#define MIN_FIELD_STR 1

/obj/machinery/power/fusion_core
	name = "\improper R-UST Mk. 9 Tokamak core"
	desc = "An enormous solenoid for generating extremely high power electromagnetic fields. It includes a kinetic energy harvester."
	icon = 'icons/obj/machines/power/fusion.dmi'
	icon_state = "core0"
	density = TRUE
	use_power = USE_POWER_IDLE
	idle_power_usage = 50
	active_power_usage = 500 //multiplied by field strength
	anchored = FALSE

	circuit = /obj/item/circuitboard/fusion_core

	var/obj/item/hose_connector/output/Output

	var/obj/effect/fusion_em_field/owned_field
	var/field_strength = 1//0.01
	var/target_field_strength = 1
	var/id_tag

	var/reactant_dump = FALSE	// Does the tokomak actively try to syphon materials?

/obj/machinery/power/fusion_core/mapped
	anchored = TRUE

/obj/machinery/power/fusion_core/Initialize()
	. = ..()
	GLOB.fusion_cores += src

	Output = new(src)
	create_reagents(10000)

	default_apply_parts()

/obj/machinery/power/fusion_core/mapped/Initialize()
	. = ..()
	connect_to_network()

/obj/machinery/power/fusion_core/Destroy()
	for(var/obj/machinery/computer/fusion_core_control/FCC in machines)
		FCC.connected_devices -= src
		if(FCC.cur_viewed_device == src)
			FCC.cur_viewed_device = null
	GLOB.fusion_cores -= src
	return ..()

/obj/machinery/power/fusion_core/proc/check_core_status()
	if(stat & BROKEN)
		return
	if(idle_power_usage > avail())
		return
	. = 1

/obj/machinery/power/fusion_core/process()
	if((stat & BROKEN) || !powernet || !owned_field)
		Shutdown()

	if(Output.get_pairing())
		reagents.trans_to_holder(Output.reagents, Output.reagents.maximum_volume)
		if(prob(5))
			visible_message("<b>\The [src]</b> gurgles as it exports fluid.")

	if(owned_field)

		set_strength(target_field_strength)

		spawn(1)
			owned_field.process()
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
		update_active_power_usage(500 * field_strength)
		if(owned_field)
			owned_field.ChangeFieldStrength(field_strength)

/obj/machinery/power/fusion_core/proc/Startup()
	if(owned_field)
		return
	owned_field = new(loc, src)
	owned_field.ChangeFieldStrength(field_strength)
	icon_state = "core1"
	update_use_power(USE_POWER_ACTIVE)
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
	update_use_power(USE_POWER_IDLE)

/obj/machinery/power/fusion_core/proc/AddParticles(var/name, var/quantity = 1)
	if(owned_field)
		owned_field.AddParticles(name, quantity)
		. = 1

/obj/machinery/power/fusion_core/bullet_act(var/obj/item/projectile/Proj)
	if(owned_field)
		. = owned_field.bullet_act(Proj)

/obj/machinery/power/fusion_core/proc/set_strength(var/value)
	value = CLAMP(value, MIN_FIELD_STR, MAX_FIELD_STR)

	if(field_strength != value)
		field_strength = value
		update_active_power_usage(5 * value)
		if(owned_field)
			owned_field.ChangeFieldStrength(value)

/obj/machinery/power/fusion_core/attack_hand(var/mob/user)
	if(!Adjacent(user)) // As funny as it was for the AI to hug-kill the tokamak field from a distance...
		return
	visible_message("<b>\The [user]</b> hugs \the [src] to make it feel better!")
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

<<<<<<< HEAD
	if(istype(W, /obj/item/device/multitool))
		var/new_ident = input(usr, "Enter a new ident tag.", "Fusion Core", id_tag) as null|text
=======
	if(istype(W, /obj/item/multitool))
		var/new_ident = input("Enter a new ident tag.", "Fusion Core", id_tag) as null|text
>>>>>>> 61084723c7b... Merge pull request #8317 from Atermonera/remove_weapon
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