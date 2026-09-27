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

/datum/category_item/player_setup_item/general/records
	name = "Records"
	sort_order = 6

/datum/category_item/player_setup_item/general/records/load_character(list/save_data)
	return

/datum/category_item/player_setup_item/general/records/save_character(list/save_data)
	return

/datum/category_item/player_setup_item/general/records/sanitize_character()
	return

/datum/category_item/player_setup_item/general/records/copy_to_mob(mob/living/carbon/human/character)
	return

/datum/category_item/player_setup_item/general/records/tgui_data(mob/user)
	var/list/data = ..()

	if(jobban_isbanned(user, "Records"))
		data["records_banned"] = TRUE
	else
		data["records_banned"] = FALSE

		data["med_record"] = TextPreview(pref.read_preference(/datum/preference/text/human/med_record), 40)
		data["gen_record"] = TextPreview(pref.read_preference(/datum/preference/text/human/gen_record), 40)
		data["sec_record"] = TextPreview(pref.read_preference(/datum/preference/text/human/sec_record), 40)

	return data

/datum/category_item/player_setup_item/general/records/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
	. = ..()
	if(.)
		return

	var/mob/user = ui.user
	switch(action)
		if("set_medical_records")
			var/new_medical = strip_html_simple(tgui_input_text(user,"Enter medical information here.","Character Preference", html_decode(pref.read_preference(/datum/preference/text/human/med_record)), MAX_RECORD_LENGTH, TRUE, prevent_enter = TRUE), MAX_RECORD_LENGTH)
			if(new_medical && !jobban_isbanned(user, JOB_RECORDS))
				pref.write_preference_by_type(/datum/preference/text/human/med_record, new_medical)
			return TOPIC_REFRESH

		if("set_general_records")
			var/new_general = strip_html_simple(tgui_input_text(user,"Enter employment information here.","Character Preference", html_decode(pref.read_preference(/datum/preference/text/human/gen_record)), MAX_RECORD_LENGTH, TRUE, prevent_enter = TRUE), MAX_RECORD_LENGTH)
			if(new_general && !jobban_isbanned(user, JOB_RECORDS))
				pref.write_preference_by_type(/datum/preference/text/human/gen_record, new_general)
			return TOPIC_REFRESH

		if("set_security_records")
			var/sec_medical = strip_html_simple(tgui_input_text(user,"Enter security information here.","Character Preference", html_decode(pref.read_preference(/datum/preference/text/human/sec_record)), MAX_RECORD_LENGTH, TRUE, prevent_enter = TRUE), MAX_RECORD_LENGTH)
			if(sec_medical && !jobban_isbanned(user, JOB_RECORDS))
				pref.write_preference_by_type(/datum/preference/text/human/sec_record, sec_medical)
			return TOPIC_REFRESH

		if("reset_medrecord")
			var/resetmed_choice = tgui_alert(user, "Wipe your Medical Records? This cannot be reverted if you have not saved your character recently! You may wish to make a backup first.","Reset Records",list("Yes","No"))
			if(resetmed_choice == "Yes")
				pref.write_preference_by_type(/datum/preference/text/human/med_record, "")
			return TOPIC_REFRESH

		if("reset_emprecord")
			var/resetemp_choice = tgui_alert(user, "Wipe your Employment Records? This cannot be reverted if you have not saved your character recently! You may wish to make a backup first.","Reset Records",list("Yes","No"))
			if(resetemp_choice == "Yes")
				pref.write_preference_by_type(/datum/preference/text/human/gen_record, "")
			return TOPIC_REFRESH

		if("reset_secrecord")
			var/resetsec_choice = tgui_alert(user, "Wipe your Security Records? This cannot be reverted if you have not saved your character recently! You may wish to make a backup first.","Reset Records",list("Yes","No"))
			if(resetsec_choice == "Yes")
				pref.write_preference_by_type(/datum/preference/text/human/sec_record, "")
			return TOPIC_REFRESH
