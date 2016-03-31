//Toggles for preferences, normal clients
/client/verb/toggle_ghost_ears()
	set name = "Show/Hide Ghost Ears"
	set category = "Preferences"
	set desc = "Toggles between seeing all mob speech and nearby mob speech."
	
	var/pref_path = /datum/client_preference/ghost_ears
		
	toggle_preference(pref_path)
	
	src << "You will [ (is_preference_enabled(pref_path)) ? "now" : " no longer"] hear all mob speech as a ghost."
	
	feedback_add_details("admin_verb","TGEars") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	
/client/verb/toggle_ghost_vision()
	set name = "Show/Hide Ghost Vision"
	set category = "Preferences"
	set desc = "Toggles between seeing all mob emotes and nearby mob emotes."
	
	var/pref_path = /datum/client_preference/ghost_sight
	
	toggle_preference(pref_path)
	
	src << "You will [ (is_preference_enabled(pref_path)) ? "now" : " no longer"] see all emotes as a ghost."
	
	feedback_add_details("admin_verb","TGVision") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	
/client/verb/toggle_ghost_radio()
	set name = "Show/Hide Radio Chatter"
	set category = "Preferences"
	set desc = "Toggles between seeing all radio chat and nearby radio chatter."
	
	var/pref_path = /datum/client_preference/ghost_radio

	toggle_preference(pref_path)
	
	src << "You will [ (is_preference_enabled(pref_path)) ? "now" : "no longer"] hear all radios as a ghost."
	
	feedback_add_details("admin_verb","TGRadio") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	
/client/verb/toggle_deadchat()
	set name = "Show/Hide Deadchat"
	set category = "Preferences"
	set desc = "Toggles the dead chat channel."
	
	var/pref_path = /datum/client_preference/show_dsay

	toggle_preference(pref_path)
	
	src << "You will [ (is_preference_enabled(pref_path)) ? "now" : "no longer"] hear dead chat as a ghost."
	
	feedback_add_details("admin_verb","TDeadChat") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	
/client/verb/toggle_ooc()
	set name = "Show/Hide OOC"
	set category = "Preferences"
	set desc = "Toggles global out of character chat."
	
	var/pref_path = /datum/client_preference/show_ooc

	toggle_preference(pref_path)
	
	src << "You will [ (is_preference_enabled(/datum/client_preference/show_ooc)) ? "now" : "no longer"] hear global out of character chat."
	
	feedback_add_details("admin_verb","TOOC") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	
/client/verb/toggle_looc()
	set name = "Show/Hide LOOC"
	set category = "Preferences"
	set desc = "Toggles local out of character chat."
	
	var/pref_path = /datum/client_preference/show_looc
	
	toggle_preference(pref_path)
	
	src << "You will [ (is_preference_enabled(pref_path)) ? "now" : "no longer"] hear local out of character chat."
	
	feedback_add_details("admin_verb","TLOOC") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	
/client/verb/toggle_typing()
	set name = "Show/Hide Typing Indicator"
	set category = "Preferences"
	set desc = "Toggles the speech bubble typing indicator."
	
	var/pref_path = /datum/client_preference/show_typing_indicator
	
	toggle_preference(pref_path)
	
	src << "You will [ (is_preference_enabled(pref_path)) ? "now" : "no longer"] see the speech indicator."
	
	feedback_add_details("admin_verb","TLOOC") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	
/client/verb/toggle_ahelp_sound()
	set name = "Toggle Admin Help Sound"
	set category = "Preferences"
	set desc = "Toggles the ability to hear a noise broadcasted when you get an admin message."
	
	var/pref_path = /datum/client_preference/holder/play_adminhelp_ping
	
	toggle_preference(pref_path)
	
	src << "You will [ (is_preference_enabled(pref_path)) ? "now" : "no longer"] receive noise from admin messages."
	
	feedback_add_details("admin_verb","TAHelp") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	
/client/verb/toggle_lobby_music()
	set name = "Toggle Lobby Music"
	set category = "Preferences"
	set desc = "Toggles the music in the lobby."
	
	var/pref_path = /datum/client_preference/play_lobby_music
	
	toggle_preference(pref_path)

	src << "You will [ (is_preference_enabled(pref_path)) ? "now" : "no longer"] hear music in the lobby."
	
	feedback_add_details("admin_verb","TLobMusic") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	
/client/verb/toggle_admin_midis()
	set name = "Toggle Admin MIDIs"
	set category = "Preferences"
	set desc = "Toggles the music in the lobby."
	
	var/pref_path = /datum/client_preference/play_admin_midis
	
	toggle_preference(pref_path)
	
	src << "You will [ (is_preference_enabled(pref_path)) ? "now" : " no longer"] hear MIDIs from admins."
	
	feedback_add_details("admin_verb","TAMidis") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	
/client/verb/toggle_ambience()
	set name = "Toggle Ambience"
	set category = "Preferences"
	set desc = "Toggles the playing of ambience."
	
	var/pref_path = /datum/client_preference/play_ambiance
	
	toggle_preference(pref_path)
	
	src << "You will [ (is_preference_enabled(pref_path)) ? "now" : " no longer"] hear ambient noise."
	
	feedback_add_details("admin_verb","TBeSpecial") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	
/client/verb/toggle_be_special(role in be_special_flags)
	set name = "Toggle SpecialRole Candidacy"
	set category = "Preferences"
	set desc = "Toggles which special roles you would like to be a candidate for, during events."
	
	var/role_flag = be_special_flags[role]
	if(!role_flag)	return
	
	prefs.be_special ^= role_flag
	prefs.save_preferences()
	
	src << "You will [(prefs.be_special & role_flag) ? "now" : "no longer"] be considered for [role] events (where possible)."
	
	feedback_add_details("admin_verb","TBeSpecial") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	
//Toggles for Staff
//Developers

/client/proc/toggle_debug_logs()
	set name = "Toggle Debug Logs"
	set category = "Preferences"
	set desc = "Toggles debug logs."
	
	var/pref_path = /datum/client_preference/debug/show_debug_logs
	
	if(check_rights(R_ADMIN|R_DEBUG))
		toggle_preference(pref_path)
		src << "You will [ (is_preference_enabled(pref_path)) ? "now" : "no longer"] receive debug logs."
	
	feedback_add_details("admin_verb","TBeSpecial") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	
//Mods
/client/proc/toggle_attack_logs()
	set name = "Toggle Attack Logs"
	set category = "Preferences"
	set desc = "Toggles attack logs."
	
	var/pref_path = /datum/client_preference/mod/show_attack_logs
	
	if(check_rights(R_ADMIN|R_MOD))
		toggle_preference(pref_path)
		src << "You will [ (is_preference_enabled(pref_path)) ? "now" : "no longer"] receive attack logs."
	
	feedback_add_details("admin_verb","TBeSpecial") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!