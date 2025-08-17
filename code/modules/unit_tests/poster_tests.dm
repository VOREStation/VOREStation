/// converted unit test, maybe should be fully refactored

/datum/unit_test/posters_shall_have_legal_states/Run()
	var/list/all_posters = decls_repository.get_decls_of_type(/decl/poster)
	all_posters -= decls_repository.get_decl(/decl/poster/lewd) // Dumb exclusion for now. This really needs to become a valid poster instead of an illegaly made base type

	for(var/path in all_posters)
		var/decl/poster/D = all_posters[path]
		var/obj/structure/sign/poster/P = /obj/structure/sign/poster // The base poster shows ALL subtypes except /lewd, so all posters should function here regardless!
		var/icon/I = initial(P.icon)
		if(D.icon_override)
			I = D.icon_override
		TEST_ASSERT(icon_exists(D.icon_state, I), "[D.type]: Poster - missing icon_state \"[D.icon_state]\" in \"[I]\", as [D.icon_override ? "override" : "base"] dmi.")
		//TEST_ASSERT(D.icon_state in cached_icon_states(I), "[D.type]: Poster - missing icon_state \"[D.icon_state]\" in \"[I]\", as [D.icon_override ? "override" : "base"] dmi.")
