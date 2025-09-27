/datum/power/changeling/visible_camouflage
	name = "Camouflage"
	desc = "We rapidly shape the color of our skin and secrete easily reversible dye on our clothes, to blend in with our surroundings.  \
	We are undetectable, so long as we move slowly.(Toggle)"
	helptext = "Running, and performing most acts will reveal us.  Our chemical regeneration is halted while we are hidden."
	enhancedtext = "Can run while hidden."
	ability_icon_state = "ling_camoflage"
	genomecost = 3
	verbpath = /mob/proc/changeling_visible_camouflage

//Hide us from anyone who would do us harm.
/mob/proc/changeling_visible_camouflage()
	set category = "Changeling"
	set name = "Visible Camouflage (10)"
	set desc = "Turns yourself almost invisible, as long as you move slowly."
	var/datum/component/antag/changeling/changeling = changeling_power(0,0,100,CONSCIOUS)
	if(!changeling)
		return

	if(ishuman(src))
		var/mob/living/carbon/human/H = src

		if(changeling.cloaked)
			changeling.cloaked = FALSE
			return TRUE
		if(H.has_modifier_of_type(/datum/modifier/changeling_camouflage)) //If they double-clicked the button while invis.
			to_chat(H, span_warning("We are already camouflaged!"))
			return TRUE

		//We delay the check, so that people can uncloak without needing 10 chemicals to do so.
		changeling = changeling_power(10,0,100,CONSCIOUS)

		if(!changeling)
			return FALSE
		changeling.chem_charges -= 10

		to_chat(H, span_notice("We vanish from sight, and will remain hidden, so long as we move carefully."))
		changeling.cloaked = TRUE
		if(changeling.recursive_enhancement)
			to_chat(src, span_notice("We may move at our normal speed while hidden."))
			H.add_modifier(/datum/modifier/changeling_camouflage/recursive, 0)
		else
			H.add_modifier(/datum/modifier/changeling_camouflage, 0)

/datum/modifier/changeling_camouflage
	name = "Camoflauge"
	desc = "We are near-impossible to see."
	var/must_walk = TRUE
	var/datum/component/antag/changeling/comp
	var/old_regen_rate
	var/mob/living/carbon/human/owner


/datum/modifier/changeling_camouflage/recursive
	must_walk = FALSE

/datum/modifier/changeling_camouflage/can_apply(var/mob/living/L, var/suppress_failure = FALSE)
	comp = L.GetComponent(/datum/component/antag/changeling)
	if(!comp)
		return FALSE

/datum/modifier/changeling_camouflage/on_applied()
	comp = holder.GetComponent(/datum/component/antag/changeling)
	if(must_walk)
		holder.set_m_intent(I_WALK)
	old_regen_rate = comp.chem_recharge_rate
	comp.chem_recharge_rate = 0
	animate(holder,alpha = 255, alpha = 10, time = 10)

/datum/modifier/changeling_camouflage/on_expire()
	animate(holder,alpha = 10, alpha = 255, time = 10)
	owner.invisibility = initial(owner.invisibility)
	holder.visible_message(span_warning("[holder] suddenly fades in, seemingly from nowhere!"),
	span_notice("We revert our camouflage, revealing ourselves."))
	holder.set_m_intent(I_RUN)
	comp.cloaked = FALSE
	comp.chem_recharge_rate = old_regen_rate
	comp = null
	owner = null

/datum/modifier/changeling_camouflage/tick()
	if(holder.m_intent != I_WALK && must_walk) // Moving too fast uncloaks you.
		expire(silent = TRUE)
	if(!comp.cloaked)
		expire(silent = TRUE)
	if(holder.stat) // Dead or unconscious lings can't stay cloaked.
		expire(silent = TRUE)
	if(holder.incapacitated(INCAPACITATION_DISABLED)) // Stunned lings also can't stay cloaked.
		expire(silent = TRUE)
	if(comp.chem_recharge_rate != 0) //Without this, there is an exploit that can be done, if one buys engorged chem sacks while cloaked.
		old_regen_rate += comp.chem_recharge_rate
		comp.chem_recharge_rate = 0
