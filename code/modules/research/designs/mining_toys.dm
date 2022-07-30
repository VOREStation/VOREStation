/datum/design/item/weapon/mining/AssembleDesignName()
	..()
	name = "Mining equipment design ([item_name])"

// Mining digging devices

/datum/design/item/weapon/mining/drill
	id = "drill"
	req_tech = list(TECH_MATERIAL = 1, TECH_POWER = 2, TECH_ENGINEERING = 1)
	materials = list(MAT_STEEL = 4000, MAT_GLASS = 500) //expensive, but no need for miners.
	build_path = /obj/item/pickaxe/drill
	sort_string = "FAAAA"

/datum/design/item/weapon/mining/advdrill
	id = "advanced_drill"
	req_tech = list(TECH_MATERIAL = 2, TECH_POWER = 3, TECH_ENGINEERING = 2)
	materials = list(MAT_STEEL = 6000, MAT_GLASS = 1000) //expensive, but no need for miners.
	build_path = /obj/item/pickaxe/advdrill
	sort_string = "FAAAB"

/datum/design/item/weapon/mining/jackhammer
	id = "jackhammer"
	req_tech = list(TECH_MATERIAL = 3, TECH_POWER = 2, TECH_ENGINEERING = 2)
	materials = list(MAT_STEEL = 2000, MAT_GLASS = 500, MAT_SILVER = 500)
	build_path = /obj/item/pickaxe/jackhammer
	sort_string = "FAAAC"

/datum/design/item/weapon/mining/plasmacutter
	id = "plasmacutter"
	req_tech = list(TECH_MATERIAL = 4, TECH_PHORON = 3, TECH_ENGINEERING = 3)
	materials = list(MAT_STEEL = 1500, MAT_GLASS = 500, MAT_GOLD = 500, MAT_PHORON = 500)
	build_path = /obj/item/pickaxe/plasmacutter
	sort_string = "FAAAD"

/datum/design/item/weapon/mining/pick_diamond
	id = "pick_diamond"
	req_tech = list(TECH_MATERIAL = 6)
	materials = list(MAT_DIAMOND = 3000)
	build_path = /obj/item/pickaxe/diamond
	sort_string = "FAAAE"

/datum/design/item/weapon/mining/drill_diamond
	id = "drill_diamond"
	req_tech = list(TECH_MATERIAL = 6, TECH_POWER = 4, TECH_ENGINEERING = 4)
	materials = list(MAT_STEEL = 3000, MAT_GLASS = 1000, MAT_DIAMOND = 2000)
	build_path = /obj/item/pickaxe/diamonddrill
	sort_string = "FAAAF"

// Mining other equipment

/datum/design/item/weapon/mining/depth_scanner
	desc = "Used to check spatial depth and density of rock outcroppings."
	id = "depth_scanner"
	req_tech = list(TECH_MAGNET = 2, TECH_ENGINEERING = 2, TECH_BLUESPACE = 2)
	materials = list(MAT_STEEL = 1000,MAT_GLASS = 1000)
	build_path = /obj/item/depth_scanner
	sort_string = "FBAAA"

/datum/design/item/weapon/mining/upgradeAOE
	name = "Mining Explosion Upgrade"
	desc = "An area of effect upgrade for the Proto-Kinetic Accelerator."
	id = "pka_mineaoe"
	req_tech = list(TECH_COMBAT = 7, TECH_MATERIAL = 8, TECH_ENGINEERING = 7) // Lets make this endgame level tech, due to it's power.
	materials = list(MAT_STEEL = 5000, MAT_GLASS = 5000, MAT_SILVER = 500, MAT_GOLD = 500, MAT_URANIUM = 2000, MAT_PHORON = 2000)
	build_path = /obj/item/borg/upgrade/modkit/aoe/turfs
	sort_string = "FAAF"
