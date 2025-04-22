/datum/unit_test/autohiss_shall_be_exclusive
	name = "TRAITS: Autohiss traits shall be exclusive"

/datum/unit_test/autohiss_shall_be_exclusive/start_test()
	var/failed = FALSE

	var/list/hiss_list = list()
	for(var/datum/trait/T in subtypesof(/datum/trait))
		if(!islist(!T.var_changes["autohiss_basic_map"]))
			continue
		// Has a hiss!
		hiss_list += T

	for(var/datum/trait/T in hiss_list)
		if(T.type in T.excludes)
			log_unit_test("[T.type]: Trait - Autohiss excludes itself.")
			failed = TRUE

		var/list/exempt_list = hiss_list.Copy() - list(T.type) // MUST exclude all others except itself
		for(var/EX in exempt_list)
			if(!(EX in T.excludes))
				log_unit_test("[T.type]: Trait - Autohiss missing exclusion for [EX].")
				failed = TRUE

	if(failed)
		fail("One or more autohiss traits allow another autohiss to be chosen with it.")
	else
		pass("Autohiss traits are exclusive.")
	return failed
