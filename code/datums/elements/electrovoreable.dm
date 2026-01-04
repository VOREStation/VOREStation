/datum/element/electrovoreable
	// Electrovore interaction handler for items (e.g. power cells).
	// Logic is hooked via signals (COMSIG_ITEM_ATTACK_SELF).

/datum/element/electrovoreable/Attach(datum/target)
	. = ..()
	if(!isitem(target))
		return ELEMENT_INCOMPATIBLE

	RegisterSignal(target, COMSIG_ITEM_ATTACK_SELF, PROC_REF(on_attack_self))

/datum/element/electrovoreable/Detach(datum/target)
	UnregisterSignal(target, COMSIG_ITEM_ATTACK_SELF)
	return ..()

/datum/element/electrovoreable/proc/on_attack_self(obj/item/source, mob/user)
	SIGNAL_HANDLER

	if(!isliving(user))
		return

	var/mob/living/L = user
	if(!iscarbon(L))
		return
	var/mob/living/carbon/CL = L

	// Must be some kind of electrovore to interact at all
	if(!HAS_TRAIT(CL, TRAIT_ELECTROVORE))
		return

	// Only cells should have special electrovore behavior
	if(!istype(source, /obj/item/cell))
		return

	var/obj/item/cell/C = source

	// HELP: obligate electrovores only (charge the cell)
	if(CL.a_intent == I_HELP && HAS_TRAIT(CL, TRAIT_ELECTROVORE_OBLIGATE))
		if(C.charge >= C.maxcharge)
			return COMPONENT_CANCEL_ATTACK_CHAIN

		if(!CL.nutrition)
			CL.show_message(span_warning("You feel too drained to charge [C]."))
			return COMPONENT_CANCEL_ATTACK_CHAIN

		var/todrain = max(100, (CL.nutrition * 0.2))
		if(CL.nutrition < todrain)
			CL.show_message(span_warning("You don't have enough energy to charge [C]."))
			return COMPONENT_CANCEL_ATTACK_CHAIN

		CL.show_message(span_warning("Power surges from you and flows into [C], increasing its charge!"))
		CL.visible_message(span_notice("[CL] squeezes [C] tightly, charging it!"))

		var/totransfer = min(todrain, ((C.maxcharge - C.charge) / 15))

		CL.adjust_nutrition(-todrain)
		C.give(min((totransfer * 15), (C.maxcharge - C.charge)))
		C.update_icon()

		return COMPONENT_CANCEL_ATTACK_CHAIN

	// HURT: drain energy for nutrition (obligate + freeform)
	if(CL.a_intent == I_HURT)
		if(!C.charge)
			CL.show_message(span_warning("You take a look at [C] and notice it has nothing in it!"))
			return COMPONENT_CANCEL_ATTACK_CHAIN

		CL.show_message(span_warning("Sparks fly from [C] as you drain energy from it!"))
		CL.visible_message(span_danger("[CL] causes sparks to emit from [C] as it loses its charge!"))

		var/coefficient = 0.9
		var/totransfer = min(C.charge, 1500)

		CL.adjust_nutrition((totransfer / 15) * coefficient)
		C.use(totransfer)
		C.update_icon()

		var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
		s.set_up(3, 0, C)
		s.start()

		return COMPONENT_CANCEL_ATTACK_CHAIN

	return
