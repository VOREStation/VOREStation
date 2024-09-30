/datum/design/item/xenobio/monkey_gun
	name = "bluespace monkey deployment system"
	desc = "An Advanced monkey teleportation and rehydration system. For serious monkey business."
	id = "monkey_gun"
	req_tech = list(TECH_MATERIAL = 3, TECH_BIO = 3, TECH_POWER = 4, TECH_COMBAT = 4, TECH_BLUESPACE = 6)
	materials = list(MAT_PLASTEEL = 5000, MAT_GLASS = 5000, MAT_DIAMOND = 500, MAT_MORPHIUM = 350)
	build_path = /obj/item/xenobio/monkey_gun
	sort_string = "HBBA"

/datum/design/item/xenobio/grinder
	name = "portable slime processor"
	desc = "This high tech device combines the slime processor with the latest in woodcutting technology."
	id = "slime_grinder"
	req_tech = list(TECH_MAGNET = 4, TECH_BIO = 7)
	materials = list(MAT_STEEL = 500, MAT_GLASS = 500, MAT_DIAMOND = 500, MAT_MORPHIUM = 100)
	build_path = /obj/item/slime_grinder
	sort_string = "HBBB"
