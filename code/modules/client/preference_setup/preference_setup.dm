#define PREF_FBP_CYBORG "cyborg"
#define PREF_FBP_POSI "posi"
#define PREF_FBP_SOFTWARE "software"

/datum/category_group/player_setup_category/general_preferences
	name = "General"
	sort_order = 1
	category_item_type = /datum/category_item/player_setup_item/general

/datum/category_group/player_setup_category/occupation_preferences
	name = "Occupation"
	sort_order = 3
	category_item_type = /datum/category_item/player_setup_item/occupation

/datum/category_group/player_setup_category/appearance_preferences
	name = "Antagonism"
	sort_order = 4
	category_item_type = /datum/category_item/player_setup_item/antagonism

/datum/category_group/player_setup_category/loadout_preferences
	name = "Loadout"
	sort_order = 5
	category_item_type = /datum/category_item/player_setup_item/loadout
/* //VOREStation Removal
/datum/category_group/player_setup_category/trait_preferences
	name = "Traits"
	sort_order = 6
	category_item_type = /datum/category_item/player_setup_item/traits
*/ //VOREStation Removal End
/datum/category_group/player_setup_category/global_preferences
	name = "Global"
	sort_order = 6 //VOREStation Edit due to above commented out
	category_item_type = /datum/category_item/player_setup_item/player_global

/****************************
* Category Collection Setup *
****************************/
/datum/category_collection/player_setup_collection
	category_group_type = /datum/category_group/player_setup_category
	var/datum/preferences/preferences
	var/datum/category_group/player_setup_category/selected_category = null

/datum/category_collection/player_setup_collection/New(var/datum/preferences/preferences)
	src.preferences = preferences
	..()
	selected_category = categories[1]

/datum/category_collection/player_setup_collection/Destroy()
	preferences = null
	selected_category = null
	return ..()

/datum/category_collection/player_setup_collection/proc/sanitize_setup()
	for(var/datum/category_group/player_setup_category/PS in categories)
		PS.sanitize_setup()

/datum/category_collection/player_setup_collection/proc/load_character(list/save_data)
	for(var/datum/category_group/player_setup_category/PS in categories)
		PS.load_character(save_data)

/datum/category_collection/player_setup_collection/proc/save_character(list/save_data)
	for(var/datum/category_group/player_setup_category/PS in categories)
		PS.save_character(save_data)

/datum/category_collection/player_setup_collection/proc/load_preferences(datum/json_savefile/savefile)
	for(var/datum/category_group/player_setup_category/PS in categories)
		PS.load_preferences(savefile)

/datum/category_collection/player_setup_collection/proc/save_preferences(datum/json_savefile/savefile)
	for(var/datum/category_group/player_setup_category/PS in categories)
		PS.save_preferences(savefile)

/datum/category_collection/player_setup_collection/proc/copy_to_mob(var/mob/living/carbon/human/C)
	for(var/datum/category_group/player_setup_category/PS in categories)
		PS.copy_to_mob(C)

/datum/category_collection/player_setup_collection/proc/header()
	var/dat = ""
	for(var/datum/category_group/player_setup_category/PS in categories)
		if(PS == selected_category)
			dat += "[PS.name] "	// TODO: Check how to properly mark a href/button selected in a classic browser window
		else
			dat += "<a href='byond://?src=\ref[src];category=\ref[PS]'>[PS.name]</a> "
	dat += "<a href='byond://?src=\ref[src];game_prefs=1'>Game Options</a>"
	return dat

/datum/category_collection/player_setup_collection/proc/content(var/mob/user)
	if(selected_category)
		return selected_category.content(user)

/datum/category_collection/player_setup_collection/Topic(var/href,var/list/href_list)
	if(..())
		return 1
	var/mob/user = usr
	if(!user.client)
		return 1

	if(href_list["category"])
		var/category = locate(href_list["category"])
		if(category && (category in categories))
			selected_category = category
		. = 1

	else if(href_list["game_prefs"])
		user.client.prefs.tgui_interact(user)

	if(.)
		user.client.prefs.ShowChoices(user)

/**************************
* Category Category Setup *
**************************/
/datum/category_group/player_setup_category
	var/sort_order = 0

/datum/category_group/player_setup_category/dd_SortValue()
	return sort_order

/datum/category_group/player_setup_category/proc/sanitize_setup()
	for(var/datum/category_item/player_setup_item/PI in items)
		PI.sanitize_preferences()
	for(var/datum/category_item/player_setup_item/PI in items)
		PI.sanitize_character()

/datum/category_group/player_setup_category/proc/load_character(list/save_data)
	// Load all data, then sanitize it.
	// Need due to, for example, the 01_basic module relying on species having been loaded to sanitize correctly but that isn't loaded until module 03_body.
	for(var/datum/category_item/player_setup_item/PI in items)
		PI.load_character(save_data)


/datum/category_group/player_setup_category/proc/save_character(list/save_data)
	// Sanitize all data, then save it
	for(var/datum/category_item/player_setup_item/PI in items)
		PI.sanitize_character()
	for(var/datum/category_item/player_setup_item/PI in items)
		PI.save_character(save_data)

/datum/category_group/player_setup_category/proc/load_preferences(datum/json_savefile/savefile)
	for(var/datum/category_item/player_setup_item/PI in items)
		PI.load_preferences(savefile)

/datum/category_group/player_setup_category/proc/save_preferences(datum/json_savefile/savefile)
	for(var/datum/category_item/player_setup_item/PI in items)
		PI.sanitize_preferences()
	for(var/datum/category_item/player_setup_item/PI in items)
		PI.save_preferences(savefile)

/datum/category_group/player_setup_category/proc/copy_to_mob(var/mob/living/carbon/human/C)
	for(var/datum/category_item/player_setup_item/PI in items)
		PI.copy_to_mob(C)

/datum/category_group/player_setup_category/proc/content(var/mob/user)
	. = "<table style='width:100%'><tr style='vertical-align:top'><td style='width:50%'>"
	var/current = 0
	var/halfway = items.len / 2
	for(var/datum/category_item/player_setup_item/PI in items)
		if(halfway && current++ >= halfway)
			halfway = 0
			. += "</td><td></td><td style='width:50%'>"
		. += "[PI.content(user)]<br>"
	. += "</td></tr></table>"

/datum/category_group/player_setup_category/occupation_preferences/content(var/mob/user)
	for(var/datum/category_item/player_setup_item/PI in items)
		. += "[PI.content(user)]<br>"

/**********************
* Category Item Setup *
**********************/
/datum/category_item/player_setup_item
	var/sort_order = 0
	var/datum/preferences/pref

/datum/category_item/player_setup_item/New()
	..()
	var/datum/category_collection/player_setup_collection/psc = category.collection
	pref = psc.preferences

/datum/category_item/player_setup_item/Destroy()
	pref = null
	return ..()

/datum/category_item/player_setup_item/dd_SortValue()
	return sort_order

/*
* Called when the item is asked to load per character settings
*/
/datum/category_item/player_setup_item/proc/load_character(list/save_data)
	return

/*
* Called when the item is asked to save per character settings
*/
/datum/category_item/player_setup_item/proc/save_character(list/save_data)
	return

/*
* Called when the item is asked to load user/global settings
*/
/datum/category_item/player_setup_item/proc/load_preferences(datum/json_savefile/savefile)
	return

/*
* Called when the item is asked to save user/global settings
*/
/datum/category_item/player_setup_item/proc/save_preferences(datum/json_savefile/savefile)
	return

/*
* Called when the item is asked to apply its per character settings to a new mob.
*/
/datum/category_item/player_setup_item/proc/copy_to_mob(var/mob/living/carbon/human/C)
	return

/datum/category_item/player_setup_item/proc/content()
	return

/datum/category_item/player_setup_item/proc/sanitize_character()
	return

/datum/category_item/player_setup_item/proc/sanitize_preferences()
	return

/datum/category_item/player_setup_item/Topic(var/href,var/list/href_list)
	if(..())
		return 1
	var/mob/pref_mob = preference_mob()
	if(!pref_mob || !pref_mob.client)
		return 1

	. = OnTopic(href, href_list, usr)

	if(!pref_mob || !pref_mob.client)		// Just in case we disappeared during OnTopic
		return 1

	if(. & TOPIC_UPDATE_PREVIEW)
		pref_mob.client.prefs.update_preview_icon()
	if(. & TOPIC_REFRESH)
		pref_mob.client.prefs.ShowChoices(usr)

/datum/category_item/player_setup_item/CanUseTopic(var/mob/user)
	return 1

/datum/category_item/player_setup_item/proc/OnTopic(var/href,var/list/href_list, var/mob/user)
	return TOPIC_NOACTION

/datum/category_item/player_setup_item/proc/preference_mob()
	if(!pref.client)
		for(var/client/C)
			if(C.ckey == pref.client_ckey)
				pref.client = C
				break

	if(pref.client)
		return pref.client.mob

// Checks in a really hacky way if a character's preferences say they are an FBP or not.
/datum/category_item/player_setup_item/proc/is_FBP()
	if(pref.organ_data && pref.organ_data[BP_TORSO] != "cyborg")
		return 0
	return 1

// Returns what kind of FBP the player's prefs are.  Returns 0 if they're not an FBP.
/datum/category_item/player_setup_item/proc/get_FBP_type()
	if(!is_FBP())
		return 0 // Not a robot.
	if(O_BRAIN in pref.organ_data)
		switch(pref.organ_data[O_BRAIN])
			if("assisted")
				return PREF_FBP_CYBORG
			if("mechanical")
				return PREF_FBP_POSI
			if("digital")
				return PREF_FBP_SOFTWARE
	return 0 //Something went wrong!

/datum/category_item/player_setup_item/proc/get_min_age()
	var/datum/species/S = GLOB.all_species[pref.species ? pref.species : "Human"]
	if(!is_FBP())
		return S.min_age // If they're not a robot, we can just use the species var.
	var/FBP_type = get_FBP_type()
	switch(FBP_type)
		if(PREF_FBP_CYBORG)
			return S.min_age
		if(PREF_FBP_POSI)
			return 1
		if(PREF_FBP_SOFTWARE)
			return 1
	return S.min_age // welp

/datum/category_item/player_setup_item/proc/get_max_age()
	var/datum/species/S = GLOB.all_species[pref.species ? pref.species : "Human"]
	if(!is_FBP())
		return S.max_age // If they're not a robot, we can just use the species var.
	var/FBP_type = get_FBP_type()
	switch(FBP_type)
		if(PREF_FBP_CYBORG)
			return S.max_age + 20
		if(PREF_FBP_POSI)
			return 220
		if(PREF_FBP_SOFTWARE)
			return 150
	return S.max_age // welp

#undef PREF_FBP_CYBORG
#undef PREF_FBP_POSI
#undef PREF_FBP_SOFTWARE
