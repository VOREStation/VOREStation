// This holds the visual UIs, state, and logic for interacting with the skill system.
// It is intended to be able to be used in many different places.
// The actual storage for skills is just an assoc list, so that it is easy to store.

/datum/skill_manager
	var/client/user = null				// The client using this UI.
	var/read_only = FALSE				// If true, the window is not interactable.
	var/list/skill_list_ref = null		// Reference to the true list to display/modify.

/datum/skill_manager/New(client/new_user, list/new_skill_list_ref)
	..()
	if(istype(new_user))
		user = new_user
	else if(ismob(new_user))
		var/mob/M = new_user
		user = M.client
	else
		CRASH("skill_ui/New() suppled with non-client or non-mob argument '[new_user]'.")
		qdel(src)

	if(islist(new_skill_list_ref))
		skill_list_ref = new_skill_list_ref
	else
		CRASH("skill_ui/New() suppled with improper list reference argument '[new_skill_list_ref]'.")
		qdel(src)

/datum/skill_manager/Destroy()
	user = null
	skill_list_ref = null // Don't cut the list, since the list is shared with other things.
	return ..()

// Outputs a table with
/datum/skill_manager/proc/display_skill_table()
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
/datum/skill_manager/proc/display_skill_info(datum/category_item/skill/item, user)
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
			dat += "<span class='highlight'>[level.mechanics_desc]</span>"
		if(level.cost > 0)
			dat += "Costs <b>[level.cost]</b> skill points."
		dat += "<br>"

	var/datum/browser/popup = new(user, "skill_info_\ref[user]", item.name, 500, 800, src)
	popup.set_content(dat.Join("<br>"))
	popup.open()

// Safely returns numerical index of the skill in an assoc list.
// This is only intended for frontend UIs, use a different proc for in-game skill checks (since front-end can change constantly).
/datum/skill_manager/proc/get_skill_level(skill_id)
	var/answer = skill_list_ref[skill_id]
	if(isnull(answer))
		return 1 // Because Byond is dumb and counts from 1.
	return answer

// Refreshes the window displaying this.
// Overrided for subtypes which use a different window (like character setup).
/datum/skill_manager/proc/refresh_ui()
	return

/datum/skill_manager/character_setup/refresh_ui()
	return

/datum/skill_manager/Topic(var/href,var/list/href_list)
	if(..())
		return 1
	var/mob/user = usr
	world << "wew [href]!"

	if(href_list["info"])
		var/datum/category_item/skill/item = locate(href_list["info"])
		display_skill_info(item, user)
		return TOPIC_HANDLED

	if(href_list["chosen_skill"])
		if(read_only) // Protect against bugs and href exploits.
			return TOPIC_HANDLED

		var/datum/category_item/skill/item = locate(href_list["chosen_skill"])
		var/chosen_level = text2num(href_list["chosen_level"])

		if(item && !isnull(chosen_level))
			world << "[item.name] | [chosen_level]"
			skill_list_ref[item.id] = chosen_level

		refresh_ui()
		// If they clicked the button in the info window, refresh that too.
		if(href_list["refresh_info"])
			display_skill_info(item, user)
		return TOPIC_REFRESH

	return ..()

/*
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
*/

/*
/datum/category_item/player_setup_item/Topic(var/href,var/list/href_list)
	if(..())
		return 1
	var/mob/pref_mob = preference_mob()
	if(!pref_mob || !pref_mob.client)
		return 1

	. = OnTopic(href, href_list, usr)
	if(. & TOPIC_UPDATE_PREVIEW)
		pref_mob.client.prefs.preview_icon = null
	if(. & TOPIC_REFRESH)
		pref_mob.client.prefs.ShowChoices(usr)

/datum/category_item/player_setup_item/CanUseTopic(var/mob/user)
	return 1
*/