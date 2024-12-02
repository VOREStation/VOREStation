/*
*	Here is where any supply packs that may or may not be legal
*	  and require modification of the supply controller live.
*/


/datum/supply_pack/randomised/contraband
	num_contained = 5
	contains = list(
			/obj/item/seeds/bloodtomatoseed,
			/obj/item/storage/pill_bottle/zoom,
			/obj/item/storage/pill_bottle/happy,
			/obj/item/reagent_containers/food/drinks/bottle/pwine
			)

	name = "Contraband crate"
	cost = 25
	containertype = /obj/structure/closet/crate
	containername = "Unlabeled crate"
	contraband = 1
	group = "Supplies"

/datum/supply_pack/security/specialops
	name = "Special Ops supplies"
	contains = list(
			/obj/item/storage/box/emps,
			/obj/item/grenade/smokebomb = 4,
			/obj/item/grenade/chem_grenade/incendiary
			)
	cost = 25
	containertype = /obj/structure/closet/crate/weapon
	containername = "Special Ops crate"
	contraband = 1

/datum/supply_pack/supply/moghes
	name = "Moghes imports"
	contains = list(
			/obj/item/reagent_containers/food/drinks/bottle/redeemersbrew = 2,
			/obj/item/reagent_containers/food/snacks/unajerky = 4
			)
	cost = 25
	containertype = /obj/structure/closet/crate/unathi
	containername = "Moghes imports crate"
	contraband = 1

/datum/supply_pack/munitions/bolt_rifles_militia
 	name = "Weapon - Surplus militia rifles"
 	contains = list(
 			/obj/item/gun/projectile/shotgun/pump/rifle = 3,
 			/obj/item/ammo_magazine/clip/c762 = 6
 			)
 	cost = 50
 	contraband = 1
 	containertype = /obj/structure/closet/crate/hedberg
 	containername = "Ballistic weapons crate"

/datum/supply_pack/randomised/misc/telecrate //you get something awesome, a couple of decent things, and a few weak/filler things
	name = "ERR_NULL_ENTRY" //null crate! also dream maker is hell,
	num_contained = 1
	contains = list(
			list( //the operator,
					/obj/item/gun/projectile/shotgun/pump/combat,
					/obj/item/clothing/suit/storage/vest/heavy/merc,
					/obj/item/clothing/glasses/night,
					/obj/item/storage/box/anti_photons,
					/obj/item/ammo_magazine/clip/c12g/pellet,
					/obj/item/ammo_magazine/clip/c12g
					),
			list( //the doc,
					/obj/item/storage/firstaid/combat,
					/obj/item/gun/projectile/dartgun,
					/obj/item/reagent_containers/hypospray,
					/obj/item/reagent_containers/glass/bottle/chloralhydrate,
					/obj/item/reagent_containers/glass/bottle/cyanide,
					/obj/item/ammo_magazine/chemdart
					),
			list( //the sapper,
					/obj/item/melee/energy/sword/ionic_rapier,
					/obj/item/storage/box/syndie_kit/space, //doesn't matter what species you are,
					/obj/item/storage/box/syndie_kit/demolitions,
					/obj/item/multitool/ai_detector,
					/obj/item/plastique,
					/obj/item/storage/toolbox/syndicate/powertools
					),
			list( //the infiltrator,
					/obj/item/gun/projectile/silenced,
					/obj/item/chameleon,
					/obj/item/storage/box/syndie_kit/chameleon,
					/obj/item/encryptionkey/syndicate,
					/obj/item/card/id/syndicate,
					/obj/item/clothing/mask/gas/voice,
					/obj/item/makeover
					),
			list( //the hacker,
					/obj/item/gun/projectile/silenced,
					/obj/item/gun/energy/ionrifle/pistol,
					/obj/item/clothing/glasses/thermal/syndi,
					/obj/item/ammo_magazine/m45/ap,
					/obj/item/material/knife/tacknife/combatknife,
					/obj/item/multitool/hacktool/modified
					),
			list( //the professional,
					/obj/item/gun/projectile/silenced,
					/obj/item/gun/energy/ionrifle/pistol,
					/obj/item/clothing/glasses/thermal/syndi,
					/obj/item/card/emag,
					/obj/item/ammo_magazine/m45/ap,
					/obj/item/material/knife/tacknife/combatknife,
					/obj/item/clothing/mask/balaclava
					)
			)
	cost = 250 //more than a hat crate!,
	contraband = 1
	containertype = /obj/structure/closet/crate/large
	containername = "Suspicious crate"

/datum/supply_pack/supply/stolen
	name = "Stolen supply crate"
	contains = list(/obj/item/stolenpackage = 1)
	cost = 150
	containertype = /obj/structure/closet/crate
	containername = "Stolen crate"
	contraband = 1

/datum/supply_pack/supply/wolfgirl
	name = "Wolfgirl Crate"
	cost = 200 //I mean, it's a whole wolfgirl
	containertype = /obj/structure/largecrate/animal/wolfgirl
	containername = "Wolfgirl crate"
	contraband = 1

/datum/supply_pack/supply/catgirl
	name = "Catgirl Crate"
	cost = 200 //I mean, it's a whole catgirl
	containertype = /obj/structure/largecrate/animal/catgirl
	containername = "Catgirl crate"
	contraband = 1

/datum/supply_pack/randomised/hospitality/pizzavouchers //WE ALWAYS DELIVER WE ALWAYS DELIVER WE ALWAYS DELIVER WE ALWAYS DELIVER WE ALWAYS DELIVER
	num_contained = 3
	contains = list(
			/obj/item/pizzavoucher,
			/obj/item/pizzavoucher,
			/obj/item/pizzavoucher
			)
	name = "FANTASTIC PIZZA PIE VOUCHER CRATE!"
	cost = 60
	containertype = /obj/structure/closet/crate
	containername = "WE ALWAYS DELIVER!"
	contraband = 1
