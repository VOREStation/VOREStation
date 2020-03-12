/*
*	Here is where any supply packs
*	related to civilian tasks live
*/

/datum/supply_pack/supply
	group = "Supplies"

/datum/supply_pack/supply/food
	name = "Kitchen supply crate"
	contains = list(
			/obj/item/weapon/reagent_containers/food/condiment/flour = 6,
			/obj/item/weapon/reagent_containers/food/drinks/milk = 3,
			/obj/item/weapon/reagent_containers/food/drinks/soymilk = 2,
			/obj/item/weapon/storage/fancy/egg_box = 2,
			/obj/item/weapon/reagent_containers/food/snacks/tofu = 4,
			/obj/item/weapon/reagent_containers/food/snacks/meat = 4,
			/obj/item/weapon/reagent_containers/food/condiment/yeast = 3
			)
	cost = 10
	containertype = /obj/structure/closet/crate/freezer
	containername = "Food crate"

/datum/supply_pack/supply/toner
	name = "Toner cartridges"
	contains = list(/obj/item/device/toner = 6)
	cost = 10
	containertype = /obj/structure/closet/crate
	containername = "Toner cartridges"

/datum/supply_pack/supply/janitor
	name = "Janitorial supplies"
	contains = list(
			/obj/item/weapon/reagent_containers/glass/bucket,
			/obj/item/weapon/mop,
			/obj/item/clothing/under/rank/janitor,
			/obj/item/weapon/cartridge/janitor,
			/obj/item/clothing/gloves/black,
			/obj/item/clothing/head/soft/purple,
			/obj/item/weapon/storage/belt/janitor,
			/obj/item/clothing/shoes/galoshes,
			/obj/item/weapon/caution = 4,
			/obj/item/weapon/storage/bag/trash,
			/obj/item/device/lightreplacer,
			/obj/item/weapon/reagent_containers/spray/cleaner,
			/obj/item/weapon/reagent_containers/glass/rag,
			/obj/item/weapon/grenade/chem_grenade/cleaner = 3,
			/obj/structure/mopbucket
			)
	cost = 10
	containertype = /obj/structure/closet/crate
	containername = "Janitorial supplies"

/datum/supply_pack/supply/shipping
	name = "Shipping supplies"
	contains = list(
				/obj/fiftyspawner/cardboard,
				/obj/item/weapon/packageWrap = 4,
				/obj/item/weapon/wrapping_paper = 2,
				/obj/item/device/destTagger,
				/obj/item/weapon/hand_labeler,
				/obj/item/weapon/tool/wirecutters,
				/obj/item/weapon/tape_roll = 2)
	cost = 10
	containertype = /obj/structure/closet/crate
	containername = "Shipping supplies crate"

/datum/supply_pack/supply/bureaucracy
	contains = list(
			/obj/item/weapon/clipboard = 2,
			/obj/item/weapon/pen/red,
			/obj/item/weapon/pen/blue,
			/obj/item/weapon/pen/blue,
			/obj/item/device/camera_film,
			/obj/item/weapon/folder/blue,
			/obj/item/weapon/folder/red,
			/obj/item/weapon/folder/yellow,
			/obj/item/weapon/hand_labeler,
			/obj/item/weapon/tape_roll,
			/obj/structure/filingcabinet/chestdrawer{anchored = 0},
			/obj/item/weapon/paper_bin
			)
	name = "Office supplies"
	cost = 15
	containertype = /obj/structure/closet/crate
	containername = "Office supplies crate"

/datum/supply_pack/supply/spare_pda
	name = "Spare PDAs"
	cost = 10
	containertype = /obj/structure/closet/crate
	containername = "Spare PDA crate"
	contains = list(/obj/item/device/pda = 3)

/datum/supply_pack/supply/minergear
	name = "Shaft miner equipment"
	contains = list(
			/obj/item/weapon/storage/backpack/industrial,
			/obj/item/weapon/storage/backpack/satchel/eng,
			/obj/item/clothing/suit/storage/hooded/wintercoat/miner,
			/obj/item/device/radio/headset/headset_cargo,
			/obj/item/clothing/under/rank/miner,
			/obj/item/clothing/gloves/black,
			/obj/item/clothing/shoes/black,
			/obj/item/device/analyzer,
			/obj/item/weapon/storage/bag/ore,
			/obj/item/device/flashlight/lantern,
			/obj/item/weapon/shovel,
			/obj/item/weapon/pickaxe,
			/obj/item/weapon/mining_scanner,
			/obj/item/clothing/glasses/material,
			/obj/item/clothing/glasses/meson
			)
	cost = 10
	containertype = /obj/structure/closet/crate/secure
	containername = "Shaft miner equipment"
	access = access_mining
/* //VOREStation Edit - Pointless on Tether.
/datum/supply_pack/supply/mule
	name = "Mulebot Crate"
	contains = list()
	cost = 20
	containertype = /obj/structure/largecrate/animal/mulebot
	containername = "Mulebot Crate"
*/ //VOREStation Edit
/datum/supply_pack/supply/cargotrain
	name = "Cargo Train Tug"
	contains = list(/obj/vehicle/train/engine)
	cost = 35
	containertype = /obj/structure/largecrate
	containername = "Cargo Train Tug Crate"

/datum/supply_pack/supply/cargotrailer
	name = "Cargo Train Trolley"
	contains = list(/obj/vehicle/train/trolley)
	cost = 15
	containertype = /obj/structure/largecrate
	containername = "Cargo Train Trolley Crate"
