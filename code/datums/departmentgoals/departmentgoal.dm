/datum/goal
	var/name = "goal"
	var/category = null
	var/goal_text = "Do nothing! Congratulations."
	var/enabled = TRUE // Allows easy disabling downstream

	var/current_count = 0
	var/goal_count = 1
	VAR_PRIVATE/completed = FALSE

/// Handles midround announcement, the override should pass TRUE to the parent call if the goal completes during the round!
/datum/goal/proc/check_completion()
	SHOULD_CALL_PARENT(TRUE)
	if(current_count >= goal_count && !completed)
		command_announcement.Announce("The [category] \"[name]\" has been completed, congratulations!", "Central Command")
		completed = TRUE
	return completed

/datum/goal/proc/get_completed() // Faster, does not recalculate
	return completed

/datum/goal/proc/progress_string()
	return span_info("Completion: [span_bold( "[FLOOR((current_count / goal_count) * 100,1)]" )]%")
