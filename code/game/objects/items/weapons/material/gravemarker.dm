/obj/item/material/gravemarker
	name = "grave marker"
	desc = "An object used in marking graves."
	icon_state = "gravemarker"
	w_class = ITEMSIZE_LARGE
	fragile = 1
	force_divisor = 0.65
	thrown_force_divisor = 0.25

	var/icon_changes = 1	//Does the sprite change when you put words on it?
	var/grave_name = ""		//Name of the intended occupant
	var/epitaph = ""		//A quick little blurb

/obj/item/material/gravemarker/attackby(obj/item/W, mob/user as mob)
	if(W.has_tool_quality(TOOL_SCREWDRIVER))
		var/carving_1 = sanitizeSafe(tgui_input_text(user, "Who is \the [src.name] for?", "Gravestone Naming", null, MAX_NAME_LEN), MAX_NAME_LEN)
		if(carving_1)
			user.visible_message("[user] starts carving \the [src.name].", "You start carving \the [src.name].")
			if(do_after(user, material.hardness * W.toolspeed))
				user.visible_message("[user] carves something into \the [src.name].", "You carve your message into \the [src.name].")
				grave_name += carving_1
				update_icon()
		var/carving_2 = sanitizeSafe(tgui_input_text(user, "What message should \the [src.name] have?", "Epitaph Carving", null, MAX_NAME_LEN), MAX_NAME_LEN)
		if(carving_2)
			user.visible_message("[user] starts carving \the [src.name].", "You start carving \the [src.name].")
			if(do_after(user, material.hardness * W.toolspeed))
				user.visible_message("[user] carves something into \the [src.name].", "You carve your message into \the [src.name].")
				epitaph += carving_2
				update_icon()
	if(W.has_tool_quality(TOOL_WRENCH))
		user.visible_message("[user] starts carving \the [src.name].", "You start carving \the [src.name].")
		if(do_after(user, material.hardness * W.toolspeed))
			material.place_dismantled_product(get_turf(src))
			user.visible_message("[user] dismantles down \the [src.name].", "You dismantle \the [src.name].")
			qdel(src)
	..()

/obj/item/material/gravemarker/examine(mob/user)
	. = ..()
	if(grave_name && get_dist(src, user) < 4)
		. += "Here Lies [grave_name]"
	if(epitaph && get_dist(src, user) < 2)
		. += epitaph

/obj/item/material/gravemarker/update_icon()
	if(icon_changes)
		if(grave_name && epitaph)
			icon_state = "[initial(icon_state)]_3"
		else if(grave_name)
			icon_state = "[initial(icon_state)]_1"
		else if(epitaph)
			icon_state = "[initial(icon_state)]_2"
		else
			icon_state = initial(icon_state)

	..()

/obj/item/material/gravemarker/attack_self(mob/user)
	src.add_fingerprint(user)

	if(!isturf(user.loc))
		return 0

	if(locate(/obj/structure/gravemarker, user.loc))
		to_chat(user, span_warning("There's already something there."))
		return 0
	else
		to_chat(user, span_notice("You begin to place \the [src.name]."))
		if(!do_after(usr, 10))
			return 0
		var/obj/structure/gravemarker/G = new /obj/structure/gravemarker/(user.loc, src.get_material())
		to_chat(user, span_notice("You place \the [src.name]."))
		G.grave_name = grave_name
		G.epitaph = epitaph
		G.add_fingerprint(usr)
		G.dir = user.dir
		QDEL_NULL(src)
	return
