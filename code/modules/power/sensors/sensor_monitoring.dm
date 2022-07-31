// POWERNET SENSOR MONITORING CONSOLE
// Connects to powernet sensors and loads data from them. Shows this data to the user.
// Newly supports NanoUI.


/obj/machinery/computer/power_monitor
	name = "Power Monitoring Console"
	desc = "Computer designed to remotely monitor power levels around the station"
	icon_keyboard = "power_key"
	icon_screen = "power_monitor"
	light_color = "#ffcc33"

	//computer stuff
	density = TRUE
	anchored = TRUE
	circuit = /obj/item/circuitboard/powermonitor
	var/alerting = 0
	use_power = USE_POWER_IDLE
	idle_power_usage = 300
	active_power_usage = 300
	var/datum/tgui_module/power_monitor/power_monitor

// Checks the sensors for alerts. If change (alerts cleared or detected) occurs, calls for icon update.
/obj/machinery/computer/power_monitor/process()
	var/alert = check_warnings()
	if(alert != alerting)
		alerting = !alerting
		update_icon()
/* VOREStation Move - Moved to VR File
// Updates icon of this computer according to current status.
/obj/machinery/computer/power_monitor/update_icon()
	if(!(stat & (NOPOWER|BROKEN)))
		if(alerting)
			icon_screen = "[initial(icon_screen)]"
		else
			icon_screen = "[initial(icon_screen)]_warn"
	..()
*/
// On creation automatically connects to active sensors. This is delayed to ensure sensors already exist.
/obj/machinery/computer/power_monitor/Initialize()
	. = ..()
	power_monitor = new(src)

// On user click opens the UI of this computer.
/obj/machinery/computer/power_monitor/attack_hand(mob/user)
	add_fingerprint(user)

	if(stat & (BROKEN|NOPOWER))
		return
	tgui_interact(user)

// Uses dark magic to operate the NanoUI of this computer.
/obj/machinery/computer/power_monitor/tgui_interact(mob/user, var/datum/tgui/ui = null)
	power_monitor.tgui_interact(user, ui)

// Verifies if any warnings were registered by connected sensors.
/obj/machinery/computer/power_monitor/proc/check_warnings()
	for(var/obj/machinery/power/sensor/S in power_monitor.grid_sensors)
		if(S.check_grid_warning())
			return 1
	return 0
