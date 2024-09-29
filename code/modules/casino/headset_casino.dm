/obj/item/radio/headset/casino
	name = "casino headset"
	desc = "An updated, modular intercom that fits over the head with extra comfortable for the hardworking casino luxury crew. Has encryption key for scamm-... Kind casino staff channel."
	icon = 'icons/obj/casino.dmi'
	icon_state = "headset"
	origin_tech = list(TECH_ILLEGAL = 1)
	ks1type = /obj/item/encryptionkey/casino

/obj/item/radio/headset/casino/bowman
	name = "casino bowman headset"
	icon_state = "headset_alt"
	adhoc_fallback = TRUE
	origin_tech = list(TECH_ILLEGAL = 2)

/obj/item/encryptionkey/casino
	icon = 'icons/obj/casino.dmi'
	icon_state = "cypherkey"
	channels = list(CHANNEL_CASINO = 1)
	origin_tech = list(TECH_ILLEGAL = 1)
	syndie = 1
