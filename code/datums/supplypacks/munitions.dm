/*
*	Here is where any supply packs
*	related to weapons live.
*/

/datum/supply_packs/munitions
	group = "Munitions"

/datum/supply_packs/randomised/munitions
	group = "Munitions"
/* VOREStation Removal - What? This crate costs 40... the crate with just two eguns costs 50... what??? This crate is also like "the armory" and has OFFICER access?
/datum/supply_packs/munitions/weapons
	name = "Weapons crate"
	contains = list(
			/obj/item/weapon/melee/baton/loaded = 2,
			/obj/item/weapon/gun/energy/gun = 2,
			/obj/item/weapon/gun/energy/taser = 2,
			/obj/item/weapon/gun/projectile/colt/detective = 2,
			/obj/item/weapon/storage/box/flashbangs = 2
			)
	cost = 40
	containertype = /obj/structure/closet/crate/secure/weapon
	containername = "Weapons crate"
	access = access_security
*/
/datum/supply_packs/munitions/flareguns
	name = "Flare guns crate"
	contains = list(
			/obj/item/weapon/gun/projectile/sec/flash,
			/obj/item/ammo_magazine/m45/flash,
			/obj/item/weapon/gun/projectile/shotgun/doublebarrel/flare,
			/obj/item/weapon/storage/box/flashshells
			)
	cost = 25
	containertype = /obj/structure/closet/crate/secure/weapon
	containername = "Flare gun crate"
	access = access_armory //VOREStation Edit - Guns are for the armory.

/datum/supply_packs/munitions/eweapons
	name = "Experimental weapons crate"
	contains = list(
			/obj/item/weapon/gun/energy/xray = 2,
			/obj/item/weapon/shield/energy = 2)
	cost = 100
	containertype = /obj/structure/closet/crate/secure/weapon
	containername = "Experimental weapons crate"
	access = access_armory

/datum/supply_packs/munitions/energyweapons
	name = "Laser carbine crate"
	contains = list(/obj/item/weapon/gun/energy/laser = 3)
	cost = 50
	containertype = /obj/structure/closet/crate/secure
	containername = "energy weapons crate"
	access = access_armory

/datum/supply_packs/munitions/shotgun
	name = "Shotgun crate"
	contains = list(
			/obj/item/weapon/storage/box/shotgunammo,
			/obj/item/weapon/storage/box/shotgunshells,
			/obj/item/weapon/gun/projectile/shotgun/pump/combat = 2
			)
	cost = 50
	containertype = /obj/structure/closet/crate/secure
	containername = "Shotgun crate"
	access = access_armory
/* VOREStation edit -- This is a bad idea. -- So is this.
/datum/supply_packs/munitions/erifle
	name = "Energy marksman crate"
	contains = list(/obj/item/weapon/gun/energy/sniperrifle = 2)
	cost = 100
	containertype = /obj/structure/closet/crate/secure
	containername = "Energy marksman crate"
	access = access_armory

/datum/supply_packs/munitions/burstlaser
	name = "Burst laser crate"
	contains = list(/obj/item/weapon/gun/energy/gun/burst = 2)
	cost = 50
	containertype = /obj/structure/closet/crate/secure
	containername = "Burst laser crate"
	access = access_armory
*/
/datum/supply_packs/munitions/ionweapons
	name = "Electromagnetic weapons crate"
	contains = list(
			/obj/item/weapon/gun/energy/ionrifle = 2,
			/obj/item/weapon/storage/box/empslite
			)
	cost = 50
	containertype = /obj/structure/closet/crate/secure
	containername = "electromagnetic weapons crate"
	access = access_armory

/datum/supply_packs/munitions/ionpistols
	name = "Electromagnetic pistols crate"
	contains = list(
			/obj/item/weapon/gun/energy/ionrifle/pistol = 2,
			/obj/item/weapon/storage/box/empslite
			)
	cost = 30
	containertype = /obj/structure/closet/crate/secure
	containername = "electromagnetic weapons crate"
	access = access_armory

/datum/supply_packs/randomised/munitions/automatic
	name = "Automatic weapon crate"
	num_contained = 2
	contains = list(
			/obj/item/weapon/gun/projectile/automatic/wt550,
			/obj/item/weapon/gun/projectile/automatic/z8
			)
	cost = 100
	containertype = /obj/structure/closet/crate/secure
	containername = "Automatic weapon crate"
	access = access_armory

/datum/supply_packs/munitions/energy_guns
	name = "Energy gun crate"
	contains = list(/obj/item/weapon/gun/energy/gun = 2)
	cost = 50
	containertype = /obj/structure/closet/crate/secure
	containername = "Energy gun crate"
	access = access_armory

/datum/supply_packs/munitions/bolt_rifles_competitive
 	name = "Competitive shooting crate"
 	contains = list(
 			/obj/item/device/assembly/timer,
 			/obj/item/weapon/gun/projectile/shotgun/pump/rifle/practice = 2,
 			/obj/item/ammo_magazine/clip/c762/practice = 4,
 			/obj/item/target = 2,
 			/obj/item/target/alien = 2,
 			/obj/item/target/syndicate = 2
 			)
 	cost = 40
 	containertype = /obj/structure/closet/crate/secure/weapon
 	containername = "Weapons crate"
 	access = access_armory //VOREStation Edit - Guns are for the armory.

/datum/supply_packs/munitions/shotgunammo
	name = "Shotgun ammunition crate"
	contains = list(
			/obj/item/weapon/storage/box/shotgunammo = 2,
			/obj/item/weapon/storage/box/shotgunshells = 2
			)
	cost = 25
	containertype = /obj/structure/closet/crate/secure
	containername = "ballistic ammunition crate"
	access = access_armory

/datum/supply_packs/randomised/munitions/autoammo
	name = "Automatic weapon ammunition crate"
	num_contained = 6
	contains = list(
			/obj/item/ammo_magazine/m9mmt,
			/obj/item/ammo_magazine/m9mmt/rubber,
			/obj/item/ammo_magazine/m545saw
			)
	cost = 25
	containertype = /obj/structure/closet/crate/secure
	containername = "Automatic weapon ammunition crate"
	access = access_armory

/datum/supply_packs/munitions/beanbagammo
	name = "Beanbag shells"
	contains = list(/obj/item/weapon/storage/box/beanbags = 3)
	cost = 25
	containertype = /obj/structure/closet/crate
	containername = "Beanbag shells"
	access = access_armory //VOREStation Edit - Guns are for the armory.
