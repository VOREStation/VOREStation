var/datum/uplink/uplink = new()

/datum/uplink
	var/list/items_assoc
	var/list/datum/uplink_item/items
	var/list/datum/uplink_category/categories

/datum/uplink/New(var/type)
	items_assoc = list()
	items = init_subtypes(/datum/uplink_item)
	categories = init_subtypes(/datum/uplink_category)
	categories = dd_sortedObjectList(categories)

	for(var/datum/uplink_item/item in items)
		if(!item.name)
			items -= item
			continue

		items_assoc[item.type] = item

		for(var/datum/uplink_category/category in categories)
			if(item.category == category.type)
				category.items += item

	for(var/datum/uplink_category/category in categories)
		category.items = dd_sortedObjectList(category.items)

/datum/uplink_item
	var/name
	var/desc
	var/item_cost = 0
	var/datum/uplink_category/category		// Item category
	var/list/datum/antagonist/antag_roles	// Antag roles this item is displayed to. If empty, display to all.
	var/blacklisted = FALSE

/datum/uplink_item/item
	var/path = null

/datum/uplink_item/New()
	..()
	if(!antag_roles)
		antag_roles = list()



/datum/uplink_item/proc/buy(var/obj/item/uplink/U, var/mob/user)
	var/extra_args = extra_args(user)
	if(!extra_args)
		return

	if(!can_buy(U, user.mind.tcrystals))
		return

	if(U.tgui_status(user, GLOB.tgui_deep_inventory_state) != STATUS_INTERACTIVE)
		return

	var/cost = cost(U, user.mind.tcrystals)

	var/goods = get_goods(U, get_turf(user), user, extra_args)
	if(!goods)
		return

	purchase_log(user)
	user.mind.tcrystals -= cost
	user.mind.used_TC += cost
	return goods

// Any additional arguments you wish to send to the get_goods
/datum/uplink_item/proc/extra_args(var/mob/user)
	return TRUE

/datum/uplink_item/proc/can_buy(var/obj/item/uplink/U, var/telecrystals)
	if(cost(U, telecrystals) > telecrystals)
		return FALSE

	return TRUE

/datum/uplink_item/proc/cost(obj/item/uplink/U, mob/M)
	. = item_cost
	if(U)
		. = U.get_item_cost(src, .)

/datum/uplink_item/proc/description()
	return desc

// get_goods does not necessarily return physical objects, it is simply a way to acquire the uplink item without paying
/datum/uplink_item/proc/get_goods(var/obj/item/uplink/U, var/loc, mob/user)
	return FALSE

/datum/uplink_item/proc/log_icon()
	return

/datum/uplink_item/proc/purchase_log(mob/M)
	feedback_add_details("traitor_uplink_items_bought", "[src]")
	log_and_message_admins("\the [M] bought \a [src] through the uplink")
	M.mind.purchase_log[src] += 1

/datum/uplink_item/dd_SortValue()
	return item_cost

/********************************
*                           	*
*	Physical Uplink Entries		*
*                           	*
********************************/
/datum/uplink_item/item/buy(var/obj/item/uplink/U, var/mob/user)
	var/obj/item/I = ..()
	if(!I)
		return

	if(istype(I, /list))
		var/list/L = I
		if(L.len) I = L[1]

	if(istype(I) && ishuman(user))
		var/mob/living/carbon/human/A = user
		A.put_in_any_hand_if_possible(I)
	return I

/datum/uplink_item/item/get_goods(var/obj/item/uplink/U, var/loc, var/mob/user)
	var/obj/item/I = new path(loc)
	return I

/datum/uplink_item/item/description()
	if(!desc)
		// Fallback description
		var/obj/temp = src.path
		desc = initial(temp.desc)
	return ..()

/datum/uplink_item/item/log_icon()
	var/obj/I = path
	return "[bicon(I)]"

/********************************
*                           	*
*	Abstract Uplink Entries		*
*                           	*
********************************/
/datum/uplink_item/abstract
	var/static/image/default_abstract_uplink_icon

/datum/uplink_item/abstract/log_icon()
	if(!default_abstract_uplink_icon)
		default_abstract_uplink_icon = image('icons/obj/pda.dmi', "pda-syn")

	return "[bicon(default_abstract_uplink_icon)]"

/*
 * Crated goods.
 */

/datum/uplink_item/crated
	var/crate_path = /obj/structure/largecrate
	var/list/paths = list()	// List of paths to be spawned into the crate.

/datum/uplink_item/crated/get_goods(var/obj/item/uplink/U, var/loc)
	var/obj/L = new crate_path(get_turf(loc))

	L.adjust_scale(rand(9, 12) / 10, rand(9, 12) / 10)	// Some variation in the crate / locker size.

	for(var/path in paths)
		var/obj/O = new path(L)
		O.forceMove(L)

	return L

/datum/uplink_item/crated/description()
	if(!desc)
		// Fallback description
		var/obj/temp = crate_path
		desc = initial(temp.desc)
	return ..()

/datum/uplink_item/crated/log_icon()
	var/obj/I = crate_path
	return "[bicon(I)]"

/****************
* Support procs *
****************/
/proc/get_random_uplink_items(var/obj/item/uplink/U, var/remaining_TC, var/loc)
	var/list/bought_items = list()
	while(remaining_TC)
		var/datum/uplink_item/I = default_uplink_selection.get_random_item(remaining_TC, U, bought_items)
		if(!I)
			break
		bought_items += I
		remaining_TC -= I.cost(remaining_TC, U)

	return bought_items

/proc/get_surplus_items(var/obj/item/uplink/U, var/remaining_TC, var/loc)
	var/list/bought_items = list()
	var/override = TRUE
	while(remaining_TC)
		var/datum/uplink_item/I = all_uplink_selection.get_random_item(remaining_TC, U, bought_items, override)
		if(!I)
			break
		bought_items += I
		remaining_TC -= I.cost(remaining_TC, U)

	return bought_items
