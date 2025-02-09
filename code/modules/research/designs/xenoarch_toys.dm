/datum/design/item/weapon/xenoarch/AssembleDesignName()
	..()
	name = "Xenoarcheology equipment design ([item_name])"

// Xenoarch tools

/datum/design/item/weapon/xenoarch/ano_scanner
	name = "Alden-Saraspova counter"
	id = "ano_scanner"
	desc = "Aids in triangulation of exotic particles."
	req_tech = list(TECH_BLUESPACE = 3, TECH_MAGNET = 3)
	materials = list(MAT_STEEL = 10000,MAT_GLASS = 5000)
	build_path = /obj/item/ano_scanner
	sort_string = "GAAAA"

/datum/design/item/weapon/xenoarch/xenoarch_multi_tool
	name = "xenoarcheology multitool"
	id = "xenoarch_multitool"
	req_tech = list(TECH_MAGNET = 3, TECH_ENGINEERING = 3, TECH_BLUESPACE = 3)
	build_path = /obj/item/xenoarch_multi_tool
	materials = list(MAT_STEEL = 2000, MAT_GLASS = 1000, MAT_URANIUM = 500, MAT_PHORON = 500)
	sort_string = "GAAAB"

/datum/design/item/weapon/xenoarch/excavationdrill
	name = "Excavation Drill"
	id = "excavationdrill"
	req_tech = list(TECH_MATERIAL = 3, TECH_POWER = 2, TECH_ENGINEERING = 2, TECH_BLUESPACE = 3)
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 4000, MAT_GLASS = 4000)
	build_path = /obj/item/pickaxe/excavationdrill
	sort_string = "GAAAC"

/datum/design/obj/item/anobattery
	name = "Anomaly power battery - Basic"
	id = "anobattery-basic"
	req_tech = list(TECH_MATERIAL = 2, TECH_POWER = 4, TECH_ENGINEERING = 2)
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 6000, MAT_GLASS = 6000)
	build_path = /obj/item/anobattery
	sort_string = "GAAAD"

/datum/design/obj/item/anobattery_mid
	name = "Anomaly power battery - Moderate"
	id = "anobattery-moderate"
	req_tech = list(TECH_MATERIAL = 5, TECH_POWER = 4, TECH_ENGINEERING = 4)
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 5000, MAT_GLASS = 5000, MAT_SILVER = 2000) //Same object, different materials
	build_path = /obj/item/anobattery/moderate
	sort_string = "GAAAE"

/datum/design/obj/item/anobattery_advanced
	name = "Anomaly power battery - Advanced"
	id = "anobattery-advanced"
	req_tech = list(TECH_MATERIAL = 6, TECH_POWER = 6, TECH_ENGINEERING = 5, TECH_BLUESPACE = 5, TECH_DATA = 4)
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 2500, MAT_GLASS = 2500, MAT_SILVER = 2000, MAT_GOLD = 2500, MAT_PHORON = 2500)
	build_path = /obj/item/anobattery/advanced
	sort_string = "GAAAF"

/datum/design/obj/item/anobattery_exotic
	name = "Anomaly power battery - Exotic"
	id = "anobattery-exotic"
	req_tech = list(TECH_MATERIAL = 8, TECH_POWER = 7, TECH_ENGINEERING = 6, TECH_BLUESPACE = 6,  TECH_DATA = 6, TECH_PRECURSOR = 2)
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 1500, MAT_GLASS = 1500, MAT_SILVER = 1500, MAT_GOLD = 1500, MAT_PHORON = 2000, MAT_DIAMOND = 2000, MAT_MORPHIUM = 2000)
	build_path = /obj/item/anobattery/exotic
	sort_string = "GAAAG"
