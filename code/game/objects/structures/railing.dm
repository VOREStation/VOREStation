// Based on railing.dmi from https://github.com/Endless-Horizon/CEV-Eris
/obj/structure/railing
	name = "railing"
	desc = "A standard steel railing, painted orange.  Play stupid games, win stupid prizes."
	icon = 'icons/obj/railing.dmi'
	density = TRUE
	throwpass = 1
	climbable = TRUE
	layer = WINDOW_LAYER
	anchored = TRUE
	flags = ON_BORDER
	icon_state = "railing0"
	var/broken = FALSE
	var/health = 70
	var/maxhealth = 70
	var/check = 0
	var/icon_modifier = ""

/obj/structure/railing/grey
	name = "grey railing"
	desc = "A standard steel railing. Prevents stupid people from falling to their doom."
	icon_modifier = "grey_"
	icon_state = "grey_railing0"

/obj/structure/railing/New(loc, constructed = 0)
	..()
	// TODO - "constructed" is not passed to us. We need to find a way to do this safely.
	if (constructed) // player-constructed railings
		anchored = FALSE
	if(climbable)
		verbs += /obj/structure/proc/climb_on

/obj/structure/railing/Initialize(mapload)
	. = ..()
	if(src.anchored)
		update_icon(0)

/obj/structure/railing/Destroy()
	var/turf/location = loc
	. = ..()
	for(var/obj/structure/railing/R in orange(location, 1))
		R.update_icon()

/obj/structure/railing/CanPass(atom/movable/mover, turf/target)
	if(istype(mover) && mover.checkpass(PASSTABLE))
		return TRUE
	if(get_dir(mover, target) == reverse_dir[dir]) // From elsewhere to here, can't move against our dir
		return !density
	return TRUE

/obj/structure/railing/Uncross(atom/movable/mover, turf/target)
	if(istype(mover) && mover.checkpass(PASSTABLE))
		return TRUE
	if(get_dir(mover, target) == dir) // From here to elsewhere, can't move in our dir
		return !density
	return TRUE

/obj/structure/railing/examine(mob/user)
	. = ..()
	if(health < maxhealth)
		switch(health / maxhealth)
			if(0.0 to 0.5)
				. += span_warning("It looks severely damaged!")
			if(0.25 to 0.5)
				. += span_warning("It looks damaged!")
			if(0.5 to 1.0)
				. += span_notice("It has a few scrapes and dents.")

/obj/structure/railing/take_damage(amount)
	health -= amount
	if(health <= 0)
		visible_message(span_warning("\The [src] breaks down!"))
		playsound(src, 'sound/effects/grillehit.ogg', 50, 1)
		new /obj/item/stack/rods(get_turf(src))
		qdel(src)

/obj/structure/railing/proc/NeighborsCheck(var/UpdateNeighbors = 1)
	check = 0
	//if (!anchored) return
	var/Rturn = turn(src.dir, -90)
	var/Lturn = turn(src.dir, 90)

	for(var/obj/structure/railing/R in src.loc)
		if ((R.dir == Lturn) && R.anchored)
			check |= 32
			if (UpdateNeighbors)
				R.update_icon(0)
		if ((R.dir == Rturn) && R.anchored)
			check |= 2
			if (UpdateNeighbors)
				R.update_icon(0)

	for (var/obj/structure/railing/R in get_step(src, Lturn))
		if ((R.dir == src.dir) && R.anchored)
			check |= 16
			if (UpdateNeighbors)
				R.update_icon(0)
	for (var/obj/structure/railing/R in get_step(src, Rturn))
		if ((R.dir == src.dir) && R.anchored)
			check |= 1
			if (UpdateNeighbors)
				R.update_icon(0)

	for (var/obj/structure/railing/R in get_step(src, (Lturn + src.dir)))
		if ((R.dir == Rturn) && R.anchored)
			check |= 64
			if (UpdateNeighbors)
				R.update_icon(0)
	for (var/obj/structure/railing/R in get_step(src, (Rturn + src.dir)))
		if ((R.dir == Lturn) && R.anchored)
			check |= 4
			if (UpdateNeighbors)
				R.update_icon(0)

/obj/structure/railing/update_icon(var/UpdateNeighgors = 1)
	NeighborsCheck(UpdateNeighgors)
	//layer = (dir == SOUTH) ? FLY_LAYER : initial(layer) // wtf does this even do
	cut_overlays()
	if (!check || !anchored)//|| !anchored
		icon_state = "[icon_modifier]railing0"
	else
		icon_state = "[icon_modifier]railing1"
		if (check & 32)
			add_overlay(image(icon, src, "[icon_modifier]corneroverlay"))
		if ((check & 16) || !(check & 32) || (check & 64))
			add_overlay(image(icon, src, "[icon_modifier]frontoverlay_l"))
		if (!(check & 2) || (check & 1) || (check & 4))
			add_overlay(image(icon, src, "[icon_modifier]frontoverlay_r"))
			if(check & 4)
				switch (src.dir)
					if (NORTH)
						add_overlay(image(icon, src, "[icon_modifier]mcorneroverlay", pixel_x = 32))
					if (SOUTH)
						add_overlay(image(icon, src, "[icon_modifier]mcorneroverlay", pixel_x = -32))
					if (EAST)
						add_overlay(image(icon, src, "[icon_modifier]mcorneroverlay", pixel_y = -32))
					if (WEST)
						add_overlay(image(icon, src, "[icon_modifier]mcorneroverlay", pixel_y = 32))

/obj/structure/railing/verb/rotate_counterclockwise()
	set name = "Rotate Railing Counter-Clockwise"
	set category = "Object"
	set src in oview(1)

	if(usr.incapacitated())
		return 0

	if (!can_touch(usr) || ismouse(usr))
		return

	if(anchored)
		to_chat(usr, "It is fastened to the floor therefore you can't rotate it!")
		return 0

	src.set_dir(turn(src.dir, 90))
	update_icon()
	return

/obj/structure/railing/verb/rotate_clockwise()
	set name = "Rotate Railing Clockwise"
	set category = "Object"
	set src in oview(1)

	if(usr.incapacitated())
		return 0

	if (!can_touch(usr) || ismouse(usr))
		return

	if(anchored)
		to_chat(usr, "It is fastened to the floor therefore you can't rotate it!")
		return 0

	src.set_dir(turn(src.dir, 270))
	update_icon()
	return

/obj/structure/railing/verb/flip() // This will help push railing to remote places, such as open space turfs
	set name = "Flip Railing"
	set category = "Object"
	set src in oview(1)

	if(usr.incapacitated())
		return 0

	if (!can_touch(usr) || ismouse(usr))
		return

	if(anchored)
		to_chat(usr, "It is fastened to the floor therefore you can't flip it!")
		return 0

	var/obj/occupied = neighbor_turf_impassable()
	if(occupied)
		to_chat(usr, "You can't flip \the [src] because there's \a [occupied] in the way.")
		return 0

	src.loc = get_step(src, src.dir)
	set_dir(turn(dir, 180))
	update_icon()
	return

/obj/structure/railing/attackby(obj/item/W as obj, mob/user as mob)
	// Dismantle
	if(W.has_tool_quality(TOOL_WRENCH) && !anchored)
		playsound(src, W.usesound, 50, 1)
		if(do_after(user, 20, src))
			user.visible_message(span_infoplain(span_bold("\The [user]") + " dismantles \the [src]."), span_notice("You dismantle \the [src]."))
			new /obj/item/stack/material/steel(get_turf(user), 2)
			qdel(src)
			return

	// Repair
	if(health < maxhealth && W.has_tool_quality(TOOL_WELDER))
		var/obj/item/weldingtool/F = W.get_welder()
		if(F.welding)
			playsound(src, F.usesound, 50, 1)
			if(do_after(user, 20, src))
				user.visible_message(span_infoplain(span_bold("\The [user]") + " repairs some damage to \the [src]."), span_notice("You repair some damage to \the [src]."))
				health = min(health+(maxhealth/5), maxhealth) // 20% repair per application
				return

	// Install
	if(W.has_tool_quality(TOOL_SCREWDRIVER))
		user.visible_message(span_info((anchored ? (span_bold("\The [user]") + " begins unscrewing \the [src].") : (span_bold("\The [user]") + "begins fasten \the [src]."))))
		playsound(src, W.usesound, 75, 1)
		if(do_after(user, 10, src))
			to_chat(user, (anchored ? span_notice("You have unfastened \the [src] from the floor.") : span_notice("You have fastened \the [src] to the floor.")))
			anchored = !anchored
			update_icon()
			return

	// Handle harm intent grabbing/tabling.
	if(istype(W, /obj/item/grab) && get_dist(src,user)<2)
		var/obj/item/grab/G = W
		if (isliving(G.affecting))
			var/mob/living/M = G.affecting
			var/obj/occupied = turf_is_crowded()
			if(occupied)
				to_chat(user, span_danger("There's \a [occupied] in the way."))
				return
			if (G.state < 2)
				if(user.a_intent == I_HURT)
					if (prob(15))	M.Weaken(5)
					M.apply_damage(8,def_zone = "head")
					take_damage(8)
					visible_message(span_danger("[G.assailant] slams [G.affecting]'s face against \the [src]!"))
					playsound(src, 'sound/effects/grillehit.ogg', 50, 1)
				else
					to_chat(user, span_danger("You need a better grip to do that!"))
					return
			else
				if (get_turf(G.affecting) == get_turf(src))
					G.affecting.forceMove(get_step(src, src.dir))
				else
					G.affecting.forceMove(get_turf(src))
				G.affecting.Weaken(5)
				visible_message(span_danger("[G.assailant] throws [G.affecting] over \the [src]!"))
			qdel(W)
			return

	else
		playsound(src, 'sound/effects/grillehit.ogg', 50, 1)
		take_damage(W.force)
		user.setClickCooldown(user.get_attack_speed(W))

	return ..()

/obj/structure/railing/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			qdel(src)
			return
		if(3.0)
			qdel(src)
			return
	return

// Duplicated from structures.dm, but its a bit different.
/obj/structure/railing/do_climb(var/mob/living/user)
	if(!can_climb(user))
		return

	user.visible_message(span_warning("[user] starts climbing onto \the [src]!"))
	LAZYDISTINCTADD(climbers, user)

	if(!do_after(user,(issmall(user) ? 20 : 34)))
		LAZYREMOVE(climbers, user)
		return

	if(!can_climb(user, post_climb_check=1))
		LAZYREMOVE(climbers, user)
		return

	if(get_turf(user) == get_turf(src))
		user.forceMove(get_step(src, src.dir))
	else
		user.forceMove(get_turf(src))

	user.visible_message(span_warning("[user] climbed over \the [src]!"))
	if(!anchored)	take_damage(maxhealth) // Fatboy
	LAZYREMOVE(climbers, user)

/obj/structure/railing/can_climb(var/mob/living/user, post_climb_check=0)
	if(!..())
		return 0

	// Normal can_climb() handles climbing from adjacent turf onto our turf.  But railings also allow climbing
	// from our turf onto an adjacent! If that is the case we need to do checks for that too...
	if(get_turf(user) == get_turf(src))
		var/obj/occupied = neighbor_turf_impassable()
		if(occupied)
			to_chat(user, span_danger("You can't climb there, there's \a [occupied] in the way."))
			return 0
	return 1

// TODO - This here might require some investigation
/obj/structure/proc/neighbor_turf_impassable()
	var/turf/T = get_step(src, src.dir)
	if(!T || !istype(T))
		return 0
	if(T.density == 1)
		return T
	for(var/obj/O in T.contents)
		if(istype(O,/obj/structure))
			var/obj/structure/S = O
			if(S.climbable) continue
		if(O && O.density && !(O.flags & ON_BORDER && !(turn(O.dir, 180) & dir)))
			return O
