// This holds the visual UIs for interacting with the skill system.
// It is intended to be able to be used in many different places.

/datum/skill_ui
	var/list/skill_buffer = list()		// Temporary storage for skill changes, if applicable.
	var/client/user = null				// The client using this UI.
	var/read_only = FALSE				// If true, the window is not interactable.

/datum/skill_ui/New(client/new_user)
	..()
	if(istype(new_user))
		user = new_user
	else if(ismob(new_user))
		var/mob/M = new_user
		user = M.client
	else
		CRASH("skill_ui/New() suppled with non-client or non-mob argument '[new_user]'.")
		qdel(src)

/datum/skill_ui/Destroy()
	user = null
	skill_buffer.Cut()
	return ..()

// Writes the buffer to somewhere more permanent.
/datum/skill_ui/proc/save_skills(list/skills_to_save)
	return

// Loads skills into the buffer.
/datum/skill_ui/proc/load_skills()
	return

// Use this subtype for character setup.
// It will target the user's preferences object.
/datum/skill_ui/character_setup/save_skills(list/skills_to_save)
	user.prefs.skill_list = skills_to_save

/datum/skill_ui/character_setup/load_skills()
	return user.prefs.skill_list


// Outputs a table with
/datum/skill_ui/proc/main_content()
	. = list()
	. += "<b>Select your Skills</b><br>"
	. += "Current skill points: <b>TODO/TODO</b><br>"
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
/datum/skill_ui/proc/display_skill_info(datum/category_item/skill/item, user)
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

// Safely returns numerical index of the skill in an assoc list.
// This is only intended for frontend UIs, use a different proc for in-game skill checks.
/datum/skill_ui/proc/get_skill_level(skill_id)
	var/answer = skill_buffer[skill_id]
	if(isnull(answer))
		return 1 // Because Byond is dumb and counts from 1.
	return answer

/datum/skill_ui/proc/OnTopic(href, href_list, user)
	if(href_list["info"])
		var/datum/category_item/skill/item = locate(href_list["info"])
		display_skill_info(item, user)
		return TOPIC_HANDLED

	if(href_list["chosen_skill"])
		var/datum/category_item/skill/item = locate(href_list["chosen_skill"])
		var/chosen_level = text2num(href_list["chosen_level"])

		if(item && !isnull(chosen_level))
			world << "[item.name] | [chosen_level]"
			skill_buffer[item.id] = chosen_level
		//	pref.skill_list[item.id] = chosen_level

		// If they clicked the button in the info window, refresh that too.
		if(href_list["refresh_info"])
			display_skill_info(item, user)
		return TOPIC_REFRESH

	return ..()