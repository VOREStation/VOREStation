/mob/living/proc/hide()
	set name = "Hide"
	set desc = "Allows to hide beneath tables or certain items. Toggled on or off."
	set category = "Abilities"

	if(stat == DEAD || paralysis || weakened || stunned || restrained())
		return

	if(layer != HIDING_LAYER)
		layer = HIDING_LAYER //Just above cables with their 2.44
		src << text("<font color='blue'>You are now hiding.</font>")
	else
		layer = MOB_LAYER
		src << text("<font color='blue'>You have stopped hiding.</font>")
