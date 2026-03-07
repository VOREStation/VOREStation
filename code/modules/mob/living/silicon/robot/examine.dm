/mob/living/silicon/robot/examine(mob/user)
	var/custom_infix = custom_name ? ", [modtype][sprite_type ? " [sprite_type]" : ""] [braintype]" : ""
	. = ..(user, infix = custom_infix)

	if (src.getBruteLoss())
		if (src.getBruteLoss() < 75)
			. += span_warning("[p_They()] look[p_s()] slightly dented.")
		else
			. += span_boldwarning("[p_They()] look[p_s()] severely dented!")
	if (src.getFireLoss())
		if (src.getFireLoss() < 75)
			. += span_warning("[p_They()] look[p_s()] slightly charred.")
		else
			. += span_boldwarning("[p_They()] look[p_s()] severely burnt and heat-warped!")

	if(opened)
		. += span_warning("[p_Their()] cover is open and the power cell is [cell ? "installed" : "missing"].")
	else
		. += "[p_Their()] cover is closed."

	if(!has_power)
		. += span_warning("[p_They()] appear[p_s()] to be running on backup power.")

	switch(src.stat)
		if(CONSCIOUS)
			if(shell)
				. += "[p_They()] appear[p_s()] to be an [deployed ? "active" : "empty"] AI shell."
			else if(!src.client)
				. += "[p_They()] appear[p_s()] to be in stand-by mode." //afk
		if(UNCONSCIOUS)		. += span_warning("[p_They()] [p_do()]n't seem to be responding.")
		if(DEAD)			. += span_deadsay("[p_They()] look[p_s()] completely unsalvageable.")

	. += formatted_vore_examine()

	. += ""

	if(print_flavor_text()) . += "<br>[print_flavor_text()]"

	if (pose)
		if(!findtext(pose, regex("\[.?!]$"))) // Will be zero if the last character is not a member of [.?!]
			pose = addtext(pose,".") //Makes sure all emotes end with a period.
		. += "<br>[p_They()] [p_are()] [pose]" //Extra <br> intentional

	user.showLaws(src)
