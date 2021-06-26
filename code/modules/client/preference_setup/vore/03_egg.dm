// Define a place to save appearance in character setup
/datum/preferences
	var/vore_egg_type = "Egg" //The egg type they have.

// Definition of the stuff for the egg type.
/datum/category_item/player_setup_item/vore/egg
	name = "Egg appearance."
	sort_order = 3

/datum/category_item/player_setup_item/vore/egg/load_character(var/savefile/S)
	S["vore_egg_type"]		>> pref.vore_egg_type

/datum/category_item/player_setup_item/vore/egg/save_character(var/savefile/S)
	S["vore_egg_type"]		<< pref.vore_egg_type

/datum/category_item/player_setup_item/vore/egg/sanitize_character()
	pref.vore_egg_type	 = sanitize_inlist(pref.vore_egg_type, global_vore_egg_types, initial(pref.vore_egg_type))

/datum/category_item/player_setup_item/vore/egg/copy_to_mob(var/mob/living/carbon/human/character)
	character.vore_egg_type	= pref.vore_egg_type

/datum/category_item/player_setup_item/vore/egg/content(var/mob/user)
	. += "<br>"
	. += " Egg Type: <a href='?src=\ref[src];vore_egg_type=1'>[pref.vore_egg_type]</a><br>"

/datum/category_item/player_setup_item/vore/egg/OnTopic(var/href, var/list/href_list, var/mob/user)
	if(!CanUseTopic(user))
		return TOPIC_NOACTION

	else if(href_list["vore_egg_type"])
		var/list/vore_egg_types = global_vore_egg_types
		var/selection = tgui_input_list(user, "Choose your character's egg type:", "Character Preference", vore_egg_types, pref.vore_egg_type)
		if(selection)
			pref.vore_egg_type = selection
			return TOPIC_REFRESH
	else
		return
