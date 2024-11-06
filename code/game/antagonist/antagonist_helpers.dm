/datum/antagonist/proc/can_become_antag(var/datum/mind/player, var/ignore_role)
	if(player.current)
		if(jobban_isbanned(player.current, bantype))
			return FALSE
		if(!isnewplayer(player.current) && !isobserver(player.current))
			if(!player.current.can_be_antagged) // Stop autotraitoring pAIs!
				return FALSE
	if(!ignore_role)
		if(player.assigned_role in restricted_jobs)
			return FALSE
		if(CONFIG_GET(flag/protect_roles_from_antagonist) && (player.assigned_role in protected_jobs))
			return FALSE
		if(avoid_silicons)
			var/datum/job/J = SSjob.get_job(player.assigned_role)
			if(J)
				if(J.mob_type & JOB_SILICON)
					return FALSE
			else // If SSjob couldn't find a job, they don't have one yet, so the next best thing we can switch on are job preferences
				if((player.current.client.prefs.job_engsec_high | player.current.client.prefs.job_engsec_med | player.current.client.prefs.job_engsec_low) & (AI | CYBORG)) // If they have ANY chance of being silicon
					return FALSE
	return TRUE

/datum/antagonist/proc/antags_are_dead()
	for(var/datum/mind/antag in current_antagonists)
		if(mob_path && !istype(antag.current,mob_path))
			continue
		if(antag.current.stat==2)
			continue
		return 0
	return 1

/datum/antagonist/proc/get_antag_count()
	return current_antagonists ? current_antagonists.len : 0

/datum/antagonist/proc/is_antagonist(var/datum/mind/player)
	if(player in current_antagonists)
		return 1

/datum/antagonist/proc/is_type(var/antag_type)
	if(antag_type == id || antag_type == role_text)
		return 1
	return 0

/datum/antagonist/proc/is_votable()
	return (flags & ANTAG_VOTABLE)

/datum/antagonist/proc/can_late_spawn()
	if(!(allow_latejoin))
		return 0
	update_current_antag_max()
	if(get_antag_count() >= cur_max)
		return 0
	return 1

/datum/antagonist/proc/is_latejoin_template()
	return (flags & (ANTAG_OVERRIDE_MOB|ANTAG_OVERRIDE_JOB))
