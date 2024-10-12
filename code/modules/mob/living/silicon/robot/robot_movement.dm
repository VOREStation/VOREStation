/mob/living/silicon/robot/get_jetpack()
	if(module)
		for(var/obj/item/tank/jetpack/J in module.modules)
			return J

/mob/living/silicon/robot/Check_Shoegrip()
	return module && module.no_slip

/mob/living/silicon/robot/Process_Spaceslipping(var/prob_slip)
	var/obj/item/tank/jetpack/thrust = get_jetpack()
	if(thrust?.can_thrust(0.01))
		return 0
	if(module && module.no_slip)
		return 0
	..(prob_slip)

/mob/living/silicon/robot/Process_Spacemove(var/check_drift = 0)
	if(..())//Can move due to other reasons, don't use jetpack fuel
		return 1

	var/obj/item/tank/jetpack/thrust = get_jetpack()
	if(thrust && (!check_drift || (check_drift && thrust.stabilization_on)) && thrust.do_thrust(0.01))
		inertia_dir = 0
		return 1

	return 0

 //No longer needed, but I'll leave it here incase we plan to re-use it.
/mob/living/silicon/robot/movement_delay()
	. = speed

	if(module_active && istype(module_active,/obj/item/borg/combat/mobility))
		. -= 2 // VOREStation Edit

	if(get_restraining_bolt())	// Borgs with Restraining Bolts move slower.
		. += 1

	. += config.robot_delay

	. += ..()

// NEW: Use power while moving.
/mob/living/silicon/robot/SelfMove(turf/n, direct, movetime)
	if (!is_component_functioning("actuator"))
		return 0

	var/datum/robot_component/actuator/A = get_component("actuator")
	if (cell_use_power(A.active_usage))
		return ..()

/mob/living/silicon/robot/Moved(atom/old_loc, direction, forced = FALSE)
	. = ..()

	if(!module)
		return

	//Borgs and drones can use their mining bags ~automagically~ if they're deployed in a slot. Only mining bags, as they're optimized for mass use.
	if(istype(module_state_1, /obj/item/storage/bag/ore) || istype(module_state_2, /obj/item/storage/bag/ore) || istype(module_state_3, /obj/item/storage/bag/ore))
		var/obj/item/storage/bag/ore/B = null
		if(istype(module_state_1, /obj/item/storage/bag/ore)) //First orebag has priority, if they for some reason have multiple.
			B = module_state_1
		else if(istype(module_state_2, /obj/item/storage/bag/ore))
			B = module_state_2
		else if(istype(module_state_3, /obj/item/storage/bag/ore))
			B = module_state_3
		var/turf/tile = loc
		if(isturf(tile))
			B.gather_all(tile, src, 1) //Shhh, unless the bag fills, don't spam the borg's chat with stuff that's going on every time they move!

	if(scrubbing && isturf(loc))
		var/turf/tile = loc
		tile.clean_blood()
		if (istype(tile, /turf/simulated))
			var/turf/simulated/S = tile
			S.dirt = 0
		for(var/A in tile)
			if(istype(A, /obj/effect))
				if(istype(A, /obj/effect/rune) || istype(A, /obj/effect/decal/cleanable) || istype(A, /obj/effect/overlay))
					qdel(A)
			else if(istype(A, /obj/item))
				var/obj/item/cleaned_item = A
				cleaned_item.clean_blood()
			else if(istype(A, /mob/living/carbon/human))
				var/mob/living/carbon/human/cleaned_human = A
				if(cleaned_human.lying)
					if(cleaned_human.head)
						cleaned_human.head.clean_blood()
						cleaned_human.update_inv_head(0)
					if(cleaned_human.wear_suit)
						cleaned_human.wear_suit.clean_blood()
						cleaned_human.update_inv_wear_suit(0)
					else if(cleaned_human.w_uniform)
						cleaned_human.w_uniform.clean_blood()
						cleaned_human.update_inv_w_uniform(0)
					if(cleaned_human.shoes)
						cleaned_human.shoes.clean_blood()
						cleaned_human.update_inv_shoes(0)
					cleaned_human.clean_blood(1)
					to_chat(cleaned_human, span_warning("[src] cleans your face!"))
