/datum/unit_test/posters_shall_have_legal_states
	name = "POSTERS: All poster decls shall have valid icon and icon overrides"

/datum/unit_test/posters_shall_have_legal_states/start_test()
	var/failed = FALSE
	var/list/all_posters = get_poster_decl(/decl/poster, FALSE, null) // While this is not all decls, this is all LEGALLY ACCESSIBLE decls. You should NEVER not use this.

	for(var/decl/poster/D in all_posters)
		var/obj/structure/sign/poster/P = D.get_poster_type()
		var/icon/I = initial(P.icon)
		if(D.icon_override)
			I = D.icon_override
		if(!(D.icon_state in cached_icon_states(I)))
			failures += 1
			log_unit_test("[D.type]: Poster - missing icon_state \"[D.icon_state]\" in  \"[I]\" dmi.")

	if(failed)
		fail("One or more posters have missing icon_states or bad icon overrides.")
	else
		pass("All posters have their icon_states and overrides set correctly.")

	return TRUE
