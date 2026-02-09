/datum/unit_test/special_role_flags_syncronized

/datum/unit_test/special_role_flags_syncronized/Run()
	if(GLOB.special_roles.len != GLOB.be_special_flags.len)
		TEST_FAIL("GLOB.special_roles and GLOB.be_special_flags lengths do not match. [GLOB.special_roles] vs [GLOB.be_special_flags].")

	// These get out of order way too often.
	var/index = 0
	for(var/key in GLOB.special_roles)
		var/check_key = GLOB.be_special_flags[index]
		if(lowertext(check_key) != lowertext(key))
			TEST_FAIL("Special role flag misalignment index: [index],  be_special_flags: [check_key],  special_roles: [key]")
