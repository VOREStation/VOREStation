/proc/guest_jobbans(var/job)
	return ( (job in SSjob.get_job_titles_in_department(DEPARTMENT_COMMAND)) || (job in SSjob.get_job_titles_in_department(DEPARTMENT_SYNTHETIC)) || (job in SSjob.get_job_titles_in_department(DEPARTMENT_SECURITY)) )

/proc/get_job_datums()
	var/list/occupations = list()
	var/list/all_jobs = typesof(/datum/job)

	for(var/A in all_jobs)
		var/datum/job/job = new A()
		if(!job)	continue
		occupations += job

	return occupations

/proc/get_alternate_titles(var/job)
	var/list/jobs = get_job_datums()
	var/list/titles = list()

	for(var/datum/job/J in jobs)
		if(J.title == job)
			titles = J.alt_titles

	return titles
