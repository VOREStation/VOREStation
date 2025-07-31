/obj/item/bork_medigun/linked
	var/obj/item/medigun_backpack/medigun_base_unit

/obj/item/bork_medigun/linked/Initialize(mapload, var/obj/item/medigun_backpack/backpack)
	. = ..()
	medigun_base_unit = backpack
	if(!medigun_base_unit.is_twohanded())
		icon_state = "medblaster_cmo"
		base_icon_state = "medblaster_cmo"
		wielded_item_state = ""
		update_icon()

/obj/item/bork_medigun/linked/Destroy()
	if(medigun_base_unit)
		//ensure the base unit's icon updates
		if(medigun_base_unit.medigun == src)
			medigun_base_unit.medigun = null
			medigun_base_unit.replace_icon()
			if(ismob(loc))
				var/mob/user = loc
				user.update_inv_back()
		medigun_base_unit = null
	return ..()

/obj/item/bork_medigun/linked/forceMove(atom/destination) //Forcemove override, ugh
	if(destination == medigun_base_unit || destination == medigun_base_unit.loc || isturf(destination))
		. = doMove(destination, 0, 0)
		if(isturf(destination))
			for(var/atom/A as anything in destination) // If we can't scan the turf, see if we can scan anything on it, to help with aiming.
				if(istype(A,/obj/structure/closet ))
					break
			if(ismob(medigun_base_unit.loc))
				var/mob/user = medigun_base_unit.loc
				medigun_base_unit.reattach_medigun(user)

/obj/item/bork_medigun/linked/dropped(mob/user)
	..() //update twohanding

	if(medigun_base_unit.containsgun == 0)
		//to_chat(user, span_warning("[loc]"))
		if(medigun_base_unit)

			//to_chat(user, span_warning("Dropped"))
			medigun_base_unit.reattach_medigun(user) //medigun attached to a base unit should never exist outside of their base unit or the mob equipping the base unit

/obj/item/bork_medigun/linked/proc/check_charge(var/charge_amt)
	return (medigun_base_unit.bcell && medigun_base_unit.bcell.check_charge(charge_amt))

/obj/item/bork_medigun/linked/proc/checked_use(var/charge_amt)
	return (medigun_base_unit.bcell && medigun_base_unit.bcell.checked_use(charge_amt))

/obj/item/bork_medigun/linked/attack_self(mob/living/user)
	if(medigun_base_unit.is_twohanded())
		update_twohanding()
	if(busy)
		busy = MEDIGUN_CANCELLED

/obj/item/bork_medigun/linked/proc/should_stop(var/mob/living/target, var/mob/living/user, var/active_hand)
	if(!target || !user || (!active_hand && medigun_base_unit.is_twohanded()) || !istype(target) || !istype(user) || busy < MEDIGUN_BUSY)
		return TRUE

	if((user.get_active_hand() != active_hand || wielded == 0) && medigun_base_unit.is_twohanded())
		to_chat(user, span_warning("Please keep your hands free!"))
		return TRUE

	if(user.incapacitated(INCAPACITATION_ALL))
		return TRUE

	if(user.stat)
		return TRUE

	if(target.isSynthetic())
		to_chat(user, span_warning("Target is not organic."))
		return TRUE

	//if(get_dist(user, target) > beam_range)
	if(!(target in range(beam_range, user)) || (!(target in view(10, user)) && !(medigun_base_unit.smodule.get_rating() >= 5)))
		to_chat(user, span_warning("You are too far away from \the [target] to heal them, Or they are not in view. Get closer."))
		return TRUE

	if(!isliving(target))
		//to_chat(user, span_warning("\the [target] is not a valid target."))
		return TRUE

	if(!ishuman(target))
		return TRUE

		/*if(!H.getBruteLoss() && !H.getFireLoss() && !H.getToxLoss())// && !H.getOxyLoss()) // No point Wasting fuel/power if target healed
			playsound(src, 'sound/machines/ping.ogg', 50)
			to_chat(user, span_warning("\the [target] is fully healed."))
			return TRUE
		*/
	return FALSE

/obj/item/bork_medigun/linked/afterattack(atom/target, mob/user, proximity_flag)
	// Things that invalidate the scan immediately.
	if(isturf(target))
		for(var/atom/A as anything in target) // If we can't scan the turf, see if we can scan anything on it, to help with aiming.
			if(isliving(A))
				target = A
				break
	if(!istype(medigun_base_unit, /obj/item/medigun_backpack/cmo))
		update_twohanding()
	if(busy && !(target == current_target) && isliving(target))
		to_chat(user, span_warning("\The [src] is already targeting something."))
		return

	if(!ishuman(target))
		return

	if(!medigun_base_unit.smanipulator)
		to_chat(user, span_warning("\The [src] Blinks a red error light, Manipulator missing."))
		return
	if(!medigun_base_unit.scapacitor)
		to_chat(user, span_warning("\The [src] Blinks a blue error light, capacitor missing."))
		return
	if(!medigun_base_unit.slaser)
		to_chat(user, span_warning("\The [src] Blinks an orange error light, laser missing."))
		return
	if(!medigun_base_unit.smodule)
		to_chat(user, span_warning("\The [src] Blinks a pink error light, scanning module missing."))
		return
	if(!check_charge(5))
		to_chat(user, span_warning("\The [src] doesn't have enough charge left to do that."))
		return
	if(get_dist(target, user) > beam_range)
		to_chat(user, span_warning("You are too far away from \the [target] to affect it. Get closer."))
		return

	if(target == current_target && busy)
		busy = MEDIGUN_CANCELLED
		return
	if(target == user)
		to_chat(user, span_warning("Cant heal yourself."))
		return
	if(!(target in range(beam_range, user)) || (!(target in view(10, user)) && !medigun_base_unit.smodule))
		to_chat(user, span_warning("You are too far away from \the [target] to heal them, Or they are not in view. Get closer."))
		return

	current_target = target
	busy = MEDIGUN_BUSY
	update_icon()
	var/myicon = "medbeam_basic"
	var/mycolor = "#037ffc"
	var/datum/beam/scan_beam = user.Beam(target, icon = 'icons/obj/borkmedigun.dmi', icon_state = myicon, time = 6000)
	var/filter = filter(type = "outline", size = 1, color = mycolor)
	var/list/box_segments = list()
	playsound(src, 'sound/weapons/wave.ogg', 50)
	var/mob/living/carbon/human/H = target
	to_chat(user, span_notice("Locking on to [H]"))
	to_chat(H, span_warning("[user] is targetting you with their medigun"))
	if(user.client)
		box_segments = draw_box(target, beam_range, user.client)
		color_box(box_segments, mycolor, 5)
	process_medigun(H, user, filter)

	action_cancelled = FALSE
	busy = MEDIGUN_IDLE
	current_target = null

	// Now clean up the effects.
	update_icon()
	QDEL_NULL(scan_beam)
	target.filters -= filter
	if(user.client) // If for some reason they logged out mid-scan the box will be gone anyways.
		delete_box(box_segments, user.client)

/obj/item/bork_medigun/linked/proc/process_medigun(mob/living/carbon/human/H, mob/user, filter, ishealing = FALSE)
	if(should_stop(H, user, user.get_active_hand()))
		return

	if(do_after(user, 10, ignore_movement = TRUE, needhand = medigun_base_unit.is_twohanded()))
		var/washealing = ishealing // Did we heal last cycle
		ishealing = FALSE // The default is 'we didn't heal this cycle'
		if(!checked_use(5))
			to_chat(user, span_warning("\The [src] doesn't have enough charge left to do that."))
			return
		if(H.stat == DEAD)
			process_medigun(H, user, filter)
			return
		var/lastier = medigun_base_unit.slaser.get_rating()
		//if(lastier >= 5)
		H.add_modifier(/datum/modifier/medbeameffect, 2 SECONDS)

		var/healmod = lastier
		/*if(H.getBruteLoss())
			healmod = min(lastier,medigun_base_unit.brutecharge,H.getBruteLoss())
			if(medigun_base_unit.brutecharge >= healmod)
				if(!checked_use(healmod))
					to_chat(user, span_warning("\The [src] doesn't have enough charge left to do that."))
					break
				if(healmod < 0)
					healmod = 0
				else
					H.adjustBruteLoss(-healmod)
					medigun_base_unit.brutecharge -= healmod
					ishealing = 1
		if(H.getFireLoss())
			healmod = min(lastier,medigun_base_unit.burncharge,H.getFireLoss())
			if(medigun_base_unit.burncharge >= healmod)
				if(!checked_use(healmod))
					to_chat(user, span_warning("\The [src] doesn't have enough charge left to do that."))
					break
				if(healmod < 0)
					healmod = 0
				else
					H.adjustFireLoss(-healmod)
					medigun_base_unit.burncharge -= healmod
					ishealing = 1*/
		if(H.getToxLoss())
			healmod = min(lastier,medigun_base_unit.toxcharge,H.getToxLoss())
			if(medigun_base_unit.toxcharge >= healmod)
				if(!checked_use(healmod))
					to_chat(user, span_warning("\The [src] doesn't have enough charge left to do that."))
					return
				if(healmod < 0)
					healmod = 0
				else
					H.adjustToxLoss(-healmod)
					medigun_base_unit.toxcharge -= healmod
					ishealing = TRUE
		if(H.getOxyLoss())
			healmod = min(10*lastier,H.getOxyLoss())
			if(!checked_use(min(10,healmod)))
				to_chat(user, span_warning("\The [src] doesn't have enough charge left to do that."))
				return
			H.adjustOxyLoss(-healmod)
			ishealing = TRUE

		ishealing = process_wounds(H, lastier, lastier, ishealing)
		//if(medigun_base_unit.brutecharge <= 0 || medigun_base_unit.burncharge <= 0 || medigun_base_unit.toxcharge <= 0)
		medigun_base_unit.update_icon()
		//if(medigun_base_unit.slaser.get_rating() >= 5)

	//Blood regeneration if there is some space
		if(lastier >= 5)
			if(H.vessel.get_reagent_amount("blood") < H.species.blood_volume)
				var/datum/reagent/blood/B = locate() in H.vessel.reagent_list //Grab some blood
				B.volume += min(5, (H.species.blood_volume - H.vessel.get_reagent_amount("blood")))// regenerate blood

		if(ishealing != washealing) // Either we stopped or started healing this cycle
			if(ishealing)
				H.filters += filter
			else
				H.filters -= filter

		process_medigun(H, user, filter, ishealing)

/obj/item/bork_medigun/linked/proc/process_wounds(mob/living/carbon/human/H, heal_ticks, remaining_strength, ishealing)
	while(heal_ticks > 0)
		if(remaining_strength <= 0)
			return ishealing
		if((!H.getFireLoss() || medigun_base_unit.burncharge <= 0) && (!H.getBruteLoss() || medigun_base_unit.burncharge <= 0))
			return ishealing

		for(var/name in BP_ALL)
			var/obj/item/organ/external/O = H.organs_by_name[name]
			for(var/datum/wound/W in O.wounds)
				if (W.internal)
					continue
				//if (W.bandaged && W.disinfected)
				//	continue
				if (W.damage_type == BRUISE || W.damage_type == CUT || W.damage_type == PIERCE)
					if(medigun_base_unit.brutecharge >= 1)
						if(W.damage <= 1)
							O.wounds -= W
							medigun_base_unit.brutecharge -= 1
							ishealing = TRUE
						else if(medigun_base_unit.brutecharge >= 1)
							W.damage -= 1
							medigun_base_unit.brutecharge -= 1
							remaining_strength -= 1
							ishealing = TRUE
				if (W.damage_type == BURN)
					if(medigun_base_unit.burncharge >= 1)
						if(W.damage <= 1)
							O.wounds -= W
							medigun_base_unit.burncharge -= 1
							ishealing = TRUE
						else if(medigun_base_unit.burncharge >= 1)
							W.damage -= 1
							medigun_base_unit.burncharge -= 1
							remaining_strength -= 1
							ishealing = TRUE
				if(remaining_strength <= 0)
					return ishealing
			if(remaining_strength <= 0)
				return ishealing
		heal_ticks--
	return ishealing
