/datum/unit_test/apc_area_test
	name = "MAP: Area Test APC / Scrubbers / Vents Z level 1"

/datum/unit_test/apc_area_test/start_test()
	var/list/bad_areas = list()
	var/area_test_count = 0
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
					/area/submap					)

	var/list/exempt_from_atmos = typesof(/area/maintenance,
						/area/storage,
						/area/engineering/atmos/storage,
						/area/rnd/test_area,
						/area/construction,
						/area/server,
						/area/mine,
						/area/vacant/vacant_shop,
						/area/rnd/research_storage, // This should probably be fixed,
						/area/security/riot_control // This should probably be fixed,
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
			area_test_count++
			var/area_good = 1
			var/bad_msg = "--------------- [A.name]([A.type])"


			if(isnull(A.apc) && !(A.type in exempt_from_apc))
				log_unit_test("[bad_msg] lacks an APC.")
				area_good = 0

			if(!A.air_scrub_info.len && !(A.type in exempt_from_atmos))
				log_unit_test("[bad_msg] lacks an Air scrubber.")
				area_good = 0

			if(!A.air_vent_info.len && !(A.type in exempt_from_atmos))
				log_unit_test("[bad_msg] lacks an Air vent.")
				area_good = 0

			if(!area_good)
				bad_areas.Add(A)

	if(bad_areas.len)
		fail("\[[bad_areas.len]/[area_test_count]\]Some areas lacked APCs, Air Scrubbers, or Air vents.")
	else
		pass("All \[[area_test_count]\] areas contained APCs, Air scrubbers, and Air vents.")

	return 1

/datum/unit_test/wire_test
	name = "MAP: Cable Test Z level 1"

/datum/unit_test/wire_test/start_test()
	var/wire_test_count = 0
	var/bad_tests = 0
	var/turf/T = null
	var/obj/structure/cable/C = null
	var/list/cable_turfs = list()
	var/list/dirs_checked = list()

	for(C in world)
		T = null

		T = get_turf(C)
		if(T && T.z == 1)
			cable_turfs |= get_turf(C)

	for(T in cable_turfs)
		var/bad_msg = "--------------- [T.name] \[[T.x] / [T.y] / [T.z]\]"
		dirs_checked.Cut()
		for(C in T)
			wire_test_count++
			var/combined_dir = "[C.d1]-[C.d2]"
			if(combined_dir in dirs_checked)
				bad_tests++
				log_unit_test("[bad_msg] Contains multiple wires with same direction on top of each other.")
			dirs_checked.Add(combined_dir)

	if(bad_tests)
		fail("\[[bad_tests] / [wire_test_count]\] Some turfs had overlapping wires going the same direction.")
	else
		pass("All \[[wire_test_count]\] wires had no overlapping cables going the same direction.")

	return 1

/datum/unit_test/active_edges
	name = "MAP: Active edges (all maps)"

/datum/unit_test/active_edges/start_test()

	var/active_edges = air_master.active_edges.len
	var/list/edge_log = list()
	if(active_edges)
		for(var/connection_edge/E in air_master.active_edges)
			edge_log += "Active Edge [E] ([E.type])"
			for(var/turf/T in E.connecting_turfs)
				edge_log += "+--- Connecting Turf [T] @ [T.x], [T.y], [T.z]"

	if(active_edges)
		fail("Maps contained [active_edges] active edges at round-start.\n" + edge_log.Join("\n"))
	else
		pass("No active edges.")

	return 1
