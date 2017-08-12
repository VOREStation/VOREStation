/datum/design/excavationdrill
	name = "Excavation Drill"
	desc = "Advanced archaeological drill combining ultrasonic excitation and bluespace manipulation to provide extreme precision. The silver tip is adjustable from 1 to 30 cm."
	id = "excavationdrill"
	req_tech = list(TECH_MATERIAL = 4, TECH_POWER = 3, TECH_ENGINEERING = 3, TECH_BLUESPACE = 3) //They were never used before. Now they'll be used. Hopefully.
	build_type = PROTOLATHE
	materials = list(DEFAULT_WALL_MATERIAL = 4000, "glass" = 1000, "silver" = 1000)
	build_path = /obj/item/weapon/pickaxe/excavationdrill

/datum/design/item/implant/language
	name = "Language implant"
	id = "implant_language"
	req_tech = list(TECH_MATERIAL = 5, TECH_BIO = 5, TECH_DATA = 4, TECH_ENGINEERING = 4) //This is not an easy to make implant.
	materials = list(DEFAULT_WALL_MATERIAL = 7000, "glass" = 7000, "gold" = 2000, "diamond" = 3000)
	build_path = /obj/item/weapon/implantcase/vrlanguage

/datum/design/item/implant/backup
	name = "Backup implant"
	id = "implant_backup"
	req_tech = list(TECH_MATERIAL = 2, TECH_BIO = 2, TECH_DATA = 4, TECH_ENGINEERING = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 2000, "glass" = 2000)
	build_path = /obj/item/weapon/implantcase/backup

/datum/design/item/weapon/sizegun
	name = "Size gun"
	id = "sizegun"
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 3, TECH_POWER = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 3000, "glass" = 2000, "uranium" = 2000)
	build_path = /obj/item/weapon/gun/energy/sizegun
	sort_string = "TAAAB"

/datum/design/item/bluespace_jumpsuit
	name = "Bluespace jumpsuit"
	id = "bsjumpsuit"
	req_tech = list(TECH_BLUESPACE = 2, TECH_MATERIAL = 3, TECH_POWER = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 4000, "glass" = 4000)
	build_path = /obj/item/clothing/under/bluespace
	sort_string = "TAAAC"

/datum/design/item/sleevemate
	name = "SleeveMate 3200"
	id = "sleevemate"
	req_tech = list(TECH_MATERIAL = 3, TECH_MAGNET = 2, TECH_BIO = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 4000, "glass" = 4000)
	build_path = /obj/item/device/sleevemate
	sort_string = "TAAAD"

/datum/design/item/bodysnatcher
	name = "Body Snatcher"
	id = "bodysnatcher"
	req_tech = list(TECH_MAGNET = 3, TECH_BIO = 3, TECH_ILLEGAL = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 4000, "glass" = 4000)
	build_path = /obj/item/device/bodysnatcher

/datum/design/item/item/pressureinterlock
	name = "APP pressure interlock"
	id = "pressureinterlock"
	req_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2, TECH_ENGINEERING = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 1000, "glass" = 250)
	build_path = /obj/item/pressurelock
	sort_string = "TAADA"

/datum/design/item/weapon/advparticle
	name = "Advanced anti-particle rifle"
	id = "advparticle"
	req_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 5, TECH_POWER = 3, TECH_MAGNET = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 5000, "glass" = 1000, "gold" = 1000, "uranium" = 750)
	build_path = /obj/item/weapon/gun/energy/particle/advanced
	sort_string = "TAADB"

/datum/design/item/weapon/particlecannon
	name = "Anti-particle cannon"
	id = "particlecannon"
	req_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 5, TECH_POWER = 4, TECH_MAGNET = 4)
	materials = list(DEFAULT_WALL_MATERIAL = 10000, "glass" = 1500, "gold" = 2000, "uranium" = 1000, "diamond" = 2000)
	build_path = /obj/item/weapon/gun/energy/particle/cannon
	sort_string = "TAADC"

/datum/design/item/hud/omni
	name = "AR glasses"
	id = "omnihud"
	req_tech = list(TECH_MAGNET = 4, TECH_COMBAT = 3, TECH_BIO = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 1000, "glass" = 1000)
	build_path = /obj/item/clothing/glasses/omnihud
	sort_string = "GAAFB"

/datum/design/item/translocator
	name = "Personal translocator"
	id = "translocator"
	req_tech = list(TECH_MAGNET = 5, TECH_BLUESPACE = 5, TECH_ILLEGAL = 7)
	materials = list(DEFAULT_WALL_MATERIAL = 4000, "glass" = 2000, "uranium" = 4000, "diamond" = 2000)
	build_path = /obj/item/device/perfect_tele
	sort_string = "HABAF"

/datum/design/item/translator/ear
	name = "handheld translator (ear)"
	id = "translator_ear"
	req_tech = list(TECH_DATA = 3, TECH_ENGINEERING = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 2000, "glass" = 2000)
	build_path = /obj/item/device/universal_translator/ear
	sort_string = "HABBB"

/datum/design/item/nif
	name = "nanite implant framework"
	id = "nif"
	req_tech = list(TECH_MAGNET = 5, TECH_BLUESPACE = 5, TECH_MATERIAL = 5, TECH_ENGINEERING = 5, TECH_DATA = 5)
	materials = list(DEFAULT_WALL_MATERIAL = 5000, "glass" = 8000, "uranium" = 6000, "diamond" = 6000)
	build_path = /obj/item/device/nif
	sort_string = "HABBC"

// Resleeving Circuitboards

/datum/design/circuit/transhuman_clonepod
	name = "grower pod"
	id = "transhuman_clonepod"
	req_tech = list(TECH_DATA = 3, TECH_BIO = 3)
	build_path = /obj/item/weapon/circuitboard/transhuman_clonepod
	sort_string = "HAADA"

/datum/design/circuit/transhuman_synthprinter
	name = "SynthFab 3000"
	id = "transhuman_synthprinter"
	req_tech = list(TECH_DATA = 3, TECH_ENGINEERING = 3)
	build_path = /obj/item/weapon/circuitboard/transhuman_synthprinter
	sort_string = "HAADB"

/datum/design/circuit/transhuman_resleever
	name = "Resleeving pod"
	id = "transhuman_resleever"
	req_tech = list(TECH_ENGINEERING = 4, TECH_BIO = 4)
	build_path = /obj/item/weapon/circuitboard/transhuman_resleever
	sort_string = "HAADC"

/datum/design/circuit/resleeving_control
	name = "Resleeving control console"
	id = "resleeving_control"
	req_tech = list(TECH_DATA = 5)
	build_path = /obj/item/weapon/circuitboard/resleeving_control
	sort_string = "HAADE"

/datum/design/circuit/body_designer
	name = "Body design console"
	id = "body_designer"
	req_tech = list(TECH_DATA = 5)
	build_path = /obj/item/weapon/circuitboard/body_designer
	sort_string = "HAADF"

/datum/design/circuit/partslathe
	name = "Parts lathe"
	id = "partslathe"
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/weapon/circuitboard/partslathe
	sort_string = "HABAD"

/datum/design/item/weapon/netgun
	name = "\'Hunter\' capture gun"
	id = "netgun"
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 5, TECH_MAGNET = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 6000, "glass" = 3000)
	build_path = /obj/item/weapon/gun/energy/netgun
	sort_string = "TAADF"

/datum/design/circuit/algae_farm
	name = "Algae Oxygen Generator"
	id = "algae_farm"
	req_tech = list(TECH_ENGINEERING = 3, TECH_BIO = 2)
	build_path = /obj/item/weapon/circuitboard/algae_farm
	sort_string = "HABAE"
