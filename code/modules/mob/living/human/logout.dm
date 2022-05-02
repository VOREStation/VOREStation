/mob/living/human/Logout()
	..()
	if(species) species.handle_logout_special(src)
	return