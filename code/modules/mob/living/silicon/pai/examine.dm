/mob/living/silicon/pai/examine(mob/user)
	. = ..(user, infix = ", personal AI")

	switch(src.stat)
		if(CONSCIOUS)
			if(!src.client)	. += "[p_They()] appear[p_s()] to be in stand-by mode." //afk
		if(UNCONSCIOUS)		. += span_warning("[p_They()] [p_do()]n't seem to be responding.")
		if(DEAD)			. += span_deadsay("[p_They()] look[p_s()] completely unsalvageable.")

	. += formatted_vore_examine()
	if(print_flavor_text()) . += "\n[print_flavor_text()]\n"
	. += ""
	if (pose)
		if(!findtext(pose, regex("\[.?!]$"))) // Will be zero if the last character is not a member of [.?!]
			pose = addtext(pose,".") //Makes sure all emotes end with a period.
		. += "<br>[p_They()] [p_are()] [pose]" //Extra <br> intentional
