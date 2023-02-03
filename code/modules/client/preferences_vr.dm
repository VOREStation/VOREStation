/datum/preferences
	var/show_in_directory = 1	//Show in Character Directory
	var/directory_tag = "Unset" //Sorting tag to use in character directory
	var/directory_erptag = "Unset"	//ditto, but for non-vore scenes
	var/directory_ad = ""		//Advertisement stuff to show in character directory.
	var/sensorpref = 5			//Set character's suit sensor level
	var/capture_crystal = 1	//Whether or not someone is able to be caught with capture crystals

	var/job_talon_high = 0
	var/job_talon_med = 0
	var/job_talon_low = 0

//Why weren't these in game toggles already?
/client/verb/toggle_eating_noises()
	set name = "Toggle Eating Noises"
	set category = "Preferences"
	set desc = "Toggles hearing Vore Eating noises."

	var/pref_path = /datum/client_preference/eating_noises

	toggle_preference(pref_path)

	to_chat(src, "You will [ (is_preference_enabled(pref_path)) ? "now" : "no longer"] hear eating related vore noises.")

	SScharacter_setup.queue_preferences_save(prefs)

	feedback_add_details("admin_verb","TEatNoise") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!


/client/verb/toggle_digestion_noises()
	set name = "Toggle Digestion Noises"
	set category = "Preferences"
	set desc = "Toggles hearing Vore Digestion noises."

	var/pref_path = /datum/client_preference/digestion_noises

	toggle_preference(pref_path)

	to_chat(src, "You will [ (is_preference_enabled(pref_path)) ? "now" : "no longer"] hear digestion related vore noises.")

	SScharacter_setup.queue_preferences_save(prefs)

	feedback_add_details("admin_verb","TDigestNoise") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/verb/toggle_belch_noises()
	set name = "Toggle Audible Belching"
	set category = "Preferences"
	set desc = "Toggles hearing audible belches."

	var/pref_path = /datum/client_preference/belch_noises

	toggle_preference(pref_path)

	to_chat(src, "You will [ (is_preference_enabled(pref_path)) ? "now" : "no longer"] hear belching.")

	SScharacter_setup.queue_preferences_save(prefs)

	feedback_add_details("admin_verb","TBelchNoise")

/client/verb/toggle_emote_noises()
	set name = "Toggle Emote Noises"
	set category = "Preferences"
	set desc = "Toggles hearing emote noises."

	var/pref_path = /datum/client_preference/emote_noises

	toggle_preference(pref_path)

	to_chat(src, "You will [ (is_preference_enabled(pref_path)) ? "now" : "no longer"] hear emote-related noises.")

	SScharacter_setup.queue_preferences_save(prefs)

	feedback_add_details("admin_verb","TEmoteNoise") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/verb/toggle_ghost_quiets()
	set name = "Toggle Ghost Privacy"
	set category = "Preferences"
	set desc = "Toggles ghosts being able to see your subtles/whispers."

	var/pref_path = /datum/client_preference/whisubtle_vis

	toggle_preference(pref_path)

	to_chat(src, "Ghosts will [ (is_preference_enabled(pref_path)) ? "now" : "no longer"] hear subtles/whispers made by you.")

	SScharacter_setup.queue_preferences_save(prefs)

	feedback_add_details("admin_verb","TWhisubtleVis") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/verb/toggle_capture_crystal()
	set name = "Toggle Catchable"
	set category = "Preferences"
	set desc = "Toggles being catchable with capture crystals."

	var/mob/living/L = mob

	if(prefs.capture_crystal)
		to_chat(src, "You are no longer catchable.")
		prefs.capture_crystal = 0
	else
		to_chat(src, "You are now catchable.")
		prefs.capture_crystal = 1
	if(L && istype(L))
		L.capture_crystal = prefs.capture_crystal
	SScharacter_setup.queue_preferences_save(prefs)

	feedback_add_details("admin_verb","TCaptureCrystal") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/verb/toggle_mentorhelp_ping()
	set name = "Toggle Mentorhelp Ping"
	set category = "Preferences"
	set desc = "Toggles the mentorhelp ping"

	var/pref_path = /datum/client_preference/play_mentorhelp_ping

	toggle_preference(pref_path)

	to_chat(src, "Mentorhelp pings are now [ is_preference_enabled(pref_path) ? "enabled" : "disabled"]")

	SScharacter_setup.queue_preferences_save(prefs)

	feedback_add_details("admin_verb", "TSoundMentorhelps")

//General
/client/proc/toggle_admin_ghost_privacy()
	set name = "Toggle Admin Hidden Subtles"
	set category = "Preferences"
	set desc = "Toggles seeing subtles/whispers for clients with the ghost privacy option on."

	var/pref_path = /datum/client_preference/holder/show_subtles

	if(holder)
		toggle_preference(pref_path)
		to_chat(src,"You will [ (is_preference_enabled(pref_path)) ? "now" : "no longer"] hear see ghost privacy hidden subtles/whispers.")
		SScharacter_setup.queue_preferences_save(prefs)

	feedback_add_details("admin_verb","TAHiddenSubtles") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!