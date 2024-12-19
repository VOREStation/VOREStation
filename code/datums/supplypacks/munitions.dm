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
			/obj/item/flash = 2,
			/obj/item/reagent_containers/spray/pepper = 2,
			/obj/item/melee/baton/loaded = 2,
			/obj/item/gun/energy/taser = 2,
			/obj/item/gun/projectile/colt/detective = 2,
			/obj/item/storage/box/flashbangs = 2
			)
	cost = 40
	containertype = /obj/structure/closet/crate/secure/lawson
	containername = "Security equipment crate"
	access = access_security*/

/datum/supply_pack/munitions/egunpistol
	name = "Weapons - Energy sidearms"
	desc = "A pair of standard two-setting energy guns, from Lawson Arms. Requires Armory access."
	contains = list(/obj/item/gun/energy/gun = 2)
	cost = 40
	containertype = /obj/structure/closet/crate/secure/lawson
	containername = "Energy sidearms crate"
	access = access_armory //VOREStation Edit - Guns are for the armory.

/datum/supply_pack/munitions/flareguns
	name = "Weapons - Flare guns"
	desc = "A set of flare-round ballistic arms and ammunition. Requires Armory access."
	contains = list(
			/obj/item/gun/projectile/sec/flash,
			/obj/item/ammo_magazine/m45/flash,
			/obj/item/gun/projectile/shotgun/doublebarrel/flare,
			/obj/item/ammo_magazine/ammo_box/b12g/flash
			)
	cost = 25
	containertype = /obj/structure/closet/crate/secure/gear
	containername = "Flare gun crate"
	access = access_armory //VOREStation Edit - Guns are for the armory.

/datum/supply_pack/munitions/eweapons
	name = "Weapons - Experimental weapons crate"
	desc = "A pair of experimental x-ray laser rifles and portable energy shields. Requires Armory access."
	contains = list(
			/obj/item/gun/energy/xray = 2,
			/obj/item/shield/energy = 2)
	cost = 100
	containertype = /obj/structure/closet/crate/secure/science
	containername = "Experimental weapons crate"
	access = access_armory

/datum/supply_pack/munitions/energyweapons
	name = "Weapons - Laser rifle crate"
	desc = "A pair of standard laser rifles, from Hephaestus Arms. Requires Armory access."
	contains = list(/obj/item/gun/energy/laser = 2) //VOREStation Edit - Made to be consistent with the energy guns crate.
	cost = 50
	containertype = /obj/structure/closet/crate/secure/heph
	containername = "Energy weapons crate"
	access = access_armory

/datum/supply_pack/munitions/shotgun
	name = "Weapons - Shotgun crate"
	desc = "Two pump-action combat shotguns and two boxes of 12-gauge ammunition. Requires Armory access."
	contains = list(
			/obj/item/ammo_magazine/ammo_box/b12g,
			/obj/item/ammo_magazine/ammo_box/b12g/pellet,
			/obj/item/gun/projectile/shotgun/pump/combat = 2
			)
	cost = 50
	containertype = /obj/structure/closet/crate/secure/weapon
	containername = "Shotgun crate"
	access = access_armory
/* VOREStation edit -- This is a bad idea. -- So is this.

/datum/supply_pack/munitions/shotgunsemi
	name = "Weapons - Semi-Automatic Shotgun crate"
	contains = list(
			/obj/item/ammo_magazine/ammo_box/b12g,
			/obj/item/ammo_magazine/ammo_box/b12g/pellet,
			/obj/item/gun/projectile/shotgun/semi = 2
			)
	cost = 100
	containertype = /obj/structure/closet/crate/secure/weapon
	containername = "Semi-Auto Shotgun crate"
	access = access_armory

/datum/supply_pack/munitions/erifle
	name = "Weapons - Energy marksman"
	contains = list(/obj/item/gun/energy/sniperrifle = 2)
	cost = 100
	containertype = /obj/structure/closet/crate/secure/heph
	containername = "Energy marksman crate"
	access = access_armory

/datum/supply_pack/munitions/burstlaser
	name = "Weapons - Burst laser"
	contains = list(/obj/item/gun/energy/gun/burst = 2)
	cost = 50
	containertype = /obj/structure/closet/crate/secure/lawson
	containername = "Burst laser crate"
	access = access_armory
*/
/datum/supply_pack/munitions/ionweapons
	name = "Weapons - Electromagnetic Pulse Rifles"
	desc = "A pair of EMP rifles and low-power EMP grenades. Requires Armory access."
	contains = list(
			/obj/item/gun/energy/ionrifle = 2,
			/obj/item/storage/box/empslite
			)
	cost = 50
	containertype = /obj/structure/closet/crate/secure/ward
	containername = "Electromagnetic weapons crate"
	access = access_armory

/datum/supply_pack/munitions/ionpistols
	name = "Weapons - Electromagnetic Pulse pistols"
	desc = "A pair of EMP pistols and low-power EMP grenades. Requires Armory access."
	contains = list(
			/obj/item/gun/energy/ionrifle/pistol = 2,
			/obj/item/storage/box/empslite
			)
	cost = 30
	containertype = /obj/structure/closet/crate/secure/ward
	containername = "Electromagnetic weapons crate"
	access = access_armory

/datum/supply_pack/munitions/bsmg
	name = "Weapons - Ballistic SMGs"
	desc = "A pair of WT-550 ballistic submachineguns. Requires Armory access."
	contains = list(/obj/item/gun/projectile/automatic/wt550 = 2)
	cost = 50
	containertype = /obj/structure/closet/crate/secure/ward
	containername = "Ballistic weapon crate"
	access = access_armory

/datum/supply_pack/munitions/brifle
	name = "Weapons - Ballistic Rifles"
	desc = "A pair of Z-8 ballistic rifles. Requires Armory access."
	contains = list(/obj/item/gun/projectile/automatic/z8 = 2)
	cost = 80
	containertype = /obj/structure/closet/crate/secure/weapon
	containername = "Ballistic weapon crate"
	access = access_armory

/datum/supply_pack/munitions/bolt_rifles_lethal
	name = "Weapons - Bolt-Action Rifles"
	desc = "A pair of vintage 7.62mm bolt-action rifles, and four clips. Requires Armory access."
	contains = list(
			/obj/item/gun/projectile/shotgun/pump/rifle = 2,
			/obj/item/ammo_magazine/ammo_box/b762 = 4,
			)
	cost = 60
	containertype = /obj/structure/closet/crate/secure/weapon
	containername = "Ballistic Weapons crate"
	access = access_armory

/datum/supply_pack/munitions/bolt_rifles_competitive
	name = "Weapons - Competitive shooting rifles"
	desc = "A set of 7.62mm bolt-action practice/sport rifles, a timer, and targets. Requires Armory access."
	contains = list(
			/obj/item/assembly/timer,
			/obj/item/gun/projectile/shotgun/pump/rifle/practice = 2,
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
	desc = "A prototype 5mm caseless automatic rifle. Requires Armory access."
	contains = list(
			/obj/item/gun/projectile/caseless/prototype,
			/obj/item/ammo_magazine/m5mmcaseless = 3
			)
	cost = 60
	containertype = /obj/structure/closet/crate/secure/heph
	containername = "Caseless rifle crate"
	access = access_armory

/datum/supply_pack/munitions/mrifle
	name = "Weapons - Magnetic Rifles"
	desc = "A pair of Hephaestus man-portable railguns. Requires Armory access."
	contains = list(/obj/item/gun/magnetic/railgun/heater = 2)
	cost = 120
	containertype = /obj/structure/closet/crate/secure/heph
	containername = "Magnetic weapon crate"
	access = access_armory

/datum/supply_pack/munitions/mpistol
	name = "Weapons - Magnetic Pistols"
	desc = "A pair of Hephaestus man-portable rail-pistols. Requires Armory access."
	contains = list(/obj/item/gun/magnetic/railgun/heater/pistol = 2)
	cost = 200
	containertype = /obj/structure/closet/crate/secure/heph
	containername = "Magnetic weapon crate"
	access = access_armory

/datum/supply_pack/munitions/mcarbine
	name = "Weapons - Magnetic Carbines"
	desc = "A pair of Lawson magnetic flechette carbines. Requires Armory access."
	contains = list(/obj/item/gun/magnetic/railgun/flechette/sif = 2)
	cost = 130
	containertype = /obj/structure/closet/crate/secure/lawson
	containername = "Magnetic weapon crate"
	access = access_armory

/datum/supply_pack/munitions/mshells
	name = "Weapons - Magnetic Shells"
	desc = "A set of ammo for magnetic weapons. Requires Armory access."
	contains = list(/obj/item/magnetic_ammo = 3)
	cost = 100
	containertype = /obj/structure/closet/crate/secure/weapon
	containername = "Magnetic ammunition crate"
	access = access_armory

/datum/supply_pack/munitions/claymore
	name = "Weapons - Melee - Claymores"
	desc = "A pair of replica two-handed claymore swords. Requires Armory access."
	contains = list(/obj/item/material/sword = 2)
	cost = 150
	containertype = /obj/structure/closet/crate/secure/weapon
	containername = "Claymore crate"
	access = access_armory //two swords that are a one-hit 40 brute + IB chance should be armory-locked

/datum/supply_pack/munitions/shotgunammo
	name = "Ammunition - Shotgun shells"
	desc = "Four boxes of 12-gauge lethal ammunition; slug and shot. Requires Armory access."
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
	desc = "Three boxes of 12-gauge less-lethal ammunition; beanbag. Requires Armory access."
	contains = list(/obj/item/ammo_magazine/ammo_box/b12g/beanbag = 3)
	cost = 25
	containertype = /obj/structure/closet/crate
	containername = "Ballistic ammunition crate"
	access = access_armory //VOREStation Edit - Guns are for the armory.

/datum/supply_pack/munitions/bsmgammo
	name = "Ammunition - 9mm top mounted lethal"
	desc = "Six magazines of lethal 9mm ammunition, top-mount. Requires Armory access."
	contains = list(/obj/item/ammo_magazine/m9mmt = 6)
	cost = 25
	containertype = /obj/structure/closet/crate/secure/weapon
	containername = "Ballistic ammunition crate"
	access = access_armory

/datum/supply_pack/munitions/bsmgammorubber
	name = "Ammunition - 9mm top mounted rubber"
	desc = "Six magazines of less-lethal 9mm rubber ammunition, top-mount. Requires Armory access."
	contains = list(/obj/item/ammo_magazine/m9mmt/rubber = 6)
	cost = 25
	containertype = /obj/structure/closet/crate/secure/weapon
	containername = "Ballistic ammunition crate"
	access = access_armory

/datum/supply_pack/munitions/brifleammo
	name = "Ammunition - 7.62mm lethal"
	desc = "Six magazines of lethal 7.62mm ammunition. Requires Armory access."
	contains = list(/obj/item/ammo_magazine/m762 = 6)
	cost = 25
	containertype = /obj/structure/closet/crate/secure/weapon
	containername = "Ballistic ammunition crate"
	access = access_armory

/datum/supply_pack/munitions/pcellammo
	name = "Ammunition - Power cell"
	desc = "Three standard weapon power cells. Requires Security access."
	contains = list(/obj/item/cell/device/weapon = 3)
	cost = 50
	containertype = /obj/structure/closet/crate/secure/weapon
	containername = "Energy ammunition crate"
	access = access_security

/*
/datum/supply_pack/munitions/expeditionguns
	name = "Frontier phaser (station-locked) crate"
	contains = list(
			/obj/item/gun/energy/locked/frontier = 2,
			/obj/item/gun/energy/locked/frontier/holdout = 2,
			)
	cost = 35
	containertype = /obj/structure/closet/crate/secure
	containername = "frontier phaser crate"
	access = access_security

/datum/supply_pack/munitions/expeditionbows
	name = "Frontier bows (station-locked) crate"
	contains = list(
			/obj/item/gun/energy/locked/frontier/handbow=2
			)
	cost = 20
	containertype = /obj/structure/closet/crate/secure
	containername = "phaser handbow crate"
	access = access_security
*/

/datum/supply_pack/munitions/ofd_charge_emp
	name = "OFD Charge - EMP"
	desc = "An obstruction field disperser charge, electromagnetic pulse core. Inert until catalyzed by the launcher. Requires Security access."
	contains = list(
			/obj/structure/ship_munition/disperser_charge/emp
			)
	cost = 35
	containertype = /obj/structure/closet/crate/large/secure/heph
	containername = "EMP disperser charge crate"
	access = access_security

/datum/supply_pack/munitions/ofd_charge_explosive
	name = "OFD Charge - Explosive"
	desc = "An obstruction field disperser charge, explosive core. Inert until catalyzed by the launcher. Requires Security access."
	contains = list(
			/obj/structure/ship_munition/disperser_charge/explosive
			)
	cost = 35
	containertype = /obj/structure/closet/crate/large/secure/heph
	containername = "Explosive disperser charge crate"
	access = access_security

/datum/supply_pack/munitions/ofd_charge_incendiary
	name = "OFD Charge - Incendiary"
	desc = "An obstruction field disperser charge, incendiary core. Inert until catalyzed by the launcher. Requires Security access."
	contains = list(
			/obj/structure/ship_munition/disperser_charge/fire
			)
	cost = 35
	containertype = /obj/structure/closet/crate/large/secure/heph
	containername = "Incendiary disperser charge crate"
	access = access_security

/datum/supply_pack/munitions/ofd_charge_mining
	name = "OFD Charge - Mining"
	desc = "An obstruction field disperser charge, mining core. Inert until catalyzed by the launcher. Requires Security access."
	contains = list(
			/obj/structure/ship_munition/disperser_charge/mining
			)
	cost = 35
	containertype = /obj/structure/closet/crate/large/secure/heph
	containername = "Mining disperser charge crate"
	access = access_security

/datum/supply_pack/munitions/longsword
	name = "Weapons - Melee -Longsword (Steel)"
	desc = "A pair of replica two-handed longswords. Requires Armory access."
	contains = list(
			/obj/item/material/twohanded/longsword=2
			)
	cost = 50
	containertype = /obj/structure/closet/crate/secure
	containername = "longsword"
	access = access_armory
