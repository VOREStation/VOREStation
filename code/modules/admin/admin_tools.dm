ADMIN_VERB_ONLY_CONTEXT_MENU(cmd_admin_check_player_logs, R_ADMIN|R_MOD, "Check Player Attack Logs", mob/living/player in  GLOB.mob_list)
	user.show_cmd_admin_check_player_logs(player)

//Views specific attack logs belonging to one player.
/client/proc/show_cmd_admin_check_player_logs(mob/living/M)
	var/dat = span_bold("[M]'s Attack Log:<HR>")
	dat += span_bold("Viewing attack logs of [M]") + " - (Played by ([key_name(M)]).<br>"
	if(M.mind)
		dat += span_bold("Current Antag?:") + " [(M.mind.special_role)?"Yes":"No"]<br>"
	dat += "<br>" + span_bold("Note:") + " This is arranged from earliest to latest. <br><br>"

	if(!SSdbcore.IsConnected())
		if(LAZYLEN(M.attack_log))
			dat += "<fieldset style='border: 2px solid white; display: inline'>"
			for(var/l in M.attack_log)
				dat += "[l]<br>"

			dat += "</fieldset>"

		else
			dat += span_italics("No attack logs found for [M].")

	else
		var/datum/db_query/query = SSdbcore.NewQuery("SELECT id,time,ckey,mob,color,message from erro_attacklog WHERE ckey = :t_ckey", list("t_ckey" = M.ckey))
		if(!query.Execute())
			dat += span_italics("Database query error")
		else
			var/messages = ""
			while(query.NextRow())
				var/message = "[query.item[6]]"
				var/color = "[query.item[5]]"
				if(color)
					if(color[1] == "#")
						message = "<font color=[color]>[message]</font>"
					else
						message = "<font color='[color]'>[message]</font>"
				messages += "([query.item[2]]) (ckey:[query.item[3]] real_name:[query.item[4]]) [message]<br>"

			if(messages=="")
				dat+= span_italics("Query returned nothing.")
			else
				dat += "<fieldset style='border: 2px solid white; display: inline'>"
				dat += messages
				dat += "</fieldset>"
		qdel(query)

	var/datum/browser/popup = new(usr, "admin_attack_log", "[src]", 650, 650, src)
	popup.set_content(jointext(dat,null))
	popup.open()

	onclose(usr, "admin_attack_log")

	feedback_add_details("admin_verb","PL") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

ADMIN_VERB_ONLY_CONTEXT_MENU(cmd_admin_check_dialogue_logs, R_ADMIN|R_MOD, "Check Player Dialogue Logs", mob/living/player in  GLOB.mob_list)
	user.show_cmd_admin_check_dialogue_logs(player)

//Views specific dialogue logs belonging to one player.
/client/proc/show_cmd_admin_check_dialogue_logs(mob/living/M)
	var/dat = span_bold("[M]'s Dialogue Log:<HR>")
	dat += span_bold("Viewing say and emote logs of [M]") + " - (Played by ([key_name(M)]).<br>"
	if(M.mind)
		dat += span_bold("Current Antag?:") + " [(M.mind.special_role)?"Yes":"No"]<br>"
	dat += "<br>" + span_bold("Note:") + " This is arranged from earliest to latest. <br><br>"

	if(!SSdbcore.IsConnected())
		if(LAZYLEN(M.dialogue_log))
			dat += "<fieldset style='border: 2px solid white; display: inline'>"

			for(var/d in M.dialogue_log)
				dat += "[d]<br>"

			dat += "</fieldset>"
		else
			dat += span_italics("No dialogue logs found for [M].")

	else
		var/datum/db_query/query = SSdbcore.NewQuery("SELECT mid,time,ckey,mob,type,color,message from erro_dialog WHERE ckey = :t_ckey", list("t_ckey" = M.ckey))
		if(!query.Execute())
			dat += span_italics("Database query error")
		else
			var/messages = ""
			while(query.NextRow())
				var/message = "[query.item[7]]"
				var/color = "[query.item[6]]"
				if(color)
					if(color[1] == "#")
						message = "<font color=[color]>[message]</font>"
					else
						message = "<font color='[color]'>[message]</font>"
				messages += "([query.item[2]]) (ckey:[query.item[3]] real_name:[query.item[4]] type:[query.item[5]]) [message]<br>"

			if(messages=="")
				dat += span_italics("Query returned nothing.")
			else
				dat += "<fieldset style='border: 2px solid white; display: inline'>"
				dat += messages
				dat += "</fieldset>"
		qdel(query)

	var/datum/browser/popup = new(usr, "admin_dialogue_log", "[src]", 650, 650, src)
	popup.set_content(jointext(dat,null))
	popup.open()

	onclose(usr, "admin_dialogue_log")


	feedback_add_details("admin_verb","PDL") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
