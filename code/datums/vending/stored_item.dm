/*
*	Datum that holds the instances and information about the items stored. Currently used in SmartFridges and Vending Machines.
*/
/datum/stored_item
		var/item_name = "name"	//Name of the item(s) displayed
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
	return product

/datum/stored_item/proc/add_product(var/atom/movable/product)
	if(product.type != item_path)
		return 0
	init_products()
	product.forceMove(stored)
	instances += product

/datum/stored_item/proc/init_products()
	if(instances)
		return
	instances = list()
	for(var/i = 1 to amount)
		var/new_product = new item_path(stored)
		instances += new_product