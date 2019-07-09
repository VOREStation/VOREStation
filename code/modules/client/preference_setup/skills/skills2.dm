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

// Safely returns numerical index of the skill in preferences.
// This is only intended for character setup, use a different proc for in-game skill checks.
/datum/category_item/player_setup_item/skills/proc/get_skill_level(skill_id)
	var/answer = pref.skill_list[skill_id]
	if(isnull(answer))
		return 1 // Because Byond is dumb and counts from 1.
	return answer

/datum/category_item/player_setup_item/skills/proc/total_spent_points()
	. = 0
	for(var/id in pref.skill_list)
		var/datum/category_item/skill/item = GLOB.skill_collection.skills_by_id[id]
		if(!item) // In case the skill gets removed or something.
			continue
		var/index = pref.skill_list[id]
		var/datum/skill_level/level = item.levels[index]
		. += level.cost

/datum/category_item/player_setup_item/skills/content()
	. = list()
	. += "<b>Select your Skills</b><br>"
	. += "Current skill points: <b>[total_spent_points()]/TODO</b><br>"
	. += href(src, list("premade_template" = 1), "Select Premade Template (TODO)")

	. += "<table style = width:90%>"
	for(var/datum/category_group/skill/group in GLOB.skill_collection.categories)
		. += "<tr>"
		. += "<th colspan = 6><b>[group.name]</b></th>"
		. += "</tr>"

		for(var/datum/category_item/skill/item in group.items)
			. += "<tr>"
			. += "<th>[href(src, list("info" = item), item.name)]</th>"

			var/i = 1
			for(var/datum/skill_level/level in item.levels)
				var/displayed_name = level.name
				if(level.cost > 0)
					displayed_name = "[displayed_name] ([level.cost])"

				if(get_skill_level(item.id) == i)
					. += "<td><span class='linkOn'>[displayed_name]</span></td>"
				else
					. += "<td>[href(src, list("chosen_skill" = item, "chosen_level" = i), displayed_name)]</td>"
				i++

			. += "</tr>"
	. += "</table>"
	. = jointext(.,null)

// Opens a window describing what the skill and all its levels do.
// Also provides an alternative means of selecting the desired skill level.
/datum/category_item/player_setup_item/skills/proc/display_skill_info(datum/category_item/skill/item, user)
	var/list/dat = list()
	dat += "<i>[item.flavor_desc]</i>"
	dat += "<b>[item.govern_desc]</b>"
	dat += item.typical_desc

	dat += "<hr>"
	var/i = 1
	for(var/datum/skill_level/level in item.levels)
		if(get_skill_level(item.id) == i)
			dat += "<span class='linkOn'>[level.name]</span>"
		else
			dat += href(src, list("chosen_skill" = item, "chosen_level" = i, "refresh_info" = 1), level.name)
		i++

		dat += "<i>[level.flavor_desc]</i>"
		if(level.mechanics_desc && config.mechanical_skill_system) // No point showing mechanical effects if they are disabled in the config.
			dat += "<font color=#FFFF00>[level.mechanics_desc]</font>"
		if(level.cost > 0)
			dat += "Costs <b>[level.cost]</b> skill points."
		dat += "<br>"

	var/datum/browser/popup = new(user, "skill_info_\ref[user]", item.name, 500, 800, src)
	popup.set_content(dat.Join("<br>"))
	popup.open()

/datum/category_item/player_setup_item/skills/OnTopic(href, href_list, user)
	if(href_list["info"])
		var/datum/category_item/skill/item = locate(href_list["info"])
		display_skill_info(item, user)
		return TOPIC_HANDLED

	if(href_list["chosen_skill"])
		var/datum/category_item/skill/item = locate(href_list["chosen_skill"])
		var/chosen_level = text2num(href_list["chosen_level"])

		if(item && !isnull(chosen_level))
			world << "[item.name] | [chosen_level]"
			pref.skill_list[item.id] = chosen_level

		// If they clicked the button in the info window, refresh that too.
		if(href_list["refresh_info"])
			display_skill_info(item, user)
		return TOPIC_REFRESH

	return ..()

/*
	else if(href_list["setskill"])
		var/datum/skill/S = locate(href_list["setskill"])
		var/value = text2num(href_list["newvalue"])
		pref.skills[S.ID] = value
		pref.CalculateSkillPoints()
		return TOPIC_REFRESH
*/