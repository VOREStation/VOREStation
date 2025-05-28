
// This proc tries to find the department of an arbitrary mob.
/datum/metric/proc/guess_department(var/mob/M)
	var/list/found_roles = list()
	. = DEPARTMENT_UNKNOWN

	// Records are usually the most reliable way to get what job someone is.
	var/datum/data/record/R = find_general_record("name", M.real_name)
	if(R) // We found someone with a record.
		var/recorded_rank = R.fields["real_rank"]
		found_roles = role_name_to_department(recorded_rank)
		. = found_roles[1]
		if(. != DEPARTMENT_UNKNOWN) // We found the correct department, so we can stop now.
			return

	// They have a custom title, aren't crew, or someone deleted their record, so we need a fallback method.
	// Let's check the mind.
	if(M.mind)
		found_roles = role_name_to_department(M.mind.assigned_role)
		. = found_roles[1]
		if(. != DEPARTMENT_UNKNOWN)
			return

	// At this point, they don't have a mind, or for some reason assigned_role didn't work.
	found_roles = role_name_to_department(M.job)
	. = found_roles[1]
	if(. != DEPARTMENT_UNKNOWN)
		return

	return DEPARTMENT_UNKNOWN // Welp.

// Similar to above, but gets the actual job. Note that it returns the job datum itself, or null.
/datum/metric/proc/guess_job(mob/M)
	// Like before, records are the most reliable way.
	var/datum/data/record/R = find_general_record("name", M.real_name)
	if(R) // They got a record, now find the job datum.
		var/datum/job/J = SSjob.get_job(R.fields["real_rank"])
		if(istype(J))
			return J

	// Try the mind.
	if(M.mind)
		var/datum/job/J = SSjob.get_job(M.mind.assigned_role)
		if(istype(J))
			return J

	// Last ditch effort, check for job assigned to the mob itself.
	var/datum/job/J = SSjob.get_job(M.job)
	if(istype(J))
		return J

	return null

// Feed this proc the name of a job, and it will try to figure out what department they are apart of.
// Improved with the addition of SSjob, which has departments be an actual thing and not a virtual concept.
/datum/metric/proc/role_name_to_department(var/role_name)
	var/datum/job/J = SSjob.get_job(role_name)
	if(istype(J))
		if(LAZYLEN(J.departments))
			return J.departments
	return list(DEPARTMENT_UNKNOWN)

/datum/metric/proc/count_people_in_department(var/department, cutoff = 75)
	var/list/L = get_people_in_department(department, cutoff)
	return L.len


/datum/metric/proc/get_people_in_department(department, cutoff = 75)
	. = list()
	if(!department)
		return
	for(var/mob/M in player_list)
		// Do not count AI's shells
		if(isrobot(M))
			var/mob/living/silicon/robot/R = M
			if(R.shell)
				continue
		if(department != DEPARTMENT_EVERYONE && guess_department(M) != department) // Ignore people outside the department we're counting.
			continue
		if(assess_player_activity(M) < cutoff)
			continue
		. += M

/datum/metric/proc/get_people_with_job(job_type, cutoff = 75)
	. = list()
	// First, get the name.
	var/datum/job/J = SSjob.get_job_type(job_type)
	if(!istype(J))
		return

	// Now find people with the job name.
	for(var/M in player_list)
		var/datum/job/their_job = guess_job(M)
		if(!istype(their_job)) // No job was guessed.
			continue
		if(their_job.title != J.title) // Jobs don't match.
			continue
		if(assess_player_activity(M) < cutoff) // Too AFK.
			continue
		. += M

/datum/metric/proc/count_people_with_job(job_type, cutoff = 75)
	var/list/L = get_people_with_job(job_type, cutoff)
	return L.len



/datum/metric/proc/get_people_with_alt_title(job_type, alt_title_type, cutoff = 75)
	. = list()

	var/list/people_with_jobs = get_people_with_job(job_type, cutoff)
	var/datum/job/J = SSjob.get_job_type(job_type)
	var/datum/alt_title/A = new alt_title_type()

	for(var/M in people_with_jobs)
		if(J.has_alt_title(M, null, A.title))
			. += M

/datum/metric/proc/count_people_with_alt_title(job_type, alt_title_type, cutoff = 75)
	var/list/L = get_people_with_alt_title(job_type, alt_title_type, cutoff)
	return L.len
