
// We don't actually have a skills system, so return max skill for everything.
/mob/proc/get_skill_value(skill_path)
	return SKILL_EXPERT

// A generic way of modifying success probabilities via skill values. Higher factor means skills have more effect. fail_chance is the chance at SKILL_NONE.
/mob/proc/skill_fail_chance(skill_path, fail_chance, no_more_fail = SKILL_EXPERT, factor = 1) 
	var/points = get_skill_value(skill_path)
	if(points >= no_more_fail)
		return 0
	else
		return fail_chance * 2 ** (factor*(SKILL_BASIC - points))

	return FALSE // We don't actually have a skills system, so never fail.
