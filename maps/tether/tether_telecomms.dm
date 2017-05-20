// ### Preset machines  ###


// #### Relays ####
// Telecomms doesn't know about connected z-levels, so we need relays even for the other surface levels.
/obj/machinery/telecomms/relay/preset/tether/base_low
	id = "Base Relay 1"
	listening_level = Z_LEVEL_SURFACE_LOW
	autolinkers = list("tbl_relay")

/obj/machinery/telecomms/relay/preset/tether/base_mid
	id = "Base Relay 2"
	listening_level = Z_LEVEL_SURFACE_MID
	autolinkers = list("tbm_relay")

/obj/machinery/telecomms/relay/preset/tether/base_high
	id = "Base Relay 3"
	listening_level = Z_LEVEL_SURFACE_HIGH
	autolinkers = list("tbh_relay")

// The station of course needs relays fluff-wise to connect to ground station. But again, no multi-z so, we need one for each z level.
/obj/machinery/telecomms/relay/preset/tether/station_low
	id = "Station Relay 1"
	listening_level = Z_LEVEL_SPACE_LOW
	autolinkers = list("tsl_relay")

/obj/machinery/telecomms/relay/preset/tether/station_mid
	id = "Station Relay 2"
	listening_level = Z_LEVEL_SPACE_MID
	autolinkers = list("tsm_relay")

/obj/machinery/telecomms/relay/preset/tether/station_high
	id = "Station Relay 3"
	listening_level = Z_LEVEL_SPACE_HIGH
	autolinkers = list("tsh_relay")

// #### Hub ####
/obj/machinery/telecomms/hub/preset/tether
	id = "Hub"
	network = "tcommsat"
	autolinkers = list("hub",
		"tbl_relay", "tbm_relay", "tbh_relay", "tsl_relay", "tsm_relay", "tsh_relay",
		"c_relay", "m_relay", "r_relay",
		"science", "medical", "supply", "service", "common", "command", "engineering", "security", "unused",
		"hb_relay", "receiverA", "broadcasterA"
	)

// Telecommunications Satellite
/area/tether/surfacebase/tcomms
	name = "\improper Telecomms"
	ambience = list('sound/ambience/ambisin2.ogg', 'sound/ambience/signal.ogg', 'sound/ambience/signal.ogg', 'sound/ambience/ambigen10.ogg')

/area/tether/surfacebase/tcomms/entrance
	name = "\improper Telecomms Teleporter"
	icon_state = "tcomsatentrance"

/area/tether/surfacebase/tcomms/foyer
	name = "\improper Telecomms Foyer"
	icon_state = "tcomsatfoyer"

/area/tether/surfacebase/tcomms/storage
	name = "\improper Telecomms Storage"
	icon_state = "tcomsatwest"

/area/tether/surfacebase/tcomms/computer
	name = "\improper Telecomms Control Room"
	icon_state = "tcomsatcomp"

/area/tether/surfacebase/tcomms/chamber
	name = "\improper Telecomms Central Compartment"
	icon_state = "tcomsatcham"
	flags = BLUE_SHIELDED

/area/maintenance/substation/tcomms
	name = "\improper Telecomms Substation"

/area/maintenance/station/tcomms
	name = "\improper Telecoms Maintenance"
