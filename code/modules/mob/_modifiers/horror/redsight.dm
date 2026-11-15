/datum/modifier/redsight
	name = "redsight"
	desc = "You can see into the unknown."
	client_color = "#ce6161"

	on_created_text = span_alien("You feel as though you can see the horrors of reality!")
	on_expired_text = span_notice("Your sight returns to what it once was.")
	stacks = MODIFIER_STACK_EXTEND

/datum/modifier/redsight/on_applied()
	holder.see_invisible = 60
	holder.see_invisible_default = 60
	holder.vis_enabled += VIS_GHOSTS
	holder.recalculate_vis()

/datum/modifier/redsight/on_expire()
	holder.see_invisible_default = initial(holder.see_invisible_default)
	holder.see_invisible = holder.see_invisible_default
	holder.vis_enabled -= VIS_GHOSTS
	holder.recalculate_vis()

/datum/modifier/redsight/can_apply(mob/living/L)
	if(L.stat)
		to_chat(L, span_warning("You can't be unconscious or dead to see the unknown."))
		return FALSE
	var/obj/item/organ/internal/eyes/E = L.internal_organs_by_name[O_EYES]
	if(E && istype(E, /obj/item/organ/internal/eyes/horror))
		return ..()
	return FALSE

/datum/modifier/redsight/check_if_valid() //We don't call parent. This doesn't wear off without set conditions.
	//Dead?
	if(holder.stat == DEAD)
		expire(silent = TRUE)
	//We got eyes and they're special eyes?
	var/obj/item/organ/internal/eyes/E = holder.internal_organs_by_name[O_EYES]
	if(!E || !istype(E, /obj/item/organ/internal/eyes/horror))
		expire(silent = TRUE)
