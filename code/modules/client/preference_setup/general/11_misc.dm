// Define a place to save in character setup
/datum/preferences
	var/vantag_volunteer = 0	// What state I want to be in, in terms of being affected by antags.
	var/vantag_preference = VANTAG_NONE	// Whether I'd like to volunteer to be an antag at some point.
	var/resleeve_lock = 0	// Whether movs should have OOC reslieving protection. Default false.
	var/resleeve_scan = 1	// Whether mob should start with a pre-spawn body scan.  Default true.
	var/mind_scan = 1		// Whether mob should start with a pre-spawn mind scan.  Default true.

/datum/category_item/player_setup_item/general/vore_misc
	name = "Misc Settings"
	sort_order = 1

/datum/category_item/player_setup_item/general/vore_misc/load_character(list/save_data)
	pref.show_in_directory		= save_data["show_in_directory"]
	pref.directory_tag			= save_data["directory_tag"]
	pref.directory_erptag		= save_data["directory_erptag"]
	pref.directory_ad			= save_data["directory_ad"]
	pref.sensorpref				= save_data["sensorpref"]
	pref.capture_crystal		= save_data["capture_crystal"]
	pref.auto_backup_implant	= save_data["auto_backup_implant"]
	pref.borg_petting			= save_data["borg_petting"]
	pref.resleeve_lock			= save_data["resleeve_lock"]
	pref.resleeve_scan			= save_data["resleeve_scan"]
	pref.mind_scan				= save_data["mind_scan"]
	pref.vantag_volunteer		= save_data["vantag_volunteer"]
	pref.vantag_preference		= save_data["vantag_preference"]

/datum/category_item/player_setup_item/general/vore_misc/save_character(list/save_data)
	save_data["show_in_directory"]		= pref.show_in_directory
	save_data["directory_tag"]			= pref.directory_tag
	save_data["directory_erptag"]		= pref.directory_erptag
	save_data["directory_ad"]			= pref.directory_ad
	save_data["sensorpref"]				= pref.sensorpref
	save_data["capture_crystal"]		= pref.capture_crystal
	save_data["auto_backup_implant"]	= pref.auto_backup_implant
	save_data["borg_petting"]			= pref.borg_petting
	save_data["resleeve_lock"]			= pref.resleeve_lock
	save_data["resleeve_scan"]			= pref.resleeve_scan
	save_data["mind_scan"]				= pref.mind_scan
	save_data["vantag_volunteer"]		= pref.vantag_volunteer
	save_data["vantag_preference"]		= pref.vantag_preference

/datum/category_item/player_setup_item/general/vore_misc/copy_to_mob(var/mob/living/carbon/human/character)
	if(pref.sensorpref > 5 || pref.sensorpref < 1)
		pref.sensorpref = 5
	character.sensorpref = pref.sensorpref
	character.capture_crystal = pref.capture_crystal
	//Vore Stomach Sprite Preference
	character.recalculate_vis()

	if(character && !istype(character,/mob/living/carbon/human/dummy))
		character.vantag_pref = pref.vantag_preference
		BITSET(character.hud_updateflag, VANTAG_HUD)

		spawn(50)
			if(QDELETED(character) || QDELETED(pref))
				return // They might have been deleted during the wait
			if(!character.virtual_reality_mob && !(/mob/living/carbon/human/proc/perform_exit_vr in character.verbs)) //Janky fix to prevent resleeving VR avatars but beats refactoring transcore
				if(pref.resleeve_scan)
					var/datum/transhuman/body_record/BR = new()
					BR.init_from_mob(character, pref.resleeve_scan, pref.resleeve_lock)
				if(pref.mind_scan)
					var/datum/transcore_db/our_db = SStranscore.db_by_key(null)
					if(our_db)
						our_db.m_backup(character.mind,character.nif,one_time = TRUE)
			if(pref.resleeve_lock)
				character.resleeve_lock = character.ckey
			character.original_player = character.ckey

/datum/category_item/player_setup_item/general/vore_misc/sanitize_character()
	pref.show_in_directory		= sanitize_integer(pref.show_in_directory, 0, 1, initial(pref.show_in_directory))
	pref.directory_tag			= sanitize_inlist(pref.directory_tag, GLOB.char_directory_tags, initial(pref.directory_tag))
	pref.directory_erptag		= sanitize_inlist(pref.directory_erptag, GLOB.char_directory_erptags, initial(pref.directory_erptag))
	pref.sensorpref				= sanitize_integer(pref.sensorpref, 1, GLOB.sensorpreflist.len, initial(pref.sensorpref))
	pref.capture_crystal		= sanitize_integer(pref.capture_crystal, 0, 1, initial(pref.capture_crystal))
	pref.auto_backup_implant	= sanitize_integer(pref.auto_backup_implant, 0, 1, initial(pref.auto_backup_implant))
	pref.borg_petting			= sanitize_integer(pref.borg_petting, 0, 1, initial(pref.borg_petting))
	pref.resleeve_lock		= sanitize_integer(pref.resleeve_lock, 0, 1, initial(pref.resleeve_lock))
	pref.resleeve_scan		= sanitize_integer(pref.resleeve_scan, 0, 1, initial(pref.resleeve_scan))
	pref.mind_scan			= sanitize_integer(pref.mind_scan, 0, 1, initial(pref.mind_scan))
	pref.vantag_volunteer	= sanitize_integer(pref.vantag_volunteer, 0, 1, initial(pref.vantag_volunteer))
	pref.vantag_preference	= sanitize_inlist(pref.vantag_preference, GLOB.vantag_choices_list, initial(pref.vantag_preference))

/datum/category_item/player_setup_item/general/vore_misc/tgui_data(mob/user, datum/tgui/ui, datum/tgui_state/state)
	var/list/data = ..()

	data["show_in_directory"] = pref.show_in_directory
	data["directory_tag"] = pref.directory_tag
	data["directory_erptag"] = pref.directory_erptag
	data["sensorpref"] = GLOB.sensorpreflist[pref.sensorpref]
	data["capture_crystal"] = pref.capture_crystal
	data["auto_backup_implant"] = pref.auto_backup_implant
	data["borg_petting"] = pref.borg_petting

	data["resleeve_lock"] = pref.resleeve_lock
	data["resleeve_scan"] = pref.resleeve_scan
	data["mind_scan"] = pref.mind_scan

	data["vantag_volunteer"] = pref.vantag_volunteer
	data["vantag_preference"] = GLOB.vantag_choices_list[pref.vantag_preference]

	return data

/datum/category_item/player_setup_item/general/vore_misc/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
	. = ..()
	if(.)
		return

	var/mob/user = ui.user

	switch(action)
		if("toggle_show_in_directory")
			pref.show_in_directory = pref.show_in_directory ? 0 : 1;
			return TOPIC_REFRESH
		if("directory_tag")
			var/new_tag = tgui_input_list(user, "Pick a new Vore tag for the character directory", "Character Vore Tag", GLOB.char_directory_tags, pref.directory_tag)
			if(!new_tag)
				return
			pref.directory_tag = new_tag
			return TOPIC_REFRESH
		if("directory_erptag")
			var/new_erptag = tgui_input_list(user, "Pick a new ERP tag for the character directory", "Character ERP Tag", GLOB.char_directory_erptags, pref.directory_erptag)
			if(!new_erptag)
				return
			pref.directory_erptag = new_erptag
			return TOPIC_REFRESH
		if("directory_ad")
			var/msg = sanitize(tgui_input_text(user,"Write your advertisement here!", "Flavor Text", html_decode(pref.directory_ad), multiline = TRUE, prevent_enter = TRUE), extra = 0)	//VOREStation Edit: separating out OOC notes
			if(!msg)
				return
			pref.directory_ad = msg
			return TOPIC_REFRESH
		if("toggle_sensor_setting")
			var/new_sensorpref = tgui_input_list(user, "Choose your character's sensor preferences:", "Character Preferences", GLOB.sensorpreflist, GLOB.sensorpreflist[pref.sensorpref])
			if (!isnull(new_sensorpref))
				pref.sensorpref = GLOB.sensorpreflist.Find(new_sensorpref)
				return TOPIC_REFRESH
		if("toggle_capture_crystal")
			pref.capture_crystal = pref.capture_crystal ? 0 : 1;
			return TOPIC_REFRESH
		if("toggle_implant")
			pref.auto_backup_implant = pref.auto_backup_implant ? 0 : 1;
			return TOPIC_REFRESH
		if("toggle_borg_petting")
			pref.borg_petting = pref.borg_petting ? 0 : 1;
			return TOPIC_REFRESH
		if("edit_private_notes")
			var/new_metadata = sanitize(tgui_input_text(user,"Write some notes for yourself. These can be anything that is useful, whether it's character events that you want to remember or a bit of lore. Things that you would normally stick in a txt file for yourself!", "Private Notes", html_decode(pref.read_preference(/datum/preference/text/living/private_notes)), multiline = TRUE, prevent_enter = TRUE), extra = 0)
			if(new_metadata)
				pref.update_preference_by_type(/datum/preference/text/living/private_notes, new_metadata)
			return TOPIC_REFRESH
		if("toggle_resleeve_lock")
			pref.resleeve_lock = pref.resleeve_lock ? 0 : 1;
			return TOPIC_REFRESH
		if("toggle_resleeve_scan")
			pref.resleeve_scan = pref.resleeve_scan ? 0 : 1;
			return TOPIC_REFRESH
		if("toggle_mind_scan")
			pref.mind_scan = pref.mind_scan ? 0 : 1;
			return TOPIC_REFRESH
		if("toggle_vantag_volunteer")
			pref.vantag_volunteer = pref.vantag_volunteer ? 0 : 1
			return TOPIC_REFRESH
		if("change_vantag")
			var/list/names_list = list()
			for(var/C in GLOB.vantag_choices_list)
				names_list[GLOB.vantag_choices_list[C]] = C

			var/selection = tgui_input_list(user, "How do you want to be involved with VS Event Characters, ERP-wise? They will see this choice on you in a HUD. Event characters are admin-selected and spawned players, possibly with assigned objectives, who are obligated to respect ERP prefs and RP their actions like any other player, though it may be a slightly shorter RP if they are pressed for time or being caught.", "Event Preference", names_list)
			if(selection && selection != "Normal")
				pref.vantag_preference = names_list[selection]
			return TOPIC_REFRESH
