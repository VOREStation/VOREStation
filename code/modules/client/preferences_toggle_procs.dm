//Toggles for preferences, normal clients
/client/verb/toggle_ghost_ears()
	set name = "Toggle Ghost Ears"
	set category = "Preferences"
	set desc = "Toggles between seeing all mob speech and only nearby mob speech as an observer."

	var/pref_path = /datum/client_preference/ghost_ears

	toggle_preference(pref_path)

	to_chat(src,"You will [ (is_preference_enabled(pref_path)) ? "now" : "no longer"] hear all mob speech as a ghost.")

	SScharacter_setup.queue_preferences_save(prefs)

	feedback_add_details("admin_verb","TGEars") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/verb/toggle_ghost_vision()
	set name = "Toggle Ghost Sight"
	set category = "Preferences"
	set desc = "Toggles between seeing all mob emotes and only nearby mob emotes as an observer."

	var/pref_path = /datum/client_preference/ghost_sight

	toggle_preference(pref_path)

	to_chat(src,"You will [ (is_preference_enabled(pref_path)) ? "now" : "no longer"] see all emotes as a ghost.")

	SScharacter_setup.queue_preferences_save(prefs)

	feedback_add_details("admin_verb","TGVision") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/verb/toggle_ghost_radio()
	set name = "Toggle Ghost Radio"
	set category = "Preferences"
	set desc = "Toggles between seeing all radio chat and only nearby radio chatter as an observer."

	var/pref_path = /datum/client_preference/ghost_radio

	toggle_preference(pref_path)

	to_chat(src,"You will [ (is_preference_enabled(pref_path)) ? "now" : "no longer"] hear all radios as a ghost.")

	SScharacter_setup.queue_preferences_save(prefs)

	feedback_add_details("admin_verb","TGRadio") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/verb/toggle_deadchat()
	set name = "Toggle Deadchat"
	set category = "Preferences"
	set desc = "Toggles visibility of dead chat."

	var/pref_path = /datum/client_preference/show_dsay

	toggle_preference(pref_path)

	to_chat(src,"You will [ (is_preference_enabled(pref_path)) ? "now" : "no longer"] hear dead chat as a ghost.")

	SScharacter_setup.queue_preferences_save(prefs)

	feedback_add_details("admin_verb","TDeadChat") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/verb/toggle_ooc()
	set name = "Toggle OOC"
	set category = "Preferences"
	set desc = "Toggles visibility of global out of character chat."

	var/pref_path = /datum/client_preference/show_ooc

	toggle_preference(pref_path)

	to_chat(src,"You will [ (is_preference_enabled(/datum/client_preference/show_ooc)) ? "now" : "no longer"] hear global out of character chat.")

	SScharacter_setup.queue_preferences_save(prefs)

	feedback_add_details("admin_verb","TOOC") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/verb/toggle_looc()
	set name = "Toggle LOOC"
	set category = "Preferences"
	set desc = "Toggles visibility of local out of character chat."

	var/pref_path = /datum/client_preference/show_looc

	toggle_preference(pref_path)

	to_chat(src,"You will [ (is_preference_enabled(pref_path)) ? "now" : "no longer"] hear local out of character chat.")

	SScharacter_setup.queue_preferences_save(prefs)

	feedback_add_details("admin_verb","TLOOC") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/verb/toggle_precision_placement()
	set name = "Toggle Precision Placement"
	set category = "Preferences"
	set desc = "Toggles whether objects placed on table will be on cursor position or centered."

	var/pref_path = /datum/client_preference/precision_placement

	toggle_preference(pref_path)

	to_chat(src,"You will [ (is_preference_enabled(pref_path)) ? "now" : "no longer"] place items where your cursor is on the table.")

	SScharacter_setup.queue_preferences_save(prefs)

	feedback_add_details("admin_verb","TPIP") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/verb/toggle_typing()
	set name = "Toggle Typing Indicator"
	set category = "Preferences"
	set desc = "Toggles you having the speech bubble typing indicator."

	var/pref_path = /datum/client_preference/show_typing_indicator

	toggle_preference(pref_path)

	to_chat(src,"You will [ (is_preference_enabled(pref_path)) ? "now" : "no longer"] have the speech indicator.")

	SScharacter_setup.queue_preferences_save(prefs)

	feedback_add_details("admin_verb","TTIND") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/verb/toggle_ahelp_sound()
	set name = "Toggle Admin Help Sound"
	set category = "Preferences"
	set desc = "Toggles the ability to hear a noise broadcasted when you get an admin message."

	var/pref_path = /datum/client_preference/holder/play_adminhelp_ping

	toggle_preference(pref_path)

	to_chat(src,"You will [ (is_preference_enabled(pref_path)) ? "now" : "no longer"] receive noise from admin messages.")

	SScharacter_setup.queue_preferences_save(prefs)

	feedback_add_details("admin_verb","TAHelp") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/verb/toggle_lobby_music()
	set name = "Toggle Lobby Music"
	set category = "Preferences"
	set desc = "Toggles the ability to hear the music in the lobby."

	var/pref_path = /datum/client_preference/play_lobby_music

	toggle_preference(pref_path)

	to_chat(src,"You will [ (is_preference_enabled(pref_path)) ? "now" : "no longer"] hear music in the lobby.")

	SScharacter_setup.queue_preferences_save(prefs)

	feedback_add_details("admin_verb","TLobMusic") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/verb/toggle_admin_midis()
	set name = "Toggle Admin Music"
	set category = "Preferences"
	set desc = "Toggles the ability to hear music played by admins."

	var/pref_path = /datum/client_preference/play_admin_midis

	toggle_preference(pref_path)

	to_chat(src,"You will [ (is_preference_enabled(pref_path)) ? "now" : "no longer"] hear music from admins.")

	SScharacter_setup.queue_preferences_save(prefs)

	feedback_add_details("admin_verb","TAMidis") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/verb/toggle_ambience()
	set name = "Toggle Ambience"
	set category = "Preferences"
	set desc = "Toggles the ability to hear local ambience."

	var/pref_path = /datum/client_preference/play_ambiance

	toggle_preference(pref_path)

	to_chat(src,"You will [ (is_preference_enabled(pref_path)) ? "now" : "no longer"] hear ambient noise.")

	SScharacter_setup.queue_preferences_save(prefs)

	feedback_add_details("admin_verb","TAmbience") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/verb/toggle_weather_sounds()
	set name = "Toggle Weather Sounds"
	set category = "Preferences"
	set desc = "Toggles the ability to hear weather sounds while on a planet."

	var/pref_path = /datum/client_preference/weather_sounds

	toggle_preference(pref_path)

	to_chat(src,"You will [ (is_preference_enabled(pref_path)) ? "now" : "no longer"] hear weather sounds.")

	SScharacter_setup.queue_preferences_save(prefs)

	feedback_add_details("admin_verb","TWeatherSounds") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/verb/toggle_supermatter_hum()
	set name = "Toggle SM Hum" // Avoiding using the full 'Supermatter' name to not conflict with the Setup-Supermatter adminverb.
	set category = "Preferences"
	set desc = "Toggles the ability to hear supermatter hums."

	var/pref_path = /datum/client_preference/supermatter_hum

	toggle_preference(pref_path)

	to_chat(src,"You will [ (is_preference_enabled(pref_path)) ? "now" : "no longer"] hear a hum from the supermatter.")

	SScharacter_setup.queue_preferences_save(prefs)

	feedback_add_details("admin_verb","TSupermatterHum") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/verb/toggle_jukebox()
	set name = "Toggle Jukebox"
	set category = "Preferences"
	set desc = "Toggles the ability to hear jukebox music."

	var/pref_path = /datum/client_preference/play_jukebox

	toggle_preference(pref_path)

	to_chat(src, "You will [ (is_preference_enabled(pref_path)) ? "now" : "no longer"] hear jukebox music.")

	SScharacter_setup.queue_preferences_save(prefs)

	feedback_add_details("admin_verb","TJukebox") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/verb/toggle_be_special(role in be_special_flags)
	set name = "Toggle Special Role Candidacy"
	set category = "Preferences"
	set desc = "Toggles which special roles you would like to be a candidate for, during events."

	var/role_flag = be_special_flags[role]
	if(!role_flag)	return

	prefs.be_special ^= role_flag
	SScharacter_setup.queue_preferences_save(prefs)

	to_chat(src,"You will [(prefs.be_special & role_flag) ? "now" : "no longer"] be considered for [role] events (where possible).")

	feedback_add_details("admin_verb","TBeSpecial") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/verb/toggle_air_pump_hum()
	set name = "Toggle Air Vent Noise"
	set category = "Preferences"
	set desc = "Toggles the ability to hear air vent humming."

	var/pref_path = /datum/client_preference/air_pump_noise

	toggle_preference(pref_path)

	to_chat(src, "You will [ (is_preference_enabled(pref_path)) ? "now" : "no longer"] hear air vents hum, start, and stop.")

	SScharacter_setup.queue_preferences_save(prefs)

	feedback_add_details("admin_verb","TAirPumpNoise")

/client/verb/toggle_old_door_sounds()
	set name = "Toggle Old Door Sounds"
	set category = "Preferences"
	set desc = "Toggles door sounds between old and new."

	var/pref_path = /datum/client_preference/old_door_sounds

	toggle_preference(pref_path)

	to_chat(src, "You will [ (is_preference_enabled(pref_path)) ? "now" : "no longer"] hear the legacy door sounds.")

	SScharacter_setup.queue_preferences_save(prefs)

	feedback_add_details("admin_verb","TOldDoorSounds")

/client/verb/toggle_department_door_sounds()
	set name = "Toggle Department Door Sounds"
	set category = "Preferences"
	set desc = "Toggles hearing of department-specific door sounds."

	var/pref_path = /datum/client_preference/department_door_sounds

	toggle_preference(pref_path)

	to_chat(src, "You will [ (is_preference_enabled(pref_path)) ? "now" : "no longer"] hear per-department door sounds.")

	SScharacter_setup.queue_preferences_save(prefs)

	feedback_add_details("admin_verb","TDepartmentDoorSounds")

/client/verb/toggle_pickup_sounds()
	set name = "Toggle Picked Up Item Sounds"
	set category = "Preferences"
	set desc = "Toggles the ability to hear sounds when items are picked up."

	var/pref_path = /datum/client_preference/pickup_sounds

	toggle_preference(pref_path)

	to_chat(src, "You will [ (is_preference_enabled(pref_path)) ? "now" : "no longer"] hear sounds when items are picked up.")

	SScharacter_setup.queue_preferences_save(prefs)

	feedback_add_details("admin_verb", "TPickupSounds")

/client/verb/toggle_drop_sounds()
	set name = "Toggle Dropped Item Sounds"
	set category = "Preferences"
	set desc = "Toggles the ability to hear sounds when items are dropped or thrown."

	var/pref_path = /datum/client_preference/drop_sounds

	toggle_preference(pref_path)

	to_chat(src, "You will [ (is_preference_enabled(pref_path)) ? "now" : "no longer"] hear sounds when items are dropped or thrown.")

	SScharacter_setup.queue_preferences_save(prefs)

	feedback_add_details("admin_verb", "TDropSounds")

/client/verb/toggle_safe_firing()
	set name = "Toggle Gun Firing Intent Requirement"
	set category = "Preferences"
	set desc = "Toggles between safe and dangerous firing. Safe requires a non-help intent to fire, dangerous can be fired on help intent."

	var/pref_path = /datum/client_preference/safefiring
	toggle_preference(pref_path)
	SScharacter_setup.queue_preferences_save(prefs)

	to_chat(src,"You will now use [(is_preference_enabled(/datum/client_preference/safefiring)) ? "safe" : "dangerous"] firearms firing.")

	feedback_add_details("admin_verb","TFiringMode") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/verb/toggle_mob_tooltips()
	set name = "Toggle Mob Tooltips"
	set category = "Preferences"
	set desc = "Toggles displaying name/species over mobs when they are moused over."

	var/pref_path = /datum/client_preference/mob_tooltips
	toggle_preference(pref_path)
	SScharacter_setup.queue_preferences_save(prefs)

	to_chat(src,"You will now [(is_preference_enabled(/datum/client_preference/mob_tooltips)) ? "see" : "not see"] mob tooltips.")

	feedback_add_details("admin_verb","TMobTooltips") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/verb/toggle_inv_tooltips()
	set name = "Toggle Item Tooltips"
	set category = "Preferences"
	set desc = "Toggles displaying name/desc over items when they are moused over (only applies in inventory)."

	var/pref_path = /datum/client_preference/inv_tooltips
	toggle_preference(pref_path)
	SScharacter_setup.queue_preferences_save(prefs)

	to_chat(src,"You will now [(is_preference_enabled(/datum/client_preference/inv_tooltips)) ? "see" : "not see"] inventory tooltips.")

	feedback_add_details("admin_verb","TInvTooltips") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/verb/toggle_hear_instruments()
	set name = "Toggle Hear/Ignore Instruments"
	set category = "Preferences"
	set desc = "Toggles the ability to hear instruments playing."

	var/pref_path = /datum/client_preference/instrument_toggle
	toggle_preference(pref_path)
	SScharacter_setup.queue_preferences_save(prefs)

	to_chat(src, "You will now [(is_preference_enabled(/datum/client_preference/instrument_toggle)) ? "hear" : "not hear"] instruments being played.")

	feedback_add_details("admin_verb","THInstm") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/verb/toggle_vchat()
	set name = "Toggle VChat"
	set category = "Preferences"
	set desc = "Toggles VChat. Reloading VChat and/or reconnecting required to affect changes."

	var/pref_path = /datum/client_preference/vchat_enable
	toggle_preference(pref_path)
	SScharacter_setup.queue_preferences_save(prefs)

	to_chat(src, "You have toggled VChat [is_preference_enabled(pref_path) ? "on" : "off"]. \
		You will have to reload VChat and/or reconnect to the server for these changes to take place. \
		VChat message persistence is not guaranteed if you change this again before the start of the next round.")

/client/verb/toggle_status_indicators()
	set name = "Toggle Status Indicators"
	set category = "Preferences"
	set desc = "Toggles seeing status indicators over peoples' heads."

	var/pref_path = /datum/client_preference/status_indicators
	toggle_preference(pref_path)
	SScharacter_setup.queue_preferences_save(prefs)

	to_chat(src, "You will now [(is_preference_enabled(/datum/client_preference/status_indicators)) ? "see" : "not see"] status indicators.")

	feedback_add_details("admin_verb","TStatusIndicators")


/client/verb/toggle_radio_sounds()
	set name = "Toggle Radio Sounds"
	set category = "Preferences"
	set desc = "Toggle hearing a sound when somebody speaks over your headset."

	var/pref_path = /datum/client_preference/radio_sounds
	toggle_preference(pref_path)
	SScharacter_setup.queue_preferences_save(prefs)

	to_chat(src, "You will now [(is_preference_enabled(/datum/client_preference/radio_sounds)) ? "hear" : "not hear"] radio sounds.")

	feedback_add_details("admin_verb","TRadioSounds")

/client/verb/toggle_say_sounds()
	set name = "Sound-Toggle-Say"
	set category = "Preferences"
	set desc = "Toggle hearing a sound when somebody speaks using say."

	var/pref_path = /datum/client_preference/say_sounds
	toggle_preference(pref_path)
	SScharacter_setup.queue_preferences_save(prefs)

	to_chat(src, "You will now [(is_preference_enabled(/datum/client_preference/say_sounds)) ? "hear" : "not hear"] say sounds.")

	feedback_add_details("admin_verb","TSaySounds")

/client/verb/toggle_emote_sounds()
	set name = "Sound-Toggle-Me"
	set category = "Preferences"
	set desc = "Toggle hearing a sound when somebody speaks using me ."

	var/pref_path = /datum/client_preference/emote_sounds
	toggle_preference(pref_path)
	SScharacter_setup.queue_preferences_save(prefs)

	to_chat(src, "You will now [(is_preference_enabled(/datum/client_preference/emote_sounds)) ? "hear" : "not hear"] me sounds.")

	feedback_add_details("admin_verb","TMeSounds")

/client/verb/toggle_whisper_sounds()
	set name = "Sound-Toggle-Whisper"
	set category = "Preferences"
	set desc = "Toggle hearing a sound when somebody speaks using whisper."

	var/pref_path = /datum/client_preference/whisper_sounds
	toggle_preference(pref_path)
	SScharacter_setup.queue_preferences_save(prefs)

	to_chat(src, "You will now [(is_preference_enabled(/datum/client_preference/whisper_sounds)) ? "hear" : "not hear"] whisper sounds.")

	feedback_add_details("admin_verb","TWhisperSounds")

/client/verb/toggle_subtle_sounds()
	set name = "Sound-Toggle-Subtle"
	set category = "Preferences"
	set desc = "Toggle hearing a sound when somebody uses subtle."

	var/pref_path = /datum/client_preference/subtle_sounds
	toggle_preference(pref_path)
	SScharacter_setup.queue_preferences_save(prefs)

	to_chat(src, "You will now [(is_preference_enabled(/datum/client_preference/subtle_sounds)) ? "hear" : "not hear"] subtle sounds.")

	feedback_add_details("admin_verb","TSubtleSounds")

// Not attached to a pref datum because those are strict binary toggles
/client/verb/toggle_examine_mode()
	set name = "Toggle Examine Mode"
	set category = "Preferences"
	set desc = "Toggle the additional behaviour of examining things."

	prefs.examine_text_mode++
	prefs.examine_text_mode %= EXAMINE_MODE_MAX // This cycles through them because if you're already specifically being routed to the examine panel, you probably don't need to have the extra text printed to chat
	switch(prefs.examine_text_mode)				// ... And I only wanted to add one verb
		if(EXAMINE_MODE_DEFAULT)
			to_chat(src, "<span class='filter_system'>Examining things will only output the base examine text, and you will not be redirected to the examine panel automatically.</span>")

		if(EXAMINE_MODE_INCLUDE_USAGE)
			to_chat(src, "<span class='filter_system'>Examining things will also print any extra usage information normally included in the examine panel to the chat.</span>")

		if(EXAMINE_MODE_SWITCH_TO_PANEL)
			to_chat(src, "<span class='filter_system'>Examining things will direct you to the examine panel, where you can view extended information about the thing.</span>")

/client/verb/toggle_multilingual_mode()
	set name = "Toggle Multilingual Mode"
	set category = "Preferences"
	set desc = "Toggle the behaviour of multilingual speech parsing."

	prefs.multilingual_mode++
	prefs.multilingual_mode %= MULTILINGUAL_MODE_MAX // Cycles through the various options
	switch(prefs.multilingual_mode)
		if(MULTILINGUAL_DEFAULT)
			to_chat(src, "<span class='filter_system'>Multilingual parsing will only check for the delimiter-key combination (,0galcom-2tradeband).</span>")
		if(MULTILINGUAL_SPACE)
			to_chat(src, "<span class='filter_system'>Multilingual parsing will enforce a space after the delimiter-key combination (,0 galcom -2still galcom). The extra space will be consumed by the pattern-matching.</span>")
		if(MULTILINGUAL_DOUBLE_DELIMITER)
			to_chat(src, "<span class='filter_system'>Multilingual parsing will enforce the a language delimiter after the delimiter-key combination (,0,galcom -2 still galcom). The extra delimiter will be consumed by the pattern-matching.</span>")
		if(MULTILINGUAL_OFF)
			to_chat(src, "<span class='filter_system'>Multilingual parsing is now disabled. Entire messages will be in the language specified at the start of the message.</span>")


//Toggles for Staff
//Developers

/client/proc/toggle_debug_logs()
	set name = "Toggle Debug Logs"
	set category = "Preferences"
	set desc = "Toggles seeing debug logs."

	var/pref_path = /datum/client_preference/debug/show_debug_logs

	if(check_rights(R_ADMIN|R_DEBUG))
		toggle_preference(pref_path)
		to_chat(src,"You will [ (is_preference_enabled(pref_path)) ? "now" : "no longer"] receive debug logs.")
		SScharacter_setup.queue_preferences_save(prefs)

	feedback_add_details("admin_verb","TADebugLogs") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

//Mods
/client/proc/toggle_attack_logs()
	set name = "Toggle Attack Logs"
	set category = "Preferences"
	set desc = "Toggles seeing attack logs."

	var/pref_path = /datum/client_preference/mod/show_attack_logs

	if(check_rights(R_ADMIN|R_MOD))
		toggle_preference(pref_path)
		to_chat(src,"You will [ (is_preference_enabled(pref_path)) ? "now" : "no longer"] receive attack logs.")
		SScharacter_setup.queue_preferences_save(prefs)

	feedback_add_details("admin_verb","TAAttackLogs") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

//General
/client/proc/toggle_admin_global_looc()
	set name = "Toggle Admin Global LOOC Visibility"
	set category = "Preferences"
	set desc = "Toggles seeing LOOC messages outside your actual LOOC range."

	var/pref_path = /datum/client_preference/holder/show_rlooc

	if(holder)
		toggle_preference(pref_path)
		to_chat(src,"You will [ (is_preference_enabled(pref_path)) ? "now" : "no longer"] hear global LOOC.")
		SScharacter_setup.queue_preferences_save(prefs)

	feedback_add_details("admin_verb","TAGlobalLOOC") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/toggle_admin_deadchat()
	set name = "Toggle Admin Living Deadchat"
	set category = "Preferences"
	set desc = "Toggles seeing deadchat while not observing."

	var/pref_path = /datum/client_preference/holder/show_staff_dsay

	if(holder)
		toggle_preference(pref_path)
		to_chat(src,"You will [ (is_preference_enabled(pref_path)) ? "now" : "no longer"] hear deadchat while not observing.")
		SScharacter_setup.queue_preferences_save(prefs)

	feedback_add_details("admin_verb","TADeadchat") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
