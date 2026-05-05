/*
*	Here is where any supply packs
*	related to materials live.
*/


/datum/supply_pack/materials
	group = "Materials"
	desc = "A stack of fifty sheets (or ingots)."

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

/datum/supply_pack/materials/birch50
	name = "50 birch planks"
	contains = list(/obj/fiftyspawner/birchwood)
	cost = 10
	containertype = /obj/structure/closet/crate/grayson
	containername = "Birch planks crate"

/datum/supply_pack/materials/oak50
	name = "50 oak planks"
	contains = list(/obj/fiftyspawner/oakwood)
	cost = 10
	containertype = /obj/structure/closet/crate/grayson
	containername = "Oak planks crate"

/datum/supply_pack/materials/pine50
	name = "50 pine planks"
	contains = list(/obj/fiftyspawner/pinewood)
	cost = 10
	containertype = /obj/structure/closet/crate/grayson
	containername = "Pine planks crate"

/datum/supply_pack/materials/alienwood50
	name = "50 alien wood planks"
	contains = list(/obj/fiftyspawner/sifwood)
	cost = 10
	containertype = /obj/structure/closet/crate/grayson
	containername = "Alien wood planks crate"

/datum/supply_pack/materials/acacia50
	name = "50 acacia planks"
	contains = list(/obj/fiftyspawner/acaciawood)
	cost = 35
	containertype = /obj/structure/closet/crate/gilthari
	containername = "Acacia planks crate"

/datum/supply_pack/materials/hardwood50
	name = "50 hardwood planks"
	contains = list(/obj/fiftyspawner/hardwood)
	cost = 50
	containertype = /obj/structure/closet/crate/gilthari
	containername = "Hardwood planks crate"

/datum/supply_pack/materials/redwood50
	name = "50 redwood planks"
	contains = list(/obj/fiftyspawner/redwood)
	cost = 50
	containertype = /obj/structure/closet/crate/gilthari
	containername = "Redwood planks crate"

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
	name = "Imported standard carpet"
	desc = "Three standard carpet designs in easy-to-lay tiles."
	containertype = /obj/structure/closet/crate/grayson
	containername = "Imported carpet crate"
	cost = 15
	contains = list(
					/obj/fiftyspawner/carpet,
					/obj/fiftyspawner/tealcarpet,
					/obj/fiftyspawner/turcarpet
					)

/datum/supply_pack/materials/carpet_ornate
	name = "Imported ornate carpet"
	desc = "Ornate, high-quality carpet in easy-to-lay tiles."
	containertype = /obj/structure/closet/crate/grayson
	containername = "Imported ornate carpet crate"
	cost = 20
	contains = list(
					/obj/fiftyspawner/brncarpet,
					/obj/fiftyspawner/blucarpet2,
					/obj/fiftyspawner/greencarpet,
					/obj/fiftyspawner/purplecarpet
					)

/datum/supply_pack/materials/carpet_diamond
	name = "Imported diamond carpet"
	desc = "Classy diamond-patterned carpets in easy-to-lay tiles."
	containertype = /obj/structure/closet/crate/grayson
	containername = "Imported diamond carpet crate"
	cost = 30
	contains = list(
					/obj/fiftyspawner/bcarpet,
					/obj/fiftyspawner/blucarpet,
					/obj/fiftyspawner/sblucarpet,
					/obj/fiftyspawner/gaycarpet,
					/obj/fiftyspawner/purcarpet,
					/obj/fiftyspawner/oracarpet
					)

/datum/supply_pack/materials/retrocarpet
	name = "Imported retro carpet"
	desc = "Terran retro-style carpets in easy-to-lay tiles."
	containertype = /obj/structure/closet/crate/grayson
	containername = "Imported retro carpet crate"
	cost = 20
	contains = list(
					/obj/fiftyspawner/geocarpet,
					/obj/fiftyspawner/retrocarpet,
					/obj/fiftyspawner/retrocarpet_red,
					/obj/fiftyspawner/happycarpet
					)

/datum/supply_pack/materials/linoleum
	name = "Linoleum flooring"
	desc = "Easy-to-clean, easy-to-lay, guaranteed non-stick linoleum floor tiles."
	containertype = /obj/structure/closet/crate/grayson
	containername = "Linoleum crate"
	cost = 15
	contains = list(/obj/fiftyspawner/linoleum)

/datum/supply_pack/materials/concrete
	name = "Concrete blocks"
	desc = "Cheap structural concrete blocks. Rebar sold seperately."
	cost = 10
	containertype = /obj/structure/closet/crate/grayson
	contains = list(/obj/fiftyspawner/concrete)
	containername = "Concrete bricks crate"

/datum/supply_pack/materials/aluminium50
	name = "50 aluminium ingots"
	contains = list(/obj/fiftyspawner/aluminium)
	cost = 120
	containertype = /obj/structure/closet/crate/grayson
	containername = "Aluminium ingots crate"

/datum/supply_pack/materials/iron50
	name = "50 iron ingots"
	contains = list(/obj/fiftyspawner/iron)
	cost = 30
	containertype = /obj/structure/closet/crate/grayson
	containername = "Iron ingots crate"

/datum/supply_pack/materials/uranium50
	name = "50 uranium ingots"
	contains = list(/obj/fiftyspawner/uranium)
	cost = 240
	containertype = /obj/structure/closet/crate/grayson
	containername = "Uranium ingots crate"

/datum/supply_pack/materials/gold50
	name = "50 gold ingots"
	contains = list(/obj/fiftyspawner/gold)
	cost = 240
	containertype = /obj/structure/closet/crate/grayson
	containername = "Gold ingots crate"

/datum/supply_pack/materials/silver50
	name = "50 silver ingots"
	contains = list(/obj/fiftyspawner/silver)
	cost = 120
	containertype = /obj/structure/closet/crate/grayson
	containername = "Silver ingots crate"

/datum/supply_pack/materials/platinum50
	name = "50 platinum ingots"
	contains = list(/obj/fiftyspawner/platinum)
	cost = 600
	containertype = /obj/structure/closet/crate/grayson
	containername = "Platinum ingots crate"

/datum/supply_pack/materials/osmium50
	name = "50 osmium ingots"
	contains = list(/obj/fiftyspawner/osmium)
	cost = 720
	containertype = /obj/structure/closet/crate/grayson
	containername = "Osmium ingots crate"

/datum/supply_pack/materials/titanium50
	name = "50 titanium ingots"
	contains = list(/obj/fiftyspawner/titanium)
	cost = 480
	containertype = /obj/structure/closet/crate/grayson
	containername = "Titanium ingots crate"

/datum/supply_pack/materials/graphite50
	name = "50 graphite ingots"
	contains = list(/obj/fiftyspawner/graphite)
	cost = 25
	containertype = /obj/structure/closet/crate/grayson
	containername = "Graphite ingots crate"

/datum/supply_pack/materials/durasteel50
	name = "50 durasteel ingots"
	contains = list(/obj/fiftyspawner/durasteel)
	cost = 1000
	containertype = /obj/structure/closet/crate/grayson
	containername = "Durasteel ingots crate"

/datum/supply_pack/materials/plasteel50
	name = "50 plasteel ingots"
	contains = list(/obj/fiftyspawner/plasteel)
	cost = 720
	containertype = /obj/structure/closet/crate/grayson
	containername = "Plasteel ingots crate"

/datum/supply_pack/materials/diamond50
	name = "50 diamond ingots"
	contains = list(/obj/fiftyspawner/diamond)
	cost = 960
	containertype = /obj/structure/closet/crate/grayson
	containername = "Diamond ingots crate"

/datum/supply_pack/materials/verdantium50
	name = "50 verdantium ingots"
	contains = list(/obj/fiftyspawner/verdantium)
	cost = 1000
	containertype = /obj/structure/closet/crate/grayson
	containername = "Verdantium ingots crate"

/datum/supply_pack/materials/sandstone50
	name = "50 sandstone blocks"
	contains = list(/obj/fiftyspawner/sandstone)
	cost = 10
	containertype = /obj/structure/closet/crate/grayson
	containername = "Sandstone blocks crate"

/datum/supply_pack/materials/marble50
	name = "50 marble blocks"
	contains = list(/obj/fiftyspawner/marble)
	cost = 10
	containertype = /obj/structure/closet/crate/grayson
	containername = "marble blocks crate"

/datum/supply_pack/materials/leather50
	name = "50 leather bolts"
	contains = list(/obj/fiftyspawner/leather)
	cost = 120
	containertype = /obj/structure/closet/crate/grayson
	containername = "Leather bolts crate"

/datum/supply_pack/materials/phoron50
	name = "50 phoron ingots"
	contains = list(/obj/fiftyspawner/phoron)
	cost = 600
	containertype = /obj/structure/closet/crate/grayson
	containername = "Phoron ingots crate"

/datum/supply_pack/materials/painite50
	name = "50 painite ingots"
	contains = list(/obj/fiftyspawner/painite)
	cost = 480
	containertype = /obj/structure/closet/crate/grayson
	containername = "Painite ingots crate"

/datum/supply_pack/materials/cloth50
	name = "50 cloth bolts"
	contains = list(/obj/fiftyspawner/cloth)
	cost = 120
	containertype = /obj/structure/closet/crate/grayson
	containername = "Cloth bolts crate"
