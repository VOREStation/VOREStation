/datum/preferences
	var/show_in_directory = 1	//Show in Character Directory
	var/directory_tag = "Unset" //Sorting tag to use in character directory
	var/directory_erptag = "Unset"	//ditto, but for non-vore scenes
	var/directory_ad = ""		//Advertisement stuff to show in character directory.
	var/sensorpref = 5			//Set character's suit sensor level

	var/job_talon_high = 0
	var/job_talon_med = 0
	var/job_talon_low = 0

//Why weren't these in game toggles already?
/client/verb/toggle_eating_noises()
	set name = "Eating Noises"
	set category = "Preferences"
	set desc = "Toggles Vore Eating noises."

	var/pref_path = /datum/client_preference/eating_noises

	toggle_preference(pref_path)

	to_chat(src, "You will [ (is_preference_enabled(pref_path)) ? "now" : "no longer"] hear eating related vore noises.")

	SScharacter_setup.queue_preferences_save(prefs)

	feedback_add_details("admin_verb","TEatNoise") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!


/client/verb/toggle_digestion_noises()
	set name = "Digestion Noises"
	set category = "Preferences"
	set desc = "Toggles Vore Digestion noises."

	var/pref_path = /datum/client_preference/digestion_noises

	toggle_preference(pref_path)

	to_chat(src, "You will [ (is_preference_enabled(pref_path)) ? "now" : "no longer"] hear digestion related vore noises.")

	SScharacter_setup.queue_preferences_save(prefs)

	feedback_add_details("admin_verb","TDigestNoise") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!


/client/verb/toggle_emote_noises()
	set name = "Emote Noises"
	set category = "Preferences"
	set desc = "Toggles emote noises."

	var/pref_path = /datum/client_preference/emote_noises

	toggle_preference(pref_path)

	to_chat(src, "You will [ (is_preference_enabled(pref_path)) ? "now" : "no longer"] hear emote-related noises.")

	SScharacter_setup.queue_preferences_save(prefs)

	feedback_add_details("admin_verb","TEmoteNoise") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/verb/toggle_ghost_quiets()
	set name = "Toggle Whisper/Subtle Vis"
	set category = "Preferences"
	set desc = "Toggle ghosts viewing your subtles/whispers."

	var/pref_path = /datum/client_preference/whisubtle_vis

	toggle_preference(pref_path)

	to_chat(src, "Ghosts will [ (is_preference_enabled(pref_path)) ? "now" : "no longer"] hear subtles/whispers made by you.")

	SScharacter_setup.queue_preferences_save(prefs)

	feedback_add_details("admin_verb","TWhisubtleVis") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
