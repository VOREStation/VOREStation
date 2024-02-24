/*************
* Ammunition *
*************/
/datum/uplink_item/item/ammo/cell
	name = "Weapon cell"

/datum/uplink_item/item/ammo/highcell
	name = "High capacity cell"
	path = /obj/item/weapon/cell/high
	item_cost = 15

/datum/uplink_item/item/ammo/supercell
	name = "Super capacity cell"
	path = /obj/item/weapon/cell/super
	item_cost = 30

/datum/uplink_item/item/ammo/voidcell
	name = "Void cell"
	path = /obj/item/weapon/cell/device/weapon/recharge/alien/hybrid
	item_cost = DEFAULT_TELECRYSTAL_AMOUNT * 1.5
	antag_roles = list("ert")
	blacklisted = 1
