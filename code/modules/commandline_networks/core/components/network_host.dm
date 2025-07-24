//component that hosts a network. simple as.
// will automatically try to get every node already on the obj upon registering to it.
//nodes are responsible for any attach/detatchment, so we don't need any callbacks!

/datum/component/commandline_network
	dupe_mode = COMPONENT_DUPE_UNIQUE //only one per.
	dupe_type = /datum/component/commandline_network //allow subnetworks
	var/datum/commandline_network/network

/datum/component/commandline_network/Initialize(var/networkType = /datum/commandline_network, var/networkname = "Network")
	network = new networkType(new_name = networkname)

/datum/component/commandline_network/RegisterWithParent()
	var/list/L = parent.GetComponents(/datum/component/commandline_network_node)
	network.owner = parent
	for(var/datum/component/commandline_network_node/node in L)
		network.add_node(node.node)
	. = ..()

/datum/component/commandline_network/UnregisterFromParent()
	qdel(network)
	. = ..()
