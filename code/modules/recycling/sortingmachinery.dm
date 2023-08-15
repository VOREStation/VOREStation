/obj/structure/bigDelivery
	desc = "A big wrapped package."
	name = "large parcel"
	icon = 'icons/obj/storage_vr.dmi'	//VOREStation Edit
	icon_state = "deliverycloset"
	var/obj/wrapped = null
	density = TRUE
	var/sortTag = null
	flags = NOBLUDGEON
	mouse_drag_pointer = MOUSE_ACTIVE_POINTER
	var/examtext = null
	var/nameset = 0
	var/label_y
	var/label_x
	var/tag_x

/obj/structure/bigDelivery/attack_hand(mob/user as mob)
	unwrap()

/obj/structure/bigDelivery/proc/unwrap()
	playsound(src, 'sound/items/package_unwrap.ogg', 50, 1)
	// Destroy will drop our wrapped object on the turf, so let it.
	qdel(src)

/obj/structure/bigDelivery/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/device/destTagger))
		var/obj/item/device/destTagger/O = W
		if(O.currTag)
			if(src.sortTag != O.currTag)
				to_chat(user, "<span class='notice'>You have labeled the destination as [O.currTag].</span>")
				if(!src.sortTag)
					src.sortTag = O.currTag
					update_icon()
				else
					src.sortTag = O.currTag
				playsound(src, 'sound/machines/twobeep.ogg', 50, 1)
			else
				to_chat(user, "<span class='warning'>The package is already labeled for [O.currTag].</span>")
		else
			to_chat(user, "<span class='warning'>You need to set a destination first!</span>")

	else if(istype(W, /obj/item/weapon/pen))
		switch(tgui_alert(usr, "What would you like to alter?","Select Alteration",list("Title","Description","Cancel")))
			if("Title")
				var/str = sanitizeSafe(tgui_input_text(usr,"Label text?","Set label","", MAX_NAME_LEN), MAX_NAME_LEN)
				if(!str || !length(str))
					to_chat(user, "<span class='warning'> Invalid text.</span>")
					return
				user.visible_message("\The [user] titles \the [src] with \a [W], marking down: \"[str]\"",\
				"<span class='notice'>You title \the [src]: \"[str]\"</span>",\
				"You hear someone scribbling a note.")
				playsound(src, pick('sound/bureaucracy/pen1.ogg','sound/bureaucracy/pen2.ogg'), 20)
				name = "[name] ([str])"
				if(!examtext && !nameset)
					nameset = 1
					update_icon()
				else
					nameset = 1
			if("Description")
				var/str = sanitize(tgui_input_text(usr,"Label text?","Set label",""))
				if(!str || !length(str))
					to_chat(user, "<font color='red'>Invalid text.</font>")
					return
				if(!examtext && !nameset)
					examtext = str
					update_icon()
				else
					examtext = str
				user.visible_message("\The [user] labels \the [src] with \a [W], scribbling down: \"[examtext]\"",\
				"<span class='notice'>You label \the [src]: \"[examtext]\"</span>",\
				"You hear someone scribbling a note.")
				playsound(src, pick('sound/bureaucracy/pen1.ogg','sound/bureaucracy/pen2.ogg'), 20)
	return

/obj/structure/bigDelivery/update_icon()
	cut_overlays()
	if(nameset || examtext)
		var/image/I = new/image('icons/obj/storage.dmi',"delivery_label")
		if(icon_state == "deliverycloset")
			I.pixel_x = 2
			if(label_y == null)
				label_y = rand(-6, 11)
			I.pixel_y = label_y
		else if(icon_state == "deliverycrate")
			if(label_x == null)
				label_x = rand(-8, 6)
			I.pixel_x = label_x
			I.pixel_y = -3
		add_overlay(I)
	if(src.sortTag)
		var/image/I = new/image('icons/obj/storage.dmi',"delivery_tag")
		if(icon_state == "deliverycloset")
			if(tag_x == null)
				tag_x = rand(-2, 3)
			I.pixel_x = tag_x
			I.pixel_y = 9
		else if(icon_state == "deliverycrate")
			if(tag_x == null)
				tag_x = rand(-8, 6)
			I.pixel_x = tag_x
			I.pixel_y = -3
		add_overlay(I)

/obj/structure/bigDelivery/examine(mob/user)
	. = ..()
	if(get_dist(user, src) <= 4)
		if(sortTag)
			. += "<span class='notice'>It is labeled \"[sortTag]\"</span>"
		if(examtext)
			. += "<span class='notice'>It has a note attached which reads, \"[examtext]\"</span>"

/obj/item/smallDelivery
	desc = "A small wrapped package."
	name = "small parcel"
	icon = 'icons/obj/storage_vr.dmi'	//VOREStation Edit
	icon_state = "deliverycrate3"
	drop_sound = 'sound/items/drop/cardboardbox.ogg'
	pickup_sound = 'sound/items/pickup/cardboardbox.ogg'
	var/obj/item/wrapped = null
	var/sortTag = null
	var/examtext = null
	var/nameset = 0
	var/tag_x

/obj/item/smallDelivery/attack_self(mob/user as mob)
	if (src.wrapped) //sometimes items can disappear. For example, bombs. --rastaf0
		wrapped.loc = user.loc
		if(ishuman(user))
			user.put_in_hands(wrapped)
		else
			wrapped.loc = get_turf(src)

	qdel(src)
	return

/obj/item/smallDelivery/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/device/destTagger))
		var/obj/item/device/destTagger/O = W
		if(O.currTag)
			if(src.sortTag != O.currTag)
				to_chat(user, "<span class='notice'>You have labeled the destination as [O.currTag].</span>")
				if(!src.sortTag)
					src.sortTag = O.currTag
					update_icon()
				else
					src.sortTag = O.currTag
				playsound(src, 'sound/machines/twobeep.ogg', 50, 1)
			else
				to_chat(user, "<span class='warning'>The package is already labeled for [O.currTag].</span>")
		else
			to_chat(user, "<span class='warning'>You need to set a destination first!</span>")

	else if(istype(W, /obj/item/weapon/pen))
		switch(tgui_alert(usr, "What would you like to alter?","Select Alteration",list("Title","Description","Cancel")))
			if("Title")
				var/str = sanitizeSafe(tgui_input_text(usr,"Label text?","Set label","", MAX_NAME_LEN), MAX_NAME_LEN)
				if(!str || !length(str))
					to_chat(user, "<span class='warning'> Invalid text.</span>")
					return
				user.visible_message("\The [user] titles \the [src] with \a [W], marking down: \"[str]\"",\
				"<span class='notice'>You title \the [src]: \"[str]\"</span>",\
				"You hear someone scribbling a note.")
				playsound(src, pick('sound/bureaucracy/pen1.ogg','sound/bureaucracy/pen2.ogg'), 20)
				name = "[name] ([str])"
				if(!examtext && !nameset)
					nameset = 1
					update_icon()
				else
					nameset = 1

			if("Description")
				var/str = sanitize(tgui_input_text(usr,"Label text?","Set label",""))
				if(!str || !length(str))
					to_chat(user, "<font color='red'>Invalid text.</font>")
					return
				if(!examtext && !nameset)
					examtext = str
					update_icon()
				else
					examtext = str
				user.visible_message("\The [user] labels \the [src] with \a [W], scribbling down: \"[examtext]\"",\
				"<span class='notice'>You label \the [src]: \"[examtext]\"</span>",\
				"You hear someone scribbling a note.")
				playsound(src, pick('sound/bureaucracy/pen1.ogg','sound/bureaucracy/pen2.ogg'), 20)
	return

/obj/item/smallDelivery/update_icon()
	cut_overlays()
	if((nameset || examtext) && icon_state != "deliverycrate1")
		var/image/I = new/image('icons/obj/storage.dmi',"delivery_label")
		if(icon_state == "deliverycrate5")
			I.pixel_y = -1
		add_overlay(I)
	if(src.sortTag)
		var/image/I = new/image('icons/obj/storage.dmi',"delivery_tag")
		switch(icon_state)
			if("deliverycrate1")
				I.pixel_y = -5
			if("deliverycrate2")
				I.pixel_y = -2
			if("deliverycrate3")
				I.pixel_y = 0
			if("deliverycrate4")
				if(tag_x == null)
					tag_x = rand(0,5)
				I.pixel_x = tag_x
				I.pixel_y = 3
			if("deliverycrate5")
				I.pixel_y = -3
		add_overlay(I)

/obj/item/smallDelivery/examine(mob/user)
	. = ..()
	if(get_dist(user, src) <= 4)
		if(sortTag)
			. += "<span class='notice'>It is labeled \"[sortTag]\"</span>"
		if(examtext)
			. += "<span class='notice'>It has a note attached which reads, \"[examtext]\"</span>"

/obj/item/weapon/packageWrap
	name = "package wrapper"
	desc = "Like wrapping paper, but less festive."
	icon = 'icons/obj/items.dmi'
	icon_state = "deliveryPaper"
	w_class = ITEMSIZE_NORMAL
	var/amount = 25.0
	drop_sound = 'sound/items/drop/wrapper.ogg'


/obj/item/weapon/packageWrap/afterattack(var/obj/target as obj, mob/user as mob, proximity)
	if(!proximity) return
	if(!istype(target))	//this really shouldn't be necessary (but it is).	-Pete
		return
	if(istype(target, /obj/item/smallDelivery) || istype(target,/obj/structure/bigDelivery) \
	|| istype(target, /obj/item/weapon/gift) || istype(target, /obj/item/weapon/evidencebag))
		return
	if(target.anchored)
		return
	if(!isturf(target.loc)) //no wrapping things inside other things, just breaks things, put it on the ground first.
		return
	if(user in target) //no wrapping closets that you are inside - it's not physically possible
		return

	user.attack_log += text("\[[time_stamp()]\] <font color='blue'>Has used [src.name] on \ref[target]</font>")


	if (istype(target, /obj/item) && !(istype(target, /obj/item/weapon/storage) && !istype(target,/obj/item/weapon/storage/box)))
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
			P.add_fingerprint(usr)
			O.add_fingerprint(usr)
			src.add_fingerprint(usr)
			src.amount -= 1
			user.visible_message("\The [user] wraps \a [target] with \a [src].",\
			"<span class='notice'>You wrap \the [target], leaving [amount] units of paper on \the [src].</span>",\
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
			"<span class='notice'>You wrap \the [target], leaving [amount] units of paper on \the [src].</span>",\
			"You hear someone taping paper around a large object.")
			playsound(src, 'sound/items/package_wrap.ogg', 50, 1)
		else if(src.amount < 3)
			to_chat(user, "<span class='warning'>You need more paper.</span>")
	else if (istype (target, /obj/structure/closet))
		var/obj/structure/closet/O = target
		if (src.amount > 3 && !O.opened)
			var/obj/structure/bigDelivery/P = new /obj/structure/bigDelivery(get_turf(O.loc))
			P.wrapped = O
			O.sealed = 1
			O.loc = P
			src.amount -= 3
			user.visible_message("\The [user] wraps \a [target] with \a [src].",\
			"<span class='notice'>You wrap \the [target], leaving [amount] units of paper on \the [src].</span>",\
			"You hear someone taping paper around a large object.")
			playsound(src, 'sound/items/package_wrap.ogg', 50, 1)
		else if(src.amount < 3)
			to_chat(user, "<span class='warning'>You need more paper.</span>")
	else
		to_chat(user, "<font color='blue'>The object you are trying to wrap is unsuitable for the sorting machinery!</font>")
	if (src.amount <= 0)
		new /obj/item/weapon/c_tube( src.loc )
		qdel(src)
		return
	return

/obj/item/weapon/packageWrap/examine(mob/user)
	. = ..()
	if(get_dist(user, src) <= 0)
		. += "<font color='blue'>There are [amount] units of package wrap left!</font>"

/obj/structure/bigDelivery/Destroy()
	if(wrapped) //sometimes items can disappear. For example, bombs. --rastaf0
		wrapped.forceMove(get_turf(src))
		if(istype(wrapped, /obj/structure/closet))
			var/obj/structure/closet/O = wrapped
			O.sealed = 0
		wrapped = null
	var/turf/T = get_turf(src)
	for(var/atom/movable/AM in contents)
		AM.forceMove(T)
	return ..()

/obj/item/device/destTagger
	name = "destination tagger"
	desc = "Used to set the destination of properly wrapped packages."
	icon_state = "dest_tagger"
	var/currTag = 0

	w_class = ITEMSIZE_SMALL
	item_state = "electronic"
	slot_flags = SLOT_BELT

/obj/item/device/destTagger/tgui_state(mob/user)
	return GLOB.tgui_inventory_state

/obj/item/device/destTagger/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "DestinationTagger", name)
		ui.open()

/obj/item/device/destTagger/tgui_data(mob/user, datum/tgui/ui)
	var/list/data = ..()

	data["currTag"] = currTag
	data["taggerLocs"] = GLOB.tagger_locations

	return data

/obj/item/device/destTagger/attack_self(mob/user as mob)
	tgui_interact(user)

/obj/item/device/destTagger/tgui_act(action, params)
	if(..())
		return TRUE
	add_fingerprint(usr)
	switch(action)
		if("set_tag")
			var/new_tag = params["tag"]
			if(!(new_tag in GLOB.tagger_locations))
				return FALSE
			currTag = new_tag
			. = TRUE

/obj/machinery/disposal/deliveryChute
	name = "Delivery chute"
	desc = "A chute for big and small packages alike!"
	density = TRUE
	icon_state = "intake"

	var/c_mode = 0

/obj/machinery/disposal/deliveryChute/Initialize()
	. = ..()
	trunk = locate() in src.loc
	if(trunk)
		trunk.linked = src	// link the pipe trunk to self

/obj/machinery/disposal/deliveryChute/interact()
	return

/obj/machinery/disposal/deliveryChute/update()
	return

/obj/machinery/disposal/deliveryChute/Bumped(var/atom/movable/AM) //Go straight into the chute
	if(istype(AM, /obj/item/projectile) || istype(AM, /obj/effect) || istype(AM, /obj/mecha))	return
	switch(dir)
		if(NORTH)
			if(AM.loc.y != src.loc.y+1) return
		if(EAST)
			if(AM.loc.x != src.loc.x+1) return
		if(SOUTH)
			if(AM.loc.y != src.loc.y-1) return
		if(WEST)
			if(AM.loc.x != src.loc.x-1) return

	if(istype(AM, /obj))
		var/obj/O = AM
		O.loc = src
	else if(istype(AM, /mob))
		var/mob/M = AM
		M.loc = src
	src.flush()

/obj/machinery/disposal/deliveryChute/flush()
	flushing = 1
	flick("intake-closing", src)
	var/obj/structure/disposalholder/H = new()	// virtual holder object which actually
												// travels through the pipes.
	air_contents = new()		// new empty gas resv.

	sleep(10)
	playsound(src, 'sound/machines/disposalflush.ogg', 50, 0, 0)
	sleep(5) // wait for animation to finish

	H.init(src)	// copy the contents of disposer to holder

	H.start(src) // start the holder processing movement
	flushing = 0
	// now reset disposal state
	flush = 0
	if(mode == 2)	// if was ready,
		mode = 1	// switch to charging
	update()
	return

/obj/machinery/disposal/deliveryChute/attackby(var/obj/item/I, var/mob/user)
	if(!I || !user)
		return

	if(I.is_screwdriver())
		c_mode = !c_mode
		playsound(src, I.usesound, 50, 1)
		to_chat(user, "You [c_mode ? "remove" : "attach"] the screws around the power connection.")
		return
	if(istype(I, /obj/item/weapon/weldingtool) && c_mode==1)
		var/obj/item/weapon/weldingtool/W = I
		if(!W.remove_fuel(0,user))
			to_chat(user, "You need more welding fuel to complete this task.")
			return
		playsound(src, W.usesound, 50, 1)
		to_chat(user, "You start slicing the floorweld off the delivery chute.")
		if(do_after(user,20 * W.toolspeed))
			if(!src || !W.isOn()) return
			to_chat(user, "You sliced the floorweld off the delivery chute.")
			var/obj/structure/disposalconstruct/C = new (src.loc)
			C.ptype = 8 // 8 =  Delivery chute
			C.update()
			C.anchored = TRUE
			C.density = TRUE
			qdel(src)
		return

/obj/machinery/disposal/deliveryChute/Destroy()
	if(trunk)
		trunk.linked = null
	..()
