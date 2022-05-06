/*
*	Here is where any supply packs
*	related to weapons live.
*/

/datum/supply_pack/munitions
	group = "Munitions"

/datum/supply_pack/randomised/munitions
	group = "Munitions"
/* VOREStation Removal - What? This crate costs 40... the crate with just two eguns costs 50... what??? This crate is also like "the armory" and has OFFICER access?
/datum/supply_pack/munitions/weapons
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
	containertype = /obj/structure/closet/crate/secure/lawson
	containername = "Security equipment crate"
	access = access_security*/

/datum/supply_pack/munitions/egunpistol
	name = "Weapons - Energy sidearms"
	contains = list(/obj/item/weapon/gun/energy/gun = 2)
	cost = 40
	containertype = /obj/structure/closet/crate/secure/lawson
	containername = "Energy sidearms crate"
	access = access_armory //VOREStation Edit - Guns are for the armory.

/datum/supply_pack/munitions/flareguns
	name = "Weapons - Flare guns"
	contains = list(
			/obj/item/weapon/gun/projectile/sec/flash,
			/obj/item/ammo_magazine/m45/flash,
			/obj/item/weapon/gun/projectile/shotgun/doublebarrel/flare,
			/obj/item/ammo_magazine/ammo_box/b12g/flash
			)
	cost = 25
	containertype = /obj/structure/closet/crate/secure/gear
	containername = "Flare gun crate"
	access = access_armory //VOREStation Edit - Guns are for the armory.

/datum/supply_pack/munitions/eweapons
	name = "Weapons - Experimental weapons crate"
	contains = list(
			/obj/item/weapon/gun/energy/xray = 2,
			/obj/item/weapon/shield/energy = 2)
	cost = 100
	containertype = /obj/structure/closet/crate/secure/science
	containername = "Experimental weapons crate"
	access = access_armory

/datum/supply_pack/munitions/energyweapons
	name = "Weapons - Laser rifle crate"
	contains = list(/obj/item/weapon/gun/energy/laser = 2) //VOREStation Edit - Made to be consistent with the energy guns crate.
	cost = 50
	containertype = /obj/structure/closet/crate/secure/heph
	containername = "Energy weapons crate"
	access = access_armory

/datum/supply_pack/munitions/shotgun
	name = "Weapons - Shotgun crate"
	contains = list(
			/obj/item/ammo_magazine/ammo_box/b12g,
			/obj/item/ammo_magazine/ammo_box/b12g/pellet,
			/obj/item/weapon/gun/projectile/shotgun/pump/combat = 2
			)
	cost = 50
	containertype = /obj/structure/closet/crate/secure/weapon
	containername = "Shotgun crate"
	access = access_armory
<<<<<<< HEAD
/* VOREStation edit -- This is a bad idea. -- So is this.
=======
	
/datum/supply_pack/munitions/shotgunsemi
	name = "Weapons - Semi-Automatic Shotgun crate"
	contains = list(
			/obj/item/storage/box/shotgunammo,
			/obj/item/storage/box/shotgunshells,
			/obj/item/gun/projectile/shotgun/semi = 2
			)
	cost = 100
	containertype = /obj/structure/closet/crate/secure/weapon
	containername = "Semi-Auto Shotgun crate"
	access = access_armory

>>>>>>> e0e497187d9... Merge pull request #8588 from Doctress/sjorgenshotgun
/datum/supply_pack/munitions/erifle
	name = "Weapons - Energy marksman"
	contains = list(/obj/item/weapon/gun/energy/sniperrifle = 2)
	cost = 100
	containertype = /obj/structure/closet/crate/secure/heph
	containername = "Energy marksman crate"
	access = access_armory

/datum/supply_pack/munitions/burstlaser
	name = "Weapons - Burst laser"
	contains = list(/obj/item/weapon/gun/energy/gun/burst = 2)
	cost = 50
	containertype = /obj/structure/closet/crate/secure/lawson
	containername = "Burst laser crate"
	access = access_armory
*/
/datum/supply_pack/munitions/ionweapons
	name = "Weapons - Electromagnetic Rifles"
	contains = list(
			/obj/item/weapon/gun/energy/ionrifle = 2,
			/obj/item/weapon/storage/box/empslite
			)
	cost = 50
	containertype = /obj/structure/closet/crate/secure/ward
	containername = "Electromagnetic weapons crate"
	access = access_armory

/datum/supply_pack/munitions/ionpistols
	name = "Weapons - Electromagnetic pistols"
	contains = list(
			/obj/item/weapon/gun/energy/ionrifle/pistol = 2,
			/obj/item/weapon/storage/box/empslite
			)
	cost = 30
	containertype = /obj/structure/closet/crate/secure/ward
	containername = "Electromagnetic weapons crate"
	access = access_armory

/datum/supply_pack/munitions/bsmg
	name = "Weapons - Ballistic SMGs"
	contains = list(/obj/item/weapon/gun/projectile/automatic/wt550 = 2)
	cost = 50
	containertype = /obj/structure/closet/crate/secure/ward
	containername = "Ballistic weapon crate"
	access = access_armory

/datum/supply_pack/munitions/brifle
	name = "Weapons - Ballistic Rifles"
	contains = list(/obj/item/weapon/gun/projectile/automatic/z8 = 2)
	cost = 80
	containertype = /obj/structure/closet/crate/secure/weapon
	containername = "Ballistic weapon crate"
	access = access_armory

/datum/supply_pack/munitions/bolt_rifles_lethal
 	name = "Weapons - Bolt-Action Rifles"
 	contains = list(
 			/obj/item/weapon/gun/projectile/shotgun/pump/rifle = 2,
 			/obj/item/ammo_magazine/ammo_box/b762 = 4,
 			)
 	cost = 60
 	containertype = /obj/structure/closet/crate/secure/weapon
 	containername = "Ballistic Weapons crate"
 	access = access_armory

/datum/supply_pack/munitions/bolt_rifles_competitive
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

/datum/supply_pack/munitions/caseless
	name = "Weapons - Prototype Caseless Rifle"
	contains = list(
			/obj/item/weapon/gun/projectile/caseless/prototype,
			/obj/item/ammo_magazine/m5mmcaseless = 3
			)
	cost = 60
	containertype = /obj/structure/closet/crate/secure/gilthari
	containername = "Caseless rifle crate"
	access = access_security

/datum/supply_pack/munitions/mrifle
	name = "Weapons - Magnetic Rifles"
	contains = list(/obj/item/weapon/gun/magnetic/railgun/heater = 2)
	cost = 120
	containertype = /obj/structure/closet/crate/secure/heph
	containername = "Magnetic weapon crate"
	access = access_armory

/datum/supply_pack/munitions/mpistol
	name = "Weapons - Magnetic Pistols"
	contains = list(/obj/item/weapon/gun/magnetic/railgun/heater/pistol = 2)
	cost = 200
	containertype = /obj/structure/closet/crate/secure/heph
	containername = "Magnetic weapon crate"
	access = access_armory

/datum/supply_pack/munitions/mcarbine
	name = "Weapons - Magnetic Carbines"
	contains = list(/obj/item/weapon/gun/magnetic/railgun/flechette/sif = 2)
	cost = 130
	containertype = /obj/structure/closet/crate/secure/lawson
	containername = "Magnetic weapon crate"
	access = access_security

/datum/supply_pack/munitions/mshells
	name = "Weapons - Magnetic Shells"
	contains = list(/obj/item/weapon/magnetic_ammo = 3)
	cost = 100
	containertype = /obj/structure/closet/crate/secure/weapon
	containername = "Magnetic ammunition crate"
	access = access_security

/datum/supply_pack/munitions/claymore
	name = "Weapons - Melee - Claymores"
	contains = list(/obj/item/weapon/material/sword = 2)
	cost = 150
	containertype = /obj/structure/closet/crate/secure/weapon
	containername = "Claymore crate"
	access = access_armory //two swords that are a one-hit 40 brute + IB chance should be armory-locked

/datum/supply_pack/munitions/shotgunammo
	name = "Ammunition - Shotgun shells"
	contains = list(
			/obj/item/ammo_magazine/ammo_box/b12g = 2,
			/obj/item/ammo_magazine/ammo_box/b12g/pellet = 2
			)
	cost = 25
	containertype = /obj/structure/closet/crate/secure/weapon
	containername = "Ballistic ammunition crate"
	access = access_armory

/datum/supply_pack/munitions/beanbagammo
	name = "Ammunition - Beanbag shells"
	contains = list(/obj/item/ammo_magazine/ammo_box/b12g/beanbag = 3)
	cost = 25
	containertype = /obj/structure/closet/crate
	containername = "Ballistic ammunition crate"
	access = access_armory //VOREStation Edit - Guns are for the armory.

/datum/supply_pack/munitions/bsmgammo
	name = "Ammunition - 9mm top mounted lethal"
	contains = list(/obj/item/ammo_magazine/m9mmt = 6)
	cost = 25
	containertype = /obj/structure/closet/crate/secure/weapon
	containername = "Ballistic ammunition crate"
	access = access_armory

/datum/supply_pack/munitions/bsmgammorubber
	name = "Ammunition - 9mm top mounted rubber"
	contains = list(/obj/item/ammo_magazine/m9mmt/rubber = 6)
	cost = 25
	containertype = /obj/structure/closet/crate/secure/weapon
	containername = "Ballistic ammunition crate"
	access = access_security

/datum/supply_pack/munitions/brifleammo
	name = "Ammunition - 7.62mm lethal"
	contains = list(/obj/item/ammo_magazine/m762 = 6)
	cost = 25
	containertype = /obj/structure/closet/crate/secure/weapon
	containername = "Ballistic ammunition crate"
	access = access_armory

/datum/supply_pack/munitions/pcellammo
	name = "Ammunition - Power cell"
	contains = list(/obj/item/weapon/cell/device/weapon = 3)
	cost = 50
	containertype = /obj/structure/closet/crate/secure/weapon
	containername = "Energy ammunition crate"
	access = access_security
