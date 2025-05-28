////////////////////////////////////////
// Tether custom shuttle implemnetations
////////////////////////////////////////

/obj/machinery/computer/shuttle_control/tether_backup
	name = "tether backup shuttle control console"
	shuttle_tag = "Tether Backup"
	req_one_access = list()
	ai_control = TRUE

/obj/machinery/computer/shuttle_control/multi/mercenary
	name = "vessel control console"
	shuttle_tag = "Mercenary"
	req_one_access = list(access_syndicate)

/obj/machinery/computer/shuttle_control/multi/ninja
	name = "vessel control console"
	shuttle_tag = "Ninja"
	//req_one_access = list()

/obj/machinery/computer/shuttle_control/multi/specops
	name = "vessel control console"
	shuttle_tag = "NDV Phantom"
	req_one_access = list(access_cent_specops)

/obj/machinery/computer/shuttle_control/multi/trade
	name = "vessel control console"
	shuttle_tag = "Trade"
	req_one_access = list(access_trader)

/obj/machinery/computer/shuttle_control/surface_mining_outpost
	name = "surface mining outpost shuttle control console"
	shuttle_tag = "Mining Outpost"
	req_one_access = list(access_mining)
	ai_control = TRUE

////////////////////////////////////////
//////// Excursion Shuttle /////////////
////////////////////////////////////////
// The 'ship' of the excursion shuttle
/obj/effect/overmap/visitable/ship/landable/excursion
	name = "Excursion Shuttle"
	desc = "The traditional Excursion Shuttle. NT Approved!"
	icon_state = "htu_destroyer_g"
	vessel_mass = 8000
	vessel_size = SHIP_SIZE_SMALL
	shuttle = "Excursion Shuttle"

/obj/machinery/computer/shuttle_control/explore/excursion
	name = "short jump console"
	shuttle_tag = "Excursion Shuttle"
	req_one_access = list(access_pilot)

////////////////////////////////////////
////////      Tour Bus     /////////////
////////////////////////////////////////
// The 'ship' of the excursion shuttle
/obj/effect/overmap/visitable/ship/landable/tourbus
	name = "Tour Bus"
	desc = "A small 'space bus', if you will."
	icon_state = "htu_frigate_g"
	vessel_mass = 2000
	vessel_size = SHIP_SIZE_SMALL
	shuttle = "Tour Bus"

/obj/machinery/computer/shuttle_control/explore/tourbus
	name = "short jump console"
	shuttle_tag = "Tour Bus"
	req_one_access = list(access_pilot)

////////////////////////////////////////
////////      Medivac      /////////////
////////////////////////////////////////
// The 'ship' of the excursion shuttle
/obj/effect/overmap/visitable/ship/landable/medivac
	name = "Medivac Shuttle"
	desc = "A medical evacuation shuttle."
	icon_state = "htu_frigate_g"
	vessel_mass = 4000
	vessel_size = SHIP_SIZE_SMALL
	shuttle = "Medivac Shuttle"
	fore_dir = EAST

/obj/machinery/computer/shuttle_control/explore/medivac
	name = "short jump console"
	shuttle_tag = "Medivac Shuttle"

////////////////////////////////////////
////////      Securiship   /////////////
////////////////////////////////////////
// The 'ship' of the excursion shuttle
/obj/effect/overmap/visitable/ship/landable/securiship
	name = "Securiship Shuttle"
	desc = "A security transport ship."
	icon_state = "htu_frigate_g"
	vessel_mass = 4000
	vessel_size = SHIP_SIZE_SMALL
	shuttle = "Securiship Shuttle"
	fore_dir = EAST

/obj/machinery/computer/shuttle_control/explore/securiship
	name = "short jump console"
	shuttle_tag = "Securiship Shuttle"
