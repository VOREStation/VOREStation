// Tell the game master that something dangerous happened, e.g. someone dying.
/datum/game_master/proc/adjust_danger(var/amt)
	amt = amt * danger_modifier
	danger = round( Clamp(danger + amt, 0, 1000), 0.1)

// Tell the game master that something interesting happened.
/datum/game_master/proc/adjust_staleness(var/amt)
	amt = amt * staleness_modifier
	staleness = round( Clamp(staleness + amt, -50, 200), 0.1)

// This proc tries to find the department of an arbitrary mob.
/datum/game_master/proc/guess_department(var/mob/M)
	var/datum/data/record/R = find_general_record("name", M.real_name)
	. = ROLE_UNKNOWN
	if(R) // We found someone with a record.
		var/recorded_rank = R.fields["real_rank"]
		. = role_name_to_department(recorded_rank)
		if(. != ROLE_UNKNOWN) // We found the correct department, so we can stop now.
			return

	// They have a custom title, aren't crew, or someone deleted their record, so we need a fallback method.
	// Let's check the mind.
	if(M.mind)
		. = role_name_to_department(M.mind.assigned_role)
		if(. != ROLE_UNKNOWN)
			return

	// At this point, they don't have a mind, or for some reason assigned_role didn't work.
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		. = role_name_to_department(H.job)
		if(. != ROLE_UNKNOWN)
			return

	return ROLE_UNKNOWN // Welp.


// Feed this proc the name of a job, and it will try to figure out what department they are apart of.
/datum/game_master/proc/role_name_to_department(var/role_name)
	if(role_name in security_positions)
		return ROLE_SECURITY

	if(role_name in engineering_positions)
		return ROLE_ENGINEERING

	if(role_name in medical_positions)
		return ROLE_MEDICAL

	if(role_name in science_positions)
		return ROLE_RESEARCH

	if(role_name in cargo_positions)
		return ROLE_CARGO

	if(role_name in civilian_positions)
		return ROLE_CIVILIAN

	if(role_name in nonhuman_positions)
		return ROLE_SYNTHETIC

	if(role_name in command_positions) // We do command last, so that only the Captain and command secretaries get caught.
		return ROLE_COMMAND

	return ROLE_UNKNOWN

/datum/game_master/proc/count_people_in_department(var/department)
	if(!department)
		return
	for(var/mob/M in player_list)
		if(guess_department(M) != department) // Ignore people outside the department we're counting.
			continue
		. += 1