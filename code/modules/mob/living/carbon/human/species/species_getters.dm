/datum/species/proc/get_valid_shapeshifter_forms(var/mob/living/carbon/human/H)
	return list()

/datum/species/proc/get_additional_examine_text(var/mob/living/carbon/human/H)
	return

/datum/species/proc/get_tail(var/mob/living/carbon/human/H)
	return tail

/datum/species/proc/get_tail_animation(var/mob/living/carbon/human/H)
	return tail_animation

/datum/species/proc/get_tail_hair(var/mob/living/carbon/human/H)
	return tail_hair

/datum/species/proc/get_blood_mask(var/mob/living/carbon/human/H)
	return blood_mask

/datum/species/proc/get_damage_overlays(var/mob/living/carbon/human/H)
	return damage_overlays

/datum/species/proc/get_damage_mask(var/mob/living/carbon/human/H)
	return damage_mask

/datum/species/proc/get_examine_name(var/mob/living/carbon/human/H)
	return name

/datum/species/proc/get_icobase(var/mob/living/carbon/human/H, var/get_deform)
	if(base_species == name) //We don't have a custom base_species? Return the normal icobase.
		return (get_deform ? deform : icobase)
	else
		var/datum/species/S = GLOB.all_species[base_species]
		if(S) //So species can have multiple iconbases.
			return S.get_icobase(H, get_deform)
	//fallback
	return (get_deform ? deform : icobase)

/datum/species/proc/get_station_variant()
	return name

/datum/species/proc/get_race_key(var/mob/living/carbon/human/H)
	return race_key

/datum/species/proc/get_bodytype(var/mob/living/carbon/human/H)
	return name

/datum/species/proc/get_knockout_message(var/mob/living/carbon/human/H)
	return ((H && H.isSynthetic()) ? "encounters a hardware fault and suddenly reboots!" : knockout_message)

/datum/species/proc/get_death_message(var/mob/living/carbon/human/H)
	if(CONFIG_GET(flag/show_human_death_message))
		return ((H && H.isSynthetic()) ? "gives one shrill beep before falling lifeless." : death_message)
	else
		return DEATHGASP_NO_MESSAGE

/datum/species/proc/get_ssd(var/mob/living/carbon/human/H)
	if(H)
		if(H.looksSynthetic())
			return "flashing a 'system offline' light"
		else if(!H.ai_holder)
			return show_ssd
		else
			return

/datum/species/proc/get_blood_colour(var/mob/living/carbon/human/H)
	if(H)
		var/datum/robolimb/company = H.isSynthetic()
		if(company)
			return company.blood_color
		else
			return blood_color

/datum/species/proc/get_blood_name(var/mob/living/carbon/human/H)
	if(H)
		var/datum/robolimb/company = H.isSynthetic()
		if(company)
			return company.blood_name
		else
			return blood_name

/datum/species/proc/get_virus_immune(var/mob/living/carbon/human/H)
	return ((H && H.isSynthetic()) ? 1 : virus_immune)

/datum/species/proc/get_flesh_colour(var/mob/living/carbon/human/H)
	return ((H && H.isSynthetic()) ? SYNTH_FLESH_COLOUR : flesh_color)

/datum/species/proc/get_environment_discomfort(var/mob/living/carbon/human/H, var/msg_type)

	/* // Commented out because clothes should not prevent you from feeling cold if your body temperature has already dropped. You can absolutely feel cold through clothing, and feel too warm without clothing. ???
	var/covered = 0 // Basic coverage can help.
	for(var/obj/item/clothing/clothes in H)
		if(H.item_is_in_hands(clothes))
			continue
		if((clothes.body_parts_covered & UPPER_TORSO) && (clothes.body_parts_covered & LOWER_TORSO))
			covered = 1
			break
	*/

	var/discomfort_message
	var/list/custom_cold = H.custom_cold
	var/list/custom_heat = H.custom_heat
	if(msg_type == ENVIRONMENT_COMFORT_MARKER_COLD && length(cold_discomfort_strings) /*&& !covered*/)
		if(custom_cold && custom_cold.len > 0)
			discomfort_message = pick(custom_cold)
		else
			discomfort_message = pick(cold_discomfort_strings)
	else if(msg_type == ENVIRONMENT_COMFORT_MARKER_HOT && length(heat_discomfort_strings) /*&& covered*/)
		if(custom_heat && custom_heat.len > 0)
			discomfort_message = pick(custom_heat)
		else
			discomfort_message = pick(heat_discomfort_strings)

	if(discomfort_message && prob(5))
		to_chat(H, span_danger(discomfort_message))
	return !!discomfort_message

/datum/species/proc/get_random_name(var/gender)
	if(!name_language)
		if(gender == FEMALE)
			return capitalize(pick(first_names_female)) + " " + capitalize(pick(last_names))
		else if(gender == MALE)
			return capitalize(pick(first_names_male)) + " " + capitalize(pick(last_names))
		else
			return capitalize(prob(50) ? pick(first_names_male) : pick(first_names_female)) + " " + capitalize(pick(last_names))

	var/datum/language/species_language = GLOB.all_languages[name_language]
	if(!species_language)
		species_language = GLOB.all_languages[default_language]
	if(!species_language)
		return "unknown"
	return species_language.get_random_name(gender)

/datum/species/proc/get_vision_flags(var/mob/living/carbon/human/H)
	return vision_flags

/datum/species/proc/get_wing_hair(var/mob/living/carbon/human/H) //I have no idea what this is even used for other than teshari, but putting it in just in case.
	return wing_hair //Since the tail has it.
/datum/species/proc/get_wing(var/mob/living/carbon/human/H)
		return wing
/datum/species/proc/get_wing_animation(var/mob/living/carbon/human/H)
	return wing_animation

/datum/species/proc/get_perfect_belly_air_type(var/mob/living/carbon/human/H)
	if(ideal_air_type)
		return ideal_air_type						//Whatever we want
	else
		return /datum/gas_mixture/belly_air 		//Default
