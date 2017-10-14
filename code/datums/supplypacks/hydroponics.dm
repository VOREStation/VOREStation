/*
*	Here is where any supply packs
*	related to hydroponics tasks live.
*/


/datum/supply_packs/hydro
	group = "Hydroponics"

/datum/supply_packs/hydro/monkey
	name = "Monkey crate"
	contains = list (/obj/item/weapon/storage/box/monkeycubes)
	cost = 20
	containertype = /obj/structure/closet/crate/freezer
	containername = "Monkey crate"

/datum/supply_packs/hydro/farwa
	name = "Farwa crate"
	contains = list (/obj/item/weapon/storage/box/monkeycubes/farwacubes)
	cost = 20
	containertype = /obj/structure/closet/crate/freezer
	containername = "Farwa crate"

/datum/supply_packs/hydro/neara
	name = "Neaera crate"
	contains = list (/obj/item/weapon/storage/box/monkeycubes/neaeracubes)
	cost = 20
	containertype = /obj/structure/closet/crate/freezer
	containername = "Neaera crate"

/datum/supply_packs/hydro/stok
	name = "Stok crate"
	contains = list (/obj/item/weapon/storage/box/monkeycubes/stokcubes)
	cost = 20
	containertype = /obj/structure/closet/crate/freezer
	containername = "Stok crate"

/datum/supply_packs/hydro/lisa
	name = "Corgi Crate"
	contains = list()
	cost = 50
	containertype = /obj/structure/largecrate/animal/corgi
	containername = "Corgi Crate"

/datum/supply_packs/hydro/hydroponics
	name = "Hydroponics Supply Crate"
	contains = list(
			/obj/item/weapon/reagent_containers/spray/plantbgone = 4,
			/obj/item/weapon/reagent_containers/glass/bottle/ammonia = 2,
			/obj/item/weapon/material/hatchet,
			/obj/item/weapon/material/minihoe,
			/obj/item/device/analyzer/plant_analyzer,
			/obj/item/clothing/gloves/botanic_leather,
			/obj/item/clothing/suit/storage/apron,
			/obj/item/weapon/material/minihoe,
			/obj/item/weapon/storage/box/botanydisk
			)
	cost = 20
	containertype = /obj/structure/closet/crate/hydroponics
	containername = "Hydroponics crate"
	access = access_hydroponics

/datum/supply_packs/hydro/cow
	name = "Cow crate"
	cost = 25
	containertype = /obj/structure/largecrate/animal/cow
	containername = "Cow crate"
	access = access_hydroponics

/datum/supply_packs/hydro/goat
	name = "Goat crate"
	cost = 25
	containertype = /obj/structure/largecrate/animal/goat
	containername = "Goat crate"
	access = access_hydroponics

/datum/supply_packs/hydro/chicken
	name = "Chicken crate"
	cost = 25
	containertype = /obj/structure/largecrate/animal/chick
	containername = "Chicken crate"
	access = access_hydroponics

/datum/supply_packs/hydro/seeds
	name = "Seeds crate"
	contains = list(
			/obj/item/seeds/chiliseed,
			/obj/item/seeds/berryseed,
			/obj/item/seeds/cornseed,
			/obj/item/seeds/eggplantseed,
			/obj/item/seeds/tomatoseed,
			/obj/item/seeds/appleseed,
			/obj/item/seeds/soyaseed,
			/obj/item/seeds/wheatseed,
			/obj/item/seeds/carrotseed,
			/obj/item/seeds/harebell,
			/obj/item/seeds/lemonseed,
			/obj/item/seeds/orangeseed,
			/obj/item/seeds/grassseed,
			/obj/item/seeds/sunflowerseed,
			/obj/item/seeds/chantermycelium,
			/obj/item/seeds/potatoseed,
			/obj/item/seeds/sugarcaneseed
			)
	cost = 10
	containertype = /obj/structure/closet/crate/hydroponics
	containername = "Seeds crate"
	access = access_hydroponics

/datum/supply_packs/hydro/weedcontrol
	name = "Weed control crate"
	contains = list(
			/obj/item/weapon/material/hatchet = 2,
			/obj/item/weapon/reagent_containers/spray/plantbgone = 4,
			/obj/item/clothing/mask/gas = 2,
			/obj/item/weapon/grenade/chem_grenade/antiweed = 2,
			/obj/item/weapon/material/twohanded/fireaxe/scythe
			)
	cost = 45
	containertype = /obj/structure/closet/crate/hydroponics
	containername = "Weed control crate"
	access = access_hydroponics

/datum/supply_packs/hydro/watertank
	name = "Water tank crate"
	contains = list(/obj/structure/reagent_dispensers/watertank)
	cost = 10
	containertype = /obj/structure/largecrate
	containername = "water tank crate"

/datum/supply_packs/hydro/bee_keeper
	name = "Beekeeping crate"
	contains = list(
			/obj/item/beehive_assembly,
			/obj/item/bee_smoker,
			/obj/item/honey_frame = 5,
			/obj/item/bee_pack
			)
	cost = 40
	containertype = /obj/structure/closet/crate/hydroponics
	containername = "Beekeeping crate"
	access = access_hydroponics

/datum/supply_packs/hydro/tray
	name = "Empty hydroponics trays"
	cost = 50
	containertype = /obj/structure/closet/crate/hydroponics
	containername = "Hydroponics tray crate"
	contains = list(/obj/machinery/portable_atmospherics/hydroponics{anchored = 0} = 3)
	access = access_hydroponics

