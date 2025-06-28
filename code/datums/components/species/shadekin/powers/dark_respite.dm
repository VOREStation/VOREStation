//Non-Canon on Virgo. Used downstream.

/datum/power/shadekin/dark_respite
	name = "Dark Respite (Only in Dark)"
	desc = "Focus yourself on healing any injuries sustained."
	verbpath = /mob/living/proc/dark_respite
	ability_icon_state = "dark_respite"

/mob/living/proc/dark_respite()
	set name = "Dark Respite (Only in Dark)"
	set desc = "Focus yourself on healing any injuries sustained."
	set category = "Abilities.Shadekin"

	var/datum/component/shadekin/SK = get_shadekin_component()
	if(!SK)
		return FALSE
	if(stat)
		to_chat(src, span_warning("Can't use that ability in your state!"))
		return FALSE

	if(!istype(get_area(src), /area/shadekin))
		to_chat(src, span_warning("Can only trigger Dark Respite in the Dark!"))
		return FALSE

	if(SK.in_dark_respite)
		to_chat(src, span_warning("You can't use that so soon after an emergency warp!"))
		return FALSE

	if(has_modifier_of_type(/datum/modifier/dark_respite) && !SK.manual_respite)
		to_chat(src, span_warning("You cannot manually end a Dark Respite triggered by an emergency warp!"))

	if(SK.in_phase)
		to_chat(src, span_warning("You can't use that while phase shifted!"))
		return FALSE

	if(has_modifier_of_type(/datum/modifier/dark_respite))
		to_chat(src, span_notice("You stop focusing the Dark on healing yourself."))
		SK.manual_respite = FALSE
		remove_a_modifier_of_type(/datum/modifier/dark_respite)
		return TRUE
	to_chat(src, span_notice("You start focusing the Dark on healing yourself. (Leave the dark or trigger the ability again to end this.)"))
	SK.manual_respite = TRUE
	add_modifier(/datum/modifier/dark_respite)
	return TRUE

/datum/modifier/dark_respite
	name = "Dark Respite"
	pain_immunity = 1
	var/datum/component/shadekin/SK

// Override this for special effects when it gets added to the mob.
/datum/modifier/dark_respite/on_applied()
	SK = holder.get_shadekin_component()
	if(!SK)
		expire()
	return

/datum/modifier/dark_respite/tick()
	if(!SK)
		expire()
		return
	var/mob/living/carbon/human/H
	if(istype(holder, /mob/living/carbon/human))
		H = holder
		if(H.nutrition)
			H.add_chemical_effect(CE_BLOODRESTORE, 5)

	if(istype(get_area(H), /area/shadekin))
		pain_immunity = TRUE
		//Very good healing, but only in the Dark.
		holder.adjustFireLoss((-0.25))
		holder.adjustBruteLoss((-0.25))
		holder.adjustToxLoss((-0.25))
		holder.heal_organ_damage(3, 0)
		if(H)
			H.add_chemical_effect(CE_ANTIBIOTIC, ANTIBIO_SUPER)
			for(var/obj/item/organ/I in H.internal_organs)
				if(I.robotic >= ORGAN_ROBOT)
					continue
				if(I.damage > 0)
					I.damage = max(I.damage - 0.25, 0)
				if(I.damage <= 5 && I.organ_tag == O_EYES)
					H.sdisabilities &= ~BLIND
			for(var/obj/item/organ/external/O in H.organs)
				if(O.status & ORGAN_BROKEN)
					O.mend_fracture()		//Only works if the bone won't rebreak, as usual
				for(var/datum/wound/W in O.wounds)
					if(W.bleeding())
						W.damage = max(W.damage - 3, 0)
						if(W.damage <= 0)
							O.wounds -= W
					if(W.internal)
						W.damage = max(W.damage - 3, 0)
						if(W.damage <= 0)
							O.wounds -= W
	else
		if(SK.manual_respite)
			to_chat(holder, span_notice("As you leave the Dark, you stop focusing the Dark on healing yourself."))
			SK.manual_respite = FALSE
			expire()
		if(pain_immunity)
			pain_immunity = 0

/datum/modifier/dark_respite/on_expire()
	SK = null
