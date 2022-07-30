/datum/design/item/biotech/nif
	name = "nanite implant framework"
	id = "nif"
	req_tech = list(TECH_MAGNET = 5, TECH_BLUESPACE = 5, TECH_MATERIAL = 5, TECH_ENGINEERING = 5, TECH_DATA = 5)
	materials = list(MAT_STEEL = 5000, MAT_GLASS = 8000, MAT_URANIUM = 6000, MAT_DIAMOND = 6000)
	build_path = /obj/item/nif
	sort_string = "JVAAA"

/datum/design/item/biotech/nifbio
	name = "bioadaptive NIF"
	id = "bioadapnif"
	req_tech = list(TECH_MAGNET = 5, TECH_BLUESPACE = 5, TECH_MATERIAL = 5, TECH_ENGINEERING = 5, TECH_DATA = 5, TECH_BIO = 5)
	materials = list(MAT_STEEL = 10000, MAT_GLASS = 15000, MAT_URANIUM = 10000, MAT_DIAMOND = 10000)
	build_path = /obj/item/nif/bioadap
	sort_string = "JVAAB"

/datum/design/item/biotech/nifrepairtool
	name = "adv. NIF repair tool"
	id = "anrt"
	req_tech = list(TECH_MAGNET = 5, TECH_BLUESPACE = 5, TECH_MATERIAL = 5, TECH_ENGINEERING = 5, TECH_DATA = 5)
	materials = list(MAT_STEEL = 2000, MAT_GLASS = 3000, MAT_URANIUM = 2000, MAT_DIAMOND = 2000)
	build_path = /obj/item/nifrepairer
	sort_string = "JVABA"
