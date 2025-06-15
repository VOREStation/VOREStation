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

/client/verb/toggle_multilingual_mode()
	set name = "Toggle Multilingual Mode"
	set category = "Preferences.Character"
	set desc = "Toggle the behaviour of multilingual speech parsing."

	prefs.multilingual_mode++
	prefs.multilingual_mode %= MULTILINGUAL_MODE_MAX // Cycles through the various options
	switch(prefs.multilingual_mode)
		if(MULTILINGUAL_DEFAULT)
			to_chat(src, span_filter_system("Multilingual parsing will only check for the delimiter-key combination (,0galcom-2tradeband)."))
		if(MULTILINGUAL_SPACE)
			to_chat(src, span_filter_system("Multilingual parsing will enforce a space after the delimiter-key combination (,0 galcom -2still galcom). The extra space will be consumed by the pattern-matching."))
		if(MULTILINGUAL_DOUBLE_DELIMITER)
			to_chat(src, span_filter_system("Multilingual parsing will enforce the a language delimiter after the delimiter-key combination (,0,galcom -2 still galcom). The extra delimiter will be consumed by the pattern-matching."))
		if(MULTILINGUAL_OFF)
			to_chat(src, span_filter_system("Multilingual parsing is now disabled. Entire messages will be in the language specified at the start of the message."))
