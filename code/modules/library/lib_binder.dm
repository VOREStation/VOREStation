/*
 * Book binder
 */
/obj/machinery/bookbinder
	name = "Book Binder"
	desc = "Bundles up a stack of inserted paper into a convenient book format."
	icon = 'icons/obj/library.dmi'
	icon_state = "binder"
	anchored = TRUE
	density = TRUE

/obj/machinery/bookbinder/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/climbable)

/obj/machinery/bookbinder/attackby(obj/O, mob/user)
	if(istype(O, /obj/item/paper) || istype(O, /obj/item/paper_bundle))
		if(istype(O, /obj/item/paper))
			user.drop_item()
			O.forceMove(src)
			user.visible_message("[user] loads some paper into [src].", "You load some paper into [src].")
			visible_message("[src] begins to hum as it warms up its printing drums.")
			sleep(rand(200,400))
			visible_message("[src] whirs as it prints and binds a new book.")
			var/obj/item/book/b = new(get_turf(src))
			b.dat = O:info
			b.name = "Print Job #" + "[rand(100, 999)]"
			b.icon_state = "book[rand(1,7)]"
			qdel(O)
		else
			user.drop_item()
			O.forceMove(src)
			user.visible_message("[user] loads some paper into [src].", "You load some paper into [src].")
			visible_message("[src] begins to hum as it warms up its printing drums.")
			sleep(rand(300,500))
			visible_message("[src] whirs as it prints and binds a new book.")
			var/obj/item/book/bundle/b = new(get_turf(src))
			b.pages = O:pages
			for(var/obj/item/paper/P in O.contents)
				P.forceMove(b)
			for(var/obj/item/photo/P in O.contents)
				P.forceMove(b)
			b.name = "Print Job #" + "[rand(100, 999)]"
			b.icon_state = "book[rand(1,7)]"
			qdel(O)
	else
		..()
