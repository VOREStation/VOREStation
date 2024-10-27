/mob/living/silicon/robot/examine(mob/user)
	var/custom_infix = custom_name ? ", [modtype][sprite_type ? " [sprite_type]" : ""] [braintype]" : ""
	. = ..(user, infix = custom_infix)

	if (src.getBruteLoss())
		if (src.getBruteLoss() < 75)
			. += span_warning("It looks slightly dented.")
		else
			. += span_boldwarning("It looks severely dented!")
	if (src.getFireLoss())
		if (src.getFireLoss() < 75)
			. += span_warning("It looks slightly charred.")
		else
			. += span_boldwarning("It looks severely burnt and heat-warped!")

	if(opened)
		. += span_warning("Its cover is open and the power cell is [cell ? "installed" : "missing"].")
	else
		. += "Its cover is closed."

	if(!has_power)
		. += span_warning("It appears to be running on backup power.")

	switch(src.stat)
		if(CONSCIOUS)
			if(shell)
				. += "It appears to be an [deployed ? "active" : "empty"] AI shell."
			else if(!src.client)
				. += "It appears to be in stand-by mode." //afk
		if(UNCONSCIOUS)		. += span_warning("It doesn't seem to be responding.")
		if(DEAD)			. += span_deadsay("It looks completely unsalvageable.")

	// VOREStation Edit: Start
	. += attempt_vr(src,"examine_bellies_borg",args) //VOREStation Edit
	// VOREStation Edit: End

	. += ""

	if(print_flavor_text()) . += "<br>[print_flavor_text()]"

	if (pose)
		if(!findtext(pose, regex("\[.?!]$"))) // Will be zero if the last character is not a member of [.?!]
			pose = addtext(pose,".") //Makes sure all emotes end with a period.
		. += "<br>It is [pose]" //Extra <br> intentional

	user.showLaws(src)
