/datum/element/spontaneous_vore

/datum/element/spontaneous_vore/Attach(datum/target)
	. = ..()
	if(!isliving(target))
		return ELEMENT_INCOMPATIBLE
	RegisterSignal(target, COMSIG_LIVING_STUMBLED_INTO, PROC_REF(handle_stumble))
	RegisterSignal(target, COMSIG_LIVING_FALLING_DOWN, PROC_REF(handle_fall))

/datum/element/spontaneous_vore/Detach(datum/target)
	. = ..()
	UnregisterSignal(target, list(COMSIG_LIVING_STUMBLED_INTO, COMSIG_LIVING_FALLING_DOWN))

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

	if(drop_mob.is_incorporeal())
		return

	//pred = drop_mob
	//prey = source
	//result: source is eaten by drop_mob
	if(source.devourable && drop_mob.vore_selected && drop_mob.can_be_drop_pred && source.can_be_drop_prey && drop_mob.drop_vore && source.drop_vore)
		drop_mob.feed_grabbed_to_self_falling_nom(drop_mob, prey = source)
		drop_mob.visible_message(span_vdanger("\The [drop_mob] falls right onto \the [source]!"))
		return COMSIG_CANCEL_FALL

	//pred = source
	//prey = drop_mob
	//result: drop_mob is eaten by source
	if(drop_mob.devourable && source.vore_selected && source.can_be_drop_pred && drop_mob.can_be_drop_prey && drop_mob.drop_vore && source.drop_vore)
		source.feed_grabbed_to_self_falling_nom(source, prey = drop_mob)
		source.Weaken(4)
		source.visible_message(span_vdanger("\The [drop_mob] falls right into \the [source]!"))
		return COMSIG_CANCEL_FALL
