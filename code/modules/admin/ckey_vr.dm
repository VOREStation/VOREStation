// Command to set the ckey of a mob without requiring VV permission
/client/proc/SetCKey(var/mob/M in mob_list)
	set category = "Admin"
	set name = "Set CKey"
	set desc = "Mob to teleport"
	if(!src.holder)
		to_chat(src, "Only administrators may use this command.")
		return

	var/list/keys = list()
	for(var/mob/playerMob in player_list)
		keys += playerMob.client
	var/client/selection = tgui_input_list(usr, "Please, select a player!", "Set CKey", sortKey(keys))
	if(!selection || !istype(selection))
		return

	log_admin("[key_name(usr)] set ckey of [key_name(M)] to [selection]")
	message_admins("[key_name_admin(usr)] set ckey of [key_name_admin(M)] to [selection]", 1)
	M.ckey = selection.ckey
	feedback_add_details("admin_verb","SCK") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
