/datum/category_item/player_setup_item/vore/misc
	name = "Misc Settings"
	sort_order = 9

/datum/category_item/player_setup_item/vore/misc/load_character(var/savefile/S)
	S["show_in_directory"]		>> pref.show_in_directory
	S["directory_tag"]			>> pref.directory_tag
	S["directory_erptag"]			>> pref.directory_erptag
	S["directory_ad"]			>> pref.directory_ad
	S["sensorpref"]				>> pref.sensorpref
	S["capture_crystal"]		>> pref.capture_crystal

/datum/category_item/player_setup_item/vore/misc/save_character(var/savefile/S)
	S["show_in_directory"]		<< pref.show_in_directory
	S["directory_tag"]			<< pref.directory_tag
	S["directory_erptag"]			<< pref.directory_erptag
	S["directory_ad"]			<< pref.directory_ad
	S["sensorpref"]				<< pref.sensorpref
	S["capture_crystal"]		<< pref.capture_crystal


/datum/category_item/player_setup_item/vore/misc/copy_to_mob(var/mob/living/carbon/human/character)
	if(pref.sensorpref > 5 || pref.sensorpref < 1)
		pref.sensorpref = 5
	character.sensorpref = pref.sensorpref
	character.capture_crystal = pref.capture_crystal

/datum/category_item/player_setup_item/vore/misc/sanitize_character()
	pref.show_in_directory		= sanitize_integer(pref.show_in_directory, 0, 1, initial(pref.show_in_directory))
	pref.directory_tag			= sanitize_inlist(pref.directory_tag, GLOB.char_directory_tags, initial(pref.directory_tag))
	pref.directory_erptag			= sanitize_inlist(pref.directory_erptag, GLOB.char_directory_erptags, initial(pref.directory_erptag))
	pref.sensorpref				= sanitize_integer(pref.sensorpref, 1, sensorpreflist.len, initial(pref.sensorpref))
	pref.capture_crystal		= sanitize_integer(pref.capture_crystal, 0, 1, initial(pref.capture_crystal))

/datum/category_item/player_setup_item/vore/misc/content(var/mob/user)
	. += "<br>"
	. += "<b>Appear in Character Directory:</b> <a [pref.show_in_directory ? "class='linkOn'" : ""] href='?src=\ref[src];toggle_show_in_directory=1'><b>[pref.show_in_directory ? "Yes" : "No"]</b></a><br>"
	. += "<b>Character Directory Vore Tag:</b> <a href='?src=\ref[src];directory_tag=1'><b>[pref.directory_tag]</b></a><br>"
	. += "<b>Character Directory ERP Tag:</b> <a href='?src=\ref[src];directory_erptag=1'><b>[pref.directory_erptag]</b></a><br>"
	. += "<b>Character Directory Advertisement:</b> <a href='?src=\ref[src];directory_ad=1'><b>Set Directory Ad</b></a><br>"
	. += "<b>Suit Sensors Preference:</b> <a [pref.sensorpref ? "" : ""] href='?src=\ref[src];toggle_sensor_setting=1'><b>[sensorpreflist[pref.sensorpref]]</b></a><br>"
	. += "<b>Capture Crystal Preference</b> <a [pref.capture_crystal ? "class='linkOn'" : ""] href='?src=\ref[src];toggle_capture_crystal=1'><b>[pref.capture_crystal ? "Yes" : "No"]</b></a><br>"

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
		var/msg = sanitize(tgui_input_text(user,"Write your advertisement here!", "Flavor Text", html_decode(pref.directory_ad), multiline = TRUE), extra = 0)	//VOREStation Edit: separating out OOC notes
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

	return ..();
