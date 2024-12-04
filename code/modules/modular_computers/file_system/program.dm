// /program/ files are executable programs that do things.
/datum/computer_file/program
	filename = "UnknownProgram"				// File name. FILE NAME MUST BE UNIQUE IF YOU WANT THE PROGRAM TO BE DOWNLOADABLE FROM NTNET!
	filetype = "PRG"

	var/required_access = null				// List of required accesses to run/download the program.
	var/requires_access_to_run = 1			// Whether the program checks for required_access when run.
	var/requires_access_to_download = 1		// Whether the program checks for required_access when downloading.

	// TGUIModule
	var/datum/tgui_module/TM = null			// If the program uses TGUIModule, put it here and it will be automagically opened. Otherwise implement tgui_interact.
	var/tguimodule_path = null				// Path to tguimodule, make sure to set this if implementing new program.
	var/program_state = PROGRAM_STATE_KILLED// PROGRAM_STATE_KILLED or PROGRAM_STATE_BACKGROUND or PROGRAM_STATE_ACTIVE - specifies whether this program is running.
	var/obj/item/modular_computer/computer	// Device that runs this program.

	var/filedesc = "Unknown Program"		// User-friendly name of this program.
	var/extended_desc = "N/A"				// Short description of this program's function.
	/// Category that this program belongs to.
	var/category = PROG_MISC
	var/usage_flags = PROGRAM_ALL			// Bitflags (PROGRAM_CONSOLE, PROGRAM_LAPTOP, PROGRAM_TABLET combination) or PROGRAM_ALL

	var/program_icon_state = null			// Program-specific screen icon state
	var/program_key_state = "standby_key"	// Program-specific keyboard icon state
	var/program_menu_icon = "newwin"		// Icon to use for program's link in main menu
	var/ui_header = null					// Example: "something.gif" - a header image that will be rendered in computer's UI when this program is running at background. Images are taken from /nano/images/status_icons. Be careful not to use too large images!

	var/requires_ntnet = 0					// Set to 1 for program to require nonstop NTNet connection to run. If NTNet connection is lost program crashes.
	var/requires_ntnet_feature = 0			// Optional, if above is set to 1 checks for specific function of NTNet (currently NTNET_SOFTWAREDOWNLOAD, NTNET_PEERTOPEER, NTNET_SYSTEMCONTROL and NTNET_COMMUNICATION)
	var/network_destination = null			// Optional string that describes what NTNet server/system this program connects to. Used in default logging.

	var/ntnet_status = 1					// NTNet status, updated every tick by computer running this program. Don't use this for checks if NTNet works, computers do that. Use this for calculations, etc.
	var/available_on_ntnet = 1				// Whether the program can be downloaded from NTNet. Set to 0 to disable.
	var/available_on_syndinet = 0			// Whether the program can be downloaded from SyndiNet (accessible via emagging the computer). Set to 1 to enable.

	// Misc
	var/computer_emagged = 0				// Set to 1 if computer that's running us was emagged. Computer updates this every Process() tick
	var/ntnet_speed = 0						// GQ/s - current network connectivity transfer rate
	/// Name of the tgui interface
	var/tgui_id

/datum/computer_file/program/New(var/obj/item/modular_computer/comp = null)
	..()
	if(comp && istype(comp))
		computer = comp

/datum/computer_file/program/Destroy()
	computer = null
	. = ..()

/datum/computer_file/program/tgui_host()
	return computer.tgui_host()

/datum/computer_file/program/clone()
	var/datum/computer_file/program/temp = ..()
	temp.required_access = required_access
	temp.filedesc = filedesc
	temp.program_icon_state = program_icon_state
	temp.requires_ntnet = requires_ntnet
	temp.requires_ntnet_feature = requires_ntnet_feature
	temp.usage_flags = usage_flags
	return temp

// Relays icon update to the computer.
/datum/computer_file/program/proc/update_computer_icon()
	if(computer)
		computer.update_icon()

// Attempts to create a log in global ntnet datum. Returns 1 on success, 0 on fail.
/datum/computer_file/program/proc/generate_network_log(var/text)
	if(computer)
		return computer.add_log(text)
	return 0

/datum/computer_file/program/proc/is_supported_by_hardware(var/hardware_flag = 0, var/loud = 0, var/mob/user = null)
	if(!(hardware_flag & usage_flags))
		if(loud && computer && user)
			to_chat(user, span_warning("\The [computer] flashes: \"Hardware Error - Incompatible software\"."))
		return 0
	return 1

/datum/computer_file/program/proc/get_signal(var/specific_action = 0)
	if(computer)
		return computer.get_ntnet_status(specific_action)
	return 0

// Called by Process() on device that runs us, once every tick.
/datum/computer_file/program/proc/process_tick()
	update_netspeed()
	return 1

/datum/computer_file/program/proc/update_netspeed()
	ntnet_speed = 0
	switch(ntnet_status)
		if(1)
			ntnet_speed = NTNETSPEED_LOWSIGNAL
		if(2)
			ntnet_speed = NTNETSPEED_HIGHSIGNAL
		if(3)
			ntnet_speed = NTNETSPEED_ETHERNET

// Check if the user can run program. Only humans can operate computer. Automatically called in run_program()
// User has to wear their ID or have it inhand for ID Scan to work.
// Can also be called manually, with optional parameter being access_to_check to scan the user's ID
/datum/computer_file/program/proc/can_run(var/mob/living/user, var/loud = 0, var/access_to_check)
	// Defaults to required_access
	if(!access_to_check)
		access_to_check = required_access
	if(!access_to_check) // No required_access, allow it.
		return 1

	// Admin override - allows operation of any computer as aghosted admin, as if you had any required access.
	if(istype(user, /mob/observer/dead) && check_rights(R_ADMIN|R_EVENT, 0, user))
		return 1

	if(!istype(user))
		return 0

	var/obj/item/card/id/I = user.GetIdCard()
	if(!I)
		if(loud)
			to_chat(user, span_notice("\The [computer] flashes an \"RFID Error - Unable to scan ID\" warning."))
		return 0

	if(access_to_check in I.GetAccess())
		return 1
	else if(loud)
		to_chat(user, span_notice("\The [computer] flashes an \"Access Denied\" warning."))

// This attempts to retrieve header data for NanoUIs. If implementing completely new device of different type than existing ones
// always include the device here in this proc. This proc basically relays the request to whatever is running the program.
/datum/computer_file/program/proc/get_header_data()
	if(computer)
		return computer.get_header_data()
	return list()

// This is performed on program startup. May be overriden to add extra logic. Remember to include ..() call. Return 1 on success, 0 on failure.
// When implementing new program based device, use this to run the program.
/datum/computer_file/program/proc/run_program(var/mob/living/user)
	if(can_run(user, 1) || !requires_access_to_run)
		computer.active_program = src
		if(tguimodule_path)
			TM = new tguimodule_path(src)
			TM.using_access = user.GetAccess()
		if(requires_ntnet && network_destination)
			generate_network_log("Connection opened to [network_destination].")
		program_state = PROGRAM_STATE_ACTIVE
		return 1
	return 0

// Use this proc to kill the program. Designed to be implemented by each program if it requires on-quit logic, such as the NTNRC client.
/datum/computer_file/program/proc/kill_program(var/forced = 0)
	program_state = PROGRAM_STATE_KILLED
	if(network_destination)
		generate_network_log("Connection to [network_destination] closed.")
	if(TM)
		SStgui.close_uis(TM)
	QDEL_NULL(TM)
	return 1

/datum/computer_file/program/ui_assets(mob/user)
	return list(
		get_asset_datum(/datum/asset/simple/headers)
	)

/datum/computer_file/program/tgui_interact(mob/user, datum/tgui/ui)
	if(program_state != PROGRAM_STATE_ACTIVE)
		if(ui)
			ui.close()
		return computer.tgui_interact(user)
	if(istype(TM))
		TM.tgui_interact(user)
		return 0
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui && tgui_id)
		ui = new(user, src, tgui_id, filedesc)
		ui.open()
	return 1

// CONVENTIONS, READ THIS WHEN CREATING NEW PROGRAM AND OVERRIDING THIS PROC:
// Topic calls are automagically forwarded from NanoModule this program contains.
// Calls beginning with "PRG_" are reserved for programs handling.
// Calls beginning with "PC_" are reserved for computer handling (by whatever runs the program)
// ALWAYS INCLUDE PARENT CALL ..() OR DIE IN FIRE.
/datum/computer_file/program/Topic(href, href_list)
	if(..())
		return 1
	if(computer)
		return computer.Topic(href, href_list)

// CONVENTIONS, READ THIS WHEN CREATING NEW PROGRAM AND OVERRIDING THIS PROC:
// Topic calls are automagically forwarded from NanoModule this program contains.
// Calls beginning with "PRG_" are reserved for programs handling.
// Calls beginning with "PC_" are reserved for computer handling (by whatever runs the program)
// ALWAYS INCLUDE PARENT CALL ..() OR DIE IN FIRE.
/datum/computer_file/program/tgui_act(action,list/params, datum/tgui/ui)
	if(..())
		return 1
	if(computer)
		switch(action)
			if("PC_exit")
				computer.kill_program()
				ui.close()
				return 1
			if("PC_shutdown")
				computer.shutdown_computer()
				ui.close()
				return 1
			if("PC_minimize")
				if(!computer.active_program)
					return

				computer.idle_threads.Add(computer.active_program)
				program_state = PROGRAM_STATE_BACKGROUND // Should close any existing UIs

				computer.active_program = null
				computer.update_icon()
				ui.close()

				if(ui.user && istype(ui.user))
					computer.tgui_interact(ui.user) // Re-open the UI on this computer. It should show the main screen now.



// Relays the call to nano module, if we have one
/datum/computer_file/program/proc/check_eye(var/mob/user)
	if(TM)
		return TM.check_eye(user)
	else
		return -1

/datum/computer_file/program/apply_visual(mob/M)
	if(TM)
		return TM.apply_visual(M)

/datum/computer_file/program/remove_visual(mob/M)
	if(TM)
		return TM.remove_visual(M)

/datum/computer_file/program/proc/relaymove(var/mob/M, direction)
	if(TM)
		return TM.relaymove(M, direction)
