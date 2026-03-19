/datum/computer_file/program/bytecrawl
	filename = "bytecrawl"
	filedesc = "BYTECRAWL"
	extended_desc = "A CLI hacking idle terminal. Run crack jobs, sell stolen data, upgrade your rig."
	size = 3
	requires_ntnet = FALSE
	available_on_ntnet = TRUE
	tgui_id = "NtosBytecrawl"
	program_icon_state = "generic"
	usage_flags = PROGRAM_ALL

/datum/computer_file/program/bytecrawl/tgui_data(mob/user)
	. = get_header_data()

/datum/computer_file/program/bytecrawl/tgui_act(action, list/params, datum/tgui/ui)
	. = ..()
	if(.)
		return
	if(action == "init")
		var/h = params["handle"]
		if(!istext(h) || !length(h))
			return FALSE
		. = TRUE
