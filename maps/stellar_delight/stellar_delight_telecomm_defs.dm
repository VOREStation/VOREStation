// #### Hub ####
/obj/machinery/telecomms/hub/preset/sd
	id = "Hub"
	network = "tcommsat"
	autolinkers = list("hub",
		"sd_relay", "c_relay", "m_relay", "r_relay",
		"science", "medical", "supply", "service", "common", "command", "engineering", "security", "Away Team", "unused",
		"hb_relay", "receiverA", "broadcasterA"
	)

/obj/machinery/telecomms/receiver/preset_right/sd
	id = "sd_rx"
	freq_listening = list(AI_FREQ, SCI_FREQ, MED_FREQ, SUP_FREQ, SRV_FREQ, COMM_FREQ, ENG_FREQ, SEC_FREQ, ENT_FREQ, EXP_FREQ)

/obj/machinery/telecomms/broadcaster/preset_right/sd
	id = "sd_tx"

/obj/machinery/telecomms/bus/preset_two/sd
	freq_listening = list(SUP_FREQ, SRV_FREQ, EXP_FREQ)

/obj/machinery/telecomms/server/presets/service/sd
	freq_listening = list(SRV_FREQ, EXP_FREQ)
	autolinkers = list("service", "Away Team")

// Telecommunications Satellite
/area/sd/surfacebase/tcomms
	name = "\improper Telecomms"
	ambience = list('sound/ambience/ambisin2.ogg', 'sound/ambience/signal.ogg', 'sound/ambience/signal.ogg')

/area/sd/surfacebase/tcomms/entrance
	name = "\improper Telecomms Teleporter"
	icon_state = "tcomsatentrance"

/area/sd/surfacebase/tcomms/foyer
	name = "\improper Telecomms Foyer"
	icon_state = "tcomsatfoyer"

/area/sd/surfacebase/tcomms/storage
	name = "\improper Telecomms Storage"
	icon_state = "tcomsatwest"

/area/sd/surfacebase/tcomms/computer
	name = "\improper Telecomms Control Room"
	icon_state = "tcomsatcomp"

/area/sd/surfacebase/tcomms/chamber
	name = "\improper Telecomms Central Compartment"
	icon_state = "tcomsatcham"
	flags = BLUE_SHIELDED

/obj/item/bluespaceradio/sd_prelinked
	name = "bluespace radio (Stellar Delight)"
	handset = /obj/item/radio/bluespacehandset/linked/sd_prelinked

/obj/item/radio/bluespacehandset/linked/sd_prelinked
	bs_tx_preload_id = "sd_rx" //Transmit to a receiver
	bs_rx_preload_id = "sd_tx" //Recveive from a transmitter
