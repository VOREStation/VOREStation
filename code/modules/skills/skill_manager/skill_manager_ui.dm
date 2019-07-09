// Contains the code for the UI and the Topic() handling for the general skill manager.
// More specific managers might override some of this.

/datum/skill_manager/proc/make_window()
	var/list/dat = list()
	dat += display_skill_setup_ui()

	var/datum/browser/popup = new(user, main_window_id, "Skills", 800, 500, src)
	popup.set_content(dat.Join("<br>"))
	popup.open()

/datum/skill_manager/proc/close_all_windows()
	// Close all the windows we can.
	user << browse(null, "window=[main_window_id]")
	user << browse(null, "window=[skill_info_window_id]")
	user << browse(null, "window=[skill_template_window_id]")
	user << browse(null, "window=[skill_template_preview_window_id]")

/datum/skill_manager/proc/display_skill_setup_ui()
	. = list()
//	. += "<b>Select your Skills</b><br>"
	. += "[user.prefs.real_name] - <b>[get_fluff_title()]</b><br>"
	. += skill_point_total_content()
	. += href(src, list("premade_template" = 1), "View Premade Templates")

	. += skill_table_content(skill_list_ref)

	. = jointext(.,null)

/datum/skill_manager/proc/skill_point_total_content()
	var/total = total_spent_points()
	var/max = get_max_point_budget()
	if(total > max) // Makes it obvious if the user goes over budget.
		return "Current skill points: <b>[span("bad", total)]/[max]</b><br>"
	return "Current skill points: <b>[total]/[max]</b><br>"

// Outputs a table with all the skills, highlighted by the inputted skill list, and buttons to modify the referenced list.
/datum/skill_manager/proc/skill_table_content(list/skills, local_read_only)
	. = list()
	. += "<center>"
	. += "<table style = width:90%>"
	for(var/datum/category_group/skill/group in GLOB.skill_collection.categories)
		. += "<tr>"
		. += "<th colspan = 6><b>[group.name]</b></th>"
		. += "</tr>"

		for(var/datum/category_item/skill/item in group.items)
			. += "<tr>"
			var/invested = get_points_in_skill(item.id)
			var/displayed_skill_name = "[item.name][invested > 0 ? " ([invested])":""]"
			. += "<th style='text-align:center'>[href(src, list("info" = item, "read_only" = local_read_only), displayed_skill_name)]</th>"

			var/i = 1
			for(var/datum/skill_level/level in item.levels)
				var/displayed_name = level.name
				if(level.cost > 0)
					displayed_name = "[displayed_name] ([level.cost])"

				var/cell_content = null
				if(get_skill_level(skills, item.id) == i)
					cell_content = "<span class='linkOn'>[displayed_name]</span>"
				else if(!can_write_skill_level(item.id, i) || local_read_only)
					cell_content = displayed_name
				else
					cell_content = href(src, list("chosen_skill" = item, "chosen_level" = i), displayed_name)

				. += "<td style='text-align:center'>[cell_content]</td>"
				i++

			. += "</tr>"
	. += "</table>"
	. += "</center>"
	. = jointext(.,null)


// Opens a standalone window describing what the skill and all its levels do.
// Also provides an alternative means of selecting the desired skill level, if allowed to do so.
/datum/skill_manager/proc/display_skill_info(datum/category_item/skill/item, user, local_read_only)
	var/list/dat = list()
	dat += "<i>[item.flavor_desc]</i>"
	dat += "<b>[item.govern_desc]</b>"
	dat += item.typical_desc

	dat += "<hr>"
	var/i = 1
	for(var/datum/skill_level/level in item.levels)
		if(get_skill_level(skill_list_ref, item.id) == i)
			dat += "<span class='linkOn'>[level.name]</span>"
		else if(!can_write_skill_level(item.id, i) || local_read_only)
			dat += "<b>[level.name]</b>"
		else
			dat += href(src, list("chosen_skill" = item, "chosen_level" = i, "refresh_info" = 1), level.name)
		i++

		dat += "<i>[level.flavor_desc]</i>"
		if(level.mechanics_desc && config.mechanical_skill_system) // No point showing mechanical effects if they are disabled in the config.
			dat += "<span class='highlight'>[level.mechanics_desc]</span>"
		if(level.cost > 0)
			dat += "Costs <b>[level.cost]</b> skill points."
		dat += "<br>"

	var/datum/browser/popup = new(user, skill_info_window_id, item.name, 500, 800, src)
	popup.set_content(dat.Join("<br>"))
	popup.open()

// Opens a standalone window for viewing templates for recommendations for each role.
// The view can choose to overwrite their current skills with the skill template, if desired.
/datum/skill_manager/proc/display_skill_template_window()
	var/list/dat = list()
	dat += "Below is a list of premade skill configurations, tailored to specific roles available.<br>"
	dat += "To view one, click a template from below. A new window showing all the skills in the template \
	will open. If you wish, you can overwrite your current skill configuration with the template.<br>"
	dat += "If you join the round without setting any skills, as a role listed below, the appropiate \
	skill template will be copied over to your character for that round.<br>"
	dat += "<hr>"
	dat += "<center>"
	for(var/datum/job/J in job_master.occupations)
		if(LAZYLEN(J.skill_templates)) // Skill templates are lists of lists.
			for(var/template_name in J.skill_templates)
				var/list/template = J.skill_templates[template_name]
				if(LAZYLEN(template))
					var/packaged_template = json_encode(template) // Because apparently the href helper's list2params cannot handle nested lists.
					dat += href(src, list("preview_template" = 1, "template_skills" = packaged_template, "template_name" = template_name), template_name)
					dat += "<br>"
	dat += "</center>"

	var/datum/browser/popup = new(user, skill_template_window_id, "Skill Templates", 500, 800, src)
	popup.set_content(dat.Join(null))
	popup.open()

/datum/skill_manager/Topic(var/href,var/list/href_list)
	if(..())
		return 1
	world << "wew [href]!"

	// Open the skill information window.
	if(href_list["info"])
		var/datum/category_item/skill/item = locate(href_list["info"])
		display_skill_info(item, usr, href_list["read_only"])
		return TOPIC_HANDLED

	// Open the premade template window.
	if(href_list["premade_template"])
		display_skill_template_window()
		return TOPIC_HANDLED

	// View a preview of a specific premade template.
	if(href_list["preview_template"])
		var/list/unpackaged_skills = json_decode(href_list["template_skills"])
		var/list/dat = list()
		dat += href(src, list("copy_template_to_skills" = 1, "template_skills" = json_encode(unpackaged_skills)), "Copy to Skills")
		dat += skill_table_content(unpackaged_skills, TRUE)

		var/datum/browser/popup = new(user, skill_template_preview_window_id, "Skill Template Preview - [href_list["template_name"]]", 800, 500, src)
		popup.set_content(dat.Join(null))
		popup.open()
		return TOPIC_HANDLED

	// Overwrite current skills with the premade template.
	if(href_list["copy_template_to_skills"])
		if(read_only) // Protect against bugs and href exploits.
			return TOPIC_HANDLED

		if(alert(user, "This will overwrite your current skill selection with the template you are trying \
		to copy, meaning you will lose your current skill configuration. Are you sure you want to do this?", "Overwrite Warning", "No", "Yes") == "No")
			return TOPIC_HANDLED

		var/list/unpackaged_skills = json_decode(href_list["template_skills"])
		for(var/missing_skill in skill_list_ref)
			if(!(missing_skill in unpackaged_skills))
				unpackaged_skills[missing_skill] = SKILL_LEVEL_ZERO

		for(var/unpackaged_skill in unpackaged_skills)
			var/unpackaged_level = unpackaged_skills[unpackaged_skill]
			if(!can_write_skill_level(unpackaged_skill, unpackaged_level))
				to_chat(user, span("warning", "One or more of the skills inside that skill template was not allowed to be applied to your current skills."))
				return TOPIC_HANDLED
		skill_list_ref = unpackaged_skills.Copy()
		refresh_ui()
		return TOPIC_REFRESH

	// Modify a specific skill.
	if(href_list["chosen_skill"])
		if(read_only) // Protect against bugs and href exploits.
			return TOPIC_HANDLED

		var/datum/category_item/skill/item = locate(href_list["chosen_skill"])
		var/chosen_level = text2num(href_list["chosen_level"])

		if(item && !isnull(chosen_level) && can_write_skill_level(item.id, chosen_level))
			write_skill_level(item.id, chosen_level)

		refresh_ui()
		// If they clicked the button in the info window, refresh that too.
		if(href_list["refresh_info"])
			display_skill_info(item, usr)
		return TOPIC_REFRESH

	return ..()
