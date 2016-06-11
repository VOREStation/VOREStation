/*
*	Here is where any supply packs
*	related to weapons live.
*/
/datum/supply_packs/ammunition
	group = "Ammunition"

/datum/supply_packs/randomised/ammunition
	group = "Ammunition"
	access = access_security

/datum/supply_packs/ammunition/shotgunammo
	name = "Ballistic ammunition crate"
	contains = list(
			/obj/item/weapon/storage/box/shotgunammo = 2,
			/obj/item/weapon/storage/box/shotgunshells = 2
			)
	cost = 60
	containertype = /obj/structure/closet/crate/secure
	containername = "ballistic ammunition crate"
	access = access_armory

/datum/supply_packs/randomised/ammunition/autoammo
	name = "Automatic weapon ammunition crate"
	num_contained = 6
	contains = list(
			/obj/item/ammo_magazine/mc9mmt,
			/obj/item/ammo_magazine/mc9mmt/rubber,
			/obj/item/ammo_magazine/a556
			)
	cost = 20
	containertype = /obj/structure/closet/crate/secure
	containername = "Automatic weapon ammunition crate"
	access = access_armory

/datum/supply_packs/security/beanbagammo
	name = "Beanbag shells"
	contains = list(/obj/item/weapon/storage/box/beanbags = 3)
	cost = 30
	containertype = /obj/structure/closet/crate
	containername = "Beanbag shells"
	access = null