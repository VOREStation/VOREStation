/obj/item/modular_computer
	var/list/paired_uavs //Weakrefs, don't worry about it!

/datum/computer_file/program/uav
	filename = "rigger"
	filedesc = "UAV Control"
	tguimodule_path = /datum/tgui_module/uav
	program_icon_state = "comm_monitor"
	program_key_state = "generic_key"
	program_menu_icon = "link"
	extended_desc = "This program allows remote control of certain drones, but only when paired with this device."
	size = 12
	available_on_ntnet = 1
	//requires_ntnet = 1
