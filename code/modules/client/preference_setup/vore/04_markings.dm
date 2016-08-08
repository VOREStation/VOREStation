/datum/preferences
	var/body_markings		// Type of selected markings style
	var/r_markings = 30		//
	var/g_markings = 30		//
	var/b_markings = 30		//

/datum/category_item/player_setup_item/vore/markings
	name = "Body Markings appearance."
	sort_order = 4

/datum/category_item/player_setup_item/vore/markings/load_character(var/savefile/S)
	S["body_markings"]		>> pref.body_markings
	S["r_markings"]			>> pref.r_markings
	S["g_markings"]			>> pref.g_markings
	S["b_markings"]			>> pref.b_markings

/datum/category_item/player_setup_item/vore/markings/save_character(var/savefile/S)
	S["body_markings"]		<< pref.body_markings
	S["r_markings"]			<< pref.r_markings
	S["g_markings"]			<< pref.g_markings
	S["b_markings"]			<< pref.b_markings

/datum/category_item/player_setup_item/vore/markings/sanitize_character()
	pref.r_markings		= sanitize_integer(pref.r_markings, 0, 255, initial(pref.r_markings))
	pref.g_markings		= sanitize_integer(pref.g_markings, 0, 255, initial(pref.g_markings))
	pref.b_markings		= sanitize_integer(pref.b_markings, 0, 255, initial(pref.b_markings))

	if(pref.body_markings)
		pref.body_markings	= sanitize_inlist(pref.body_markings, body_markings_list, initial(pref.body_markings))

/datum/category_item/player_setup_item/vore/markings/copy_to_mob(var/mob/living/carbon/human/character)
	character.body_markings	= pref.body_markings

/datum/category_item/player_setup_item/vore/markings/copy_to_mob(var/mob/living/carbon/human/character)
	character.body_markings		= body_markings_list[pref.body_markings]
	character.r_markings			= pref.r_markings
	character.b_markings			= pref.b_markings
	character.g_markings			= pref.g_markings

/datum/category_item/player_setup_item/vore/markings/content(var/mob/user)

	. += "<b>Markings</b><br>"
	. += " Style: <a href='?src=\ref[src];body_markings=1'>[pref.tail_style ? "Custom" : "Normal"]</a><br>"

	if(body_markings_list[pref.body_markings])
		var/datum/sprite_accessory/body_markings/T = body_markings_list[pref.body_markings]
		if (T.do_colouration)
			. += "<a href='?src=\ref[src];markings_color=1'>Change Color</a> <font face='fixedsys' size='3' color='#[num2hex(pref.r_markings, 2)][num2hex(pref.g_markings, 2)][num2hex(pref.b_markings, 2)]'><table style='display:inline;' bgcolor='#[num2hex(pref.r_markings, 2)][num2hex(pref.g_markings, 2)][num2hex(pref.b_markings)]'><tr><td>__</td></tr></table> </font><br>"


/datum/category_item/player_setup_item/vore/markings/OnTopic(var/href, var/list/href_list, var/mob/user)
	if(!CanUseTopic(user))
		return TOPIC_NOACTION

	if(href_list["body_markings"])
		var/list/pretty_markings_styles = list("Vulpine", "Earfluff", "Kita")
		for(var/path in body_markings_list)
	//		var/datum/sprite_accessory/body_markings/instance = body_markings_list[path]

		// Present choice to user
		var/selection = input(user, "Pick markings", "Character Preference") as null|anything in pretty_markings_styles
		if(selection && selection != "Normal")
			pref.body_markings = pretty_markings_styles[selection]
		else
			pref.body_markings = null
		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["markings_color"])
		var/new_markingsc = input(user, "Choose your character's markings colour:", "Character Preference",
			rgb(pref.r_markings, pref.g_markings, pref.b_markings)) as color|null
		if(new_markingsc)
			pref.r_markings = hex2num(copytext(new_markingsc, 2, 4))
			pref.g_markings = hex2num(copytext(new_markingsc, 4, 6))
			pref.b_markings = hex2num(copytext(new_markingsc, 6, 8))
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["toggle_clothing"])
		pref.dress_mob = !pref.dress_mob
		return TOPIC_REFRESH_UPDATE_PREVIEW

	return ..()