/datum/design/item/weapon/xenobio/monkey_gun
	name = "bluespace monkey deployment system"
	desc = "An Advanced monkey teleportation and rehydration system. For serious monkey business."
	id = "monkey_gun"
	req_tech = list(TECH_BIO = 6, TECH_BLUESPACE = 5)
	materials = list(MAT_STEEL = 3500, MAT_GLASS = 3500, MAT_PHORON = 1500, MAT_DIAMOND = 1500)
	build_path = /obj/item/xenobio/monkey_gun
	sort_string = "HBBA"

/datum/design/item/weapon/xenobio/grinder
	name = "portable slime processor"
	desc = "This high tech device combines the slime processor with the latest in woodcutting technology."
	id = "slime_grinder"
	req_tech = list(TECH_MAGNET = 4, TECH_BIO = 5)
	materials = list(MAT_STEEL = 200, MAT_GLASS = 200, MAT_SILVER = 500, MAT_GOLD = 100)
	build_path = /obj/item/slime_grinder
	sort_string = "HBBB"
