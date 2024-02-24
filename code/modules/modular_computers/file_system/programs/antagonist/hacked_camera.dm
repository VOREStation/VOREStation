/datum/computer_file/program/camera_monitor/hacked
	filename = "camcrypt"
	filedesc = "Camera Decryption Tool"
	tguimodule_path = /datum/tgui_module/camera/ntos/hacked
	program_icon_state = "hostile"
	program_key_state = "security_key"
	program_menu_icon = "zoomin"
	extended_desc = "This very advanced piece of software uses adaptive programming and large database of cipherkeys to bypass most encryptions used on camera networks. Be warned that system administrator may notice this."
	size = 73 // Very large, a price for bypassing ID checks completely.
	available_on_ntnet = FALSE
	available_on_syndinet = TRUE

/datum/computer_file/program/camera_monitor/hacked/process_tick()
	..()
	if(program_state != PROGRAM_STATE_ACTIVE) // Background programs won't trigger alarms.
		return

	// The program is active and connected to one of the station's networks. Has a very small chance to trigger IDS alarm every tick.
	if(prob(0.1))
		if(ntnet_global.intrusion_detection_enabled)
			ntnet_global.add_log("IDS WARNING - Unauthorised access detected to camera network by device with NID [computer.network_card.get_network_tag()]")
			ntnet_global.intrusion_detection_alarm = 1
