/client/proc/cmd_admin_say(msg as text)
	set category = "Special Verbs"
	set name = "Asay" //Gave this shit a shorter name so you only have to time out "asay" rather than "admin say" to use it --NeoFite
	set hidden = 1
	if(!check_rights(R_ADMIN)) //VOREStation Edit
		return

	msg = sanitize(msg)
	if(!msg)
		return

	log_adminsay(msg,src)

	for(var/client/C in GLOB.admins)
		if(check_rights(R_ADMIN, 0, C))
			to_chat(C, span_admin_channel(create_text_tag("admin", "ADMIN:", C) + " " + span_name("[key_name(usr, 1)]") + "([admin_jump_link(mob, src)]): " + span_name("[msg]") ))

	feedback_add_details("admin_verb","M") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/cmd_mod_say(msg as text)
	set category = "Special Verbs"
	set name = "Msay"
	set hidden = 1

	if(!check_rights(R_ADMIN|R_MOD|R_SERVER)) //VOREStation Edit
		return

	msg = sanitize(msg)
	log_modsay(msg,src)

	if (!msg)
		return

	var/sender_name = key_name(usr, 1)
	if(check_rights(R_ADMIN, 0))
		sender_name = span_admin("[sender_name]")
	for(var/client/C in GLOB.admins)
		if(check_rights(R_ADMIN|R_MOD|R_SERVER)) //VOREStation Edit
			to_chat(C, span_mod_channel(create_text_tag("mod", "MOD:", C) + " " + span_name("[sender_name]") + "([admin_jump_link(mob, C.holder)]): " + span_name("[msg]") ))

	feedback_add_details("admin_verb","MS") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/cmd_event_say(msg as text)
	set category = "Special Verbs"
	set name = "Esay"
	set hidden = 1

	if(!check_rights(R_ADMIN|R_MOD|R_EVENT|R_SERVER)) //VOREStation Edit
		return

	msg = sanitize(msg)
	log_eventsay(msg,src)

	if (!msg)
		return

	var/sender_name = key_name(usr, 1)
	if(check_rights(R_ADMIN, 0))
		sender_name = span_admin("[sender_name]")
	for(var/client/C in GLOB.admins)
		to_chat(C, span_event_channel(create_text_tag("event", "EVENT:", C) + " " + span_name("[sender_name]") + "([admin_jump_link(mob, C.holder)]): " + span_name("[msg]") ))

	feedback_add_details("admin_verb","GS") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
