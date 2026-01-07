/datum/element/spontaneous_vore

/datum/element/spontaneous_vore/Attach(datum/target)
	. = ..()
	if(!isliving(target))
		return ELEMENT_INCOMPATIBLE
	RegisterSignal(target, COMSIG_LIVING_STUMBLED_INTO, PROC_REF(handle_stumble))
	RegisterSignal(target, COMSIG_LIVING_FALLING_DOWN, PROC_REF(handle_fall))
	RegisterSignal(target, COMSIG_LIVING_HIT_BY_THROWN_ENTITY, PROC_REF(handle_hitby))
	RegisterSignal(target, COMSIG_MOVABLE_CROSS, PROC_REF(handle_crossed))

/datum/element/spontaneous_vore/Detach(datum/target)
	. = ..()
	UnregisterSignal(target, list(COMSIG_LIVING_STUMBLED_INTO, COMSIG_LIVING_FALLING_DOWN, COMSIG_LIVING_HIT_BY_THROWN_ENTITY, COMSIG_MOVABLE_CROSS))

///Source is the one being bumped into (Owner of this component)
///Target is the one bumping into us.
/datum/element/spontaneous_vore/proc/handle_stumble(mob/living/source, mob/living/target)
	SIGNAL_HANDLER

	//Prevents slipping into ourselves if we have a blobform.
	if(!isturf(target.loc) || !isturf(source.loc)) //No slipping into things that aren't even on a valid turf.
		return
	//Prevents eating ourselves with our own stomach.
	if(source.vore_selected == target.vore_selected)
		return

	//We are able to eat the person stumbling into us.
	if(can_stumble_vore(prey = target, pred = source)) //This is if the person stumbling into us is able to eat us!
		source.visible_message(span_vwarning("[target] flops carelessly into [source]!"))
		var/obj/belly/destination_belly = source.get_current_spont_belly(target)
		source.begin_instant_nom(source, prey = target, pred = source, belly = destination_belly)
		target.stop_flying()
		return CANCEL_STUMBLED_INTO

	//The person stumbling into us is able to eat us.
	if(can_stumble_vore(prey = source, pred = target)) //This is if the person stumbling into us is able to be eaten by us! BROKEN!
		source.visible_message(span_vwarning("[target] flops carelessly into [source]!"))
		target.forceMove(get_turf(source))
		var/obj/belly/destination_belly = target.get_current_spont_belly(source)
		source.begin_instant_nom(target, prey = source, pred = target, belly = destination_belly)
		source.stop_flying()
		return CANCEL_STUMBLED_INTO

//Source is the one dropping (us)
//Landing is the tile we're falling onto
//drop_mob is whatever mob is found in the turf we're dropping onto.
/datum/element/spontaneous_vore/proc/handle_fall(mob/living/source, turf/landing, mob/living/drop_mob)
	SIGNAL_HANDLER

	if(!drop_mob || drop_mob == source)
		return

	//pred = drop_mob
	//prey = source
	//result: source is eaten by drop_mob
	if(can_drop_vore(prey = source, pred = drop_mob))
		drop_mob.feed_grabbed_to_self_falling_nom(drop_mob, prey = source)
		drop_mob.visible_message(span_vdanger("\The [drop_mob] falls right onto \the [source]!"))
		return COMSIG_CANCEL_FALL

	//pred = source
	//prey = drop_mob
	//result: drop_mob is eaten by source
	if(can_drop_vore(prey = drop_mob, pred = source))
		source.feed_grabbed_to_self_falling_nom(source, prey = drop_mob)
		source.Weaken(4)
		source.visible_message(span_vdanger("\The [drop_mob] falls right into \the [source]!"))
		return COMSIG_CANCEL_FALL

/datum/element/spontaneous_vore/proc/handle_hitby(mob/living/source, atom/movable/hitby, mob/thrower, speed)
	SIGNAL_HANDLER

	//Handle object throw vore
	if(isitem(hitby))
		var/obj/item/O = hitby
		var/obj/belly/destination_belly = source.get_current_spont_belly(O)
		if(!destination_belly)
			return
		if(source.stat != DEAD && source.trash_catching)
			if(source.adminbus_trash || is_type_in_list(O, GLOB.edible_trash) && O.trash_eatable && !is_type_in_list(O, GLOB.item_vore_blacklist))
				source.visible_message(span_vwarning("[O] is thrown directly into [source]'s [lowertext(destination_belly.name)]!"))
				destination_belly.nom_atom(O)
				return COMSIG_CANCEL_HITBY

	//Throwing a prey into a pred takes priority. After that it checks to see if the person being thrown is a pred.
	if(isliving(hitby))
		var/mob/living/thrown_mob = hitby

		//If we don't allow mobvore and the thrown mob is an NPC animal, stop here.
		if(!source.allowmobvore && isanimal(thrown_mob) && !thrown_mob.ckey)
			return

		//If we're an NPC animal and the person thrown into us doesn't allow mobvore, stop here.
		if(!thrown_mob.allowmobvore && isanimal(source) && !source.ckey)
			return

		// PERSON BEING HIT: CAN BE DROP PRED, ALLOWS THROW VORE.
		// PERSON BEING THROWN: DEVOURABLE, ALLOWS THROW VORE, CAN BE DROP PREY.
		if(can_throw_vore(prey = thrown_mob, pred = source))
			var/obj/belly/destination_belly = source.get_current_spont_belly(thrown_mob)
			if(!destination_belly)
				return
			destination_belly.nom_atom(thrown_mob) //Eat them!!!
			source.visible_message(span_vwarning("[thrown_mob] is thrown right into [source]'s [lowertext(destination_belly.name)]!"))
			source.on_throw_vore_special(TRUE, thrown_mob)

			if(thrower)
				add_attack_logs(thrower,source,"Devoured [thrown_mob.name] via throw vore.")
			else
				log_vore("[source] devoured [thrown_mob.name] via throw vore.")
			return COMSIG_CANCEL_HITBY //We can stop here. We don't need to calculate damage or anything else. They're eaten.

		// PERSON BEING HIT: CAN BE DROP PREY, ALLOWS THROW VORE, AND IS DEVOURABLE.
		// PERSON BEING THROWN: CAN BE DROP PRED, ALLOWS THROW VORE.
		else if(can_throw_vore(prey = source, pred = thrown_mob))//Pred thrown into prey.
			var/obj/belly/destination_belly = thrown_mob.get_current_spont_belly(source)
			if(!destination_belly)
				return
			source.visible_message(span_vwarning("[source] suddenly slips inside of [thrown_mob]'s [lowertext(destination_belly.name)] as [thrown_mob] flies into them!"))
			destination_belly.nom_atom(source) //Eat them!!!
			if(source.loc != thrown_mob.vore_selected)
				source.forceMove(thrown_mob.vore_selected) //Double check. Should never happen but...Weirder things have happened!
			if(thrower)
				add_attack_logs(thrower,source,"Was Devoured by [thrown_mob.name] via throw vore.")
			else
				log_vore("[source] Was Devoured by [thrown_mob.name] via throw vore.")
			return COMSIG_CANCEL_HITBY

//source = person standing up
//crossed = person sliding
/datum/element/spontaneous_vore/proc/handle_crossed(mob/living/source, mob/living/crossed)
	SIGNAL_HANDLER

	if(source == crossed || !istype(crossed))
		return


	//Person being slipped into eats the person slipping
	if(can_slip_vore(pred = source, prey = crossed))	//If we can vore them go for it
		var/obj/belly/destination_belly = source.get_current_spont_belly(crossed)
		if(!destination_belly)
			return
		source.begin_instant_nom(source, prey = crossed, pred = source, belly = destination_belly)
		return COMPONENT_BLOCK_CROSS

	//The person slipping eats the person being slipped into
	else if(can_slip_vore(pred = crossed, prey = source))
		var/obj/belly/destination_belly = crossed.get_current_spont_belly(source)
		if(!destination_belly)
			return
		source.begin_instant_nom(crossed, prey = source, pred = crossed, belly = destination_belly) //Must be
		return //We DON'T block it here. Pred can slip onto the prey's tile, no problem.
