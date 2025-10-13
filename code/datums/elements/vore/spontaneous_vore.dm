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
	if(CanStumbleVore(prey = target, pred = source)) //This is if the person stumbling into us is able to eat us!
		source.visible_message(span_vwarning("[target] flops carelessly into [source]!"))
		source.begin_instant_nom(source, prey = target, pred = source, belly = source.vore_selected)
		target.stop_flying()
		return CANCEL_STUMBLED_INTO

	//The person stumbling into us is able to eat us.
	if(CanStumbleVore(prey = source, pred = target)) //This is if the person stumbling into us is able to be eaten by us! BROKEN!
		source.visible_message(span_vwarning("[target] flops carelessly into [source]!"))
		target.forceMove(get_turf(source))
		source.begin_instant_nom(target, prey = source, pred = target, belly = target.vore_selected)
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
	if(CanDropVore(prey = source, pred = drop_mob))
		drop_mob.feed_grabbed_to_self_falling_nom(drop_mob, prey = source)
		drop_mob.visible_message(span_vdanger("\The [drop_mob] falls right onto \the [source]!"))
		return COMSIG_CANCEL_FALL

	//pred = source
	//prey = drop_mob
	//result: drop_mob is eaten by source
	if(CanDropVore(prey = drop_mob, pred = source))
		source.feed_grabbed_to_self_falling_nom(source, prey = drop_mob)
		source.Weaken(4)
		source.visible_message(span_vdanger("\The [drop_mob] falls right into \the [source]!"))
		return COMSIG_CANCEL_FALL

/datum/element/spontaneous_vore/proc/handle_hitby(mob/living/source, atom/movable/hitby, speed)
	SIGNAL_HANDLER

	//Handle object throw vore
	if(isitem(hitby))
		var/obj/item/O = hitby
		if(source.stat != DEAD && source.trash_catching && source.vore_selected)
			if(source.adminbus_trash || is_type_in_list(O, GLOB.edible_trash) && O.trash_eatable && !is_type_in_list(O, GLOB.item_vore_blacklist))
				source.visible_message(span_vwarning("[O] is thrown directly into [source]'s [lowertext(source.vore_selected.name)]!"))
				O.throwing = 0
				O.forceMove(source.vore_selected)
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
		if(CanThrowVore(prey = thrown_mob, pred = source))
			if(!source.vore_selected)
				return
			source.vore_selected.nom_mob(thrown_mob) //Eat them!!!
			source.visible_message(span_vwarning("[thrown_mob] is thrown right into [source]'s [lowertext(source.vore_selected.name)]!"))
			if(thrown_mob.loc != source.vore_selected)
				thrown_mob.forceMove(source.vore_selected) //Double check. Should never happen but...Weirder things have happened!
			source.on_throw_vore_special(TRUE, thrown_mob)
			add_attack_logs(thrown_mob.thrower,source,"Devoured [thrown_mob.name] via throw vore.")
			return //We can stop here. We don't need to calculate damage or anything else. They're eaten.

		// PERSON BEING HIT: CAN BE DROP PREY, ALLOWS THROW VORE, AND IS DEVOURABLE.
		// PERSON BEING THROWN: CAN BE DROP PRED, ALLOWS THROW VORE.
		else if(CanThrowVore(prey = source, pred = thrown_mob))//Pred thrown into prey.
			if(!thrown_mob.vore_selected)
				return
			source.visible_message(span_vwarning("[source] suddenly slips inside of [thrown_mob]'s [lowertext(thrown_mob.vore_selected.name)] as [thrown_mob] flies into them!"))
			thrown_mob.vore_selected.nom_mob(source) //Eat them!!!
			if(source.loc != thrown_mob.vore_selected)
				source.forceMove(thrown_mob.vore_selected) //Double check. Should never happen but...Weirder things have happened!
			add_attack_logs(thrown_mob.LAssailant,source,"Was Devoured by [thrown_mob.name] via throw vore.")
			return

//source = person standing up
//crossed = person sliding
/datum/element/spontaneous_vore/proc/handle_crossed(mob/living/source, mob/living/crossed)
	SIGNAL_HANDLER

	if(source == crossed || !istype(crossed))
		return

	//Person being slipped into eats the person slipping
	if(can_slip_vore(pred = source, prey = crossed))	//If we can vore them go for it
		source.begin_instant_nom(source, prey = crossed, pred = source, belly = source.vore_selected)
		return COMPONENT_BLOCK_CROSS

	//The person slipping eats the person being slipped into
	else if(can_slip_vore(pred = crossed, prey = source))
		source.begin_instant_nom(crossed, prey = source, pred = crossed, belly = crossed.vore_selected) //Must be
		return //We DON'T block it here. Pred can slip onto the prey's tile, no problem.


///Helper Procs
/proc/CanStumbleVore(mob/living/prey, mob/living/pred)
	if(!can_spontaneous_vore(pred, prey))
		return FALSE
	if(!prey.stumble_vore || !pred.stumble_vore)
		return FALSE
	return TRUE

/proc/CanDropVore(mob/living/prey, mob/living/pred)
	if(!can_spontaneous_vore(pred, prey))
		return FALSE
	if(!pred.drop_vore || !prey.drop_vore)
		return FALSE
	return TRUE

/proc/CanThrowVore(mob/living/prey, mob/living/pred)
	if(!can_spontaneous_vore(pred, prey))
		return FALSE
	if(!pred.throw_vore || !prey.throw_vore)
		return FALSE
	return TRUE

/proc/can_slip_vore(mob/living/pred, mob/living/prey)
	if(!can_spontaneous_vore(pred, prey))
		return FALSE
	if(!prey.is_slipping && !pred.is_slipping)	//Obviously they have to be slipping to get slip vored
		return FALSE
	if(world.time <= prey.slip_protect)
		return FALSE
	if(!pred.slip_vore || !prey.slip_vore)
		return FALSE
	return TRUE

///This is a general 'do we have the mechanical ability to do any type of spontaneous vore' without specialties.
/proc/can_spontaneous_vore(mob/living/pred, mob/living/prey)
	if(!istype(pred) || !istype(prey))
		return FALSE
	//Unfortunately, can_be_drop_prey is 'spontanous prey' var and can_be_drop_pred is 'spontaneous pred' var...horribly named imo.
	if(!prey.can_be_drop_prey || !pred.can_be_drop_pred)
		return FALSE
	if(prey.is_incorporeal() || pred.is_incorporeal())
		return FALSE
	if(!prey.devourable)
		return FALSE
	if(!is_vore_predator(pred))	//Check their bellies and stuff
		return FALSE
	if(!pred.vore_selected)	//Gotta have one selected as well.
		return FALSE
	if(!prey.allowmobvore && isanimal(pred) && !pred.ckey || (!pred.allowmobvore && isanimal(prey) && !prey.ckey))
		return FALSE
	return TRUE
