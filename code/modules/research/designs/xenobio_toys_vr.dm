/datum/design/item/weapon/xenobio/monkey_gun
	id = "bluespace monkey deployment system"
	req_tech = list(TECH_MATERIAL = 3, TECH_BIO = 3, TECH_POWER = 4, TECH_COMBAT = 4, TECH_BLUESPACE = 6)
	materials = list(MAT_PLASTEEL = 5000, MAT_GLASS = 5000, MAT_DIAMOND = 500, MAT_MORPHIUM = 350)
	build_path = /obj/item/weapon/xenobio/monkey_gun
	sort_string = "HBBA"

/datum/design/item/weapon/xenobio/grinder
	name = "portable slime processor"
	desc = "This high tech device combines the slime processor with the latest in woodcutting technology."
	id = "slime_scanner"
	req_tech = list(TECH_MAGNET = 4, TECH_BIO = 7)
	materials = list(MAT_STEEL = 500, MAT_GLASS = 500, MAT_DIAMOND = 500, MAT_MORPHIUM = 100)
	build_path = /obj/item/weapon/slime_grinder
	sort_string = "HBBB"