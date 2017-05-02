/*************
* Ammunition *
*************/
/datum/uplink_item/item/ammo
	item_cost = 20
	category = /datum/uplink_category/ammunition
	blacklisted = 1

/datum/uplink_item/item/ammo/a357
	name = ".357 Speedloader"
	path = /obj/item/ammo_magazine/a357

/datum/uplink_item/item/ammo/mc9mm
	name = "Pistol Magazine (9mm)"
	path = /obj/item/ammo_magazine/mc9mm

/datum/uplink_item/item/ammo/c45m
	name = "Pistol Magazine (.45)"
	path = /obj/item/ammo_magazine/c45m

/datum/uplink_item/item/ammo/c45map
	name = "Pistol Magazine (.45 AP)"
	path = /obj/item/ammo_magazine/c45m/ap

/datum/uplink_item/item/ammo/tommymag
	name = "Tommygun Magazine (.45)"
	path = /obj/item/ammo_magazine/tommymag

/datum/uplink_item/item/ammo/tommymagap
	name = "Tommygun Magazine (.45 AP)"
	path = /obj/item/ammo_magazine/tommymag/ap

/datum/uplink_item/item/ammo/tommydrum
	name = "Tommygun Drum Magazine (.45)"
	path = /obj/item/ammo_magazine/tommydrum
	item_cost = 40

/datum/uplink_item/item/ammo/tommydrumap
	name = "Tommygun Drum Magazine (.45 AP)"
	path = /obj/item/ammo_magazine/tommydrum/ap

/datum/uplink_item/item/ammo/darts
	name = "Darts"
	path = /obj/item/ammo_magazine/chemdart
	item_cost = 5

/datum/uplink_item/item/ammo/sniperammo
	name = "Anti-Materiel Rifle ammo box (14.5mm)"
	path = /obj/item/weapon/storage/box/sniperammo

/datum/uplink_item/item/ammo/c556
	name = "Rifle Magazine (5.56mm)"
	path = /obj/item/ammo_magazine/c556

/datum/uplink_item/item/ammo/c556/ext
	name = "Rifle Magazine (5.56mm Extended)"
	path = /obj/item/ammo_magazine/c556/ext

/datum/uplink_item/item/ammo/c556/ap
	name = "Rifle Magazine (5.56mm AP)"
	path = /obj/item/ammo_magazine/c556/ap

/datum/uplink_item/item/ammo/c556/ap/ext
	name = "Rifle Magazine (5.56mm AP Extended)"
	path = /obj/item/ammo_magazine/c556/ap/ext

/datum/uplink_item/item/ammo/c762
	name = "Rifle Magazine (7.62mm)"
	path = /obj/item/ammo_magazine/c762

/datum/uplink_item/item/ammo/c762/ap
	name = "Rifle Magazine (7.62mm AP)"
	path = /obj/item/ammo_magazine/c762/ap

/datum/uplink_item/item/ammo/a10mm
	name = "SMG Magazine (10mm)"
	path = /obj/item/ammo_magazine/a10mm

/datum/uplink_item/item/ammo/a556
	name = "Machinegun Magazine (5.56mm)"
	path = /obj/item/ammo_magazine/a556

/datum/uplink_item/item/ammo/a556/ap
	name = "Machinegun Magazine (5.56mm AP)"
	path = /obj/item/ammo_magazine/a556/ap

/datum/uplink_item/item/ammo/g12
	name = "12g Shotgun Ammo Box (Slug)"
	path = /obj/item/weapon/storage/box/shotgunammo

/datum/uplink_item/item/ammo/g12/beanbag
	name = "12g Shotgun Ammo Box (Beanbag)"
	path = /obj/item/weapon/storage/box/beanbags
	item_cost = 10 // Discount due to it being LTL.

/datum/uplink_item/item/ammo/g12/pellet
	name = "12g Shotgun Ammo Box (Pellet)"
	path = /obj/item/weapon/storage/box/shotgunshells

/datum/uplink_item/item/ammo/g12/stun
	name = "12g Shotgun Ammo Box (Stun)"
	path = /obj/item/weapon/storage/box/stunshells
	item_cost = 10 // Discount due to it being LTL.

/datum/uplink_item/item/ammo/g12/flash
	name = "12g Shotgun Ammo Box (Flash)"
	path = /obj/item/weapon/storage/box/flashshells
	item_cost = 10 // Discount due to it being LTL.

/datum/uplink_item/item/ammo/cell
	name = "weapon cell"
	path = /obj/item/weapon/cell/device/weapon