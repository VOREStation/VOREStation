/obj/machinery/computer/crew
	name = "crew monitoring computer"
	desc = "Used to monitor active health sensors built into most of the crew's uniforms."
	icon_keyboard = "med_key"
	icon_screen = "crew"
	light_color = "#315ab4"
	use_power = USE_POWER_IDLE
	idle_power_usage = 250
	active_power_usage = 500
	circuit = /obj/item/circuitboard/crew
	var/datum/tgui_module/crew_monitor/crew_monitor

/obj/machinery/computer/crew/New()
	crew_monitor = new(src)
	..()

/obj/machinery/computer/crew/Destroy()
	qdel(crew_monitor)
	crew_monitor = null
	..()

/obj/machinery/computer/crew/attack_ai(mob/user)
	attack_hand(user)

/obj/machinery/computer/crew/attack_hand(mob/user)
	add_fingerprint(user)
	if(stat & (BROKEN|NOPOWER))
		return
	tgui_interact(user)

/obj/machinery/computer/crew/tgui_interact(mob/user, datum/tgui/ui = null)
	crew_monitor.tgui_interact(user, ui)

/obj/machinery/computer/crew/interact(mob/user)
	crew_monitor.tgui_interact(user)
