/datum/controller/configuration/proc/LoadModes()
	gamemode_cache = typecacheof(/datum/game_mode, TRUE)
	modes = list()
	mode_names = list()
	//mode_reports = list()
	//mode_false_report_weight = list()
	votable_modes = list()
	var/list/probabilities = CONFIG_GET(keyed_list/probabilities)
	for(var/T in gamemode_cache)
		// I wish I didn't have to instance the game modes in order to look up
		// their information, but it is the only way (at least that I know of).
		var/datum/game_mode/M = new T()

		if(M.config_tag)
			if(!(M.config_tag in modes))		// ensure each mode is added only once
				modes += M.config_tag
				mode_names[M.config_tag] = M.name
				probabilities[M.config_tag] = M.probability
				//mode_reports[M.config_tag] = M.generate_report()
				//mode_false_report_weight[M.config_tag] = M.false_report_weight
				if(M.votable)
					votable_modes += M.config_tag
		qdel(M)
	votable_modes += "extended"

/datum/controller/configuration/proc/pick_mode(mode_name)
	// I wish I didn't have to instance the game modes in order to look up
	// their information, but it is the only way (at least that I know of).
	// ^ This guy didn't try hard enough
	for(var/T in gamemode_cache)
		var/datum/game_mode/M = T
		var/ct = initial(M.config_tag)
		if(ct && ct == mode_name)
			return new T
	return new /datum/game_mode/extended()

/datum/controller/configuration/proc/get_runnable_modes()
	var/list/runnable_modes = list()
	var/list/probabilities = CONFIG_GET(keyed_list/probabilities)

	for(var/T in gamemode_cache)
		var/datum/game_mode/M = new T()
		if(!(M.config_tag in modes))
			qdel(M)
			continue
		if(probabilities[M.config_tag] <= 0)
			qdel(M)
			continue
		if(M.can_start())
			var/final_weight = probabilities[M.config_tag]
			runnable_modes[M] = final_weight

	return runnable_modes
