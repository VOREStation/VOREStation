//Allows some list search inputs
/client/proc/tgui_admin_lists()
	set name = "TGUI Admin Lists"
	set desc = "Allows to have some procs with searchable lists."
	set category = "Admin.Game"
	if(!check_rights(R_ADMIN|R_EVENT))
		return

	var/list/modification_options = list(TGUI_VIEW_ATTACK_LOGS, TGUI_VIEW_DIALOG_LOGS, TGUI_RESIZE)


	var/tgui_list_choice = tgui_input_list(src, "Select the verb you would like to use with a tgui input","Choice", modification_options)
	if(!tgui_list_choice || tgui_list_choice == "Cancel")
		return

	log_and_message_admins("[key_name(src)] has used TGUI Admin Lists with ([tgui_list_choice])].")
	feedback_add_details("admin_verb","TGUIADL") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

	switch(tgui_list_choice)
		if(TGUI_VIEW_ATTACK_LOGS)
			var/mob/living/L = tgui_input_list(src, "Check a player's attack logs.", "Check Player Attack Logs", GLOB.mob_list)
			show_cmd_admin_check_player_logs(L)
		if(TGUI_VIEW_DIALOG_LOGS)
			var/mob/living/L = tgui_input_list(src, "Check a player's dialogue logs.", "Check Player Dialogue Logs", GLOB.mob_list)
			show_cmd_admin_check_dialogue_logs(L)
		if(TGUI_RESIZE)
			var/mob/living/L = tgui_input_list(src, "Resizes any living mob without any restrictions on size.", "Resize", GLOB.mob_list)
			if(L)
				do_resize(L)
