/datum/modifier/resleeving_sickness
	name = "resleeving sickness"
	desc = "You feel rather weak and unfocused, having been sleeved not so long ago."
	stacks = MODIFIER_STACK_EXTEND

	on_created_text = "<span class='warning'><font size='3'>You feel weak and unfocused.</font></span>"
	on_expired_text = "<span class='notice'><font size='3'>You feel your strength and focus return to you.</font></span>"

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

	on_created_text = "<span class='warning'>You feel slightly weak and unfocused.</span>"
	on_expired_text = "<span class='notice'>You feel your strength and focus return to you.</span>"

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