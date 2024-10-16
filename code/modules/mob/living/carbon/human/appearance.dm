/mob/living/carbon/human/proc/change_appearance(var/flags = APPEARANCE_ALL_HAIR,
												var/mob/user = src,
												var/check_species_whitelist = 1,
												var/list/species_whitelist = list(),
												var/list/species_blacklist = list(),
												var/datum/tgui_state/state = GLOB.tgui_self_state)
	var/datum/tgui_module/appearance_changer/AC = new(src, src, check_species_whitelist, species_whitelist, species_blacklist)
	AC.flags = flags
	AC.tgui_interact(user, custom_state = state)

/mob/living/carbon/human/proc/change_species(var/new_species)
	if(!new_species)
		return

	if(species == new_species)
		return

	if(!(new_species in GLOB.all_species))
		return

	set_species(new_species)
	reset_hair()
	return 1

/mob/living/carbon/human/proc/change_gender(var/gender)
	if(src.gender == gender)
		return

	src.gender = gender
	//reset_hair() //VOREStation Remove - Don't just randomize hair on gender swaps for prometheans.
	update_dna()
	update_icons_body()
	return 1

/mob/living/carbon/human/proc/change_gender_identity(var/identifying_gender)
	if(src.identifying_gender == identifying_gender)
		return

	src.identifying_gender = identifying_gender
	return 1

/mob/living/carbon/human/proc/change_hair(var/hair_style)
	if(!hair_style)
		return

	if(h_style == hair_style)
		return

	if(!(hair_style in hair_styles_list))
		return

	h_style = hair_style

	update_hair()
	return 1

/mob/living/carbon/human/proc/change_hair_gradient(var/hair_gradient)
	if(!hair_gradient)
		return

	if(grad_style == hair_gradient)
		return

	if(!(hair_gradient in GLOB.hair_gradients))
		return

	grad_style = hair_gradient

	update_hair()
	return 1

/mob/living/carbon/human/proc/change_facial_hair(var/facial_hair_style)
	if(!facial_hair_style)
		return

	if(f_style == facial_hair_style)
		return

	if(!(facial_hair_style in facial_hair_styles_list))
		return

	f_style = facial_hair_style

	update_hair()
	return 1

/mob/living/carbon/human/proc/reset_hair()
	var/list/valid_hairstyles = generate_valid_hairstyles()
	var/list/valid_facial_hairstyles = generate_valid_facial_hairstyles()

	if(valid_hairstyles.len)
		h_style = pick(valid_hairstyles)
	else
		//this shouldn't happen
		h_style = "Bald"

	if(valid_facial_hairstyles.len)
		f_style = pick(valid_facial_hairstyles)
	else
		//this shouldn't happen
		f_style = "Shaved"

	update_hair()

/mob/living/carbon/human/proc/change_eye_color(var/red, var/green, var/blue)
	if(red == r_eyes && green == g_eyes && blue == b_eyes)
		return

	r_eyes = red
	g_eyes = green
	b_eyes = blue

	update_eyes()
	update_icons_body()
	return 1

/mob/living/carbon/human/proc/change_hair_color(var/red, var/green, var/blue)
	if(red == r_hair && green == g_hair && blue == b_hair)
		return

	r_hair = red
	g_hair = green
	b_hair = blue

	update_hair()
	return 1

/mob/living/carbon/human/proc/change_grad_color(var/red, var/green, var/blue)
	if(red == r_grad && green == g_grad && blue == b_grad)
		return

	r_grad = red
	g_grad = green
	b_grad = blue

	update_hair()
	return 1

/mob/living/carbon/human/proc/change_facial_hair_color(var/red, var/green, var/blue)
	if(red == r_facial && green == g_facial && blue == b_facial)
		return

	r_facial = red
	g_facial = green
	b_facial = blue

	update_hair()
	return 1

/mob/living/carbon/human/proc/change_skin_color(var/red, var/green, var/blue)
	if(red == r_skin && green == g_skin && blue == b_skin || !(species.appearance_flags & HAS_SKIN_COLOR))
		return

	r_skin = red
	g_skin = green
	b_skin = blue

	force_update_limbs()
	update_icons_body()
	return 1

/mob/living/carbon/human/proc/change_skin_tone(var/tone)
	if(s_tone == tone || !(species.appearance_flags & HAS_SKIN_TONE))
		return

	s_tone = tone

	force_update_limbs()
	update_icons_body()
	return 1

/mob/living/carbon/human/proc/update_dna()
	check_dna()
	dna.ready_dna(src)
	for(var/obj/item/organ/O in organs)
		O.dna = dna // Update all of those because apparently they're separate, and icons won't update properly

/mob/living/carbon/human/proc/generate_valid_species(var/check_whitelist = 1, var/list/whitelist = list(), var/list/blacklist = list())
	var/list/valid_species = new()
	for(var/current_species_name in GLOB.all_species)
		var/datum/species/current_species = GLOB.all_species[current_species_name]

		if(check_whitelist && CONFIG_GET(flag/usealienwhitelist) && !check_rights(R_ADMIN|R_EVENT, 0, src)) //If we're using the whitelist, make sure to check it!
			if(!(current_species.spawn_flags & SPECIES_CAN_JOIN))
				continue
			if(whitelist.len && !(current_species_name in whitelist))
				continue
			if(blacklist.len && (current_species_name in blacklist))
				continue
			if((current_species.spawn_flags & SPECIES_IS_WHITELISTED) && !is_alien_whitelisted(src, current_species))
				continue

		valid_species += current_species_name

	return valid_species

/mob/living/carbon/human/proc/generate_valid_hairstyles(var/check_gender = 1)

	var/use_species = species.get_bodytype(src)
	var/obj/item/organ/external/head/H = get_organ(BP_HEAD)
	if(H) use_species = H.species.get_bodytype(src)

	var/list/valid_hairstyles = new()
	for(var/hairstyle in hair_styles_list)
		var/datum/sprite_accessory/S = hair_styles_list[hairstyle]

		if(check_gender && gender != NEUTER)
			if(gender == MALE && S.gender == FEMALE)
				continue
			else if(gender == FEMALE && S.gender == MALE)
				continue

		if(!(use_species in S.species_allowed))
			continue

		if(S.ckeys_allowed && !(ckey in S.ckeys_allowed)) //VOREStation add - ckey whitelist check
			continue //VOREStation add - ckey whitelist check

		valid_hairstyles += hairstyle

	return valid_hairstyles

/mob/living/carbon/human/proc/generate_valid_facial_hairstyles()

	var/use_species = species.get_bodytype(src)
	var/obj/item/organ/external/head/H = get_organ(BP_HEAD)
	if(H) use_species = H.species.get_bodytype(src)

	var/list/valid_facial_hairstyles = new()
	for(var/facialhairstyle in facial_hair_styles_list)
		var/datum/sprite_accessory/S = facial_hair_styles_list[facialhairstyle]

		if(gender != NEUTER)
			if(gender == MALE && S.gender == FEMALE)
				continue
			else if(gender == FEMALE && S.gender == MALE)
				continue

		if(!(use_species in S.species_allowed))
			continue

		if(S.ckeys_allowed && !(ckey in S.ckeys_allowed)) //VOREStation add - ckey whitelist check
			continue //VOREStation add - ckey whitelist check

		valid_facial_hairstyles += facialhairstyle

	return valid_facial_hairstyles

/mob/living/carbon/human/proc/force_update_limbs()
	for(var/obj/item/organ/external/O in organs)
		O.sync_colour_to_human(src)
	update_icons_body(FALSE)
