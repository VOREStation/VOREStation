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
			/obj/item/weapon/material/sword/foam = 2,
			/obj/item/weapon/material/twohanded/baseballbat/foam = 2,
			/obj/item/weapon/material/twohanded/spear/foam = 2,
			/obj/item/weapon/material/twohanded/fireaxe/foam = 2
			)
	cost = 50
	containertype = /obj/structure/closet/crate
	containername = "foam weapon crate"

/datum/supply_pack/recreation/lasertag
	name = "Lasertag equipment"
	contains = list(
			/obj/item/weapon/gun/energy/lasertag/red,
			/obj/item/clothing/suit/redtag,
			/obj/item/weapon/gun/energy/lasertag/blue,
			/obj/item/clothing/suit/bluetag
			)
	containertype = /obj/structure/closet
	containername = "Lasertag Closet"
	cost = 10

/datum/supply_pack/recreation/artscrafts
	name = "Arts and Crafts supplies"
	contains = list(
			/obj/item/weapon/storage/fancy/crayons,
			/obj/item/weapon/storage/fancy/markers,
			/obj/item/device/camera,
			/obj/item/device/camera_film = 2,
			/obj/item/weapon/storage/photo_album,
			/obj/item/weapon/packageWrap,
			/obj/item/weapon/reagent_containers/glass/paint/red,
			/obj/item/weapon/reagent_containers/glass/paint/green,
			/obj/item/weapon/reagent_containers/glass/paint/blue,
			/obj/item/weapon/reagent_containers/glass/paint/yellow,
			/obj/item/weapon/reagent_containers/glass/paint/purple,
			/obj/item/weapon/reagent_containers/glass/paint/black,
			/obj/item/weapon/reagent_containers/glass/paint/white,
			/obj/item/weapon/contraband/poster,
			/obj/item/weapon/wrapping_paper = 3
			)
	cost = 10
	containertype = /obj/structure/closet/crate
	containername = "Arts and Crafts crate"

/datum/supply_pack/recreation/painters
	name = "Station Painting Supplies"
	cost = 10
	containername = "station painting supplies crate"
	containertype = /obj/structure/closet/crate
	contains = list(
			/obj/item/device/pipe_painter = 2,
			/obj/item/device/floor_painter = 2,
			/obj/item/device/closet_painter = 2
			)

/datum/supply_pack/recreation/cheapbait
	name = "Cheap Fishing Bait"
	cost = 10
	containername = "cheap bait crate"
	containertype = /obj/structure/closet/crate/freezer
	contains = list(
			/obj/item/weapon/storage/box/wormcan/sickly = 5
			)

/datum/supply_pack/randomised/recreation/cheapbait
	name = "Deluxe Fishing Bait"
	cost = 40
	containername = "deluxe bait crate"
	containertype = /obj/structure/closet/crate/freezer
	num_contained = 8
	contains = list(
			/obj/item/weapon/storage/box/wormcan,
			/obj/item/weapon/storage/box/wormcan/deluxe
			)

/datum/supply_pack/recreation/ltagturrets
	name = "Laser Tag Turrets"
	cost = 40
	containername = "laser tag turret crate"
	containertype = /obj/structure/closet/crate
	contains = list(
			/obj/machinery/porta_turret/lasertag/blue,
			/obj/machinery/porta_turret/lasertag/red
			)