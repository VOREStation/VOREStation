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
	name = "Weapons - Security basic equipment"
	contains = list(
			/obj/item/device/flash = 2,
			/obj/item/weapon/reagent_containers/spray/pepper = 2,
			/obj/item/weapon/melee/baton/loaded = 2,
			/obj/item/weapon/gun/energy/taser = 2,
			/obj/item/weapon/gun/projectile/colt/detective = 2,
			/obj/item/weapon/storage/box/flashbangs = 2
			)
	cost = 40
	containertype = /obj/structure/closet/crate/secure/gear
	containername = "Security equipment crate"
	access = access_security

/datum/supply_packs/munitions/egunpistol
	name = "Weapons - Energy sidearms"
	contains = list(/obj/item/weapon/gun/energy/gun = 2)
	cost = 40
	containertype = /obj/structure/closet/crate/secure/weapon
	containername = "Energy sidearms crate"
	access = access_security
*/
/datum/supply_packs/munitions/flareguns
	name = "Weapons - Flare guns"
	contains = list(
			/obj/item/weapon/gun/projectile/sec/flash,
			/obj/item/ammo_magazine/m45/flash,
			/obj/item/weapon/gun/projectile/shotgun/doublebarrel/flare,
			/obj/item/weapon/storage/box/flashshells
			)
	cost = 25
	containertype = /obj/structure/closet/crate/secure/gear
	containername = "Flare gun crate"
	access = access_armory //VOREStation Edit - Guns are for the armory.

/datum/supply_packs/munitions/eweapons
	name = "Weapons - Experimental weapons crate"
	contains = list(
			/obj/item/weapon/gun/energy/xray = 2,
			/obj/item/weapon/shield/energy = 2)
	cost = 100
	containertype = /obj/structure/closet/crate/secure/science
	containername = "Experimental weapons crate"
	access = access_armory

/datum/supply_packs/munitions/energyweapons
	name = "Weapons - Laser rifle crate"
	contains = list(/obj/item/weapon/gun/energy/laser = 2) //VOREStation Edit - Made to be consistent with the energy guns crate.
	cost = 50
	containertype = /obj/structure/closet/crate/secure/weapon
	containername = "Energy weapons crate"
	access = access_armory

/datum/supply_packs/munitions/shotgun
	name = "Weapons - Shotgun crate"
	contains = list(
			/obj/item/weapon/storage/box/shotgunammo,
			/obj/item/weapon/storage/box/shotgunshells,
			/obj/item/weapon/gun/projectile/shotgun/pump/combat = 2
			)
	cost = 50
	containertype = /obj/structure/closet/crate/secure/weapon
	containername = "Shotgun crate"
	access = access_armory
/* VOREStation edit -- This is a bad idea. -- So is this.
/datum/supply_packs/munitions/erifle
	name = "Weapons - Energy marksman"
	contains = list(/obj/item/weapon/gun/energy/sniperrifle = 2)
	cost = 100
	containertype = /obj/structure/closet/crate/secure/weapon
	containername = "Energy marksman crate"
	access = access_armory

/datum/supply_packs/munitions/burstlaser
	name = "Weapons - Burst laser"
	contains = list(/obj/item/weapon/gun/energy/gun/burst = 2)
	cost = 50
	containertype = /obj/structure/closet/crate/secure/weapon
	containername = "Burst laser crate"
	access = access_armory
*/
/datum/supply_packs/munitions/ionweapons
	name = "Weapons - Electromagnetic Rifles"
	contains = list(
			/obj/item/weapon/gun/energy/ionrifle = 2,
			/obj/item/weapon/storage/box/empslite
			)
	cost = 50
	containertype = /obj/structure/closet/crate/secure/weapon
	containername = "Electromagnetic weapons crate"
	access = access_armory

/datum/supply_packs/munitions/ionpistols
	name = "Weapons - Electromagnetic pistols"
	contains = list(
			/obj/item/weapon/gun/energy/ionrifle/pistol = 2,
			/obj/item/weapon/storage/box/empslite
			)
	cost = 30
	containertype = /obj/structure/closet/crate/secure/weapon
	containername = "Electromagnetic weapons crate"
	access = access_armory

/datum/supply_packs/munitions/bsmg
	name = "Weapons - Ballistic SMGs"
	contains = list(/obj/item/weapon/gun/projectile/automatic/wt550 = 2)
	cost = 50
	containertype = /obj/structure/closet/crate/secure/weapon
	containername = "Ballistic weapon crate"
	access = access_armory

/datum/supply_packs/munitions/brifle
	name = "Weapons - Ballistic Rifles"
	contains = list(/obj/item/weapon/gun/projectile/automatic/z8 = 2)
	cost = 80
	containertype = /obj/structure/closet/crate/secure/weapon
	containername = "Ballistic weapon crate"
	access = access_armory

/datum/supply_packs/munitions/bolt_rifles_competitive
 	name = "Weapons - Competitive shooting rifles"
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
 	containername = "Ballistic Weapons crate"
 	access = access_armory //VOREStation Edit - Guns are for the armory.

/datum/supply_packs/munitions/shotgunammo
	name = "Ammunition - Shotgun shells"
	contains = list(
			/obj/item/weapon/storage/box/shotgunammo = 2,
			/obj/item/weapon/storage/box/shotgunshells = 2
			)
	cost = 25
	containertype = /obj/structure/closet/crate/secure
	containername = "Ballistic ammunition crate"
	access = access_armory

/datum/supply_packs/munitions/beanbagammo
	name = "Ammunition - Beanbag shells"
	contains = list(/obj/item/weapon/storage/box/beanbags = 3)
	cost = 25
	containertype = /obj/structure/closet/crate
	containername = "Ballistic ammunition crate"
	access = access_armory //VOREStation Edit - Guns are for the armory.

/datum/supply_packs/munitions/bsmgammo
	name = "Ammunition - 9mm top mounted lethal"
	contains = list(/obj/item/ammo_magazine/m9mmt = 6)
	cost = 25
	containertype = /obj/structure/closet/crate/secure
	containername = "Ballistic ammunition crate"
	access = access_armory

/datum/supply_packs/munitions/bsmgammorubber
	name = "Ammunition - 9mm top mounted rubber"
	contains = list(/obj/item/ammo_magazine/m9mmt/rubber = 6)
	cost = 25
	containertype = /obj/structure/closet/crate/secure
	containername = "Ballistic ammunition crate"
	access = access_security

/datum/supply_packs/munitions/brifleammo
	name = "Ammunition - 7.62mm lethal"
	contains = list(/obj/item/ammo_magazine/m762 = 6)
	cost = 25
	containertype = /obj/structure/closet/crate/secure
	containername = "Ballistic ammunition crate"
	access = access_armory

/datum/supply_packs/munitions/pcellammo
	name = "Ammunition - Power cell"
	contains = list(/obj/item/weapon/cell/device/weapon = 3)
	cost = 50
	containertype = /obj/structure/closet/crate/secure
	containername = "Energy ammunition crate"
	access = access_security
