/mob/living/silicon/pai/examine(mob/user)
	. = ..(user, infix = ", personal AI")

	switch(src.stat)
		if(CONSCIOUS)
			if(!src.client)	. += "It appears to be in stand-by mode." //afk
		if(UNCONSCIOUS)		. += "<span class='warning'>It doesn't seem to be responding.</span>"
		if(DEAD)			. += "<span class='deadsay'>It looks completely unsalvageable.</span>"
	
	// VOREStation Edit: Start
	. += attempt_vr(src,"examine_bellies",args) //VOREStation Edit
	if(ooc_notes)
		. += "<span class = 'deptradio'>OOC Notes:</span> <a href='?src=\ref[src];ooc_notes=1'>\[View\]</a>"
	// VOREStation Edit: End

	. += "*---------*"

	if(print_flavor_text()) . += "\n[print_flavor_text()]\n"

	if (pose)
		if(!findtext(pose, regex("\[.?!]$"))) // Will be zero if the last character is not a member of [.?!]
			pose = addtext(pose,".") //Makes sure all emotes end with a period.
		. += "<br>It is [pose]" //Extra <br> intentional
		