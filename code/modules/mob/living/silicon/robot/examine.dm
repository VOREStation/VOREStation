/mob/living/silicon/robot/examine(mob/user)
	var/custom_infix = custom_name ? ", [modtype][sprite_type] [braintype]" : ""
	. = ..(user, infix = custom_infix)

	if (src.getBruteLoss())
		if (src.getBruteLoss() < 75)
			. += "<span class='warning'>It looks slightly dented.</span>"
		else
			. += "<span class='warning'><B>It looks severely dented!</B></span>"
	if (src.getFireLoss())
		if (src.getFireLoss() < 75)
			. += "<span class='warning'>It looks slightly charred.</span>"
		else
			. += "<span class='warning'><B>It looks severely burnt and heat-warped!</B></span>"

	if(opened)
		. += "<span class='warning'>Its cover is open and the power cell is [cell ? "installed" : "missing"].</span>"
	else
		. += "Its cover is closed."

	if(!has_power)
		. += "<span class='warning'>It appears to be running on backup power.</span>"

	switch(src.stat)
		if(CONSCIOUS)
			if(shell)
				. += "It appears to be an [deployed ? "active" : "empty"] AI shell."
			else if(!src.client)
				. += "It appears to be in stand-by mode." //afk
		if(UNCONSCIOUS)		. += "<span class='warning'>It doesn't seem to be responding.</span>"
		if(DEAD)			. += "<span class='deadsay'>It looks completely unsalvageable.</span>"

	// VOREStation Edit: Start
	. += attempt_vr(src,"examine_bellies_borg",args) //VOREStation Edit
	// VOREStation Edit: End

	. += "*---------*"

	if(print_flavor_text()) . += "<br>[print_flavor_text()]"

	if (pose)
		if(!findtext(pose, regex("\[.?!]$"))) // Will be zero if the last character is not a member of [.?!]
			pose = addtext(pose,".") //Makes sure all emotes end with a period.
		. += "<br>It is [pose]" //Extra <br> intentional

	user.showLaws(src)
