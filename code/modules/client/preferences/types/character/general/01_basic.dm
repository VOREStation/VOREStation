// Toggles
/datum/preference/toggle/human/bday_announce
	category = PREFERENCE_CATEGORY_NON_CONTEXTUAL
	savefile_key = "bday_announce"
	default_value = FALSE
	savefile_identifier = PREFERENCE_CHARACTER
	can_randomize = FALSE

/datum/preference/toggle/human/bday_announce/apply_to_human(mob/living/carbon/human/target, value)
	return


// Numerics
/datum/preference/numeric/human/age
	category = PREFERENCE_CATEGORY_MANUALLY_RENDERED
	savefile_key = "age"
	savefile_identifier = PREFERENCE_CHARACTER

	step = 1
	minimum = 18
	maximum = 250

/datum/preference/numeric/human/age/apply_to_human(mob/living/carbon/human/target, value)
	target.age = value
	return

/datum/preference/numeric/human/age/create_default_value()
	return 18

/datum/preference/numeric/human/age/create_random_value(datum/preferences/preferences, datum/species/current_species)
	return rand(current_species.min_age, current_species.max_age)

/datum/preference/numeric/human/bday_month
	category = PREFERENCE_CATEGORY_MANUALLY_RENDERED
	savefile_key = "bday_month"
	savefile_identifier = PREFERENCE_CHARACTER
	can_randomize = FALSE

	step = 1
	minimum = 0
	maximum = 12

/datum/preference/numeric/human/bday_month/apply_to_human(mob/living/carbon/human/target, value)
	return

/datum/preference/numeric/human/bday_month/create_default_value()
	return 0

/datum/preference/numeric/human/bday_day
	category = PREFERENCE_CATEGORY_MANUALLY_RENDERED
	savefile_key = "bday_day"
	savefile_identifier = PREFERENCE_CHARACTER
	can_randomize = FALSE

	step = 1
	minimum = 0
	maximum = 31

/datum/preference/numeric/human/bday_day/apply_to_human(mob/living/carbon/human/target, value)
	return

/datum/preference/numeric/human/bday_day/create_default_value()
	return 0

/datum/preference/numeric/human/last_bday_note
	category = PREFERENCE_CATEGORY_MANUALLY_RENDERED
	savefile_key = "last_bday_note"
	savefile_identifier = PREFERENCE_CHARACTER
	can_randomize = FALSE

	step = 1
	minimum = 0
	maximum = 9999

/datum/preference/numeric/human/last_bday_note/apply_to_human(mob/living/carbon/human/target, value)
	return

/datum/preference/numeric/human/last_bday_note/create_default_value()
	return 0

/datum/preference/numeric/human/last_bday_note/is_accessible(datum/preferences/preferences)
	..()
	return FALSE

/datum/preference/text/living/ooc_notes
	category = PREFERENCE_CATEGORY_MANUALLY_RENDERED
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "OOC_Notes"
	maximum_value_length = MAX_MESSAGE_LEN * 4
	can_randomize = FALSE

/datum/preference/text/living/ooc_notes/apply_to_living(mob/living/target, value)
	target.ooc_notes = value
	return

/datum/preference/text/living/ooc_notes_likes
	category = PREFERENCE_CATEGORY_MANUALLY_RENDERED
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "OOC_Notes_Likes"
	maximum_value_length = MAX_MESSAGE_LEN * 2
	can_randomize = FALSE

/datum/preference/text/living/ooc_notes_likes/apply_to_living(mob/living/target, value)
	target.ooc_notes_likes = value
	return

/datum/preference/text/living/ooc_notes_dislikes
	category = PREFERENCE_CATEGORY_MANUALLY_RENDERED
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "OOC_Notes_Disikes"
	maximum_value_length = MAX_MESSAGE_LEN * 2
	can_randomize = FALSE

/datum/preference/text/living/ooc_notes_dislikes/apply_to_living(mob/living/target, value)
	target.ooc_notes_dislikes = value
	return

// CHOMP specific, but added here not to forget
/datum/preference/toggle/living/ooc_notes_style
	category = PREFERENCE_CATEGORY_MANUALLY_RENDERED
	savefile_key = "OOC_Notes_System"
	default_value = FALSE
	savefile_identifier = PREFERENCE_CHARACTER
	can_randomize = FALSE

/datum/preference/toggle/living/ooc_notes_style/apply_to_living(mob/living/target, value)
	// target.ooc_notes_style // Not available on virgo
	return

/datum/preference/text/living/ooc_notes_maybes
	category = PREFERENCE_CATEGORY_MANUALLY_RENDERED
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "OOC_Notes_Maybes"
	maximum_value_length = MAX_MESSAGE_LEN * 2
	can_randomize = FALSE

/datum/preference/text/living/ooc_notes_maybes/apply_to_living(mob/living/target, value)
	// target.ooc_notes_maybes = value // Not available on virgo
	return

/datum/preference/text/living/ooc_notes_favs
	category = PREFERENCE_CATEGORY_MANUALLY_RENDERED
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "OOC_Notes_Favs"
	maximum_value_length = MAX_MESSAGE_LEN * 2
	can_randomize = FALSE

/datum/preference/text/living/ooc_notes_favs/apply_to_living(mob/living/target, value)
	// target.ooc_notes_favs = value // Not available on virgo
	return

/datum/preference/toggle/human/name_is_always_random
	category = PREFERENCE_CATEGORY_MANUALLY_RENDERED
	savefile_key = "name_is_always_random"
	default_value = FALSE
	savefile_identifier = PREFERENCE_CHARACTER
	can_randomize = FALSE

/datum/preference/toggle/human/name_is_always_random/apply_to_human(mob/living/carbon/human/target, value)
	return // handled in copy_to

/datum/preference/choiced/living/spawnpoint
	category = PREFERENCE_CATEGORY_MANUALLY_RENDERED
	savefile_key = "spawnpoint"
	savefile_identifier = PREFERENCE_CHARACTER
	can_randomize = FALSE

/datum/preference/choiced/living/spawnpoint/init_possible_values()
	var/list/spawnkeys = list()
	for(var/spawntype in get_spawn_points())
		spawnkeys += spawntype
	return spawnkeys

/datum/preference/choiced/living/spawnpoint/apply_to_living(mob/living/target, value)
	return // handled in job_controller
