/*
 *
 *  Map Unit Tests.
 *  Zone checks / APC / Scrubber / Vent / Cryopod Computers.
 *
 *
 */

/datum/unit_test/apc_area_test
	name = "MAP: Area Test APCs"

/datum/unit_test/apc_area_test/start_test()
	var/list/bad_areas = list()
	var/area_test_count = 0
	// We don't care either way.
	var/list/exempt_areas = typesof(/area/space,
					/area/syndicate_station,
					/area/skipjack_station,
					/area/solar,
					/area/shuttle,
					/area/holodeck,
					/area/supply/station,
					/area/mine,
					/area/vacant,
					/area/turbolift,
					/area/submap					)

	// Should NOT have an APC.
	var/list/exempt_from_apc = typesof(/area/construction,
						/area/medical/genetics,
						/area/mine
						)

	// Some maps have areas specific to the map, so include those.
	exempt_areas += using_map.unit_test_exempt_areas.Copy()
	exempt_from_apc += using_map.unit_test_exempt_from_apc.Copy()

	for(var/area/A in world)
		if(isNotStationLevel(A.z))
			continue
		if(A.type in exempt_areas)
			continue
		area_test_count++
		var/area_good = 1
		var/bad_msg = "--------------- [A.name]([A.type])"

		if(!A.apc && !(A.type in exempt_from_apc))
			log_bad("[bad_msg] lacks an APC.")
			area_good = 0
		else if(A.apc && (A.type in exempt_from_apc))
			log_bad("[bad_msg] is not supposed to have an APC.")
			area_good = 0

		if(!area_good)
			bad_areas.Add(A)

	if(bad_areas.len)
		fail("\[[bad_areas.len]/[area_test_count]\]Some areas did not have the expected APC/vent/scrubber setup.")
	else
		pass("All \[[area_test_count]\] areas contained APCs, air scrubbers, and air vents.")

	return 1

//=======================================================================================

/datum/unit_test/wire_test
	name = "MAP: Cable Overlap Test"

/datum/unit_test/wire_test/start_test()
	var/wire_test_count = 0
	var/bad_tests = 0
	var/turf/T = null
	var/obj/structure/cable/C = null
	var/list/cable_turfs = list()
	var/list/dirs_checked = list()

	for(C in world)
		T = get_turf(C)
		cable_turfs |= get_turf(C)

	for(T in cable_turfs)
		dirs_checked.Cut()
		for(C in T)
			wire_test_count++
			var/combined_dir = "[C.d1]-[C.d2]"
			if(combined_dir in dirs_checked)
				bad_tests++
				log_unit_test("\t [T.log_info_line()] Contains multiple wires with same direction on top of each other.")
			dirs_checked.Add(combined_dir)

	if(bad_tests)
		fail("\[[bad_tests] / [wire_test_count]\] Some turfs had overlapping wires going the same direction.")
	else
		pass("All \[[wire_test_count]\] wires had no overlapping cables going the same direction.")

	return 1

//=======================================================================================

/datum/unit_test/correct_allowed_spawn_test
	name = "MAP: All allowed_spawns entries should have spawnpoints on map."

/datum/unit_test/correct_allowed_spawn_test/start_test()
	var/failed = FALSE

	for(var/spawn_name in using_map.allowed_spawns)
		var/datum/spawnpoint/spawnpoint = spawntypes[spawn_name]
		if(!spawnpoint)
			log_unit_test("Map allows spawning in [spawn_name], but [spawn_name] is null!")
			failed = TRUE
		else if(!spawnpoint.turfs.len)
			log_unit_test("Map allows spawning in [spawn_name], but [spawn_name] has no associated spawn turfs.")
			failed = TRUE

	if(failed)
		log_unit_test("Following spawn points exist:")
		for(var/spawnpoint in spawntypes)
			log_unit_test("\t[spawnpoint] (\ref[spawnpoint])")
		log_unit_test("Following spawn points are allowed:")
		for(var/spawnpoint in using_map.allowed_spawns)
			log_unit_test("\t[spawnpoint] (\ref[spawnpoint])")
		fail("Some of the entries in allowed_spawns have no spawnpoint turfs.")
	else
		pass("All entries in allowed_spawns have spawnpoints.")

	return 1

//=======================================================================================

/datum/unit_test/cryopod_comp_check
	name = "MAP: Cryopod Validity Check"

/datum/unit_test/cryopod_comp_check/start_test()
	var/pass = TRUE

	for(var/obj/machinery/cryopod/C in global.machines)
		if(!C.control_computer)
			log_bad("[get_area(C)] lacks a cryopod control computer while holding a cryopod.")
			pass = FALSE

	for(var/obj/machinery/computer/cryopod/C in global.machines)
		if(!(locate(/obj/machinery/cryopod) in get_area(C)))
			log_bad("[get_area(C)] lacks a cryopod while holding a control computer.")
			pass = FALSE

	if(pass)
		pass("All cryopods have their respective control computers.")
	else
		fail("Cryopods were not set up correctly.")

	return 1

//=======================================================================================

/datum/unit_test/camera_nil_c_tag_check
	name = "MAP: Camera nil c_tag check"

/datum/unit_test/camera_nil_c_tag_check/start_test()
	var/pass = TRUE

	for(var/obj/machinery/camera/C in world)
		if(!C.c_tag)
			log_bad("The following camera does not have a c_tag set: [C.log_info_line()]")
			pass = FALSE

	if(pass)
		pass("All cameras have c_tag set.")
	else
		fail("One or more cameras do not have the c_tag set.")

	return 1

//=======================================================================================

/datum/unit_test/camera_unique_c_tag_check
	name = "MAP: Camera unique c_tag check"
	var/exceptions = list(
		"video camera circuit" = TRUE // TODO: Switch to a define
	)

/datum/unit_test/camera_unique_c_tag_check/start_test()
	var/cameras_by_ctag = list()
	var/checked_cameras = 0
	var/failed_tags = list()

	for(var/obj/machinery/camera/C in world)
		if(!C.c_tag)
			continue
		if(exceptions[C.c_tag])
			continue
		checked_cameras++
		if((C.c_tag in cameras_by_ctag))
			failed_tags[C.c_tag] = TRUE
		LAZYADD(cameras_by_ctag[C.c_tag], C)

	if(length(failed_tags))
		for(var/ctag in failed_tags)
			log_bad("Tag [ctag] had [length(cameras_by_ctag[ctag])] cameras:")
			for(var/obj/machinery/camera/C in cameras_by_ctag[ctag])
				log_bad("\t[C] at [C.x], [C.y], [C.z] (in [get_area(C)])")
		fail("[length(failed_tags)] duplicate camera c_tag\s found.")
	else
		pass("[checked_cameras] camera\s have a unique c_tag.")

	return 1

//=======================================================================================

/datum/unit_test/disposal_segments_shall_connect_with_other_disposal_pipes
	name = "MAP: Disposal segments shall connect with other disposal pipes"

/datum/unit_test/disposal_segments_shall_connect_with_other_disposal_pipes/start_test()
	var/list/faulty_pipes = list()

	for(var/obj/structure/disposalpipe/segment/D in world)
		if(!isPlayerLevel(D.z))
			continue
		var/area/Darea = get_area(D)
		if((Darea.type in using_map.disposal_test_exempt_areas) || is_type_in_list(Darea, disposal_test_exempt_root_areas))
			continue
		var/failed = FALSE
		for(var/checkdir in global.cardinal)
			if(!(checkdir & D.dpdir))
				continue
			var/turf/partnerTurf = get_step(D, checkdir)
			if(!partnerTurf)
				continue
			var/foundMatch = FALSE
			for(var/obj/structure/disposalpipe/partner in partnerTurf)
				if(get_dir(partner, D) & partner.dpdir)
					foundMatch = TRUE
			if(!foundMatch)
				failed = TRUE
				break
		if(failed)
			log_bad("Following disposal pipe does not connect correctly: [D.log_info_line()]")
			faulty_pipes += D

	if(faulty_pipes.len)
		fail("[faulty_pipes.len] disposal segment\s did not connect with other disposal pipes.")
	else
		pass("All disposal segments connect with other disposal pipes.")

	return 1

//=======================================================================================

/datum/unit_test/wire_dir_and_icon_stat
	name = "MAP: Cable Dir And Icon State Test"

/datum/unit_test/wire_dir_and_icon_stat/start_test()
	var/list/bad_cables = list()

	for(var/obj/structure/cable/C in world)
		var/expected_icon_state = "[C.d1]-[C.d2]"
		if(C.icon_state != expected_icon_state)
			bad_cables |= C
			log_bad("[C.log_info_line()] has an invalid icon state. Expected [expected_icon_state], was [C.icon_state]")
		if(!(C.icon_state in icon_states(C.icon)))
			bad_cables |= C
			log_bad("[C.log_info_line()] has an non-existing icon state.")

	if(bad_cables.len)
		fail("Found [bad_cables.len] cable\s with an unexpected icon state.")
	else
		pass("All wires had their expected icon state.")

	return 1

//=======================================================================================

/datum/unit_test/station_power_terminals_shall_be_wired
	name = "MAP: Station power terminals shall be wired"

/datum/unit_test/station_power_terminals_shall_be_wired/start_test()
	var/failures = 0
	for(var/obj/machinery/power/terminal/term in global.machines)
		var/turf/T = get_turf(term)
		if(!T)
			failures++
			log_bad("Nullspace terminal : [term.log_info_line()]")
			continue

		if(!isStationLevel(T.z))
			continue

		var/found_cable = FALSE
		for(var/obj/structure/cable/C in T)
			if(C.d2 > 0 && C.d1 == 0)
				found_cable = TRUE
				break
		if(!found_cable)
			failures++
			log_bad("Unwired terminal : [term.log_info_line()]")

	if(failures)
		fail("[failures] unwired power terminal\s.")
	else
		pass("All station power terminals are wired.")
	return 1

//=======================================================================================

/datum/unit_test/station_wires_shall_be_connected
	name = "MAP: Station wires shall be connected"

/datum/unit_test/station_wires_shall_be_connected/start_test()
	var/failures = 0

	for(var/obj/structure/cable/C in world)
		if(istype(C, /obj/structure/cable/ender))
			continue
		if(!all_ends_connected(C))
			failures++

	if(failures)
		fail("Found [failures] cable\s without connections.")
	else
		pass("All station wires are properly connected.")

	return 1

// We work on the assumption that another test ensures we only have valid directions
/datum/unit_test/station_wires_shall_be_connected/proc/all_ends_connected(var/obj/structure/cable/C)
	. = TRUE

	var/turf/source_turf = get_turf(C)
	if(!source_turf)
		log_bad("Nullspace wire: [C.log_info_line()]")
		return FALSE

	// We don't care about non-station wires
	if(!isStationLevel(source_turf.z))
		return TRUE
	
	var/area/source_area = get_area(source_turf)
	if(source_area.type in using_map.wire_test_exempt_areas)
		return TRUE

	for(var/dir in list(C.d1, C.d2))
		if(!dir) // Don't care about knots
			continue
		var/rev_dir = global.reverse_dir[dir]

		var/turf/target_turf
		if(dir == UP)
			target_turf = GetAbove(C)
		if(dir == DOWN)
			target_turf = GetBelow(C)
		else
			target_turf = get_step(C, dir)

		var/connected = FALSE
		for(var/obj/structure/cable/revC in target_turf)
			if(revC.d1 == rev_dir || revC.d2 == rev_dir)
				connected = TRUE
				break

		if(!connected)
			var/dir_message = (C.dir == initial(C.dir)) ? "" : " (Potential mapping error, check d1/d2 and icon state)"
			log_bad("Disconnected wire: [dir2text(dir)] - [C.log_info_line()][dir_message]")
			. = FALSE

//=======================================================================================

/datum/unit_test/bad_doors
	name = "MAP: Check for bad doors"

/datum/unit_test/bad_doors/start_test()
	var/checks = 0
	var/failed_checks = 0
	for(var/obj/machinery/door/airlock/A in world)
		var/turf/T = get_turf(A)
		checks++
		if(!isPlayerLevel(A.z))
			continue
		if(istype(T, /turf/space) || isopenspace(T) || T.density)
			failed_checks++
			log_unit_test("Airlock [A] with bad turf at ([A.x],[A.y],[A.z]) in [T.loc].")
	
	if(failed_checks)
		fail("\[[failed_checks] / [checks]\] Some doors had improper turfs below them.")
	else
		pass("All \[[checks]\] doors have proper turfs below them.")
	
	return 1

//=======================================================================================

/datum/unit_test/active_edges
	name = "MAP: Active edges (all maps)"

/datum/unit_test/active_edges/start_test()

	var/active_edges = air_master.active_edges.len
	var/list/edge_log = list()
	if(active_edges)
		for(var/connection_edge/E in air_master.active_edges)
			var/a_temp = E.A.air.temperature
			var/a_moles = E.A.air.total_moles
			var/a_vol = E.A.air.volume
			var/a_gas = ""
			for(var/gas in E.A.air.gas)
				a_gas += "[gas]=[E.A.air.gas[gas]]"
			
			var/b_temp
			var/b_moles
			var/b_vol
			var/b_gas = ""
			
			// Two zones mixing
			if(istype(E, /connection_edge/zone))
				var/connection_edge/zone/Z = E
				b_temp = Z.B.air.temperature
				b_moles = Z.B.air.total_moles
				b_vol = Z.B.air.volume
				for(var/gas in Z.B.air.gas)
					b_gas += "[gas]=[Z.B.air.gas[gas]]"

			// Zone and unsimulated turfs mixing
			if(istype(E, /connection_edge/unsimulated))
				var/connection_edge/unsimulated/U = E
				b_temp = U.B.temperature
				b_moles = "Unsim"
				b_vol = "Unsim"
				for(var/gas in U.air.gas)
					b_gas += "[gas]=[U.air.gas[gas]]"
			
			edge_log += "Active Edge [E] ([E.type])"
			edge_log += "Edge side A: T:[a_temp], Mol:[a_moles], Vol:[a_vol], Gas:[a_gas]"
			edge_log += "Edge side B: T:[b_temp], Mol:[b_moles], Vol:[b_vol], Gas:[b_gas]"
			
			for(var/turf/T in E.connecting_turfs)
				edge_log += "+--- Connecting Turf [T] ([T.type]) @ [T.x], [T.y], [T.z] ([T.loc])"

	if(active_edges)
		fail("Maps contained [active_edges] active edges at round-start.\n" + edge_log.Join("\n"))
	else
		pass("No active edges.")

	return 1
