/datum/unit_test/apc_area_test
	name = "MAP: Area Test APC / Scrubbers / Vents (Defined Z-Levels)"

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
			area_test_count++
			var/area_good = 1
			var/bad_msg = "--------------- [A.name]([A.type])"

			// Scan for areas with extra APCs
			if(!(A.type in exempt_from_apc))
				if(isnull(A.apc))
					log_unit_test("[bad_msg] lacks an APC. (X[A.x]|Y[A.y]) - Z[A.z])")
					area_good = 0
				else
					var/list/apc_list = list()
					for(var/turf/T in get_current_area_turfs(A))
						for(var/atom/S in T.contents)
							if(istype(S,/obj/machinery/power/apc))
								apc_list.Add(S)
					if(apc_list.len > 1)
						area_good = 0
						for(var/obj/machinery/power/P in apc_list)
							log_unit_test("[bad_msg] has too many APCs. (X[P.x]|Y[P.y]) - Z[P.z])")

			if(!A.air_scrub_info.len && !(A.type in exempt_from_atmos))
				log_unit_test("[bad_msg] lacks an Air scrubber. (X[A.x]|Y[A.y]) - (Z[A.z])")
				area_good = 0

			if(!A.air_vent_info.len && !(A.type in exempt_from_atmos))
				log_unit_test("[bad_msg] lacks an Air vent. (X[A.x]|Y[A.y]) - (Z[A.z])")
				area_good = 0

			if(!area_good)
				bad_areas.Add(A)

	if(bad_areas.len)
		fail("\[[bad_areas.len]/[area_test_count]\]Some areas lacked APCs, Air Scrubbers, or Air vents.")
	else
		pass("All \[[area_test_count]\] areas contained APCs, Air scrubbers, and Air vents.")

	return 1

/datum/unit_test/wire_test
	name = "MAP: Cable Test (Defined Z-Levels)"

/datum/unit_test/wire_test/start_test()
	set background=1

	var/wire_test_count = 0
	var/bad_tests = 0
	var/turf/T = null
	var/obj/structure/cable/C = null
	var/list/cable_turfs = list()
	var/list/dirs_checked = list()

	var/list/exempt_from_wires = list()
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
				if(combined_dir in dirs_checked)
					bad_tests++
					log_unit_test("[bad_msg] Contains multiple wires with same direction on top of each other.")
				if(C.dir != SOUTH)
					bad_tests++
					log_unit_test("[bad_msg] Contains wire with dir set, wires MUST face south, use icon_states.")
				dirs_checked.Add(combined_dir)

		log_unit_test("[color] wires checked.")

	if(bad_tests)
		fail("\[[bad_tests] / [wire_test_count]\] Some turfs had overlapping wires going the same direction.")
	else
		pass("All \[[wire_test_count]\] wires had no overlapping cables going the same direction.")

	return 1

/datum/unit_test/template_noops
	name = "MAP: Template no-ops (all maps)"

/datum/unit_test/template_noops/start_test()

	var/list/log = list()

	var/turf_noop_count = 0
	for(var/turf/template_noop/T in world)
		turf_noop_count++
		log += "+-- Template Turf @ [T.x], [T.y], [T.z] ([T.loc])"

	var/area_noop_count = 0
	for(var/area/template_noop/A in world)
		area_noop_count++
		log += "+-- Template Area"

	if(turf_noop_count || area_noop_count)
		fail("Map contained [turf_noop_count] template turfs and [area_noop_count] template areas at round-start.\n" + log.Join("\n"))
	else
		pass("No template turfs or areas.")

	return 1

/datum/unit_test/active_edges
	name = "MAP: Active edges (all maps)"

/datum/unit_test/active_edges/start_test()

	var/active_edges = SSair.active_edges.len
	var/list/edge_log = list()
	if(active_edges)
		for(var/connection_edge/E in SSair.active_edges)
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

/datum/unit_test/ladder_test
	name = "MAP: Ladder Test"

/datum/unit_test/ladder_test/start_test()
	var/failed = FALSE

	for(var/obj/structure/ladder/L in world)
		var/turf/T = get_turf(L)
		if(!T)
			log_unit_test("[L.x].[L.y].[L.z]: Map - Ladder on invalid turf")
			failed = TRUE
			continue
		if(L.allowed_directions & UP)
			if(!L.target_up)
				log_unit_test("[T.x].[T.y].[T.z]: Map - Ladder allows upward movement, but had no ladder above it")
				failed = TRUE
		if(L.allowed_directions & DOWN)
			if(!L.target_down)
				log_unit_test("[T.x].[T.y].[T.z]: Map - Ladder allows downward movement, but had no ladder beneath it")
				failed = TRUE
		if(T.density)
			log_unit_test("[L.x].[L.y].[L.z]: Map - Ladder is inside a wall")
			failed = TRUE

	if(failed)
		fail("Ladders were incorrectly placed, or missing connections.")
	else
		pass("All ladders were correctly placed and had connections.")
	return failed
