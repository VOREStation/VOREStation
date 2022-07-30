// Everything that didn't fit elsewhere

/datum/design/item/general/AssembleDesignName()
	..()
	name = "General purpose design ([item_name])"

/datum/design/item/general/communicator
	name = "Communicator"
	id = "communicator"
	req_tech = list(TECH_DATA = 2, TECH_MAGNET = 2)
	materials = list(MAT_STEEL = 500, MAT_GLASS = 500)
	build_path = /obj/item/communicator
	sort_string = "TAAAA"

/datum/design/item/general/laserpointer
	name = "laser pointer"
	desc = "Don't shine it in your eyes!"
	id = "laser_pointer"
	req_tech = list(TECH_MAGNET = 3)
	materials = list(MAT_STEEL = 100, MAT_GLASS = 50)
	build_path = /obj/item/laser_pointer
	sort_string = "TAABA"

/datum/design/item/general/translator
	name = "handheld translator"
	id = "translator"
	req_tech = list(TECH_DATA = 3, TECH_ENGINEERING = 3)
	materials = list(MAT_STEEL = 3000, MAT_GLASS = 3000)
	build_path = /obj/item/universal_translator
	sort_string = "TAACA"

/datum/design/item/general/ear_translator
	name = "earpiece translator"
	id = "ear_translator"
	req_tech = list(TECH_DATA = 5, TECH_ENGINEERING = 5)	//It's been hella miniaturized.
	materials = list(MAT_STEEL = 2000, MAT_GLASS = 2000, MAT_GOLD = 1000)
	build_path = /obj/item/universal_translator/ear
	sort_string = "TAACB"

/datum/design/item/general/light_replacer
	name = "Light replacer"
	desc = "A device to automatically replace lights. Refill with working lightbulbs."
	id = "light_replacer"
	req_tech = list(TECH_MAGNET = 3, TECH_MATERIAL = 4)
	materials = list(MAT_STEEL = 1500, MAT_SILVER = 150, MAT_GLASS = 3000)
	build_path = /obj/item/lightreplacer
	sort_string = "TAADA"

/datum/design/item/general/binaryencrypt
	name = "Binary encryption key"
	desc = "Allows for deciphering the binary channel on-the-fly."
	id = "binaryencrypt"
	req_tech = list(TECH_ILLEGAL = 2)
	materials = list(MAT_STEEL = 300, MAT_GLASS = 300)
	build_path = /obj/item/encryptionkey/binary
	sort_string = "TBAAA"

/datum/design/item/general/chameleon
	name = "Holographic equipment kit"
	desc = "A kit of dangerous, high-tech equipment with changeable looks."
	id = "chameleon"
	req_tech = list(TECH_ILLEGAL = 2)
	materials = list(MAT_STEEL = 500)
	build_path = /obj/item/storage/box/syndie_kit/chameleon
	sort_string = "TBAAB"

/datum/design/item/general/bsflare
	name = "bluespace flare"
	desc = "A marker that can be detected by shuttle landing systems."
	id = "bsflare"
	req_tech = list(TECH_DATA = 3, TECH_BLUESPACE = 4)
	materials = list(MAT_STEEL = 4000, MAT_GLASS = 2000, MAT_SILVER = 2000)
	build_path = /obj/item/spaceflare
	sort_string = "TBAAC"

/datum/design/item/general/riflescope
	name = "rifle scope"
	desc = "A scope that can be mounted to certain rifles."
	id = "riflescope"
	req_tech = list(TECH_ILLEGAL = 2, TECH_MATERIAL = 2)
	materials = list(MAT_STEEL = 4000, MAT_GLASS = 4000)
	build_path = /obj/item/binoculars/scope
	sort_string = "TBAAD"

/datum/design/item/general/advmop
	name = "advanced mop"
	desc = "An advanced mop with pressured water jets that break away the toughest stains."
	id = "advmop"
	req_tech = list(TECH_MATERIAL = 3, TECH_ENGINEERING = 5, TECH_BIO = 1)
	materials = list(MAT_STEEL = 5000, MAT_GLASS = 2000, MAT_GOLD = 1000)
	build_path = /obj/item/mop/advanced
	sort_string = "TBAAE"
