/*
*	Here is where any supply packs
*	related to materials live.
*/


/datum/supply_packs/materials
	group = "Materials"

/datum/supply_packs/materials/metal50
	name = "50 metal sheets"
	contains = list(/obj/item/stack/material/steel)
	amount = 50
	cost = 10
	containertype = /obj/structure/closet/crate
	containername = "Metal sheets crate"

/datum/supply_packs/materials/glass50
	name = "50 glass sheets"
	contains = list(/obj/item/stack/material/glass)
	amount = 50
	cost = 10
	containertype = /obj/structure/closet/crate
	containername = "Glass sheets crate"

/datum/supply_packs/materials/wood50
	name = "50 wooden planks"
	contains = list(/obj/item/stack/material/wood)
	amount = 50
	cost = 10
	containertype = /obj/structure/closet/crate
	containername = "Wooden planks crate"

/datum/supply_packs/materials/plastic50
	name = "50 plastic sheets"
	contains = list(/obj/item/stack/material/plastic)
	amount = 50
	cost = 10
	containertype = /obj/structure/closet/crate
	containername = "Plastic sheets crate"

/datum/supply_packs/materials/cardboard_sheets
	contains = list(/obj/item/stack/material/cardboard)
	name = "50 cardboard sheets"
	amount = 50
	cost = 10
	containertype = /obj/structure/closet/crate
	containername = "Cardboard sheets crate"

/datum/supply_packs/materials/carpet
	name = "Imported carpet"
	containertype = /obj/structure/closet/crate
	containername = "Imported carpet crate"
	cost = 15
	contains = list(
					/obj/item/stack/tile/carpet,
					/obj/item/stack/tile/carpet/blue
					)
	amount = 50


/datum/supply_packs/misc/linoleum
	name = "Linoleum"
	containertype = /obj/structure/closet/crate
	containername = "Linoleum crate"
	cost = 15
	contains = list(/obj/item/stack/tile/linoleum)
	amount = 50