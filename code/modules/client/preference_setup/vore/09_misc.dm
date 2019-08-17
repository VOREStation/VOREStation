//TFF 5/8/19 - moved /datum/preferences to preferences_vr.dm

/datum/category_item/player_setup_item/vore/misc
	name = "Misc Settings"
	sort_order = 9

/datum/category_item/player_setup_item/vore/misc/load_character(var/savefile/S)
	S["show_in_directory"]		>> pref.show_in_directory
	S["sensorpref"]				>> pref.sensorpref	//TFF 5/8/19 - add sensor pref setting to load after saved

/datum/category_item/player_setup_item/vore/misc/save_character(var/savefile/S)
	S["show_in_directory"]		<< pref.show_in_directory
	S["sensorpref"]				<< pref.sensorpref	//TFF 5/8/19 - add sensor pref setting to be saveable

//TFF 5/8/19 - add new datum category to allow for setting multiple settings when this is selected in the loadout.
/datum/category_item/player_setup_item/vore/misc/copy_to_mob(var/mob/living/carbon/human/character)
	if(pref.sensorpref > 5 || pref.sensorpref < 1)
		pref.sensorpref = 5
	character.sensorpref = pref.sensorpref

/datum/category_item/player_setup_item/vore/misc/sanitize_character()
	pref.show_in_directory		= sanitize_integer(pref.show_in_directory, 0, 1, initial(pref.show_in_directory))
	pref.sensorpref				= sanitize_integer(pref.sensorpref, 1, sensorpreflist.len, initial(pref.sensorpref))	//TFF - 5/8/19 - add santisation for sensor prefs

/datum/category_item/player_setup_item/vore/misc/content(var/mob/user)
	. += "<br>"
	. += "<b>Appear in Character Directory:</b> <a [pref.show_in_directory ? "class='linkOn'" : ""] href='?src=\ref[src];toggle_show_in_directory=1'><b>[pref.show_in_directory ? "Yes" : "No"]</b></a><br>"
	. += "<b>Suit Sensors Preference:</b> <a [pref.sensorpref ? "" : ""] href='?src=\ref[src];toggle_sensor_setting=1'><b>[sensorpreflist[pref.sensorpref]]</b></a><br>"	//TFF 5/8/19 - Allow selection of sensor settings from off, binary, vitals, tracking, or random

/datum/category_item/player_setup_item/vore/misc/OnTopic(var/href, var/list/href_list, var/mob/user)
	if(href_list["toggle_show_in_directory"])
		pref.show_in_directory = pref.show_in_directory ? 0 : 1;
		return TOPIC_REFRESH
	//TFF 5/8/19 - add new thing so you can choose the sensor setting your character can get.
	else if(href_list["toggle_sensor_setting"])
		var/new_sensorpref = input(user, "Choose your character's sensor preferences:", "Character Preferences", sensorpreflist[pref.sensorpref]) as null|anything in sensorpreflist
		if (!isnull(new_sensorpref) && CanUseTopic(user))
			pref.sensorpref = sensorpreflist.Find(new_sensorpref)
			return TOPIC_REFRESH
	return ..();
