// ### Preset machines  ###


// #### Relays ####
// Telecomms doesn't know about connected z-levels, so we need relays even for the other surface levels.
/obj/machinery/telecomms/relay/preset/station
	id = "groundbase Relay"
	listening_level = 9
	autolinkers = list("groundbase_relay")

// #### Hub ####
/obj/machinery/telecomms/hub/preset/groundbase
	id = "Hub"
	network = "tcommsat"
	autolinkers = list("hub",
		"groundbase_relay", "c_relay", "m_relay", "r_relay",
		"science", "medical", "supply", "service", "common", "command", "engineering", "security", "explorer", "unused",
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
	autolinkers = list("service", "explorer")

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

/area/maintenance/substation/tcomms
	name = "\improper Telecomms Substation"

/area/maintenance/station/tcomms
	name = "\improper Telecoms Maintenance"

/datum/map/groundbase/default_internal_channels()
	return list(
		num2text(PUB_FREQ) = list(),
		num2text(AI_FREQ)  = list(access_synth),
		num2text(ENT_FREQ) = list(),
		num2text(ERT_FREQ) = list(access_cent_specops),
		num2text(COMM_FREQ)= list(access_heads),
		num2text(ENG_FREQ) = list(access_engine_equip, access_atmospherics),
		num2text(MED_FREQ) = list(access_medical_equip),
		num2text(MED_I_FREQ)=list(access_medical_equip),
		num2text(SEC_FREQ) = list(access_security),
		num2text(SEC_I_FREQ)=list(access_security),
		num2text(SCI_FREQ) = list(access_tox,access_robotics,access_xenobiology),
		num2text(SUP_FREQ) = list(access_cargo),
		num2text(SRV_FREQ) = list(access_janitor, access_hydroponics),
		num2text(EXP_FREQ) = list(access_explorer)
	)

/obj/item/multitool/groundbase_buffered
	name = "pre-linked multitool (groundbase hub)"
	desc = "This multitool has already been linked to the groundbase telecomms hub and can be used to configure one (1) relay."

/obj/item/multitool/groundbase_buffered/Initialize()
	. = ..()
	buffer = locate(/obj/machinery/telecomms/hub/preset/groundbase)

/obj/item/bluespaceradio/groundbase_prelinked
	name = "bluespace radio (Groundbase)"
	handset = /obj/item/radio/bluespacehandset/linked/groundbase_prelinked

/obj/item/radio/bluespacehandset/linked/groundbase_prelinked
	bs_tx_preload_id = "groundbase_rx" //Transmit to a receiver
	bs_rx_preload_id = "groundbase_tx" //Recveive from a transmitter
