/datum/action/cooldown/mob_cooldown/leap
	name = "Leap"
	desc = "Jump a short distance"
	cooldown_time = 10 SECONDS
	shared_cooldown = NONE
	button_icon_state = "genetic_jump"

	var/leap_windup = 2 SECONDS
	var/leap_distance = 3

/datum/action/cooldown/mob_cooldown/leap/Activate(atom/target)
	owner.do_windup_animation(get_step(get_turf(owner), owner.dir), leap_windup)
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

/datum/action/cooldown/mob_cooldown/leap/teshari
	leap_distance = 4

/datum/action/cooldown/mob_cooldown/leap/tajaran
	name = "Pounce"
	cooldown_time = 5 SECONDS
	leap_windup = 1 SECOND
