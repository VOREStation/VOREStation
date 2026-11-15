/// Conveys all log_mapping messages as unit test failures, as they all indicate mapping problems.
/datum/unit_test/log_mapping
	// Happen before all other tests, to make sure we only capture normal mapping logs.
	priority = TEST_PRE

/datum/unit_test/log_mapping/Run()
	var/static/regex/test_areacoord_regex = regex(@"\(-?\d+,-?\d+,(-?\d+)\)")

	for(var/log_entry in GLOB.unit_test_mapping_logs)
		// Only fail if AREACOORD was conveyed, and it's a station or mining z-level. FIXME: SEE BELOW!
		// This is due to mapping errors don't have coords being impossible to diagnose as a unit test,
		// and various ruins frequently intentionally doing non-standard things.
		if(!test_areacoord_regex.Find(log_entry))
			continue
		// var/z = text2num(test_areacoord_regex.group[1])
		//if(!is_station_level(z) && !is_mining_level(z)) // FIXME: We cannot check for these yet!
		//	continue

		TEST_FAIL(log_entry)

/* Should probably be done as a linter thing instead
/// Checks all machines for legal access numbers
/datum/unit_test/all_access_id_must_have_existing_datums

/datum/unit_test/all_access_id_must_have_existing_datums/Run()
	var/failed = FALSE
	var/list/access_datums = SSaccess.get_all_access_datums_by_id()

	for(var/obj/machinery/thing in world)
		failed += validate_list(thing.req_access, thing, "req_access")
		failed += validate_list(thing.req_one_access, thing, "req_one_access")
	if(failed)
		TEST_FAIL("Machinery had an illegal access id.")

/datum/unit_test/proc/validate_list(list/access_list, obj/machinery/thing, name_list)
	if(!access_list)
		return FALSE // null is legal

	if(!islist(access_list))
		TEST_NOTICE(src, "Access - [thing] ([thing.x].[thing.y].[thing.z]) had a [name_list] that was not a list or null.")
		return TRUE // Was something other than null or a list... illegal

	var/failed = FALSE
	for(var/access in access_list)
		if(!SSaccess.get_access_by_id(access))
			TEST_NOTICE(src, "Access - [thing] ([thing.x].[thing.y].[thing.z]) had a [name_list] with a non-existant id [access].")
			failed = TRUE // has a non-existant id, illegal

	return failed
*/
