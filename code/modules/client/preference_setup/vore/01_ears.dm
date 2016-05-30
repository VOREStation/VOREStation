// Super Global Stuff
/datum/category_collection/player_setup_collection/proc/copy_to_mob(var/mob/living/carbon/human/C)
	for(var/datum/category_group/player_setup_category/PS in categories)
		PS.copy_to_mob(C)

/datum/category_group/player_setup_category/proc/copy_to_mob(var/mob/living/carbon/human/C)
	for(var/datum/category_item/player_setup_item/PI in items)
		PI.copy_to_mob(C)

/datum/category_item/player_setup_item/proc/copy_to_mob(var/mob/living/carbon/human/C)
	return

// Global stuff that will put us on the map
/datum/category_group/player_setup_category/vore
	name = "VORE"
	sort_order = 7
	category_item_type = /datum/category_item/player_setup_item/vore

// Define a place to save appearance in character setup
/datum/preferences
	var/custom_species	// Custom species name
	var/ear_style		// Type of selected ear style
	var/tail_style		// Type of selected tail style
	var/r_tail = 30		// Tail/Taur color
	var/g_tail = 30		// Tail/Taur color
	var/b_tail = 30		// Tail/Taur color

	//Marking colour and style
	var/r_markings = 0
	var/g_markings = 0
	var/b_markings = 0
	var/m_style = "None"

// Definition of the stuff for Ears
/datum/category_item/player_setup_item/vore/ears
	name = "Appearance"
	sort_order = 1

/datum/category_item/player_setup_item/vore/ears/load_character(var/savefile/S)
	S["custom_species"]	>> pref.custom_species
	S["ear_style"]		>> pref.ear_style
	S["tail_style"]		>> pref.tail_style
	S["r_tail"]			>> pref.r_tail
	S["g_tail"]			>> pref.g_tail
	S["b_tail"]			>> pref.b_tail
	S["m_style"]		>> pref.m_style
	S["r_markings"]			>> pref.r_markings
	S["g_markings"]			>> pref.g_markings
	S["b_markings"]			>> pref.b_markings

/datum/category_item/player_setup_item/vore/ears/save_character(var/savefile/S)
	S["custom_species"]	<< pref.custom_species
	S["ear_style"]		<< pref.ear_style
	S["tail_style"]		<< pref.tail_style
	S["r_tail"]			<< pref.r_tail
	S["g_tail"]			<< pref.g_tail
	S["b_tail"]			<< pref.b_tail
	S["m_style"]		<< pref.m_style
	S["r_markings"]			<< pref.r_markings
	S["g_markings"]			<< pref.g_markings
	S["b_markings"]			<< pref.b_markings

/datum/category_item/player_setup_item/vore/ears/sanitize_character()
	pref.r_tail		= sanitize_integer(pref.r_tail, 0, 255, initial(pref.r_tail))
	pref.g_tail		= sanitize_integer(pref.g_tail, 0, 255, initial(pref.g_tail))
	pref.b_tail		= sanitize_integer(pref.b_tail, 0, 255, initial(pref.b_tail))
	if(pref.ear_style)
		pref.ear_style	= sanitize_inlist(pref.ear_style, ear_styles_list, initial(pref.ear_style))
	if(pref.tail_style)
		pref.tail_style	= sanitize_inlist(pref.tail_style, tail_styles_list, initial(pref.tail_style))
	pref.r_markings		= sanitize_integer(pref.r_markings, 0, 255, initial(pref.r_markings))
	pref.g_markings		= sanitize_integer(pref.g_markings, 0, 255, initial(pref.g_markings))
	pref.b_markings		= sanitize_integer(pref.b_markings, 0, 255, initial(pref.b_markings))
	pref.m_style			= sanitize_inlist(m_style, marking_styles_list, initial(pref.m_style))

/datum/category_item/player_setup_item/vore/ears/copy_to_mob(var/mob/living/carbon/human/character)
	character.custom_species	= pref.custom_species
	character.ear_style			= ear_styles_list[pref.ear_style]
	character.tail_style		= tail_styles_list[pref.tail_style]
	character.r_tail			= pref.r_tail
	character.b_tail			= pref.b_tail
	character.g_tail			= pref.g_tail

	if(character.species.bodyflags & HAS_MARKINGS)
		character.r_markings = r_markings
		character.g_markings = g_markings
		character.b_markings = b_markings
		character.m_style = m_style

/datum/category_item/player_setup_item/vore/ears/content(var/mob/user)
	. += "<h2>VORE Station Settings</h2>"

	pref.update_preview_icon()
	if(pref.preview_icon_front && pref.preview_icon_side)
		user << browse_rsc(pref.preview_icon_front, "preview_icon.png")
		user << browse_rsc(pref.preview_icon_side, "preview_icon2.png")
	. += "<b>Preview</b><br>"
	. += "<img src=preview_icon.png height=64 width=64><img src=preview_icon2.png height=64 width=64><br>"

	. += "<b>Ears</b><br>"
	. += " Style: <a href='?src=\ref[src];ear_style=1'>[pref.ear_style ? "Custom" : "Normal"]</a><br>"

	. += "<b>Tail</b><br>"
	. += " Style: <a href='?src=\ref[src];tail_style=1'>[pref.tail_style ? "Custom" : "Normal"]</a><br>"
	if(tail_styles_list[pref.tail_style])
		var/datum/sprite_accessory/tail/T = tail_styles_list[pref.tail_style]
		if (T.do_colouration)
			. += "<a href='?src=\ref[src];tail_color=1'>Change Color</a> <font face='fixedsys' size='3' color='#[num2hex(pref.r_tail, 2)][num2hex(pref.g_tail, 2)][num2hex(pref.b_tail, 2)]'><table style='display:inline;' bgcolor='#[num2hex(pref.r_tail, 2)][num2hex(pref.g_tail, 2)][num2hex(pref.b_tail)]'><tr><td>__</td></tr></table> </font><br>"

	. += "<b>Custom Species</b> "
	. += "<a href='?src=\ref[src];custom_species=1'>[pref.custom_species ? pref.custom_species : "None"]</a><br>"

	. += "<br><b>Body Markings</b><br>"
	. += "<a href='?_src_=prefs;preference=markings;task=input'>Change Color</a> <font face='fixedsys' size='3' color='#[num2hex(r_markings, 2)][num2hex(g_markings, 2)][num2hex(b_markings, 2)]'><table style='display:inline;' bgcolor='#[num2hex(r_markings, 2)][num2hex(g_markings, 2)][num2hex(b_markings)]'><tr><td>__</td></tr></table></font> "
	. += "<br>Style: <a href='?_src_=prefs;preference=m_style;task=input'>[m_style]</a><br>"

/datum/category_item/player_setup_item/vore/ears/OnTopic(var/href,var/list/href_list, var/mob/user)
	if(!CanUseTopic(user))
		return TOPIC_NOACTION

	else if(href_list["custom_species"])
		var/raw_choice = sanitize(input(user, "Input your character's species:",
			"Character Preference", pref.custom_species) as null|text, MAX_NAME_LEN)
		if (raw_choice && CanUseTopic(user))
			pref.custom_species = raw_choice
		return TOPIC_REFRESH

	else if(href_list["ear_style"])
		// Construct the list of names allowed for this user.
		var/list/pretty_ear_styles = list("Normal")
		for(var/path in ear_styles_list)
			var/datum/sprite_accessory/ears/instance = ear_styles_list[path]
			if((!instance.ckeys_allowed) || (usr.ckey in instance.ckeys_allowed))
				pretty_ear_styles[instance.name] = path

		// Present choice to user
		var/selection = input(user, "Pick ears", "Character Preference") as null|anything in pretty_ear_styles
		if(selection && selection != "Normal")
			pref.ear_style = pretty_ear_styles[selection]
		else
			pref.ear_style = null
		return TOPIC_REFRESH

	else if(href_list["tail_style"])
		// Construct the list of names allowed for this user.
		var/list/pretty_tail_styles = list("Normal")
		for(var/path in tail_styles_list)
			var/datum/sprite_accessory/tail/instance = tail_styles_list[path]
			if((!instance.ckeys_allowed) || (user.ckey in instance.ckeys_allowed))
				pretty_tail_styles[instance.name] = path

		// Present choice to user
		var/selection = input(user, "Pick tails", "Character Preference") as null|anything in pretty_tail_styles
		if(selection && selection != "Normal")
			pref.tail_style = pretty_tail_styles[selection]
		else
			pref.tail_style = null
		return TOPIC_REFRESH

	else if(href_list["tail_color"])
		var/new_tailc = input(user, "Choose your character's tail/taur colour:", "Character Preference",
			rgb(pref.r_tail, pref.g_tail, pref.b_tail)) as color|null
		if(new_tailc)
			pref.r_tail = hex2num(copytext(new_tailc, 2, 4))
			pref.g_tail = hex2num(copytext(new_tailc, 4, 6))
			pref.b_tail = hex2num(copytext(new_tailc, 6, 8))
			return TOPIC_REFRESH

	else if(href_list["body_markings"])
		if((species in list("Unathi", "Vulpkanin", "Tajaran"))) // Species with markings
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

	return ..()