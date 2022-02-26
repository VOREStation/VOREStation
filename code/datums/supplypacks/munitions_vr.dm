/datum/supply_pack/munitions/expeditionguns
	name = "Frontier phaser (station-locked) crate"
	contains = list(
			/obj/item/weapon/gun/energy/locked/frontier = 2,
			/obj/item/weapon/gun/energy/locked/frontier/holdout = 2,
			)
	cost = 35
	containertype = /obj/structure/closet/crate/secure
	containername = "frontier phaser crate"
	access = access_explorer

/datum/supply_pack/munitions/expeditionbows
	name = "Frontier bows (station-locked) crate"
	contains = list(
			/obj/item/weapon/gun/energy/locked/frontier/handbow=2
			)
	cost = 20
	containertype = /obj/structure/closet/crate/secure
	containername = "phaser handbow crate"
	access = access_explorer

/datum/supply_pack/munitions/ofd_charge_emp
	name = "OFD Charge - EMP"
	contains = list(
			/obj/structure/ship_munition/disperser_charge/emp
			)
	cost = 35
	containertype = /obj/structure/closet/crate/large/secure/heph
	containername = "EMP disperser charge crate"
	access = access_security

/datum/supply_pack/munitions/ofd_charge_explosive
	name = "OFD Charge - Explosive"
	contains = list(
			/obj/structure/ship_munition/disperser_charge/explosive
			)
	cost = 35
	containertype = /obj/structure/closet/crate/large/secure/heph
	containername = "Explosive disperser charge crate"
	access = access_security

/datum/supply_pack/munitions/ofd_charge_incendiary
	name = "OFD Charge - Incendiary"
	contains = list(
			/obj/structure/ship_munition/disperser_charge/fire
			)
	cost = 35
	containertype = /obj/structure/closet/crate/large/secure/heph
	containername = "Incendiary disperser charge crate"
	access = access_security

/datum/supply_pack/munitions/ofd_charge_mining
	name = "OFD Charge - Mining"
	contains = list(
			/obj/structure/ship_munition/disperser_charge/mining
			)
	cost = 35
	containertype = /obj/structure/closet/crate/large/secure/heph
	containername = "Mining disperser charge crate"
	access = access_security

/datum/supply_pack/munitions/longsword
	name = "Weapons - Melee -Longsword (Steel)"
	contains = list(
			/obj/item/weapon/material/twohanded/longsword=2
			)
	cost = 50
	containertype = /obj/structure/closet/crate/secure
	containername = "longsword"
	access = access_armory