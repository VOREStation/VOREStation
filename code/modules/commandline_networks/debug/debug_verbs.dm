//TODO: Remove 99% of this shit
/mob/verb/test_tokenizer(var/string as text)
	to_chat(usr,string)
	to_chat(usr,"---------------------------")
	var/list/test = TokenizeString(string)
	to_chat(usr, json_encode(test))
	to_chat(usr,"---------------------------")
	var/list/parsed_tokens = ParseTokens(test)
	to_chat(usr,json_encode(parsed_tokens))

/obj/item/testNetworkItem
	var/datum/commandline_network/network
	name = "AUGHH"

/mob/verb/test_networks(var/nodecount as num)
	var/obj/item/testNetworkItem/idiot = new(src.loc)
	idiot.network = new
	for(var/i = 1 to nodecount)
		var/datum/commandline_network_node/testNode/test = new
		test.name = "[test.name][i]"
		test.Initialize()
		idiot.network.add_node(test)

/datum/commandline_network_node/testNode
	name = "TESTNODE"

/datum/commandline_network_node/testNode/Initialize()
	name = "TESTNODE[rand(0,999)]"
	for(var/i = 1 to 3)
		network_locs |= pick(list(CMD_LOC_HEAD,CMD_LOC_EYES,CMD_LOC_TORSO,CMD_LOC_GROIN))
	.=..()


/obj/item/testDatajack
	name = "she be jackin my date till i uh"
	desc = "todo"

/obj/item/testDatajack/Initialize(mapload)
	AddComponent(/datum/component/commandline_network)
	AddComponent(/datum/component/commandline_network_node, nodeType = /datum/commandline_network_node/datajack)
	AddComponent(/datum/component/commandline_network_interface)
	. = ..()

/obj/item/testnetwork
	name = "FUCK"

/obj/item/testnetwork/Initialize(mapload)
	AddComponent(/datum/component/commandline_network)
	AddComponent(/datum/component/commandline_network_node, nodeType = /datum/commandline_network_node/datajack)
	AddComponent(/datum/component/commandline_network_node, nodeType = /datum/commandline_network_node/datajack)
	AddComponent(/datum/component/commandline_network_node, nodeType = /datum/commandline_network_node/datajack)
	AddComponent(/datum/component/commandline_network_node, nodeType = /datum/commandline_network_node/datajack)
	AddComponent(/datum/component/commandline_network_node, nodeType = /datum/commandline_network_node/datajack)
	AddComponent(/datum/component/commandline_network_node, nodeType = /datum/commandline_network_node/datajack)
	AddComponent(/datum/component/commandline_network_node, nodeType = /datum/commandline_network_node/datajack)
	AddComponent(/datum/component/commandline_network_node, nodeType = /datum/commandline_network_node/datajack)
	AddComponent(/datum/component/commandline_network_node, nodeType = /datum/commandline_network_node/datajack)
	AddComponent(/datum/component/commandline_network_node, nodeType = /datum/commandline_network_node/datajack)
	AddComponent(/datum/component/commandline_network_node, nodeType = /datum/commandline_network_node/datajack)
	. = ..()
