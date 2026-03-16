ADMIN_VERB(cinematic, R_FUN, "Cinematic", "Show a cinematic to all players.", "Fun.Do Not")
	var/datum/cinematic/choice = tgui_input_list(
		user,
		"Chose a cinematic to play to everyone in the server.",
		"Choose Cinematic",
		sortList(subtypesof(/datum/cinematic), GLOBAL_PROC_REF(cmp_typepaths_asc)),
	)
	if(!choice || !ispath(choice, /datum/cinematic))
		return
	play_cinematic(choice, world)
