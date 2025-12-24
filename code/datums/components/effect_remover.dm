/datum/component/effect_remover
	dupe_mode = COMPONENT_DUPE_ALLOWED
	/// Line sent to the user on successful removal.
	var/success_feedback
	/// Line forcesaid by the user on successful removal.
	var/success_forcesay
	/// Callback invoked with removal is done.
	var/datum/callback/on_clear_callback
	/// A typecache of all effects we can clear with our item.
	var/list/obj/effect/effects_we_clear
	/// If above 0, how long it takes while standing still to remove the effect.
	var/time_to_remove = 0 SECONDS

/datum/component/effect_remover/Initialize(success_forcesay, success_feedback, on_clear_callback, effects_we_clear, time_to_remove)
	. = ..()

	if(!isitem(parent))
		return COMPONENT_INCOMPATIBLE

	if(!effects_we_clear)
		stack_trace("[type] was instantiated without any valid removable effects!")
		return COMPONENT_INCOMPATIBLE

	//src.success_feedback = success_feedback
	//src.success_forcesay = success_forcesay
	src.on_clear_callback = on_clear_callback
	src.effects_we_clear = typecacheof(effects_we_clear)
	src.time_to_remove = time_to_remove

/datum/component/effect_remover/Destroy(force)
	on_clear_callback = null
	return ..()

/datum/component/effect_remover/RegisterWithParent()
	RegisterSignal(parent, COMSIG_ITEM_PRE_ATTACK, PROC_REF(try_remove_effect))

/datum/component/effect_remover/UnregisterFromParent()
	UnregisterSignal(parent, COMSIG_ITEM_PRE_ATTACK)

/datum/component/effect_remover/proc/try_remove_effect(datum/source, atom/target, mob/living/user, params)
	SIGNAL_HANDLER

	if(!isliving(user))
		return NONE

	if(is_type_in_typecache(target, effects_we_clear))
		do_remove_effects(target, user)
		return

/datum/component/effect_remover/proc/do_remove_effects(obj/effect/target, mob/living/user)
/* Grah- Might have to get this revised, later on.
	if(time_to_remove && !do_after(user, time_to_remove, target))
		return
	var/obj/item/item_parent = parent
	if(success_forcesay)
		user.say(success_forcesay)
	if(success_feedback)
		var/real_feedback = replacetext(success_feedback, "%THEEFFECT", "\the [target]")
		real_feedback = replacetext(real_feedback, "%THEWEAPON", "\the [item_parent]")
		user.balloon_alert()
		to_chat(user, span_notice(real_feedback))
*/
	on_clear_callback?.Invoke(target, user)

	if(!QDELETED(target))
		qdel(target)
