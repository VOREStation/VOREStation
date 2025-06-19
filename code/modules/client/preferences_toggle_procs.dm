//Toggles for preferences, normal clients
/client/verb/toggle_be_special(role in be_special_flags)
	set name = "Toggle Special Role Candidacy"
	set category = "Preferences.Character"
	set desc = "Toggles which special roles you would like to be a candidate for, during events."

	var/role_flag = be_special_flags[role]
	if(!role_flag)	return

	prefs.be_special ^= role_flag
	SScharacter_setup.queue_preferences_save(prefs)

	to_chat(src,"You will [(prefs.be_special & role_flag) ? "now" : "no longer"] be considered for [role] events (where possible).")

	feedback_add_details("admin_verb","TBeSpecial") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
