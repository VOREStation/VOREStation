//Various overrides to make Eris sprites look nicer
/obj/machinery/computer/power_monitor
	icon_keyboard = "power_key"
	icon_screen = "power_monitor"

/obj/machinery/computer/power_monitor/update_icon()
	if(stat & BROKEN)
		icon_screen = "broken"
	else if(alerting)
		icon_screen = "power_monitor_warn"
	else
		icon_screen = "power_monitor"
	..()

/obj/machinery/computer/rcon
	icon_keyboard = "power_key"
	icon_screen = "ai-fixer"
