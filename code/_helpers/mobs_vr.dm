/atom/proc/living_mobs(var/range = world.view)
	var/list/viewers = oviewers(src,range)
	var/list/living = list()
	for(var/mob/living/L in viewers)
		living += L

	return living
