/*
	P - teleporteing item stuff
*/

/datum/design/item/teleport/AssembleDesignName()
	..()
	name = "Teleportation device prototype ([item_name])"

/datum/design/item/teleport/translocator
	name = "Personal translocator"
	id = "translocator"
	req_tech = list(TECH_MAGNET = 5, TECH_BLUESPACE = 5, TECH_ILLEGAL = 6)
	materials = list(MAT_STEEL = 4000, MAT_GLASS = 2000, MAT_URANIUM = 4000, MAT_DIAMOND = 2000)
	build_path = /obj/item/perfect_tele
	sort_string = "PAAAA"

/datum/design/item/teleport/bluespace_crystal
	name = "Artificial Bluespace Crystal"
	id = "bluespace_crystal"
	req_tech = list(TECH_BLUESPACE = 3, TECH_PHORON = 4)
	materials = list(MAT_DIAMOND = 1500, MAT_PHORON = 1500)
	build_path = /obj/item/bluespace_crystal/artificial
	sort_string = "PAAAB"
