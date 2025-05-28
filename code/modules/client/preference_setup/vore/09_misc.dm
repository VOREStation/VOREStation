/datum/category_item/player_setup_item/vore/misc
	name = "Misc Settings"
	sort_order = 9

/datum/category_item/player_setup_item/vore/misc/load_character(list/save_data)
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

/datum/category_item/player_setup_item/vore/misc/save_character(list/save_data)
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

/datum/category_item/player_setup_item/vore/misc/copy_to_mob(var/mob/living/carbon/human/character)
	if(pref.sensorpref > 5 || pref.sensorpref < 1)
		pref.sensorpref = 5
	character.sensorpref = pref.sensorpref
	character.capture_crystal = pref.capture_crystal
	//Vore Stomach Sprite Preference
	character.recalculate_vis()

/datum/category_item/player_setup_item/vore/misc/sanitize_character()
	pref.show_in_directory		= sanitize_integer(pref.show_in_directory, 0, 1, initial(pref.show_in_directory))
	pref.directory_tag			= sanitize_inlist(pref.directory_tag, GLOB.char_directory_tags, initial(pref.directory_tag))
	pref.directory_gendertag	= sanitize_inlist(pref.directory_gendertag, GLOB.char_directory_gendertags, initial(pref.directory_gendertag))
	pref.directory_sexualitytag	= sanitize_inlist(pref.directory_sexualitytag, GLOB.char_directory_sexualitytags, initial(pref.directory_sexualitytag))
	pref.directory_erptag		= sanitize_inlist(pref.directory_erptag, GLOB.char_directory_erptags, initial(pref.directory_erptag))
	pref.sensorpref				= sanitize_integer(pref.sensorpref, 1, GLOB.sensorpreflist.len, initial(pref.sensorpref))
	pref.capture_crystal		= sanitize_integer(pref.capture_crystal, 0, 1, initial(pref.capture_crystal))
	pref.auto_backup_implant	= sanitize_integer(pref.auto_backup_implant, 0, 1, initial(pref.auto_backup_implant))
	pref.borg_petting			= sanitize_integer(pref.borg_petting, 0, 1, initial(pref.borg_petting))

/datum/category_item/player_setup_item/vore/misc/content(var/mob/user)
	. += "<br>"
	. += span_bold("Appear in Character Directory:") + " <a [pref.show_in_directory ? "class='linkOn'" : ""] href='byond://?src=\ref[src];toggle_show_in_directory=1'><b>[pref.show_in_directory ? "Yes" : "No"]</b></a><br>"
	. += span_bold("Character Directory Vore Tag:") + " <a href='byond://?src=\ref[src];directory_tag=1'><b>[pref.directory_tag]</b></a><br>"
	. += span_bold("Character Directory Gender:") + " <a href='byond://?src=\ref[src];directory_gendertag=1'><b>[pref.directory_gendertag]</b></a><br>"
	. += span_bold("Character Directory Sexuality:") + " <a href='byond://?src=\ref[src];directory_sexualitytag=1'><b>[pref.directory_sexualitytag]</b></a><br>"
	. += span_bold("Character Directory ERP Tag:") + " <a href='byond://?src=\ref[src];directory_erptag=1'><b>[pref.directory_erptag]</b></a><br>"
	. += span_bold("Character Directory Advertisement:") + " <a href='byond://?src=\ref[src];directory_ad=1'><b>Set Directory Ad</b></a><br>"
	. += span_bold("Suit Sensors Preference:") + " <a [pref.sensorpref ? "" : ""] href='byond://?src=\ref[src];toggle_sensor_setting=1'><b>[GLOB.sensorpreflist[pref.sensorpref]]</b></a><br>"
	. += span_bold("Capture Crystal Preference:") + " <a [pref.capture_crystal ? "class='linkOn'" : ""] href='byond://?src=\ref[src];toggle_capture_crystal=1'><b>[pref.capture_crystal ? "Yes" : "No"]</b></a><br>"
	. += span_bold("Spawn With Backup Implant:") + " <a [pref.auto_backup_implant ? "class='linkOn'" : ""] href='byond://?src=\ref[src];toggle_implant=1'><b>[pref.auto_backup_implant ? "Yes" : "No"]</b></a><br>"
	. += span_bold("Allow petting as robot:") + " <a [pref.borg_petting ? "class='linkOn'" : ""] href='byond://?src=\ref[src];toggle_borg_petting=1'><b>[pref.borg_petting ? "Yes" : "No"]</b></a><br>"
	if(CONFIG_GET(flag/allow_metadata))
		. += span_bold("Private Notes: <a href='byond://?src=\ref[src];edit_private_notes=1'>Edit</a>") + "<br>"

/datum/category_item/player_setup_item/vore/misc/OnTopic(var/href, var/list/href_list, var/mob/user)
	if(href_list["toggle_show_in_directory"])
		pref.show_in_directory = pref.show_in_directory ? 0 : 1;
		return TOPIC_REFRESH
	else if(href_list["directory_tag"])
		var/new_tag = tgui_input_list(user, "Pick a new Vore tag for the character directory", "Character Vore Tag", GLOB.char_directory_tags, pref.directory_tag)
		if(!new_tag)
			return
		pref.directory_tag = new_tag
		return TOPIC_REFRESH
	else if(href_list["directory_gendertag"])
		var/new_gendertag = tgui_input_list(user, "Pick a new Gender tag for the character directory. This is YOUR gender, not what you prefer.", "Character Gender Tag", GLOB.char_directory_gendertags, pref.directory_gendertag)
		if(!new_gendertag)
			return
		pref.directory_gendertag = new_gendertag
		return TOPIC_REFRESH
	else if(href_list["directory_sexualitytag"])
		var/new_sexualitytag = tgui_input_list(user, "Pick a new Sexuality/Orientation tag for the character directory", "Character Sexuality/Orientation Tag", GLOB.char_directory_sexualitytags, pref.directory_sexualitytag)
		if(!new_sexualitytag)
			return
		pref.directory_sexualitytag = new_sexualitytag
		return TOPIC_REFRESH
	else if(href_list["directory_erptag"])
		var/new_erptag = tgui_input_list(user, "Pick a new ERP tag for the character directory", "Character ERP Tag", GLOB.char_directory_erptags, pref.directory_erptag)
		if(!new_erptag)
			return
		pref.directory_erptag = new_erptag
		return TOPIC_REFRESH
	else if(href_list["directory_ad"])
		var/msg = sanitize(tgui_input_text(user,"Write your advertisement here!", "Flavor Text", html_decode(pref.directory_ad), multiline = TRUE, prevent_enter = TRUE), extra = 0)	//VOREStation Edit: separating out OOC notes
		if(!msg)
			return
		pref.directory_ad = msg
		return TOPIC_REFRESH
	else if(href_list["toggle_sensor_setting"])
		var/new_sensorpref = tgui_input_list(user, "Choose your character's sensor preferences:", "Character Preferences", GLOB.sensorpreflist, GLOB.sensorpreflist[pref.sensorpref])
		if (!isnull(new_sensorpref) && CanUseTopic(user))
			pref.sensorpref = GLOB.sensorpreflist.Find(new_sensorpref)
			return TOPIC_REFRESH
	else if(href_list["toggle_capture_crystal"])
		pref.capture_crystal = pref.capture_crystal ? 0 : 1;
		return TOPIC_REFRESH
	else if(href_list["toggle_implant"])
		pref.auto_backup_implant = pref.auto_backup_implant ? 0 : 1;
		return TOPIC_REFRESH
	else if(href_list["toggle_borg_petting"])
		pref.borg_petting = pref.borg_petting ? 0 : 1;
		return TOPIC_REFRESH
	else if(href_list["edit_private_notes"])
		var/new_metadata = sanitize(tgui_input_text(user,"Write some notes for yourself. These can be anything that is useful, whether it's character events that you want to remember or a bit of lore. Things that you would normally stick in a txt file for yourself!", "Private Notes", html_decode(pref.read_preference(/datum/preference/text/living/private_notes)), multiline = TRUE, prevent_enter = TRUE), extra = 0)
		if(new_metadata && CanUseTopic(user))
			pref.update_preference_by_type(/datum/preference/text/living/private_notes, new_metadata)
	return ..();
