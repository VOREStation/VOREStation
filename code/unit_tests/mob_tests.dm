/datum/unit_test/space_suffocation
	name = "MOB: human mob suffocates in space"

	var/startOxyloss
	var/endOxyloss
	var/mob/living/carbon/human/H
	async = 1

/datum/unit_test/space_suffocation/start_test()
	// Get an empty space level instead of just picking a random space turf
	var/empty_z = using_map.get_empty_zlevel()
	if(!empty_z)
		fail("Unable to get empty z-level for suffocation test!")
		return 1

	// Away from map edges so they don't transit while we're testing
	var/mid_w = round(world.maxx*0.5)
	var/mid_h = round(world.maxy*0.5)

	var/turf/T = locate(mid_w, mid_h, empty_z)

	if(!T)
		fail("Unable to find middle turf for suffocation test!")
		return 1

	H = new(T)
	startOxyloss = H.getOxyLoss()

	return 1

/datum/unit_test/space_suffocation/check_result()
	if(H.life_tick < 10)
		return 0

	endOxyloss = H.getOxyLoss()

	if(startOxyloss < endOxyloss)
		pass("Human mob takes oxygen damage in space. (Before: [startOxyloss]; after: [endOxyloss])")
	else
		fail("Human mob is not taking oxygen damage in space. (Before: [startOxyloss]; after: [endOxyloss])")

	qdel(H)
	return 1


/datum/modifier/unit_test

/datum/unit_test/modifier
	name = "modifier test template"
	var/mob/living/subject = null
	var/subject_type = /mob/living/carbon/human
	var/list/inputs = list(1.00, 0.75, 0.50, 0.25, 0.00, -0.50, -1.0, -2.0)
	var/list/expected_outputs = list(1.00, 0.75, 0.50, 0.25, 0.00, -0.50, -1.0, -2.0)
	var/datum/modifier/test_modifier = null
	var/issues = 0

/datum/unit_test/modifier/start_test()
	// Arrange.
	subject = new subject_type(get_standard_turf())
	subject.add_modifier(/datum/modifier/unit_test)
	test_modifier = subject.get_modifier_of_type(/datum/modifier/unit_test)

	// Act,
	for(var/i = 1 to inputs.len)
		set_tested_variable(test_modifier, inputs[i])
		var/actual = round(get_test_value(subject), 0.01) // Rounding because floating point schannigans.
		if(actual != expected_outputs[i])
			issues++
			log_bad("Input '[inputs[i]]' did not match expected output '[expected_outputs[i]]', but was instead '[actual]'.")

	// Assert.
	if(issues)
		fail("[issues] issues were found.")
	else
		pass("No issues found.")
	qdel(subject)
	return TRUE

// Override for subtypes.
/datum/unit_test/modifier/proc/set_tested_variable(datum/modifier/M, new_value)
	return

/datum/unit_test/modifier/proc/get_test_value(mob/living/L)
	return


/datum/unit_test/modifier/heat_protection
	name = "MOB: human mob heat protection is calculated correctly"

/datum/unit_test/modifier/heat_protection/set_tested_variable(datum/modifier/M, new_value)
	M.heat_protection = new_value

/datum/unit_test/modifier/heat_protection/get_test_value(mob/living/L)
	return L.get_heat_protection(1000)

/datum/unit_test/modifier/heat_protection/simple_mob
	name = "MOB: simple mob heat protection is calculated correctly"
	subject_type = /mob/living/simple_mob


/datum/unit_test/modifier/cold_protection
	name = "MOB: human mob cold protection is calculated correctly"

/datum/unit_test/modifier/cold_protection/set_tested_variable(datum/modifier/M, new_value)
	M.cold_protection = new_value

/datum/unit_test/modifier/cold_protection/get_test_value(mob/living/L)
	return L.get_cold_protection(50)

/datum/unit_test/modifier/cold_protection/simple_mob
	name = "MOB: simple mob cold protection is calculated correctly"
	subject_type = /mob/living/simple_mob


/datum/unit_test/modifier/shock_protection
	name = "MOB: human mob shock protection is calculated correctly"
	inputs = list(3.00, 2.00, 1.50, 1.00, 0.75, 0.50, 0.25, 0.00)
	expected_outputs = list(-2.00, -1.00, -0.50, 0.00, 0.25, 0.50, 0.75, 1.00)

/datum/unit_test/modifier/shock_protection/set_tested_variable(datum/modifier/M, new_value)
	M.siemens_coefficient = new_value

/datum/unit_test/modifier/shock_protection/get_test_value(mob/living/L)
	return L.get_shock_protection()

/datum/unit_test/modifier/shock_protection/simple_mob
	name = "MOB: simple mob shock protection is calculated correctly"
	subject_type = /mob/living/simple_mob


/datum/unit_test/modifier/percentage_armor
	name = "MOB: human mob percentage armor is calculated correctly"
	inputs = list(100, 75, 50, 25, 0)
	expected_outputs = list(100, 75, 50, 25, 0)

/datum/unit_test/modifier/percentage_armor/set_tested_variable(datum/modifier/M, new_value)
	M.armor_percent = list("melee" = new_value)

/datum/unit_test/modifier/percentage_armor/get_test_value(mob/living/L)
	return L.getarmor(null, "melee")

/datum/unit_test/modifier/percentage_armor/simple_mob
	name = "MOB: simple mob percentage armor is calculated correctly"
	subject_type = /mob/living/simple_mob


/datum/unit_test/modifier/percentage_flat
	name = "MOB: human mob flat armor is calculated correctly"
	inputs = list(100, 75, 50, 25, 0)
	expected_outputs = list(100, 75, 50, 25, 0)

/datum/unit_test/modifier/percentage_flat/set_tested_variable(datum/modifier/M, new_value)
	M.armor_flat = list("melee" = new_value)

/datum/unit_test/modifier/percentage_flat/get_test_value(mob/living/L)
	return L.getsoak(null, "melee")

/datum/unit_test/modifier/percentage_flat/simple_mob
	name = "MOB: simple mob flat armor is calculated correctly"
	subject_type = /mob/living/simple_mob
