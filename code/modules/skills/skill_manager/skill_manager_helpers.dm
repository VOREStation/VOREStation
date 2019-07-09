
// Returns TRUE if everything is fine.
// Things might not be fine if, for example, the player can't afford all the skills chosen.
// Note that invalid setups are allowed to be saved, its just that they will not be able to join the round.
/datum/skill_manager/proc/is_valid()
//	return TRUE //TODO
	return total_spent_points() <= get_max_point_budget()

// Switches the list.
/datum/skill_manager/proc/change_skill_list(list/new_skill_list_ref)
	skill_list_ref = new_skill_list_ref

// Safely returns numerical index of the skill in an assoc list.
// This is only intended for frontend UIs, use a different proc for in-game skill checks (since front-end can change constantly).
/datum/skill_manager/proc/get_skill_level(list/skill_list, skill_id)
	var/answer = skill_list[skill_id]
	if(isnull(answer))
		return SKILL_LEVEL_ZERO
	return answer

/datum/skill_manager/proc/get_points_in_skill(skill_id)
	var/datum/category_item/skill/item = GLOB.skill_collection.skills_by_id[skill_id]
	if(!item) // In case the skill got removed or something.
		return 0
	var/level_index = get_skill_level(skill_list_ref, skill_id)
	var/datum/skill_level/level = item.levels[level_index]
	return level.cost

/datum/skill_manager/proc/total_spent_points()
	. = 0
	for(var/id in skill_list_ref)
		. += get_points_in_skill(id)

/datum/skill_manager/proc/get_name_in_skill(skill_id)
	var/datum/category_item/skill/item = GLOB.skill_collection.skills_by_id[skill_id]
	if(!item) // In case the skill got removed or something.
		return "ERROR"
	var/level_index = get_skill_level(skill_list_ref, skill_id)
	var/datum/skill_level/level = item.levels[level_index]
	return level.name

// Override this for getting the age.
/datum/skill_manager/proc/get_age()
	return -1

// Override this for getting the species.
// Note that it needs to return the instantiated datum, not the species string. Use the global all_species list to get it.
/datum/skill_manager/proc/get_species()
	return null

// Override this for determining if they're a robot, and if so, what kind.
/datum/skill_manager/proc/get_FBP_type()
	return null

// Uses part of an ellipse to calculate the 'curve' of skill point distribution along various ages.
/datum/skill_manager/proc/calculate_ellipse(current_age, lowest_age, highest_age, minimum_points, maximum_points)
	// Makes sure current_age doesn't fall off the ellipse. This also makes it so highest_age can be before the max age of the species, without any issue.
	current_age = between(lowest_age, current_age, highest_age)
	return FLOOR(minimum_points + (maximum_points - minimum_points) * sqrt( (1 - ((highest_age -  current_age) / (highest_age - lowest_age)) ** 2)), 1)

/datum/skill_manager/proc/get_max_point_budget(current_age = get_age(), robot_type = get_FBP_type(), datum/species/S = get_species())
	var/lowest_age = null						// Lowest age on curve.
	var/highest_age = null						// Highest age on curve.
	var/minimum_points = SKILL_POINT_FLOOR		// How many skill points when equal to a.
	var/maximum_points = SKILL_POINT_CEILING	// How many skill points when equal to b.

	// Posibrains and drones have their own curves. MMIs have the same curves as their species.
	if(robot_type in list(PREF_FBP_POSI, PREF_FBP_SOFTWARE))
		// Sadly they're hardcoded here.
		lowest_age = 1 // Both of them share this.
		switch(robot_type)
			if(PREF_FBP_POSI)
				// Posibrains learn mostly like humans, just quicker.
				// It might be neat to add another curve going backwards to simulate posi lore better, somehow.
				highest_age = 80 // TODO
			if(PREF_FBP_SOFTWARE)
				// Drones are literally software, so their initial points are high, but scales poorly.
				// In the future, we could have different scales for different classes of drones.
				minimum_points = 75 // TODO
				highest_age = MAX_AGE_DRONE // TODO

	// At this point, they're not a robot (or they are, but they're an MMI), so check for species.
	else if(istype(S))
		lowest_age = S.skill_curve_lowest_age
		highest_age = S.skill_curve_highest_age
		minimum_points = S.skill_curve_minimum_points
		maximum_points = S.skill_curve_maximum_points

	// Otherwise they're something weird, like a simple mob, and the curve can't handle them, so just give them the max points.
	else
		return SKILL_POINT_CEILING

	return calculate_ellipse(current_age, lowest_age, highest_age, minimum_points, maximum_points)

// Generates a comma seperated values file containing the skill point distribution among every species and robot type, at every age.
// This file can then be imported into a program that can make charts with the file, to easily visualize the various skill curves.
/datum/skill_manager/proc/generate_skill_curve_csv_file()
	var/warning_msg = "This will create a .csv file that iterates over every species, \
		and writes down how many skill points a species will have at a specific age.\n\
		Generating the file may cause lag.\n\
		Are you sure you want to start?"

	if(alert(usr, warning_msg, "Lag Warning", "No", "Yes") == "No")
		return

	log_and_message_admins("is now generating a .csv file for the skill curves of every species. Expect significant lag until generation finishes.")

	// First, we need to know the max possible age for all species.
	to_chat(usr, "\[1/3\] - Calculating required amount of lines in file.")
	var/absolute_max_age = 0
	for(var/a in all_species)
		var/datum/species/S = all_species[a]
		if(S.spawn_flags &= SPECIES_IS_RESTRICTED)
			continue
		// Species that can use MMIs will live longer.
		if(!S.flags & NO_SCAN && S.max_age + MMI_LIFE_EXTENSION > absolute_max_age)
			absolute_max_age = S.max_age
		else if(S.max_age > absolute_max_age)
			absolute_max_age = S.max_age

	CHECK_TICK
	to_chat(usr, "Going to write [absolute_max_age] lines in file.")

	// To help preserve the string tree, we're gonna use a two-dimensional list to avoid polluting the string tree as much.
	var/lines[absolute_max_age+1]

	to_chat(usr, "\[2/3\] - Writing title row.")
	var/list/title_row = list("Character Age")

	// Fill out the title row with the name of each species.
	for(var/a in all_species)
		var/datum/species/S = all_species[a]
		if(S.spawn_flags &= SPECIES_IS_RESTRICTED)
			continue
		title_row += S.name

	// Synthetics are added manually, due to not being a species.
	// The order DOES matter, because they are columns.
	title_row += "Positronic"
	title_row += "Drone"

	// Title row is done. Now it gets added as the first line.
	lines[1] = title_row

	to_chat(usr, "\[3/3\] - Writing other rows.")
	for(var/i = 1 to absolute_max_age)
		// Add current iteration to the age column.
		var/list/current_row = list("[i]")

		// All species.
		for(var/a in all_species)
			var/datum/species/S = all_species[a]

			if(S.spawn_flags &= SPECIES_IS_RESTRICTED)
				continue

			var/modified_max_age = S.max_age
			if(!S.flags & NO_SCAN)
				modified_max_age += MMI_LIFE_EXTENSION

			if(i < S.min_age || i > modified_max_age)
				// Some spreadsheets' charts will not show a line if the data is 'empty' instead of 0, so this is an empty string to accomodate that.
				// Some others just treat it as 0.
				current_row += ""
			else
				current_row += "[get_max_point_budget(i, 0, S)]"
			CHECK_TICK

		// Posibrain column.
		if(i > MAX_AGE_POSI)
			current_row += ""
		else
			current_row += "[get_max_point_budget(i, PREF_FBP_POSI, 0)]"

		// Drone column.
		if(i > MAX_AGE_DRONE)
			current_row += ""
		else
			current_row += "[get_max_point_budget(i, PREF_FBP_SOFTWARE, 0)]"

		// Row is done, put it in the line list and move on to the next row.
		lines[i+1] = current_row
		if(i % 50 == 0)
			to_chat(usr, "[i]/[absolute_max_age] rows finished.")
		CHECK_TICK

	// List of lists is finished. Now to convert it into csv format.
	// Doing it like this will vastly reduce the amount of useless strings created, which should help avoid bloating BYOND's string tree excessively.
	// It's also much faster this way, taking a few seconds compared to a few minutes.
	var/list/converted_lines = list()
	for(var/list/line in lines)
		converted_lines += line.Join(",")
	var/csv = converted_lines.Join("\n")

	to_chat(usr, "Finished. Look for <b>skill_curve.csv</b> inside your BYOND cache folder.")
	usr << browse(csv, "window=csv;file=skill_curve.csv;display=0")

/client/proc/generate_skill_curve_csv_file()
	if(!check_rights(R_ADMIN|R_DEBUG))
		return
	var/datum/skill_manager/manager = new(src, list())
	manager.generate_skill_curve_csv_file()
	qdel(manager)

/*
/datum/skill_manager/proc/get_discount_modifier(skill_group, point_cap, max_discount_factor)
	var/
	for(var/id in skill_list_ref)
		var/datum/category_item/skill/item = GLOB.skill_collection.skills_by_id[skill_id]
		if(!item)
			continue

	return X * (1 - (X / point_cap) * max_discount_factor)
*/
/*
Skill specialization discount formula;
	point_cap = 100
	max_discount_factor = 0.5
	X = point total inside specific group
	Y = Discount factor (Capped at max_discount_factor)

	discount_modifier = 1 - (X / point_cap) * max_discount_factor
	true_point_cost = X * discount_modifier
*/
/*
// Returns someone's max amount of points.
/datum/skill_manager/proc/calculate_max_points(age, min_age, max_age, point_floor, multiplier)
	var/A = max(age - min_age, 0)
	var/B = max(max_age - min_age, 0)
	var/scale = min(sqrt(A / B), 1) // Scale cannot exceed 1.
	return FLOOR( (scale + base_points) * multiplier )
*/

// ROUNDDOWN(((MIN(SQRT( MAX(age - min_age,0) / MAX(max_age-min_age, 0)), 1) + base_points ) * multiplier ) )

// Returns the most expensive skill level rank.
// Used for flavor, and is only shown to the user.
/datum/skill_manager/proc/get_fluff_title()
	var/highest_investment = 0
	var/highest_skill = null

	for(var/id in skill_list_ref)
		var/cost = get_points_in_skill(id)
		if(cost > highest_investment)
			highest_skill = id
			highest_investment = cost

	if(highest_skill)
		return get_name_in_skill(highest_skill)
	return "Unremarkable"

// Refreshes the window displaying this.
// Overrided for subtypes which use a different window (like character setup).
/datum/skill_manager/proc/refresh_ui()
	return

/datum/skill_manager/proc/can_write_skill_level(skill_id, new_skill_level)
	return !read_only

// Modifies the referenced list of skills.
// Can be overrided to do additional things after the fact.
/datum/skill_manager/proc/write_skill_level(skill_id, new_skill_level)
	if(read_only)
		return FALSE
	skill_list_ref[skill_id] = new_skill_level
	return TRUE