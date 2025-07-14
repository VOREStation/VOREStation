/datum/commandline_network
	var/datum/owner = null //required
	var/list/nodes = list() //every node in the network that contains commands.
	var/list/nodecaches = list() //moderately complicated structure that lets us cache a target to a given node (or series of)
	//commands that need to be processed
	var/list/command_queue = list()
	var/last_update //timestamp of the last time we were processed
	var/network_flags = NETWORK_TYPE_GENERIC

	var/list/connected_networks = list()
	var/datum/commandline_network/targetted_network //commands go here!

	var/theme = "hex"


	var/name = "" //doesn't need to be unique, but! it probably should!

	var/max_logs = 100 //anything beyond this gets removed, bottom up.
	var/list/logs = list()

/datum/commandline_network/proc/process_command(var/input as text, var/datum/commandline_network_node/source, var/remoteAccess = FALSE)
	if(!remoteAccess)
		if(targetted_network && targetted_network != src)
			return targetted_network.process_command(input,source,TRUE)

	var/datum/commandline_log_entry/log = new
	log.owner = src
	log.command = input
	log.source = source
	add_log(log)

	var/list/tokens = TokenizeString(input)
	if(istext(tokens)) //we got an error from the tokenizer
		log.set_log(src,tokens,COMMAND_OUTPUT_ERROR)
		return

	var/list/categorized_tokens = ParseTokens(tokens)
	if(!islist(categorized_tokens))
		log.set_log(src,categorized_tokens,COMMAND_OUTPUT_ERROR)
		return //error from the parser

	var/prefix = LAZYACCESS(categorized_tokens,COMMAND_ARGUMENT_PREFIX)
	if(prefix == null)
		log.set_log(src,COMMAND_RESULT_NO_PREFIX,COMMAND_OUTPUT_ERROR)
		return
	var/target = LAZYACCESS(categorized_tokens,COMMAND_ARGUMENT_TARGET)
	if(target == null)
		log.set_log(src,COMMAND_RESULT_NO_TARGET,COMMAND_OUTPUT_ERROR)
		return
	var/command = LAZYACCESS(categorized_tokens,COMMAND_ARGUMENT_COMMAND)
	if(command == null)
		log.set_log(src,COMMAND_RESULT_NO_COMMAND,COMMAND_OUTPUT_ERROR)
		return

	//ruled out all the shitty options.
	. = "" //we need this later.

	if((prefix == COMMAND_PREFIX_TARGET_SELF) && source == null) //special handling for this. no idea why it'd ever happen but u never know.
		return COMMAND_RESULT_MISSING_SELF

	var/list/foundNodes = list()
	if(prefix == COMMAND_PREFIX_TARGET_SELF)
		foundNodes = list(source)
	else
		foundNodes = find_nodes(target,prefix)

	if(foundNodes == null)
		log.set_log(src,COMMAND_RESULT_NO_FOUND_TARGETS(target),COMMAND_OUTPUT_ERROR)
		return

	var/verbose = FALSE
	if(COMMAND_PREFIX_CONFIG[prefix][COMMAND_CONFIG_VERBOSE] || contains_verbose_flag(categorized_tokens[COMMAND_ARGUMENT_FLAGS_GLOBAL]))
		verbose = TRUE



	for(var/datum/commandline_network_node/node in foundNodes)
		node.recieve_command(source,categorized_tokens,log,verbose)

	//split up the command
	//find matching nodes based on the target / prefix
	//forward the command to them

/datum/commandline_network/proc/do_command(var/command as text,var/do_now = FALSE)
	//add to the queue, or process it instantly if it's "do now"

/datum/commandline_network/New(var/atom/new_owner, var/new_name)
	owner = owner
	name = new_name
	SScommandline_networks.Initialize_Network(src)

/datum/commandline_network/proc/Initialize()
	SHOULD_NOT_SLEEP(TRUE)
	SHOULD_CALL_PARENT(TRUE)
	name = name + "_[SScommandline_networks.networks_instantiated]"

	//oopies!

/datum/commandline_network/proc/contains_verbose_flag(var/list/flags)
	for(var/flag in flags)
		if(IS_COMMAND_FLAG_VERBOSE(flag)) return TRUE
	return FALSE

//START_PROCESSING(SScommandline_network, src)

/datum/commandline_network/proc/find_nodes(var/query, var/prefix)
	//preprocess the query first
	. = null
	query = ckey(query)

	//consult the cache
	if(prefix == COMMAND_PREFIX_TARGET_ALL)
		return LAZYACCESS(nodecaches,query)

	//first result in the cache
	if(prefix == COMMAND_PREFIX_TARGET_ONCE)
		. = LAZYACCESS(nodecaches,query)
		if(LAZYLEN(.) >= 1)
			return list(LAZYACCESS(.,1))

	//just dump nodes
	if(prefix == COMMAND_PREFIX_TARGET_EVERY)
		return nodes


	if(prefix ==COMMAND_PREFIX_TARGET_NOT)
		. = LAZYACCESS(nodecaches,query)
		var/list/result = nodes
		result.Remove(.)
		return result

/datum/commandline_network/proc/add_node(var/datum/commandline_network_node/to_add)
	nodes |= to_add
	cache_node(to_add)
	if(!to_add.owner)
		to_add.owner = src

/datum/commandline_network/proc/remove_node(var/datum/commandline_network_node/to_remove)
	nodes.Remove(to_remove)
	for(var/key in nodecaches)
		var/list/L = nodecaches[key]
		if(!L) return
		if(L.Remove(to_remove))
			var/list/subcache = nodecaches[key]
			if(!subcache || !islist(subcache)) return
			if(subcache.len == 0)
				nodecaches.Remove(key)

/datum/commandline_network/proc/rebuild_cache()
	nodecaches.Cut()
	for(var/datum/commandline_network_node/to_cache in nodes)
		cache_node(to_cache)

/datum/commandline_network/proc/cache_node(var/datum/commandline_network_node/to_cache)
	if(nodecaches[ckey(to_cache.name)])
		nodecaches[ckey(to_cache.name)] |= to_cache
	else
		nodecaches[ckey(to_cache.name)] = list(to_cache)
	//then we break up the location flags list. yayy.
	for(var/location in to_cache.network_locs)
		if(nodecaches[ckey(location)])
			nodecaches[ckey(location)] |= to_cache
		else
			nodecaches[ckey(location)] = list(to_cache)

/datum/commandline_network/proc/connect_to(var/datum/commandline_network/newConnection)
	connect_to_network(newConnection)
	newConnection.connect_to_network(src)

/datum/commandline_network/proc/connect_to_network(var/datum/commandline_network/newNetwork)
	if(newNetwork in connected_networks)
		return //already in
	LAZYADD(connected_networks,newNetwork)

/datum/commandline_network/proc/disconnect_from(var/datum/commandline_network/removedConnection)
	removedConnection.disconnect_from_network(src)
	disconnect_from_network(removedConnection)

/datum/commandline_network/proc/disconnect_from_network(var/datum/commandline_network/removedConnection)
	LAZYREMOVE(connected_networks,removedConnection)


/datum/commandline_network/proc/add_log(var/datum/commandline_log_entry/newlog)
	LAZYADD(logs,newlog)
	if(max_logs > 0)
		if(LAZYLEN(logs) > max_logs)
			logs.Remove(logs[1]) //remove from the first.

/datum/commandline_network/proc/FetchFirstNodeByFlag(var/flag)
	for(var/datum/commandline_network_node/n in nodes)
		if(n.flags & flag)
			return n //we just need the first one.
