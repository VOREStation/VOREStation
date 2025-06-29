/datum/component/commandline_network_node
	dupe_mode = COMPONENT_DUPE_ALLOWED
	var/datum/commandline_network_node/node

/datum/component/commandline_network_node/Initialize(var/nodeType)
	node = new nodeType
	node.Initialize()
	. = ..()

/datum/component/commandline_network_node/RegisterWithParent()
	var/datum/component/commandline_network/network = parent.GetComponent(/datum/component/commandline_network)
	if(network)
		network.network.add_node(node)


/datum/component/commandline_network_node/UnregisterFromParent()
	var/datum/component/commandline_network/network = parent.GetComponent(/datum/component/commandline_network)
	if(network)
		network.network.remove_node(node)
