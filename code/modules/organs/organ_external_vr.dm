//Sideways override for nanoform limbs (ugh)
/obj/item/organ/external/robotize(var/company, var/skip_prosthetics = FALSE, var/keep_organs = FALSE)
	var/original_robotic = robotic
	if(original_robotic >= ORGAN_NANOFORM)
		var/o_encased = encased
		var/o_max_damage = max_damage
		var/o_min_broken_damage = min_broken_damage
		robotic = FALSE
		. = ..(company = company, keep_organs = TRUE)
		robotic = original_robotic
		encased = o_encased
		max_damage = o_max_damage
		min_broken_damage = o_min_broken_damage
	else
		return ..()

/obj/item/organ/external/proc/is_hidden_by_tail()
	if(owner && owner.tail_style && owner.tail_style.hide_body_parts && (organ_tag in owner.tail_style.hide_body_parts))
		return 1