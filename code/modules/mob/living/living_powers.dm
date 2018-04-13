/mob/living/proc/hide()
	set name = "Hide"
	set desc = "Allows to hide beneath tables or certain items. Toggled on or off."
	set category = "Abilities"

	if(stat == DEAD || paralysis || weakened || stunned || restrained())
		return

	if(status_flags & HIDING)
		status_flags &= ~HIDING
		reset_plane_and_layer()
		to_chat(src,"<span class='notice'>You have stopped hiding.</span>")
	else
		status_flags |= HIDING
		layer = HIDING_LAYER //Just above cables with their 2.44
		plane = OBJ_PLANE
		to_chat(src,"<span class='notice'>You are now hiding.</span>")
