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

/client/verb/toggle_chat_timestamps()
	set name = "Toggle Chat Timestamps"
	set category = "Preferences.Chat"
	set desc = "Toggles whether or not messages in chat will display timestamps. Enabling this will not add timestamps to messages that have already been sent."

	prefs.chat_timestamp = !prefs.chat_timestamp	//There is no preference datum for tgui input lock, nor for any TGUI prefs.
	SScharacter_setup.queue_preferences_save(prefs)

	to_chat(src, span_notice("You have toggled chat timestamps: [prefs.chat_timestamp ? "ON" : "OFF"]."))

// Not attached to a pref datum because those are strict binary toggles
/client/verb/toggle_examine_mode()
	set name = "Toggle Examine Mode"
	set category = "Preferences.Game"
	set desc = "Toggle the additional behaviour of examining things."

	prefs.examine_text_mode++
	prefs.examine_text_mode %= EXAMINE_MODE_MAX // This cycles through them because if you're already specifically being routed to the examine panel, you probably don't need to have the extra text printed to chat
	switch(prefs.examine_text_mode)				// ... And I only wanted to add one verb
		if(EXAMINE_MODE_DEFAULT)
			to_chat(src, span_filter_system("Examining things will only output the base examine text, and you will not be redirected to the examine panel automatically."))

		if(EXAMINE_MODE_INCLUDE_USAGE)
			to_chat(src, span_filter_system("Examining things will also print any extra usage information normally included in the examine panel to the chat."))

		if(EXAMINE_MODE_SWITCH_TO_PANEL)
			to_chat(src, span_filter_system("Examining things will direct you to the examine panel, where you can view extended information about the thing."))

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
