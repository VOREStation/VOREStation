/datum/design/item/weapon/mining/AssembleDesignName()
	..()
	name = "Mining equipment design ([item_name])"

// Mining digging devices

/datum/design/item/weapon/mining/drill
	id = "drill"
	req_tech = list(TECH_MATERIAL = 2, TECH_POWER = 3, TECH_ENGINEERING = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 6000, "glass" = 1000, MAT_COPPER = 10) //expensive, but no need for miners.
	build_path = /obj/item/weapon/pickaxe/drill
	sort_string = "FAAAA"

/datum/design/item/weapon/mining/jackhammer
	id = "jackhammer"
	req_tech = list(TECH_MATERIAL = 3, TECH_POWER = 2, TECH_ENGINEERING = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 2000, "glass" = 500, "silver" = 500, MAT_COPPER = 20)
	build_path = /obj/item/weapon/pickaxe/jackhammer
	sort_string = "FAAAB"

/datum/design/item/weapon/mining/plasmacutter
	id = "plasmacutter"
	req_tech = list(TECH_MATERIAL = 4, TECH_PHORON = 3, TECH_ENGINEERING = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 1500, "glass" = 500, "gold" = 500, "phoron" = 500)
	build_path = /obj/item/weapon/pickaxe/plasmacutter
	sort_string = "FAAAC"

/datum/design/item/weapon/mining/pick_diamond
	id = "pick_diamond"
	req_tech = list(TECH_MATERIAL = 6)
	materials = list(MAT_WOOD = 2000, "diamond" = 3000)
	build_path = /obj/item/weapon/pickaxe/diamond
	sort_string = "FAAAD"

/datum/design/item/weapon/mining/drill_diamond
	id = "drill_diamond"
	req_tech = list(TECH_MATERIAL = 6, TECH_POWER = 4, TECH_ENGINEERING = 4)
	materials = list(MAT_ALUMINIUM = 2000, DEFAULT_WALL_MATERIAL = 1000, "glass" = 500, "diamond" = 2000, MAT_COPPER = 50)
	build_path = /obj/item/weapon/pickaxe/diamonddrill
	sort_string = "FAAAE"

// Mining other equipment

/datum/design/item/weapon/mining/depth_scanner
	desc = "Used to check spatial depth and density of rock outcroppings."
	id = "depth_scanner"
	req_tech = list(TECH_MAGNET = 2, TECH_ENGINEERING = 2, TECH_BLUESPACE = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 1000,"glass" = 1000, MAT_COPPER = 50)
	build_path = /obj/item/device/depth_scanner
	sort_string = "FBAAA"

/datum/design/item/weapon/mining/mining_scanner
	id = "mining_scanner"
	req_tech = list(TECH_MAGNET = 3, TECH_ENGINEERING = 4, TECH_BLUESPACE = 1)
	materials = list(DEFAULT_WALL_MATERIAL = 1000,"glass" = 500, MAT_COPPER = 250)
	build_path = /obj/item/weapon/mining_scanner/advanced
	sort_string = "FBAAB"