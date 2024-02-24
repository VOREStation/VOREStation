/***************
* Telecrystals *
***************/
/datum/uplink_item/item/telecrystal
	category = /datum/uplink_category/telecrystals
	blacklisted = 1

/datum/uplink_item/item/telecrystal/get_goods(var/obj/item/device/uplink/U, var/loc, var/mob/M)
	return new /obj/item/stack/telecrystal(loc, cost(U, M.mind.tcrystals))

/datum/uplink_item/item/telecrystal/one
	name = "Telecrystal - 01"
	item_cost = 1

/datum/uplink_item/item/telecrystal/five
	name = "Telecrystals - 05"
	item_cost = 5

/datum/uplink_item/item/telecrystal/ten
	name = "Telecrystals - 10"
	item_cost = 10

/datum/uplink_item/item/telecrystal/twentyfive
	name = "Telecrystals - 25"
	item_cost = 25

/datum/uplink_item/item/telecrystal/fifty
	name = "Telecrystals - 50"
	item_cost = 50

/datum/uplink_item/item/telecrystal/onehundred
	name = "Telecrystals - 100"
	item_cost = 100

/datum/uplink_item/item/telecrystal/all
	name = "Telecrystals - Empty Uplink"

/datum/uplink_item/item/telecrystal/all/cost(obj/item/device/uplink/U, mob/M)
	return max(1, M.mind.tcrystals)