var/list/job_whitelist = list()

/hook/startup/proc/loadJobWhitelist()
	load_jobwhitelist()
	return 1

/proc/load_jobwhitelist()
	var/text = file2text("config/jobwhitelist.txt")
	if (!text)
		log_misc("Failed to load config/jobwhitelist.txt")
	else
		job_whitelist = splittext(text, "\n")

/proc/is_job_whitelisted(mob/M, var/rank)
	var/datum/job/job = job_master.GetJob(rank)
	if(!job.whitelist_only)
		return 1
	if(rank == JOB_ALT_VISITOR) //VOREStation Edit - Visitor not Assistant
		return 1
	if(check_rights(R_ADMIN, 0))
		return 1
	if(!job_whitelist)
		return 0
	if(M && rank)
		for (var/s in job_whitelist)
			if(findtext(s,"[lowertext(M.ckey)] - [lowertext(rank)]"))
				return 1
			if(findtext(s,"[M.ckey] - All"))
				return 1
	return 0
