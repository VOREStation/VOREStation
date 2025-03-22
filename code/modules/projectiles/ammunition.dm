/obj/item/ammo_casing
	name = "bullet casing"
	desc = "A bullet casing."
	icon = 'icons/obj/ammo.dmi'
	icon_state = "s-casing"
	randpixel = 10
	slot_flags = SLOT_BELT | SLOT_EARS
	throwforce = 1
	w_class = ITEMSIZE_TINY
	preserve_item = 1
	drop_sound = 'sound/items/drop/ring.ogg'
	pickup_sound = 'sound/items/pickup/ring.ogg'

	var/leaves_residue = 1
	var/caliber = ""					//Which kind of guns it can be loaded into
	var/projectile_type					//The bullet type to create when New() is called
	var/obj/item/projectile/BB = null	//The loaded bullet - make it so that the projectiles are created only when needed?
	var/caseless = null					//Caseless ammo deletes its self once the projectile is fired.

/obj/item/ammo_casing/Initialize(mapload)
	. = ..()
	if(ispath(projectile_type))
		BB = new projectile_type(src)
	randpixel_xy()

//removes the projectile from the ammo casing
/obj/item/ammo_casing/proc/expend()
	. = BB
	BB = null
	set_dir(pick(cardinal)) //spin spent casings
	update_icon()

/obj/item/ammo_casing/attackby(obj/item/I as obj, mob/user as mob)
	if(I.has_tool_quality(TOOL_SCREWDRIVER))
		if(!BB)
			to_chat(user, span_blue("There is no bullet in the casing to inscribe anything into."))
			return

		var/tmp_label = ""
		var/label_text = sanitizeSafe(tgui_input_text(user, "Inscribe some text into \the [initial(BB.name)]","Inscription",tmp_label,MAX_NAME_LEN), MAX_NAME_LEN)
		if(length(label_text) > 20)
			to_chat(user, span_red("The inscription can be at most 20 characters long."))
		else if(!label_text)
			to_chat(user, span_blue("You scratch the inscription off of [initial(BB)]."))
			BB.name = initial(BB.name)
		else
			to_chat(user, span_blue("You inscribe \"[label_text]\" into \the [initial(BB.name)]."))
			BB.name = "[initial(BB.name)] (\"[label_text]\")"
	else if(istype(I, /obj/item/ammo_magazine) && isturf(loc)) // Mass magazine reloading.
		var/obj/item/ammo_magazine/box = I
		if (!box.can_remove_ammo || box.reloading)
			return ..()

		box.reloading = TRUE
		var/boolets = 0
		var/turf/floor = loc
		for(var/obj/item/ammo_casing/bullet in floor)
			if(box.stored_ammo.len >= box.max_ammo)
				break
			if(box.caliber == bullet.caliber && bullet.BB)
				if (boolets < 1)
					to_chat(user, span_notice("You start collecting shells.")) // Say it here so it doesn't get said if we don't find anything useful.
				if(do_after(user,5,box))
					if(box.stored_ammo.len >= box.max_ammo) // Double check because these can change during the wait.
						break
					if(bullet.loc != floor)
						continue
					bullet.forceMove(box)
					box.stored_ammo.Add(bullet)
					box.update_icon()
					boolets++
				else
					break

		if(boolets > 0)
			to_chat(user, span_notice("You collect [boolets] shell\s. [box] now contains [box.stored_ammo.len] shell\s."))
		else
			to_chat(user, span_warning("You fail to collect anything!"))
		box.reloading = FALSE
	else
		return ..()

/obj/item/ammo_casing/update_icon()
	if(!BB)
		icon_state = "[initial(icon_state)]-spent"

/obj/item/ammo_casing/examine(mob/user)
	. = ..()
	if (!BB)
		. += "This one is spent."

//An item that holds casings and can be used to put them inside guns
/obj/item/ammo_magazine
	name = "magazine"
	desc = "A magazine for some kind of gun."
	icon_state = ".357"
	icon = 'icons/obj/ammo.dmi'
	slot_flags = SLOT_BELT
	item_state = "syringe_kit"
	matter = list(MAT_STEEL = 500)
	throwforce = 5
	w_class = ITEMSIZE_SMALL
	throw_speed = 4
	throw_range = 10
	preserve_item = 1

	var/list/stored_ammo = list()
	var/mag_type = SPEEDLOADER //ammo_magazines can only be used with compatible guns. This is not a bitflag, the load_method var on guns is.
	var/caliber = ".357"
	var/max_ammo = 7

	var/ammo_type = /obj/item/ammo_casing //ammo type that is initially loaded
	var/initial_ammo = null

	var/can_remove_ammo = TRUE	// Can this thing have bullets removed one-by-one? As of first implementation, only affects smart magazines
	var/reloading = FALSE		//  Is this magazine being reloaded, currently? - Currently only useful for automatic pickups, ignored by manual reloading.

	var/multiple_sprites = 0
	//because BYOND doesn't support numbers as keys in associative lists
	var/list/icon_keys = list()		//keys
	var/list/ammo_states = list()	//values

/obj/item/ammo_magazine/Initialize(mapload)
	. = ..()
	pixel_x = rand(-5, 5)
	pixel_y = rand(-5, 5)
	if(multiple_sprites)
		initialize_magazine_icondata(src)

	if(isnull(initial_ammo))
		initial_ammo = max_ammo

	if(initial_ammo)
		for(var/i in 1 to initial_ammo)
			stored_ammo += new ammo_type(src)
	update_icon()

/obj/item/ammo_magazine/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/ammo_casing))
		var/obj/item/ammo_casing/C = W
		if(C.caliber != caliber)
			to_chat(user, span_warning("[C] does not fit into [src]."))
			return
		if(stored_ammo.len >= max_ammo)
			to_chat(user, span_warning("[src] is full!"))
			return
		user.remove_from_mob(C)
		C.forceMove(src)
		stored_ammo.Add(C)
		update_icon()
	if(istype(W, /obj/item/ammo_magazine/clip))
		var/obj/item/ammo_magazine/clip/L = W
		if(L.caliber != caliber)
			to_chat(user, span_warning("The ammo in [L] does not fit into [src]."))
			return
		if(!L.stored_ammo.len)
			to_chat(user, span_warning("There's no more ammo [L]!"))
			return
		if(stored_ammo.len >= max_ammo)
			to_chat(user, span_warning("[src] is full!"))
			return
		var/obj/item/ammo_casing/AC = L.stored_ammo[1] //select the next casing.
		L.stored_ammo -= AC //Remove this casing from loaded list of the clip.
		AC.forceMove(src)
		stored_ammo.Insert(1, AC) //add it to the head of our magazine's list
		L.update_icon()
	playsound(src, 'sound/weapons/flipblade.ogg', 50, 1)
	update_icon()

// This dumps all the bullets right on the floor
/obj/item/ammo_magazine/attack_self(mob/user)
	if(can_remove_ammo)
		if(!stored_ammo.len)
			to_chat(user, span_notice("[src] is already empty!"))
			return
		to_chat(user, span_notice("You empty [src]."))
		playsound(src, "casing_sound", 50, 1)
		spawn(7)
			playsound(src, "casing_sound", 50, 1)
		spawn(10)
			playsound(src, "casing_sound", 50, 1)
		for(var/obj/item/ammo_casing/C in stored_ammo)
			C.loc = user.loc
			C.set_dir(pick(cardinal))
		stored_ammo.Cut()
		update_icon()
	else
		to_chat(user, span_notice("\The [src] is not designed to be unloaded."))
		return

// This puts one bullet from the magazine into your hand
/obj/item/ammo_magazine/attack_hand(mob/user)
	if(can_remove_ammo)	// For Smart Magazines
		if(user.get_inactive_hand() == src)
			if(stored_ammo.len)
				var/obj/item/ammo_casing/C = stored_ammo[stored_ammo.len]
				stored_ammo-=C
				user.put_in_hands(C)
				user.visible_message("\The [user] removes \a [C] from [src].", span_notice("You remove \a [C] from [src]."))
				update_icon()
				return
	..()

/obj/item/ammo_magazine/update_icon()
	if(multiple_sprites)
		//find the lowest key greater than or equal to stored_ammo.len
		var/new_state = null
		for(var/idx in 1 to icon_keys.len)
			var/ammo_count = icon_keys[idx]
			if (ammo_count >= stored_ammo.len)
				new_state = ammo_states[idx]
				break
		icon_state = (new_state)? new_state : initial(icon_state)

/obj/item/ammo_magazine/examine(mob/user)
	. = ..()
	. += "There [(stored_ammo.len == 1)? "is" : "are"] [stored_ammo.len] round\s left!"

//magazine icon state caching
/var/global/list/magazine_icondata_keys = list()
/var/global/list/magazine_icondata_states = list()

/proc/initialize_magazine_icondata(var/obj/item/ammo_magazine/M)
	var/typestr = M.type
	if(!(typestr in magazine_icondata_keys) || !(typestr in magazine_icondata_states))
		magazine_icondata_cache_add(M)

	M.icon_keys = magazine_icondata_keys[typestr]
	M.ammo_states = magazine_icondata_states[typestr]

/proc/magazine_icondata_cache_add(var/obj/item/ammo_magazine/M)
	var/list/icon_keys = list()
	var/list/ammo_states = list()
	var/list/states = cached_icon_states(M.icon)
	for(var/i = 0, i <= M.max_ammo, i++)
		var/ammo_state = "[M.icon_state]-[i]"
		if(ammo_state in states)
			icon_keys += i
			ammo_states += ammo_state

	magazine_icondata_keys[M.type] = icon_keys
	magazine_icondata_states[M.type] = ammo_states

/*
 * Ammo Boxes
 */

/obj/item/ammo_magazine/ammo_box
	name = "ammo box"
	desc = "A box that holds some kind of ammo."
	icon = 'icons/obj/ammo_boxes.dmi'
	icon_state = "pistol"
	slot_flags = null //You can't fit a box on your belt
	item_state = "paper"
	matter = null
	throwforce = 3
	throw_speed = 5
	throw_range = 12
	preserve_item = 1
	caliber = ".357"
	drop_sound = 'sound/items/drop/matchbox.ogg'
	pickup_sound = 'sound/items/pickup/matchbox.ogg'

/obj/item/ammo_magazine/ammo_box/AltClick(mob/user)
	if(can_remove_ammo)
		if(isliving(user) && Adjacent(user))
			if(stored_ammo.len)
				var/obj/item/ammo_casing/C = stored_ammo[stored_ammo.len]
				stored_ammo-=C
				user.put_in_hands(C)
				user.visible_message("\The [user] removes \a [C] from [src].", span_notice("You remove \a [C] from [src]."))
				update_icon()
				return
	..()

/obj/item/ammo_magazine/ammo_box/examine(mob/user)
	. = ..()

	. += to_chat(user, span_notice("Alt-click to extract contents."))
