/obj/structure/animal_den
	name = "den"
	icon = 'icons/obj/structures/den.dmi'
	icon_state = "den1"
	desc = "A rough-walled, shallow den dug into the earth."
	density = FALSE
	opacity = FALSE

/obj/structure/animal_den/Initialize()
	icon_state = "den[rand(1,3)]"
	. = ..()

/obj/structure/animal_den/proc/remove_from_den(var/atom/movable/AM)
	AM.dropInto(get_turf(src))
	if(ismob(AM))
		var/mob/M = AM
		if(M.client)
			M.client.eye = M.client.mob
			M.client.perspective = MOB_PERSPECTIVE
	update_icon()

/obj/structure/animal_den/relaymove(mob/user, direction)
	remove_from_den(user)
	user.visible_message(SPAN_NOTICE("\The [user] emerges from \the [src]."))

/obj/structure/animal_den/Destroy()
	for(var/atom/movable/AM in contents)
		remove_from_den(AM)
	. = ..()

/obj/structure/animal_den/attack_hand(mob/user)
	if(try_grab_occupant(user))
		return TRUE
	. = ..()

/obj/structure/animal_den/attackby(obj/item/O, mob/user)
	if(O.has_tool_quality(TOOL_SHOVEL) && try_collapse_den(user))
		return TRUE
	. = ..()

/obj/structure/animal_den/proc/try_grab_occupant(var/mob/user)
	if(user.a_intent != I_GRAB)
		return FALSE
	if(!do_after(user, 1 SECOND, src) || QDELETED(src))
		return TRUE
	if(!length(contents))
		to_chat(user, SPAN_WARNING("There is nothing inside \the [src]."))
		return TRUE
	var/atom/movable/AM = pick(contents)
	remove_from_den(AM)
	user.visible_message(SPAN_NOTICE("\The [user] reaches into \the [src] and pulls out \the [AM]!"))
	update_icon()
	return TRUE

/obj/structure/animal_den/proc/try_collapse_den(var/mob/user)
	if(user.a_intent != I_HURT)
		return FALSE
	// Humans can only get here via a shovel, so it's fine for them to be small.
	if(user.mob_size < MOB_MEDIUM && !ishuman(user))
		to_chat(user, SPAN_WARNING("You are too small to collapse \the [src]."))
		return TRUE
	if(!do_after(user, 5 SECONDS, src) || QDELETED(src))
		return TRUE
	if(length(contents))
		to_chat(user, SPAN_WARNING("You can't collapse \the [src]; it's occupied."))
	else
		to_chat(user, SPAN_NOTICE("You collapse \the [src]."))
		playsound(user, 'sound/weapons/thudswoosh.ogg', 50)
		qdel(src)
	return TRUE

/obj/structure/animal_den/attack_generic(mob/user, damage, attack_verb)
	// Animal interactions with their nests.
	if(istype(user, /mob/living/simple_mob/animal))
		if(try_collapse_den(user))
			return TRUE
		if(try_grab_occupant(user))
			return TRUE
		if(!do_after(user, 1 SECOND, src))
			return TRUE
		if(length(contents))
			to_chat(user, SPAN_WARNING("You can't hide in \the [src]; it's occupied."))
			return TRUE
		user.visible_message(SPAN_NOTICE("\The [user] disappears into \the [src]."))
		user.forceMove(src)
		update_icon()
		return TRUE
	return ..()

/mob/living/simple_mob/animal/proc/get_eye_color()
	return COLOR_WHITE

/obj/structure/animal_den/update_icon()
	cut_overlays()
	for(var/mob/living/simple_mob/animal/critter in contents)
		if(critter.stat == CONSCIOUS && !critter.resting)
			var/image/I = image(icon, "eyes[rand(1,3)]")
			I.color = critter.get_eye_color()
			I.pixel_x = rand(-3, 3)
			I.pixel_y = rand(-3, 3)
			add_overlay(I)

// Joinable den for critter spawns with ghost players.
/obj/structure/animal_den/ghost_join
	var/mob/living/critter
	var/ban_check = "Critter"

/obj/structure/animal_den/ghost_join/Initialize()
	. = ..()
	name = "den" // to remove mapping identifiers.
	if(ispath(critter))
		critter = new critter(src)

/obj/structure/animal_den/ghost_join/remove_from_den(var/atom/movable/AM)
	. = ..()
	if(critter == AM && critter.loc != src)
		if(critter.resting)
			critter.lay_down() // you woke them up :(
		critter = null

/obj/structure/animal_den/ghost_join/examine(mob/user, infix, suffix)
	var/list/output = ..()
	if(isobserver(user))
		if(critter)
			if(ban_check && ckey_is_jobbanned(user.ckey, ban_check))
				output += SPAN_WARNING("You are banned from [ban_check] roles and cannot join via this den.")
			else if(user.MayRespawn(TRUE))
				output += SPAN_NOTICE("<b>Click on the den to join as \a [critter].</b>")
		else
			output += SPAN_WARNING("This den is no longer available for joining.")
	return output

/obj/structure/animal_den/ghost_join/attack_ghost(mob/user)
	if(!critter)
		return ..()
	if(ban_check && ckey_is_jobbanned(user.ckey, ban_check))
		to_chat(user, SPAN_WARNING("You are banned from [ban_check] roles and cannot join via this den."))
		return
	transfer_personality(user)

/obj/structure/animal_den/ghost_join/proc/transfer_personality(var/mob/user)

	set waitfor = FALSE
	if(!critter)
		return

	// Transfer over mind and key.
	if(user.mind)
		user.mind.transfer_to(critter)
	critter.key = user.key

	var/mob/living/critter_ref = critter
	critter = null

	// Sleep long enough for the logged-in critter to update state and regen icon.
	sleep(SSmobs.wait)
	if(critter_ref.resting) // get up lazybones
		critter_ref.lay_down()
	update_icon()

	var/new_name = sanitize(input(critter_ref, "Would you like to customize your name?", "Critter Name", critter_ref.real_name), MAX_NAME_LEN)
	if(new_name && !QDELETED(critter_ref))
		critter_ref.real_name = new_name
		critter_ref.name = critter_ref.real_name
