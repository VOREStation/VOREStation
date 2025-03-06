/*
*	Here is where any supply packs
*	related to civilian tasks live
*/

/datum/supply_pack/supply
	group = "Supplies"

/datum/supply_pack/supply/food
	name = "Kitchen supply crate"
	desc = "An assortment of standard kitchen supplies, fit for preparing a variety of basic meals."
	contains = list(
			/obj/item/reagent_containers/food/condiment/carton/flour = 6,
			/obj/item/reagent_containers/food/drinks/milk = 3,
			/obj/item/reagent_containers/food/drinks/soymilk = 2,
			/obj/item/storage/fancy/egg_box = 2,
			/obj/item/reagent_containers/food/snacks/tofu = 4,
			/obj/item/reagent_containers/food/snacks/meat = 4,
			/obj/item/reagent_containers/food/condiment/yeast = 3,
			/obj/item/reagent_containers/food/condiment/sprinkles = 1
			)
	cost = 10
	containertype = /obj/structure/closet/crate/freezer/centauri
	containername = "Food crate"

/datum/supply_pack/supply/fancyfood
	name = "Artisanal food delivery"
	desc = "High-quality flour and sugar from luxury Centauri Foods brands."
	contains = list(
			/obj/item/reagent_containers/food/condiment/carton/flour/rustic = 6,
			/obj/item/reagent_containers/food/condiment/carton/sugar/rustic = 6
			)
	cost = 25
	containertype = /obj/structure/closet/crate/freezer/centauri
	containername = "Artisanal food crate"


/datum/supply_pack/supply/toner
	name = "Toner cartridges"
	desc = "A set of six toner cartridges, for use in printers."
	contains = list(/obj/item/toner = 6)
	cost = 10
	containertype = /obj/structure/closet/crate/ummarcar
	containername = "Toner cartridges"

/datum/supply_pack/supply/janitor
	name = "Janitorial supplies"
	desc = "A set of standard-issue janitorial equipment."
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
			/obj/item/clothing/glasses/hud/janitor,
			/obj/structure/mopbucket
			)
	cost = 10
	containertype = /obj/structure/closet/crate/galaksi
	containername = "Janitorial supplies"

/datum/supply_pack/supply/shipping
	name = "Shipping supplies"
	desc = "Equipment and supplies needed for shipping supplies."
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
			/obj/structure/filingcabinet/chestdrawer{anchored = FALSE},
			/obj/item/paper_bin
			)
	name = "Office supplies"
	desc = "Standard issue office supplies."
	cost = 15
	containertype = /obj/structure/closet/crate/ummarcar
	containername = "Office supplies crate"

/datum/supply_pack/supply/sticky_notes
	name = "Stationery - sticky notes (50)"
	desc = "An entire full-size crate for a single pad of sticky notes."
	contains = list(/obj/item/sticky_pad/random)
	cost = 10
	containertype = /obj/structure/closet/crate/ummarcar
	containername = "\improper Sticky notes crate"

/datum/supply_pack/supply/spare_pda
	name = "Spare PDAs"
	desc = "Three spare PDAs."
	cost = 10
	containertype = /obj/structure/closet/crate/thinktronic
	containername = "Spare PDA crate"
	contains = list(/obj/item/pda = 3)

/datum/supply_pack/supply/minergear
	name = "Shaft miner equipment"
	desc = "Standard supplies for equipping miners. Requires Mining access."
	contains = list(
			/obj/item/storage/backpack/industrial,
			/obj/item/storage/backpack/satchel/eng,
			/obj/item/clothing/suit/storage/hooded/wintercoat/miner,
			/obj/item/radio/headset/miner,
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

/* //No longer supported on our current maps, as it requires specialized dropoff beacons and the pathfinding doesn't work well on multi-z
//plus we have the destination tagger
/datum/supply_pack/supply/mule
	name = "Mulebot Crate"
	desc = "A mulebot."
	contains = list()
	cost = 20
	containertype = /obj/structure/largecrate/animal/mulebot
	containername = "Mulebot Crate"
*/

/datum/supply_pack/supply/cargotrain
	name = "Cargo Train Tug"
	desc = "A cargo train tug. Useless without at least one trolley. Can tow several though."
	contains = list(/obj/vehicle/train/engine)
	cost = 35

/datum/supply_pack/supply/cargotrailer
	name = "Cargo Train Trolley"
	desc = "A cargo train trolley. Useless without a tug."
	contains = list(/obj/vehicle/train/trolley)
	cost = 15

/datum/supply_pack/explorergear
	name= JOB_EXPLORER + " gear"
	desc = "Standard issue equipment for Explorers. Requires EVA and Exploration access."
	contains = list (
					/obj/item/cataloguer,
					/obj/item/geiger,
					/obj/item/clothing/suit/storage/hooded/explorer,
					/obj/item/flashlight/glowstick,
					/obj/item/flashlight,
					/obj/item/stack/marker_beacon/thirty,
					/obj/item/storage/belt/explorer,
					/obj/item/clothing/mask/gas/explorer,
					/obj/item/cartridge/explorer,
			 		/obj/item/gps/explorer,
			 		/obj/item/clothing/under/explorer,
			 		/obj/item/radio/headset/explorer,
			 		/obj/item/clothing/shoes/boots/winter/explorer,
					/obj/item/material/knife/tacknife/survival,
					/obj/item/material/knife/machete,
			 		/obj/item/clothing/accessory/holster/machete,
					/obj/item/clothing/accessory/watch/survival
					)
	cost=25
	containertype = /obj/structure/closet/crate/secure/xion
	containername = JOB_EXPLORER + " equipment"
	access = list(access_eva, access_explorer)

/datum/supply_pack/pilotgear
	name= JOB_PILOT + " gear"
	desc = "Standard issue equipment for Pilots. Requires Pilot's access."
	contains = list (
					/obj/item/storage/backpack/parachute,
					/obj/item/radio/headset/pilot,
					/obj/item/radio/headset/alt/pilot,
					/obj/item/clothing/mask/gas/half,
					/obj/item/flashlight/glowstick,
					/obj/item/stack/marker_beacon/thirty,
					/obj/item/gps/explorer,
					/obj/item/clothing/gloves/fingerless,
					/obj/item/clothing/suit/storage/toggle/bomber/pilot,
			 		/obj/item/clothing/shoes/boots/winter/explorer,
					/obj/item/flashlight,
					/obj/item/material/knife/tacknife/survival,
					/obj/item/clothing/head/pilot_vr,
					/obj/item/clothing/under/rank/pilot1,
					/obj/item/gun/energy/gun/protector/pilotgun/locked,
					/obj/item/clothing/accessory/watch/survival
					)
	cost=20
	containertype = /obj/structure/closet/crate/secure/xion
	containername =  JOB_PILOT + " equipment"
	access = access_pilot

/datum/supply_pack/supply/foodcubes
	name = "Emergency food cubes"
	desc = "A pack of emergency food cubes. Even less appetizing than nutripaste."
	contains = list(
				/obj/machinery/vending/emergencyfood/filled = 1)
	cost = 75
	containertype = /obj/structure/closet/crate/freezer
	containername = "food cubes"

/datum/supply_pack/pathfindergear
	name= JOB_PATHFINDER + " gear"
	desc = "Standard issue equipment for Away Team Pathfinders. Requires Exploration access."
	contains = list (
					/obj/item/cataloguer/compact/pathfinder,
					/obj/item/geiger,
					/obj/item/clothing/suit/storage/hooded/explorer,
					/obj/item/flashlight/glowstick,
					/obj/item/flashlight,
					/obj/item/stack/marker_beacon/thirty,
					/obj/item/storage/belt/explorer/pathfinder,
					/obj/item/clothing/mask/gas/explorer,
					/obj/item/cartridge/explorer,
			 		/obj/item/gps/explorer,
			 		/obj/item/clothing/under/explorer,
			 		/obj/item/radio/headset/pathfinder,
			 		/obj/item/clothing/shoes/boots/winter/explorer,
					/obj/item/material/knife/tacknife/survival,
					/obj/item/material/knife/machete/deluxe,
			 		/obj/item/clothing/accessory/holster/machete,
					/obj/item/storage/box/explorerkeys,
					/obj/item/mapping_unit,
					/obj/item/clothing/accessory/watch/survival
					)
	cost = 75
	containertype = /obj/structure/closet/crate/secure/xion
	containername = JOB_PATHFINDER + " equipment"
	access = list(access_explorer)

/datum/supply_pack/supply/postal_service
	name = "Postal Service Supplies"
	contains = list(
		/obj/item/mail/blank = 10,
		/obj/item/pen/fountain,
		/obj/item/pen/multi,
		/obj/item/destTagger,
		/obj/item/storage/bag/mail
	)
	cost = 15
	containertype = /obj/structure/closet/crate/nanotrasen
	containername = "Postal Service crate"
