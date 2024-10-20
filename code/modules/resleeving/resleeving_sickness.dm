/datum/modifier/resleeving_sickness
	name = "resleeving sickness"
	desc = "You feel rather weak and unfocused, having been sleeved not so long ago."
	stacks = MODIFIER_STACK_EXTEND

	on_created_text = span_warning(span_large("You feel weak and unfocused."))
	on_expired_text = span_notice(span_large("You feel your strength and focus return to you."))

	incoming_brute_damage_percent = 1.1			// 10% more brute damage
	incoming_fire_damage_percent = 1.1			// 10% more burn damage
	incoming_hal_damage_percent = 1.5			// 50% more incoming agony.
	outgoing_melee_damage_percent = 0.5			// 50% less melee damage.
	disable_duration_percent = 2	 			// 100% longer stuns.
	evasion = -40								// 40% easier to hit.
	accuracy = -50								// 50% less accurate.
	accuracy_dispersion	= 20					// 20% less precise.

/datum/modifier/faux_resleeving_sickness
	name = "resleeving sickness (vore)"
	desc = "You feel somewhat weak and unfocused, having been sleeved not so long ago. (OOC: No real penalty for vore-related deaths)"
	stacks = MODIFIER_STACK_EXTEND

	on_created_text = span_warning("You feel slightly weak and unfocused.")
	on_expired_text = span_notice("You feel your strength and focus return to you.")

/datum/modifier/gory_devourment
	name = "gory devourment"
	desc = "You are being devoured! Dying right now would definitely be same as dying as food."
	stacks = MODIFIER_STACK_EXTEND
	hidden = TRUE
	var/datum/mind/cached_mind = null

/datum/modifier/gory_devourment/can_apply(var/mob/living/L)
	if(L.stat == DEAD)
		return FALSE
	else
		return TRUE

/datum/modifier/gory_devourment/on_applied()
	cached_mind = holder.mind
	return ..()

/datum/modifier/gory_devourment/on_expire()
	if(holder.stat == DEAD)
		cached_mind?.vore_death = TRUE
	cached_mind = null //Don't keep a hardref
	return ..()
