/obj/structure/bed/chair/wheelchair
	name = "wheelchair"
	desc = "You sit in this. Either by will or force."
	icon = 'icons/obj/wheelchair.dmi'
	icon_state = "wheelchair"
	anchored = FALSE
	buckle_movable = 1

	var/folded_type = /obj/item/wheelchair
	var/driving = 0
	var/mob/living/pulling = null
	var/bloodiness
	var/min_mob_buckle_size = MOB_SMALL
	var/max_mob_buckle_size = MOB_LARGE

/obj/structure/bed/chair/wheelchair/Initialize(mapload, var/new_material, var/new_padding_material)
	. = ..()
	update_icon()

/obj/structure/bed/chair/wheelchair/motor
	name = "electric wheelchair"
	desc = "A motorized wheelchair controlled with a joystick on one armrest"
	icon_state = "motorchair"
	folded_type = /obj/item/wheelchair/motor

/obj/structure/bed/chair/wheelchair/smallmotor
	name = "small electric wheelchair"
	desc = "A small motorized wheelchair, it looks around the right size for a Teshari"
	icon_state = "teshchair"
	min_mob_buckle_size = MOB_SMALL
	max_mob_buckle_size = MOB_MEDIUM
	folded_type = /obj/item/wheelchair/motor/small

/obj/structure/bed/chair/wheelchair/can_buckle_check(mob/living/M, forced = FALSE)
	. = ..()
	if(.)
		if(M.mob_size < min_mob_buckle_size)
			to_chat(M, span_warning("You are too small to use \the [src]."))
			. = FALSE
		else if(M.mob_size >= max_mob_buckle_size)
			to_chat(M, span_warning("You are too large to use \the [src]."))
			. = FALSE

/obj/structure/bed/chair/wheelchair/update_icon()
	cut_overlays()
	var/image/O = image(icon = icon, icon_state = "[icon_state]_overlay", layer = ABOVE_MOB_LAYER)
	O.plane = MOB_PLANE
	add_overlay(O)

/obj/structure/bed/chair/wheelchair/set_dir()
	. = ..()
	if(.)
		if(has_buckled_mobs())
			for(var/mob/living/L as anything in buckled_mobs)
				L.set_dir(dir)

/obj/structure/bed/chair/wheelchair/attackby(obj/item/W as obj, mob/user as mob)
	if(W.has_tool_quality(TOOL_WRENCH) || W.has_tool_quality(TOOL_WIRECUTTER) || istype(W,/obj/item/stack))
		return
	..()

/obj/structure/bed/chair/wheelchair/relaymove(mob/user, direction)
	// Redundant check?
	if(user.stat || user.stunned || user.weakened || user.paralysis || user.lying || user.restrained())
		if(user==pulling)
			pulling = null
			user.pulledby = null
			to_chat(user, span_warning("You lost your grip!"))
		return
	if(has_buckled_mobs() && pulling && (user in buckled_mobs))
		if(pulling.stat || pulling.stunned || pulling.weakened || pulling.paralysis || pulling.lying || pulling.restrained())
			pulling.pulledby = null
			pulling = null
	if(user.pulling && (user == pulling))
		pulling = null
		user.pulledby = null
		return
	if(propelled)
		return
	if(pulling && (get_dist(src, pulling) > 1))
		pulling = null
		user.pulledby = null
		if(user==pulling)
			return
	if(pulling && (get_dir(src.loc, pulling.loc) == direction))
		to_chat(user, span_warning("You cannot go there."))
		return
	if(pulling && has_buckled_mobs() && (user in buckled_mobs))
		to_chat(user, span_warning("You cannot drive while being pushed."))
		return

	// Let's roll
	driving = 1
	var/turf/T = null
	//--1---Move occupant---1--//
	if(has_buckled_mobs())
		for(var/mob/living/L as anything in buckled_mobs)
			L.buckled = null
			step(L, direction)
			L.buckled = src
	//--2----Move driver----2--//
	if(pulling)
		T = pulling.loc
		if(get_dist(src, pulling) >= 1)
			step(pulling, get_dir(pulling.loc, src.loc))
	//--3--Move wheelchair--3--//
	step(src, direction)
	if(has_buckled_mobs()) // Make sure it stays beneath the occupant
		var/mob/living/L = buckled_mobs[1]
		Move(L.loc)
	set_dir(direction)
	if(pulling) // Driver
		if(pulling.loc == src.loc) // We moved onto the wheelchair? Revert!
			pulling.forceMove(T)
		else
			spawn(0)
			if(get_dist(src, pulling) > 1) // We are too far away? Losing control.
				pulling = null
				user.pulledby = null
			pulling.set_dir(get_dir(pulling, src)) // When everything is right, face the wheelchair
	if(bloodiness)
		create_track()
	driving = 0

/obj/structure/bed/chair/wheelchair/Moved(atom/old_loc, direction, forced = FALSE)
	. = ..()
	playsound(src, 'sound/effects/roll.ogg', 75, 1)
	if(has_buckled_mobs())
		for(var/mob/living/occupant as anything in buckled_mobs)
			if(!driving)
				occupant.buckled = null
				occupant.Move(src.loc)
				occupant.buckled = src
				if (occupant && (src.loc != occupant.loc))
					if (propelled)
						for (var/mob/O in src.loc)
							if (O != occupant)
								Bump(O)
					else
						unbuckle_mob()
				if (pulling && (get_dist(src, pulling) > 1))
					pulling.pulledby = null
					to_chat(pulling, span_warning("You lost your grip!"))
					pulling = null
			else
				if (occupant && (src.loc != occupant.loc))
					src.forceMove(occupant.loc) // Failsafe to make sure the wheelchair stays beneath the occupant after driving

/obj/structure/bed/chair/wheelchair/attack_hand(mob/living/user as mob)
	if (pulling)
		MouseDrop(user)
	else
		if(has_buckled_mobs())
			for(var/A in buckled_mobs)
				user_unbuckle_mob(A, user)
	return

/obj/structure/bed/chair/wheelchair/CtrlClick(var/mob/user)
	if(in_range(src, user))
		if(!ishuman(user))	return
		if(has_buckled_mobs() && (user in buckled_mobs))
			to_chat(user, span_warning("You realize you are unable to push the wheelchair you sit in."))
			return
		if(!pulling)
			pulling = user
			user.pulledby = src
			if(user.pulling)
				user.stop_pulling()
			user.set_dir(get_dir(user, src))
			to_chat(user, "You grip \the [name]'s handles.")
		else
			to_chat(user, "You let go of \the [name]'s handles.")
			pulling.pulledby = null
			pulling = null
		return

/obj/structure/bed/chair/wheelchair/Bump(atom/A)
	..()
	if(!has_buckled_mobs())	return

	if(propelled || (pulling && (pulling.a_intent == I_HURT)))
		var/mob/living/occupant = unbuckle_mob()

		if (pulling && (pulling.a_intent == I_HURT))
			occupant.throw_at(A, 3, 3, pulling)
		else if (propelled)
			occupant.throw_at(A, 3, propelled)

		var/def_zone = ran_zone()
		var/blocked = occupant.run_armor_check(def_zone, "melee")
		var/soaked = occupant.get_armor_soak(def_zone, "melee")
		occupant.throw_at(A, 3, propelled)
		occupant.apply_effect(6, STUN, blocked)
		occupant.apply_effect(6, WEAKEN, blocked)
		occupant.apply_effect(6, STUTTER, blocked)
		occupant.apply_damage(10, BRUTE, def_zone, soaked)
		playsound(src, 'sound/weapons/punch1.ogg', 50, 1, -1)
		if(isliving(A))
			var/mob/living/victim = A
			def_zone = ran_zone()
			blocked = victim.run_armor_check(def_zone, "melee")
			soaked = victim.get_armor_soak(def_zone, "melee")
			victim.apply_effect(6, STUN, blocked)
			victim.apply_effect(6, WEAKEN, blocked)
			victim.apply_effect(6, STUTTER, blocked)
			victim.apply_damage(10, BRUTE, def_zone, soaked)
		if(pulling)
			occupant.visible_message(span_danger("[pulling] has thrusted \the [name] into \the [A], throwing \the [occupant] out of it!"))

			add_attack_logs(pulling,occupant,"Crashed their [name] into [A]")
		else
			occupant.visible_message(span_danger("[occupant] crashed into \the [A]!"))

/obj/structure/bed/chair/wheelchair/proc/create_track()
	var/obj/effect/decal/cleanable/blood/tracks/B = new(loc)
	var/newdir = get_dir(get_step(loc, dir), loc)
	if(newdir == dir)
		B.set_dir(newdir)
	else
		newdir = newdir | dir
		if(newdir == 3)
			newdir = 1
		else if(newdir == 12)
			newdir = 4
		B.set_dir(newdir)
	bloodiness--

/obj/structure/bed/chair/wheelchair/buckle_mob(mob/M as mob, mob/user as mob)
	if(M == pulling)
		pulling = null
		user.pulledby = null
	..()

/obj/structure/bed/chair/wheelchair/MouseDrop(over_object, src_location, over_location)
	..()
	if((over_object == usr && (in_range(src, usr) || usr.contents.Find(src))))
		if(!ishuman(usr))	return
		if(has_buckled_mobs())	return 0
		visible_message("[usr] collapses \the [src.name].")
		var/obj/item/wheelchair/R = new folded_type(get_turf(src))
		R.name = src.name
		R.color = src.color
		spawn(0)
			qdel(src)
		return
