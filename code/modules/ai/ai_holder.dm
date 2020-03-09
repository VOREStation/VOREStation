// This is a datum-based artificial intelligence for simple mobs (and possibly others) to use.
// The neat thing with having this here instead of on the mob is that it is independant of Life(), and that different mobs
// can use a more or less complex AI by giving it a different datum.

/mob/living
	var/datum/ai_holder/ai_holder = null
	var/ai_holder_type = null // Which ai_holder datum to give to the mob when initialized. If null, nothing happens.

/mob/living/Initialize()
	if(ai_holder_type)
		ai_holder = new ai_holder_type(src)
	return ..()

/mob/living/Destroy()
	QDEL_NULL(ai_holder)
	return ..()

/datum/ai_holder
	var/mob/living/holder = null		// The mob this datum is going to control.
	var/stance = STANCE_IDLE			// Determines if the mob should be doing a specific thing, e.g. attacking, following, standing around, etc.
	var/intelligence_level = AI_NORMAL	// Adjust to make the AI be intentionally dumber, or make it more robust (e.g. dodging grenades).
	var/autopilot = FALSE				// If true, the AI won't be deactivated if a client gets attached to the AI's mob.
	var/busy = FALSE					// If true, the ticker will skip processing this mob until this is false. Good for if you need the
										// mob to stay still (e.g. delayed attacking). If you need the mob to be inactive for an extended period of time,
										// consider sleeping the AI instead.



/datum/ai_holder/hostile
	hostile = TRUE

/datum/ai_holder/retaliate
	hostile = TRUE
	retaliate = TRUE

/datum/ai_holder/New(var/new_holder)
	ASSERT(new_holder)
	holder = new_holder
	SSai.processing += src
	home_turf = get_turf(holder)
	..()

/datum/ai_holder/Destroy()
	holder = null
	SSai.processing -= src // We might've already been asleep and removed, but byond won't care if we do this again and it saves a conditional.
	home_turf = null
	return ..()

/datum/ai_holder/proc/update_stance_hud()
	var/image/stanceimage = holder.grab_hud(LIFE_HUD)
	stanceimage.icon_state = "ais_[stance]"
	holder.apply_hud(LIFE_HUD, stanceimage)

/datum/ai_holder/proc/update_paused_hud()
	var/image/sleepingimage = holder.grab_hud(STATUS_HUD)
	var/asleep = 0
	if(busy)
		asleep = 2
	else if (stance == STANCE_SLEEP)
		asleep = 1
	sleepingimage.icon_state = "ai_[asleep]"
	holder.apply_hud(STATUS_HUD, sleepingimage)

// Now for the actual AI stuff.
/datum/ai_holder/proc/set_busy(var/value = 0)
	busy = value
	update_paused_hud()

// Makes this ai holder not get processed.
// Called automatically when the host mob is killed.
// Potential future optimization would be to sleep AIs which mobs that are far away from in-round players.
/datum/ai_holder/proc/go_sleep()
	if(stance == STANCE_SLEEP)
		return
	forget_everything() // If we ever wake up, its really unlikely that our current memory will be of use.
	set_stance(STANCE_SLEEP)
	SSai.processing -= src
	update_paused_hud()

// Reverses the above proc.
// Revived mobs will wake their AI if they have one.
/datum/ai_holder/proc/go_wake()
	if(stance != STANCE_SLEEP)
		return
	if(!should_wake())
		return
	set_stance(STANCE_IDLE)
	SSai.processing += src
	update_paused_hud()

/datum/ai_holder/proc/should_wake()
	if(holder.client && !autopilot)
		return FALSE
	if(holder.stat >= DEAD)
		return FALSE
	return TRUE

// Resets a lot of 'memory' vars.
/datum/ai_holder/proc/forget_everything()
	// Some of these might be redundant, but hopefully this prevents future bugs if that changes.
	lose_follow()
	remove_target()

// 'Tactical' processes such as moving a step, meleeing an enemy, firing a projectile, and other fairly cheap actions that need to happen quickly.
/datum/ai_holder/proc/handle_tactics()
	handle_special_tactic()
	handle_stance_tactical()

// 'Strategical' processes that are more expensive on the CPU and so don't get run as often as the above proc, such as A* pathfinding or robust targeting.
/datum/ai_holder/proc/handle_strategicals()
	handle_special_strategical()
	handle_stance_strategical()

// Override these for special things without polluting the main loop.
/datum/ai_holder/proc/handle_special_tactic()

/datum/ai_holder/proc/handle_special_strategical()

// For setting the stance WITHOUT processing it
/datum/ai_holder/proc/set_stance(var/new_stance)
	ai_log("set_stance() : Setting stance from [stance] to [new_stance].", AI_LOG_INFO)
	stance = new_stance
	if(stance_coloring) // For debugging or really weird mobs.
		stance_color()
	update_stance_hud()

// This is called every half a second.
/datum/ai_holder/proc/handle_stance_tactical()
	ai_log("========= Fast Process Beginning ==========", AI_LOG_TRACE) // This is to make it easier visually to disinguish between 'blocks' of what a tick did.
	ai_log("handle_stance_tactical() : Called.", AI_LOG_TRACE)

	if(stance == STANCE_SLEEP)
		ai_log("handle_stance_tactical() : Going to sleep.", AI_LOG_TRACE)
		go_sleep()
		return

	if(target && can_see_target(target))
		track_target_position()

	if(stance != STANCE_DISABLED && is_disabled()) // Stunned/confused/etc
		ai_log("handle_stance_tactical() : Disabled.", AI_LOG_TRACE)
		set_stance(STANCE_DISABLED)
		return

	if(stance in STANCES_COMBAT)
		// Should resist?  We check this before fleeing so that we can actually flee and not be trapped in a chair.
		if(holder.incapacitated(INCAPACITATION_BUCKLED_PARTIALLY))
			ai_log("handle_stance_tactical() : Going to handle_resist().", AI_LOG_TRACE)
			handle_resist()

		else if(istype(holder.loc, /obj/structure/closet))
			var/obj/structure/closet/C = holder.loc
			ai_log("handle_stance_tactical() : Inside a closet. Going to attempt escape.", AI_LOG_TRACE)
			if(C.sealed)
				holder.resist()
			else
				C.open()

		// Should we flee?
		if(should_flee())
			ai_log("handle_stance_tactical() : Going to flee.", AI_LOG_TRACE)
			set_stance(STANCE_FLEE)
			return

	switch(stance)
		if(STANCE_IDLE)
			if(should_go_home())
				ai_log("handle_stance_tactical() : STANCE_IDLE, going to go home.", AI_LOG_TRACE)
				go_home()

			else if(should_follow_leader())
				ai_log("handle_stance_tactical() : STANCE_IDLE, going to follow leader.", AI_LOG_TRACE)
				set_stance(STANCE_FOLLOW)

			else if(should_wander())
				ai_log("handle_stance_tactical() : STANCE_IDLE, going to wander randomly.", AI_LOG_TRACE)
				handle_wander_movement()

		if(STANCE_ALERT)
			ai_log("handle_stance_tactical() : STANCE_ALERT, going to threaten_target().", AI_LOG_TRACE)
			threaten_target()

		if(STANCE_APPROACH)
			ai_log("handle_stance_tactical() : STANCE_APPROACH, going to walk_to_target().", AI_LOG_TRACE)
			walk_to_target()

		if(STANCE_FIGHT)
			ai_log("handle_stance_tactical() : STANCE_FIGHT, going to engage_target().", AI_LOG_TRACE)
			engage_target()

		if(STANCE_MOVE)
			ai_log("handle_stance_tactical() : STANCE_MOVE, going to walk_to_destination().", AI_LOG_TRACE)
			walk_to_destination()

		if(STANCE_REPOSITION) // This is the same as above but doesn't stop if an enemy is visible since its an 'in-combat' move order.
			ai_log("handle_stance_tactical() : STANCE_REPOSITION, going to walk_to_destination().", AI_LOG_TRACE)
			if(!target && !find_target())
				walk_to_destination()

		if(STANCE_FOLLOW)
			ai_log("handle_stance_tactical() : STANCE_FOLLOW, going to walk_to_leader().", AI_LOG_TRACE)
			walk_to_leader()

		if(STANCE_FLEE)
			ai_log("handle_stance_tactical() : STANCE_FLEE, going to flee_from_target().", AI_LOG_TRACE)
			flee_from_target()

		if(STANCE_DISABLED)
			ai_log("handle_stance_tactical() : STANCE_DISABLED.", AI_LOG_TRACE)
			if(!is_disabled())
				ai_log("handle_stance_tactical() : No longer disabled.", AI_LOG_TRACE)
				set_stance(STANCE_IDLE)
			else
				handle_disabled()

	ai_log("handle_stance_tactical() : Exiting.", AI_LOG_TRACE)
	ai_log("========= Fast Process Ending ==========", AI_LOG_TRACE)

// This is called every two seconds.
/datum/ai_holder/proc/handle_stance_strategical()
	ai_log("++++++++++ Slow Process Beginning ++++++++++", AI_LOG_TRACE)
	ai_log("handle_stance_strategical() : Called.", AI_LOG_TRACE)
	
	//We got left around for some reason. Goodbye cruel world.
	if(!holder)
		qdel(src)

	ai_log("handle_stance_strategical() : LTT=[lose_target_time]", AI_LOG_TRACE)
	if(lose_target_time && (lose_target_time + lose_target_timeout < world.time)) // We were tracking an enemy but they are gone.
		ai_log("handle_stance_strategical() : Giving up a chase.", AI_LOG_DEBUG)
		remove_target()

	if(stance in STANCES_COMBAT)
		request_help() // Call our allies.

	switch(stance)
		if(STANCE_IDLE)
			if(speak_chance) // In the long loop since otherwise it wont shut up.
				handle_idle_speaking()
			if(hostile)
				ai_log("handle_stance_strategical() : STANCE_IDLE, going to find_target().", AI_LOG_TRACE)
				find_target()
		if(STANCE_APPROACH)
			if(target)
				ai_log("handle_stance_strategical() : STANCE_APPROACH, going to calculate_path([target]).", AI_LOG_TRACE)
				calculate_path(target)
				walk_to_target()
		if(STANCE_MOVE)
			if(hostile && find_target()) // This will switch its stance.
				ai_log("handle_stance_strategical() : STANCE_MOVE, found target and was inturrupted.", AI_LOG_TRACE)
		if(STANCE_FOLLOW)
			if(hostile && find_target()) // This will switch its stance.
				ai_log("handle_stance_strategical() : STANCE_FOLLOW, found target and was inturrupted.", AI_LOG_TRACE)
			else if(leader)
				ai_log("handle_stance_strategical() : STANCE_FOLLOW, going to calculate_path([leader]).", AI_LOG_TRACE)
				calculate_path(leader)
				walk_to_leader()

	ai_log("handle_stance_strategical() : Exiting.", AI_LOG_TRACE)
	ai_log("++++++++++ Slow Process Ending ++++++++++", AI_LOG_TRACE)


// Helper proc to turn AI 'busy' mode on or off without having to check if there is an AI, to simplify writing code.
/mob/living/proc/set_AI_busy(value)
	if(ai_holder)
		ai_holder.set_busy(value)

/mob/living/proc/is_AI_busy()
	if(!ai_holder)
		return FALSE
	return ai_holder.busy

// Helper proc to check for the AI's stance.
// Returns null if there's no AI holder, or the mob has a player and autopilot is not on.
// Otherwise returns the stance.
/mob/living/proc/get_AI_stance()
	if(!ai_holder)
		return null
	if(client && !ai_holder.autopilot)
		return null
	return ai_holder.stance

// Similar to above but only returns 1 or 0.
/mob/living/proc/has_AI()
	return get_AI_stance() ? TRUE : FALSE

// 'Taunts' the AI into attacking the taunter.
/mob/living/proc/taunt(atom/movable/taunter, force_target_switch = FALSE)
	if(ai_holder)
		ai_holder.receive_taunt(taunter, force_target_switch)