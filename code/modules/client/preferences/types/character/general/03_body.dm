/datum/preference/color/human/hair_color
	category = PREFERENCE_CATEGORY_MANUALLY_RENDERED
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "hair_color"
	can_randomize = FALSE

/datum/preference/color/human/hair_color/apply_to_human(mob/living/carbon/human/target, value)
	target.r_hair = hex2num(copytext(value, 2, 4))
	target.g_hair = hex2num(copytext(value, 4, 6))
	target.b_hair = hex2num(copytext(value, 6, 8))

/datum/preference/color/human/grad_color
	category = PREFERENCE_CATEGORY_MANUALLY_RENDERED
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "grad_color"
	can_randomize = FALSE

/datum/preference/color/human/grad_color/apply_to_human(mob/living/carbon/human/target, value)
	target.r_grad = hex2num(copytext(value, 2, 4))
	target.g_grad = hex2num(copytext(value, 4, 6))
	target.b_grad = hex2num(copytext(value, 6, 8))

/datum/preference/color/human/facial_color
	category = PREFERENCE_CATEGORY_MANUALLY_RENDERED
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "facial_color"
	can_randomize = FALSE

/datum/preference/color/human/facial_color/apply_to_human(mob/living/carbon/human/target, value)
	target.r_facial = hex2num(copytext(value, 2, 4))
	target.g_facial = hex2num(copytext(value, 4, 6))
	target.b_facial = hex2num(copytext(value, 6, 8))

/datum/preference/color/human/eyes_color
	category = PREFERENCE_CATEGORY_MANUALLY_RENDERED
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "eyes_color"
	can_randomize = FALSE

/datum/preference/color/human/eyes_color/apply_to_human(mob/living/carbon/human/target, value)
	target.r_eyes = hex2num(copytext(value, 2, 4))
	target.g_eyes = hex2num(copytext(value, 4, 6))
	target.b_eyes = hex2num(copytext(value, 6, 8))

/datum/preference/color/human/skin_color
	category = PREFERENCE_CATEGORY_MANUALLY_RENDERED
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "skin_color"
	can_randomize = FALSE

/datum/preference/color/human/skin_color/apply_to_human(mob/living/carbon/human/target, value)
	target.r_skin = hex2num(copytext(value, 2, 4))
	target.g_skin = hex2num(copytext(value, 4, 6))
	target.b_skin = hex2num(copytext(value, 6, 8))

/datum/preference/color/human/synth_color
	category = PREFERENCE_CATEGORY_MANUALLY_RENDERED
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "synth_color_rgb"
	can_randomize = FALSE

/datum/preference/color/human/synth_color/apply_to_human(mob/living/carbon/human/target, value)
	target.r_synth = hex2num(copytext(value, 2, 4))
	target.g_synth = hex2num(copytext(value, 4, 6))
	target.b_synth = hex2num(copytext(value, 6, 8))

/datum/preference/color/human/tail_color1
	category = PREFERENCE_CATEGORY_MANUALLY_RENDERED
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "tail_color1"
	can_randomize = FALSE

/datum/preference/color/human/tail_color1/apply_to_human(mob/living/carbon/human/target, value)
	target.r_tail = hex2num(copytext(value, 2, 4))
	target.g_tail = hex2num(copytext(value, 4, 6))
	target.b_tail = hex2num(copytext(value, 6, 8))

/datum/preference/color/human/tail_color2
	category = PREFERENCE_CATEGORY_MANUALLY_RENDERED
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "tail_color2"
	can_randomize = FALSE

/datum/preference/color/human/tail_color2/apply_to_human(mob/living/carbon/human/target, value)
	target.r_tail2 = hex2num(copytext(value, 2, 4))
	target.g_tail2 = hex2num(copytext(value, 4, 6))
	target.b_tail2 = hex2num(copytext(value, 6, 8))

/datum/preference/color/human/tail_color3
	category = PREFERENCE_CATEGORY_MANUALLY_RENDERED
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "tail_color3"
	can_randomize = FALSE

/datum/preference/color/human/tail_color3/apply_to_human(mob/living/carbon/human/target, value)
	target.r_tail3 = hex2num(copytext(value, 2, 4))
	target.g_tail3 = hex2num(copytext(value, 4, 6))
	target.b_tail3 = hex2num(copytext(value, 6, 8))


/datum/preference/color/human/wing_color1
	category = PREFERENCE_CATEGORY_MANUALLY_RENDERED
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "wing_color1"
	can_randomize = FALSE

/datum/preference/color/human/wing_color1/apply_to_human(mob/living/carbon/human/target, value)
	target.r_wing = hex2num(copytext(value, 2, 4))
	target.g_wing = hex2num(copytext(value, 4, 6))
	target.b_wing = hex2num(copytext(value, 6, 8))

/datum/preference/color/human/wing_color2
	category = PREFERENCE_CATEGORY_MANUALLY_RENDERED
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "wing_color2"
	can_randomize = FALSE

/datum/preference/color/human/wing_color2/apply_to_human(mob/living/carbon/human/target, value)
	target.r_wing2 = hex2num(copytext(value, 2, 4))
	target.g_wing2 = hex2num(copytext(value, 4, 6))
	target.b_wing2 = hex2num(copytext(value, 6, 8))

/datum/preference/color/human/wing_color3
	category = PREFERENCE_CATEGORY_MANUALLY_RENDERED
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "wing_color3"
	can_randomize = FALSE

/datum/preference/color/human/wing_color3/apply_to_human(mob/living/carbon/human/target, value)
	target.r_wing3 = hex2num(copytext(value, 2, 4))
	target.g_wing3 = hex2num(copytext(value, 4, 6))
	target.b_wing3 = hex2num(copytext(value, 6, 8))


/datum/preference/color/human/ears_color1
	category = PREFERENCE_CATEGORY_MANUALLY_RENDERED
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "ears_color1"
	can_randomize = FALSE

/datum/preference/color/human/ears_color1/apply_to_human(mob/living/carbon/human/target, value)
	target.r_ears = hex2num(copytext(value, 2, 4))
	target.g_ears = hex2num(copytext(value, 4, 6))
	target.b_ears = hex2num(copytext(value, 6, 8))

/datum/preference/color/human/ears_color2
	category = PREFERENCE_CATEGORY_MANUALLY_RENDERED
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "ears_color2"
	can_randomize = FALSE

/datum/preference/color/human/ears_color2/apply_to_human(mob/living/carbon/human/target, value)
	target.r_ears2 = hex2num(copytext(value, 2, 4))
	target.g_ears2 = hex2num(copytext(value, 4, 6))
	target.b_ears2 = hex2num(copytext(value, 6, 8))

/datum/preference/color/human/ears_color3
	category = PREFERENCE_CATEGORY_MANUALLY_RENDERED
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "ears_color3"
	can_randomize = FALSE

/datum/preference/color/human/ears_color3/apply_to_human(mob/living/carbon/human/target, value)
	target.r_ears3 = hex2num(copytext(value, 2, 4))
	target.g_ears3 = hex2num(copytext(value, 4, 6))
	target.b_ears3 = hex2num(copytext(value, 6, 8))
