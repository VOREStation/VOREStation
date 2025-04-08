/obj/machinery/computer/fusion_core_control
	name = "\improper R-UST Mk. 8 core control"
	light_color = COLOR_ORANGE
	circuit = /obj/item/circuitboard/fusion_core_control

	icon_keyboard = "tech_key"
	icon_screen = "core_control"

	var/id_tag = ""
	var/scan_range = 25
	var/list/connected_devices = list()
	var/obj/machinery/power/fusion_core/cur_viewed_device
	var/datum/tgui_module/rustcore_monitor/monitor

/obj/machinery/computer/fusion_core_control/Initialize(mapload)
	. = ..()
	monitor = new(src)
	monitor.core_tag = id_tag

/obj/machinery/computer/fusion_core_control/Destroy()
	QDEL_NULL(monitor)
	. = ..()

/obj/machinery/computer/fusion_core_control/attackby(var/obj/item/thing, var/mob/user)
	..()
	if(istype(thing, /obj/item/multitool))
		var/new_ident = sanitize_text(tgui_input_text(user, "Enter a new ident tag.", "Core Control", monitor.core_tag))
		if(new_ident && user.Adjacent(src))
			monitor.core_tag = new_ident
		return

/obj/machinery/computer/fusion_core_control/attack_ai(mob/user)
	attack_hand(user)

/obj/machinery/computer/fusion_core_control/attack_hand(var/mob/user as mob)
	..()
	if(stat & (BROKEN|NOPOWER))
		return

	monitor.tgui_interact(user)

//Returns 1 if the machine can be interacted with via this console.
/obj/machinery/computer/fusion_core_control/proc/check_core_status(var/obj/machinery/power/fusion_core/C)
	return istype(C) ? C.check_core_status() : FALSE
