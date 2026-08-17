/// converted unit test, maybe should be fully refactored
/// MIGHT REQUIRE BIGGER REWORK

/// Test that tests the apcs, scrubbers and vents of the defined z-levels
/datum/unit_test/apc_area_test

/datum/unit_test/apc_area_test/Run()
	var/list/exempt_areas = typesof(/area/space,
					/area/syndicate_station,
					/area/skipjack_station,
					/area/solar,
					/area/shuttle,
					/area/holodeck,
					/area/supply/station,
					/area/mine,
					/area/vacant/vacant_shop,
					/area/turbolift,
					/area/submap
					)

	var/list/exempt_from_atmos = typesof(/area/maintenance,
						/area/storage,
						/area/engineering/atmos/storage,
						/area/rnd/test_area,
						/area/construction,
						/area/server,
						/area/mine,
						/area/vacant/vacant_shop,
						/area/rnd/research_storage, // This should probably be fixed,
						/area/security/riot_control, // This should probably be fixed,
						)

	var/list/exempt_from_apc = typesof(/area/construction,
						/area/medical/genetics,
						/area/mine,
						/area/vacant/vacant_shop
						)

	// Some maps have areas specific to the map, so include those.
	exempt_areas += using_map.unit_test_exempt_areas.Copy()
	exempt_from_atmos += using_map.unit_test_exempt_from_atmos.Copy()
	exempt_from_apc += using_map.unit_test_exempt_from_apc.Copy()

	var/list/zs_to_test = using_map.unit_test_z_levels || list(1) //Either you set it, or you just get z1

	for(var/area/A in world)
		if((A.z in zs_to_test) && !(A.type in exempt_areas))
			var/bad_msg = "--------------- [A.name]([A.type])"

			// Scan for areas with extra APCs
			if(!(A.type in exempt_from_apc))
				TEST_ASSERT_NOTNULL(A.apc, "[bad_msg] lacks an APC. (X[A.x]|Y[A.y]) - Z[A.z])")

				if(!isnull(A.apc))
					var/list/apc_list = list()
					for(var/turf/T in get_current_area_turfs(A))
						for(var/atom/S in T.contents)
							if(istype(S,/obj/machinery/power/apc))
								apc_list.Add(S)
					if(apc_list.len > 1)
						for(var/obj/machinery/power/P in apc_list)
							TEST_FAIL("[bad_msg] has too many APCs. (X[P.x]|Y[P.y]) - Z[P.z])")

			TEST_ASSERT(!(!A.air_scrub_info.len && !(A.type in exempt_from_atmos)), "[bad_msg] lacks an Air scrubber. (X[A.x]|Y[A.y]) - (Z[A.z])")
			TEST_ASSERT(!(!A.air_vent_info.len && !(A.type in exempt_from_atmos)), "[bad_msg] lacks an Air vent. (X[A.x]|Y[A.y]) - (Z[A.z])")

/// Test that tests cables on defined z-levels
/datum/unit_test/wire_test
	var/wire_test_count = 0
	var/turf/T = null
	var/obj/structure/cable/C = null
	var/list/cable_turfs = list()
	var/list/dirs_checked = list()

	var/list/exempt_from_wires = list()

/datum/unit_test/wire_test/Run()
	set background = 1

	exempt_from_wires += using_map.unit_test_exempt_from_wires.Copy()

	var/list/zs_to_test = using_map.unit_test_z_levels || list(1) //Either you set it, or you just get z1

	for(var/color in GLOB.possible_cable_coil_colours)
		cable_turfs = list()

		for(C in world)
			T = null

			T = get_turf(C)
			var/area/A = get_area(T)
			if(T && (T.z in zs_to_test) && !(A.type in exempt_from_wires))
				if(C.color == GLOB.possible_cable_coil_colours[color])
					cable_turfs |= get_turf(C)

		for(T in cable_turfs)
			var/bad_msg = "--------------- [T.name] \[[T.x] / [T.y] / [T.z]\] [color]"
			dirs_checked.Cut()
			for(C in T)
				wire_test_count++
				var/combined_dir = "[C.d1]-[C.d2]"
				TEST_ASSERT(!(combined_dir in dirs_checked), "[bad_msg] Contains multiple wires with same direction on top of each other.")
				TEST_ASSERT(C.dir == SOUTH, "[bad_msg] Contains wire with dir set, wires MUST face south, use icon_states.")
				dirs_checked.Add(combined_dir)

/// Test template no-ops on all maps
/datum/unit_test/template_noops
	var/list/log = list()
	var/turf_noop_count = 0

/datum/unit_test/template_noops/Run()
	for(var/turf/template_noop/T in world)
		turf_noop_count++
		log += "+-- Template Turf @ [T.x], [T.y], [T.z] ([T.loc])"

	var/area_noop_count = 0
	for(var/area/template_noop/A in world)
		area_noop_count++
		log += "+-- Template Area"

	if(turf_noop_count || area_noop_count)
		TEST_FAIL("Map contained [turf_noop_count] template turfs and [area_noop_count] template areas at round-start.\n" + log.Join("\n"))

/// Test active edges on all maps
/datum/unit_test/active_edges

/datum/unit_test/active_edges/Run()
	var/active_edges = SSair.active_edges.len
	var/list/edge_log = list()

	if(active_edges)
		for(var/datum/connection_edge/E in SSair.active_edges)
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
			if(istype(E, /datum/connection_edge/zone))
				var/datum/connection_edge/zone/Z = E
				b_temp = Z.B.air.temperature
				b_moles = Z.B.air.total_moles
				b_vol = Z.B.air.volume
				for(var/gas in Z.B.air.gas)
					b_gas += "[gas]=[Z.B.air.gas[gas]]"

			// Zone and unsimulated turfs mixing
			if(istype(E, /datum/connection_edge/unsimulated))
				var/datum/connection_edge/unsimulated/U = E
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
		TEST_FAIL("Maps contained [active_edges] active edges at round-start.\n" + edge_log.Join("\n"))

/// Test the ladders on the maps
/datum/unit_test/ladder_test
	var/failed = FALSE

/datum/unit_test/ladder_test/Run()
	for(var/obj/structure/ladder/L in world)
		var/turf/T = get_turf(L)
		TEST_ASSERT(T, "[L.x].[L.y].[L.z]: Map - Ladder on invalid turf")
		if(!T)
			continue

		if(L.allowed_directions & UP)
			TEST_ASSERT(L.target_up, "[T.x].[T.y].[T.z]: Map - Ladder allows upward movement, but had no ladder above it")
		if(L.allowed_directions & DOWN)
			TEST_ASSERT(L.target_down, "[T.x].[T.y].[T.z]: Map - Ladder allows downward movement, but had no ladder beneath it")

		TEST_ASSERT(!T.density, "[L.x].[L.y].[L.z]: Map - Ladder is inside a wall")

/// Test the smes on the map
/datum/unit_test/smes_validity

/datum/unit_test/smes_validity/Run()
	var/failed = FALSE
	var/list/used_tags = list()

	for(var/obj/machinery/power/smes/buildable/unit in world)
		if(unit.RCon_tag == initial(unit.RCon_tag))
			continue
		if(unit.RCon_tag in used_tags)
			TEST_NOTICE(src, "[unit.x].[unit.y].[unit.z]: Map - Smes has an already used RCon_tag: \"[unit.RCon_tag]\"")
			failed = TRUE
			continue
		used_tags += unit.RCon_tag

	if(failed)
		TEST_FAIL("Map has smes with duplicated RCon_tag")

/datum/unit_test/default_spawnpoint_exists

/datum/unit_test/default_spawnpoint_exists/Run()
	var/datum/spawnpoint/default_spawnpoint = new DEFAULT_LATEJOIN_LOCATION()
	TEST_ASSERT(LAZYLEN(default_spawnpoint.turfs), "Map does not define the default spawnpoint location ([default_spawnpoint.display_name])")

/// Telebeacons won't show up in the list, as it's assoc when presented for which one to warp to.
/datum/unit_test/all_tele_beacons_must_be_unique

/datum/unit_test/all_tele_beacons_must_be_unique/Run()
	var/failed = FALSE

	var/list/used_tags = list()
	for(var/obj/item/perfect_tele_beacon/beacon in world)
		var/turf/T = get_turf(beacon)
		var/area/A = get_area(beacon)
		if(!beacon.tele_name)
			failed = TRUE
			TEST_NOTICE(src, "Telebeacon not assigned a tele_name. Located at [T.x].[T.y].[T.z] : [A]")
			continue
		if(beacon.tele_name in used_tags)
			failed = TRUE
			TEST_NOTICE(src, "Telebeacon already in use [beacon.tele_name]. Located at [T.x].[T.y].[T.z] : [A]")
			continue
		used_tags += beacon.tele_name

	if(failed)
		TEST_FAIL("One or more tele_beacon objects are incorrectly setup or are duplicates")

/// Airlocks behave erraticly if they have multiple controllers
/datum/unit_test/all_airlock_controllers_shall_have_unique_ids

/datum/unit_test/all_airlock_controllers_shall_have_unique_ids/Run()
	var/failed = FALSE

	var/list/used_tags = list()
	for(var/obj/machinery/embedded_controller/radio/airlock/controller in world)
		var/turf/T = get_turf(controller)
		var/area/A = get_area(controller)
		if(!controller.id_tag)
			failed = TRUE
			TEST_NOTICE(src, "Airlock controller was missing an id_tag. Located at [T.x].[T.y].[T.z] : [A]")
			continue
		if(controller.id_tag in used_tags)
			failed = TRUE
			TEST_NOTICE(src, "Airlock controller id_tag \"[controller.id_tag]\" was already in use. Located at [T.x].[T.y].[T.z] : [A]")
			continue
		used_tags += controller.id_tag

	if(failed)
		TEST_FAIL("One or more airlock controllers had an incorrect id_tag set")

/// All area subtypes much have unique names
/datum/unit_test/area_names_must_all_be_unique

/datum/unit_test/area_names_must_all_be_unique/Run()
	var/failed = FALSE

	var/list/used_names = list()
	for(var/area/check as anything in subtypesof(/area))
		if(check.name in used_names)
			TEST_NOTICE(src, "[check] area has a name already in use: [check.name]")
			failed = TRUE
			continue
		used_names.Add(check.name)

	if(failed)
		TEST_FAIL("One or more area subtypes share a name.")

// Doors, lights, railings, etc should not be inside of dense turfs. As well, doors should not have space placed under them.
/datum/unit_test/things_should_not_be_in_walls

/datum/unit_test/things_should_not_be_in_walls/Run()
	set background=1

	var/failed = FALSE

	for(var/obj/machinery/light/lig in world)
		if(is_in_wall(lig))
			failed = TRUE
	for(var/obj/machinery/door/dor in world)
		if(is_in_wall(dor))
			failed = TRUE
		if(is_in_space(dor))
			failed = TRUE
	for(var/obj/structure/railing/ral in world)
		if(is_in_wall(ral))
			failed = TRUE

	if(failed)
		TEST_FAIL("One or more objects are inside a dense turf wall.")

/datum/unit_test/things_should_not_be_in_walls/proc/is_in_wall(obj/structure/thing)
	var/turf/ground = get_turf(thing)
	if(!ground)
		return FALSE; // What?
	if(!ground.density)
		return
	TEST_NOTICE(src, "[thing] was inside a dense wall. Located at [ground.x].[ground.y].[ground.z] : [get_area(thing)]")
	return TRUE;

/datum/unit_test/things_should_not_be_in_walls/proc/is_in_space(obj/structure/thing)
	var/turf/ground = get_turf(thing)
	if(!isspace(ground))
		return FALSE;
	TEST_NOTICE(src, "[thing] was placed on space turf. Located at [ground.x].[ground.y].[ground.z] : [get_area(thing)]")
	return TRUE
