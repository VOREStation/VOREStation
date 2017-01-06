/datum/category_item/player_setup_item/vore/genitals
	name = "Genitals"
	sort_order = 4

/datum/category_item/player_setup_item/vore/genitals/load_character(var/savefile/S)
	S["c_type"]				>> pref.c_type
	S["d_type"]				>> pref.d_type
	S["v_type"]				>> pref.v_type
	S["r_genital"]			>> pref.r_genital
	S["g_genital"]			>> pref.g_genital
	S["b_genital"]			>> pref.b_genital

/datum/category_item/player_setup_item/vore/genitals/save_character(var/savefile/S)
	S["c_type"]				<< pref.c_type
	S["d_type"]				<< pref.d_type
	S["v_type"]				<< pref.v_type
	S["r_genital"]			<< pref.r_genital
	S["g_genital"]			<< pref.g_genital
	S["b_genital"]			<< pref.b_genital

/datum/category_item/player_setup_item/vore/genitals/sanitize_character(var/savefile/S)
	pref.c_type			= sanitize_inlist(pref.c_type, body_breast_list, initial(pref.c_type))
	pref.d_type			= sanitize_inlist(pref.d_type, body_dicks_list, initial(pref.d_type))
	pref.v_type			= sanitize_inlist(pref.v_type, body_vaginas_list, initial(pref.v_type))
	pref.r_genital		= sanitize_integer(pref.r_genital, 0, 255, initial(pref.r_genital))
	pref.g_genital		= sanitize_integer(pref.g_genital, 0, 255, initial(pref.g_genital))
	pref.b_genital		= sanitize_integer(pref.b_genital, 0, 255, initial(pref.b_genital))

/datum/category_item/player_setup_item/vore/genitals/content(var/mob/user)

	. += "<table><tr style='vertical-align:top'><td><b>Sexual Organs</b> "
	. += "<br>"
	. += "Chest Type: <a href='?src=\ref[src];chest_type=1'>[pref.c_type]</a><br>"
	. += "Dick Type: <a href='?src=\ref[src];dick_type=1'>[pref.d_type]</a><br>"
	. += "Vagina Type: <a href='?src=\ref[src];vagina_type=1'>[pref.v_type]</a><br>"
	. += "<b>Genitals Color</b><br>"
	. += "<a href='?src=\ref[src];genital_color=1'>Genitals Color</a> <font face='fixedsys' size='3' color='#[num2hex(pref.r_genital, 2)][num2hex(pref.g_genital, 2)][num2hex(pref.b_genital, 2)]'><table style='display:inline;' bgcolor='#[num2hex(pref.r_genital, 2)][num2hex(pref.g_genital, 2)][num2hex(pref.b_genital)]'><tr><td>__</td></tr></table></font><br>"
	. += "<br>"

/datum/category_item/player_setup_item/vore/genitals/copy_to_mob(var/mob/living/carbon/human/character)
	character.c_type	= pref.c_type
	character.d_type	= pref.d_type
	character.v_type	= pref.v_type
	character.r_genital	= pref.r_genital
	character.g_genital	= pref.g_genital
	character.b_genital	= pref.b_genital


/datum/category_item/player_setup_item/vore/genitals/OnTopic(var/href,var/list/href_list, var/mob/user)

	var/datum/species/mob_species = all_species[pref.species]

	if(href_list["chest_type"])
		var/list/valid_chest_types = list()
		for (var/boobs in body_breast_list)
			var/datum/sprite_accessory/S = body_breast_list[boobs]
			if(!(mob_species.get_bodytype() in S.species_allowed))
				continue
			valid_chest_types[boobs] = body_breast_list[boobs]
			if (valid_chest_types.len)
				pref.c_type = pick(valid_chest_types)
			else
				pref.c_type = body_breast_list["None"]
		var/new_c_type = input(user, "Choose your character's Breasts:", "Character Preference") as null|anything in valid_chest_types
		if(new_c_type && CanUseTopic(user))
			pref.c_type = new_c_type
		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["dick_type"])
		var/list/valid_dick_types = list()
		for (var/dicks in body_dicks_list)
			var/datum/sprite_accessory/S = body_dicks_list[dicks]
			if(!(mob_species.get_bodytype() in S.species_allowed))
				continue
			valid_dick_types[dicks] = body_dicks_list[dicks]
			if (valid_dick_types.len)
				pref.d_type = pick(valid_dick_types)
			else
				pref.d_type = body_dicks_list["None"]
		var/new_d_type = input(user, "Choose your character's Dick:", "Character Preference") as null|anything in valid_dick_types
		if(new_d_type && CanUseTopic(user))
			pref.d_type = new_d_type
		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["vagina_type"])
		var/list/valid_vagina_types = list()
		for (var/vaginas in body_vaginas_list)
			var/datum/sprite_accessory/S = body_vaginas_list[vaginas]
			if(!(mob_species.get_bodytype() in S.species_allowed))
				continue
			valid_vagina_types[vaginas] = body_vaginas_list[vaginas]
			if (valid_vagina_types.len)
				pref.v_type = pick(valid_vagina_types)
			else
				pref.v_type = body_vaginas_list["None"]
		var/new_v_type = input(user, "Choose your character's Vagina:", "Character Preference") as null|anything in valid_vagina_types
		if(new_v_type && CanUseTopic(user))
			pref.v_type = new_v_type
		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["genital_color"])
		var/new_genital = input(user, "Choose your character's Genitals colour: ", "Character Preference", rgb(pref.r_genital, pref.g_genital, pref.b_genital)) as color|null
		pref.r_genital = hex2num(copytext(new_genital, 2, 4))
		pref.g_genital = hex2num(copytext(new_genital, 4, 6))
		pref.b_genital = hex2num(copytext(new_genital, 6, 8))
		return TOPIC_REFRESH_UPDATE_PREVIEW
