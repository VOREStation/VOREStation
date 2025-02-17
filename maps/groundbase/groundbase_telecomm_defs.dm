// #### Hub ####
/obj/machinery/telecomms/hub/preset/groundbase
	id = "Hub"
	network = "tcommsat"
	autolinkers = list("hub",
		"groundbase_relay", "c_relay", "m_relay", "r_relay",
		"science", "medical", "supply", "service", "common", "command", "engineering", "security", "Away Team", "unused",
		"hb_relay", "receiverA", "broadcasterA"
	)

/obj/machinery/telecomms/receiver/preset_right/groundbase
	id = "groundbase_rx"
	freq_listening = list(AI_FREQ, SCI_FREQ, MED_FREQ, SUP_FREQ, SRV_FREQ, COMM_FREQ, ENG_FREQ, SEC_FREQ, ENT_FREQ, EXP_FREQ)

/obj/machinery/telecomms/broadcaster/preset_right/groundbase
	id = "groundbase_tx"

/obj/machinery/telecomms/bus/preset_two/groundbase
	freq_listening = list(SUP_FREQ, SRV_FREQ, EXP_FREQ)

/obj/machinery/telecomms/server/presets/service/groundbase
	freq_listening = list(SRV_FREQ, EXP_FREQ)
	autolinkers = list("service", "Away Team")

// Telecommunications Satellite
/area/groundbase/command/tcomms
	name = "\improper Telecomms"
	ambience = list('sound/ambience/ambisin2.ogg', 'sound/ambience/signal.ogg', 'sound/ambience/signal.ogg')

/area/groundbase/command/tcomms/entrance
	name = "\improper Telecomms Teleporter"

/area/groundbase/command/tcomms/foyer
	name = "\improper Telecomms Foyer"

/area/groundbase/command/tcomms/storage
	name = "\improper Telecomms Storage"

/area/groundbase/command/tcomms/computer
	name = "\improper Telecomms Control Room"

/area/groundbase/command/tcomms/chamber
	name = "\improper Telecomms Central Compartment"
	flags = BLUE_SHIELDED

/obj/item/bluespaceradio/groundbase_prelinked
	name = "bluespace radio (Rascal's Pass)"
	handset = /obj/item/radio/bluespacehandset/linked/groundbase_prelinked

/obj/item/radio/bluespacehandset/linked/groundbase_prelinked
	bs_tx_preload_id = "groundbase_rx" //Transmit to a receiver
	bs_rx_preload_id = "groundbase_tx" //Recveive from a transmitter
