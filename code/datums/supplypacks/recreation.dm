/*
 *	Here is where any supply packs
 *	related to recreation live.
 */


/datum/supply_pack/recreation
	group = "Recreation"

/datum/supply_pack/randomised/recreation
	group = "Recreation"
	access = access_security

/datum/supply_pack/recreation/foam_weapons
	name = "Foam Weapon Crate"
	contains = list(
			/obj/item/material/sword/foam = 2,
			/obj/item/material/twohanded/baseballbat/foam = 2,
			/obj/item/material/twohanded/spear/foam = 2,
			/obj/item/material/twohanded/fireaxe/foam = 2
			)
	cost = 50
	containertype = /obj/structure/closet/crate/allico
	containername = "foam weapon crate"

/datum/supply_pack/recreation/donksoftweapons
	name = "Donk-Soft Weapon Crate"
	contains = list(
			/obj/item/ammo_magazine/ammo_box/foam = 2,
			/obj/item/gun/projectile/shotgun/pump/toy = 2,
			/obj/item/gun/projectile/pistol/toy = 2,
			/obj/item/ammo_magazine/mfoam_dart/pistol = 2
			)
	cost = 50
	containertype = /obj/structure/closet/crate/allico
	containername = "foam weapon crate"

/datum/supply_pack/recreation/donksoftborg
	name = "Donk-Soft Cyborg Blaster Crate"
	contains = list(
			/obj/item/borg/upgrade/no_prod/toygun = 2,
			)
	cost = 35
	containertype = /obj/structure/closet/crate/allico
	containername = "foam weapon crate"

/datum/supply_pack/recreation/donksoftvend
	name = "Donk-Soft Vendor Crate"
	contains = list()
	cost = 75
	containertype = /obj/structure/largecrate/donksoftvendor
	containername = "\improper Donk-Soft vendor crate"

/datum/supply_pack/recreation/lasertag
	name = "Lasertag equipment"
	contains = list(
			/obj/item/gun/energy/lasertag/red,
			/obj/item/clothing/suit/redtag,
			/obj/item/gun/energy/lasertag/blue,
			/obj/item/clothing/suit/bluetag
			)
	containertype = /obj/structure/closet/crate/ward
	containername = "Lasertag Supplies"
	cost = 10

/datum/supply_pack/recreation/artscrafts
	name = "Arts and Crafts supplies"
	contains = list(
			/obj/item/storage/fancy/crayons,
			/obj/item/storage/fancy/markers,
			/obj/item/camera,
			/obj/item/camera_film = 2,
			/obj/item/storage/photo_album,
			/obj/item/packageWrap,
			/obj/item/poster/custom,
			/obj/item/wrapping_paper = 3,
			/obj/structure/easel,
			/obj/item/paint_brush,
			/obj/item/paint_palette,
			/obj/item/canvas = 3,
			/obj/item/canvas/nineteen_nineteen = 2,
			/obj/item/canvas/twentythree_nineteen = 2,
			/obj/item/canvas/twentythree_twentythree = 2,
			/obj/item/canvas/twentyfour_twentyfour = 2
			)
	cost = 10
	containertype = /obj/structure/closet/crate/allico
	containername = "Arts and Crafts crate"

/datum/supply_pack/recreation/painters
	name = "Station Painting Supplies"
	cost = 10
	containername = "station painting supplies crate"
	containertype = /obj/structure/closet/crate/grayson
	contains = list(
			/obj/item/pipe_painter = 2,
			/obj/item/floor_painter = 2,
			/obj/item/reagent_containers/glass/paint/red,
			/obj/item/reagent_containers/glass/paint/green,
			/obj/item/reagent_containers/glass/paint/blue,
			/obj/item/reagent_containers/glass/paint/yellow,
			/obj/item/reagent_containers/glass/paint/violet,
			/obj/item/reagent_containers/glass/paint/cyan,
			/obj/item/reagent_containers/glass/paint/orange,
			/obj/item/reagent_containers/glass/paint/purple,
			/obj/item/reagent_containers/glass/paint/grey,
			/obj/item/reagent_containers/glass/paint/black,
			/obj/item/reagent_containers/glass/paint/white = 3
			)

/datum/supply_pack/recreation/cheapbait
	name = "Cheap Fishing Bait"
	cost = 10
	containername = "cheap bait crate"
	containertype = /obj/structure/closet/crate/freezer
	contains = list(
			/obj/item/storage/box/wormcan/sickly = 5
			)

/datum/supply_pack/randomised/recreation/cheapbait
	name = "Deluxe Fishing Bait"
	cost = 40
	containername = "deluxe bait crate"
	containertype = /obj/structure/closet/crate/carp
	num_contained = 8
	contains = list(
			/obj/item/storage/box/wormcan,
			/obj/item/storage/box/wormcan/deluxe
			)

/datum/supply_pack/recreation/ltagturrets
	name = "Laser Tag Turrets"
	cost = 40
	containername = "laser tag turret crate"
	containertype = /obj/structure/closet/crate/ward
	contains = list(
			/obj/machinery/porta_turret/lasertag/blue,
			/obj/machinery/porta_turret/lasertag/red
			)

/datum/supply_pack/recreation/monster_bait
	name = "Monster Bait Toy"
	cost = 5
	containername = "monster bait crate"
	containertype = /obj/structure/closet/crate/allico
	contains = list(
			/obj/item/toy/monster_bait
			)

/*
/datum/supply_pack/recreation/rover
	name = "NT Humvee"
	contains = list(
			/obj/vehicle/train/rover/engine
			)
	containertype = /obj/structure/largecrate
	containername = "NT Humvee Crate"
	cost = 100
*/
/datum/supply_pack/recreation/restraints
	name = "Recreational Restraints"
	contains = list(
			/obj/item/clothing/mask/muzzle,
			/obj/item/clothing/glasses/sunglasses/blindfold,
			/obj/item/handcuffs/fuzzy,
			/obj/item/tape_roll,
			/obj/item/stack/cable_coil/random,
			/obj/item/clothing/accessory/collar/shock,
			/obj/item/clothing/suit/straight_jacket,
			/obj/item/handcuffs/legcuffs/fuzzy,
			/obj/item/melee/fluff/holochain/mass,
			/obj/item/material/twohanded/riding_crop,
			/obj/item/clothing/under/fluff/latexmaid
			)
	containertype = /obj/structure/closet/crate
	containername = "Restraints crate"
	cost = 30

/datum/supply_pack/recreation/wolfgirl_cosplay_crate
	name = "Wolfgirl Cosplay Crate"
	contains = list(
			/obj/item/clothing/head/fluff/wolfgirl = 1,
			/obj/item/clothing/shoes/fluff/wolfgirl = 1,
			/obj/item/clothing/under/fluff/wolfgirl = 1,
			/obj/item/melee/fluffstuff/wolfgirlsword = 1,
			/obj/item/shield/fluff/wolfgirlshield = 1
			)
	cost = 50
	containertype = /obj/structure/closet/crate
	containername = "wolfgirl cosplay crate"

/datum/supply_pack/randomised/recreation/figures
	name = "Action figures crate"
	num_contained = 5
	contains = list(
			/obj/random/action_figure/supplypack
			)
	cost = 200
	containertype = /obj/structure/closet/crate
	containername = "Action figures crate"

/datum/supply_pack/recreation/collars
	name = "Collar bundle"
	contains = list(
			/obj/item/clothing/accessory/collar/shock = 1,
			/obj/item/clothing/accessory/collar/spike = 1,
			/obj/item/clothing/accessory/collar/silver = 1,
			/obj/item/clothing/accessory/collar/gold = 1,
			/obj/item/clothing/accessory/collar/bell = 1,
			/obj/item/clothing/accessory/collar/pink = 1,
			/obj/item/clothing/accessory/collar/holo = 1
			)
	cost = 25
	containertype = /obj/structure/closet/crate
	containername = "collar crate"

/datum/supply_pack/recreation/shiny
	name = "Shiny Clothing"
	contains = list(
			/obj/item/clothing/mask/muzzle/ballgag = 1,
			/obj/item/clothing/mask/muzzle/ballgag/ringgag = 1,
			/obj/item/clothing/head/shiny_hood = 1,
			/obj/item/clothing/head/shiny_hood/poly = 1,
			/obj/item/clothing/head/shiny_hood/closed = 1,
			/obj/item/clothing/head/shiny_hood/closed/poly = 1,
			/obj/item/clothing/under/shiny/catsuit = 1,
			/obj/item/clothing/under/shiny/catsuit/poly = 1,
			/obj/item/clothing/under/shiny/leotard = 1,
			/obj/item/clothing/under/shiny/leotard/poly = 1,
			/obj/item/clothing/accessory/shiny/gloves = 1,
			/obj/item/clothing/accessory/shiny/gloves/poly = 1,
			/obj/item/clothing/accessory/shiny/socks = 1,
			/obj/item/clothing/accessory/shiny/socks/poly = 1
			)
	containertype = /obj/structure/closet/crate
	containername = "Shiny clothes crate"
	cost = 30

//3/19/21
/datum/supply_pack/recreation/smoleworld
	name = "Smole Bulding Bricks"
	contains = list(
			/obj/item/storage/smolebrickcase, /obj/item/storage/smolebrickcase,
			)
	cost = 50
	containertype = /obj/structure/closet/crate
	containername = "Smole Bulding Brick crate"

/datum/supply_pack/recreation/smolesnackplanets
	name = "Snack planets pack"
	num_contained = 4
	contains = list(
			/obj/item/storage/bagoplanets, /obj/item/storage/bagoplanets
			)
	cost = 25
	containertype = /obj/structure/closet/crate
	containername = "Snack planets crate"

/datum/supply_pack/recreation/pinkpillows
	name = "Pillow Crate - Pink"
	contains = list(
		/obj/item/bedsheet/pillow = 6
	)
	cost = 10
	containertype = /obj/structure/closet/crate

/datum/supply_pack/recreation/tealpillows
	name = "Pillow Crate - Teal"
	contains = list(
		/obj/item/bedsheet/pillow/teal = 6
	)
	cost = 10
	containertype = /obj/structure/closet/crate

/datum/supply_pack/recreation/whitepillows
	name = "Pillow Crate - White"
	contains = list(
		/obj/item/bedsheet/pillow/white = 6
	)
	cost = 10
	containertype = /obj/structure/closet/crate

/datum/supply_pack/recreation/blackpillows
	name = "Pillow Crate - Black"
	contains = list(
		/obj/item/bedsheet/pillow/black = 6
	)
	cost = 10
	containertype = /obj/structure/closet/crate

/datum/supply_pack/recreation/redpillows
	name = "Pillow Crate - Red"
	contains = list(
		/obj/item/bedsheet/pillow/red = 6
	)
	cost = 10
	containertype = /obj/structure/closet/crate

/datum/supply_pack/recreation/greenpillows
	name = "Pillow Crate - Green"
	contains = list(
		/obj/item/bedsheet/pillow/green = 6
	)
	cost = 10
	containertype = /obj/structure/closet/crate

/datum/supply_pack/recreation/orangepillows
	name = "Pillow Crate - Orange"
	contains = list(
		/obj/item/bedsheet/pillow/orange = 6
	)
	cost = 10
	containertype = /obj/structure/closet/crate

/datum/supply_pack/recreation/yellowpillows
	name = "Pillow Crate - Yellow"
	contains = list(
		/obj/item/bedsheet/pillow/yellow = 6
	)
	cost = 10
	containertype = /obj/structure/closet/crate
