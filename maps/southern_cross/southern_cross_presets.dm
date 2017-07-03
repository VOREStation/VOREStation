var/const/NETWORK_BRIDGE       = "Bridge"
var/const/NETWORK_FIFTH_DECK   = "Fifth Deck"
var/const/NETWORK_FOURTH_DECK  = "Fourth Deck"
var/const/NETWORK_THIRD_DECK   = "Third Deck"
var/const/NETWORK_SECOND_DECK  = "Second Deck"
var/const/NETWORK_FIRST_DECK   = "First Deck"
var/const/NETWORK_POD          = "General Utility Pod"
var/const/NETWORK_SUPPLY       = "Supply"
var/const/NETWORK_MAIN_OUTPOST = "Main Outpost"


/*
/datum/map/torch/get_network_access(var/network)
	switch(network)
		if(NETWORK_AQUILA)
			return access_aquila
		if(NETWORK_BRIDGE)
			return access_heads
		if(NETWORK_CALYPSO)
			return access_calypso
		if(NETWORK_POD)
			return access_guppy
		if(NETWORK_SUPPLY)
			return access_mailsorting
	return get_shared_network_access(network) || ..()
*/

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

//
// T-Coms
//

/obj/machinery/telecomms/relay/preset/shuttle
	id = "Calypso Relay"
	autolinkers = list("s_relay")

/obj/machinery/telecomms/relay/preset/calypso
	id = "Calypso Relay"
	autolinkers = list("s_relay")

/obj/machinery/telecomms/relay/preset/aquila
	id = "Aquila Relay"
	autolinkers = list("s_relay")
