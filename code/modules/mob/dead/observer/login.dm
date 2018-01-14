//Nobody here anymore.
/mob/observer/dead/Login()
	..() //Creates the plane_holder lazily
	plane_holder.set_vis(VIS_GHOSTS, ghostvision)
	plane_holder.set_vis(VIS_FULLBRIGHT, !seedarkness)
	plane_holder.set_vis(VIS_AI_EYE, TRUE)
	plane = PLANE_GHOSTS
