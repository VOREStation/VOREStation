/datum/element/spontaneous_vore

/datum/element/spontaneous_vore/Attach(datum/target)
	. = ..()
	if(!isliving(target))
		return ELEMENT_INCOMPATIBLE
	RegisterSignal(target, COMSIG_LIVING_STUMBLED_INTO, PROC_REF(handle_stumble))
	RegisterSignal(target, COMSIG_LIVING_FALLING_DOWN, PROC_REF(handle_fall))
	RegisterSignal(target, COMSIG_HIT_BY_THROWN_ENTITY, PROC_REF(handle_hitby))

/datum/element/spontaneous_vore/Detach(datum/target)
	. = ..()
	UnregisterSignal(target, list(COMSIG_LIVING_STUMBLED_INTO, COMSIG_LIVING_FALLING_DOWN, COMSIG_HIT_BY_THROWN_ENTITY))

///Source is the one being bumped into (Owner of this component)
///Target is the one bumping into us.
/datum/element/spontaneous_vore/proc/handle_stumble(mob/living/source, mob/living/target)
	SIGNAL_HANDLER

	//We are able to eat the person stumbling into us.
	if(source.CanStumbleVore(target)) //This is if the person stumbling into us is able to eat us!
		source.visible_message(span_vwarning("[target] flops carelessly into [source]!"))
		source.begin_instant_nom(source, prey = target, pred = source, belly = source.vore_selected)
		target.stop_flying()
		return CANCEL_STUMBLED_INTO

	//The person stumbling into us is able to eat us.
	if(target.CanStumbleVore(source)) //This is if the person stumbling into us is able to be eaten by us! BROKEN!
		source.visible_message(span_vwarning("[target] flops carelessly into [source]!"))
		target.forceMove(get_turf(source))
		source.begin_instant_nom(target, prey = source, pred = target, belly = target.vore_selected)
		source.stop_flying()
		return CANCEL_STUMBLED_INTO

//Source is the one dropping (us)
//Landing is the tile we're falling onto
//drop_mob is whatever mob is found in the turf we're dropping onto.
/datum/element/spontaneous_vore/proc/handle_fall(mob/living/source, turf/landing, mob/living/drop_mob)
	if(!drop_mob || drop_mob == source)
		return

	//pred = drop_mob
	//prey = source
	//result: source is eaten by drop_mob
	if(drop_mob.CanDropVore(source))
		drop_mob.feed_grabbed_to_self_falling_nom(drop_mob, prey = source)
		drop_mob.visible_message(span_vdanger("\The [drop_mob] falls right onto \the [source]!"))
		return COMSIG_CANCEL_FALL

	//pred = source
	//prey = drop_mob
	//result: drop_mob is eaten by source
	if(source.CanDropVore(drop_mob))
		source.feed_grabbed_to_self_falling_nom(source, prey = drop_mob)
		source.Weaken(4)
		source.visible_message(span_vdanger("\The [drop_mob] falls right into \the [source]!"))
		return COMSIG_CANCEL_FALL

/datum/element/spontaneous_vore/proc/handle_hitby(mob/living/source, atom/movable/hitby, speed)

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
		if(source.CanThrowVore(thrown_mob))
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
		else if(thrown_mob.CanThrowVore(source))//Pred thrown into prey.
			if(!thrown_mob.vore_selected)
				return
			source.visible_message(span_vwarning("[source] suddenly slips inside of [thrown_mob]'s [lowertext(thrown_mob.vore_selected.name)] as [thrown_mob] flies into them!"))
			thrown_mob.vore_selected.nom_mob(source) //Eat them!!!
			if(source.loc != thrown_mob.vore_selected)
				source.forceMove(thrown_mob.vore_selected) //Double check. Should never happen but...Weirder things have happened!
			add_attack_logs(thrown_mob.LAssailant,source,"Was Devoured by [thrown_mob.name] via throw vore.")
			return
