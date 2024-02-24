/datum/computer_file/program/email_client
	filename = "emailc"
	filedesc = "Email Client"
	extended_desc = "This program may be used to log in into your email account."
	program_icon_state = "generic"
	program_key_state = "generic_key"
	program_menu_icon = "mail-closed"
	size = 7
	requires_ntnet = TRUE
	available_on_ntnet = TRUE
	var/stored_login = ""
	var/stored_password = ""
	usage_flags = PROGRAM_ALL
	category = PROG_OFFICE

	tguimodule_path = /datum/tgui_module/email_client

// Persistency. Unless you log out, or unless your password changes, this will pre-fill the login data when restarting the program
/datum/computer_file/program/email_client/kill_program()
	if(TM)
		var/datum/tgui_module/email_client/TME = TM
		if(TME.current_account)
			stored_login = TME.stored_login
			stored_password = TME.stored_password
		else
			stored_login = ""
			stored_password = ""
	. = ..()

/datum/computer_file/program/email_client/run_program()
	. = ..()
	if(TM)
		var/datum/tgui_module/email_client/TME = TM
		TME.stored_login = stored_login
		TME.stored_password = stored_password
		TME.log_in()
		TME.error = ""
		TME.check_for_new_messages(1)

/datum/computer_file/program/email_client/proc/new_mail_notify()
	var/turf/T = get_turf(computer) // Because visible_message is being a butt
	if(T)
		T.visible_message("<span class='notice'>[computer] beeps softly, indicating a new email has been received.</span>")
	playsound(computer, 'sound/misc/server-ready.ogg', 100, 0)

/datum/computer_file/program/email_client/process_tick()
	..()
	var/datum/tgui_module/email_client/TME = TM
	if(!istype(TME))
		return
	TME.relayed_process(ntnet_speed)

	var/check_count = TME.check_for_new_messages()
	if(check_count)
		if(check_count == 2)
			new_mail_notify()
		ui_header = "ntnrc_new.gif"
	else
		ui_header = "ntnrc_idle.gif"
