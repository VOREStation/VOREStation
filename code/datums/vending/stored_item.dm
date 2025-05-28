/*
*	Datum that holds the instances and information about the items stored. Currently used in SmartFridges and Vending Machines.
*/
/datum/stored_item
	var/item_name = "name"	//Name of the item(s) displayed
	var/item_desc
	var/item_path = null
	var/amount = 0
	var/list/instances		//What items are actually stored
	var/stored				//The thing holding it is

/datum/stored_item/New(var/stored, var/path, var/name = null, var/amount = 0)
	src.item_path = path

	if(!name)
		var/atom/tmp = path
		src.item_name = initial(tmp.name)
	else
		src.item_name = name

	src.amount  = amount
	src.stored = stored

	..()

/datum/stored_item/Destroy()
	stored = null
	if(instances)
		for(var/product in instances)
			qdel(product)
		instances.Cut()
	. = ..()

/datum/stored_item/proc/get_amount()
	return instances ? instances.len : amount

/datum/stored_item/proc/get_product(var/product_location)
	if(!get_amount() || !product_location)
		return
	init_products()

	var/atom/movable/product = instances[instances.len]	// Remove the last added product
	instances -= product
	product.forceMove(product_location)
	//VOREStation Addition Start
	if(istype(product, /obj))
		var/obj/item = product
		item.persist_storable = FALSE
	//VOREStation Addition End
	return product

/datum/stored_item/proc/add_product(var/atom/movable/product)
	if(product.type != item_path)
		return FALSE
	init_products()
	product.forceMove(stored)
	instances += product
	return TRUE

/datum/stored_item/proc/init_products()
	if(instances)
		return
	instances = list()
	for(var/i = 1 to amount)
		var/new_product = new item_path(stored)
		instances += new_product

/datum/stored_item/proc/refill_products(var/refill_amount)
	if(!instances)
		init_products()
	for(var/i = 1 to refill_amount)
		var/new_product = new item_path(stored)
		instances += new_product

/datum/stored_item/stack/get_amount()
	return amount

/datum/stored_item/stack/add_product(var/atom/movable/product)
	. = ..()
	if(.)
		var/obj/item/stack/S = product
		if(istype(S))
			amount += S.get_amount()

/datum/stored_item/stack/get_product(var/product_location, var/count)
	if(!LAZYLEN(instances))
		return null // Shouldn't happen, but will loudly complain if it breaks

	var/obj/item/stack/S = instances[1]
	count = min(count, S.get_max_amount())
	src.amount -= count // We won't vend more than one full stack per call

	// Case 1: Draw the full amount from the first instance
	if(count < S.get_amount())
		S = S.split(count)

	// Case 2: Amount at least one stack, or have to accumulate
	else if(count >= S.get_amount())
		count -= S.get_amount()
		instances -= S
		for(var/obj/item/stack/T as anything in instances)
			if(count <= 0)
				break
			if(T.get_amount() <= count)
				instances -=T
			count -= T.transfer_to(S, count)

	S.forceMove(product_location)
	return S
