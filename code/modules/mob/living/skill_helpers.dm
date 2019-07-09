// Helper procs for interacting with the skill system.
// The actual skill list is held inside the mob's mind (if one exists).

// Gets the level of skill a mob has.
// Remember, the lowest value is 1 (aka SKILL_LEVEL_ZERO) because of BYOND lists.
/mob/living/proc/get_skill_level(skill_id)
	if(!mind)
		return SKILL_LEVEL_ZERO
	var/level = mind.skills[skill_id]
	return level ? level : SKILL_LEVEL_ZERO

// Returns the difference in skill between this mob and another.
// E.g. if someone has level 2, and the other person has level 4, it will return -2.
/mob/living/proc/get_skill_difference(skill_id, mob/living/other)
	if(!config.mechanical_skill_system)
		return 0 // Everyone is equal if the skill system is off.
	return get_skill_level(skill_id) - other.get_skill_level(skill_id)

// Basic proc to do 'Does mob have X skill at Y level or higher?'.
/mob/living/proc/skill_check(skill_id, required_skill_level)
	if(!config.mechanical_skill_system)
		return TRUE // Always succeed if the skill system is off.
	return get_skill_level(skill_id) >= required_skill_level

// Skill checks all skills in a list. All checks must succeed for this to pass.
// Requires a assoc list in the 'skill id = number' format.
/mob/living/proc/check_all_skills(list/skills)
	for(var/skill_id in skills)
		if(!skill_check(skill_id, skills[skill_id]))
			return FALSE
	return TRUE

// Similar to above, but only needs one of the skills to succeed.
/mob/living/proc/check_any_skills(list/skills)
	for(var/skill_id in skills)
		if(skill_check(skill_id, skills[skill_id]))
			return TRUE
	return FALSE
