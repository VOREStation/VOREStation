
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
