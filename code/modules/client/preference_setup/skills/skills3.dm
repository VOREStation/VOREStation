/datum/category_item/player_setup_item/skills
	name = "Skills"
	sort_order = 1

// 'skill_list' is the new skill system save format, to avoid any potential conflicts from overwriting 'skills' from the old system.
/datum/category_item/player_setup_item/skills/load_character(var/savefile/S)
	S["skill_list"]				>> pref.skill_list

/datum/category_item/player_setup_item/skills/save_character(var/savefile/S)
	S["skill_list"]				<< pref.skill_list

/datum/category_item/player_setup_item/skills/sanitize_character()
	if(!pref.skill_list)
		pref.skill_list = list()

	// Lazyload the manager object.
	make_skill_manager(pref.skill_list)

	// Clean up any skills that stop existing.
	for(var/skill_id in pref.skill_list)
		var/datum/category_item/skill/item = GLOB.skill_collection.skills_by_id[skill_id]
		if(!item)
			pref.skill_list -= skill_id
			to_chat(pref.client, span("warning", "The skill '[skill_id]' no longer exists and has been removed from your skill configuration."))

/datum/category_item/player_setup_item/skills/proc/make_skill_manager(new_skill_list)
	if(!pref.skill_manager)
		pref.skill_manager = new(pref.client, new_skill_list)
	else
		pref.skill_manager.change_skill_list(new_skill_list) // In case we swapped characters or something.

/datum/category_item/player_setup_item/skills/content(mob/user)
	. = list()
	. += pref.skill_manager.display_skill_setup_ui()
	. = jointext(.,null)

