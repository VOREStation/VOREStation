/*
 * Library Scanner
 */
/obj/machinery/libraryscanner
	name = "scanner"
	desc = "A scanner for scanning in books and papers."
	icon = 'icons/obj/library.dmi'
	icon_state = "bigscanner"
	anchored = TRUE
	density = TRUE
	var/obj/item/book/cache		// Last scanned book

/obj/machinery/libraryscanner/attackby(obj/O, mob/user)
	if(cache) // Prevent stacking books in here, unlike the original code.
		to_chat(user,span_warning("\The [src] already has a book inside it!"))
		return
	if(istype(O, /obj/item/book))
		user.drop_item()
		O.forceMove(src)
		cache = O
		visible_message(span_notice("\The [O] was inserted into \the [src]."))

/obj/machinery/libraryscanner/attack_hand(mob/user)
	if(cache) // Prevent stacking books in here
		cache = null
		for(var/obj/item/book/B in contents) // The old code allowed stacking, if multiple things end up in here somehow we may as well drop them all out too.
			B.forceMove(get_turf(src))
		visible_message(span_notice("\The [src] ejects a book."))
		return
	to_chat(user,span_warning("There is nothing to eject from \the [src]!"))
