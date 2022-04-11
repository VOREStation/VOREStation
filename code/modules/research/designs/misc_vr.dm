/datum/design/item/general/hyperfiber_jumpsuit
	name = "HYPER jumpsuit"
	id = "hfjumpsuit"
	req_tech = list(TECH_BLUESPACE = 2)
	materials = list(MAT_STEEL = 2000, MAT_GLASS = 1000)
	build_path = /obj/item/clothing/under/hyperfiber
	sort_string = "TAVAA"

/datum/design/item/general/bluespace_jumpsuit
	name = "Bluespace jumpsuit"
	id = "bsjumpsuit"
	req_tech = list(TECH_BLUESPACE = 2, TECH_MATERIAL = 3, TECH_POWER = 2)
	materials = list(MAT_STEEL = 4000, MAT_GLASS = 4000)
	build_path = /obj/item/clothing/under/hyperfiber/bluespace
	sort_string = "TAVAA"

/datum/design/item/general/sizegun
	name = "Size gun"
	id = "sizegun"
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 3, TECH_POWER = 2)
	materials = list(MAT_STEEL = 3000, MAT_GLASS = 2000)
	build_path = /obj/item/weapon/gun/energy/sizegun
	sort_string = "TAVBA"

/datum/design/item/general/bodysnatcher
	name = "Body Snatcher"
	id = "bodysnatcher"
	req_tech = list(TECH_MAGNET = 3, TECH_BIO = 3, TECH_ILLEGAL = 2)
	materials = list(MAT_STEEL = 4000, MAT_GLASS = 4000, MAT_URANIUM = 2000)
	build_path = /obj/item/device/bodysnatcher
	sort_string = "TBVAA"

/datum/design/item/general/inducer_sci
	name = "Inducer (Scientific)"
	id = "inducersci"
	req_tech = list(TECH_BLUESPACE = 4, TECH_MATERIAL = 5, TECH_POWER = 6)
	materials = list(MAT_STEEL = 8000, MAT_GLASS = 2000, MAT_URANIUM = 4000, MAT_PHORON = 4000)
	build_path = /obj/item/weapon/inducer/sci
	sort_string = "TCVAA"

/datum/design/item/general/inducer_eng
	name = "Inducer (Industrial)"
	id = "inducerind"
	req_tech = list(TECH_BLUESPACE = 5, TECH_MATERIAL = 7, TECH_POWER = 7)
	materials = list(MAT_STEEL = 3000, MAT_GLASS = 2000, MAT_URANIUM = 2000, MAT_TITANIUM = 2000)
	build_path = /obj/item/weapon/inducer/unloaded
	sort_string = "TCVAB"

/datum/design/item/weapon/mining/mining_scanner
	id = "mining_scanner"
	req_tech = list(TECH_MAGNET = 3, TECH_ENGINEERING = 4, TECH_BLUESPACE = 1)
	materials = list(MAT_STEEL = 1000,MAT_GLASS = 500)
	build_path = /obj/item/weapon/mining_scanner/advanced
	sort_string = "FBAAB" 

/datum/design/item/general/walkpod
	name = "PodZu Music Player"
	id = "walkpod"
	req_tech = list(TECH_MAGNET = 3, TECH_ENGINEERING = 3)
	materials = list(MAT_STEEL = 2000, MAT_GLASS = 2000)
	build_path = /obj/item/device/walkpod
	sort_string = "TCVAD"

/datum/design/item/general/juke_remote
	name = "BoomTown Cordless Speaker"
	id = "juke_remote"
	req_tech = list(TECH_MAGNET = 3, TECH_ENGINEERING = 4, TECH_BLUESPACE = 1)
	materials = list(MAT_STEEL = 4000, MAT_GLASS = 4000, MAT_URANIUM = 2000)
	build_path = /obj/item/device/juke_remote
	sort_string = "TCVAE"
