/datum/inventory
	var/mob/mymob = null
	var/list/datum/inventory_slot/slots = list()
	var/list/slot_types = list()

/datum/inventory/New(new_mob)
	. = ..()
	mymob = new_mob
	for(var/type in slot_types)
		slots += new type(src)

/datum/inventory/proc/build_hud(datum/hud/HUD)
	var/list/items = list()

	for(var/datum/inventory_slot/slot as anything in slots)
		items += slot.build_hud(HUD)

	LAZYADD(HUD.adding, items)

	if(mymob.client)
		mymob.client.screen |= items


/datum/inventory/living
	slot_types = list(
		/datum/inventory_slot/l_hand,
		/datum/inventory_slot/r_hand
	)

/datum/inventory/human
	slot_types = list(
		/datum/inventory_slot/l_hand,
		/datum/inventory_slot/r_hand
	)
