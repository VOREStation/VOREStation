/*
*	Here is where any supply packs
*	related to hydroponics tasks live.
*/


/datum/supply_pack/hydro
	group = "Hydroponics"

/datum/supply_pack/hydro/monkey
	name = "Monkey crate"
	contains = list (/obj/item/storage/box/monkeycubes)
	cost = 20
	containertype = /obj/structure/closet/crate/freezer/nanotrasen
	containername = "Monkey crate"

/datum/supply_pack/hydro/farwa
	name = "Farwa crate"
	contains = list (/obj/item/storage/box/monkeycubes/farwacubes)
	cost = 20
	containertype = /obj/structure/closet/crate/freezer
	containername = "Farwa crate"

/datum/supply_pack/hydro/neara
	name = "Neaera crate"
	contains = list (/obj/item/storage/box/monkeycubes/neaeracubes)
	cost = 20
	containertype = /obj/structure/closet/crate/freezer
	containername = "Neaera crate"

/datum/supply_pack/hydro/stok
	name = "Stok crate"
	contains = list (/obj/item/storage/box/monkeycubes/stokcubes)
	cost = 20
	containertype = /obj/structure/closet/crate/freezer
	containername = "Stok crate"

/datum/supply_pack/hydro/lisa
	name = "Corgi Crate"
	contains = list()
	cost = 50
	containertype = /obj/structure/largecrate/animal/corgi
	containername = "Corgi Crate"

/datum/supply_pack/hydro/cat
	name = "Cat Crate"
	contains = list()
	cost = 45
	containertype = /obj/structure/largecrate/animal/cat
	containername = "Cat Crate"

/datum/supply_pack/hydro/catslug
	name = "Catslug Crate"
	contains = list()
	cost = 200
	containertype = /obj/structure/largecrate/animal/catslug
	containername = "Catslug Crate"

/datum/supply_pack/hydro/hydroponics
	name = "Hydroponics Supply Crate"
	contains = list(
			/obj/item/reagent_containers/spray/plantbgone = 4,
			/obj/item/reagent_containers/glass/bottle/ammonia = 2,
			/obj/item/material/knife/machete/hatchet,
			/obj/item/material/minihoe,
			/obj/item/analyzer/plant_analyzer,
			/obj/item/clothing/gloves/botanic_leather,
			/obj/item/clothing/suit/storage/apron,
			/obj/item/material/minihoe,
			/obj/item/storage/box/botanydisk
			)
	cost = 20
	containertype = /obj/structure/closet/crate/hydroponics
	containername = "Hydroponics crate"
	access = access_hydroponics

/datum/supply_pack/hydro/cow
	name = "Cow crate"
	cost = 25
	containertype = /obj/structure/largecrate/animal/cow
	containername = "Cow crate"
	access = access_hydroponics

/datum/supply_pack/hydro/goat
	name = "Goat crate"
	cost = 25
	containertype = /obj/structure/largecrate/animal/goat
	containername = "Goat crate"
	access = access_hydroponics

/datum/supply_pack/hydro/chicken
	name = "Chicken crate"
	cost = 25
	containertype = /obj/structure/largecrate/animal/chick
	containername = "Chicken crate"
	access = access_hydroponics

/datum/supply_pack/hydro/seeds
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
	containertype = /obj/structure/closet/crate/carp
	containername = "Seeds crate"
	access = access_hydroponics

/datum/supply_pack/hydro/weedcontrol
	name = "Weed control crate"
	contains = list(
			/obj/item/material/knife/machete/hatchet = 2,
			/obj/item/reagent_containers/spray/plantbgone = 4,
			/obj/item/clothing/mask/gas = 2,
			/obj/item/grenade/chem_grenade/antiweed = 2,
			/obj/item/material/twohanded/fireaxe/scythe
			)
	cost = 45
	containertype = /obj/structure/closet/crate/grayson
	containername = "Weed control crate"
	access = access_hydroponics

/datum/supply_pack/hydro/watertank
	name = "Water tank crate"
	contains = list(/obj/structure/reagent_dispensers/watertank)
	cost = 10
	containertype = /obj/structure/closet/crate/large/aether
	containername = "water tank crate"

/datum/supply_pack/hydro/bee_keeper
	name = "Beekeeping crate"
	contains = list(
			/obj/item/beehive_assembly,
			/obj/item/bee_smoker,
			/obj/item/honey_frame = 5,
			/obj/item/bee_pack
			)
	cost = 40
	containertype = /obj/structure/closet/crate/carp
	containername = "Beekeeping crate"
	access = access_hydroponics

/datum/supply_pack/hydro/tray
	name = "Empty hydroponics trays"
	cost = 50
	containertype = /obj/structure/closet/crate/aether
	containername = "Hydroponics tray crate"
	contains = list(/obj/machinery/portable_atmospherics/hydroponics{anchored = FALSE} = 3)
	access = access_hydroponics

<<<<<<< HEAD
=======
/datum/supply_pack/hydro/fish
	name = "Seafood supply crate"
	contains = list(
			/obj/item/reagent_containers/food/snacks/lobster = 6,
			/obj/item/reagent_containers/food/snacks/cuttlefish = 8,
			/obj/item/reagent_containers/food/snacks/sliceable/monkfish = 1
			)
	cost = 20
	containertype = /obj/structure/closet/crate/freezer/centauri
	containername = "Fresh fish crate"
>>>>>>> 61084723c7b... Merge pull request #8317 from Atermonera/remove_weapon
