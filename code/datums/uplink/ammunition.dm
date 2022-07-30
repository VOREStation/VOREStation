/*************
* Ammunition *
*************/
/datum/uplink_item/item/ammo
	item_cost = 20
	category = /datum/uplink_category/ammunition
	blacklisted = 1

/datum/uplink_item/item/ammo/a357
	name = ".357 Speedloader"
	path = /obj/item/ammo_magazine/s357

/datum/uplink_item/item/ammo/mc9mm_compact
	name = "Compact Pistol Magazine (9mm)"
	path = /obj/item/ammo_magazine/m9mm/compact

/datum/uplink_item/item/ammo/mc9mm
	name = "Pistol Magazine (9mm)"
	path = /obj/item/ammo_magazine/m9mm

/datum/uplink_item/item/ammo/mc9mm_large
	name = "Large Capacity Pistol Magazine (9mm)"
	path = /obj/item/ammo_magazine/m9mm/large
	item_cost = 40

/datum/uplink_item/item/ammo/c45m
	name = "Pistol Magazine (.45)"
	path = /obj/item/ammo_magazine/m45

/datum/uplink_item/item/ammo/c45map
	name = "Pistol Magazine (.45 AP)"
	path = /obj/item/ammo_magazine/m45/ap

/datum/uplink_item/item/ammo/s45m
	name = "Speedloader (.45)"
	path = /obj/item/ammo_magazine/s45

/datum/uplink_item/item/ammo/s45map
	name = "Speedloader  (.45 AP)"
	path = /obj/item/ammo_magazine/s45/ap

/datum/uplink_item/item/ammo/tommymag
	name = "Tommy Gun Magazine (.45)"
	path = /obj/item/ammo_magazine/m45tommy

/datum/uplink_item/item/ammo/tommymagap
	name = "Tommy Gun Magazine (.45 AP)"
	path = /obj/item/ammo_magazine/m45tommy/ap

/datum/uplink_item/item/ammo/tommydrum
	name = "Tommy Gun Drum Magazine (.45)"
	path = /obj/item/ammo_magazine/m45tommydrum
	item_cost = 40

/datum/uplink_item/item/ammo/tommydrumap
	name = "Tommy Gun Drum Magazine (.45 AP)"
	path = /obj/item/ammo_magazine/m45tommydrum/ap

/datum/uplink_item/item/ammo/darts
	name = "Darts"
	path = /obj/item/ammo_magazine/chemdart
	item_cost = 5

/datum/uplink_item/item/ammo/sniperammo
	name = "Anti-Materiel Rifle ammo box (14.5mm)"
	path = /obj/item/ammo_magazine/ammo_box/b145

/datum/uplink_item/item/ammo/sniperammo_highvel
	name = "Anti-Materiel Rifle ammo box (14.5mm sabot)"
	path = /obj/item/ammo_magazine/ammo_box/b145/highvel

/datum/uplink_item/item/ammo/c545
	name = "Rifle Magazine (5.45mm)"
	path = /obj/item/ammo_magazine/m545

/datum/uplink_item/item/ammo/c545/ext
	name = "Rifle Magazine (5.45mm Extended)"
	path = /obj/item/ammo_magazine/m545/ext

/datum/uplink_item/item/ammo/c545/ap
	name = "Rifle Magazine (5.45mm AP)"
	path = /obj/item/ammo_magazine/m545/ap

/datum/uplink_item/item/ammo/c545/ap/ext
	name = "Rifle Magazine (5.45mm AP Extended)"
	path = /obj/item/ammo_magazine/m545/ap/ext

/datum/uplink_item/item/ammo/c762
	name = "Rifle Magazine (7.62mm)"
	path = /obj/item/ammo_magazine/m762

/datum/uplink_item/item/ammo/c762/ap
	name = "Rifle Magazine (7.62mm AP)"
	path = /obj/item/ammo_magazine/m762/ap

/datum/uplink_item/item/ammo/a10mm
	name = "SMG Magazine (10mm)"
	path = /obj/item/ammo_magazine/m10mm

/datum/uplink_item/item/ammo/a545
	name = "Machinegun Magazine (5.45mm)"
	path = /obj/item/ammo_magazine/m545saw

/datum/uplink_item/item/ammo/a545/ap
	name = "Machinegun Magazine (5.45mm AP)"
	path = /obj/item/ammo_magazine/m545saw/ap

/datum/uplink_item/item/ammo/g12
	name = "12g Shotgun Ammo Box (Slug)"
	path = /obj/item/ammo_magazine/ammo_box/b12g

/datum/uplink_item/item/ammo/g12/beanbag
	name = "12g Shotgun Ammo Box (Beanbag)"
	path = /obj/item/ammo_magazine/ammo_box/b12g/beanbag
	item_cost = 10 // Discount due to it being LTL.

/datum/uplink_item/item/ammo/g12/pellet
	name = "12g Shotgun Ammo Box (Pellet)"
	path =/obj/item/ammo_magazine/ammo_box/b12g/pellet

/datum/uplink_item/item/ammo/g12/stun
	name = "12g Shotgun Ammo Box (Stun)"
	path = /obj/item/ammo_magazine/ammo_box/b12g/stunshell
	item_cost = 10 // Discount due to it being LTL.

/datum/uplink_item/item/ammo/g12/flash
	name = "12g Shotgun Ammo Box (Flash)"
	path = /obj/item/ammo_magazine/ammo_box/b12g/flash
	item_cost = 10 // Discount due to it being LTL.

/datum/uplink_item/item/ammo/cell
	name = "weapon cell"
	path = /obj/item/cell/device/weapon
