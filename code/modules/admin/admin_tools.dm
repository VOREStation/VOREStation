ADMIN_VERB(cmd_admin_check_player_logs, R_ADMIN|R_MOD|R_EVENT, "Check Player Attack Logs", "Check a player's attack logs.", ADMIN_CATEGORY_LOGS, mob/living/living_mob in GLOB.mob_list)
	user.show_cmd_admin_check_player_logs(living_mob)

//Views specific attack logs belonging to one player.
/client/proc/show_cmd_admin_check_player_logs(mob/living/M)
	var/dat = span_bold("[M]'s Attack Log:<HR>")
	dat += span_bold("Viewing attack logs of [M]") + " - (Played by ([key_name(M)]).<br>"
	if(M.mind)
		dat += span_bold("Current Antag?:") + " [(M.mind.special_role)?"Yes":"No"]<br>"
	dat += "<br>" + span_bold("Note:") + " This is arranged from earliest to latest. <br><br>"


	if(!isemptylist(M.attack_log))
		dat += "<fieldset style='border: 2px solid white; display: inline'>"
		for(var/l in M.attack_log)
			dat += "[l]<br>"

		dat += "</fieldset>"

	else
		dat += span_italics("No attack logs found for [M].")

	var/datum/browser/popup = new(src, "admin_attack_log", "[src]", 650, 650, src)
	popup.set_content(jointext(dat,null))
	popup.open()

	onclose(src, "admin_attack_log")

	feedback_add_details("admin_verb","PL") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/cmd_admin_check_dialogue_logs(mob/living/M as mob in GLOB.mob_list)
	set category = "Admin.Logs"
	set name = "Check Player Dialogue Logs"
	set desc = "Check a player's dialogue logs."
	show_cmd_admin_check_dialogue_logs(M)

//Views specific dialogue logs belonging to one player.
/client/proc/show_cmd_admin_check_dialogue_logs(mob/living/M)
	var/dat = span_bold("[M]'s Dialogue Log:<HR>")
	dat += span_bold("Viewing say and emote logs of [M]") + " - (Played by ([key_name(M)]).<br>"
	if(M.mind)
		dat += span_bold("Current Antag?:") + " [(M.mind.special_role)?"Yes":"No"]<br>"
	dat += "<br>" + span_bold("Note:") + " This is arranged from earliest to latest. <br><br>"

	if(!isemptylist(M.dialogue_log))
		dat += "<fieldset style='border: 2px solid white; display: inline'>"

		for(var/d in M.dialogue_log)
			dat += "[d]<br>"

		dat += "</fieldset>"
	else
		dat += span_italics("No dialogue logs found for [M].")
	var/datum/browser/popup = new(usr, "admin_dialogue_log", "[src]", 650, 650, src)
	popup.set_content(jointext(dat,null))
	popup.open()

	onclose(usr, "admin_dialogue_log")


	feedback_add_details("admin_verb","PDL") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
