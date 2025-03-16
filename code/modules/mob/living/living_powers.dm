/mob/living/proc/reveal(var/silent, var/message = span_warning("You have been revealed! You are no longer hidden."))
	if(status_flags & HIDING)
		status_flags &= ~HIDING
		reset_plane_and_layer()
		if(!silent && message)
			to_chat(src, message)

/mob/living/proc/hide()
	set name = "Hide"
	set desc = "Allows to hide beneath tables or certain items. Toggled on or off."
	set category = "Abilities.General"

	if(stat == DEAD || paralysis || weakened || stunned || restrained() || buckled || LAZYLEN(grabbed_by) || has_buckled_mobs()) //VORE EDIT: Check for has_buckled_mobs() (taur riding)
		return

	if(status_flags & HIDING)
		reveal(FALSE, span_notice("You have stopped hiding."))
	else
		status_flags |= HIDING
		layer = HIDING_LAYER //Just above cables with their 2.44
		plane = OBJ_PLANE
		to_chat(src,span_notice("You are now hiding."))

/mob/living/proc/toggle_selfsurgery()
	set name = "Allow Self Surgery"
	set desc = "Toggles the 'safeties' on self-surgery, allowing you to do so."
	set category = "Object"

	allow_self_surgery = !allow_self_surgery

	to_chat(src, span_notice("You will [allow_self_surgery ? "now" : "no longer"] attempt to operate upon yourself."))
	log_admin("DEBUG \[[world.timeofday]\]: [src.ckey ? "[src.name]:([src.ckey])" : "[src.name]"] has [allow_self_surgery ? "Enabled" : "Disabled"] self surgery.")

/mob/living/proc/toggle_patting_defence()
	set name = "Toggle Reflexive Biting"
	set desc = "Toggles the automatic biting for if someone pats you on the head or boops your nose."
	set category = "Abilities.General"

	if(touch_reaction_flags & SPECIES_TRAIT_PATTING_DEFENCE)
		touch_reaction_flags &= ~(SPECIES_TRAIT_PATTING_DEFENCE)
		to_chat(src,span_notice("You will no longer bite hands who pat or boop you."))
	else
		touch_reaction_flags |= SPECIES_TRAIT_PATTING_DEFENCE
		to_chat(src,span_notice("You will now longer bite hands who pat or boop you."))

/mob/living/proc/toggle_personal_space()
	set name = "Toggle Personal Space"
	set desc = "Toggles dodging any attempts to hug or pat you."
	set category = "Abilities.General"

	if(touch_reaction_flags & SPECIES_TRAIT_PERSONAL_BUBBLE)
		touch_reaction_flags &= ~(SPECIES_TRAIT_PERSONAL_BUBBLE)
		to_chat(src,span_notice("You will no longer dodge all attempts at hugging, patting, booping, licking, smelling and hand shaking."))
	else
		touch_reaction_flags |= SPECIES_TRAIT_PERSONAL_BUBBLE
		to_chat(src,span_notice("You will now dodge all attempts at hugging, patting, booping, licking, smelling and hand shaking."))
