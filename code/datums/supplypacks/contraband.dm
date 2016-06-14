/*
*	Here is where any supply packs that may or may not be legal
*	  and require modification of the supply controller live.
*/

/datum/supply_packs/randomised/contraband
	num_contained = 5
	contains = list(
			/obj/item/seeds/bloodtomatoseed,
			/obj/item/weapon/storage/pill_bottle/zoom,
			/obj/item/weapon/storage/pill_bottle/happy,
			/obj/item/weapon/reagent_containers/food/drinks/bottle/pwine
			)

	name = "Contraband crate"
	cost = 30
	containertype = /obj/structure/closet/crate
	containername = "Unlabeled crate"
	contraband = 1
	group = "Operations"

/datum/supply_packs/security/specialops
	name = "Special Ops supplies"
	contains = list(
			/obj/item/weapon/storage/box/emps,
			/obj/item/weapon/grenade/smokebomb = 3,
			/obj/item/weapon/pen/reagent/paralysis,
			/obj/item/weapon/grenade/chem_grenade/incendiary
			)
	cost = 20
	containertype = /obj/structure/closet/crate
	containername = "Special Ops crate"
	hidden = 1
	
/datum/supply_packs/security/bolt_rifles_mosin
 	name = "Surplus militia rifles"
 	contains = list(
 			/obj/item/weapon/gun/projectile/shotgun/pump/rifle/mosin = 3,
 			/obj/item/ammo_magazine/clip/a762 = 6
 			)
 	cost = 50
 	hidden = 1
 	containertype = /obj/structure/closet/crate/secure/weapon
 	containername = "Weapons crate"