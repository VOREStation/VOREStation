// Yeah yeah, vague file name. Basically a misc folder for antag things that RnD can make.

/datum/design/item/binaryencrypt
	name = "Binary encryption key"
	desc = "Allows for deciphering the binary channel on-the-fly."
	id = "binaryencrypt"
	req_tech = list(TECH_ILLEGAL = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 300, "glass" = 300)
	build_path = /obj/item/device/encryptionkey/binary
	sort_string = "VASAA"

/datum/design/item/chameleon
	name = "Holographic equipment kit"
	desc = "A kit of dangerous, high-tech equipment with changeable looks."
	id = "chameleon"
	req_tech = list(TECH_ILLEGAL = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 500)
	build_path = /obj/item/weapon/storage/box/syndie_kit/chameleon
	sort_string = "VASBA"

/datum/design/item/weapon/esword
	id = "chargesword"
	req_tech = list(TECH_COMBAT = 6, TECH_MAGNET = 4, TECH_ENGINEERING = 5, TECH_ILLEGAL = 4, TECH_ANOMALY = 1)
	materials = list(MAT_PLASTEEL = 3500, "glass" = 1000, MAT_LEAD = 2250, MAT_METALHYDROGEN = 500)
	build_path = /obj/item/weapon/melee/energy/sword/charge
	sort_string = "VASCA"
