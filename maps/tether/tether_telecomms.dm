// ### Preset machines  ###


// #### Relays ####
// Telecomms doesn't know about connected z-levels, so we need relays even for the other surface levels.
/obj/machinery/telecomms/relay/preset/tether/base_low
	id = "Base Relay 1"
	listening_level = Z_LEVEL_SURFACE_LOW
	autolinkers = list("tbl_relay")

/obj/machinery/telecomms/relay/preset/centcom/tether/base_low
	listening_level = Z_LEVEL_SURFACE_LOW

/obj/machinery/telecomms/relay/preset/tether/base_mid
	id = "Base Relay 2"
	listening_level = Z_LEVEL_SURFACE_MID
	autolinkers = list("tbm_relay")

/obj/machinery/telecomms/relay/preset/centcom/tether/base_mid
	listening_level = Z_LEVEL_SURFACE_MID

/obj/machinery/telecomms/relay/preset/tether/base_high
	id = "Base Relay 3"
	listening_level = Z_LEVEL_SURFACE_HIGH
	autolinkers = list("tbh_relay")

/obj/machinery/telecomms/relay/preset/centcom/tether/base_high
	listening_level = Z_LEVEL_SURFACE_HIGH

//Some coverage for midpoint
/obj/machinery/telecomms/relay/preset/tether/midpoint
	id = "Midpoint Relay"
	listening_level = Z_LEVEL_TRANSIT
	autolinkers = list("tmp_relay")

/obj/machinery/telecomms/relay/preset/centcom/tether/midpoint
	listening_level = Z_LEVEL_TRANSIT

// The station of course needs relays fluff-wise to connect to ground station. But again, no multi-z so, we need one for each z level.
/obj/machinery/telecomms/relay/preset/tether/station_low
	id = "Station Relay 1"
	listening_level = Z_LEVEL_SPACE_LOW
	autolinkers = list("tsl_relay")

/obj/machinery/telecomms/relay/preset/centcom/tether/station_low
	listening_level = Z_LEVEL_SPACE_LOW

/obj/machinery/telecomms/relay/preset/tether/station_mid
	id = "Station Relay 2"
	listening_level = Z_LEVEL_SPACE_MID
	autolinkers = list("tsm_relay")

/obj/machinery/telecomms/relay/preset/centcom/tether/station_mid
	listening_level = Z_LEVEL_SPACE_MID

/obj/machinery/telecomms/relay/preset/tether/station_high
	id = "Station Relay 3"
	listening_level = Z_LEVEL_SPACE_HIGH
	autolinkers = list("tsh_relay")

/obj/machinery/telecomms/relay/preset/centcom/tether/station_high
	listening_level = Z_LEVEL_SPACE_HIGH

/obj/machinery/telecomms/relay/preset/tether/sci_outpost
	id = "Science Outpost Relay"
	listening_level = Z_LEVEL_SOLARS
	autolinkers = list("sci_o_relay")

/obj/machinery/telecomms/relay/preset/centcom/tether/sci_outpost
	listening_level = Z_LEVEL_SOLARS

/obj/machinery/telecomms/relay/preset/underdark
	id = "Mining Underground Relay"
	listening_level = Z_LEVEL_UNDERDARK
	autolinkers = list("ud_relay")

/obj/machinery/telecomms/relay/preset/centcom/underdark
	listening_level = Z_LEVEL_UNDERDARK

// #### Hub ####
/obj/machinery/telecomms/hub/preset/tether
	id = "Hub"
	network = "tcommsat"
	autolinkers = list("hub",
		"tbl_relay", "tbm_relay", "tbh_relay", "tmp_relay", "tsl_relay", "tsm_relay", "tsh_relay",
		"c_relay", "m_relay", "r_relay", "sci_o_relay", "ud_relay",
		"science", "medical", "supply", "service", "common", "command", "engineering", "security", "explorer", "unused",
		"hb_relay", "receiverA", "broadcasterA"
	)

/obj/machinery/telecomms/receiver/preset_right/tether
	freq_listening = list(AI_FREQ, SCI_FREQ, MED_FREQ, SUP_FREQ, SRV_FREQ, COMM_FREQ, ENG_FREQ, SEC_FREQ, ENT_FREQ, EXP_FREQ)

/obj/machinery/telecomms/bus/preset_two/tether
	freq_listening = list(SUP_FREQ, SRV_FREQ, EXP_FREQ)

/obj/machinery/telecomms/server/presets/service/tether
	freq_listening = list(SRV_FREQ, EXP_FREQ)
	autolinkers = list("service", "explorer")

// Telecommunications Satellite
/area/tether/surfacebase/tcomms
	name = "\improper Telecomms"
	ambience = list('sound/ambience/ambisin2.ogg', 'sound/ambience/signal.ogg', 'sound/ambience/signal.ogg')

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

/datum/map/tether/default_internal_channels()
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

/obj/item/device/multitool/tether_buffered
	name = "pre-linked multitool (tether hub)"
	desc = "This multitool has already been linked to the Tether telecomms hub and can be used to configure one (1) relay."

/obj/item/device/multitool/tether_buffered/Initialize()
	. = ..()
	buffer = locate(/obj/machinery/telecomms/hub/preset/tether)
