
/obj/machinery/computer/station_alert
	name = "Station Alert Console"
	desc = "Used to access the station's automated alert system."
	icon_keyboard = "tech_key"
	icon_screen = "alert:0"
	light_color = "#e6ffff"
	circuit = /obj/item/weapon/circuitboard/stationalert_engineering
	var/datum/tgui_module/alarm_monitor/alarm_monitor
	var/monitor_type = /datum/tgui_module/alarm_monitor/engineering

/obj/machinery/computer/station_alert/security
	monitor_type = /datum/tgui_module/alarm_monitor/security
	circuit = /obj/item/weapon/circuitboard/stationalert_security

/obj/machinery/computer/station_alert/all
	monitor_type = /datum/tgui_module/alarm_monitor/all
	circuit = /obj/item/weapon/circuitboard/stationalert_all

/obj/machinery/computer/station_alert/Initialize()
	alarm_monitor = new monitor_type(src)
	alarm_monitor.register_alarm(src, /obj/machinery/computer/station_alert/update_icon)
	. = ..()

/obj/machinery/computer/station_alert/Destroy()
	alarm_monitor.unregister_alarm(src)
	qdel(alarm_monitor)
	..()

/obj/machinery/computer/station_alert/attack_ai(mob/user)
	add_fingerprint(user)
	if(stat & (BROKEN|NOPOWER))
		return
	tgui_interact(user)
	return

/obj/machinery/computer/station_alert/attack_hand(mob/user)
	add_fingerprint(user)
	if(stat & (BROKEN|NOPOWER))
		return
	tgui_interact(user)
	return

/obj/machinery/computer/station_alert/tgui_interact(mob/user)
	alarm_monitor.tgui_interact(user)

/obj/machinery/computer/station_alert/update_icon()
	if(!(stat & (BROKEN|NOPOWER)))
		var/list/alarms = alarm_monitor ? alarm_monitor.major_alarms() : list()
		if(alarms.len)
			icon_screen = "alert:2"
		else
			icon_screen = initial(icon_screen)
	..()
