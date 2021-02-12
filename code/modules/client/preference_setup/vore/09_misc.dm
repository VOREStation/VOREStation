//TFF 5/8/19 - moved /datum/preferences to preferences_vr.dm

/datum/category_item/player_setup_item/vore/misc
	name = "Misc Settings"
	sort_order = 9

/datum/category_item/player_setup_item/vore/misc/load_character(var/savefile/S)
	S["show_in_directory"]		>> pref.show_in_directory
	S["directory_tag"]			>> pref.directory_tag
	S["directory_erptag"]			>> pref.directory_erptag
	S["directory_ad"]			>> pref.directory_ad
	S["sensorpref"]				>> pref.sensorpref	//TFF 5/8/19 - add sensor pref setting to load after saved

/datum/category_item/player_setup_item/vore/misc/save_character(var/savefile/S)
	S["show_in_directory"]		<< pref.show_in_directory
	S["directory_tag"]			<< pref.directory_tag
	S["directory_erptag"]			<< pref.directory_erptag
	S["directory_ad"]			<< pref.directory_ad
	S["sensorpref"]				<< pref.sensorpref	//TFF 5/8/19 - add sensor pref setting to be saveable

//TFF 5/8/19 - add new datum category to allow for setting multiple settings when this is selected in the loadout.
/datum/category_item/player_setup_item/vore/misc/copy_to_mob(var/mob/living/carbon/human/character)
	if(pref.sensorpref > 5 || pref.sensorpref < 1)
		pref.sensorpref = 5
	character.sensorpref = pref.sensorpref

/datum/category_item/player_setup_item/vore/misc/sanitize_character()
	pref.show_in_directory		= sanitize_integer(pref.show_in_directory, 0, 1, initial(pref.show_in_directory))
	pref.directory_tag			= sanitize_inlist(pref.directory_tag, GLOB.char_directory_tags, initial(pref.directory_tag))
	pref.directory_erptag			= sanitize_inlist(pref.directory_erptag, GLOB.char_directory_erptags, initial(pref.directory_erptag))
	pref.sensorpref				= sanitize_integer(pref.sensorpref, 1, sensorpreflist.len, initial(pref.sensorpref))	//TFF - 5/8/19 - add santisation for sensor prefs

/datum/category_item/player_setup_item/vore/misc/content(var/mob/user)
	. += "<br>"
	. += "<b>Appear in Character Directory:</b> <a [pref.show_in_directory ? "class='linkOn'" : ""] href='?src=\ref[src];toggle_show_in_directory=1'><b>[pref.show_in_directory ? "Yes" : "No"]</b></a><br>"
	. += "<b>Character Directory Vore Tag:</b> <a href='?src=\ref[src];directory_tag=1'><b>[pref.directory_tag]</b></a><br>"
	. += "<b>Character Directory ERP Tag:</b> <a href='?src=\ref[src];directory_erptag=1'><b>[pref.directory_erptag]</b></a><br>"
	. += "<b>Character Directory Advertisement:</b> <a href='?src=\ref[src];directory_ad=1'><b>Set Directory Ad</b></a><br>"
	. += "<b>Suit Sensors Preference:</b> <a [pref.sensorpref ? "" : ""] href='?src=\ref[src];toggle_sensor_setting=1'><b>[sensorpreflist[pref.sensorpref]]</b></a><br>"	//TFF 5/8/19 - Allow selection of sensor settings from off, binary, vitals, tracking, or random

/datum/category_item/player_setup_item/vore/misc/OnTopic(var/href, var/list/href_list, var/mob/user)
	if(href_list["toggle_show_in_directory"])
		pref.show_in_directory = pref.show_in_directory ? 0 : 1;
		return TOPIC_REFRESH
	else if(href_list["directory_tag"])
		var/new_tag = input(user, "Pick a new Vore tag for the character directory", "Character Vore Tag", pref.directory_tag) as null|anything in GLOB.char_directory_tags
		if(!new_tag)
			return
		pref.directory_tag = new_tag
		return TOPIC_REFRESH
	else if(href_list["directory_erptag"])
		var/new_erptag = input(user, "Pick a new ERP tag for the character directory", "Character ERP Tag", pref.directory_erptag) as null|anything in GLOB.char_directory_erptags
		if(!new_erptag)
			return
		pref.directory_erptag = new_erptag
		return TOPIC_REFRESH
	else if(href_list["directory_ad"])
		var/msg = sanitize(input(user,"Write your advertisement here!", "Flavor Text", html_decode(pref.directory_ad)) as message, extra = 0)	//VOREStation Edit: separating out OOC notes
		pref.directory_ad = msg
		return TOPIC_REFRESH
	//TFF 5/8/19 - add new thing so you can choose the sensor setting your character can get.
	else if(href_list["toggle_sensor_setting"])
		var/new_sensorpref = input(user, "Choose your character's sensor preferences:", "Character Preferences", sensorpreflist[pref.sensorpref]) as null|anything in sensorpreflist
		if (!isnull(new_sensorpref) && CanUseTopic(user))
			pref.sensorpref = sensorpreflist.Find(new_sensorpref)
			return TOPIC_REFRESH
	return ..();
