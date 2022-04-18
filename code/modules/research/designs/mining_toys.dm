/datum/design/item/weapon/mining/AssembleDesignName()
	..()
	name = "Mining equipment design ([item_name])"

// Mining digging devices

/datum/design/item/weapon/mining/drill
	id = "drill"
<<<<<<< HEAD
	req_tech = list(TECH_MATERIAL = 1, TECH_POWER = 2, TECH_ENGINEERING = 1)
	materials = list(MAT_STEEL = 4000, MAT_GLASS = 500) //expensive, but no need for miners.
	build_path = /obj/item/weapon/pickaxe/drill
=======
	req_tech = list(TECH_MATERIAL = 2, TECH_POWER = 3, TECH_ENGINEERING = 2)
	materials = list(MAT_STEEL = 6000, "glass" = 1000) //expensive, but no need for miners.
	build_path = /obj/item/pickaxe/drill
>>>>>>> 61084723c7b... Merge pull request #8317 from Atermonera/remove_weapon
	sort_string = "FAAAA"

/datum/design/item/weapon/mining/advdrill
	id = "advanced_drill"
	req_tech = list(TECH_MATERIAL = 2, TECH_POWER = 3, TECH_ENGINEERING = 2)
	materials = list(MAT_STEEL = 6000, MAT_GLASS = 1000) //expensive, but no need for miners.
	build_path = /obj/item/weapon/pickaxe/advdrill
	sort_string = "FAAAB"

/datum/design/item/weapon/mining/jackhammer
	id = "jackhammer"
	req_tech = list(TECH_MATERIAL = 3, TECH_POWER = 2, TECH_ENGINEERING = 2)
<<<<<<< HEAD
	materials = list(MAT_STEEL = 2000, MAT_GLASS = 500, MAT_SILVER = 500)
	build_path = /obj/item/weapon/pickaxe/jackhammer
	sort_string = "FAAAC"
=======
	materials = list(MAT_STEEL = 2000, "glass" = 500, "silver" = 500)
	build_path = /obj/item/pickaxe/jackhammer
	sort_string = "FAAAB"
>>>>>>> 61084723c7b... Merge pull request #8317 from Atermonera/remove_weapon

/datum/design/item/weapon/mining/plasmacutter
	id = "plasmacutter"
	req_tech = list(TECH_MATERIAL = 4, TECH_PHORON = 3, TECH_ENGINEERING = 3)
<<<<<<< HEAD
	materials = list(MAT_STEEL = 1500, MAT_GLASS = 500, MAT_GOLD = 500, MAT_PHORON = 500)
	build_path = /obj/item/weapon/pickaxe/plasmacutter
	sort_string = "FAAAD"
=======
	materials = list(MAT_STEEL = 1500, "glass" = 500, "gold" = 500, "phoron" = 500)
	build_path = /obj/item/pickaxe/plasmacutter
	sort_string = "FAAAC"
>>>>>>> 61084723c7b... Merge pull request #8317 from Atermonera/remove_weapon

/datum/design/item/weapon/mining/pick_diamond
	id = "pick_diamond"
	req_tech = list(TECH_MATERIAL = 6)
<<<<<<< HEAD
	materials = list(MAT_DIAMOND = 3000)
	build_path = /obj/item/weapon/pickaxe/diamond
	sort_string = "FAAAE"
=======
	materials = list("diamond" = 3000)
	build_path = /obj/item/pickaxe/diamond
	sort_string = "FAAAD"
>>>>>>> 61084723c7b... Merge pull request #8317 from Atermonera/remove_weapon

/datum/design/item/weapon/mining/drill_diamond
	id = "drill_diamond"
	req_tech = list(TECH_MATERIAL = 6, TECH_POWER = 4, TECH_ENGINEERING = 4)
<<<<<<< HEAD
	materials = list(MAT_STEEL = 3000, MAT_GLASS = 1000, MAT_DIAMOND = 2000)
	build_path = /obj/item/weapon/pickaxe/diamonddrill
	sort_string = "FAAAF"
=======
	materials = list(MAT_STEEL = 3000, "glass" = 1000, "diamond" = 2000)
	build_path = /obj/item/pickaxe/diamonddrill
	sort_string = "FAAAE"
>>>>>>> 61084723c7b... Merge pull request #8317 from Atermonera/remove_weapon

// Mining other equipment

/datum/design/item/weapon/mining/depth_scanner
	desc = "Used to check spatial depth and density of rock outcroppings."
	id = "depth_scanner"
	req_tech = list(TECH_MAGNET = 2, TECH_ENGINEERING = 2, TECH_BLUESPACE = 2)
<<<<<<< HEAD
	materials = list(MAT_STEEL = 1000,MAT_GLASS = 1000)
	build_path = /obj/item/device/depth_scanner
=======
	materials = list(MAT_STEEL = 1000,"glass" = 1000)
	build_path = /obj/item/depth_scanner
>>>>>>> 61084723c7b... Merge pull request #8317 from Atermonera/remove_weapon
	sort_string = "FBAAA"

/datum/design/item/weapon/mining/upgradeAOE
	name = "Mining Explosion Upgrade"
	desc = "An area of effect upgrade for the Proto-Kinetic Accelerator."
	id = "pka_mineaoe"
	req_tech = list(TECH_COMBAT = 7, TECH_MATERIAL = 8, TECH_ENGINEERING = 7) // Lets make this endgame level tech, due to it's power.
	materials = list(MAT_STEEL = 5000, MAT_GLASS = 5000, MAT_SILVER = 500, MAT_GOLD = 500, MAT_URANIUM = 2000, MAT_PHORON = 2000)
	build_path = /obj/item/borg/upgrade/modkit/aoe/turfs
	sort_string = "FAAF"