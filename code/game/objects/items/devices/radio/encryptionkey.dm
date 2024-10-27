
/obj/item/encryptionkey/
	name = "standard encryption key"
	desc = "An encryption key for a radio headset. Contains cypherkeys."
	icon = 'icons/obj/radio.dmi'
	icon_state = "cypherkey"
	w_class = ITEMSIZE_TINY
	slot_flags = SLOT_EARS
	var/translate_binary = 0
	var/translate_hive = 0
	var/syndie = 0
	var/list/channels = list()

/obj/item/encryptionkey/attackby(obj/item/W as obj, mob/user as mob)

/obj/item/encryptionkey/syndicate
	icon_state = "syn_cypherkey"
	channels = list(CHANNEL_MERCENARY = 1)
	origin_tech = list(TECH_ILLEGAL = 3)
	syndie = 1//Signifies that it de-crypts Syndicate transmissions

/obj/item/encryptionkey/raider
	icon_state = "cypherkey"
	channels = list(CHANNEL_RAIDER = 1)
	origin_tech = list(TECH_ILLEGAL = 2)
	syndie = 1

/obj/item/encryptionkey/binary
	icon_state = "bin_cypherkey"
	translate_binary = 1
	origin_tech = list(TECH_ILLEGAL = 3)

/obj/item/encryptionkey/headset_sec
	name = "security radio encryption key"
	icon_state = "sec_cypherkey"
	channels = list(CHANNEL_SECURITY = 1)

/obj/item/encryptionkey/headset_eng
	name = "engineering radio encryption key"
	icon_state = "eng_cypherkey"
	channels = list(CHANNEL_ENGINEERING = 1)

/obj/item/encryptionkey/headset_rob
	name = "robotics radio encryption key"
	icon_state = "rob_cypherkey"
	channels = list(CHANNEL_ENGINEERING = 1, CHANNEL_SCIENCE = 1)

/obj/item/encryptionkey/headset_med
	name = "medical radio encryption key"
	icon_state = "med_cypherkey"
	channels = list(CHANNEL_MEDICAL = 1)

/obj/item/encryptionkey/headset_sci
	name = "science radio encryption key"
	icon_state = "sci_cypherkey"
	channels = list(CHANNEL_SCIENCE = 1)

/obj/item/encryptionkey/headset_medsci
	name = "medical research radio encryption key"
	icon_state = "medsci_cypherkey"
	channels = list(CHANNEL_MEDICAL = 1, CHANNEL_SCIENCE = 1)

/obj/item/encryptionkey/headset_com
	name = "command radio encryption key"
	icon_state = "com_cypherkey"
	channels = list(CHANNEL_COMMAND = 1)

/obj/item/encryptionkey/heads/captain
	name = "site manager's encryption key"
	icon_state = "cap_cypherkey"
	channels = list(CHANNEL_COMMAND = 1, CHANNEL_SECURITY = 1, CHANNEL_ENGINEERING = 1, CHANNEL_SCIENCE = 1, CHANNEL_MEDICAL = 1, CHANNEL_SUPPLY = 1, CHANNEL_SERVICE = 1)

/obj/item/encryptionkey/heads/ai_integrated
	name = "ai integrated encryption key"
	desc = "Integrated encryption key"
	icon_state = "cap_cypherkey"
	channels = list(CHANNEL_COMMAND = 1, CHANNEL_SECURITY = 1, CHANNEL_ENGINEERING = 1, CHANNEL_SCIENCE = 1, CHANNEL_MEDICAL = 1, CHANNEL_SUPPLY = 1, CHANNEL_SERVICE = 1, CHANNEL_AI_PRIVATE = 1)

/obj/item/encryptionkey/heads/rd
	name = "research director's encryption key"
	icon_state = "rd_cypherkey"
	channels = list(CHANNEL_SCIENCE = 1, CHANNEL_COMMAND = 1)

/obj/item/encryptionkey/heads/hos
	name = "head of security's encryption key"
	icon_state = "hos_cypherkey"
	channels = list(CHANNEL_SECURITY = 1, CHANNEL_COMMAND = 1)

/obj/item/encryptionkey/heads/ce
	name = "chief engineer's encryption key"
	icon_state = "ce_cypherkey"
	channels = list(CHANNEL_ENGINEERING = 1, CHANNEL_COMMAND = 1)

/obj/item/encryptionkey/heads/cmo
	name = "chief medical officer's encryption key"
	icon_state = "cmo_cypherkey"
	channels = list(CHANNEL_MEDICAL = 1, CHANNEL_COMMAND = 1)

/obj/item/encryptionkey/heads/hop
	name = "head of personnel's encryption key"
	icon_state = "hop_cypherkey"
	channels = list(CHANNEL_SUPPLY = 1, CHANNEL_SERVICE = 1, CHANNEL_COMMAND = 1, CHANNEL_SECURITY = 1)
/*
/obj/item/encryptionkey/headset_mine
	name = "mining radio encryption key"
	icon_state = "mine_cypherkey"
	channels = list("Mining" = 1)

/obj/item/encryptionkey/heads/qm
	name = "quartermaster's encryption key"
	icon_state = "qm_cypherkey"
	channels = list("Cargo" = 1, "Mining" = 1)
*/
/obj/item/encryptionkey/headset_cargo
	name = "supply radio encryption key"
	icon_state = "cargo_cypherkey"
	channels = list(CHANNEL_SUPPLY = 1)

/obj/item/encryptionkey/headset_service
	name = "service radio encryption key"
	icon_state = "srv_cypherkey"
	channels = list(CHANNEL_SERVICE = 1)

/obj/item/encryptionkey/ert
	name = "\improper ERT radio encryption key"
	icon_state = "cent_cypherkey"
	channels = list(CHANNEL_RESPONSE_TEAM = 1, CHANNEL_SCIENCE = 1, CHANNEL_COMMAND = 1, CHANNEL_MEDICAL = 1, CHANNEL_ENGINEERING = 1, CHANNEL_SECURITY = 1, CHANNEL_SUPPLY = 1, CHANNEL_SERVICE = 1)

/obj/item/encryptionkey/omni		//Literally only for the admin intercoms
	channels = list(CHANNEL_MERCENARY = 1, CHANNEL_RAIDER = 1, CHANNEL_RESPONSE_TEAM = 1, CHANNEL_SCIENCE = 1, CHANNEL_COMMAND = 1, CHANNEL_MEDICAL = 1, CHANNEL_ENGINEERING = 1, CHANNEL_SECURITY = 1, CHANNEL_SUPPLY = 1, CHANNEL_SERVICE = 1)
	syndie = 1//Signifies that it de-crypts Syndicate transmissions

/obj/item/encryptionkey/ent
	name = "entertainment encryption key"
	channels = list(CHANNEL_ENTERTAINMENT = 1)
