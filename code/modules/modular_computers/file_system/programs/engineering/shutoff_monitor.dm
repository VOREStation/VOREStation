/datum/computer_file/program/shutoff_monitor
	filename = "shutoffmonitor"
	filedesc = "Shutoff Valve Monitoring"
	tguimodule_path = /datum/tgui_module/shutoff_monitor/ntos
	program_icon_state = "atmos_control"
	program_key_state = "atmos_key"
	program_menu_icon = "wrench"
	extended_desc = "This program allows for remote monitoring and control of emergency shutoff valves."
	required_access = access_engine
	requires_ntnet = TRUE
	network_destination = "shutoff valve control computer"
	size = 5
	category = PROG_ENG
	var/has_alert = 0
