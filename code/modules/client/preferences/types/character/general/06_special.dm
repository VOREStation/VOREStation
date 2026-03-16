/datum/preference/color/living/flicker_color
	category = PREFERENCE_CATEGORY_MANUALLY_RENDERED
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "flicker_color"
	can_randomize = FALSE

/datum/preference/color/living/flicker_color/create_default_value()
	return "#E0EFF0"

/datum/preference/color/living/flicker_color/apply_to_living(mob/living/target, value)
	var/datum/component/shadekin/our_SK = target.get_shadekin_component()
	if(our_SK)
		our_SK.flicker_color = value

/datum/preference/numeric/living/flicker_time
	category = PREFERENCE_CATEGORY_MANUALLY_RENDERED
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "flicker_time"
	can_randomize = FALSE
	minimum = 2
	maximum = 20

/datum/preference/numeric/living/flicker_time/create_default_value()
	return 10

/datum/preference/numeric/living/flicker_time/apply_to_living(mob/living/target, value)
	var/datum/component/shadekin/our_SK = target.get_shadekin_component()
	if(our_SK)
		our_SK.flicker_time = value

/datum/preference/numeric/living/flicker_break_chance
	category = PREFERENCE_CATEGORY_MANUALLY_RENDERED
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "flicker_break_chance"
	can_randomize = FALSE
	minimum = 0
	maximum = 25

/datum/preference/numeric/living/flicker_break_chance/create_default_value()
	return 0

/datum/preference/numeric/living/flicker_break_chance/apply_to_living(mob/living/target, value)
	var/datum/component/shadekin/our_SK = target.get_shadekin_component()
	if(our_SK)
		our_SK.flicker_break_chance = value

/datum/preference/numeric/living/flicker_distance
	category = PREFERENCE_CATEGORY_MANUALLY_RENDERED
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "flicker_distance"
	can_randomize = FALSE
	minimum = 4
	maximum = 10

/datum/preference/numeric/living/flicker_distance/create_default_value()
	return 4

/datum/preference/numeric/living/flicker_distance/apply_to_living(mob/living/target, value)
	var/datum/component/shadekin/our_SK = target.get_shadekin_component()
	if(our_SK)
		our_SK.flicker_distance = value

/datum/preference/toggle/living/dark_retreat_toggle
	category = PREFERENCE_CATEGORY_MANUALLY_RENDERED
	savefile_key = "DARK_RETREAT_TOGGLE"
	default_value = TRUE
	savefile_identifier = PREFERENCE_PLAYER

/datum/preference/toggle/living/dark_retreat_toggle/apply_to_living(mob/living/target, value)
	var/datum/component/shadekin/our_SK = target.get_shadekin_component()
	if(our_SK)
		our_SK.no_retreat = value

/datum/preference/toggle/living/shadekin_nutrition_conversion
	category = PREFERENCE_CATEGORY_MANUALLY_RENDERED
	savefile_key = "SHADEKIN_NUTRITION_CONVERSION"
	default_value = FALSE
	savefile_identifier = PREFERENCE_PLAYER

/datum/preference/toggle/living/shadekin_nutrition_conversion/apply_to_living(mob/living/target, value)
	var/datum/component/shadekin/our_SK = target.get_shadekin_component()
	if(our_SK)
		our_SK.nutrition_energy_conversion = value

/datum/preference/toggle/living/shadekin_hide_voice_in_phase
	category = PREFERENCE_CATEGORY_MANUALLY_RENDERED
	savefile_key = "SHADEKIN_HIDE_VOICE_IN_PHASE"
	default_value = TRUE
	savefile_identifier = PREFERENCE_PLAYER

/datum/preference/toggle/living/shadekin_hide_voice_in_phase/apply_to_living(mob/living/target, value)
	var/datum/component/shadekin/our_SK = target.get_shadekin_component()
	if(our_SK)
		our_SK.hide_voice_in_phase = value
