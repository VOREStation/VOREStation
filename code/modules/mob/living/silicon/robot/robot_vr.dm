/mob/living/silicon/robot/updateicon()
	if(stat == 0)
		if(sleeper_g == 1)
			overlays += "sleeper_g"
		if(sleeper_r == 1)
			overlays += "sleeper_r"