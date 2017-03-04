/datum/design/excavationdrill
	name = "Excavation Drill"
	desc = "Advanced archaeological drill combining ultrasonic excitation and bluespace manipulation to provide extreme precision. The silver tip is adjustable from 1 to 30 cm."
	id = "excavationdrill"
	req_tech = list(TECH_MATERIAL = 4, TECH_POWER = 3, TECH_ENGINEERING = 3, TECH_BLUESPACE = 3) //They were never used before. Now they'll be used. Hopefully.
	build_type = PROTOLATHE
	materials = list(DEFAULT_WALL_MATERIAL = 4000, "glass" = 1000, "silver" = 1000)
	build_path = /obj/item/weapon/pickaxe/excavationdrill

/datum/design/item/implant/language
	name = "language implant"
	id = "implant_language"
	req_tech = list(TECH_MATERIAL = 5, TECH_BIO = 5, TECH_DATA = 4, TECH_ENGINEERING = 4) //This is not an easy to make implant.
	materials = list(DEFAULT_WALL_MATERIAL = 7000, "glass" = 7000, "gold" = 2000, "diamond" = 3000)
	build_path = /obj/item/weapon/implantcase/vrlanguage

/datum/design/item/implant/backup
	name = "backup implant"
	id = "implant_backup"
	req_tech = list(TECH_MATERIAL = 2, TECH_BIO = 2, TECH_DATA = 4, TECH_ENGINEERING = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 2000, "glass" = 2000)
	build_path = /obj/item/weapon/implantcase/backup

/datum/design/item/weapon/sizegun
	name = "shrink ray"
	id = "shrinkray"
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 3, TECH_POWER = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 3000, "glass" = 2000, "uranium" = 2000)
	build_path = /obj/item/weapon/gun/energy/sizegun
	sort_string = "TAAAB"

/datum/design/item/weapon/sizegun
	name = "shrink ray"
	id = "shrinkray"
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 3, TECH_POWER = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 3000, "glass" = 2000, "uranium" = 2000)
	build_path = /obj/item/weapon/gun/energy/sizegun
	sort_string = "TAAAB"

/datum/design/item/hud/omni
	name = "AR sunglasses"
	id = "omnihud"
	req_tech = list(TECH_MAGNET = 4, TECH_COMBAT = 3, TECH_BIO = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 1000, "glass" = 1000)
	build_path = /obj/item/clothing/glasses/sunglasses/omnihud
	sort_string = "GAAFB"

// Resleeving Circuitboards

/datum/design/circuit/comm_server
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
	name = "resleeving pod"
	id = "transhuman_resleever"
	req_tech = list(TECH_ENGINEERING = 4, TECH_BIO = 4)
	build_path = /obj/item/weapon/circuitboard/transhuman_resleever
	sort_string = "HAADC"

/datum/design/circuit/resleeving_control
	name = "resleeving control console"
	id = "resleeving_control"
	req_tech = list(TECH_DATA = 5)
	build_path = /obj/item/weapon/circuitboard/resleeving_control
	sort_string = "HAADE"

/datum/design/circuit/partslathe
	name = "parts lathe"
	id = "partslathe"
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/weapon/circuitboard/partslathe
	sort_string = "HABAD"
