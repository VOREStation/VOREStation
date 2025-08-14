/// Generic attack logging
/proc/log_attack(text, list/data)
	logger.Log(LOG_CATEGORY_ATTACK, text, data)

/**
 * Log a combat message in the attack log
 *
 * Arguments:
 * * atom/user - argument is the actor performing the action
 * * atom/target - argument is the target of the action
 * * what_done - is a verb describing the action (e.g. punched, throwed, kicked, etc.)
 * * atom/object - is a tool with which the action was made (usually an item)
 * * addition - is any additional text, which will be appended to the rest of the log line
 */
/proc/log_combat(atom/user, atom/target, what_done, atom/object=null, addition=null)
	var/ssource = key_name(user)
	var/starget = key_name(target)

	var/mob/living/living_target = target
	var/hp = istype(living_target) ? " (NEWHP: [living_target.health]) " : ""

	var/sobject = ""
	if(object)
		sobject = " with [object]"
	var/saddition = ""
	if(addition)
		saddition = " [addition]"

	var/postfix = "[sobject][saddition][hp]"

	var/message = "[what_done] [starget][postfix]"
	user.log_message(message, LOG_ATTACK, color="red")

	if(user != target)
		var/reverse_message = "was [what_done] by [ssource][postfix]"
		target.log_message(reverse_message, LOG_VICTIM, color="orange", log_globally=FALSE)

/// Log for vore interactions
/proc/log_vore(text, list/data)
	logger.Log(LOG_CATEGORY_VORE, text, data)
