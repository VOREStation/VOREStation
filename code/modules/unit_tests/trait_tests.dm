/// Test that all traits have unique names
/datum/unit_test/all_traits_unique_names

/datum/unit_test/all_traits_unique_names/Run()
	var/list/used_named = list()
	for(var/traitpath in GLOB.all_traits)
		var/datum/trait/T = GLOB.all_traits[traitpath]
		TEST_ASSERT(!(T.name in used_named), "[T.type]: Trait - The name \"[T.name]\" is already in use.")
		used_named.Add(T.name)

/// Test that autohiss traits shall be excluse
/datum/unit_test/autohiss_shall_be_exclusive

/datum/unit_test/autohiss_shall_be_exclusive/Run()
	var/list/hiss_list = list()
	for(var/traitpath in GLOB.all_traits)
		var/datum/trait/T = GLOB.all_traits[traitpath]
		if(!T.var_changes)
			continue
		if(!islist(T.var_changes["autohiss_basic_map"]))
			continue
		hiss_list += T

	for(var/datum/trait/T in hiss_list)
		TEST_ASSERT(!(T.type in T.excludes), "[T.type]: Trait - Autohiss excludes itself.")
		TEST_ASSERT(T.excludes, "[T.type]: Trait - Autohiss missing exclusion list.")

		if(!T.excludes)
			continue

		var/list/exempt_list = hiss_list.Copy() - T // MUST exclude all others except itself
		for(var/datum/trait/EX in exempt_list)
			TEST_ASSERT(EX.type in T.excludes, "[T.type]: Trait - Autohiss missing exclusion for [EX].")
