/datum/preferences
	var/show_in_directory = 1	//Show in Character Directory
	var/directory_tag = "Unset" //Sorting tag to use in character directory
	var/directory_erptag = "Unset"	//ditto, but for non-vore scenes
	var/directory_gendertag = "Unset" // Gender stuff!
	var/directory_sexualitytag = "Unset" // Sexuality!
	var/directory_ad = ""		//Advertisement stuff to show in character directory.
	var/sensorpref = 5			//Set character's suit sensor level
	var/capture_crystal = 1	//Whether or not someone is able to be caught with capture crystals
	var/auto_backup_implant = FALSE //Whether someone starts with a backup implant or not.
	var/borg_petting = TRUE //Whether someone can be petted as a borg or not.

	var/job_talon_high = 0
	var/job_talon_med = 0
	var/job_talon_low = 0

//Why weren't these in game toggles already?
/client/verb/toggle_capture_crystal()
	set name = "Toggle Catchable"
	set category = "Preferences.Character"
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
