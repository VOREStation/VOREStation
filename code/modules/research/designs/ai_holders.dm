// Various AI/mind holding device
/datum/design/item/ai_holder/AssembleDesignName()
	..()
	name = "Mind storage device prototype ([item_name])"

/datum/design/item/ai_holder/mmi
	name = "Man-machine interface"
	id = "mmi"
	req_tech = list(TECH_DATA = 2, TECH_BIO = 3)
	build_type = PROTOLATHE | PROSFAB
	materials = list(DEFAULT_WALL_MATERIAL = 1000, "glass" = 500)
	build_path = /obj/item/device/mmi
	category = "Misc"
	sort_string = "SAAAA"

/datum/design/item/ai_holder/posibrain
	name = "Positronic brain"
	id = "posibrain"
	req_tech = list(TECH_ENGINEERING = 4, TECH_MATERIAL = 6, TECH_BLUESPACE = 2, TECH_DATA = 4)
	build_type = PROTOLATHE | PROSFAB
	materials = list(DEFAULT_WALL_MATERIAL = 2000, "glass" = 1000, "silver" = 1000, "gold" = 500, "phoron" = 500, "diamond" = 100)
	build_path = /obj/item/device/mmi/digital/posibrain
	category = "Misc"
	sort_string = "SAAAB"

/datum/design/item/ai_holder/dronebrain
	name = "Robotic intelligence circuit"
	id = "dronebrain"
	req_tech = list(TECH_ENGINEERING = 4, TECH_MATERIAL = 5, TECH_DATA = 4)
	build_type = PROTOLATHE | PROSFAB
	materials = list(DEFAULT_WALL_MATERIAL = 2000, "glass" = 1000, "silver" = 1000, "gold" = 500)
	build_path = /obj/item/device/mmi/digital/robot
	category = "Misc"
	sort_string = "SAAAC"

/datum/design/item/ai_holder/paicard
	name = "'pAI', personal artificial intelligence device"
	id = "paicard"
	req_tech = list(TECH_DATA = 2)
	materials = list("glass" = 500, DEFAULT_WALL_MATERIAL = 500)
	build_path = /obj/item/device/paicard
	sort_string = "SBAAA"

/datum/design/item/ai_holder/intellicard
	name = "intelliCore"
	desc = "Allows for the construction of an intelliCore."
	id = "intellicore"
	req_tech = list(TECH_DATA = 4, TECH_MATERIAL = 4)
	materials = list("glass" = 1000, "gold" = 200)
	build_path = /obj/item/device/aicard
	sort_string = "SCAAA"