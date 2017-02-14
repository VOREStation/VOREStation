/obj/machinery/computer/shuttle_control/multi/admin
	name = "centcom shuttle control console"
	req_access = list(access_cent_general)
	shuttle_tag = "Administration"

/obj/machinery/computer/shuttle_control/multi/awaymission
	name = "exploration shuttle control console"
	req_access = list(access_gateway)
	shuttle_tag = "AwayMission"

/obj/machinery/computer/shuttle_control/belter
	name = "belter control console"
	req_access = list(access_mining)
	// shuttle_tag = "Belter" //The scanning console needs to enable/disable this at will.

/obj/machinery/computer/shuttle_control/mining
	name = "mining elevator control console"

/obj/machinery/computer/shuttle_control/engineering
	name = "engineering elevator control console"

/obj/machinery/computer/shuttle_control/research
	name = "research elevator control console"
