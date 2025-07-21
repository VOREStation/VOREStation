/**
 * Attached to humans. Gives them godmode by stopping damage to external and internal organs.
 */
/datum/element/human_godmode
	element_flags = ELEMENT_DETACH_ON_HOST_DESTROY


/datum/element/human_godmode/Attach(datum/target)
	. = ..()
	if(!ishuman(target))
		return ELEMENT_INCOMPATIBLE
	RegisterSignal(target, COMSIG_EXTERNAL_ORGAN_PRE_DAMAGE_APPLICATION, PROC_REF(on_external_damaged))
	RegisterSignal(target, COMSIG_INTERNAL_ORGAN_PRE_DAMAGE_APPLICATION, PROC_REF(on_internal_damaged))

/datum/element/human_godmode/Detach(atom/movable/target)
	. = ..()
	UnregisterSignal(target, list(COMSIG_EXTERNAL_ORGAN_PRE_DAMAGE_APPLICATION, COMPONENT_CANCEL_INTERNAL_ORGAN_DAMAGE))

/datum/element/human_godmode/proc/on_external_damaged()
	SIGNAL_HANDLER
	return COMPONENT_CANCEL_EXTERNAL_ORGAN_DAMAGE

/datum/element/human_godmode/proc/on_internal_damaged()
	SIGNAL_HANDLER
	return COMPONENT_CANCEL_INTERNAL_ORGAN_DAMAGE
