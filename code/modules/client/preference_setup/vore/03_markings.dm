/datum/category_item/player_setup_item/vore/markings
	name = "Body Markings"
	sort_order = 3

//save set up
/datum/preferences
//Marking colour and style
	var/r_markings = 0
	var/g_markings = 0
	var/b_markings = 0
	var/m_style = "None"

/datum/category_item/player_setup_item/vore/markings
//Marking colour and style because wtf
	var/r_markings = 0
	var/g_markings = 0
	var/b_markings = 0
	var/m_style = "None"

//defs, etc.
/datum/category_item/player_setup_item/vore/markings/load_character(var/savefile/S)
	S["m_style"]			>> pref.m_style
	S["r_markings"]			>> pref.r_markings
	S["g_markings"]			>> pref.g_markings
	S["b_markings"]			>> pref.b_markings

/datum/category_item/player_setup_item/vore/markings/save_character(var/savefile/S)
	S["m_style"]			<< pref.m_style
	S["r_markings"]			<< pref.r_markings
	S["g_markings"]			<< pref.g_markings
	S["b_markings"]			<< pref.b_markings

/datum/category_item/player_setup_item/vore/markings/sanitize_character()
	pref.r_markings		= sanitize_integer(pref.r_markings, 0, 255, initial(pref.r_markings))
	pref.g_markings		= sanitize_integer(pref.g_markings, 0, 255, initial(pref.g_markings))
	pref.b_markings		= sanitize_integer(pref.b_markings, 0, 255, initial(pref.b_markings))
	pref.m_style			= sanitize_inlist(m_style, marking_styles_list, initial(pref.m_style))

/datum/category_item/player_setup_item/vore/markings/copy_to_mob(var/mob/living/carbon/human/character)
	if(character.species.bodyflags & HAS_MARKINGS)
		character.r_markings = r_markings
		character.g_markings = g_markings
		character.b_markings = b_markings
		character.m_style = m_style

datum/category_item/player_setup_item/vore/markings/content(var/mob/user)

	. += "<br><b>Body Markings</b><br>"
	. += "<a href='?_src_=prefs;preference=markings;task=input'>Change Color</a> <font face='fixedsys' size='3' color='#[num2hex(r_markings, 2)][num2hex(g_markings, 2)][num2hex(b_markings, 2)]'><table style='display:inline;' bgcolor='#[num2hex(r_markings, 2)][num2hex(g_markings, 2)][num2hex(b_markings)]'><tr><td>__</td></tr></table></font> "
	. += "<br>Style: <a href='?_src_=prefs;preference=m_style;task=input'>[m_style]</a><br>"

/datum/category_item/player_setup_item/vore/markings/OnTopic(var/href,var/list/href_list, var/mob/user)
	if(!CanUseTopic(user))
		return TOPIC_NOACTION

	if(href_list["body_markings"])
		var/list/valid_markings = list()
		for(var/markingstyle in marking_styles_list)
			var/datum/sprite_accessory/M = marking_styles_list[markingstyle]
			if( !(species in M.species_allowed))
				continue

			valid_markings[markingstyle] = marking_styles_list[markingstyle]

		var/new_marking_style = input(user, "Choose the style of your character's body markings:", "Character Preference") as null|anything in valid_markings
		if(new_marking_style)
			m_style = new_marking_style

		// Present choice to user
		var/selection = input(user, "Pick markings", "Character Preference") as null|anything in body_markings_styles
		if(selection && selection != "Normal")
			pref.body_markings = body_markings_styles[selection]
		else
			pref.body_markings = null
		return TOPIC_REFRESH

	else if(href_list["body_markings_color"])
		var/input = "Choose the colour of your your character's body markings:"
			var/new_markings = input(user, input, "Character Preference", rgb(r_markings, g_markings, b_markings)) as color|null
			if(new_markings)
				r_markings = hex2num(copytext(new_markings, 2, 4))
				g_markings = hex2num(copytext(new_markings, 4, 6))
				b_markings = hex2num(copytext(new_markings, 6, 8))
				return TOPIC_REFRESH