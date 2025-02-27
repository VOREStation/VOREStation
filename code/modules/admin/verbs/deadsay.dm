/client/proc/dsay(msg as text)
	set category = "Admin.Chat"
	set name = "Dsay" //Gave this shit a shorter name so you only have to time out "dsay" rather than "dead say" to use it --NeoFite
	set hidden = 1
	if(!src.holder)
		to_chat(src, "Only administrators may use this command.")
		return
	if(!src.mob)
		return
	if(prefs.muted & MUTE_DEADCHAT)
		to_chat(src, span_warning("You cannot send DSAY messages (muted)."))
		return

	if(!prefs?.read_preference(/datum/preference/toggle/show_dsay))
		to_chat(src, span_warning("You have deadchat muted."))
		return

	var/stafftype = uppertext(holder.rank_names())

	msg = sanitize(msg)
	log_admin("DSAY: [key_name(src)] : [msg]")

	if (!msg)
		return

	say_dead_direct(span_name("[stafftype]([src.holder.fakekey ? src.holder.fakekey : src.key])") + " says, " + span_message("\"[msg]\""))

	feedback_add_details("admin_verb","D") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
