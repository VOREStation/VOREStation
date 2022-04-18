/*
*	Here is where any supply packs
*	related to civilian tasks live
*/

/datum/supply_pack/supply
	group = "Supplies"

/datum/supply_pack/supply/food
	name = "Kitchen supply crate"
	contains = list(
			/obj/item/reagent_containers/food/condiment/flour = 6,
			/obj/item/reagent_containers/food/drinks/milk = 3,
			/obj/item/reagent_containers/food/drinks/soymilk = 2,
			/obj/item/storage/fancy/egg_box = 2,
			/obj/item/reagent_containers/food/snacks/tofu = 4,
			/obj/item/reagent_containers/food/snacks/meat = 4,
			/obj/item/reagent_containers/food/condiment/yeast = 3
			)
	cost = 10
	containertype = /obj/structure/closet/crate/freezer/centauri
	containername = "Food crate"

/datum/supply_pack/supply/toner
	name = "Toner cartridges"
	contains = list(/obj/item/toner = 6)
	cost = 10
	containertype = /obj/structure/closet/crate/ummarcar
	containername = "Toner cartridges"

/datum/supply_pack/supply/janitor
	name = "Janitorial supplies"
	contains = list(
			/obj/item/reagent_containers/glass/bucket,
			/obj/item/mop,
			/obj/item/clothing/under/rank/janitor,
			/obj/item/cartridge/janitor,
			/obj/item/clothing/gloves/black,
			/obj/item/clothing/head/soft/purple,
			/obj/item/storage/belt/janitor,
			/obj/item/clothing/shoes/galoshes,
			/obj/item/clothing/suit/caution = 4,
			/obj/item/storage/bag/trash,
			/obj/item/lightreplacer,
			/obj/item/reagent_containers/spray/cleaner,
			/obj/item/reagent_containers/glass/rag,
			/obj/item/grenade/chem_grenade/cleaner = 3,
			/obj/structure/mopbucket
			)
	cost = 10
	containertype = /obj/structure/closet/crate/galaksi
	containername = "Janitorial supplies"

/datum/supply_pack/supply/shipping
	name = "Shipping supplies"
	contains = list(
				/obj/fiftyspawner/cardboard,
				/obj/item/packageWrap = 4,
				/obj/item/wrapping_paper = 2,
				/obj/item/destTagger,
				/obj/item/hand_labeler,
				/obj/item/tool/wirecutters,
				/obj/item/tape_roll = 2)
	cost = 10
	containertype = /obj/structure/closet/crate/ummarcar
	containername = "Shipping supplies crate"

/datum/supply_pack/supply/bureaucracy
	contains = list(
<<<<<<< HEAD
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
			/obj/structure/filingcabinet/chestdrawer{anchored = FALSE},
			/obj/item/weapon/paper_bin
=======
			/obj/item/clipboard = 2,
			/obj/item/pen/red,
			/obj/item/pen/blue,
			/obj/item/pen/blue,
			/obj/item/camera_film,
			/obj/item/folder/blue,
			/obj/item/folder/red,
			/obj/item/folder/yellow,
			/obj/item/hand_labeler,
			/obj/item/tape_roll,
			/obj/structure/filingcabinet/chestdrawer{anchored = 0},
			/obj/item/paper_bin
>>>>>>> 61084723c7b... Merge pull request #8317 from Atermonera/remove_weapon
			)
	name = "Office supplies"
	cost = 15
	containertype = /obj/structure/closet/crate/ummarcar
	containername = "Office supplies crate"

/datum/supply_pack/supply/sticky_notes
	name = "Stationery - sticky notes (50)"
	contains = list(/obj/item/sticky_pad/random)
	cost = 10
	containertype = /obj/structure/closet/crate/ummarcar
	containername = "\improper Sticky notes crate"

/datum/supply_pack/supply/spare_pda
	name = "Spare PDAs"
	cost = 10
	containertype = /obj/structure/closet/crate/thinktronic
	containername = "Spare PDA crate"
	contains = list(/obj/item/pda = 3)

/datum/supply_pack/supply/minergear
	name = "Shaft miner equipment"
	contains = list(
			/obj/item/storage/backpack/industrial,
			/obj/item/storage/backpack/satchel/eng,
			/obj/item/clothing/suit/storage/hooded/wintercoat/miner,
			/obj/item/radio/headset/headset_cargo,
			/obj/item/clothing/under/rank/miner,
			/obj/item/clothing/gloves/black,
			/obj/item/clothing/shoes/black,
			/obj/item/analyzer,
			/obj/item/storage/bag/ore,
			/obj/item/flashlight/lantern,
			/obj/item/shovel,
			/obj/item/pickaxe,
			/obj/item/mining_scanner,
			/obj/item/clothing/glasses/material,
			/obj/item/clothing/glasses/meson
			)
	cost = 10
	containertype = /obj/structure/closet/crate/secure/xion
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
	containertype = /obj/structure/closet/crate/large/xion
	containername = "Cargo Train Tug Crate"

/datum/supply_pack/supply/cargotrailer
	name = "Cargo Train Trolley"
	contains = list(/obj/vehicle/train/trolley)
	cost = 15
	containertype = /obj/structure/closet/crate/large/xion
	containername = "Cargo Train Trolley Crate"

/datum/supply_pack/explorergear
	name="Explorer gear"
	contains = list (
					/obj/item/device/cataloguer,
					/obj/item/device/geiger,
					/obj/item/clothing/suit/storage/hooded/explorer,
					/obj/item/device/flashlight/glowstick,
					/obj/item/device/flashlight,
					/obj/item/stack/marker_beacon/thirty,
					/obj/item/weapon/storage/belt/explorer,
					/obj/item/clothing/mask/gas/explorer,
					/obj/item/weapon/cartridge/explorer,
			 		/obj/item/device/gps/explorer,
			 		/obj/item/clothing/under/explorer,
			 		/obj/item/device/radio/headset/explorer,
			 		/obj/item/clothing/shoes/boots/winter/explorer,
					/obj/item/weapon/material/knife/tacknife/survival,
					/obj/item/weapon/material/knife/machete,
			 		/obj/item/clothing/accessory/holster/machete,
					)
	cost=25
	containertype = /obj/structure/closet/crate/secure/xion
	containername = "Explorer equipment"
	access = access_explorer

/datum/supply_pack/pilotgear
	name= "Pilot gear"
	contains = list (
					/obj/item/weapon/storage/backpack/parachute,
					/obj/item/device/radio/headset/pilot,
					/obj/item/device/radio/headset/pilot/alt,
					/obj/item/clothing/mask/gas/half,
					/obj/item/device/flashlight/glowstick,
					/obj/item/stack/marker_beacon/thirty,
					/obj/item/device/gps/explorer,
					/obj/item/clothing/gloves/fingerless,
					/obj/item/device/cataloguer/compact,
					/obj/item/clothing/suit/storage/toggle/bomber/pilot,
			 		/obj/item/clothing/shoes/boots/winter/explorer,
					/obj/item/device/flashlight,
					/obj/item/weapon/material/knife/tacknife/survival,
					/obj/item/clothing/head/pilot_vr,
					/obj/item/clothing/under/rank/pilot1,
					)
	cost=20
	containertype = /obj/structure/closet/crate/secure/xion
	containername = "Pilot equipment"
	access = access_pilot

