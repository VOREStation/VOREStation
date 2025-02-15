// Define a place to save in character setup
/datum/preferences
	var/vantag_volunteer = 0	// What state I want to be in, in terms of being affected by antags.
	var/vantag_preference = VANTAG_NONE	// Whether I'd like to volunteer to be an antag at some point.

// Definition of the stuff for Sizing
/datum/category_item/player_setup_item/vore/vantag
	name = "VS Events"
	sort_order = 6

/datum/category_item/player_setup_item/vore/vantag/load_character(list/save_data)
	pref.vantag_volunteer	= save_data["vantag_volunteer"]
	pref.vantag_preference	= save_data["vantag_preference"]

/datum/category_item/player_setup_item/vore/vantag/save_character(list/save_data)
	save_data["vantag_volunteer"]	= pref.vantag_volunteer
	save_data["vantag_preference"]	= pref.vantag_preference

/datum/category_item/player_setup_item/vore/vantag/sanitize_character()
	pref.vantag_volunteer	= sanitize_integer(pref.vantag_volunteer, 0, 1, initial(pref.vantag_volunteer))
	pref.vantag_preference	= sanitize_inlist(pref.vantag_preference, GLOB.vantag_choices_list, initial(pref.vantag_preference))

/datum/category_item/player_setup_item/vore/vantag/copy_to_mob(var/mob/living/carbon/human/character)
	if(character && !istype(character,/mob/living/carbon/human/dummy))
		character.vantag_pref = pref.vantag_preference
		BITSET(character.hud_updateflag, VANTAG_HUD)

/datum/category_item/player_setup_item/vore/vantag/content(var/mob/user)
	. += "<br>"
	. += span_bold("Event Volunteer:") + " <a [pref.vantag_volunteer ? "class='linkOn'" : ""] href='byond://?src=\ref[src];toggle_vantag_volunteer=1'>" + span_bold("[pref.vantag_volunteer ? "Yes" : "No"]") + "</a><br>"
	. += span_bold("Event Pref:") + " <a href='byond://?src=\ref[src];change_vantag=1'>" + span_bold("[GLOB.vantag_choices_list[pref.vantag_preference]]") + "</a><br>"

/datum/category_item/player_setup_item/vore/vantag/OnTopic(var/href, var/list/href_list, var/mob/user)
	if(href_list["toggle_vantag_volunteer"])
		pref.vantag_volunteer = pref.vantag_volunteer ? 0 : 1
		return TOPIC_REFRESH

	else if(href_list["change_vantag"])
		var/list/names_list = list()
		for(var/C in GLOB.vantag_choices_list)
			names_list[GLOB.vantag_choices_list[C]] = C

		var/selection = tgui_input_list(user, "How do you want to be involved with VS Event Characters, ERP-wise? They will see this choice on you in a HUD. Event characters are admin-selected and spawned players, possibly with assigned objectives, who are obligated to respect ERP prefs and RP their actions like any other player, though it may be a slightly shorter RP if they are pressed for time or being caught.", "Event Preference", names_list)
		if(selection && selection != "Normal")
			pref.vantag_preference = names_list[selection]

		return TOPIC_REFRESH
	return ..()
