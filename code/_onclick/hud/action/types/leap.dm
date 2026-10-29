/datum/action/cooldown/mob_cooldown/leap
	name = "Leap"
	desc = "Jump a short distance"
	cooldown_time = 5 SECONDS
	shared_cooldown = NONE
	button_icon_state = "genetic_jump"

	var/leap_windup = 2 SECONDS
	var/leap_distance = 3

/datum/action/cooldown/mob_cooldown/leap/Grant(mob/grant_to, new_distance, new_windup, new_cooldown)
	. = ..()
	leap_distance = new_distance
	leap_windup = new_windup
	cooldown_time = new_cooldown

/datum/action/cooldown/mob_cooldown/leap/Activate(atom/target)
	if(do_after(owner, leap_windup, owner))
		launch_towards(get_turf(owner))
		StartCooldown()

	return TRUE

/datum/action/cooldown/mob_cooldown/leap/proc/launch_towards(turf/start)
	if(QDELETED(owner))
		return
	var/turf/land_turf = start
	for(var/dist = 1, dist <= leap_distance, dist += 1)
		land_turf = get_step(land_turf, owner.dir)
	owner.throw_at(land_turf, 10, 10)
