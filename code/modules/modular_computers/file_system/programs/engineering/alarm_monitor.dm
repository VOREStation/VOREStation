/datum/computer_file/program/alarm_monitor
	filename = "alarmmonitoreng"
	filedesc = "Alarm Monitoring (Engineering)"
	tguimodule_path = /datum/tgui_module/alarm_monitor/engineering/ntos
	ui_header = "alarm_green.gif"
	program_icon_state = "alert-green"
	program_key_state = "atmos_key"
	program_menu_icon = "alert"
	extended_desc = "This program provides visual interface for the engineering alarm system."
	required_access = access_engine
	requires_ntnet = TRUE
	network_destination = "alarm monitoring network"
	size = 5
	category = PROG_MONITOR
	var/has_alert = 0

/datum/computer_file/program/alarm_monitor/process_tick()
	..()
	var/datum/tgui_module/alarm_monitor/TMA = TM
	if(istype(TMA) && TMA.has_major_alarms())
		if(!has_alert)
			program_icon_state = "alert-red"
			ui_header = "alarm_red.gif"
			update_computer_icon()
			has_alert = 1
	else
		if(has_alert)
			program_icon_state = "alert-green"
			ui_header = "alarm_green.gif"
			update_computer_icon()
			has_alert = 0
	return 1
