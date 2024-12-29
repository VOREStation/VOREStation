/datum/modifier/feysight
	name = "feysight"
	desc = "You are filled with an inner peace, and widened sight."
	client_color = "#42e6ca"

	on_created_text = span_alien("You feel an inner peace as your mind's eye expands!")
	on_expired_text = span_notice("Your sight returns to what it once was.")
	stacks = MODIFIER_STACK_EXTEND

	accuracy = -15
	accuracy_dispersion = 1

/datum/modifier/feysight/on_applied()
	holder.see_invisible = 60
	holder.see_invisible_default = 60
	holder.vis_enabled += VIS_GHOSTS
	holder.recalculate_vis()

/datum/modifier/feysight/on_expire()
	holder.see_invisible_default = initial(holder.see_invisible_default)
	holder.see_invisible = holder.see_invisible_default
	holder.vis_enabled -= VIS_GHOSTS
	holder.recalculate_vis()

/datum/modifier/feysight/can_apply(var/mob/living/L)
	if(L.stat)
		to_chat(L, span_warning("You can't be unconscious or dead to experience tranquility."))
		return FALSE

	if(!L.is_sentient())
		return FALSE // Drones don't feel anything.

	if(ishuman(L))
		var/mob/living/carbon/human/H = L
		if(H.species.name == "Diona")
			to_chat(L, span_warning("You feel strange for a moment, but it passes."))
			return FALSE // Happy trees aren't affected by tranquility.

	return ..()

/datum/modifier/feysight/tick()
	..()

	if(ishuman(holder))
		var/mob/living/carbon/human/H = holder
		H.druggy = min(15, H.druggy + 4)
