/datum/job
	//Requires a ckey to be whitelisted in jobwhitelist.txt
	var/whitelist_only = 0

	//Does not display this job on the occupation setup screen
	var/latejoin_only = 0

	//Every hour playing this role gains this much time off. (Can be negative for off duty jobs!)
	var/timeoff_factor = 3

	//What type of PTO is that job earning?
	var/pto_type

	//Disallow joining as this job midround from off-duty position via going on-duty
	var/disallow_jobhop = FALSE

// Check client-specific availability rules.
/datum/job/proc/player_has_enough_pto(client/C)
	return timeoff_factor >= 0 || (C && LAZYACCESS(C.department_hours, pto_type) > 0)
