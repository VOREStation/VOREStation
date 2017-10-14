/obj/item/weapon/material/gravemarker
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

/obj/item/weapon/material/gravemarker/attackby(obj/item/weapon/W, mob/user as mob)
	if(istype(W, /obj/item/weapon/screwdriver))
		var/carving_1 = sanitizeSafe(input(user, "Who is \the [src.name] for?", "Gravestone Naming", null)  as text, MAX_NAME_LEN)
		if(carving_1)
			user.visible_message("[user] starts carving \the [src.name].", "You start carving \the [src.name].")
			if(do_after(user, material.hardness * W.toolspeed))
				user.visible_message("[user] carves something into \the [src.name].", "You carve your message into \the [src.name].")
				grave_name += carving_1
				update_icon()
		var/carving_2 = sanitizeSafe(input(user, "What message should \the [src.name] have?", "Epitaph Carving", null)  as text, MAX_NAME_LEN)
		if(carving_2)
			user.visible_message("[user] starts carving \the [src.name].", "You start carving \the [src.name].")
			if(do_after(user, material.hardness * W.toolspeed))
				user.visible_message("[user] carves something into \the [src.name].", "You carve your message into \the [src.name].")
				epitaph += carving_2
				update_icon()
	if(istype(W, /obj/item/weapon/wrench))
		user.visible_message("[user] starts carving \the [src.name].", "You start carving \the [src.name].")
		if(do_after(user, material.hardness * W.toolspeed))
			material.place_dismantled_product(get_turf(src))
			user.visible_message("[user] dismantles down \the [src.name].", "You dismantle \the [src.name].")
			qdel(src)
	..()

/obj/item/weapon/material/gravemarker/examine(mob/user)
	..()
	if(get_dist(src, user) < 4)
		if(grave_name)
			to_chat(user, "Here Lies [grave_name]")
	if(get_dist(src, user) < 2)
		if(epitaph)
			to_chat(user, epitaph)

/obj/item/weapon/material/gravemarker/update_icon()
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

/obj/item/weapon/material/gravemarker/attack_self(mob/user)
	src.add_fingerprint(user)

	if(!isturf(user.loc))
		return 0

	if(locate(/obj/structure/gravemarker, user.loc))
		to_chat(user, "<span class='warning'>There's already something there.</span>")
		return 0
	else
		to_chat(user, "<span class='notice'>You begin to place \the [src.name].</span>")
		if(!do_after(usr, 10))
			return 0
		var/obj/structure/gravemarker/G = new /obj/structure/gravemarker/(user.loc, src.get_material())
		to_chat(user, "<span class='notice'>You place \the [src.name].</span>")
		G.grave_name = grave_name
		G.epitaph = epitaph
		G.add_fingerprint(usr)
		G.dir = user.dir
		qdel_null(src)
	return