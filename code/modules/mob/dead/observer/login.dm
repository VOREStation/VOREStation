/mob/observer/dead/Login()
	..()
	if (ghostimage)
		ghostimage.icon_state = src.icon_state
	updateghostimages()
