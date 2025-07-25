/**
 * Attached to mobs. Gives them godmode by stopping damage, effects, embeds, among all other negative effects.
 */
/datum/element/godmode
	element_flags = ELEMENT_DETACH_ON_HOST_DESTROY|ELEMENT_BESPOKE
	argument_hash_start_idx = 2

/datum/element/godmode/Attach(datum/target)
	. = ..()
	//Must be appliied to mobs.
	if(!ismob(target))
		return ELEMENT_INCOMPATIBLE
	var/mob/our_target = target
	if(our_target.status_flags & GODMODE) //Already have it.
		return ELEMENT_INCOMPATIBLE
	our_target.status_flags |= GODMODE

	if(ishuman(target))
		RegisterSignal(target, COMSIG_EXTERNAL_ORGAN_PRE_DAMAGE_APPLICATION, PROC_REF(on_external_damaged))
		RegisterSignal(target, COMSIG_INTERNAL_ORGAN_PRE_DAMAGE_APPLICATION, PROC_REF(on_internal_damaged))

	if(issilicon(target))
		RegisterSignal(target, COMSIG_SILICON_EMP_ACT, PROC_REF(on_emp))

	if(isrobot(target))
		RegisterSignal(target, COMSIG_ROBOT_EMP_ACT, PROC_REF(on_emp))

	//Four main damage types: Brute, Burn, Oxy, Tox
	RegisterSignal(target, COMSIG_TAKING_OXY_DAMAGE, PROC_REF(on_oxygen_damage))
	RegisterSignal(target, COMSIG_TAKING_TOX_DAMAGE, PROC_REF(on_tox_damage))
	RegisterSignal(target, COMSIG_TAKING_FIRE_DAMAGE, PROC_REF(on_fire_damage))
	RegisterSignal(target, COMSIG_TAKING_BRUTE_DAMAGE, PROC_REF(on_brute_damage))

	//Rarer types, such as Brain, Clone, Halloss
	RegisterSignal(target, COMSIG_TAKING_BRAIN_DAMAGE, PROC_REF(on_brain_damage))
	RegisterSignal(target, COMSIG_TAKING_CLONE_DAMAGE, PROC_REF(on_clone_damage))
	RegisterSignal(target, COMSIG_TAKING_HALO_DAMAGE, PROC_REF(on_halo_damage))

	//Things such as update health.
	RegisterSignal(target, COMSIG_UPDATE_HEALTH, PROC_REF(on_update_health))
	RegisterSignal(target, COMSIG_TAKING_APPLY_EFFECT, PROC_REF(on_apply_effect))

	//For things that don't fall into a single bucket
	RegisterSignal(target, COMSIG_CHECK_FOR_GODMODE, PROC_REF(godmode_check))
	RegisterSignal(target, COMSIG_BEING_ELECTROCUTED, PROC_REF(on_electrocute))
	RegisterSignal(target, COMSIG_EMBED_OBJECT, PROC_REF(embed_check))


/datum/element/godmode/Detach(atom/movable/target)
	//Human specific comsigs:
	if(ishuman(target))
		UnregisterSignal(target, list(COMSIG_EXTERNAL_ORGAN_PRE_DAMAGE_APPLICATION, COMSIG_INTERNAL_ORGAN_PRE_DAMAGE_APPLICATION))

	if(issilicon(target))
		UnregisterSignal(target, list(COMSIG_SILICON_EMP_ACT))

	if(isrobot(target))
		UnregisterSignal(target, list(COMSIG_ROBOT_EMP_ACT))

	//All the general comsigs.
	UnregisterSignal(target, list(COMSIG_TAKING_OXY_DAMAGE, COMSIG_TAKING_TOX_DAMAGE, COMSIG_TAKING_FIRE_DAMAGE, \
	COMSIG_TAKING_BRUTE_DAMAGE, COMSIG_TAKING_BRAIN_DAMAGE, COMSIG_TAKING_CLONE_DAMAGE, COMSIG_TAKING_HALO_DAMAGE, \
	COMSIG_UPDATE_HEALTH, COMSIG_TAKING_APPLY_EFFECT, COMSIG_CHECK_FOR_GODMODE, COMSIG_BEING_ELECTROCUTED, COMSIG_EMBED_OBJECT))
	var/mob/our_target = target

	//And finally, remove the fact we're in godmode.
	our_target.status_flags &= ~GODMODE
	return ..()

/datum/element/godmode/proc/on_external_damaged()
	SIGNAL_HANDLER
	return COMPONENT_CANCEL_EXTERNAL_ORGAN_DAMAGE

/datum/element/godmode/proc/on_internal_damaged()
	SIGNAL_HANDLER
	return COMPONENT_CANCEL_INTERNAL_ORGAN_DAMAGE

/datum/element/godmode/proc/on_brain_damage()
	SIGNAL_HANDLER
	return COMSIG_CANCEL_BRAIN_DAMAGE

/datum/element/godmode/proc/on_oxygen_damage()
	SIGNAL_HANDLER
	return COMSIG_CANCEL_OXY_DAMAGE

/datum/element/godmode/proc/on_tox_damage()
	SIGNAL_HANDLER
	return COMSIG_CANCEL_TOX_DAMAGE

/datum/element/godmode/proc/on_clone_damage()
	SIGNAL_HANDLER
	return COMSIG_CANCEL_CLONE_DAMAGE

/datum/element/godmode/proc/on_fire_damage()
	SIGNAL_HANDLER
	return COMSIG_CANCEL_FIRE_DAMAGE

/datum/element/godmode/proc/on_brute_damage()
	SIGNAL_HANDLER
	return COMSIG_CANCEL_BRUTE_DAMAGE

/datum/element/godmode/proc/on_halo_damage()
	SIGNAL_HANDLER
	return COMSIG_CANCEL_HALO_DAMAGE

/datum/element/godmode/proc/on_update_health()
	SIGNAL_HANDLER
	return COMSIG_UPDATE_HEALTH_GOD_MODE

/datum/element/godmode/proc/on_apply_effect()
	SIGNAL_HANDLER
	return COMSIG_CANCEL_EFFECT

/datum/element/godmode/proc/on_electrocute()
	SIGNAL_HANDLER
	return COMPONENT_CARBON_CANCEL_ELECTROCUTE

/datum/element/godmode/proc/embed_check()
	SIGNAL_HANDLER
	return COMSIG_CANCEL_EMBED

/datum/element/godmode/proc/on_emp()
	SIGNAL_HANDLER
	return COMPONENT_BLOCK_EMP

/datum/element/godmode/proc/godmode_check()
	SIGNAL_HANDLER
	return COMSIG_GODMODE_CANCEL
