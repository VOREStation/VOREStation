var/const/NETWORK_BRIDGE       = "Bridge"
var/const/NETWORK_FIFTH_DECK   = "Fifth Deck"
var/const/NETWORK_FOURTH_DECK  = "Fourth Deck"
var/const/NETWORK_THIRD_DECK   = "Third Deck"
var/const/NETWORK_SECOND_DECK  = "Second Deck"
var/const/NETWORK_FIRST_DECK   = "First Deck"
var/const/NETWORK_POD          = "General Utility Pod"
var/const/NETWORK_SUPPLY       = "Supply"
var/const/NETWORK_MAIN_OUTPOST = "Main Outpost"

/datum/map/southern_cross
	// Networks that will show up as options in the camera monitor program
	station_networks = list(
		NETWORK_BRIDGE,,
		NETWORK_ENGINE,
		NETWORK_FIFTH_DECK,
		NETWORK_FOURTH_DECK,
		NETWORK_THIRD_DECK,
		NETWORK_SECOND_DECK,
		NETWORK_FIRST_DECK,
		NETWORK_ROBOTS,
		NETWORK_POD,
		NETWORK_SUPPLY,
		NETWORK_COMMAND,
		NETWORK_ENGINEERING,
		NETWORK_MEDICAL,
		NETWORK_MAIN_OUTPOST,
		NETWORK_RESEARCH,
		NETWORK_SECURITY,
		NETWORK_THUNDER,
	)

//
// Cameras
//

// Networks
/obj/machinery/camera/network/bridge
	network = list(NETWORK_BRIDGE)

/obj/machinery/camera/network/fifth_deck
	network = list(NETWORK_FIFTH_DECK)

/obj/machinery/camera/network/fourth_deck
	network = list(NETWORK_FOURTH_DECK)

/obj/machinery/camera/network/third_deck
	network = list(NETWORK_THIRD_DECK)

/obj/machinery/camera/network/second_deck
	network = list(NETWORK_SECOND_DECK)

/obj/machinery/camera/network/first_deck
	network = list(NETWORK_FIRST_DECK)

/obj/machinery/camera/network/main_outpost
	network = list(NETWORK_MAIN_OUTPOST)

/obj/machinery/camera/network/pod
	network = list(NETWORK_POD)

/obj/machinery/camera/network/supply
	network = list(NETWORK_SUPPLY)

// ### Preset machines  ###


// #### Relays ####
// Telecomms doesn't know about connected z-levels, so we need relays even for the other surface levels.
/obj/machinery/telecomms/relay/preset/southerncross/d1
	id = "Station Relay 1"
	autolinkers = list("d1_relay")

/obj/machinery/telecomms/relay/preset/southerncross/d2
	id = "Station Relay 2"
	autolinkers = list("d2_relay")

/obj/machinery/telecomms/relay/preset/southerncross/d3
	id = "Station Relay 3"
	autolinkers = list("d3_relay")

/obj/machinery/telecomms/relay/preset/southerncross/planet
	id = "Planet Relay"
	autolinkers = list("pnt_relay")

// #### Hub ####
/obj/machinery/telecomms/hub/preset/southerncross
	id = "Hub"
	network = "tcommsat"
	autolinkers = list("hub",
		"d1_relay", "d2_relay", "d3_relay", "pnt_relay",
		"c_relay", "m_relay", "r_relay",
		"science", "medical", "supply", "service", "common", "command", "engineering", "security", "unused",
		"hb_relay", "receiverA", "broadcasterA"
	)