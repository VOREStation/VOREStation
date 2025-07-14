/datum/commandline_network/proc/get_log()
	var/list/outputlogs = list()
	for(var/datum/commandline_log_entry/L in logs)
		outputlogs += list(L.serializeLog())
	return outputlogs

/datum/commandline_network/proc/get_all_logs() //serialized, for TGUI
	var/list/json_nightmare = list()
	json_nightmare += get_log()
	for(var/datum/commandline_network/n in connected_networks)
		json_nightmare += n.get_log()
	return json_nightmare

/datum/commandline_network/proc/getConnectedNetworks()
	. = list()
	for(var/datum/commandline_network/x in connected_networks)
		. += x.name


/datum/commandline_network/proc/export_tgui_data() as list
	var/list/data = list()

	data["networkName"] = name //we need to know the root obj
	data["logs"] = get_all_logs()
	data["networkTree"] = assemble_network_tree()
	return data

/datum/commandline_network/proc/assemble_network_tree(var/list/has_seen = list())
	var/list/network = list() //we return this

	var/list/networks = get_all_connected_networks() - src

	network += make_nodeInstance(TRUE)

	for(var/datum/commandline_network/instance in networks)
		network += instance.make_nodeInstance()

	return network

/datum/commandline_network/proc/get_all_connected_networks()
	var/list/visited = list()
	var/list/to_visit = list(src)

	while(to_visit.len)
		var/datum/commandline_network/current = to_visit[1]
		to_visit.Cut(1, 2)
		if(!(current in visited))
			visited += current
			for(var/datum/commandline_network/conn in current.connected_networks)
				if(!(conn in visited) && !(conn in to_visit))
					to_visit += conn
	return visited

/proc/make_cmd_node_instance(var/name,var/key,var/type,var/list/parents,var/list/children,var/glitch,var/distortion,var/latency)
	var/list/l = list()
	l["name"] = name
	l["key"] = key
	l["Type"] = type
	l["parents"] = parents
	l["children"] = children
	l["glitch"] = glitch
	l["distortion"] = distortion
	l["latency"] = latency
	return l

/datum/commandline_network/proc/make_nodeInstance(var/isowner = FALSE)
	var/list/to_add = list() //we return this, but it's a list of things to append(if not there) to the network graph list

	var/list/nodeIDs = list() //JUST for the parenting
	for(var/datum/commandline_network_node/node in nodes)
		nodeIDs |= "\ref[node]"
		to_add += list(make_cmd_node_instance(node.name,"\ref[node]","subnode",list("\ref[src]"),list(),node.is_glitchy(),node.get_distortion(),node.get_latency()))
		//above needs to be wrapped in a list, thx byond

	for(var/datum/D in connected_networks)
		nodeIDs |= "\ref[D]"

	to_add += list(make_cmd_node_instance(
	src.name, //name
	"\ref[src]", //key/ID
	 isowner ? "localhost" : "node" , //node type
	 list(), //parents
	 nodeIDs, //children
	 FALSE, //glitchy
	 0, //distortion
	 0 //latency
	 )) //this is where we'd represent network-scale distortion / glitchy / etc

	return to_add
