/datum/unit_test/mech_construction/Run()
	var/failed = FALSE
	for(var/datum/construction/C as anything in subtypesof(/datum/construction))
		// We check for null, as null is legal here... For now... Mech construction needs a full refactor to make them unittest-able in a not ugly way.
		if(!C.result)
			continue
		if(!ispath(C.result))
			TEST_NOTICE(src, "[C.type]: Mech Construction - Had invalid result \"[C.result]\", must be a path.")
			failed = TRUE
	if(failed)
		TEST_FAIL("Mech Construction - A construction datum had incorrect data.")

/datum/unit_test/all_machine_circuits_must_be_printable/Run()
	// get a list of all construction frames that automatically populate their circuitboard, we don't need to test for these
	var/list/prepopulated_circuits = list()
	for(var/datum/frame/frame_types/path as anything in subtypesof(/datum/frame/frame_types))
		var/obj/item/circuitboard/circuit = initial(path.circuit)
		if(!circuit)
			continue
		prepopulated_circuits |= circuit

	// Get all machines with circuitboards
	var/list/all_circuitboard_machines = list()
	for(var/obj/machinery/path as anything in subtypesof(/obj/machinery))
		var/obj/item/circuitboard/circuit = initial(path.circuit)
		if(!circuit)
			continue
		all_circuitboard_machines |= circuit

	// Check all circuits that are need has a techweb design
	all_circuitboard_machines -= prepopulated_circuits
	for(var/id in SSresearch.techweb_designs)
		var/datum/design_techweb/design = SSresearch.techweb_designs[id]
		if(!(design.build_path in subtypesof(/obj/item/circuitboard)))
			continue
		all_circuitboard_machines -= design.build_path

	var/failed = FALSE
	if(length(all_circuitboard_machines))
		for(var/obj/item/circuitboard/circuit as anything in all_circuitboard_machines)
			if(ispath(circuit))
				if(initial(circuit.hidden)) // Intentionally not meant to show up on station
					continue
				TEST_NOTICE(src, "[circuit] - Missing a circuit from techweb. Ensure a techweb entry exists, or [circuit.build_path] will not be constructable in round.")
			else
				TEST_NOTICE(src, "[circuit] - is a LEGACY STRING and must be converted to a path!!!")
			failed = TRUE

	if(failed)
		TEST_FAIL("missing circuitboard print recipies.")

/datum/unit_test/all_default_circuits_must_match_machines

/datum/unit_test/all_default_circuits_must_match_machines/Run()
	var/failed = FALSE

	// Check the machine deconstructs into the board
	for(var/obj/machinery/machine_path as anything in subtypesof(/obj/machinery))
		if((machine_path in typesof(/obj/machinery/airlock_sensor)) || (machine_path in typesof(/obj/machinery/embedded_controller/radio/airlock))) // Snowflake multi-type airlock board
			continue
		if(machine_path == /obj/machinery/power/smes) // Ignore this snowflake basetype that isn't constructable
			continue
		if(!machine_path.circuit)
			continue
		var/obj/item/circuitboard/board_path = initial(machine_path.circuit)
		if(!board_path)
			continue

		// Get to the actual test!
		if(!(machine_path in typesof(board_path.build_path))) // This should be stricted someday... but not today.
			TEST_NOTICE(src, "[machine_path]'s default board does not match the machine it constructs. \"[board_path]\".")
			failed = TRUE

	if(failed)
		TEST_FAIL("machine had an incorrect circuitboard in its definition.")
