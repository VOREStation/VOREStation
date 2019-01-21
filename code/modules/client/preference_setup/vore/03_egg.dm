var/UNATHI_EGG 		= "Unathi"
var/TAJARAN_EGG 		= "Tajaran"
var/AKULA_EGG 		= "Akula"
var/SKRELL_EGG		= "Skrell"
var/SERGAL_EGG 		= "Sergal"
var/HUMAN_EGG 		= "Human"
var/NEVREAN_EGG		= "nevrean"
var/SLIME_EGG 		= "Slime"
var/EGG_EGG 			= "Egg"
var/XENOCHIMERA_EGG 	= "Xenochimera"
var/XENOMORPH_EGG 	= "Xenomorph"

// Define a place to save appearance in character setup
/datum/preferences
	var/egg_type = "Egg" //The egg type they have.

// Definition of the stuff for the egg type.
/datum/category_item/player_setup_item/vore/egg
	name = "Egg appearance."
	sort_order = 3

/datum/category_item/player_setup_item/vore/egg/load_character(var/savefile/S)
	S["egg_type"]		>> pref.egg_type

/datum/category_item/player_setup_item/vore/egg/save_character(var/savefile/S)
	S["egg_type"]		<< pref.egg_type

/datum/category_item/player_setup_item/vore/egg/sanitize_character()
	var/valid_egg_types = global_egg_types
	pref.egg_type	 = sanitize_inlist(pref.egg_type, valid_egg_types, initial(pref.egg_type))

/datum/category_item/player_setup_item/vore/egg/copy_to_mob(var/mob/living/carbon/human/character)
	character.egg_type	= pref.egg_type

/datum/category_item/player_setup_item/vore/egg/content(var/mob/user)
	. += "<br>"
	. += " Egg Type: <a href='?src=\ref[src];egg_type=1'>[pref.egg_type]</a><br>"

/datum/category_item/player_setup_item/vore/egg/OnTopic(var/href, var/list/href_list, var/mob/user)
	if(!CanUseTopic(user))
		return TOPIC_NOACTION

	else if(href_list["egg_type"])
		var/list/egg_types = global_egg_types
		var/selection = input(user, "Choose your character's egg type:", "Character Preference", pref.egg_type) as null|anything in egg_types
		if(selection)
			pref.egg_type = egg_types[selection]
			return TOPIC_REFRESH
	else
		return