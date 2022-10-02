
GLOBAL_LIST_EMPTY(gyrotrons)

/obj/machinery/power/emitter/gyrotron
	name = "gyrotron"
	icon = 'icons/obj/machines/power/fusion.dmi'
	desc = "It is a heavy duty industrial gyrotron suited for powering fusion reactors."
	icon_state = "emitter-off"
	req_access = list(access_engine)
	use_power = USE_POWER_IDLE
	active_power_usage = 50000

	circuit = /obj/item/weapon/circuitboard/gyrotron

	var/id_tag
	var/rate = 3
	var/mega_energy = 1


/obj/machinery/power/emitter/gyrotron/anchored
	anchored = TRUE
	state = 2

/obj/machinery/power/emitter/gyrotron/Initialize()
	GLOB.gyrotrons += src
	default_apply_parts()
	return ..()

/obj/machinery/power/emitter/gyrotron/Destroy()
	GLOB.gyrotrons -= src
	return ..()

/obj/machinery/power/emitter/gyrotron/proc/set_beam_power(var/new_power)
	mega_energy = new_power
	update_active_power_usage(mega_energy * initial(active_power_usage))

/obj/machinery/power/emitter/gyrotron/get_rand_burst_delay()
	return rate * 10

/obj/machinery/power/emitter/gyrotron/get_burst_delay()
	return rate * 10

/obj/machinery/power/emitter/gyrotron/get_emitter_beam()
	var/obj/item/projectile/beam/emitter/E = ..()
	E.damage = mega_energy * 50
	return E

/obj/machinery/power/emitter/gyrotron/update_icon()
	if (active && powernet && avail(active_power_usage))
		icon_state = "emitter-on"
	else
		icon_state = "emitter-off"

/obj/machinery/power/emitter/gyrotron/attackby(var/obj/item/W, var/mob/user)
	if(istype(W, /obj/item/device/multitool))
		var/new_ident = tgui_input_text(usr, "Enter a new ident tag.", "Gyrotron", id_tag, MAX_NAME_LEN)
		new_ident = sanitize(new_ident,MAX_NAME_LEN)
		if(new_ident && user.Adjacent(src))
			id_tag = new_ident
		return

	if(default_deconstruction_screwdriver(user, W))
		return
	if(default_deconstruction_crowbar(user, W))
		return
	if(default_part_replacement(user, W))
		return

	return ..()