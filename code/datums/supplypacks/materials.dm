/*
*	Here is where any supply packs
*	related to materials live.
*/


/datum/supply_pack/materials
	group = "Materials"

/datum/supply_pack/materials/metal50
	name = "50 metal sheets"
	contains = list(/obj/fiftyspawner/steel)
	cost = 10
	containertype = /obj/structure/closet/crate/grayson
	containername = "Metal sheets crate"

/datum/supply_pack/materials/glass50
	name = "50 glass sheets"
	contains = list(/obj/fiftyspawner/glass)
	cost = 10
	containertype = /obj/structure/closet/crate/grayson
	containername = "Glass sheets crate"

/datum/supply_pack/materials/wood50
	name = "50 wooden planks"
	contains = list(/obj/fiftyspawner/wood)
	cost = 10
	containertype = /obj/structure/closet/crate/grayson
	containername = "Wooden planks crate"

/datum/supply_pack/materials/hardwood50
	name = "50 hardwood planks"
	contains = list(/obj/fiftyspawner/hardwood)
	cost = 50
	containertype = /obj/structure/closet/crate/gilthari
	containername = "Hardwood planks crate"

/datum/supply_pack/materials/plastic50
	name = "50 plastic sheets"
	contains = list(/obj/fiftyspawner/plastic)
	cost = 10
	containertype = /obj/structure/closet/crate/grayson
	containername = "Plastic sheets crate"

/datum/supply_pack/materials/copper50
	name = "50 copper ingots"
	contains = list(/obj/fiftyspawner/copper)
	cost = 60
	containertype = /obj/structure/closet/crate/grayson
	containername = "Copper ingots crate"

/datum/supply_pack/materials/cardboard_sheets
	contains = list(/obj/fiftyspawner/cardboard)
	name = "50 cardboard sheets"
	cost = 10
	containertype = /obj/structure/closet/crate/grayson
	containername = "Cardboard sheets crate"

/datum/supply_pack/materials/carpet
	name = "Imported carpet"
	containertype = /obj/structure/closet/crate/grayson
	containername = "Imported carpet crate"
	cost = 15
	contains = list(
					/obj/fiftyspawner/carpet,
					/obj/fiftyspawner/tealcarpet
					)

/datum/supply_pack/materials/retrocarpet
	name = "Retro carpet"
	containertype = /obj/structure/closet/crate/grayson
	containername = "Retro carpet crate"
	cost = 15
	contains = list(
					/obj/fiftyspawner/geocarpet,
					/obj/fiftyspawner/retrocarpet,
					/obj/fiftyspawner/retrocarpet_red,
					/obj/fiftyspawner/happycarpet
					)

/datum/supply_pack/materials/linoleum
	name = "Linoleum"
	containertype = /obj/structure/closet/crate/grayson
	containername = "Linoleum crate"
	cost = 15
	contains = list(/obj/fiftyspawner/linoleum)

/datum/supply_pack/materials/concrete
	name = "Concrete"
	cost = 10
	containertype = /obj/structure/closet/crate/grayson
	contains = list(/obj/fiftyspawner/concrete)
	containername = "Concrete bricks crate"