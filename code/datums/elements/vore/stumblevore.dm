/datum/element/stumblevore

/datum/element/stumblevore/Attach(datum/target)
	. = ..()
	if(!isliving(target))
		return ELEMENT_INCOMPATIBLE
	RegisterSignal(target, COMSIG_LIVING_STUMBLED_INTO, PROC_REF(handle_stumble))

/datum/element/stumblevore/Detach(datum/target)
	. = ..()
	UnregisterSignal(target, COMSIG_LIVING_STUMBLED_INTO)

///Source is the one being bumped into (Owner of this component)
///Target is the one bumping into us.
/datum/element/stumblevore/proc/handle_stumble(mob/living/source, mob/living/target)
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
