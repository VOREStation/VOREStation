// Various AI/mind holding device
/datum/design/item/ai_holder/AssembleDesignName()
	..()
	name = "Mind storage device prototype ([item_name])"

/datum/design/item/ai_holder/mmi
	name = "Man-machine interface"
	id = "mmi"
	req_tech = list(TECH_DATA = 2, TECH_BIO = 3)
	build_type = PROTOLATHE | PROSFAB
<<<<<<< HEAD
	materials = list(MAT_STEEL = 1000, MAT_GLASS = 500)
	build_path = /obj/item/device/mmi
	category = list("Misc")
=======
	materials = list(MAT_STEEL = 1000, "glass" = 500)
	build_path = /obj/item/mmi
	category = "Misc"
>>>>>>> 61084723c7b... Merge pull request #8317 from Atermonera/remove_weapon
	sort_string = "SAAAA"

/datum/design/item/ai_holder/posibrain
	name = "Positronic brain"
	id = "posibrain"
	req_tech = list(TECH_ENGINEERING = 4, TECH_MATERIAL = 6, TECH_BLUESPACE = 2, TECH_DATA = 4)
	build_type = PROTOLATHE | PROSFAB
<<<<<<< HEAD
	materials = list(MAT_STEEL = 2000, MAT_GLASS = 1000, MAT_SILVER = 1000, MAT_GOLD = 500, MAT_PHORON = 500, MAT_DIAMOND = 100)
	build_path = /obj/item/device/mmi/digital/posibrain
	category = list("Misc")
=======
	materials = list(MAT_STEEL = 2000, "glass" = 1000, "silver" = 1000, "gold" = 500, "phoron" = 500, "diamond" = 100)
	build_path = /obj/item/mmi/digital/posibrain
	category = "Misc"
>>>>>>> 61084723c7b... Merge pull request #8317 from Atermonera/remove_weapon
	sort_string = "SAAAB"

/datum/design/item/ai_holder/dronebrain
	name = "Robotic intelligence circuit"
	id = "dronebrain"
	req_tech = list(TECH_ENGINEERING = 4, TECH_MATERIAL = 5, TECH_DATA = 4)
	build_type = PROTOLATHE | PROSFAB
<<<<<<< HEAD
	materials = list(MAT_STEEL = 2000, MAT_GLASS = 1000, MAT_SILVER = 1000, MAT_GOLD = 500)
	build_path = /obj/item/device/mmi/digital/robot
	category = list("Misc")
=======
	materials = list(MAT_STEEL = 2000, "glass" = 1000, "silver" = 1000, "gold" = 500)
	build_path = /obj/item/mmi/digital/robot
	category = "Misc"
>>>>>>> 61084723c7b... Merge pull request #8317 from Atermonera/remove_weapon
	sort_string = "SAAAC"

/datum/design/item/ai_holder/paicard
	name = "'pAI', personal artificial intelligence device"
	id = "paicard"
	req_tech = list(TECH_DATA = 2)
<<<<<<< HEAD
	materials = list(MAT_GLASS = 500, MAT_STEEL = 500)
	build_path = /obj/item/device/paicard
=======
	materials = list("glass" = 500, MAT_STEEL = 500)
	build_path = /obj/item/paicard
>>>>>>> 61084723c7b... Merge pull request #8317 from Atermonera/remove_weapon
	sort_string = "SBAAA"

/datum/design/item/ai_holder/intellicard
	name = "intelliCore"
	desc = "Allows for the construction of an intelliCore."
	id = "intellicore"
	req_tech = list(TECH_DATA = 4, TECH_MATERIAL = 4)
<<<<<<< HEAD
	materials = list(MAT_GLASS = 1000, MAT_GOLD = 200)
	build_path = /obj/item/device/aicard
=======
	materials = list("glass" = 1000, "gold" = 200)
	build_path = /obj/item/aicard
>>>>>>> 61084723c7b... Merge pull request #8317 from Atermonera/remove_weapon
	sort_string = "SCAAA"