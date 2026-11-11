//utilized for universal adapters to stop reporting that they're unconnected on pipe check
/proc/universal_adapter_connected_ends(obj/machinery/atmospherics/pipe/simple/adapter)
	var/list/layer_connections
	if (istype(adapter, /obj/machinery/atmospherics/pipe/simple/visible/universal))
		var/obj/machinery/atmospherics/pipe/simple/visible/universal/visible_adapter = adapter
		layer_connections = visible_adapter.universal_nodes
	else if (istype(adapter, /obj/machinery/atmospherics/pipe/simple/hidden/universal))
		var/obj/machinery/atmospherics/pipe/simple/hidden/universal/hidden_adapter = adapter
		layer_connections = hidden_adapter.universal_nodes
	else
		return null

	var/first_end_connected = FALSE
	var/second_end_connected = FALSE
	for (var/list/connections in layer_connections)
		if (connections[1])
			first_end_connected = TRUE
		if (connections[2])
			second_end_connected = TRUE
	return first_end_connected + second_end_connected

ADMIN_VERB_VISIBILITY(atmosscan, ADMIN_VERB_VISIBLITY_FLAG_LOCALHOST)
ADMIN_VERB(atmosscan, R_DEBUG, "Check Piping", "Check all pipes in game (Only use on a test server).", ADMIN_CATEGORY_MAPPING)
	set background = 1

	feedback_add_details("admin_verb","CP") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

	if(tgui_alert(user, "WARNING: This command should not be run on a live server. Do you want to continue?", "Check Piping", list("No", "Yes")) != "Yes")
		return

	to_chat(user, span_debug_info("Checking for disconnected pipes..."))
	//all plumbing - yes, some things might get stated twice, doesn't matter.
	for (var/obj/machinery/atmospherics/plumbing in GLOB.machines)
		if (plumbing.nodealert)
			to_chat(user, span_filter_adminlog(span_red("Unconnected [plumbing.name] located at ([get_area(plumbing.loc)]) [ADMIN_COORDJMP(plumbing.loc)]")))

	//Manifolds
	for (var/obj/machinery/atmospherics/pipe/manifold/pipe in GLOB.machines)
		if (!pipe.node1 || !pipe.node2 || !pipe.node3)
			to_chat(user, span_filter_adminlog(span_red("Unconnected [pipe.name] located at ([get_area(pipe.loc)]) [ADMIN_COORDJMP(pipe.loc)]")))

	//Pipes
	for (var/obj/machinery/atmospherics/pipe/simple/pipe in GLOB.machines)
		//universal adaptor check
		var/universal_ends = universal_adapter_connected_ends(pipe)
		if (!isnull(universal_ends))
			if (universal_ends < 2)
				to_chat(user, span_filter_adminlog(span_red("Unconnected [pipe.name] located at ([get_area(pipe.loc)]) [ADMIN_COORDJMP(pipe.loc)] - only [universal_ends] of its 2 ends are connected")))
			continue
		if (!pipe.node1 || !pipe.node2)
			to_chat(user, span_filter_adminlog(span_red("Unconnected [pipe.name] located at ([get_area(pipe.loc)]) [ADMIN_COORDJMP(pipe.loc)]")))

	to_chat(user, span_debug_info("Checking for overlapping pipes..."))
	next_turf:
		for(var/turf/T in world)
			for(var/dir in GLOB.cardinal)
				var/list/connect_types = list(0, 0, 0)
				for(var/obj/machinery/atmospherics/pipe in T)
					if(dir & pipe.initialize_directions)
						for(var/connect_type in pipe.connect_types)
							connect_types[connect_type] += 1
						if(connect_types[1] > 1 || connect_types[2] > 1 || connect_types[3] > 1)
							to_chat(user, span_filter_adminlog(span_red("Overlapping pipe ([pipe.name]) located at [ADMIN_COORDJMP(pipe.loc)]")))
							continue next_turf
	to_chat(user, span_debug_info("Done"))

ADMIN_VERB_VISIBILITY(powerdebug, ADMIN_VERB_VISIBLITY_FLAG_LOCALHOST)
ADMIN_VERB(powerdebug, R_DEBUG, "Check Power", "Checks all powernets (Only use on a test server).", ADMIN_CATEGORY_MAPPING)
	feedback_add_details("admin_verb","CPOW") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

	for(var/datum/powernet/PN in SSmachines.powernets)
		var/cable_count = length(PN.cables)
		if(!cable_count)
			continue

		var/obj/structure/cable/C = PN.cables[1]
		// check for a single cable, don't spam further
		if(cable_count == 1)
			to_chat(user, span_filter_adminlog(span_red("Powernet is a single cable! - cable at ([get_area(C.loc)]) [ADMIN_COORDJMP(C.loc)]")))
			continue

		var/list/problems = list()
		if(!length(PN.nodes))
			problems += "no nodes"
		if(cable_count < 10)
			problems += "fewer than 10 cables ([cable_count])"
		if(!length(problems))
			continue

		to_chat(user, span_filter_adminlog(span_red("Powernet with [english_list(problems)]! (Powernet number: [PN.number]) - cable at ([get_area(C.loc)]) [ADMIN_COORDJMP(C.loc)]")))
