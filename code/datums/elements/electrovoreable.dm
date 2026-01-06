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

	if(!iscarbon(user))
		return
	var/mob/living/carbon/carbon_user = user

	// Must be some kind of electrovore to interact at all
	if(!HAS_TRAIT(carbon_user, TRAIT_ELECTROVORE))
		return

	// Only cells should have special electrovore behavior
	if(!istype(source, /obj/item/cell))
		return
	var/obj/item/cell/source_cell = source

	// HELP: obligate electrovores only (charge the cell)
	if(carbon_user.a_intent == I_HELP && HAS_TRAIT(carbon_user, TRAIT_ELECTROVORE_OBLIGATE))
		if(source_cell.charge >= source_cell.maxcharge)
			return COMPONENT_CANCEL_ATTACK_CHAIN

		if(!carbon_user.nutrition)
			carbon_user.show_message(span_warning("You feel too drained to charge [source_cell]."))
			return COMPONENT_CANCEL_ATTACK_CHAIN

		var/todrain = max(100, (carbon_user.nutrition * 0.2))
		if(carbon_user.nutrition < todrain)
			carbon_user.show_message(span_warning("You don't have enough energy to charge [source_cell]."))
			return COMPONENT_CANCEL_ATTACK_CHAIN

		carbon_user.show_message(span_warning("Power surges from you and flows into [source_cell], increasing its charge!"))
		carbon_user.visible_message(span_notice("[carbon_user] squeezes [source_cell] tightly, charging it!"))

		var/totransfer = min(todrain, ((source_cell.maxcharge - source_cell.charge) / 15))

		carbon_user.adjust_nutrition(-todrain)
		source_cell.give(min((totransfer * 15), (source_cell.maxcharge - source_cell.charge)))
		source_cell.update_icon()

		return COMPONENT_CANCEL_ATTACK_CHAIN

	// HURT: drain energy for nutrition (obligate + freeform)
	if(carbon_user.a_intent == I_HURT)
		if(!source_cell.charge)
			carbon_user.show_message(span_warning("You take a look at [source_cell] and notice it has nothing in it!"))
			return COMPONENT_CANCEL_ATTACK_CHAIN

		carbon_user.show_message(span_warning("Sparks fly from [source_cell] as you drain energy from it!"))
		carbon_user.visible_message(span_danger("[carbon_user] causes sparks to emit from [source_cell] as it loses its charge!"))

		var/coefficient = 0.9
		var/totransfer = min(source_cell.charge, 1500)

		carbon_user.adjust_nutrition((totransfer / 15) * coefficient)
		source_cell.use(totransfer)
		source_cell.update_icon()

		var/datum/effect/effect/system/spark_spread/spark_effect = new /datum/effect/effect/system/spark_spread
		spark_effect.set_up(3, 0, source_cell)
		spark_effect.start()

		return COMPONENT_CANCEL_ATTACK_CHAIN
