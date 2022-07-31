/datum/computer_file/program/supermatter_monitor
	filename = "supmon"
	filedesc = "Supermatter Monitoring"
	tguimodule_path = /datum/tgui_module/supermatter_monitor/ntos
	program_icon_state = "smmon_0"
	program_key_state = "tech_key"
	program_menu_icon = "notice"
	extended_desc = "This program connects to specially calibrated supermatter sensors to provide information on the status of supermatter-based engines."
	ui_header = "smmon_0.gif"
	required_access = access_engine
	requires_ntnet = TRUE
	network_destination = "supermatter monitoring system"
	size = 5
	category = PROG_ENG
	var/last_status = 0

/datum/computer_file/program/supermatter_monitor/process_tick()
	..()
	var/datum/tgui_module/supermatter_monitor/TMS = TM
	var/new_status = istype(TMS) ? TMS.get_status() : 0
	if(last_status != new_status)
		last_status = new_status
		ui_header = "smmon_[last_status].gif"
		program_icon_state = "smmon_[last_status]"
		if(istype(computer))
			computer.update_icon()
