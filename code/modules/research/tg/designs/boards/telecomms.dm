
/datum/design_techweb/board/comm_monitor
	name = "telecommunications monitoring console circuit"
	id = "comm_monitor"
	// req_tech = list(TECH_DATA = 3)
	build_path = /obj/item/circuitboard/comm_monitor
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_TELECOMMS
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/comm_server
	name = "telecommunications server monitoring console circuit"
	id = "comm_server"
	// req_tech = list(TECH_DATA = 3)
	build_path = /obj/item/circuitboard/comm_server
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_TELECOMMS
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/message_monitor
	name = "messaging monitor console circuit"
	id = "message_monitor"
	// req_tech = list(TECH_DATA = 5)
	build_path = /obj/item/circuitboard/message_monitor
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_TELECOMMS
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/tcom
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_TELECOMMS
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/tcom/server
	name = "server mainframe circuit"
	id = "tcom-server"
	build_path = /obj/item/circuitboard/telecomms/server

/datum/design_techweb/board/tcom/processor
	name = "processor unit circuit"
	id = "tcom-processor"
	build_path = /obj/item/circuitboard/telecomms/processor

/datum/design_techweb/board/tcom/bus
	name = "bus mainframe circuit"
	id = "tcom-bus"
	build_path = /obj/item/circuitboard/telecomms/bus

/datum/design_techweb/board/tcom/hub
	name = "hub mainframe circuit"
	id = "tcom-hub"
	build_path = /obj/item/circuitboard/telecomms/hub

/datum/design_techweb/board/tcom/relay
	name = "relay mainframe circuit"
	id = "tcom-relay"
	// req_tech = list(TECH_DATA = 3, TECH_ENGINEERING = 4, TECH_BLUESPACE = 3)
	build_path = /obj/item/circuitboard/telecomms/relay

/datum/design_techweb/board/tcom/broadcaster
	name = "subspace broadcaster circuit"
	id = "tcom-broadcaster"
	// req_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 4, TECH_BLUESPACE = 2)
	build_path = /obj/item/circuitboard/telecomms/broadcaster

/datum/design_techweb/board/tcom/receiver
	name = "subspace receiver circuit"
	id = "tcom-receiver"
	// req_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 3, TECH_BLUESPACE = 2)
	build_path = /obj/item/circuitboard/telecomms/receiver

/datum/design_techweb/board/tcom/exonet_node
	name = "exonet node circuit"
	id = "tcom-exonet_node"
	// req_tech = list(TECH_DATA = 5, TECH_ENGINEERING = 5, TECH_BLUESPACE = 4)
	build_path = /obj/item/circuitboard/telecomms/exonet_node

/datum/design_techweb/board/ntnet_relay
	name = "NTNet Quantum Relay circuit"
	id = "ntnet_relay"
	// req_tech = list(TECH_DATA = 4)
	build_path = /obj/item/circuitboard/ntnet_relay
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_TELECOMMS
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

// Telecomm parts
/datum/design_techweb/subspace
	build_type = PROTOLATHE
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_TELECOMMS
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/subspace/New()
	. = ..()

	var/obj/object_build_item_path = build_path
	name = "Subspace component design ([initial(object_build_item_path.name)])"

/datum/design_techweb/subspace/subspace_ansible
	id = "s-ansible"
	// req_tech = list(TECH_DATA = 3, TECH_MAGNET = 4, TECH_MATERIAL = 4, TECH_BLUESPACE = 2)
	materials = list(MAT_STEEL = 80, MAT_SILVER = 20)
	build_path = /obj/item/stock_parts/subspace/ansible

/datum/design_techweb/subspace/hyperwave_filter
	id = "s-filter"
	// req_tech = list(TECH_DATA = 3, TECH_MAGNET = 3)
	materials = list(MAT_STEEL = 40, MAT_SILVER = 10)
	build_path = /obj/item/stock_parts/subspace/sub_filter

/datum/design_techweb/subspace/subspace_amplifier
	id = "s-amplifier"
	// req_tech = list(TECH_DATA = 3, TECH_MAGNET = 4, TECH_MATERIAL = 4, TECH_BLUESPACE = 2)
	materials = list(MAT_STEEL = 10, MAT_GOLD = 30, MAT_URANIUM = 15)
	build_path = /obj/item/stock_parts/subspace/amplifier

/datum/design_techweb/subspace/subspace_treatment
	id = "s-treatment"
	// req_tech = list(TECH_DATA = 3, TECH_MAGNET = 2, TECH_MATERIAL = 4, TECH_BLUESPACE = 2)
	materials = list(MAT_STEEL = 10, MAT_SILVER = 20)
	build_path = /obj/item/stock_parts/subspace/treatment

/datum/design_techweb/subspace/subspace_analyzer
	id = "s-analyzer"
	// req_tech = list(TECH_DATA = 3, TECH_MAGNET = 4, TECH_MATERIAL = 4, TECH_BLUESPACE = 2)
	materials = list(MAT_STEEL = 10, MAT_GOLD = 15)
	build_path = /obj/item/stock_parts/subspace/analyzer

/datum/design_techweb/subspace/subspace_crystal
	id = "s-crystal"
	// req_tech = list(TECH_MAGNET = 4, TECH_MATERIAL = 4, TECH_BLUESPACE = 2)
	materials = list(MAT_GLASS = 1000, MAT_SILVER = 20, MAT_GOLD = 20)
	build_path = /obj/item/stock_parts/subspace/crystal

/datum/design_techweb/subspace/subspace_transmitter
	id = "s-transmitter"
	// req_tech = list(TECH_MAGNET = 5, TECH_MATERIAL = 5, TECH_BLUESPACE = 3)
	materials = list(MAT_GLASS = 100, MAT_SILVER = 10, MAT_URANIUM = 15)
	build_path = /obj/item/stock_parts/subspace/transmitter
