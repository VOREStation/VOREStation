/datum/goal/common
	category = GOAL_GENERAL


// Clean floors
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/datum/goal/common/clean_floors
	name = "Clean Dirty Floors"

/datum/goal/common/clean_floors/New()
	. = ..()
	goal_count = rand(3000,6000)
	goal_text = "Clean up [goal_count] dirty sections of floor, this station gets filthy!"
	RegisterSignal(SSdcs,COMSIG_GLOB_WASHED_FLOOR,PROC_REF(handle_mopped_floor))

/datum/goal/common/clean_floors/Destroy(force)
	UnregisterSignal(SSdcs,COMSIG_GLOB_WASHED_FLOOR)
	. = ..()

/datum/goal/common/clean_floors/proc/handle_mopped_floor(turf/source)
	SIGNAL_HANDLER
	current_count++


// Cardio
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/datum/goal/common/just_walk
	name = "Cardio Quota"

/datum/goal/common/just_walk/New()
	. = ..()
	goal_count = rand(10000,90000)
	goal_text = "Crew should take at least [goal_count] steps to ensure their cardio quotas are met."

/datum/goal/common/just_walk/check_completion()
	current_count = GLOB.step_taken_shift_roundstat
	. = ..()


// Grow plants
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/datum/goal/common/grow_plants
	name = "Grow Crops"

/datum/goal/common/grow_plants/New()
	. = ..()
	goal_count = rand(200,500)
	goal_text = "Crew should grow at least [goal_count] plants of any type to encourage hydroponics and kitchen crew productivity."

/datum/goal/common/grow_plants/check_completion()
	current_count = GLOB.seed_planted_shift_roundstat
	. = ..()


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


// Food cooked
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/datum/goal/common/food_prepared
	name = "Cook Food"

/datum/goal/common/food_prepared/New()
	. = ..()
	goal_count = rand(50,200)
	goal_text = "Get those friers ready, and cook up at least [goal_count] meals of any type for the crew!"
	RegisterSignal(SSdcs,COMSIG_GLOB_FOOD_PREPARED,PROC_REF(handle_food_prepared))

/datum/goal/common/food_prepared/Destroy(force)
	UnregisterSignal(SSdcs,COMSIG_GLOB_FOOD_PREPARED)
	. = ..()

/datum/goal/common/food_prepared/proc/handle_food_prepared(datum/recipe/source, obj/container, list/results)
	SIGNAL_HANDLER
	current_count++


// Trash searched
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/datum/goal/common/trashpiles
	name = "Clean Out Maintenance Trash"

/datum/goal/common/trashpiles/New()
	. = ..()
	goal_count = rand(40,200)
	goal_text = "Get that trash cleaned out of maintenance! Dig at least [goal_count] things out of the trashpiles in maintenance."
	RegisterSignal(SSdcs,COMSIG_GLOB_TRASHPILE_SEARCHED,PROC_REF(handle_trash_searched))

/datum/goal/common/trashpiles/Destroy(force)
	UnregisterSignal(SSdcs,COMSIG_GLOB_TRASHPILE_SEARCHED)
	. = ..()

/datum/goal/common/trashpiles/proc/handle_trash_searched(datum/source, mob/living/user, list/searched_by)
	SIGNAL_HANDLER
	current_count++
