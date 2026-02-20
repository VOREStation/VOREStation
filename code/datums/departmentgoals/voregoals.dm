// Prey eaten
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/datum/goal/common/prey_eaten
	name = "Crew \"Morale\" Booster"

/datum/goal/common/prey_eaten/New()
	. = ..()
	goal_count = rand(10,30)
	goal_text = "Crew should engage in more \"Recreational\" activities, with and even inside each other! Have at least [goal_count] \"breaks\" together and find out just how close you can be as a crew!"

/datum/goal/common/prey_eaten/check_completion()
	current_count = GLOB.prey_eaten_roundstat
	. = ..()
