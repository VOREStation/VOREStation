/obj/machinery/computer/shutoff_monitor
	name = "automated shutoff valve monitor"
	desc = "Console used to remotely monitor shutoff valves on the station."
	icon_keyboard = "power_key"
	icon_screen = "power_monitor"
	light_color = "#a97faa"
	circuit = /obj/item/circuitboard/shutoff_monitor
	var/datum/tgui_module/shutoff_monitor/monitor

/obj/machinery/computer/shutoff_monitor/Initialize()
	. = ..()
	monitor = new(src)

/obj/machinery/computer/shutoff_monitor/Destroy()
	QDEL_NULL(monitor)
	..()

/obj/machinery/computer/shutoff_monitor/attack_hand(var/mob/user as mob)
	..()
	monitor.tgui_interact(user)

/obj/machinery/computer/shutoff_monitor/update_icon()
	..()
	if(!(stat & (NOPOWER|BROKEN)))
		add_overlay("ai-fixer-empty")
	else
		cut_overlay("ai-fixer-empty")
