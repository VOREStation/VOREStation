/*
*	Here is where any supply packs
*	related to sc weapons live.
*/

/datum/supply_packs/munitions/bolt_rifles_explorer
 	name = "Weapons - Surplus explorer rifles"
 	contains = list(
 			/obj/item/weapon/gun/projectile/shotgun/pump/rifle = 4,
 			/obj/item/ammo_magazine/clip/c762 = 4,
 			/obj/item/ammo_magazine/clip/c762/hunter = 8
 			)
 	cost = 50
 	containertype = /obj/structure/closet/crate/secure/weapon
 	containername = "Explorer weapons crate"
 	access = access_explorer
