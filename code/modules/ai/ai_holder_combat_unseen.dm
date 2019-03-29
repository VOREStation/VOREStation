// Used for fighting invisible things.

// Used when a target is out of sight or invisible.
/datum/ai_holder/proc/engage_unseen_enemy()
	// Lets do some last things before giving up.
	if(!ranged)
		if(get_dist(holder, target_last_seen_turf > 1)) // We last saw them over there.
			// Go to where you last saw the enemy.
			give_destination(target_last_seen_turf, 1, TRUE) // This will set it to STANCE_REPOSITION.
		else // We last saw them next to us, so do a blind attack on that tile.
			melee_on_tile(target_last_seen_turf)

	else if(!conserve_ammo)
		shoot_near_turf(target_last_seen_turf)

// This shoots semi-randomly near a specific turf.
/datum/ai_holder/proc/shoot_near_turf(turf/targeted_turf)
	if(!ranged)
		return // Can't shoot.
	if(get_dist(holder, targeted_turf) > max_range(targeted_turf))
		return // Too far to shoot.

	var/turf/T = pick(RANGE_TURFS(2, targeted_turf)) // The turf we're actually gonna shoot at.
	on_engagement(T)
	if(firing_lanes && !test_projectile_safety(T))
		step_rand(holder)
		holder.face_atom(T)
		return

	ranged_attack(T)

// Attempts to attack something on a specific tile.
// TODO: Put on mob/living?
/datum/ai_holder/proc/melee_on_tile(turf/T)
	var/mob/living/L = locate() in T
	if(!L)
		T.visible_message("\The [holder] attacks nothing around \the [T].")
		return

	if(holder.IIsAlly(L)) // Don't hurt our ally.
		return

	melee_attack(L)