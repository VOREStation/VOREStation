// Define a place to save in character setup
/datum/preferences
	var/vantag_volunteer = 0	// What state I want to be in, in terms of being affected by antags.
	var/vantag_preference = VANTAG_NONE	// Whether I'd like to volunteer to be an antag at some point.
	var/resleeve_lock = 0	// Whether movs should have OOC reslieving protection. Default false.
	var/resleeve_scan = 1	// Whether mob should start with a pre-spawn body scan.  Default true.
	var/mind_scan = 1		// Whether mob should start with a pre-spawn mind scan.  Default true.

	var/custom_species	// Custom species name, can't be changed due to it having been used in savefiles already.

	var/custom_say = null
	var/custom_whisper = null
	var/custom_ask = null
	var/custom_exclaim = null

	var/list/custom_heat = list()
	var/list/custom_cold = list()

/datum/category_item/player_setup_item/general/vore_misc
	name = "Misc Settings"
	sort_order = 1

/datum/category_item/player_setup_item/general/vore_misc/load_character(list/save_data)
	pref.show_in_directory		= save_data["show_in_directory"]
	pref.directory_tag			= save_data["directory_tag"]
	pref.directory_gendertag	= save_data["directory_gendertag"]
	pref.directory_sexualitytag	= save_data["directory_sexualitytag"]
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

	pref.custom_species			= save_data["custom_species"]

	pref.custom_say				= save_data["custom_say"]
	pref.custom_whisper			= save_data["custom_whisper"]
	pref.custom_ask				= save_data["custom_ask"]
	pref.custom_exclaim			= save_data["custom_exclaim"]
	pref.custom_heat			= check_list_copy(save_data["custom_heat"])
	pref.custom_cold			= check_list_copy(save_data["custom_cold"])

/datum/category_item/player_setup_item/general/vore_misc/save_character(list/save_data)
	save_data["show_in_directory"]		= pref.show_in_directory
	save_data["directory_tag"]			= pref.directory_tag
	save_data["directory_gendertag"]	= pref.directory_gendertag
	save_data["directory_sexualitytag"]	= pref.directory_sexualitytag
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

	save_data["custom_species"]		= pref.custom_species

	save_data["custom_say"]			= pref.custom_say
	save_data["custom_whisper"]		= pref.custom_whisper
	save_data["custom_ask"]			= pref.custom_ask
	save_data["custom_exclaim"]		= pref.custom_exclaim
	save_data["custom_heat"]		= check_list_copy(pref.custom_heat)
	save_data["custom_cold"]		= check_list_copy(pref.custom_cold)

/datum/category_item/player_setup_item/general/vore_misc/copy_to_mob(var/mob/living/carbon/human/character)
	character.custom_species	= pref.custom_species

	character.custom_say		= lowertext(trim(pref.custom_say))
	character.custom_ask		= lowertext(trim(pref.custom_ask))
	character.custom_whisper	= lowertext(trim(pref.custom_whisper))
	character.custom_exclaim	= lowertext(trim(pref.custom_exclaim))
	character.custom_heat = pref.custom_heat
	character.custom_cold = pref.custom_cold

	if(pref.sensorpref > 5 || pref.sensorpref < 1)
		pref.sensorpref = 5
	character.sensorpref = pref.sensorpref
	character.capture_crystal = pref.capture_crystal
	//Vore Stomach Sprite Preference
	character.recalculate_vis()

	if(character && !istype(character,/mob/living/carbon/human/dummy))
		character.vantag_pref = pref.vantag_preference
		BITSET(character.hud_updateflag, VANTAG_HUD)
		var/want_body_save = pref.resleeve_scan
		var/want_mind_save = pref.mind_scan

		spawn(50)
			if(QDELETED(character) || QDELETED(pref))
				return // They might have been deleted during the wait
			if(!character.virtual_reality_mob && !(/mob/living/carbon/human/proc/perform_exit_vr in character.verbs)) //Janky fix to prevent resleeving VR avatars but beats refactoring transcore
				if(want_body_save && !(character.species.flags & NO_SLEEVE)) // Nosleeve flag overrides character pref editor. Otherwise resleevable species still get one even if they took a trait to not be sleevable.
					var/datum/transhuman/body_record/BR = new()
					BR.init_from_mob(character, TRUE, pref.resleeve_lock)
				if(want_mind_save)
					var/datum/transcore_db/our_db = SStranscore.db_by_key(null)
					if(our_db)
						our_db.m_backup(character.mind,character.nif,one_time = TRUE)
			if(pref.resleeve_lock)
				character.resleeve_lock = character.ckey
			character.original_player = character.ckey

/datum/category_item/player_setup_item/general/vore_misc/sanitize_character()
	pref.show_in_directory		= sanitize_integer(pref.show_in_directory, 0, 1, initial(pref.show_in_directory))
	pref.directory_tag			= sanitize_inlist(pref.directory_tag, GLOB.char_directory_tags, initial(pref.directory_tag))
	pref.directory_gendertag	= sanitize_inlist(pref.directory_gendertag, GLOB.char_directory_gendertags, initial(pref.directory_gendertag))
	pref.directory_sexualitytag	= sanitize_inlist(pref.directory_sexualitytag, GLOB.char_directory_sexualitytags, initial(pref.directory_sexualitytag))
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

	pref.custom_say = lowertext(trim(pref.custom_say))
	pref.custom_whisper = lowertext(trim(pref.custom_whisper))
	pref.custom_ask = lowertext(trim(pref.custom_ask))
	pref.custom_exclaim = lowertext(trim(pref.custom_exclaim))
	if (islist(pref.custom_heat)) //don't bother checking these for actual singular message length, they should already have been checked and it'd take too long every time it's sanitized
		if (length(pref.custom_heat) > 10)
			pref.custom_heat.Cut(11)
	else
		pref.custom_heat = list()
	if (islist(pref.custom_cold))
		if (length(pref.custom_cold) > 10)
			pref.custom_cold.Cut(11)
	else
		pref.custom_cold = list()

/datum/category_item/player_setup_item/general/vore_misc/tgui_data(mob/user, datum/tgui/ui, datum/tgui_state/state)
	var/list/data = ..()

	data["show_in_directory"] = pref.show_in_directory
	data["directory_tag"] = pref.directory_tag
	data["directory_gendertag"] = pref.directory_gendertag
	data["directory_sexualitytag"] = pref.directory_sexualitytag
	data["directory_erptag"] = pref.directory_erptag
	data["sensorpref"] = GLOB.sensorpreflist[pref.sensorpref]
	data["capture_crystal"] = pref.capture_crystal
	data["auto_backup_implant"] = pref.auto_backup_implant
	data["borg_petting"] = pref.borg_petting

	data["ignore_shoes"] = pref.read_preference(/datum/preference/toggle/human/ignore_shoes)

	data["resleeve_lock"] = pref.resleeve_lock
	data["resleeve_scan"] = pref.resleeve_scan
	data["mind_scan"] = pref.mind_scan

	data["vantag_volunteer"] = pref.vantag_volunteer
	data["vantag_preference"] = GLOB.vantag_choices_list[pref.vantag_preference]

	data["custom_species"] = pref.custom_species

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
		if("directory_gendertag")
			var/new_gendertag = tgui_input_list(user, "Pick a new Gender tag for the character directory. This is YOUR gender, not what you prefer.", "Character Gender Tag", GLOB.char_directory_gendertags, pref.directory_gendertag)
			if(!new_gendertag)
				return
			pref.directory_gendertag = new_gendertag
			return TOPIC_REFRESH
		if("directory_sexualitytag")
			var/new_sexualitytag = tgui_input_list(user, "Pick a new Sexuality/Orientation tag for the character directory", "Character Sexuality/Orientation Tag", GLOB.char_directory_sexualitytags, pref.directory_sexualitytag)
			if(!new_sexualitytag)
				return
			pref.directory_sexualitytag = new_sexualitytag
			return TOPIC_REFRESH
		if("directory_erptag")
			var/new_erptag = tgui_input_list(user, "Pick a new ERP tag for the character directory", "Character ERP Tag", GLOB.char_directory_erptags, pref.directory_erptag)
			if(!new_erptag)
				return
			pref.directory_erptag = new_erptag
			return TOPIC_REFRESH
		if("directory_ad")
			var/msg = tgui_input_text(user,"Write your advertisement here!", "Flavor Text", html_decode(pref.directory_ad), MAX_MESSAGE_LEN, TRUE, prevent_enter = TRUE)
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
		if("toggle_ignore_shoes")
			pref.update_preference_by_type(/datum/preference/toggle/human/ignore_shoes, !pref.read_preference(/datum/preference/toggle/human/ignore_shoes))
			return TOPIC_REFRESH
		if("toggle_implant")
			pref.auto_backup_implant = pref.auto_backup_implant ? 0 : 1;
			return TOPIC_REFRESH
		if("toggle_borg_petting")
			pref.borg_petting = pref.borg_petting ? 0 : 1;
			return TOPIC_REFRESH
		if("edit_private_notes")
			var/new_metadata = tgui_input_text(user,"Write some notes for yourself. These can be anything that is useful, whether it's character events that you want to remember or a bit of lore. Things that you would normally stick in a txt file for yourself!", "Private Notes", html_decode(pref.read_preference(/datum/preference/text/living/private_notes)), MAX_MESSAGE_LEN, TRUE, prevent_enter = TRUE)
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
		if("custom_say")
			var/char_name = pref.read_preference(/datum/preference/name/real_name)
			var/say_choice = tgui_input_text(user, "This word or phrase will appear instead of 'says': [char_name] says, \"Hi.\"", "Custom Say", pref.custom_say, 12)
			if(say_choice)
				pref.custom_say = say_choice
			return TOPIC_REFRESH
		if("custom_whisper")
			var/char_name = pref.read_preference(/datum/preference/name/real_name)
			var/whisper_choice = tgui_input_text(user, "This word or phrase will appear instead of 'whispers': [char_name] whispers, \"Hi...\"", "Custom Whisper", pref.custom_whisper, 12)
			if(whisper_choice)
				pref.custom_whisper = whisper_choice
			return TOPIC_REFRESH
		if("custom_ask")
			var/char_name = pref.read_preference(/datum/preference/name/real_name)
			var/ask_choice = tgui_input_text(user, "This word or phrase will appear instead of 'asks': [char_name] asks, \"Hi?\"", "Custom Ask", pref.custom_ask, 12)
			if(ask_choice)
				pref.custom_ask = ask_choice
			return TOPIC_REFRESH
		if("custom_exclaim")
			var/char_name = pref.read_preference(/datum/preference/name/real_name)
			var/exclaim_choice = tgui_input_text(user, "This word or phrase will appear instead of 'exclaims', 'shouts' or 'yells': [char_name] exclaims, \"Hi!\"", "Custom Exclaim", pref.custom_exclaim, 12)
			if(exclaim_choice)
				pref.custom_exclaim = exclaim_choice
			return TOPIC_REFRESH
		if("custom_heat")
			tgui_alert(user, "You are setting custom heat messages. These will overwrite your species' defaults. To return to defaults, click reset.")
			var/old_message = pref.custom_heat.Join("\n\n")
			var/new_message = sanitize(tgui_input_text(user,"Use double enter between messages to enter a new one. Must be at least 3 characters long, 160 characters max and up to 10 messages are allowed.","Heat Discomfort messages",old_message, multiline= TRUE, encode = FALSE, prevent_enter = TRUE), MAX_MESSAGE_LEN,0,0,0)
			if(length(new_message) > 0)
				var/list/raw_list = splittext(new_message,"\n\n")
				if(raw_list.len > 10)
					raw_list.Cut(11)
				for(var/i = 1, i <= raw_list.len, i++)
					if(length(raw_list[i]) < 3 || length(raw_list[i]) > 160)
						raw_list.Cut(i,i)
					else
						raw_list[i] = readd_quotes(raw_list[i])
				ASSERT(raw_list.len <= 10)
				pref.custom_heat = raw_list
			return TOPIC_REFRESH
		if("custom_cold")
			tgui_alert(user, "You are setting custom cold messages. These will overwrite your species' defaults. To return to defaults, click reset.")
			var/old_message = pref.custom_heat.Join("\n\n")
			var/new_message = sanitize(tgui_input_text(user,"Use double enter between messages to enter a new one. Must be at least 3 characters long, 160 characters max and up to 10 messages are allowed.","Cold Discomfort messages",old_message, multiline= TRUE, encode = FALSE, prevent_enter = TRUE), MAX_MESSAGE_LEN,0,0,0)
			if(length(new_message) > 0)
				var/list/raw_list = splittext(new_message,"\n\n")
				if(raw_list.len > 10)
					raw_list.Cut(11)
				for(var/i = 1, i <= raw_list.len, i++)
					if(length(raw_list[i]) < 3 || length(raw_list[i]) > 160)
						raw_list.Cut(i,i)
					else
						raw_list[i] = readd_quotes(raw_list[i])
				ASSERT(raw_list.len <= 10)
				pref.custom_cold = raw_list
			return TOPIC_REFRESH
		if("reset_say")
			var/say_choice = tgui_alert(user, "Reset your Custom Say Verb?","Reset Verb",list("Yes","No"))
			if(say_choice == "Yes")
				pref.custom_say = null
			return TOPIC_REFRESH
		if("reset_whisper")
			var/whisper_choice = tgui_alert(user, "Reset your Custom Whisper Verb?","Reset Verb",list("Yes","No"))
			if(whisper_choice == "Yes")
				pref.custom_whisper = null
			return TOPIC_REFRESH
		if("reset_ask")
			var/ask_choice = tgui_alert(user, "Reset your Custom Ask Verb?","Reset Verb",list("Yes","No"))
			if(ask_choice == "Yes")
				pref.custom_ask = null
			return TOPIC_REFRESH
		if("reset_exclaim")
			var/exclaim_choice = tgui_alert(user, "Reset your Custom Exclaim Verb?","Reset Verb",list("Yes","No"))
			if(exclaim_choice == "Yes")
				pref.custom_exclaim = null
			return TOPIC_REFRESH
		if("reset_cold")
			var/cold_choice = tgui_alert(user, "Reset your Custom Cold Discomfort messages?", "Reset Discomfort",list("Yes","No"))
			if(cold_choice == "Yes")
				pref.custom_cold = list()
			return TOPIC_REFRESH
		if("reset_heat")
			var/heat_choice = tgui_alert(user, "Reset your Custom Heat Discomfort messages?", "Reset Discomfort",list("Yes","No"))
			if(heat_choice == "Yes")
				pref.custom_heat = list()
			return TOPIC_REFRESH
		if("custom_species")
			var/raw_choice = tgui_input_text(user, "Input your custom species name:",
				"Character Preference", pref.custom_species, MAX_NAME_LEN)
			pref.custom_species = raw_choice
			return TOPIC_REFRESH
