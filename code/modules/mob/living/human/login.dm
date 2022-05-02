/mob/living/human/Login()
	..()
	update_hud()
	if(species) species.handle_login_special(src)
	return