// #### Relays ####
// Telecomms doesn't know about connected z-levels, so we need relays even for the other surface levels.
/obj/machinery/telecomms/relay/preset/station
	id = "Tether Relay"
	autolinkers = list("tether_relay")

/datum/map/tether/default_internal_channels()
	return list(
		num2text(PUB_FREQ) = list(),
		num2text(AI_FREQ)  = list(ACCESS_SYNTH),
		num2text(ENT_FREQ) = list(),
		num2text(ERT_FREQ) = list(ACCESS_CENT_SPECOPS),
		num2text(COMM_FREQ)= list(ACCESS_HEADS),
		num2text(ENG_FREQ) = list(ACCESS_ENGINE_EQUIP, ACCESS_ATMOSPHERICS),
		num2text(MED_FREQ) = list(ACCESS_MEDICAL_EQUIP),
		num2text(MED_I_FREQ)=list(ACCESS_MEDICAL_EQUIP),
		num2text(SEC_FREQ) = list(ACCESS_SECURITY),
		num2text(SEC_I_FREQ)=list(ACCESS_SECURITY),
		num2text(SCI_FREQ) = list(ACCESS_TOX,ACCESS_ROBOTICS,ACCESS_XENOBIOLOGY),
		num2text(SUP_FREQ) = list(ACCESS_CARGO),
		num2text(SRV_FREQ) = list(ACCESS_JANITOR, ACCESS_HYDROPONICS),
		num2text(EXP_FREQ) = list(ACCESS_EXPLORER)
	)

/obj/item/multitool/station_buffered
	name = "pre-linked multitool (tether hub)"
	desc = "This multitool has already been linked to the Tether telecomms hub and can be used to configure one (1) relay."

/obj/item/multitool/station_buffered/Initialize(mapload)
	. = ..()
	buffer = locate(/obj/machinery/telecomms/hub/preset/tether)
