var/static/icon/ingame_hud_vr = icon('icons/mob/hud_vr.dmi')
var/static/icon/ingame_hud_med_vr = icon('icons/mob/hud_med_vr.dmi')

/mob/living/carbon/human/make_hud_overlays()
	. = ..()
	hud_list[HEALTH_VR_HUD]   = gen_hud_image(ingame_hud_med_vr, src, "100", plane = PLANE_CH_HEALTH_VR)
	hud_list[STATUS_R_HUD]    = gen_hud_image(ingame_hud_vr, src, plane = PLANE_CH_STATUS_R)
	hud_list[BACKUP_HUD]      = gen_hud_image(ingame_hud_vr, src, plane = PLANE_CH_BACKUP)
	hud_list[VANTAG_HUD]      = gen_hud_image(ingame_hud_vr, src, plane = PLANE_CH_VANTAG)

/mob/living/carbon/human/proc/remove_marking(var/datum/sprite_accessory/marking/mark_datum)
	if (!mark_datum)
		return FALSE
	var/successful = FALSE
	for(var/BP in mark_datum.body_parts)
		var/obj/item/organ/external/O = organs_by_name[BP]
		if(O)
			successful = O.markings.Remove(mark_datum.name) || successful
	if (successful)
		markings_len -= 1
		update_dna()
		update_icons_body()
		return TRUE
	return FALSE

/mob/living/carbon/human/proc/add_marking(var/datum/sprite_accessory/marking/mark_datum, var/mark_color = "#000000")
	if (!mark_datum)
		return FALSE
	var/success = FALSE
	for(var/BP in mark_datum.body_parts)
		var/obj/item/organ/external/O = organs_by_name[BP]
		if(O)
			success = TRUE
			O.markings[mark_datum.name] = list("color" = mark_color, "datum" = mark_datum, "priority" = markings_len + 1, "on" = TRUE)
	if (success)
		markings_len += 1
		update_dna()
		update_icons_body()
	return success

/mob/living/carbon/human/proc/change_priority_of_marking(var/datum/sprite_accessory/marking/mark_datum, var/move_down, var/swap = TRUE) //move_down should be true/false
	if (!mark_datum)
		return FALSE
	var/change = move_down ? 1 : -1
	var/success = FALSE
	for(var/BP in mark_datum.body_parts)
		var/obj/item/organ/external/O = organs_by_name[BP]
		if(O)
			var/index = O.markings.Find(mark_datum.name)
			if (!index)
				continue
			var/change_from = O.markings[mark_datum.name]["priority"]
			if (change_from == clamp(change_from + change, 1, markings_len))
				continue
			if (!success)
				success = TRUE
				change_priority_marking_to_priority(change_from + change, change_from)
			O.markings[mark_datum.name]["priority"] = clamp(change_from + change, 1, markings_len)
			if ((move_down && index == O.markings.len) || (!move_down && index == 1))
				continue
			if (O.markings[O.markings[index + change]]["priority"] == change_from)
				moveElement(O.markings, index, index+(move_down ? 2 : -1))
	if (success)
		update_dna()
		update_icons_body()
	return TRUE

/mob/living/carbon/human/proc/change_priority_marking_to_priority(var/priority, var/to_priority)
	for (var/obj/item/organ/external/O in organs)
		for (var/marking in O.markings)
			if (O.markings[marking]["priority"] == priority)
				O.markings[marking]["priority"] = to_priority

/mob/living/carbon/human/proc/change_marking_color(var/datum/sprite_accessory/marking/mark_datum, var/mark_color = "#000000")
	if (!mark_datum)
		return FALSE
	var/success = FALSE
	for(var/BP in mark_datum.body_parts)
		var/obj/item/organ/external/O = organs_by_name[BP]
		if(O && O.markings[mark_datum.name] && O.markings[mark_datum.name]["color"] != mark_color)
			success = TRUE
			O.markings[mark_datum.name]["color"] = mark_color
	if (success)
		update_dna()
		update_icons_body()
	return success

/mob/living/carbon/human/proc/get_prioritised_markings()
	var/list/markings = list()
	var/list/priorities = list()
	for(var/obj/item/organ/external/O in organs)
		if(O.markings?.len)
			for (var/marking in O.markings)
				var/priority = num2text(O.markings[marking]["priority"])
				if (markings[priority])
					if (markings[priority][marking])
						markings[priority][marking] |= list(O.organ_tag = list("on" = O.markings[marking]["on"], "color" = O.markings[marking]["color"]))
					else
						markings[priority] |= list("[marking]" = list(O.organ_tag = list("on" = O.markings[marking]["on"], "color" = O.markings[marking]["color"]))) //yes I know technically you could have a limb that was attached that has the same marking as another limb with a different color but I'm too tired
				else
					priorities |= O.markings[marking]["priority"]
					markings[priority] = list("[marking]" = list(O.organ_tag = list("on" = O.markings[marking]["on"], "color" = O.markings[marking]["color"])))
	var/list/sorted = list()
	while (priorities.len > 0)
		var/priority = min(priorities)
		priorities.Remove(priority)
		priority = num2text(priority)
		for (var/marking in markings[priority])
			if (isnull(sorted[marking]))
				sorted[marking] = markings[priority][marking]
			else
				sorted[marking] |= markings[priority][marking]
	for (var/marking in sorted)
		var/should_add_color = TRUE
		var/last_color = null
		for (var/bp in sorted[marking])
			if (!isnull(last_color) && sorted[marking][bp]["color"] != last_color)
				should_add_color = FALSE
			last_color = sorted[marking][bp]["color"]
		if (should_add_color)
			sorted[marking]["color"] = last_color||"#000000"
	del(markings)
	del(priorities)
	markings_len = sorted.len
	//todo - add an autofixing thing for having markings with the same priorities as another, and for having markings that should have the same priorities across bodyparts, but don't
	//does not really need to happen, that kinda thing will only happen when putting another person's limb onto your own body
	return sorted

/mob/living/carbon/human/proc/transform_into_other_human(var/mob/living/carbon/human/character, var/copy_name, var/copy_flavour = TRUE, var/convert_to_prosthetics = FALSE)
	/*
	name, nickname, flavour, OOC notes
	gender, sex
	custom species name, custom bodytype, weight, scale, scaling center, sound type, sound freq
	custom say verbs
	ears, wings, tail, hair, facial hair
	ears colors, wings colors, tail colors
	body color, prosthetics (if they're a protean) (convert to DSI if protean and not prosthetic), eye color, hair color etc
	markings
	custom synth markings toggle, custom synth color toggle
	digitigrade
	blood color
	*/
	if (copy_name)
		name = character.name
		nickname = character.nickname
	gender = character.gender
	identifying_gender = character.identifying_gender

	r_eyes = character.r_eyes
	g_eyes = character.g_eyes
	b_eyes = character.b_eyes
	h_style = character.h_style
	r_hair = character.r_hair
	g_hair = character.g_hair
	b_hair = character.b_hair
	r_grad = character.r_grad
	g_grad = character.g_grad
	b_grad = character.b_grad
	f_style = character.f_style
	r_facial = character.r_facial
	g_facial = character.g_facial
	b_facial = character.b_facial
	r_skin = character.r_skin
	g_skin = character.g_skin
	b_skin = character.b_skin
	s_tone = character.s_tone
	h_style = character.h_style
	grad_style = character.grad_style
	f_style = character.f_style
	grad_style = character.grad_style
	b_type = character.b_type
	synth_color = character.synth_color
	r_synth = character.r_synth
	g_synth = character.g_synth
	b_synth = character.b_synth
	synth_markings = character.synth_markings

	ear_style = character.ear_style
	r_ears = character.r_ears
	b_ears = character.b_ears
	g_ears = character.g_ears
	r_ears2 = character.r_ears2
	b_ears2 = character.b_ears2
	g_ears2 = character.g_ears2
	r_ears3 = character.r_ears3
	b_ears3 = character.b_ears3
	g_ears3 = character.g_ears3

	tail_style = character.tail_style
	r_tail = character.r_tail
	b_tail = character.b_tail
	g_tail = character.g_tail
	r_tail2 = character.r_tail2
	b_tail2 = character.b_tail2
	g_tail2 = character.g_tail2
	r_tail3 = character.r_tail3
	b_tail3 = character.b_tail3
	g_tail3 = character.g_tail3

	wing_style = character.wing_style
	r_wing = character.r_wing
	b_wing = character.b_wing
	g_wing = character.g_wing
	r_wing2 = character.r_wing2
	b_wing2 = character.b_wing2
	g_wing2 = character.g_wing2
	r_wing3 = character.r_wing3
	b_wing3 = character.b_wing3
	g_wing3 = character.g_wing3


	var/bodytype = character.species?.get_bodytype()

	if (convert_to_prosthetics) //should only really be run for proteans
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
			var/obj/item/organ/external/I = character.organs_by_name[name]
			var/obj/item/organ/external/O = organs_by_name[name]
			if(O)
				if(I.robotic >= ORGAN_ROBOT)
					O.robotize(I.model)
				else
					var/dsi_company = GLOB.dsi_to_species[bodytype]
					if (!dsi_company)
						dsi_company = "DSI - Adaptive"
					O.robotize(dsi_company)

	for(var/N in character.organs_by_name)
		var/obj/item/organ/external/O = organs_by_name[N]
		var/obj/item/organ/external/I = character.organs_by_name[N]
		O.markings = I.markings.Copy()

	markings_len = character.markings_len

	descriptors = character.descriptors?.Copy()

	if (copy_flavour)
		flavor_texts = character.flavor_texts?.Copy()

	weight			= character.weight
	weight_gain		= character.weight_gain
	weight_loss		= character.weight_loss
	fuzzy				= character.fuzzy
	offset_override	= character.offset_override //CHOMPEdit
	voice_freq		= character.voice_freq
	if (species && character.species)
		species.micro_size_mod = character.species.micro_size_mod
		species.icon_scale_x = character.species.icon_scale_x
		species.icon_scale_y = character.species.icon_scale_y
		update_transform()
	resize(character.size_multiplier, animate = TRUE, ignore_prefs = TRUE)
	voice_sounds_list = character.voice_sounds_list

	species?.blood_color = character.species?.blood_color

	dna?.base_species = bodytype
	species?.base_species = bodytype
	species?.vanity_base_fit = bodytype
	if (istype(species, /datum/species/shapeshifter))
		wrapped_species_by_ref["\ref[src]"] = bodytype

	custom_species	= character.custom_species
	custom_say		= character.custom_say
	custom_ask		= character.custom_ask
	custom_whisper	= character.custom_whisper
	custom_exclaim	= character.custom_exclaim

	digitigrade = character.digitigrade

	dna?.ResetUIFrom(src)
	force_update_limbs()
	regenerate_icons()
