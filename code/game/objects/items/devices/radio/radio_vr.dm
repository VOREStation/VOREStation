/obj/item/device/radio/phone
	subspace_transmission = 1
	canhear_range = 0
	adhoc_fallback = TRUE

/obj/item/device/radio/emergency
	name = "Medbay Emergency Radio Link"
	icon_state = "med_walkietalkie"
	frequency = MED_I_FREQ
	subspace_transmission = 1
	adhoc_fallback = TRUE

/obj/item/device/radio/emergency/New()
	..()
	internal_channels = default_medbay_channels.Copy()



/obj/item/device/bluespaceradio/tether_prelinked
	name = "bluespace radio (tether)"
	handset = /obj/item/device/radio/bluespacehandset/linked/tether_prelinked

/obj/item/device/radio/bluespacehandset/linked/tether_prelinked
	bs_tx_preload_id = "tether_rx" //Transmit to a receiver
	bs_rx_preload_id = "tether_tx" //Recveive from a transmitter

/obj/item/device/bluespaceradio/talon_prelinked
	name = "bluespace radio (talon)"
	handset = /obj/item/device/radio/bluespacehandset/linked/talon_prelinked

/obj/item/device/radio/bluespacehandset/linked/talon_prelinked
	bs_tx_preload_id = "talon_aio" //Transmit to a receiver
	bs_rx_preload_id = "talon_aio" //Recveive from a transmitter