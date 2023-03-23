/datum/computer_file/program/rcon_console
	filename = "rconconsole"
	filedesc = "RCON Remote Control"
	tguimodule_path = /datum/tgui_module/rcon/ntos
	program_icon_state = "generic"
	program_key_state = "rd_key"
	program_menu_icon = "power"
	extended_desc = "This program allows remote control of power distribution systems. This program can not be run on tablet computers."
	required_access = access_engine
	requires_ntnet = TRUE
	network_destination = "RCON remote control system"
	requires_ntnet_feature = NTNET_SYSTEMCONTROL
	usage_flags = PROGRAM_LAPTOP | PROGRAM_CONSOLE
	size = 19
	category = PROG_ENG
