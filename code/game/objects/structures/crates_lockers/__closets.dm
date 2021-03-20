// Someone should really merge secure closets and crates into this, which Bay has done already.
/obj/structure/closet
	name = "closet"
	desc = "It's a basic storage unit."
	icon = 'icons/obj/closets/bases/closet.dmi'
	icon_state = "base"
	density = 1
	w_class = ITEMSIZE_HUGE
	layer = UNDER_JUNK_LAYER
	
	var/opened = 0
	var/sealed = 0
	
	var/seal_tool = /obj/item/weapon/weldingtool	//Tool used to seal the closet, defaults to welder
	var/wall_mounted = 0 //never solid (You can always pass over it)
	var/health = 100

	var/breakout = 0 //if someone is currently breaking out. mutex
	var/breakout_time = 2 //2 minutes by default
	var/breakout_sound = 'sound/effects/grillehit.ogg'	//Sound that plays while breaking out

	var/storage_capacity = 2 * MOB_MEDIUM //This is so that someone can't pack hundreds of items in a locker/crate
							  //then open it in a populated area to crash clients.
	var/storage_cost = 40	//How much space this closet takes up if it's stuffed in another closet

	var/open_sound = 'sound/machines/click.ogg'
	var/close_sound = 'sound/machines/click.ogg'

	var/store_misc = 1		//Chameleon item check
	var/store_items = 1		//Will the closet store items?
	var/store_mobs = 1		//Will the closet store mobs?
	var/max_closets = 0		//Number of other closets allowed on tile before it won't close.

	var/list/starts_with // List of type = count (or just type for 1)

	var/closet_appearance = /decl/closet_appearance // The /decl that defines what decals we end up with, that makes our look unique

/obj/structure/closet/Initialize()
	..()
	return INITIALIZE_HINT_LATELOAD

/obj/structure/closet/LateInitialize()
	. = ..()
	if(starts_with)
		create_objects_in_loc(src, starts_with)
		starts_with = null

	if(!opened)		// if closed, any item at the crate's loc is put in the contents
		if(istype(loc, /mob/living)) return
		var/obj/item/I
		for(I in loc)
			if(I.density || I.anchored || I == src) continue
			I.forceMove(src)
		// adjust locker size to hold all items with 5 units of free store room
		var/content_size = 0
		for(I in contents)
			content_size += CEILING(I.w_class/2, 1)
		if(content_size > storage_capacity-5)
			storage_capacity = content_size + 5

	if(ispath(closet_appearance))
		var/decl/closet_appearance/app = GLOB.closet_appearances[closet_appearance]
		if(app)
			icon = app.icon
			color = null
	update_icon()

/obj/structure/closet/examine(mob/user)
	. = ..()
	if(Adjacent(user) || isobserver(user))
		var/content_size = 0
		for(var/obj/item/I in contents)
			if(!I.anchored)
				content_size += CEILING(I.w_class/2, 1)
		if(!content_size)
			. += "It is empty."
		else if(storage_capacity > content_size*4)
			. += "It is barely filled."
		else if(storage_capacity > content_size*2)
			. += "It is less than half full."
		else if(storage_capacity > content_size)
			. += "There is still some free space."
		else
			. += "It is full."

	if(!opened && isobserver(user))
		. += "It contains: [counting_english_list(contents)]"

/obj/structure/closet/CanPass(atom/movable/mover, turf/target)
	if(wall_mounted)
		return TRUE
	return ..()

/obj/structure/closet/proc/can_open()
	if(sealed)
		return 0
	return 1

/obj/structure/closet/proc/can_close()
	var/closet_count = 0
	for(var/obj/structure/closet/closet in get_turf(src))
		if(closet != src)
			if(!closet.anchored)
				closet_count ++
	if(closet_count > max_closets)
		return 0
	return 1

/obj/structure/closet/proc/dump_contents()
	//Cham Projector Exception
	for(var/obj/effect/dummy/chameleon/AD in src)
		AD.forceMove(loc)

	for(var/obj/I in src)
		I.forceMove(loc)

	for(var/mob/M in src)
		M.forceMove(loc)
		if(M.client)
			M.client.eye = M.client.mob
			M.client.perspective = MOB_PERSPECTIVE

/obj/structure/closet/proc/open()
	if(opened)
		return 0

	if(!can_open())
		return 0

	dump_contents()

	opened = 1
	playsound(src, open_sound, 15, 1, -3)
	if(initial(density))
		density = !density
	update_icon()
	return 1

/obj/structure/closet/proc/close()
	if(!opened)
		return 0
	if(!can_close())
		return 0

	var/stored_units = 0

	if(store_misc)
		stored_units += store_misc(stored_units)
	if(store_items)
		stored_units += store_items(stored_units)
	if(store_mobs)
		stored_units += store_mobs(stored_units)
	if(max_closets)
		stored_units += store_closets(stored_units)

	opened = 0

	playsound(src, close_sound, 15, 1, -3)
	if(initial(density))
		density = !density
	update_icon()
	return 1

//Cham Projector Exception
/obj/structure/closet/proc/store_misc(var/stored_units)
	var/added_units = 0
	for(var/obj/effect/dummy/chameleon/AD in loc)
		if((stored_units + added_units) > storage_capacity)
			break
		AD.forceMove(src)
		added_units++
	return added_units

/obj/structure/closet/proc/store_items(var/stored_units)
	var/added_units = 0
	for(var/obj/item/I in loc)
		var/item_size = CEILING(I.w_class / 2, 1)
		if(stored_units + added_units + item_size > storage_capacity)
			continue
		if(!I.anchored)
			I.forceMove(src)
			added_units += item_size
	return added_units

/obj/structure/closet/proc/store_mobs(var/stored_units)
	var/added_units = 0
	for(var/mob/living/M in loc)
		if(M.buckled || M.pinned.len)
			continue
		if(stored_units + added_units + M.mob_size > storage_capacity)
			break
		if(M.client)
			M.client.perspective = EYE_PERSPECTIVE
			M.client.eye = src
		M.forceMove(src)
		added_units += M.mob_size
	return added_units

/obj/structure/closet/proc/store_closets(var/stored_units)
	var/added_units = 0
	for(var/obj/structure/closet/C in loc)
		if(C == src)	//Don't store ourself
			continue
		if(C.anchored)	//Don't worry about anchored things on the same tile
			continue
		if(C.max_closets)	//Prevents recursive storage
			continue
		if(stored_units + added_units + storage_cost > storage_capacity)
			break
		C.forceMove(src)
		added_units += storage_cost
	return added_units


/obj/structure/closet/proc/toggle(mob/user as mob)
	if(!(opened ? close() : open()))
		to_chat(user, "<span class='notice'>It won't budge!</span>")
		return
	update_icon()

// this should probably use dump_contents()
/obj/structure/closet/ex_act(severity)
	switch(severity)
		if(1)
			for(var/atom/movable/A as mob|obj in src)//pulls everything out of the locker and hits it with an explosion
				A.forceMove(loc)
				A.ex_act(severity + 1)
			qdel(src)
		if(2)
			if(prob(50))
				for (var/atom/movable/A as mob|obj in src)
					A.forceMove(loc)
					A.ex_act(severity + 1)
				qdel(src)
		if(3)
			if(prob(5))
				for(var/atom/movable/A as mob|obj in src)
					A.forceMove(loc)
				qdel(src)

/obj/structure/closet/blob_act()
	damage(100)

/obj/structure/closet/proc/damage(var/damage)
	health -= damage
	if(health <= 0)
		for(var/atom/movable/A in src)
			A.forceMove(loc)
		qdel(src)

/obj/structure/closet/bullet_act(var/obj/item/projectile/Proj)
	var/proj_damage = Proj.get_structure_damage()
	if(!proj_damage)
		return

	..()
	damage(proj_damage)

	return

/obj/structure/closet/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(W.is_wrench())
		if(opened)
			if(anchored)
				user.visible_message("\The [user] begins unsecuring \the [src] from the floor.", "You start unsecuring \the [src] from the floor.")
			else
				user.visible_message("\The [user] begins securing \the [src] to the floor.", "You start securing \the [src] to the floor.")
			if(do_after(user, 20 * W.toolspeed))
				if(!src) return
				to_chat(user, "<span class='notice'>You [anchored? "un" : ""]secured \the [src]!</span>")
				anchored = !anchored
				return
		else
			to_chat(user, "<span class='notice'>You can't reach the anchoring bolts when the door is closed!</span>")
	else if(opened)
		if(istype(W, /obj/item/weapon/grab))
			var/obj/item/weapon/grab/G = W
			MouseDrop_T(G.affecting, user)      //act like they were dragged onto the closet
			return 0
		if(istype(W,/obj/item/tk_grab))
			return 0
		if(istype(W, /obj/item/weapon/weldingtool))
			var/obj/item/weapon/weldingtool/WT = W
			if(!WT.remove_fuel(0,user))
				if(!WT.isOn())
					return
				else
					to_chat(user, "<span class='notice'>You need more welding fuel to complete this task.</span>")
					return
			playsound(src, WT.usesound, 50)
			new /obj/item/stack/material/steel(loc)
			for(var/mob/M in viewers(src))
				M.show_message("<span class='notice'>\The [src] has been cut apart by [user] with \the [WT].</span>", 3, "You hear welding.", 2)
			qdel(src)
			return
		if(istype(W, /obj/item/weapon/storage/laundry_basket) && W.contents.len)
			var/obj/item/weapon/storage/laundry_basket/LB = W
			var/turf/T = get_turf(src)
			for(var/obj/item/I in LB.contents)
				LB.remove_from_storage(I, T)
			user.visible_message("<span class='notice'>[user] empties \the [LB] into \the [src].</span>", \
								 "<span class='notice'>You empty \the [LB] into \the [src].</span>", \
								 "<span class='notice'>You hear rustling of clothes.</span>")
			return
		if(isrobot(user))
			return
		if(W.loc != user) // This should stop mounted modules ending up outside the module.
			return
		usr.drop_item()
		if(W)
			W.forceMove(loc)
	else if(istype(W, /obj/item/weapon/packageWrap))
		return
	else if(seal_tool)
		if(istype(W, seal_tool))
			var/obj/item/weapon/S = W
			if(istype(S, /obj/item/weapon/weldingtool))
				var/obj/item/weapon/weldingtool/WT = S
				if(!WT.remove_fuel(0,user))
					if(!WT.isOn())
						return
					else
						to_chat(user, "<span class='notice'>You need more welding fuel to complete this task.</span>")
						return
			if(do_after(user, 20 * S.toolspeed))
				playsound(src, S.usesound, 50)
				sealed = !sealed
				update_icon()
				for(var/mob/M in viewers(src))
					M.show_message("<span class='warning'>[src] has been [sealed?"sealed":"unsealed"] by [user.name].</span>", 3)
	else
		attack_hand(user)
	return

/obj/structure/closet/MouseDrop_T(atom/movable/O as mob|obj, mob/user as mob)
	if(istype(O, /obj/screen))	//fix for HUD elements making their way into the world	-Pete
		return
	if(O.loc == user)
		return
	if(user.restrained() || user.stat || user.weakened || user.stunned || user.paralysis)
		return
	if((!( istype(O, /atom/movable) ) || O.anchored || !Adjacent(user) || !Adjacent(O) || !user.Adjacent(O) || user.contents.Find(src)))
		return
	if(!isturf(user.loc)) // are you in a container/closet/pod/etc?
		return
	if(!opened)
		return
	if(istype(O, /obj/structure/closet))
		return
	step_towards(O, loc)
	if(user != O)
		user.show_viewers("<span class='danger'>[user] stuffs [O] into [src]!</span>")
	add_fingerprint(user)
	return

/obj/structure/closet/attack_robot(mob/user)
	if(Adjacent(user))
		attack_hand(user)

/obj/structure/closet/relaymove(mob/user as mob)
	if(user.stat || !isturf(loc))
		return

	if(!open())
		to_chat(user, "<span class='notice'>It won't budge!</span>")

/obj/structure/closet/attack_hand(mob/user as mob)
	add_fingerprint(user)
	toggle(user)

// tk grab then use on self
/obj/structure/closet/attack_self_tk(mob/user as mob)
	add_fingerprint(user)
	if(!toggle())
		to_chat(usr, "<span class='notice'>It won't budge!</span>")

/obj/structure/closet/verb/verb_toggleopen()
	set src in oview(1)
	set category = "Object"
	set name = "Toggle Open"

	if(!usr.canmove || usr.stat || usr.restrained())
		return

	if(ishuman(usr) || isrobot(usr))
		add_fingerprint(usr)
		toggle(usr)
	else
		to_chat(usr, "<span class='warning'>This mob type can't use this verb.</span>")

/obj/structure/closet/update_icon()
	if(opened)
		icon_state = "open"
	else
		icon_state = "closed_unlocked[sealed ? "_welded" : ""]"

/obj/structure/closet/attack_generic(var/mob/user, var/damage, var/attack_message = "destroys")
	if(damage < STRUCTURE_MIN_DAMAGE_THRESHOLD)
		return
	user.do_attack_animation(src)
	visible_message("<span class='danger'>[user] [attack_message] the [src]!</span>")
	dump_contents()
	spawn(1) qdel(src)
	return 1

/obj/structure/closet/proc/req_breakout()
	if(opened)
		return 0 //Door's open... wait, why are you in it's contents then?
	if(!sealed)
		return 0 //closed but not sealed...
	return 1

/obj/structure/closet/container_resist(var/mob/living/escapee)
	if(breakout || !req_breakout())
		return

	escapee.setClickCooldown(100)

	//okay, so the closet is either sealed or locked... resist!!!
	to_chat(escapee, "<span class='warning'>You lean on the back of \the [src] and start pushing the door open. (this will take about [breakout_time] minutes)</span>")

	visible_message("<span class='danger'>\The [src] begins to shake violently!</span>")

	breakout = 1 //can't think of a better way to do this right now.
	for(var/i in 1 to (6*breakout_time * 2)) //minutes * 6 * 5seconds * 2
		if(!do_after(escapee, 50)) //5 seconds
			breakout = 0
			return
		if(!escapee || escapee.incapacitated() || escapee.loc != src)
			breakout = 0
			return //closet/user destroyed OR user dead/unconcious OR user no longer in closet OR closet opened
		//Perform the same set of checks as above for weld and lock status to determine if there is even still a point in 'resisting'...
		if(!req_breakout())
			breakout = 0
			return

			playsound(src, breakout_sound, 100, 1)
			animate_shake()
			add_fingerprint(escapee)

		//Well then break it!
		breakout = 0
		to_chat(escapee, "<span class='warning'>You successfully break out!</span>")
		visible_message("<span class='danger'>\The [escapee] successfully broke out of \the [src]!</span>")
		playsound(src, breakout_sound, 100, 1)
		break_open()
		animate_shake()

/obj/structure/closet/proc/break_open()
	sealed = 0
	update_icon()
	//Do this to prevent contents from being opened into nullspace (read: bluespace)
	if(istype(loc, /obj/structure/bigDelivery))
		var/obj/structure/bigDelivery/BD = loc
		BD.unwrap()
	open()

/obj/structure/closet/proc/animate_shake()
	var/init_px = pixel_x
	var/shake_dir = pick(-1, 1)
	animate(src, transform=turn(matrix(), 8*shake_dir), pixel_x=init_px + 2*shake_dir, time=1)
	animate(transform=null, pixel_x=init_px, time=6, easing=ELASTIC_EASING)

/obj/structure/closet/onDropInto(var/atom/movable/AM)
	return

/obj/structure/closet/AllowDrop()
	return TRUE

/obj/structure/closet/return_air_for_internal_lifeform(var/mob/living/L)
	if(loc)
		if(istype(loc, /obj/structure/closet))
			return (loc.return_air_for_internal_lifeform(L))
	return return_air()

/obj/structure/closet/take_damage(var/damage)
	if(damage < STRUCTURE_MIN_DAMAGE_THRESHOLD)
		return
	dump_contents()
	spawn(1) qdel(src)
	return 1

// Just a generic cabinet for mappers to use
/obj/structure/closet/cabinet
	name = "cabinet"
	icon = 'icons/obj/closets/bases/cabinet.dmi'
	closet_appearance = /decl/closet_appearance/cabinet
