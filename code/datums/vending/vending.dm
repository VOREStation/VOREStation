/**
 *  Datum used to hold further information about a product in a vending machine
 */
/datum/stored_item/vending_product
	var/price = 0              // Price to buy one
	var/display_color = null   // Display color for vending machine listing
	var/category = CAT_NORMAL  // CAT_HIDDEN for contraband, CAT_COIN for premium

/datum/stored_item/vending_product/New(stored, path, name = null, amount = 1, price = 0, color = null, category = CAT_NORMAL)
	..(stored, path, name, amount)
	src.price = price
	src.display_color = color
	src.category = category
