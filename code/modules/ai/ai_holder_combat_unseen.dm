// Used for fighting invisible things.

// Used when a target is out of sight or invisible.
/datum/ai_holder/proc/engage_unseen_enemy()
	ai_log("engage_unseen_enemy() : Entering.", AI_LOG_TRACE)

	// Also handled in strategic updates but handling it here allows for more fine resolution timeouts
	if((lose_target_time+lose_target_timeout) <= world.time)
		return find_target()

	// Lets do some last things before giving up.
	if(conserve_ammo || !holder.ICheckRangedAttack(target_last_seen_turf))
		// We conserve ammo (or can't shoot) so walk closer
		if(get_dist(holder, target_last_seen_turf) > 1)
			return give_destination(target_last_seen_turf, 1, TRUE) // Sets stance as well
		// We're right there, look around?
		else
			return find_target()
	// Shoot in their direction angrily
	else
		return shoot_near_turf(target_last_seen_turf)

// This shoots semi-randomly near a specific turf.
/datum/ai_holder/proc/shoot_near_turf(turf/targeted_turf)
	if(get_dist(holder, targeted_turf) > max_range(targeted_turf))
		return ATTACK_FAILED// Too far to shoot.

	var/turf/T = pick(RANGE_TURFS(2, targeted_turf)) // The turf we're actually gonna shoot at.
	on_engagement(T)
	if(firing_lanes && !test_projectile_safety(T))
		step_rand(holder)
		holder?.face_atom(T)
		return ATTACK_FAILED

	return ranged_attack(T)

// Attempts to attack something on a specific tile.
// TODO: Put on mob/living?
/datum/ai_holder/proc/melee_on_tile(turf/T)
	ai_log("melee_on_tile() : Entering.", AI_LOG_TRACE)
	var/mob/living/L = locate() in T
	if(!L)
		T.visible_message("\The [holder] attacks nothing around \the [T].")
		return ATTACK_FAILED

	if(holder.IIsAlly(L)) // Don't hurt our ally.
		return ATTACK_FAILED

	return melee_attack(L)

// Attempts to locate any possible avenues that the target might have escaped via
// Could be an open door, could be a stairwell or a ladder
// Returns object to path to. If multiple targets are equidistant, picks randomly
/datum/ai_holder/proc/find_escape_route()
	ai_log("find_escape_route() : Entering.", AI_LOG_DEBUG)
	var/list/closest_escape = list()
	var/closest_dist = world.view // We can't see any further than this
	var/list/possible_escape_types = list(
		/obj/machinery/door,
		/obj/structure/stairs/top,
		/obj/structure/stairs/bottom
	)

	if(intelligence_level >= AI_SMART)
		possible_escape_types += /obj/structure/ladder

	for(var/atom/A in view(world.view, holder))
		if(!is_type_in_list(A, possible_escape_types))
			continue // Not something they could have escaped through
		if(turn(holder.dir, 180) & get_dir(get_turf(holder), get_turf(A)))
			continue // Surely, they couldn't have escaped *behind* us!

		if(istype(A, /obj/machinery/door))
			var/obj/machinery/door/D = A
			if(D.glass) // Surely, they couldn't hide behind a transparent door!
				continue
			if(D.density && intelligence_level < AI_SMART) // Surely, they couldn't have escaped through a *closed* door
				continue

		var/dist = get_dist(holder, A)
		if(dist == closest_dist)
			closest_escape += A

		else if(dist < closest_dist)
			closest_escape.Cut()
			closest_escape += A
			closest_dist = dist
	ai_log("find_escape_route() : Found [closest_escape.len] candidates [closest_dist] tiles away.", AI_LOG_DEBUG)
	if(closest_escape.len)
		return pick(closest_escape)
	return null
