/obj/machinery/computer/gyrotron_control
	name = "gyrotron control console"
	desc = "Used to control the R-UST stability beams."
	light_color = COLOR_BLUE
	circuit = /obj/item/circuitboard/gyrotron_control

	icon_keyboard = "generic_key"
	icon_screen = "mass_driver"

	var/id_tag
	var/scan_range = 25
	var/datum/tgui_module/gyrotron_control/monitor

/obj/machinery/computer/gyrotron_control/Initialize(mapload)
	. = ..()
	monitor = new(src)
	monitor.gyro_tag = id_tag
	monitor.scan_range = scan_range

/obj/machinery/computer/gyrotron_control/Destroy()
	QDEL_NULL(monitor)
	. = ..()

/obj/machinery/computer/gyrotron_control/attack_ai(var/mob/user)
	attack_hand(user)

/obj/machinery/computer/gyrotron_control/attack_hand(var/mob/user as mob)
	..()
	if(stat & (BROKEN|NOPOWER))
		return

	monitor.tgui_interact(user)

/obj/machinery/computer/gyrotron_control/attackby(var/obj/item/W, var/mob/user)
	..()
	if(istype(W, /obj/item/multitool))
		var/new_ident = tgui_input_text(user, "Enter a new ident tag.", "Gyrotron Control", monitor.gyro_tag, MAX_NAME_LEN)
		new_ident = sanitize(new_ident,MAX_NAME_LEN)
		if(new_ident && user.Adjacent(src))
			monitor.gyro_tag = new_ident
		return
/*
/obj/machinery/computer/gyrotron_control/update_icon()
	if(stat & (BROKEN))
		icon = 'icons/obj/computer.dmi'
		icon_state = "broken"
		set_light(0)

	if(stat & (NOPOWER))
		icon = 'icons/obj/computer.dmi'
		icon_state = "computer"
		set_light(0)

	if(!stat & (BROKEN|NOPOWER))
		icon = initial(icon)
		icon_state = initial(icon_state)
		set_light(light_range_on, light_power_on)
*/
