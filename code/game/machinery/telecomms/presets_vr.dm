/obj/machinery/telecomms/relay/preset/houseboat
	id = "Nearby Ship Relay"
	hide = 1
	produces_heat = 0
	autolinkers = list("hb_relay")

/obj/machinery/telecomms/relay/onTransitZ(oldz, newz)
	. = ..()
	listening_level = newz
