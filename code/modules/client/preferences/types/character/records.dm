// Character employment, medical, and security records.
// Separated from background preferences where it was handled.

/datum/preference/text/human/med_record
	savefile_key = "med_record"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_NON_CONTEXTUAL
	can_randomize = FALSE
	maximum_value_length = MAX_RECORD_LENGTH

/datum/preference/text/human/med_record/apply_to_human(mob/living/carbon/human/target, value)
	target.med_record = value

/datum/preference/text/human/sec_record
	savefile_key = "sec_record"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_NON_CONTEXTUAL
	can_randomize = FALSE
	maximum_value_length = MAX_RECORD_LENGTH

/datum/preference/text/human/sec_record/apply_to_human(mob/living/carbon/human/target, value)
	target.sec_record = value

/datum/preference/text/human/gen_record
	savefile_key = "gen_record"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_NON_CONTEXTUAL
	can_randomize = FALSE
	maximum_value_length = MAX_RECORD_LENGTH

/datum/preference/text/human/gen_record/apply_to_human(mob/living/carbon/human/target, value)
	target.gen_record = value
