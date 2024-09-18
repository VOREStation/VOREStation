/obj/item/encryptionkey/heads/hop
	name = "head of personnel's encryption key"
	icon_state = "hop_cypherkey"
	channels = list(CHANNEL_SUPPLY = 1, CHANNEL_SERVICE = 1, CHANNEL_COMMAND = 1, CHANNEL_SECURITY = 1, CHANNEL_EXPLORATION = 1)

/obj/item/encryptionkey/heads/ai_integrated
	name = "ai integrated encryption key"
	desc = "Integrated encryption key"
	icon_state = "cap_cypherkey"
	channels = list(CHANNEL_COMMAND = 1, CHANNEL_SECURITY = 1, CHANNEL_ENGINEERING = 1, CHANNEL_SCIENCE = 1, CHANNEL_MEDICAL = 1, CHANNEL_SUPPLY = 1, CHANNEL_SERVICE = 1, CHANNEL_AI_PRIVATE = 1, CHANNEL_EXPLORATION = 1)

/obj/item/encryptionkey/heads/captain
	name = "site manager's encryption key"
	icon_state = "cap_cypherkey"
	channels = list(CHANNEL_COMMAND = 1, CHANNEL_SECURITY = 1, CHANNEL_ENGINEERING = 1, CHANNEL_SCIENCE = 1, CHANNEL_MEDICAL = 1, CHANNEL_SUPPLY = 1, CHANNEL_SERVICE = 1, CHANNEL_EXPLORATION = 1)

/obj/item/encryptionkey/heads/rd
	name = "research director's encryption key"
	icon_state = "rd_cypherkey"
	channels = list(CHANNEL_COMMAND = 1, CHANNEL_SCIENCE = 1)

/obj/item/device/encryptionkey/ert
	channels = list(CHANNEL_RESPONSE_TEAM = 1, CHANNEL_SCIENCE = 1, CHANNEL_COMMAND = 1, CHANNEL_MEDICAL = 1, CHANNEL_ENGINEERING = 1, CHANNEL_SECURITY = 1, CHANNEL_SUPPLY = 1, CHANNEL_SERVICE = 1, CHANNEL_EXPLORATION = 1)

/obj/item/device/encryptionkey/omni		//Literally only for the admin intercoms
	channels = list(CHANNEL_MERCENARY = 1, CHANNEL_RAIDER = 1, CHANNEL_RESPONSE_TEAM = 1, CHANNEL_SCIENCE = 1, CHANNEL_COMMAND = 1, CHANNEL_MEDICAL = 1, CHANNEL_ENGINEERING = 1, CHANNEL_SECURITY = 1, CHANNEL_SUPPLY = 1, CHANNEL_SERVICE = 1, CHANNEL_EXPLORATION = 1)

/obj/item/encryptionkey/pathfinder
	name = "pathfinder's encryption key"
	icon_state = "com_cypherkey"
	channels = list(CHANNEL_COMMAND = 1, CHANNEL_EXPLORATION = 1)

/obj/item/encryptionkey/qm
	name = "quartermaster's encryption key"
	icon_state = "qm_cypherkey"
	channels = list(CHANNEL_COMMAND = 1, CHANNEL_SUPPLY = 1)

/obj/item/encryptionkey/pilot
	name = "pilot's encryption key"
	icon_state = "cypherkey"
	channels = list(CHANNEL_EXPLORATION = 1)

/obj/item/encryptionkey/explorer
	name = "away team's encryption key"
	icon_state = "rob_cypherkey"
	channels = list(CHANNEL_EXPLORATION = 1)

/obj/item/encryptionkey/sar
	name = "fm's encryption key"
	icon_state = "med_cypherkey"
	channels = list(CHANNEL_MEDICAL = 1, CHANNEL_EXPLORATION = 1)

/obj/item/device/encryptionkey/talon
	channels = list(CHANNEL_TALON = 1)
