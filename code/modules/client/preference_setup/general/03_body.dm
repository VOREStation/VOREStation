/datum/preferences
	var/equip_preview_mob = EQUIP_PREVIEW_ALL
	var/animations_toggle = FALSE

	var/icon/bgstate = "steel"
	var/list/bgstate_options = list("steel", "000", "midgrey", "FFF", "white", "techmaint", "desert", "grass", "snow")

	var/ear_style		// Type of selected ear style

	/// The typepath of the character's selected secondary ears.
	var/ear_secondary_style
	/// The color channels for the character's selected secondary ears
	///
	/// * This is a lazy list. Its length, when populated, should but cannot be assumed
	///   to be the number of color channels supported by the secondary ear style.
	var/list/ear_secondary_colors = list()

	var/tail_style		// Type of selected tail style

	var/wing_style		// Type of selected wing style

	var/datum/browser/markings_subwindow = null

// Sanitize ear/wing/tail styles
/datum/preferences/proc/sanitize_body_styles()

	// Grandfather in anyone loading paths from a save.
	if(ispath(ear_style, /datum/sprite_accessory))
		var/datum/sprite_accessory/instance = GLOB.ear_styles_list[ear_style]
		if(istype(instance))
			ear_style = instance.name
	if(ispath(wing_style, /datum/sprite_accessory))
		var/datum/sprite_accessory/instance = GLOB.wing_styles_list[wing_style]
		if(istype(instance))
			wing_style = instance.name
	if(ispath(tail_style, /datum/sprite_accessory))
		var/datum/sprite_accessory/instance = GLOB.tail_styles_list[tail_style]
		if(istype(instance))
			tail_style = instance.name

	// Sanitize for non-existent keys.
	if(ear_style && !(ear_style in get_available_styles(GLOB.ear_styles_list)))
		ear_style = null
	if(ear_secondary_style && !(ear_secondary_style in get_available_styles(GLOB.ear_styles_list)))
		ear_secondary_style = null
	if(wing_style && !(wing_style in get_available_styles(GLOB.wing_styles_list)))
		wing_style = null
	if(tail_style && !(tail_style in get_available_styles(GLOB.tail_styles_list)))
		tail_style = null

/datum/preferences/proc/get_available_styles(var/style_list)
	. = list("Normal" = null)
	for(var/path in style_list)
		var/datum/sprite_accessory/instance = style_list[path]
		if(!istype(instance))
			continue
		if(instance.name == DEVELOPER_WARNING_NAME)
			continue
		if(instance.ckeys_allowed && (!client || !(client.ckey in instance.ckeys_allowed)))
			continue
		if(instance.species_allowed && (!species || !(species in instance.species_allowed)) && (!client || !check_rights_for(client, R_ADMIN | R_EVENT | R_FUN)) && (!custom_base || !(custom_base in instance.species_allowed)))
			continue
		if(!instance.can_be_selected && (!client || !check_rights_for(client, R_HOLDER)))
			continue
		.[instance.name] = instance

/datum/preferences/proc/mass_edit_marking_list(var/marking, var/change_on = TRUE, var/change_color = TRUE, var/marking_value = null, var/on = TRUE, var/color = "#000000")
	var/datum/sprite_accessory/marking/mark_datum = GLOB.body_marking_styles_list[marking]
	var/list/new_marking = marking_value||mark_datum.body_parts
	for (var/NM in new_marking)
		if (marking_value && !islist(new_marking[NM])) continue
		new_marking[NM] = list("on" = (!change_on && marking_value) ? marking_value[NM]["on"] : on, "color" = (!change_color && marking_value) ? marking_value[NM]["color"] : color)
	if (change_color)
		new_marking["color"] = color
	return new_marking

/datum/category_item/player_setup_item/general/body
	name = "Body"
	sort_order = 3

/datum/category_item/player_setup_item/general/body/load_character(list/save_data)
	pref.species			= save_data["species"]
	pref.s_tone				= save_data["skin_tone"]
	pref.h_style			= save_data["hair_style_name"]
	pref.f_style			= save_data["facial_style_name"]
	pref.grad_style			= save_data["grad_style_name"]
	pref.b_type				= save_data["b_type"]
	pref.organ_data			= check_list_copy(save_data["organ_data"])
	pref.rlimb_data			= check_list_copy(save_data["rlimb_data"])
	pref.body_markings		= check_list_copy(save_data["body_markings"])
	for(var/i in pref.body_markings)
		pref.body_markings[i] = check_list_copy(pref.body_markings[i])
		for(var/j in pref.body_markings[i])
			pref.body_markings[i][j] = check_list_copy(pref.body_markings[i][j])
	pref.synth_color		= save_data["synth_color"]
	pref.synth_markings		= save_data["synth_markings"]
	pref.bgstate			= save_data["bgstate"]
	pref.ear_style			= save_data["ear_style"]
	pref.ear_secondary_style = save_data["ear_secondary_style"]
	pref.ear_secondary_colors = save_data["ear_secondary_colors"]
	pref.tail_style			= save_data["tail_style"]
	pref.wing_style			= save_data["wing_style"]
	pref.digitigrade 		= save_data["digitigrade"]

/datum/category_item/player_setup_item/general/body/save_character(list/save_data)
	save_data["species"]			= pref.species
	save_data["skin_tone"]			= pref.s_tone
	save_data["hair_style_name"]	= pref.h_style
	save_data["facial_style_name"]	= pref.f_style
	save_data["grad_style_name"]	= pref.grad_style
	save_data["b_type"]				= pref.b_type
	save_data["organ_data"]			= check_list_copy(pref.organ_data)
	save_data["rlimb_data"]			= check_list_copy(pref.rlimb_data)
	var/list/body_markings 			= check_list_copy(pref.body_markings)
	for(var/i in pref.body_markings)
		body_markings[i] = check_list_copy(body_markings[i])
		for(var/j in body_markings[i])
			body_markings[i][j] = check_list_copy(body_markings[i][j])
	save_data["body_markings"]		= body_markings
	save_data["synth_color"]		= pref.synth_color
	save_data["synth_markings"]		= pref.synth_markings
	save_data["bgstate"]			= pref.bgstate
	save_data["ear_style"]			= pref.ear_style
	save_data["ear_secondary_style"] = pref.ear_secondary_style
	save_data["ear_secondary_colors"] = pref.ear_secondary_colors
	save_data["tail_style"]			= pref.tail_style
	save_data["wing_style"]			= pref.wing_style
	save_data["digitigrade"]		= pref.digitigrade

/datum/category_item/player_setup_item/general/body/sanitize_character()
	if(!pref.species || !(pref.species in GLOB.playable_species))
		pref.species = SPECIES_HUMAN
	pref.s_tone			= sanitize_integer(pref.s_tone, -185, 34, initial(pref.s_tone))
	pref.h_style		= sanitize_inlist(pref.h_style, GLOB.hair_styles_list, initial(pref.h_style))
	pref.f_style		= sanitize_inlist(pref.f_style, GLOB.facial_hair_styles_list, initial(pref.f_style))
	pref.grad_style		= sanitize_inlist(pref.grad_style, GLOB.hair_gradients, initial(pref.grad_style))
	pref.b_type			= sanitize_text(pref.b_type, initial(pref.b_type))

	if(!pref.organ_data) pref.organ_data = list()
	if(!pref.rlimb_data || !islist(pref.rlimb_data)) pref.rlimb_data = list()
	if(!pref.body_markings) pref.body_markings = list()
	else pref.body_markings &= GLOB.body_marking_styles_list
	for (var/M in pref.body_markings)
		if (!islist(pref.body_markings[M]))
			var/col = istext(pref.body_markings[M]) ? pref.body_markings[M] : "#000000"
			pref.body_markings[M] = pref.mass_edit_marking_list(M,color=col)
	for(var/limb in pref.rlimb_data)
		var/key = pref.rlimb_data[limb]
		if(!istext(key))
			pref.rlimb_data -= limb
		if(!LAZYACCESS(GLOB.all_robolimbs, key))
			pref.rlimb_data -= limb
	if(!pref.bgstate || !(pref.bgstate in pref.bgstate_options))
		pref.bgstate = "000"

	// sanitize secondary ears
	pref.ear_secondary_colors = SANITIZE_LIST(pref.ear_secondary_colors)
	if(length(pref.ear_secondary_colors) > length(GLOB.fancy_sprite_accessory_color_channel_names))
		pref.ear_secondary_colors.len = length(GLOB.fancy_sprite_accessory_color_channel_names)
	for(var/i in 1 to length(pref.ear_secondary_colors))
		pref.ear_secondary_colors[i] = sanitize_hexcolor(pref.ear_secondary_colors[i], "#ffffff")

	pref.digitigrade	= sanitize_integer(pref.digitigrade, 0, 1, initial(pref.digitigrade))

	pref.sanitize_body_styles()

// Moved from /datum/preferences/proc/copy_to()
/datum/category_item/player_setup_item/general/body/copy_to_mob(var/mob/living/carbon/human/character)
	// Copy basic values
	character.h_style	= pref.h_style
	character.f_style	= pref.f_style
	character.s_tone	= pref.s_tone
	character.h_style	= pref.h_style
	character.f_style	= pref.f_style
	character.grad_style= pref.grad_style
	character.dna.b_type= pref.b_type
	character.synth_color = pref.synth_color
	character.synth_markings = pref.synth_markings
	character.digitigrade = pref.digitigrade

	//sanity check
	if(character.digitigrade == null)
		character.digitigrade = 0
		pref.digitigrade = 0

	var/list/ear_styles = pref.get_available_styles(GLOB.ear_styles_list)
	character.ear_style =  ear_styles[pref.ear_style]

	// apply secondary ears; sanitize again to prevent runtimes in rendering
	character.ear_secondary_style = ear_styles[pref.ear_secondary_style]
	character.ear_secondary_colors = SANITIZE_LIST(pref.ear_secondary_colors)

	var/list/tail_styles = pref.get_available_styles(GLOB.tail_styles_list)
	character.tail_style = tail_styles[pref.tail_style]

	var/list/wing_styles = pref.get_available_styles(GLOB.wing_styles_list)
	character.wing_style = wing_styles[pref.wing_style]

	character.set_gender(pref.biological_gender)

	character.synthetic = pref.species == "Protean" ? GLOB.all_robolimbs["protean"] : null //Clear the existing var. (unless protean, then switch it to the normal protean limb)
	var/list/organs_to_edit = list()
	for (var/name in list(BP_TORSO, BP_HEAD, BP_GROIN, BP_L_ARM, BP_R_ARM, BP_L_HAND, BP_R_HAND, BP_L_LEG, BP_R_LEG, BP_L_FOOT, BP_R_FOOT))
		var/obj/item/organ/external/O = character.organs_by_name[name]
		if (O)
			var/x = organs_to_edit.Find(O.parent_organ)
			if (x == 0)
				organs_to_edit += name
			else
				organs_to_edit.Insert(x+(O.robotic == ORGAN_NANOFORM ? 1 : 0), name)
	for(var/name in organs_to_edit)
		var/status = pref.organ_data[name]
		var/obj/item/organ/external/O = character.organs_by_name[name]
		if(O)
			if(status == "amputated")
				O.remove_rejuv()
			else if(status == "cyborg")
				if(pref.rlimb_data[name])
					O.robotize(pref.rlimb_data[name])
				else
					O.robotize()

	for(var/name in list(O_HEART,O_EYES,O_VOICE,O_LUNGS,O_LIVER,O_KIDNEYS,O_SPLEEN,O_STOMACH,O_INTESTINE,O_BRAIN))
		var/status = pref.organ_data[name]
		if(!status)
			continue
		var/obj/item/organ/I = character.internal_organs_by_name[name]
		if(istype(I, /obj/item/organ/internal/brain))
			var/obj/item/organ/external/E = character.get_organ(I.parent_organ)
			if(E.robotic < ORGAN_ASSISTED)
				continue
		if(I)
			if(status == FBP_ASSISTED)
				I.mechassist()
			else if(status == FBP_MECHANICAL)
				I.robotize()
			else if(status == FBP_DIGITAL)
				I.digitize()

	for(var/N in character.organs_by_name)
		var/obj/item/organ/external/O = character.organs_by_name[N]
		O.markings.Cut()

	var/priority = 0
	for(var/M in pref.body_markings)
		priority += 1
		var/datum/sprite_accessory/marking/mark_datum = GLOB.body_marking_styles_list[M]

		for(var/BP in mark_datum.body_parts)
			var/obj/item/organ/external/O = character.organs_by_name[BP]
			if(O && islist(O.markings) && islist(pref.body_markings[M]) && islist(pref.body_markings[M][BP]))
				O.markings[M] = list("color" = pref.body_markings[M][BP]["color"], "datum" = mark_datum, "priority" = priority, "on" = pref.body_markings[M][BP]["on"])
	character.markings_len = priority

/datum/category_item/player_setup_item/general/body/proc/has_flag(var/datum/species/mob_species, var/flag)
	return mob_species && (mob_species.appearance_flags & flag)

/datum/category_item/player_setup_item/general/body/proc/reset_limbs()
	for(var/organ in pref.organ_data)
		pref.organ_data[organ] = null
	while(null in pref.organ_data)
		pref.organ_data -= null

	for(var/organ in pref.rlimb_data)
		pref.rlimb_data[organ] = null
	while(null in pref.rlimb_data)
		pref.rlimb_data -= null

	// Sanitize the name so that there aren't any numbers sticking around.
	// Is this still necessary with TG conversation?
	var/current_name = pref.read_preference(/datum/preference/name/real_name)
	current_name = sanitize_name(current_name, pref.species)
	if(!current_name)
		current_name = random_name(pref.identifying_gender, pref.species)
	pref.update_preference_by_type(/datum/preference/name/real_name, current_name)

/datum/category_item/player_setup_item/general/body/tgui_data(mob/user, datum/tgui/ui, datum/tgui_state/state)
	var/list/data = ..()


	data["species"] = pref.species
	data["organ_data"] = pref.organ_data
	data["rlimb_data"] = pref.rlimb_data

	data["s_tone"] = -pref.s_tone + 35
	data["eyes_color"] = pref.read_preference(/datum/preference/color/human/eyes_color)
	data["skin_color"] = pref.read_preference(/datum/preference/color/human/skin_color)

	data["h_style"] = pref.h_style
	data["hair_color"] = pref.read_preference(/datum/preference/color/human/hair_color)

	data["f_style"] = pref.f_style
	data["facial_color"] = pref.read_preference(/datum/preference/color/human/facial_color)

	data["grad_style"] = pref.grad_style
	data["grad_color"] = pref.read_preference(/datum/preference/color/human/grad_color)

	data["ear_style"] = pref.ear_style
	data["ears_color1"] = pref.read_preference(/datum/preference/color/human/ears_color1)
	data["ears_color2"] = pref.read_preference(/datum/preference/color/human/ears_color2)
	data["ears_color3"] = pref.read_preference(/datum/preference/color/human/ears_color3)
	data["ears_alpha"] = pref.read_preference(/datum/preference/numeric/human/ears_alpha)

	data["ear_secondary_style"] = pref.ear_secondary_style
	data["ear_secondary_colors"] = pref.ear_secondary_colors
	data["ear_secondary_alpha"] = pref.read_preference(/datum/preference/numeric/human/ears_alpha/secondary)

	data["body_markings"] = pref.body_markings

	data["tail_style"] = pref.tail_style
	data["tail_color1"] = pref.read_preference(/datum/preference/color/human/tail_color1)
	data["tail_color2"] = pref.read_preference(/datum/preference/color/human/tail_color2)
	data["tail_color3"] = pref.read_preference(/datum/preference/color/human/tail_color3)
	data["tail_alpha"] = pref.read_preference(/datum/preference/numeric/human/tail_alpha)

	data["wing_style"] = pref.wing_style
	data["wing_color1"] = pref.read_preference(/datum/preference/color/human/wing_color1)
	data["wing_color2"] = pref.read_preference(/datum/preference/color/human/wing_color2)
	data["wing_color3"] = pref.read_preference(/datum/preference/color/human/wing_color3)
	data["wing_alpha"] = pref.read_preference(/datum/preference/numeric/human/wing_alpha)

	data["b_type"] = pref.b_type
	data["digitigrade"] = pref.digitigrade
	data["tail_layering"] = pref.read_preference(/datum/preference/choiced/human/tail_layering)

	data["synth_color_toggle"] = pref.synth_color
	data["synth_color"] = pref.read_preference(/datum/preference/color/human/synth_color)
	data["synth_markings"] = pref.synth_markings

	return data

/datum/category_item/player_setup_item/general/body/tgui_static_data(mob/user)
	var/list/data = ..()

	var/list/can_play_list = list()
	for(var/species in GLOB.playable_species)
		var/datum/species/S = GLOB.all_species[species]
		var/restricted = 0
		if(!(S.spawn_flags & SPECIES_CAN_JOIN))
			restricted = 2
		else if(!is_alien_whitelisted(user.client, S))
			restricted = 1

		var/can_select = !restricted
		if(check_rights(R_ADMIN|R_EVENT, 0) || S.spawn_flags & SPECIES_WHITELIST_SELECTABLE)
			can_select = TRUE

		can_play_list[species] = list(
			"restricted" = restricted,
			"can_select" = can_select,
		)
	data["can_play"] = can_play_list

	var/list/available_hair_styles = list()
	for(var/path in pref.get_available_styles(GLOB.hair_styles_list))
		UNTYPED_LIST_ADD(available_hair_styles, path)
	data["available_hair_styles"] = available_hair_styles

	var/list/available_facial_styles = list()
	for(var/path in pref.get_available_styles(GLOB.facial_hair_styles_list))
		UNTYPED_LIST_ADD(available_facial_styles, path)
	data["available_facial_styles"] = available_facial_styles

	// WARNING: Depends on adding "None"
	var/list/available_ear_styles = list("None")
	for(var/path in pref.get_available_styles(GLOB.ear_styles_list))
		UNTYPED_LIST_ADD(available_ear_styles, path)
	data["available_ear_styles"] = available_ear_styles

	var/list/available_tail_styles = list()
	for(var/path in pref.get_available_styles(GLOB.tail_styles_list))
		UNTYPED_LIST_ADD(available_tail_styles, path)
	data["available_tail_styles"] = available_tail_styles

	var/list/available_wing_styles = list()
	for(var/path in pref.get_available_styles(GLOB.wing_styles_list))
		UNTYPED_LIST_ADD(available_wing_styles, path)
	data["available_wing_styles"] = available_wing_styles

	return data

/datum/category_item/player_setup_item/general/body/tgui_constant_data()
	var/list/data = ..()

	var/list/species_list = list()
	for(var/species in GLOB.playable_species)
		var/datum/species/S = GLOB.all_species[species]
		UNTYPED_LIST_ADD(species_list, list(
			"name" = S.name,
			"wikilink" = S.wikilink,
			"blurb" = S.blurb,
			"species_language" = S.species_language,
			"icobase" = S.icobase,
			"rarity" = S.rarity_value,
			"has_organ" = S.has_organ,
			"flags" = S.flags,
			"spawn_flags" = S.spawn_flags,
			"appearance_flags" = S.appearance_flags,
		))
	data["species"] = species_list

	var/list/hair_styles = list()
	for(var/path in GLOB.hair_styles_list)
		var/datum/sprite_accessory/hair/S = GLOB.hair_styles_list[path]
		hair_styles[path] = list(
			"name" = S.name,
			"icon" = REF(S.icon),
			"icon_state" = S.icon_state,
		)

	data["hair_styles"] = hair_styles

	var/list/facial_styles = list()
	for(var/path in GLOB.facial_hair_styles_list)
		var/datum/sprite_accessory/facial_hair/S = GLOB.facial_hair_styles_list[path]
		facial_styles[path] = list(
			"name" = S.name,
			"icon" = REF(S.icon),
			"icon_state" = S.icon_state,
		)

	data["facial_styles"] = facial_styles

	var/list/grad_styles = list()
	for(var/name in GLOB.hair_gradients)
		var/icon_state = GLOB.hair_gradients[name]
		grad_styles[name] = list(
			"name" = name,
			"icon" = REF('icons/mob/hair_gradients.dmi'),
			"icon_state" = icon_state,
		)
	data["grad_styles"] = grad_styles

	var/list/ear_styles = list()
	for(var/path in GLOB.ear_styles_list)
		var/datum/sprite_accessory/ears/S = GLOB.ear_styles_list[path]
		ear_styles[S.name] = list(
			"name" = S.name,
			"type" = S.type,
			"icon" = REF(S.icon),
			"icon_state" = S.icon_state,
			"do_colouration" = S.do_colouration,
			"extra_overlay" = S.extra_overlay,
			"extra_overlay2" = S.extra_overlay2,
		)
	data["ear_styles"] = ear_styles

	var/list/body_markings = list()
	for(var/path in GLOB.body_marking_styles_list)
		var/datum/sprite_accessory/marking/S = GLOB.body_marking_styles_list[path]

		var/icon_state = S.icon_state
		if(LAZYLEN(S.body_parts))
			icon_state += "-[S.body_parts[1]]"

		body_markings[path] = list(
			"name" = S.name,
			"icon" = REF(S.icon),
			"icon_state" = icon_state,
			"genetic" = S.genetic,
			"body_parts" = S.body_parts,
		)
	data["body_markings"] = body_markings

	var/list/tail_styles = list()
	for(var/path in GLOB.tail_styles_list)
		var/datum/sprite_accessory/tail/S = GLOB.tail_styles_list[path]
		tail_styles[S.name] = list(
			"name" = name,
			"icon" = REF(S.icon),
			"icon_state" = S.icon_state,
			"do_colouration" = S.do_colouration,
			"extra_overlay" = S.extra_overlay,
			"extra_overlay2" = S.extra_overlay2,
		)
	data["tail_styles"] = tail_styles

	var/list/wing_styles = list()
	for(var/path in GLOB.wing_styles_list)
		var/datum/sprite_accessory/wing/S = GLOB.wing_styles_list[path]
		wing_styles[S.name] = list(
			"name" = S.name,
			"icon" = REF(S.icon),
			"icon_state" = S.icon_state,
			"do_colouration" = S.do_colouration,
			"extra_overlay" = S.extra_overlay,
			"extra_overlay2" = S.extra_overlay2,
		)
	data["wing_styles"] = wing_styles

	return data

/datum/category_item/player_setup_item/general/body/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
	. = ..()
	if(.)
		return

	var/datum/species/mob_species = GLOB.all_species[pref.species]
	var/mob/user = ui.user

	switch(action)
		/* Hair */
		if("set_hair_style")
			var/new_h_style = params["hair_style"]
			if(new_h_style in pref.get_available_styles(GLOB.hair_styles_list))
				pref.h_style = new_h_style
				return TOPIC_REFRESH_UPDATE_PREVIEW
		if("set_hair_color")
			if(!has_flag(mob_species, HAS_HAIR_COLOR))
				return TOPIC_NOACTION
			var/new_hair = tgui_color_picker(user, "Choose your character's hair colour:", "Character Preference", pref.read_preference(/datum/preference/color/human/hair_color))
			if(new_hair && has_flag(mob_species, HAS_HAIR_COLOR))
				pref.update_preference_by_type(/datum/preference/color/human/hair_color, new_hair)
				return TOPIC_REFRESH_UPDATE_PREVIEW

		/* Facial Hair */
		if("set_facial_hair_style")
			var/new_f_style = params["facial_hair_style"]
			if(new_f_style in pref.get_available_styles(GLOB.facial_hair_styles_list))
				pref.f_style = new_f_style
				return TOPIC_REFRESH_UPDATE_PREVIEW
		if("set_facial_hair_color")
			if(!has_flag(mob_species, HAS_HAIR_COLOR))
				return TOPIC_NOACTION
			var/new_facial = tgui_color_picker(user, "Choose your character's facial-hair colour:", "Character Preference", pref.read_preference(/datum/preference/color/human/facial_color))
			if(new_facial && has_flag(mob_species, HAS_HAIR_COLOR))
				pref.update_preference_by_type(/datum/preference/color/human/facial_color, new_facial)
				return TOPIC_REFRESH_UPDATE_PREVIEW

		/* Gradient */
		if("set_grad_style")
			// Note: Must pass in NAME not icon_state
			var/new_grad_style = params["grad_style"]
			if(new_grad_style in GLOB.hair_gradients)
				pref.grad_style = new_grad_style
				return TOPIC_REFRESH_UPDATE_PREVIEW
		if("set_grad_color")
			if(!has_flag(mob_species, HAS_HAIR_COLOR))
				return TOPIC_NOACTION
			var/new_grad = tgui_color_picker(user, "Choose your character's secondary hair color:", "Character Preference", pref.read_preference(/datum/preference/color/human/grad_color))
			if(new_grad && has_flag(mob_species, HAS_HAIR_COLOR))
				pref.update_preference_by_type(/datum/preference/color/human/grad_color, new_grad)
				return TOPIC_REFRESH_UPDATE_PREVIEW

		/* Markings */
		if("add_marking")
			var/list/usable_markings = pref.body_markings.Copy() ^ GLOB.body_marking_styles_list.Copy()
			var/new_marking = params["new_marking"]
			if(new_marking && (new_marking in usable_markings))
				pref.body_markings[new_marking] = pref.mass_edit_marking_list(new_marking) //New markings start black
				return TOPIC_REFRESH_UPDATE_PREVIEW
		if("marking_up")
			var/M = params["marking"]
			var/start = pref.body_markings.Find(M)
			if(start != 1) //If we're not the beginning of the list, swap with the previous element.
				moveElement(pref.body_markings, start, start-1)
			else //But if we ARE, become the final element -ahead- of everything else.
				moveElement(pref.body_markings, start, pref.body_markings.len+1)
			return TOPIC_REFRESH_UPDATE_PREVIEW
		if("marking_down")
			var/M = params["marking"]
			var/start = pref.body_markings.Find(M)
			if(start != pref.body_markings.len) //If we're not the end of the list, swap with the next element.
				moveElement(pref.body_markings, start, start+2)
			else //But if we ARE, become the first element -behind- everything else.
				moveElement(pref.body_markings, start, 1)
			return TOPIC_REFRESH_UPDATE_PREVIEW
		if("marking_remove")
			var/M = params["marking"]
			winshow(user, "prefs_markings_subwindow", FALSE)
			pref.body_markings -= M
			return TOPIC_REFRESH_UPDATE_PREVIEW
		if("marking_color")
			var/M = params["marking"]
			if(isnull(pref.body_markings[M]["color"]))
				if(tgui_alert(user, "You currently have customized marking colors. This will reset each bodypart's color. Are you sure you want to continue?","Reset Bodypart Colors",list("Yes","No")) != "Yes")
					return TOPIC_NOACTION
			var/mark_color = tgui_color_picker(user, "Choose the [M] color: ", "Character Preference", pref.body_markings[M]["color"])
			if(mark_color)
				pref.body_markings[M] = pref.mass_edit_marking_list(M,FALSE,TRUE,pref.body_markings[M],color="[mark_color]")
				return TOPIC_REFRESH_UPDATE_PREVIEW
		if("toggle_all_marking_selection")
			var/toggle = text2num(params["toggle"])
			var/marking = params["marking"]
			if(pref.body_markings.Find(marking) == 0)
				return TOPIC_NOACTION
			pref.body_markings[marking] = pref.mass_edit_marking_list(marking,TRUE,FALSE,pref.body_markings[marking],on=toggle)
			return TOPIC_REFRESH_UPDATE_PREVIEW
		if("color_all_marking_selection")
			var/marking = params["marking"]
			if(pref.body_markings.Find(marking) == 0)
				return TOPIC_NOACTION
			var/mark_color = tgui_color_picker(user, "Choose the [marking] color: ", "Character Preference", pref.body_markings[marking]["color"])
			if(mark_color)
				pref.body_markings[marking] = pref.mass_edit_marking_list(marking,FALSE,TRUE,pref.body_markings[marking],color="[mark_color]")
				return TOPIC_REFRESH_UPDATE_PREVIEW
		if("zone_marking_color")
			var/marking = params["marking"]
			if(pref.body_markings.Find(marking) == 0)
				return TOPIC_NOACTION
			var/zone = params["zone"]
			pref.body_markings[marking]["color"] = null //turn off the color button outside the submenu
			var/mark_color = tgui_color_picker(user, "Choose the [marking] color: ", "Character Preference", pref.body_markings[marking][zone]["color"])
			if(mark_color)
				pref.body_markings[marking][zone]["color"] = "[mark_color]"
				return TOPIC_REFRESH_UPDATE_PREVIEW
		if("zone_marking_toggle")
			var/marking = params["marking"]
			if(pref.body_markings.Find(marking) == 0)
				return TOPIC_NOACTION
			var/zone = params["zone"]
			pref.body_markings[marking][zone]["on"] = !pref.body_markings[marking][zone]["on"]
			return TOPIC_REFRESH_UPDATE_PREVIEW

		/* Ears */
		if("set_ear_style")
			var/new_ear_style = params["ear_style"]
			if(new_ear_style == "None")
				pref.ear_style = null
				return TOPIC_REFRESH_UPDATE_PREVIEW
			if(new_ear_style in pref.get_available_styles(GLOB.ear_styles_list))
				pref.ear_style = new_ear_style
				return TOPIC_REFRESH_UPDATE_PREVIEW
		if("set_ear_color")
			var/new_earc = tgui_color_picker(user, "Choose your character's ear colour:", "Character Preference",
				pref.read_preference(/datum/preference/color/human/ears_color1))
			if(new_earc)
				pref.update_preference_by_type(/datum/preference/color/human/ears_color1, new_earc)
				return TOPIC_REFRESH_UPDATE_PREVIEW
		if("set_ear_color2")
			var/new_earc2 = tgui_color_picker(user, "Choose your character's secondary ear colour:", "Character Preference",
				pref.read_preference(/datum/preference/color/human/ears_color2))
			if(new_earc2)
				pref.update_preference_by_type(/datum/preference/color/human/ears_color2, new_earc2)
				return TOPIC_REFRESH_UPDATE_PREVIEW
		if("set_ear_color3")
			var/new_earc3 = tgui_color_picker(user, "Choose your character's tertiary ear colour:", "Character Preference",
				pref.read_preference(/datum/preference/color/human/ears_color3))
			if(new_earc3)
				pref.update_preference_by_type(/datum/preference/color/human/ears_color3, new_earc3)
				return TOPIC_REFRESH_UPDATE_PREVIEW
		if("set_ear_secondary_style")
			var/new_ear_style = params["ear_style"]
			if(new_ear_style == "None")
				pref.ear_secondary_style = null
				return TOPIC_REFRESH_UPDATE_PREVIEW
			if(new_ear_style in pref.get_available_styles(GLOB.ear_styles_list))
				pref.ear_secondary_style = new_ear_style
				return TOPIC_REFRESH_UPDATE_PREVIEW
		if("set_ear_secondary_color")
			var/channel = text2num(params["ear_secondary_color"])
			// very important sanity check; this makes sure someone can't crash the server by setting channel to some insanely high value
			if(channel > GLOB.fancy_sprite_accessory_color_channel_names.len)
				return TOPIC_NOACTION
			// this would say 'secondary ears' but you'd get 'choose your character's primary secondary ear colour' which sounds silly
			var/new_color = tgui_color_picker(
				user,
				"Choose your character's [lowertext(GLOB.fancy_sprite_accessory_color_channel_names[channel])] ear colour:",
				"Secondary Ear Coloration",
				LAZYACCESS(pref.ear_secondary_colors, channel) || "#ffffff",
			)
			if(!new_color)
				return TOPIC_NOACTION
			// ensures color channel list is at least that long
			// the upper bound is to have a secondary safety check because list index set is a dangerous call
			pref.ear_secondary_colors.len = clamp(length(pref.ear_secondary_colors), channel, length(GLOB.fancy_sprite_accessory_color_channel_names))
			pref.ear_secondary_colors[channel] = new_color
			return TOPIC_REFRESH_UPDATE_PREVIEW
		if("ears_alpha")
			var/new_ear_alpha = tgui_input_number(user, "Choose how transparent your character's primary ears are.", "Character Preference",
				pref.read_preference(/datum/preference/numeric/human/ears_alpha), 255, 0)
			if(new_ear_alpha)
				pref.update_preference_by_type(/datum/preference/numeric/human/ears_alpha, new_ear_alpha)
				return TOPIC_REFRESH_UPDATE_PREVIEW
		if("secondary_ears_alpha")
			var/new_ear_alpha = tgui_input_number(user, "Choose how transparent your character's horns are.", "Character Preference",
				pref.read_preference(/datum/preference/numeric/human/ears_alpha/secondary), 255, 0)
			if(new_ear_alpha)
				pref.update_preference_by_type(/datum/preference/numeric/human/ears_alpha/secondary, new_ear_alpha)
				return TOPIC_REFRESH_UPDATE_PREVIEW

		/* Wings */
		if("set_wing_style")
			var/new_style = params["style"]
			if(new_style in pref.get_available_styles(GLOB.wing_styles_list))
				pref.wing_style = new_style
				return TOPIC_REFRESH_UPDATE_PREVIEW
		if("set_wing_color")
			var/new_wingc = tgui_color_picker(user, "Choose your character's wing colour:", "Character Preference",
				pref.read_preference(/datum/preference/color/human/wing_color1))
			if(new_wingc)
				pref.update_preference_by_type(/datum/preference/color/human/wing_color1, new_wingc)
				return TOPIC_REFRESH_UPDATE_PREVIEW
		if("set_wing_color2")
			var/new_wingc = tgui_color_picker(user, "Choose your character's secondary wing colour:", "Character Preference",
				pref.read_preference(/datum/preference/color/human/wing_color2))
			if(new_wingc)
				pref.update_preference_by_type(/datum/preference/color/human/wing_color2, new_wingc)
				return TOPIC_REFRESH_UPDATE_PREVIEW
		if("set_wing_color3")
			var/new_wingc = tgui_color_picker(user, "Choose your character's tertiary wing colour:", "Character Preference",
				pref.read_preference(/datum/preference/color/human/wing_color3))
			if(new_wingc)
				pref.update_preference_by_type(/datum/preference/color/human/wing_color3, new_wingc)
				return TOPIC_REFRESH_UPDATE_PREVIEW
		if("set_wing_alpha")
			var/new_wing_alpha = tgui_input_number(user, "Choose how transparent your character's wings are.", "Character Preference",
				pref.read_preference(/datum/preference/numeric/human/wing_alpha), 255, 0)
			if(new_wing_alpha)
				pref.update_preference_by_type(/datum/preference/numeric/human/wing_alpha, new_wing_alpha)
				return TOPIC_REFRESH_UPDATE_PREVIEW

		/* Tail */
		if("set_tail_style")
			var/new_tail_style = params["style"]
			if(new_tail_style in pref.get_available_styles(GLOB.tail_styles_list))
				pref.tail_style = new_tail_style
			return TOPIC_REFRESH_UPDATE_PREVIEW
		if("set_tail_color")
			var/new_tailc = tgui_color_picker(user, "Choose your character's tail/taur colour:", "Character Preference",
				pref.read_preference(/datum/preference/color/human/tail_color1))
			if(new_tailc)
				pref.update_preference_by_type(/datum/preference/color/human/tail_color1, new_tailc)
				return TOPIC_REFRESH_UPDATE_PREVIEW
		if("set_tail_color2")
			var/new_tailc2 = tgui_color_picker(user, "Choose your character's secondary tail/taur colour:", "Character Preference",
				pref.read_preference(/datum/preference/color/human/tail_color2))
			if(new_tailc2)
				pref.update_preference_by_type(/datum/preference/color/human/tail_color2, new_tailc2)
				return TOPIC_REFRESH_UPDATE_PREVIEW
		if("set_tail_color3")
			var/new_tailc3 = tgui_color_picker(user, "Choose your character's tertiary tail/taur colour:", "Character Preference",
				pref.read_preference(/datum/preference/color/human/tail_color3))
			if(new_tailc3)
				pref.update_preference_by_type(/datum/preference/color/human/tail_color3, new_tailc3)
				return TOPIC_REFRESH_UPDATE_PREVIEW
		if("set_tail_alpha")
			var/new_tail_alpha = tgui_input_number(user, "Choose how transparent your character's tail is.", "Character Preference",
				pref.read_preference(/datum/preference/numeric/human/tail_alpha), 255, 0)
			if(new_tail_alpha)
				pref.update_preference_by_type(/datum/preference/numeric/human/tail_alpha, new_tail_alpha)
				return TOPIC_REFRESH_UPDATE_PREVIEW

		/* Species */
		if("set_species")
			var/datum/species/setting_species

			if(!GLOB.all_species[params["species"]])
				return TOPIC_NOACTION

			setting_species = GLOB.all_species[params["species"]]

			if(((!(setting_species.spawn_flags & SPECIES_CAN_JOIN)) || (!is_alien_whitelisted(user.client,setting_species))) && !check_rights(R_ADMIN|R_EVENT, 0) && !(setting_species.spawn_flags & SPECIES_WHITELIST_SELECTABLE))
				return TOPIC_NOACTION

			var/prev_species = pref.species
			pref.species = params["species"]
			if(prev_species != pref.species)
				if(!(pref.biological_gender in mob_species.genders))
					pref.set_biological_gender(mob_species.genders[1])
				pref.custom_species = null
				//grab one of the valid hair styles for the newly chosen species
				var/list/valid_hairstyles = pref.get_valid_hairstyles(user)

				if(valid_hairstyles.len)
					if(!(pref.h_style in valid_hairstyles))
						pref.h_style = pick(valid_hairstyles)
				else
					//this shouldn't happen
					pref.h_style = GLOB.hair_styles_list["Bald"]

				//grab one of the valid facial hair styles for the newly chosen species
				var/list/valid_facialhairstyles = pref.get_valid_facialhairstyles()

				if(valid_facialhairstyles.len)
					if(!(pref.f_style in valid_facialhairstyles))
						pref.f_style = pick(valid_facialhairstyles)
				else
					//this shouldn't happen
					pref.f_style = GLOB.facial_hair_styles_list["Shaved"]

				//reset hair colour and skin colour
				pref.update_preference_by_type(/datum/preference/color/human/hair_color, "#000000")
				pref.s_tone = -75

				reset_limbs() // Safety for species with incompatible manufacturers; easier than trying to do it case by case.
				pref.body_markings.Cut() // Basically same as above.

				pref.sanitize_body_styles()

				var/min_age = get_min_age()
				var/max_age = get_max_age()
				pref.update_preference_by_type(/datum/preference/numeric/human/age, max(min(pref.read_preference(/datum/preference/numeric/human/age), max_age), min_age))
				pref.blood_color = setting_species.blood_color

				update_static_data_for_all_viewers()
				return TOPIC_REFRESH_UPDATE_PREVIEW

		// Colors
		if("eye_color")
			if(!has_flag(mob_species, HAS_EYE_COLOR))
				return TOPIC_NOACTION
			var/new_eyes = tgui_color_picker(user, "Choose your character's eye colour:", "Character Preference", pref.read_preference(/datum/preference/color/human/eyes_color))
			if(new_eyes && has_flag(mob_species, HAS_EYE_COLOR))
				pref.update_preference_by_type(/datum/preference/color/human/eyes_color, new_eyes)
				return TOPIC_REFRESH_UPDATE_PREVIEW

		if("skin_tone")
			if(!has_flag(mob_species, HAS_SKIN_TONE))
				return TOPIC_NOACTION
			var/new_s_tone = tgui_input_number(user, "Choose your character's skin-tone:\n(Light 1 - 220 Dark)", "Character Preference", (-pref.s_tone) + 35, 220, 1)
			if(new_s_tone && has_flag(mob_species, HAS_SKIN_TONE))
				pref.s_tone = 35 - max(min( round(new_s_tone), 220),1)
				return TOPIC_REFRESH_UPDATE_PREVIEW

		if("skin_color")
			if(!has_flag(mob_species, HAS_SKIN_COLOR))
				return TOPIC_NOACTION
			var/new_skin = tgui_color_picker(user, "Choose your character's skin colour: ", "Character Preference", pref.read_preference(/datum/preference/color/human/skin_color))
			if(new_skin && has_flag(mob_species, HAS_SKIN_COLOR))
				pref.update_preference_by_type(/datum/preference/color/human/skin_color, new_skin)
				return TOPIC_REFRESH_UPDATE_PREVIEW

		/* Robolimbs */
		if("robolimb_select_bodypart")
			var/zone = params["zone"]
			if(!(zone in BP_ALL))
				return TOPIC_HANDLED

			var/is_brainless = !mob_species.has_organ[O_BRAIN]

			// Full prosthetic bodies without a brain are borderline unkillable so make sure they have a brain to remove/destroy.
			if(is_brainless && (zone in list(BP_HEAD, BP_TORSO, BP_GROIN)))
				return TOPIC_HANDLED

			// we have a valid zone, let's figure out what options are avaliable for it
			var/list/options = list()
			switch(zone)
				if(BP_L_FOOT, BP_R_FOOT, BP_L_LEG, BP_R_LEG, BP_L_HAND, BP_R_HAND, BP_L_ARM, BP_R_ARM)
					options = list("Normal", "Amputated", "Prosthesis")
				if(BP_HEAD)
					if(is_FBP())
						options = list("Prosthesis")
					else
						options = list("Normal")
				if(BP_TORSO, BP_GROIN)
					options = list("Normal", "Prosthesis")

			var/new_state = tgui_input_list(user, "What state do you wish the limb to be in?", "State Choice", options)
			if(!new_state)
				return TOPIC_HANDLED

			var/limb = zone
			var/second_limb = null // if you try to change the arm, the hand should also change
			var/third_limb = null  // if you try to unchange the hand, the arm should also change

			switch(zone)
				if(BP_L_FOOT)
					third_limb = BP_L_LEG
				if(BP_R_FOOT)
					third_limb = BP_R_LEG
				if(BP_L_LEG)
					second_limb = BP_L_FOOT
				if(BP_R_LEG)
					second_limb = BP_R_FOOT
				if(BP_L_HAND)
					third_limb = BP_L_ARM
				if(BP_R_HAND)
					third_limb = BP_R_ARM
				if(BP_L_ARM)
					second_limb = BP_L_HAND
				if(BP_R_ARM)
					second_limb = BP_R_HAND
				// standardize these to the same settings for full body
				if(BP_TORSO, BP_GROIN)
					limb = BP_TORSO
					second_limb = BP_HEAD
					third_limb = BP_GROIN

			switch(new_state)
				if("Normal")
					pref.organ_data[limb] = null
					pref.rlimb_data[limb] = null
					if(limb == BP_TORSO) // depends on standardization
						for(var/other_limb in BP_ALL - BP_TORSO)
							pref.organ_data[other_limb] = null
							pref.rlimb_data[other_limb] = null
						for(var/internal in O_STANDARD)
							pref.organ_data[internal] = null
							pref.rlimb_data[internal] = null
					if(third_limb)
						pref.organ_data[third_limb] = null
						pref.rlimb_data[third_limb] = null

				if("Amputated")
					if(limb == BP_TORSO) // depends on standardization
						return
					pref.organ_data[limb] = "amputated"
					pref.rlimb_data[limb] = null
					if(second_limb)
						pref.organ_data[second_limb] = "amputated"
						pref.rlimb_data[second_limb] = null

				if("Prosthesis")
					var/list/usable_manufacturers = list()
					for(var/company in GLOB.chargen_robolimbs)
						var/datum/robolimb/M = GLOB.chargen_robolimbs[company]
						if(!(limb in M.parts))
							continue
						if(pref.species in M.species_cannot_use)
							continue
						if(M.whitelisted_to && !(user.ckey in M.whitelisted_to))
							continue
						usable_manufacturers[company] = M
					if(!usable_manufacturers.len)
						return
					var/choice = tgui_input_list(user, "Which manufacturer do you wish to use for this limb?", "Manufacturer Choice", usable_manufacturers)
					if(!choice)
						return

					pref.rlimb_data[limb] = choice
					pref.organ_data[limb] = "cyborg"

					if(second_limb)
						pref.rlimb_data[second_limb] = choice
						pref.organ_data[second_limb] = "cyborg"
					if(third_limb && pref.organ_data[third_limb] == "amputated")
						pref.organ_data[third_limb] = null

					if(limb == BP_TORSO)
						for(var/other_limb in BP_ALL - BP_TORSO)
							if(pref.organ_data[other_limb])
								continue
							pref.organ_data[other_limb] = "cyborg"
							pref.rlimb_data[other_limb] = choice
						if(!pref.organ_data[O_BRAIN])
							pref.organ_data[O_BRAIN] = FBP_ASSISTED
						for(var/internal_organ in list(O_HEART,O_EYES))
							pref.organ_data[internal_organ] = FBP_MECHANICAL

			return TOPIC_REFRESH_UPDATE_PREVIEW

		if("robolimb_select_organ")
			var/zone = params["zone"]
			if(!(zone in O_STANDARD))
				return

			if(zone == O_BRAIN && pref.organ_data[BP_HEAD] != "cyborg")
				to_chat(user, span_warning("You may only select a cybernetic or synthetic brain if you have a full prosthetic body."))
				return

			var/list/organ_choices = list("Normal")
			if(is_FBP())
				organ_choices -= "Normal"
				if(zone == O_BRAIN)
					organ_choices += "Cybernetic"
					if(!(mob_species.spawn_flags & SPECIES_NO_POSIBRAIN))
						organ_choices += "Positronic"
					if(!(mob_species.spawn_flags & SPECIES_NO_DRONEBRAIN))
						organ_choices += "Drone"
				else
					organ_choices += "Assisted"
					organ_choices += "Mechanical"
			else
				organ_choices += "Assisted"
				organ_choices += "Mechanical"

			var/new_state = tgui_input_list(user, "What state do you wish the organ to be in?", "State Choice", organ_choices)
			if(!new_state)
				return

			switch(new_state)
				if("Normal")
					pref.organ_data[zone] = null
				if("Assisted")
					pref.organ_data[zone] = FBP_ASSISTED
				if("Cybernetic")
					pref.organ_data[zone] = FBP_ASSISTED
				if("Mechanical")
					pref.organ_data[zone] = FBP_MECHANICAL
				if("Drone")
					pref.organ_data[zone] = FBP_DIGITAL
				if("Positronic")
					pref.organ_data[zone] = FBP_MECHANICAL

			return TOPIC_REFRESH_UPDATE_PREVIEW

		if("reset_limbs")
			reset_limbs()
			return TOPIC_REFRESH_UPDATE_PREVIEW

		if("blood_type")
			var/new_b_type = tgui_input_list(user, "Choose your character's blood-type:", "Character Preference", GLOB.valid_bloodtypes, pref.b_type)
			if(new_b_type)
				pref.b_type = new_b_type
				return TOPIC_REFRESH

		if("digitigrade")
			pref.digitigrade = !pref.digitigrade
			return TOPIC_REFRESH_UPDATE_PREVIEW

		if("set_tail_layering")
			var/new_tail_layering = tgui_input_list(user, "Select a tail layer.", "Set Tail Layer", GLOB.tail_layer_options,
				pref.read_preference(/datum/preference/choiced/human/tail_layering))
			if(new_tail_layering)
				pref.update_preference_by_type(/datum/preference/choiced/human/tail_layering, new_tail_layering)
				return TOPIC_REFRESH_UPDATE_PREVIEW

		if("synth_color_toggle")
			pref.synth_color = !pref.synth_color
			return TOPIC_REFRESH_UPDATE_PREVIEW

		if("synth_color")
			var/new_color = tgui_color_picker(user, "Choose your character's synth colour: ", "Character Preference", pref.read_preference(/datum/preference/color/human/synth_color))
			if(new_color && CanUseTopic(user))
				pref.update_preference_by_type(/datum/preference/color/human/synth_color, new_color)
				return TOPIC_REFRESH_UPDATE_PREVIEW

		if("synth_markings")
			pref.synth_markings = !pref.synth_markings
			return TOPIC_REFRESH_UPDATE_PREVIEW
