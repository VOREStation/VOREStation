//Device that tells you how many cargo points / thalers an item sells for
/obj/item/cargo_scanner
	name = "cargo scanner"
	desc = "Assess the cargo sale value of items."
	icon = 'icons/obj/device.dmi'
	icon_state = "retail_idle"
	flags = NOBLUDGEON
	slot_flags = SLOT_BELT
	w_class = ITEMSIZE_SMALL

// Always face the user when put on a table
/obj/item/cargo_scanner/afterattack(atom/movable/AM, mob/user, proximity)
	if(!proximity)	return
	if(istype(AM, /obj/structure/table))
		src.pixel_y = 3 // Shift it up slightly to look better on table
		src.dir = get_dir(src, user)
	else
		flick("retail_scan", src)
		scan_item_price(AM,user)

// Reset dir when picked back up
/obj/item/cargo_scanner/pickup(mob/user)
	src.dir = SOUTH
	src.pixel_y = 0

/obj/item/cargo_scanner/proc/scan_item_price(atom/movable/AM,mob/user)
	if(istype(AM,/obj/effect))
		return 0

	var/final_output = span_boldnotice("\The [src] assesses the value of \the [AM]...\n")
	playsound(src, 'sound/machines/beep.ogg', 50, 1)

	// Some things cannot be sold
	if(isliving(AM) || isturf(AM))
		final_output += span_danger("-Cannot be sold.")
		to_chat(user,final_output)
		return 0

	var/value = 0
	if(istype(AM,/obj/structure/closet/crate))
		// Scan all contents in crate
		for(var/atom/movable/thing in AM.contents)
			value += SEND_SIGNAL(thing,COMSIG_ITEM_SCAN_PROFIT)
	else
		// Get single item value
		value = SEND_SIGNAL(AM,COMSIG_ITEM_SCAN_PROFIT)

	if(!value)
		final_output += span_danger("-It's worth nothing.")
		to_chat(user,final_output)
		return 0

	// Stasis cages are for RESEARCH!
	if(istype(AM,/obj/structure/stasis_cage))
		final_output += span_notice("-Its contents can be studied for [value] research points.")
		to_chat(user,final_output)
		return value

	var/price = SSsupply.points_to_cash(value)
	final_output += span_notice("-It can be sold for [value] supply points, or [price] [price > 1 ? "thalers" : "thaler"]")
	to_chat(user,final_output)
	return value
