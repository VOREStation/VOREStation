/obj/item/packageWrap
	name = "package wrapper"
	desc = "Like wrapping paper, but less festive."
	icon = 'icons/obj/items.dmi'
	icon_state = "deliveryPaper"
	w_class = ITEMSIZE_NORMAL
	var/amount = 25.0
	drop_sound = 'sound/items/drop/wrapper.ogg'

/obj/item/packageWrap/afterattack(obj/target, mob/user, proximity)
	if(!proximity) return
	if(!istype(target))	//this really shouldn't be necessary (but it is).	-Pete
		return
	if(istype(target, /obj/item/smallDelivery) || istype(target,/obj/structure/bigDelivery) \
	|| istype(target, /obj/item/gift) || istype(target, /obj/item/evidencebag))
		return
	if(target.anchored)
		return
	if(!isturf(target.loc)) //no wrapping things inside other things, just breaks things, put it on the ground first.
		return
	if(user in target) //no wrapping closets that you are inside - it's not physically possible
		return

	user.attack_log += text("\[[time_stamp()]\] [span_blue("Has used [src.name] on \ref[target]")]")

	if (istype(target, /obj/item) && !(istype(target, /obj/item/storage) && !istype(target,/obj/item/storage/box)))
		var/obj/item/O = target
		if (src.amount > 1)
			var/obj/item/smallDelivery/P = new /obj/item/smallDelivery(get_turf(O.loc))	//Aaannd wrap it up!
			if(!istype(O.loc, /turf))
				if(user.client)
					user.client.screen -= O
			P.wrapped = O
			O.forceMove(P)
			P.w_class = O.w_class
			var/i = round(O.w_class)
			if(i in list(1,2,3,4,5))
				P.icon_state = "deliverycrate[i]"
				switch(i)
					if(1) P.name = "tiny parcel"
					if(3) P.name = "normal-sized parcel"
					if(4) P.name = "large parcel"
					if(5) P.name = "huge parcel"
			if(i < 1)
				P.icon_state = "deliverycrate1"
				P.name = "tiny parcel"
			if(i > 5)
				P.icon_state = "deliverycrate5"
				P.name = "huge parcel"
			P.add_fingerprint(user)
			O.add_fingerprint(user)
			src.add_fingerprint(user)
			src.amount -= 1
			user.visible_message("\The [user] wraps \a [target] with \a [src].",\
			span_notice("You wrap \the [target], leaving [amount] units of paper on \the [src]."),\
			"You hear someone taping paper around a small object.")
			playsound(src, 'sound/items/package_wrap.ogg', 50, 1)
	else if (istype(target, /obj/structure/closet/crate))
		var/obj/structure/closet/crate/O = target
		if (src.amount > 3 && !O.opened)
			var/obj/structure/bigDelivery/P = new /obj/structure/bigDelivery(get_turf(O.loc))
			P.icon_state = "deliverycrate"
			P.wrapped = O
			O.loc = P
			src.amount -= 3
			user.visible_message("\The [user] wraps \a [target] with \a [src].",\
			span_notice("You wrap \the [target], leaving [amount] units of paper on \the [src]."),\
			"You hear someone taping paper around a large object.")
			playsound(src, 'sound/items/package_wrap.ogg', 50, 1)
		else if(src.amount < 3)
			to_chat(user, span_warning("You need more paper."))
	else if (istype (target, /obj/structure/closet))
		var/obj/structure/closet/O = target
		if (src.amount > 3 && !O.opened)
			var/obj/structure/bigDelivery/P = new /obj/structure/bigDelivery(get_turf(O.loc))
			P.wrapped = O
			O.sealed = 1
			O.loc = P
			src.amount -= 3
			user.visible_message("\The [user] wraps \a [target] with \a [src].",\
			span_notice("You wrap \the [target], leaving [amount] units of paper on \the [src]."),\
			"You hear someone taping paper around a large object.")
			playsound(src, 'sound/items/package_wrap.ogg', 50, 1)
		else if(src.amount < 3)
			to_chat(user, span_warning("You need more paper."))
	else
		to_chat(user, span_blue("The object you are trying to wrap is unsuitable for the sorting machinery!"))
	if (src.amount <= 0)
		new /obj/item/c_tube( src.loc )
		qdel(src)
		return
	return

/obj/item/packageWrap/examine(mob/user)
	. = ..()
	if(get_dist(user, src) <= 0)
		. += span_blue("There are [amount] units of package wrap left!")
