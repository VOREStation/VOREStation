/datum/computer_file/program/ship_nav
	filename = "navviewer"
	filedesc = "Ship Navigational Screen"
	tguimodule_path = /datum/tgui_module/ship/nav/ntos
	program_icon_state = "helm"
	program_key_state = "generic_key"
	program_menu_icon = "pin-s"
	extended_desc = "Displays a ship's location in the sector."
	required_access = null
	requires_ntnet = TRUE
	network_destination = "ship position sensors"
	size = 4
