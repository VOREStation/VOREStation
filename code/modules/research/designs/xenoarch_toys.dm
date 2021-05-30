/datum/design/item/weapon/xenoarch/AssembleDesignName()
	..()
	name = "Xenoarcheology equipment design ([item_name])"

// Xenoarch tools

/datum/design/item/weapon/xenoarch/ano_scanner
	name = "Alden-Saraspova counter"
	id = "ano_scanner"
	desc = "Aids in triangulation of exotic particles."
	req_tech = list(TECH_BLUESPACE = 3, TECH_MAGNET = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 10000,"glass" = 5000)
	build_path = /obj/item/device/ano_scanner
	sort_string = "GAAAA"

/datum/design/item/weapon/xenoarch/xenoarch_multi_tool
	name = "xenoarcheology multitool"
	id = "xenoarch_multitool"
	req_tech = list(TECH_MAGNET = 3, TECH_ENGINEERING = 3, TECH_BLUESPACE = 3)
	build_path = /obj/item/device/xenoarch_multi_tool
	materials = list(DEFAULT_WALL_MATERIAL = 2000, "glass" = 1000, "uranium" = 500, "phoron" = 500)
	sort_string = "GAAAB"

/datum/design/item/weapon/xenoarch/excavationdrill
	name = "Excavation Drill"
	id = "excavationdrill"
	req_tech = list(TECH_MATERIAL = 3, TECH_POWER = 2, TECH_ENGINEERING = 2, TECH_BLUESPACE = 3)
	build_type = PROTOLATHE
	materials = list(DEFAULT_WALL_MATERIAL = 4000, "glass" = 4000)
	build_path = /obj/item/weapon/pickaxe/excavationdrill
	sort_string = "GAAAC"