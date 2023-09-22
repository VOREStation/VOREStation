// Handles AI while stunned or otherwise disabled.

/datum/ai_holder
	var/respect_confusion = TRUE // If false, the mob won't wander around recklessly.

// If our holder is able to do anything.
/datum/ai_holder/proc/can_act()
	if(!holder) // Holder missing.
		manage_processing(0)
		return FALSE
	if(holder.stat) // Dead or unconscious.
		ai_log("can_act() : Stat was non-zero ([holder.stat]).", AI_LOG_TRACE)
		return FALSE
	if(holder.incapacitated(INCAPACITATION_DISABLED)) // Stunned in some form.
		ai_log("can_act() : Incapacited.", AI_LOG_TRACE)
		return FALSE
	if(holder.instasis()) // In a stasis field.
		ai_log("can_act() : In a stasis field.", AI_LOG_TRACE)
		return FALSE
	if(!belly_attack)
		if(isbelly(holder.loc))
			return FALSE
	return TRUE

// Test if we should switch to STANCE_DISABLE.
// Currently tests for death, stuns, and confusion.
/datum/ai_holder/proc/is_disabled()
	if(!can_act())
		return TRUE
	if(is_confused())
		return TRUE
	return FALSE

/datum/ai_holder/proc/is_confused()
	return holder.confused > 0 && respect_confusion

// Called by the main loop.
/datum/ai_holder/proc/handle_disabled()
	if(!can_act())
		return // Just sit there and take it.
	else if(is_confused())
		dangerous_wander() // Let's bump into allies and hit them.

// Similar to normal wander, but will walk into tiles that are harmful, and attack anything they bump into, including allies.
// Occurs when confused.
/datum/ai_holder/proc/dangerous_wander()
	ai_log("dangerous_wander() : Entered.", AI_LOG_DEBUG)
	if(isturf(holder.loc) && can_act())
		// Test if we should refrain from falling/attacking allies, if we're smart enough to realize that.
		if(intelligence_level > AI_NORMAL)
			var/unsafe = FALSE

			tile_test:
				for(var/dir_tested in cardinal)
					var/turf/turf_tested = get_step(holder, dir_tested)
					// Look for unsafe tiles.
					if(!turf_tested.is_safe_to_enter(holder))
						unsafe = TRUE
						break

					// Look for allies.
					for(var/mob/living/L in turf_tested)
						if(holder.IIsAlly(L))
							unsafe = TRUE
							break tile_test


			if(unsafe)
				ai_log("dangerous_wander() : Staying still due to risk of harm to self or allies.", AI_LOG_TRACE)
				return // Just stay still.

		var/moving_to = 0
		moving_to = pick(cardinal)
		var/turf/T = get_step(holder, moving_to)

		var/mob/living/L = locate() in T
		if(L)
			// Attack whoever's on the tile. Even if it's an ally.
			ai_log("dangerous_wander() : Going to confuse-attack [L].", AI_LOG_TRACE)
			melee_attack(L)
		else
			// Move to the tile. Even if it's unsafe.
			ai_log("dangerous_wander() : Going to confuse-walk to [T] ([T.x],[T.y],[T.z]).", AI_LOG_TRACE)
			holder.IMove(T, safety = FALSE)
	ai_log("dangerous_wander() : Exited.", AI_LOG_DEBUG)

/*
// Wanders randomly in cardinal directions.
/datum/ai_holder/proc/handle_wander_movement()
	ai_log("handle_wander_movement() : Entered.", AI_LOG_DEBUG)
	if(isturf(holder.loc) && can_act())
		wander_delay--
		if(wander_delay <= 0)
			if(!wander_when_pulled && holder.pulledby)
				ai_log("handle_wander_movement() : Being pulled and cannot wander. Exiting.", AI_LOG_DEBUG)
				return

			var/moving_to = 0 // Apparently this is required or it always picks 4, according to the previous developer for simplemob AI.
			moving_to = pick(cardinal)
			holder.set_dir(moving_to)
			holder.IMove(get_step(holder,moving_to))
			wander_delay = base_wander_delay
	ai_log("handle_wander_movement() : Exited.", AI_LOG_DEBUG)
*/
