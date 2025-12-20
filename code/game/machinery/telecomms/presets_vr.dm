/obj/machinery/telecomms/relay/preset/houseboat
	id = "Nearby Ship Relay"
	hide = 1
	produces_heat = 0
	autolinkers = list("hb_relay")

/obj/machinery/telecomms/relay/on_changed_z_level(oldz, newz)
	. = ..()
	listening_level = newz
