ADMIN_VERB(cmd_admin_say, R_ADMIN, "ASay", "Send a message to other admins", "Admin.Chat", message as text)
	var/msg = sanitize(message)
	if(!msg)
		return

	log_adminsay(msg, user)

	for(var/client/C in GLOB.admins)
		if(check_rights_for(C, R_ADMIN))
			to_chat(C, span_admin_channel(create_text_tag("admin", "ADMIN:", C) + " " + span_name("[key_name(user, 1)]") + "([admin_jump_link(user.mob, C.holder)]): " + span_name("[msg]") ))

	feedback_add_details("admin_verb","M") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

ADMIN_VERB(cmd_mod_say, (R_ADMIN|R_MOD|R_SERVER), "Msay", "Send a message to other mod", "Admin.Chat", message as text)
	var/msg = sanitize(message)
	log_modsay(msg, user)

	if (!msg)
		return

	var/sender_name = key_name(user, 1)
	if(check_rights(R_ADMIN, 0))
		sender_name = span_admin("[sender_name]")
	for(var/client/C in GLOB.admins)
		if(check_rights(R_ADMIN|R_MOD|R_SERVER)) //VOREStation Edit
			to_chat(C, span_mod_channel(create_text_tag("mod", "MOD:", C) + " " + span_name("[sender_name]") + "([admin_jump_link(user.mob, C.holder)]): " + span_name("[msg]") ))

	feedback_add_details("admin_verb","MS") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

ADMIN_VERB(cmd_event_say, (R_ADMIN|R_MOD|R_EVENT|R_SERVER), "Esay", "Send a message to other event manager", "Admin.Chat", message as text)
	var/msg = sanitize(message)
	log_eventsay(msg, user)

	if (!msg)
		return

	var/sender_name = key_name(user, 1)
	if(check_rights(R_ADMIN, 0))
		sender_name = span_admin("[sender_name]")
	for(var/client/C in GLOB.admins)
		to_chat(C, span_event_channel(create_text_tag("event", "EVENT:", C) + " " + span_name("[sender_name]") + "([admin_jump_link(user.mob, C.holder)]): " + span_name("[msg]") ))

	feedback_add_details("admin_verb","GS") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

ADMIN_VERB(cmd_mentor_say, (R_ADMIN|R_MOD|R_EVENT|R_SERVER|R_MENTOR), "Mentorsay", "Send a message to other mentors", "Admin.Chat", message as text)
	var/msg = sanitize(message)
	if (!msg)
		return

	log_admin("Mentorsay: [key_name(user)]: [msg]")

	for(var/client/C in GLOB.admins)
		to_chat(C, create_text_tag("mentor", "MENTOR:", C) + " " + span_mentor_channel(span_name("[user]") + ": " + span_message("[msg]")))
