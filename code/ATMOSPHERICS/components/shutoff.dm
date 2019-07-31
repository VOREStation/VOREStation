/obj/machinery/atmospherics/valve/shutoff
	icon = 'icons/atmos/clamp.dmi'
	icon_state = "map_vclamp0"
	pipe_state = "vclamp"

	name = "automatic shutoff valve"
	desc = "An automatic valve with control circuitry and pipe integrity sensor, capable of automatically isolating damaged segments of the pipe network."
	var/close_on_leaks = TRUE	// If false it will be always open
	level = 1

/obj/machinery/atmospherics/valve/shutoff/update_icon()
	icon_state = "vclamp[open]"

/obj/machinery/atmospherics/valve/shutoff/examine(var/mob/user)
	..()
	to_chat(user, "The automatic shutoff circuit is [close_on_leaks ? "enabled" : "disabled"].")

/obj/machinery/atmospherics/valve/shutoff/Initialize()
	. = ..()
	open()
	hide(1)

/obj/machinery/atmospherics/valve/shutoff/attack_ai(mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/atmospherics/valve/shutoff/attack_hand(var/mob/user)
	src.add_fingerprint(usr)
	update_icon(1)
	close_on_leaks = !close_on_leaks
	to_chat(user, "You [close_on_leaks ? "enable" : "disable"] the automatic shutoff circuit.")
	return TRUE

/obj/machinery/atmospherics/valve/shutoff/process()
	..()

	if (!network_node1 || !network_node2)
		if(open)
			close()
		return

	if (!close_on_leaks)
		if (!open)
			open()
		return

	if (network_node1.leaks.len || network_node2.leaks.len)
		if (open)
			close()
	else if (!open)
		open()
