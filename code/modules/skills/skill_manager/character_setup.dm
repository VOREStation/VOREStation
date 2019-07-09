// This subtype is used for the skills tab in character setup.
/datum/skill_manager/character_setup

/datum/skill_manager/character_setup/get_age()
	return user.prefs.age

/datum/skill_manager/character_setup/get_species()
	return all_species[user.prefs.species]

/datum/skill_manager/character_setup/get_FBP_type()
	return user.prefs.get_FBP_type()

/datum/skill_manager/character_setup/refresh_ui()
	user.prefs.ShowChoices(usr)
	return ..()