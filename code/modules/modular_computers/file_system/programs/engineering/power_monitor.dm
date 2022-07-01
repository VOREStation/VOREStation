/datum/computer_file/program/power_monitor
	filename = "powermonitor"
	filedesc = "Power Monitoring"
	tguimodule_path = /datum/tgui_module/power_monitor/ntos
	program_icon_state = "power_monitor"
	program_key_state = "power_key"
	program_menu_icon = "battery-3"
	extended_desc = "This program connects to sensors to provide information about electrical systems"
	ui_header = "power_norm.gif"
	required_access = access_engine
	requires_ntnet = TRUE
	network_destination = "power monitoring system"
	size = 9
	category = PROG_ENG
	var/has_alert = 0

/datum/computer_file/program/power_monitor/process_tick()
	..()
	var/datum/tgui_module/power_monitor/TMA = TM
	if(istype(TMA) && TMA.has_alarm())
		if(!has_alert)
			program_icon_state = "power_monitor_warn"
			ui_header = "power_warn.gif"
			update_computer_icon()
			has_alert = 1
	else
		if(has_alert)
			program_icon_state = "power_monitor"
			ui_header = "power_norm.gif"
			update_computer_icon()
			has_alert = 0
