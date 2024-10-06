/datum/category_item/player_setup_item/vore/misc
	name = "Misc Settings"
	sort_order = 9

/datum/category_item/player_setup_item/vore/misc/load_character(list/save_data)
	pref.show_in_directory		= save_data["show_in_directory"]
	pref.directory_tag			= save_data["directory_tag"]
	pref.directory_erptag		= save_data["directory_erptag"]
	pref.directory_ad			= save_data["directory_ad"]
	pref.sensorpref				= save_data["sensorpref"]
	pref.capture_crystal		= save_data["capture_crystal"]
	pref.auto_backup_implant	= save_data["auto_backup_implant"]
	pref.borg_petting			= save_data["borg_petting"]
	pref.stomach_vision			= save_data["stomach_vision"]

/datum/category_item/player_setup_item/vore/misc/save_character(list/save_data)
	save_data["show_in_directory"]		= pref.show_in_directory
	save_data["directory_tag"]			= pref.directory_tag
	save_data["directory_erptag"]		= pref.directory_erptag
	save_data["directory_ad"]			= pref.directory_ad
	save_data["sensorpref"]				= pref.sensorpref
	save_data["capture_crystal"]		= pref.capture_crystal
	save_data["auto_backup_implant"]	= pref.auto_backup_implant
	save_data["borg_petting"]			= pref.borg_petting
	save_data["stomach_vision"]			= pref.stomach_vision

/datum/category_item/player_setup_item/vore/misc/copy_to_mob(var/mob/living/carbon/human/character)
	if(pref.sensorpref > 5 || pref.sensorpref < 1)
		pref.sensorpref = 5
	character.sensorpref = pref.sensorpref
	character.capture_crystal = pref.capture_crystal
	//Vore Stomach Sprite Preference
	character.stomach_vision = pref.stomach_vision
	character.recalculate_vis()

/datum/category_item/player_setup_item/vore/misc/sanitize_character()
	pref.show_in_directory		= sanitize_integer(pref.show_in_directory, 0, 1, initial(pref.show_in_directory))
	pref.directory_tag			= sanitize_inlist(pref.directory_tag, GLOB.char_directory_tags, initial(pref.directory_tag))
	pref.directory_erptag		= sanitize_inlist(pref.directory_erptag, GLOB.char_directory_erptags, initial(pref.directory_erptag))
	pref.sensorpref				= sanitize_integer(pref.sensorpref, 1, sensorpreflist.len, initial(pref.sensorpref))
	pref.capture_crystal		= sanitize_integer(pref.capture_crystal, 0, 1, initial(pref.capture_crystal))
	pref.auto_backup_implant	= sanitize_integer(pref.auto_backup_implant, 0, 1, initial(pref.auto_backup_implant))
	pref.borg_petting			= sanitize_integer(pref.borg_petting, 0, 1, initial(pref.borg_petting))
	pref.stomach_vision			= sanitize_integer(pref.stomach_vision, 0, 1, initial(pref.stomach_vision))

/datum/category_item/player_setup_item/vore/misc/content(var/mob/user)
	. += "<br>"
	. += span_bold("Appear in Character Directory:") + " <a [pref.show_in_directory ? "class='linkOn'" : ""] href='?src=\ref[src];toggle_show_in_directory=1'><b>[pref.show_in_directory ? "Yes" : "No"]</b></a><br>"
	. += span_bold("Character Directory Vore Tag:") + " <a href='?src=\ref[src];directory_tag=1'><b>[pref.directory_tag]</b></a><br>"
	. += span_bold("Character Directory ERP Tag:") + " <a href='?src=\ref[src];directory_erptag=1'><b>[pref.directory_erptag]</b></a><br>"
	. += span_bold("Character Directory Advertisement:") + " <a href='?src=\ref[src];directory_ad=1'><b>Set Directory Ad</b></a><br>"
	. += span_bold("Suit Sensors Preference:") + " <a [pref.sensorpref ? "" : ""] href='?src=\ref[src];toggle_sensor_setting=1'><b>[sensorpreflist[pref.sensorpref]]</b></a><br>"
	. += span_bold("Capture Crystal Preference:") + " <a [pref.capture_crystal ? "class='linkOn'" : ""] href='?src=\ref[src];toggle_capture_crystal=1'><b>[pref.capture_crystal ? "Yes" : "No"]</b></a><br>"
	. += span_bold("Spawn With Backup Implant:") + " <a [pref.auto_backup_implant ? "class='linkOn'" : ""] href='?src=\ref[src];toggle_implant=1'><b>[pref.auto_backup_implant ? "Yes" : "No"]</b></a><br>"
	. += span_bold("Allow petting as robot:") + " <a [pref.borg_petting ? "class='linkOn'" : ""] href='?src=\ref[src];toggle_borg_petting=1'><b>[pref.borg_petting ? "Yes" : "No"]</b></a><br>"
	. += span_bold("Enable Stomach Sprites:") + " <a [pref.stomach_vision ? "class='linkOn'" : ""] href='?src=\ref[src];toggle_stomach_vision=1'><b>[pref.stomach_vision ? "Yes" : "No"]</b></a><br>"

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
		var/new_sensorpref = tgui_input_list(user, "Choose your character's sensor preferences:", "Character Preferences", sensorpreflist, sensorpreflist[pref.sensorpref])
		if (!isnull(new_sensorpref) && CanUseTopic(user))
			pref.sensorpref = sensorpreflist.Find(new_sensorpref)
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
	else if(href_list["toggle_stomach_vision"])
		pref.stomach_vision = pref.stomach_vision ? 0 : 1;
		return TOPIC_REFRESH
	return ..();
