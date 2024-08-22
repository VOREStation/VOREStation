/*
*	Here is where any supply packs
*	related to civilian tasks live
*/

/datum/supply_pack/supply
	group = "Supplies"

/datum/supply_pack/supply/food
	name = "Kitchen supply crate"
	contains = list(
			/obj/item/weapon/reagent_containers/food/condiment/carton/flour = 6,
			/obj/item/weapon/reagent_containers/food/drinks/milk = 3,
			/obj/item/weapon/reagent_containers/food/drinks/soymilk = 2,
			/obj/item/weapon/storage/fancy/egg_box = 2,
			/obj/item/weapon/reagent_containers/food/snacks/tofu = 4,
			/obj/item/weapon/reagent_containers/food/snacks/meat = 4,
			/obj/item/weapon/reagent_containers/food/condiment/yeast = 3,
			/obj/item/weapon/reagent_containers/food/condiment/sprinkles = 1
			)
	cost = 10
	containertype = /obj/structure/closet/crate/freezer/centauri
	containername = "Food crate"

/datum/supply_pack/supply/fancyfood
	name = "Artisanal food delivery"
	contains = list(
			/obj/item/weapon/reagent_containers/food/condiment/carton/flour/rustic = 6,
			/obj/item/weapon/reagent_containers/food/condiment/carton/sugar/rustic = 6
			)
	cost = 25
	containertype = /obj/structure/closet/crate/freezer/centauri
	containername = "Artisanal food crate"


/datum/supply_pack/supply/toner
	name = "Toner cartridges"
	contains = list(/obj/item/device/toner = 6)
	cost = 10
	containertype = /obj/structure/closet/crate/ummarcar
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
			/obj/item/clothing/suit/caution = 4,
			/obj/item/weapon/storage/bag/trash,
			/obj/item/device/lightreplacer,
			/obj/item/weapon/reagent_containers/spray/cleaner,
			/obj/item/weapon/reagent_containers/glass/rag,
			/obj/item/weapon/grenade/chem_grenade/cleaner = 3,
			/obj/item/clothing/glasses/hud/janitor,
			/obj/structure/mopbucket
			)
	cost = 10
	containertype = /obj/structure/closet/crate/galaksi
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
	containertype = /obj/structure/closet/crate/ummarcar
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
			/obj/structure/filingcabinet/chestdrawer{anchored = FALSE},
			/obj/item/weapon/paper_bin
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
	containertype = /obj/structure/closet/crate/secure/xion
	containername = "Shaft miner equipment"
	access = access_mining

/* //No longer supported on our current maps, as it requires specialized dropoff beacons and the pathfinding doesn't work well on multi-z
//plus we have the destination tagger
/datum/supply_pack/supply/mule
	name = "Mulebot Crate"
	contains = list()
	cost = 20
	containertype = /obj/structure/largecrate/animal/mulebot
	containername = "Mulebot Crate"
*/

/datum/supply_pack/supply/cargotrain
	name = "Cargo Train Tug"
	contains = list(/obj/vehicle/train/engine)
	cost = 35

/datum/supply_pack/supply/cargotrailer
	name = "Cargo Train Trolley"
	contains = list(/obj/vehicle/train/trolley)
	cost = 15

/datum/supply_pack/explorergear
	name="Away Team gear"
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
					/obj/item/clothing/gloves/watch/survival
					)
	cost=25
	containertype = /obj/structure/closet/crate/secure/xion
	containername = "Away Team equipment"
	access = list(access_eva, access_explorer)

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
					/obj/item/clothing/suit/storage/toggle/bomber/pilot,
			 		/obj/item/clothing/shoes/boots/winter/explorer,
					/obj/item/device/flashlight,
					/obj/item/weapon/material/knife/tacknife/survival,
					/obj/item/clothing/head/pilot_vr,
					/obj/item/clothing/under/rank/pilot1,
					/obj/item/weapon/gun/energy/gun/protector/pilotgun/locked,
					/obj/item/clothing/gloves/watch/survival
					)
	cost=20
	containertype = /obj/structure/closet/crate/secure/xion
	containername = "Pilot equipment"
	access = access_pilot

/datum/supply_pack/supply/foodcubes
	name = "Emergency food cubes"
	contains = list(
				/obj/machinery/vending/emergencyfood/filled = 1)
	cost = 75
	containertype = /obj/structure/closet/crate/freezer
	containername = "food cubes"

/datum/supply_pack/pathfindergear
	name="Away Team Leader gear"
	contains = list (
					/obj/item/device/cataloguer/compact/pathfinder,
					/obj/item/device/geiger,
					/obj/item/clothing/suit/storage/hooded/explorer,
					/obj/item/device/flashlight/glowstick,
					/obj/item/device/flashlight,
					/obj/item/stack/marker_beacon/thirty,
					/obj/item/weapon/storage/belt/explorer/pathfinder,
					/obj/item/clothing/mask/gas/explorer,
					/obj/item/weapon/cartridge/explorer,
			 		/obj/item/device/gps/explorer,
			 		/obj/item/clothing/under/explorer,
			 		/obj/item/device/radio/headset/pathfinder,
			 		/obj/item/clothing/shoes/boots/winter/explorer,
					/obj/item/weapon/material/knife/tacknife/survival,
					/obj/item/weapon/material/knife/machete/deluxe,
			 		/obj/item/clothing/accessory/holster/machete,
					/obj/item/weapon/storage/box/explorerkeys,
					/obj/item/device/mapping_unit,
					/obj/item/clothing/gloves/watch/survival
					)
	cost = 75
	containertype = /obj/structure/closet/crate/secure/xion
	containername = "Away Team Leader equipment"
	access = list(access_explorer)
