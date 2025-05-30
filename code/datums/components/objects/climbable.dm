/datum/component/climbable
	VAR_PRIVATE/obj/owner
	VAR_PRIVATE/list/climbers
	VAR_PRIVATE/climb_delay = 3.5 SECONDS
	VAR_PRIVATE/climb_to_adjacent_turf = FALSE // for railings

/datum/component/climbable/Initialize()
	owner = parent
	RegisterSignal(owner, COMSIG_MOVABLE_START_CLIMB, PROC_REF(start_climb))
	RegisterSignal(owner, COMSIG_MOVABLE_SHAKE_CLIMBERS, PROC_REF(shaken))
	owner.verbs += /obj/proc/climb_on

/datum/component/climbable/Destroy(force = FALSE)
	UnregisterSignal(owner, COMSIG_MOVABLE_START_CLIMB)
	UnregisterSignal(owner, COMSIG_MOVABLE_SHAKE_CLIMBERS)
	owner.verbs -= /obj/proc/climb_on
	owner = null
	. = ..()

/// Sets if this climbable object will move you to the turf it faces if you are standing on the turf it's on. Used for railings.
/datum/component/climbable/proc/enable_vaulting()
	climb_to_adjacent_turf = TRUE

/// Sets the delay time for climbing the object
/datum/component/climbable/proc/set_climb_delay(var/time)
	climb_delay = time

/// Gets the currently set delay time to climb the object
/datum/component/climbable/proc/get_climb_delay()
	return climb_delay

/// Starts climbing the object
/datum/component/climbable/proc/start_climb(var/obj/caller, mob/user)
	SIGNAL_HANDLER
	var/mob/living/H = user
	if(istype(H) && can_climb(H))
		do_climb(user)

/// Check if the mob is in any condition to climb the object, if the destination is blocked, and how to climb it
/datum/component/climbable/proc/can_climb(var/mob/living/user, post_climb_check=0)
	if (!can_touch(user) || (!post_climb_check && (user in climbers)))
		return 0

	if (!user.Adjacent(owner))
		to_chat(user, span_danger("You can't climb there, the way is blocked."))
		return 0

	var/obj/occupied = turf_is_crowded()
	if(occupied)
		to_chat(user, span_danger("There's \a [occupied] in the way."))
		return 0

	// Railings are a bit snowflakey, but needed for when you climb from their turf to their facing turf!
	if(climb_to_adjacent_turf)
		if(get_turf(user) == get_turf(owner))
			occupied = neighbor_turf_impassable()
			if(occupied)
				to_chat(user, span_danger("You can't climb there, there's \a [occupied] in the way."))
				return 0
	return 1

/// Checks if something is blocking our climb destination, ignores other climbable objects
/datum/component/climbable/proc/turf_is_crowded()
	var/turf/T = get_turf(owner)
	if(!T || !istype(T))
		return "empty void"
	if(T.density)
		return T
	for(var/obj/O in T.contents)
		if(O && O.density && !(O.flags & ON_BORDER)) //ON_BORDER structures are handled by the Adjacent() check.
			if(O.GetComponent(/datum/component/climbable)) // We're climbable, allow it anyway
				continue
			return O
	return 0

/// Check if the destination turf for vaulting is blocked by something. Extremely similar to above.
/datum/component/climbable/proc/neighbor_turf_impassable()
	var/turf/T = get_step(owner, owner.dir)
	if(!T || !istype(T))
		return 0
	if(T.density == 1)
		return T
	for(var/obj/O in T.contents)
		if(O && O.density && !(O.flags & ON_BORDER && !(turn(O.dir, 180) & owner.dir)))
			if(O.GetComponent(/datum/component/climbable)) // We're climbable, allow it anyway
				continue
			return O
	return 0

/// Performs the wait and any remaining checks before the climb resolves.
/datum/component/climbable/proc/do_climb(var/mob/living/user)
	user.visible_message(span_warning("[user] starts climbing onto \the [owner]!"))
	LAZYDISTINCTADD(climbers, user)

	if(!do_after(user,(issmall(user) ? climb_delay * 0.6 : climb_delay)))
		LAZYREMOVE(climbers, user)
		return

	if (!can_climb(user, post_climb_check=1))
		LAZYREMOVE(climbers, user)
		return

	climb_to(user)

	if(get_turf(user) == get_turf(owner))
		user.visible_message(span_warning("[user] climbs onto \the [owner]!"))
	else
		user.visible_message(span_warning("[user] climbed over \the [owner]!"))
	LAZYREMOVE(climbers, user)

/// Resolve the climb by moving the mob to its final destination.
/datum/component/climbable/proc/climb_to(var/mob/living/user)
	if(climb_to_adjacent_turf && get_turf(user) == get_turf(owner))
		user.forceMove(get_step(owner, owner.dir))
	else
		user.forceMove(get_turf(owner))

/// Check if a mob is capable of climbing at all
/datum/component/climbable/proc/can_touch(var/mob/user)
	if (!user)
		return 0
	if(!owner.Adjacent(user))
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

/// Shakes an object, if anyone is climbing it, causes them to fall off it.
/datum/component/climbable/proc/shaken(var/obj/caller, var/mob/user)
	SIGNAL_HANDLER
	// You cannot shake yourself
	if(user) // Crates pass null on open because no user
		if(!LAZYLEN(climbers) || (user in climbers))
			return
		user.visible_message(span_warning("\The [user] shakes \the [owner]."), span_notice("You shake \the [owner]."))

	for(var/mob/living/M in climbers)
		M.Weaken(1)
		to_chat(M, span_danger("You topple as you are shaken off \the [owner]!"))
		climbers.Cut(1,2)

	for(var/mob/living/M in get_turf(owner))
		if(M.lying) //No spamming this on people.
			return

		M.Weaken(3)
		to_chat(M, span_danger("You topple as \the [owner] moves under you!"))

		if(prob(25))
			var/damage = rand(15,30)
			var/mob/living/carbon/human/H = M
			if(!istype(H))
				to_chat(H, span_danger("You land heavily!"))
				M.adjustBruteLoss(damage)
				return

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


// Cliff climbing requires climbing gear.
/datum/component/climbable/cliff/can_climb(var/mob/living/user, post_climb_check=0)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		var/obj/item/clothing/shoes/shoes = H.shoes
		if(shoes && shoes.rock_climbing)
			return ..() // Do the other checks too.

	to_chat(user, span_warning("\The [owner] is too steep to climb unassisted."))
	return FALSE

// Breaks if climbed while unanchored, railings.
/datum/component/climbable/unanchored_can_break/climb_to(var/mob/living/user)
	. = ..()
	if(!owner.anchored)
		owner.take_damage(9999) // Fatboy, was originally maxhealth, but that var doesn't exist on everything

// Table flipping is important!
/datum/component/climbable/table/climb_to(mob/living/mover)
	var/obj/structure/table/TBL = owner
	if(TBL.flipped == 1 && mover.loc == TBL.loc)
		var/turf/T = get_step(owner, TBL.dir)
		if(T.Enter(mover))
			return T
	return ..()


// Helper verb for objects
/obj/proc/climb_on()
	set name = "Climb structure"
	set desc = "Climbs onto a structure."
	set category = "Object"
	set src in oview(1)

	SEND_SIGNAL(src, COMSIG_MOVABLE_START_CLIMB, usr)
