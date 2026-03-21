ADMIN_VERB(dsay, R_HOLDER, "Dsay", "Speak to the dead.", ADMIN_CATEGORY_CHAT, msg as text)
	if(user.prefs.muted & MUTE_DEADCHAT)
		to_chat(user, span_warning("You cannot send DSAY messages (muted)."))
		return

	if(!user.prefs?.read_preference(/datum/preference/toggle/show_dsay))
		to_chat(user, span_warning("You have deadchat muted."))
		return

	var/stafftype = uppertext(user.holder.rank_names())

	msg = sanitize(msg)
	log_admin("DSAY: [key_name(user)] : [msg]")

	if (!msg)
		return

	say_dead_direct(span_name("[stafftype]([user.holder.fakekey ? user.holder.fakekey : user.key])") + " says, " + span_message("\"[msg]\""))

	feedback_add_details("admin_verb","D") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
