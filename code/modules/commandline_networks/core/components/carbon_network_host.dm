/datum/component/commandline_network/carbon

/datum/component/commandline_network/carbon/Initialize(var/networkType = /datum/commandline_network)
	if(iscarbon(parent))
		var/mob/living/carbon/target = parent
		network = new networkType(new_name = ckey(target.name))
		target.cmdNetwork = network
	else
		return COMPONENT_INCOMPATIBLE


/datum/component/commandline_network/RegisterWithParent()
	var/list/L = parent.GetComponents(/datum/component/commandline_network_node)
	network.owner = parent
	for(var/datum/component/commandline_network_node/node in L)
		network.add_node(node.node)
	. = ..()

/datum/component/commandline_network/UnregisterFromParent()
	qdel(network)
	. = ..()
