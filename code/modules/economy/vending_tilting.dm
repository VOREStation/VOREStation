/**
 * Can this atom be curshed by the vending machine
 * Arguments
 *
 * * atom/atom_target - the atom we are checking for
*/
/proc/check_atom_crushable(atom/atom_target)
	var/static/list/vendor_uncrushable_objects = list(
		/obj/structure/bed/chair,
		/obj/machinery/conveyor,
		/obj/structure/table
	)

	if(is_type_in_list(atom_target, vendor_uncrushable_objects))
		return FALSE

	if(atom_target.uses_integrity && !(atom_target.invisibility > SEE_INVISIBLE_LIVING))
		return TRUE

	return FALSE

/**
 * Causes src to fall onto [target], crushing everything on it (including itself) with [damage]
 * and a small chance to do a spectacular effect per entity (if a chance above 0 is provided).
 *
 * Args:
 * * turf/target: The turf to fall onto. Cannot be null.
 * * damage: The raw numerical damage to do by default.
 * * chance_to_crit: The percent chance of a critical hit occurring. Default: 0
 * * forced_crit_case: If given a value from crushing.dm, [target] and its contents will always be hit with that specific critical hit. Default: null
 * * paralyze_time: The time, in deciseconds, a given mob/living will be paralyzed for if crushed.
 * * crush_dir: The direction the crush is coming from. Default: dir of src to [target].
 * * damage_type: The type of damage to do. Default: BRUTE
 * * damage_flag: The attack flag for armor purposes. Default: MELEE
 * * rotation: The angle of which to rotate src's transform by on a successful tilt. Default: 90.
 *
 * Returns: A collection of bitflags defined in crushing.dm. Read that file's documentation for info.
 */
/atom/movable/proc/fall_and_crush(turf/target, damage, chance_to_crit = 0, forced_crit_case = null, paralyze_time, crush_dir = get_dir(get_turf(src), target), damage_type = BRUTE, damage_flag = "melee", rotation = 90)

	ASSERT(!isnull(target))

	var/flags_to_return = NONE

	if(!is_blocked_turf(target, TRUE, src, list(src)))
		for(var/atom/atom_target in (target.contents) + target)
			if(isarea(atom_target))
				continue

			if(SEND_SIGNAL(atom_target, COMSIG_PRE_TILT_AND_CRUSH, src) & COMPONENT_IMMUNE_TO_TILT_AND_CRUSH)
				continue

			var/crit_case = forced_crit_case
			if(isnull(crit_case) && chance_to_crit > 0)
				if(prob(chance_to_crit))
					crit_case = pick_weight(get_crit_crush_chances())
			var/crit_rebate_mult = 1

			if(!isnull(crit_case))
				crit_rebate_mult = fall_and_crush_crit_rebate_table(crit_case)
				apply_crit_crush(crit_case, atom_target)

			var/adjusted_damage = damage * crit_rebate_mult
			var/crushed
			if(isliving(atom_target))
				crushed = TRUE
				var/mob/living/carbon/human/living_target = atom_target
				var/was_alive = living_target.stat != DEAD
				var/blocked = living_target.run_armor_check(attack_flag = damage_flag)
				if(iscarbon(living_target))
					var/mob/living/carbon/carbon_target = living_target
					if(prob(30))
						carbon_target.take_overall_damage(adjusted_damage)
					else
						var/brute = (damage_type == BRUTE ? damage : 0) * 0.5
						var/burn = (damage_type == BURN ? damage : 0) * 0.5
						carbon_target.apply_damage(brute, BRUTE, pick(BP_ALL))
						carbon_target.apply_damage(burn, BURN, pick(BP_ALL))
				else
					living_target.apply_damage(adjusted_damage, damage_type, blocked = blocked)

				living_target.Stun(paralyze_time)
				living_target.Weaken(paralyze_time*2)
				living_target.emote("scream")
				playsound(src, 'sound/effects/meteorimpact.ogg', 50, 1)
				post_crush_living(living_target, was_alive)
				flags_to_return |= (SUCCESSFULLY_CRUSHED_MOB|SUCCESSFULLY_CRUSHED_ATOM)

			else if(check_atom_crushable(atom_target))
				atom_target.take_damage(adjusted_damage, damage_type, damage_flag)
				crushed = TRUE
				flags_to_return |= SUCCESSFULLY_CRUSHED_ATOM

			if(crushed)
				atom_target.visible_message(span_danger("[atom_target] is crushed by [src]!"), span_userdanger("You are crushed by [src]!"))
				SEND_SIGNAL(atom_target, COMSIG_POST_TILT_AND_CRUSH, src)

		var/matrix/to_turn = turn(transform, rotation)
		animate(src, transform = to_turn, 0.2 SECONDS)
		playsound(src, 'sound/effects/bang.ogg', 40)

		visible_message(span_danger("[src] tips over, slamming hard onto [target]!"))
		flags_to_return |= SUCCESSFULLY_FELL_OVER
		post_tilt()
	else
		visible_message(span_danger("[src] rebounts comically as it fails to slam onto [target]!"))

	forceMove(target, crush_dir)
	return flags_to_return

/**
 * Returns a assoc list of (critcase -> num), where critcase is a critical define in crushing.dm and num is a weight.
 * Use with pickweight to acquire a random critcase.
 */
/atom/movable/proc/get_crit_crush_chances()
	RETURN_TYPE(/list)

	return list(
		CRUSH_CRIT_SHATTER_LEGS = 100,
		/*
		CRUSH_CRIT_PARAPLEGIC = 80,
		CRUSH_CRIT_HEADGIB = 20,
		*/
		CRUSH_CRIT_SQUISH_LIMB = 100
	)

/**
 * Exists for the purposes of custom behavior.
 * Called directly after [crushed] is crushed.
 *
 * Args:
 * * mob/living/crushed: The mob that was crushed.
 * * was_alive: Boolean. True if the mob was alive before the crushing.
 */
/atom/movable/proc/post_crush_living(mob/living/crushed, was_alive)
	return

/**
 * Exists for the purposes of custom behavior.
 * Called directly after src actually rotates and falls over.
 */
/atom/movable/proc/post_tilt()
	return

/**
 * Should be where critcase effects are actually implemented. Use this to apply critcases.
 * Args:
 * * crit_case: The chosen critcase, defined in crushing.dm.
 * * atom/atom_target: The target to apply the critical hit to. Cannot be null. Can be anything except /area.
 *
 * Returns:
 * TRUE if a crit case is successfully applied, FALSE otherwise.
 */
/atom/movable/proc/apply_crit_crush(crit_case, atom/atom_target)
	switch(crit_case)
		if(CRUSH_CRIT_SHATTER_LEGS)
			if(!ishuman(atom_target))
				return FALSE
			var/mob/living/carbon/human/human_target = atom_target
			var/obj/item/organ/external/left_leg = human_target.get_organ(BP_L_LEG)
			if(left_leg)
				left_leg.fracture()
			var/obj/item/organ/external/right_leg = human_target.get_organ(BP_R_LEG)
			if(right_leg)
				right_leg.fracture()
			if(left_leg || right_leg)
				human_target.visible_message(span_danger("[human_target]'s legs shatter with a sickening crunch!"), span_userdanger("Your legs shatter with a sickening crunch!"))
			return TRUE
		if(CRUSH_CRIT_SQUISH_LIMB)
			if(!ishuman(atom_target))
				return FALSE
			var/mob/living/carbon/human/human_target = atom_target
			for(var/obj/item/organ/external/squish_part in human_target.organs)
				squish_part.take_damage(15)
			human_target.visible_message(span_danger("[human_target]'s body is maimed underneath the mass of [src]!"), span_userdanger("Your body is maimed underneath the mass of [src]!"))
			return TRUE

	return FALSE

/**
 * Tilts ontop of the atom supplied, if crit is true some extra shit can happen. See [fall_and_crush] for return values.
 * Arguments:
 * fatty - atom to tilt the vendor onto
 * local_crit_chance - percent chance of a critical hit
 * forced_crit - specific critical hit case to use, if any
 * range - the range of the machine when thrown if not adjacent
*/
/obj/machinery/vending/proc/tilt(atom/fatty, local_crit_chance = crit_chance, forced_crit, range = 1)
	if(QDELETED(src))
		return

	. = NONE

	var/picked_rotation = pick(90, 270)
	if(Adjacent(fatty))
		. = fall_and_crush(get_turf(fatty), squish_damage, local_crit_chance, forced_crit, 4, rotation = picked_rotation)

		if(. & SUCCESSFULLY_FELL_OVER)
			visible_message(span_danger("[src] tips over!"))
			tilted = TRUE
			tilted_rotation = picked_rotation
			anchored = FALSE
			plane = ABOVE_MOB_PLANE

	if(get_turf(fatty) != get_turf(src))
		throw_at(get_turf(fatty), range, 1, FALSE)

/**
 * Allows damage to be reduced on certain crit cases.
 * Args:
 * * crit_case: The critical case chosen.
 */
/atom/movable/proc/fall_and_crush_crit_rebate_table(crit_case)
	ASSERT(!isnull(crit_case))

	switch(crit_case)
		if (CRUSH_CRIT_SHATTER_LEGS)
			return 0.2
		else
			return 1

/obj/machinery/vending/fall_and_crush_crit_rebate_table(crit_case)
	return crit_case == VENDOR_CRUSH_CRIT_GLASSCANDY ? 0.33 : ..()

/obj/machinery/vending/get_crit_crush_chances()
	return list(
		VENDOR_CRUSH_CRIT_GLASSCANDY = 100,
		VENDOR_CRUSH_CRIT_PIN = 100
	)

/obj/machinery/vending/apply_crit_crush(crit_case, atom_target)
	. = ..()
	if (.)
		return TRUE

	switch (crit_case)
		if(VENDOR_CRUSH_CRIT_GLASSCANDY)
			if (!ishuman(atom_target))
				return FALSE
			var/mob/living/carbon/human/human_target = atom_target
			for(var/i in 1 to 7)
				var/obj/item/material/shard/shard = new /obj/item/material/shard(get_turf(human_target))
				human_target.embed(shard, def_zone = pick(BP_ALL))
		if(VENDOR_CRUSH_CRIT_PIN)
			if(!isliving(atom_target))
				return FALSE
			var/mob/living/living_target = atom_target
			forceMove(get_turf(living_target))
			buckle_mob(living_target, TRUE)
			living_target.visible_message(span_danger("[living_target] is pinned underneath [src]!"), span_userdanger("You are pinned down by [src]!"))
			living_target.Weaken(20)
			return TRUE

	return FALSE

/**
 * Rights the vendor up, unpinning mobs under it, if any.
 * Arguments:
 * user - mob that has untilted the vendor
 */
/obj/machinery/vending/proc/untilt(mob/user)
	if(user)
		user.visible_message(span_notice("[user] rights [src]."), \
			span_notice("You right [src]."))

	unbuckle_all_mobs(TRUE)

	tilted = FALSE
	plane = initial(layer)

	var/matrix/to_turn = turn(transform, -tilted_rotation)
	animate(src, transform = to_turn, 0.2 SECONDS)
	tilted_rotation = 0
