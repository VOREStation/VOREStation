
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

// Feed this proc the name of a job, and it will try to figure out what department they are apart of.
// Note that this returns a list, as some jobs are in more than one department, like Command.  The 'primary' department is the first
// in the list, e.g. a HoS has Security as first, Command as second in the returned list.
/datum/metric/proc/role_name_to_department(var/role_name)
	var/list/result = list()

	if(SSjob.is_job_in_department(role_name, DEPARTMENT_SECURITY))
		result += DEPARTMENT_SECURITY

	if(SSjob.is_job_in_department(role_name, DEPARTMENT_ENGINEERING))
		result += DEPARTMENT_ENGINEERING

	if(SSjob.is_job_in_department(role_name, DEPARTMENT_MEDICAL))
		result += DEPARTMENT_MEDICAL

	if(SSjob.is_job_in_department(role_name, DEPARTMENT_RESEARCH))
		result += DEPARTMENT_RESEARCH

	if(SSjob.is_job_in_department(role_name, DEPARTMENT_CARGO))
		result += DEPARTMENT_CARGO

	if(SSjob.is_job_in_department(role_name, DEPARTMENT_CIVILIAN))
		result += DEPARTMENT_CIVILIAN

	if(SSjob.is_job_in_department(role_name, DEPARTMENT_SYNTHETIC))
		result += DEPARTMENT_SYNTHETIC

	if(SSjob.is_job_in_department(role_name, DEPARTMENT_COMMAND)) // We do Command last, since we consider command to only be a primary department for hop/admin.
		result += DEPARTMENT_COMMAND

	if(!result.len) // No department was found.
		result += DEPARTMENT_UNKNOWN
	return result

/datum/metric/proc/count_people_in_department(var/department)
	if(!department)
		return
	for(var/mob/M in player_list)
		if(guess_department(M) != department) // Ignore people outside the department we're counting.
			continue
		. += 1
