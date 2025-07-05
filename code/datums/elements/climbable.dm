///Climbable element. Allows climbing an object using mousedrag or a verb
/datum/element/climbable
	element_flags = ELEMENT_DETACH_ON_HOST_DESTROY|ELEMENT_BESPOKE
	argument_hash_start_idx = 2

	VAR_PRIVATE/list/current_climbers
	VAR_PRIVATE/climb_delay = 3.5 SECONDS
	VAR_PRIVATE/climb_to_adjacent_turf = FALSE // for railings

/datum/element/climbable/Attach(obj/target, var/climb_delay = 3.5 SECONDS, var/vaulting = FALSE)
	. = ..()
	if(!isobj(target))
		return ELEMENT_INCOMPATIBLE

	src.climb_delay = climb_delay
	src.climb_to_adjacent_turf = vaulting

	RegisterSignal(target, COMSIG_CLIMBABLE_START_CLIMB, PROC_REF(start_climb))
	RegisterSignal(target, COMSIG_CLIMBABLE_SHAKE_CLIMBERS, PROC_REF(shaken))
	RegisterSignal(target, COMSIG_MOVABLE_MOVED, PROC_REF(move_shaken))
	RegisterSignal(target, COMSIG_PARENT_EXAMINE, PROC_REF(on_examine))
	target.verbs += /obj/proc/climb_on

	ADD_TRAIT(target, TRAIT_CLIMBABLE, ELEMENT_TRAIT(type))

/datum/element/climbable/Detach(obj/source)
	UnregisterSignal(source, COMSIG_CLIMBABLE_START_CLIMB)
	UnregisterSignal(source, COMSIG_CLIMBABLE_SHAKE_CLIMBERS)
	UnregisterSignal(source, COMSIG_MOVABLE_MOVED)
	UnregisterSignal(source, COMSIG_PARENT_EXAMINE)
	source.verbs -= /obj/proc/climb_on

	REMOVE_TRAIT(source, TRAIT_CLIMBABLE, ELEMENT_TRAIT(type))
	return ..()


/// Starts climbing the object
/datum/element/climbable/proc/start_climb(var/obj/climbed_thing, mob/user)
	SIGNAL_HANDLER
	var/mob/living/H = user
	if(istype(H) && can_climb(climbed_thing,H))
		addtimer(CALLBACK(src, PROC_REF(do_climb), climbed_thing, user, climb_delay), 0, TIMER_DELETE_ME) // Isolate from signal handler

/// Check if the mob is in any condition to climb the object, if the destination is blocked, and how to climb it
/datum/element/climbable/proc/can_climb(var/obj/climbed_thing, var/mob/living/user, post_climb_check=0)
	if(user.is_incorporeal()) // No! Bad shadekin!
		return FALSE

	var/list/climbers = LAZYACCESS(current_climbers, climbed_thing)
	if (!can_touch(climbed_thing, user) || (!post_climb_check && (user in climbers)))
		return FALSE

	if (!user.Adjacent(climbed_thing))
		to_chat(user, span_danger("You can't climb there, the way is blocked."))
		return FALSE

	var/obj/occupied = can_climb_turf(climbed_thing)
	if(occupied)
		to_chat(user, span_danger("There's \a [occupied] in the way."))
		return FALSE

	// Railings are a bit snowflakey, but needed for when you climb from their turf to their facing turf!
	if(climb_to_adjacent_turf)
		if(get_turf(user) == get_turf(climbed_thing))
			occupied = can_climb_neighbor_turf(climbed_thing)
			if(occupied)
				to_chat(user, span_danger("You can't climb there, there's \a [occupied] in the way."))
				return FALSE
	return TRUE

/// Performs the wait and any remaining checks before the climb resolves.
/datum/element/climbable/proc/do_climb(var/obj/climbed_thing, var/mob/living/user, var/delay_time)
	if(QDELETED(user) || QDELETED(climbed_thing))
		return

	user.visible_message(span_warning("[user] starts climbing onto \the [climbed_thing]!"))
	LAZYADDASSOCLIST(current_climbers, climbed_thing, user)

	if(do_after(user,(issmall(user) ? delay_time * 0.6 : delay_time)))
		if(can_climb(climbed_thing, user, post_climb_check=1))
			climb_to(climbed_thing, user)
			if(get_turf(user) == get_turf(climbed_thing))
				user.visible_message(span_warning("[user] climbs onto \the [climbed_thing]!"))
			else
				user.visible_message(span_warning("[user] climbed over \the [climbed_thing]!"))
		else
			to_chat(user, span_warning("You fail to climb onto \the [climbed_thing]."))
	LAZYREMOVEASSOC(current_climbers, climbed_thing, user)

/// Resolve the climb by moving the mob to its final destination.
/datum/element/climbable/proc/climb_to(var/obj/climbed_thing, var/mob/living/user)
	if(climb_to_adjacent_turf && get_turf(user) == get_turf(climbed_thing))
		user.forceMove(get_step(climbed_thing, climbed_thing.dir))
	else
		user.forceMove(get_turf(climbed_thing))

/// Check if a mob is capable of climbing at all
/datum/element/climbable/proc/can_touch(var/obj/climbed_thing, var/mob/user)
	if (!user)
		return 0
	if(!climbed_thing.Adjacent(user))
		return 0
	if (user.restrained() || user.buckled)
		to_chat(user, span_notice("You need your hands and legs free for this."))
		return 0
	if (user.stat || user.paralysis || user.sleeping || user.lying || user.weakened)
		return 0
	if (isAI(user))
		to_chat(user, span_notice("You need hands for this."))
		return 0
	return 1

/// Shakes an object, called from movement so it needs to be cleaned up a bit!
/datum/element/climbable/proc/move_shaken(obj/climbed_thing, atom/oldloc, direction, forced, list/old_locs, momentum_change)
	SIGNAL_HANDLER
	if(!forced) // Don't perform this if going up stairs
		shaken(climbed_thing, null)

/// Shakes an object, if anyone is climbing it, causes them to fall off it.
/datum/element/climbable/proc/shaken(var/obj/climbed_thing, var/mob/user)
	SIGNAL_HANDLER
	var/list/climbers = LAZYACCESS(current_climbers, climbed_thing)
	// You cannot shake yourself
	if(user) // Crates pass null on open because no user
		if(!LAZYLEN(climbers) || (user in climbers))
			return
		user.visible_message(span_warning("\The [user] shakes \the [climbed_thing]."), span_notice("You shake \the [climbed_thing]."))

	for(var/mob/living/M in climbers)
		M.Weaken(1)
		to_chat(M, span_danger("You topple as you are shaken off \the [climbed_thing]!"))
		climbers.Cut(1,2)

	for(var/mob/living/M in get_turf(climbed_thing))
		if(M.is_incorporeal())
			continue
		if(M.lying) //No spamming this on people.
			continue
		if(M.pulling == climbed_thing) // Pulling stuff up stairs can get weird
			continue

		M.Weaken(3)
		to_chat(M, span_danger("You topple as \the [climbed_thing] moves under you!"))

		if(prob(25))
			var/damage = rand(15,30)
			var/mob/living/carbon/human/H = M
			if(!istype(H))
				to_chat(H, span_danger("You land heavily!"))
				M.adjustBruteLoss(damage)
				continue

			var/obj/item/organ/external/affecting

			switch(pick(list("ankle","wrist","head","knee","elbow")))
				if("ankle")
					affecting = H.get_organ(pick(BP_L_FOOT, BP_R_FOOT))
				if("knee")
					affecting = H.get_organ(pick(BP_L_LEG, BP_R_LEG))
				if("wrist")
					affecting = H.get_organ(pick(BP_L_HAND, BP_R_HAND))
				if("elbow")
					affecting = H.get_organ(pick(BP_L_ARM, BP_R_ARM))
				if("head")
					affecting = H.get_organ(BP_HEAD)

			if(affecting)
				to_chat(M, span_danger("You land heavily on your [affecting.name]!"))
				affecting.take_damage(damage, 0)
				if(affecting.parent)
					affecting.parent.add_autopsy_data("Misadventure", damage)
			else
				to_chat(H, span_danger("You land heavily!"))
				H.adjustBruteLoss(damage)

			H.UpdateDamageIcon()
			H.updatehealth()

/datum/element/climbable/proc/on_examine(datum/source, mob/user, list/examine_texts)
	SIGNAL_HANDLER
	examine_texts += span_notice("It looks climbable.")

// Cliff climbing requires climbing gear.
/datum/element/climbable/cliff/do_climb(obj/climbed_thing, mob/living/user, delay_time)
	// Special snowflake handling, because north facing cliffs require half the time
	var/obj/structure/cliff/C = climbed_thing
	if(C.is_double_cliff)
		delay_time /= 2
	. = ..(climbed_thing, user, delay_time)

/datum/element/climbable/cliff/can_climb(var/obj/climbed_thing, var/mob/living/user, post_climb_check=0)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		var/obj/item/clothing/shoes/shoes = H.shoes
		if(shoes && shoes.rock_climbing)
			return ..() // Do the other checks too.

	to_chat(user, span_warning("\The [climbed_thing] is too steep to climb unassisted."))
	return FALSE


// Breaks if climbed while unanchored, railings.
/datum/element/climbable/unanchored_can_break/climb_to(var/obj/climbed_thing, var/mob/living/user)
	. = ..()
	if(!climbed_thing.anchored)
		climbed_thing.take_damage(9999) // Fatboy, was originally maxhealth, but that var doesn't exist on everything


// Table flipping is important!
/datum/element/climbable/table/climb_to(var/obj/climbed_thing, mob/living/mover)
	var/obj/structure/table/TBL = climbed_thing
	if(TBL.flipped == 1 && mover.loc == TBL.loc)
		var/turf/T = get_step(climbed_thing, TBL.dir)
		if(T.Enter(mover))
			return T
	return ..()



/// Verb for climbing objects, calls same signal as mouse drop
/obj/proc/climb_on()
	set name = "Climb structure"
	set desc = "Climbs onto a structure."
	set category = "Object"
	set src in oview(1)

	SEND_SIGNAL(src, COMSIG_CLIMBABLE_START_CLIMB, usr)

/// Checks if something is blocking our climb destination, ignores climbable objects
/proc/can_climb_turf(var/obj/climbed_thing)
	var/turf/T = get_turf(climbed_thing)
	if(!T || !istype(T))
		return "empty void"
	if(T.density)
		return T
	for(var/obj/O in T.contents)
		if(O && O.density && !(O.flags & ON_BORDER) && !HAS_TRAIT(O,TRAIT_CLIMBABLE)) //ON_BORDER structures are handled by the Adjacent() check.
			return O
	return 0

/// Check if the destination turf for vaulting is blocked by something. Extremely similar to above.
/proc/can_climb_neighbor_turf(var/obj/climbed_thing)
	var/turf/T = get_step(climbed_thing, climbed_thing.dir)
	if(!T || !istype(T))
		return 0
	if(T.density == 1)
		return T
	for(var/obj/O in T.contents)
		if(O && O.density && !(O.flags & ON_BORDER && !(turn(O.dir, 180) & climbed_thing.dir)) && !HAS_TRAIT(O,TRAIT_CLIMBABLE))
			return O
	return 0
