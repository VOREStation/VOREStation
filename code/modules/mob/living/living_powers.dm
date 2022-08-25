/mob/living/proc/reveal(var/silent, var/message = "<span class='warning'>You have been revealed! You are no longer hidden.</span>")
	if(status_flags & HIDING)
		status_flags &= ~HIDING
		reset_plane_and_layer()
		if(!silent && message)
			to_chat(src, message)

/mob/living/proc/hide()
	set name = "Hide"
	set desc = "Allows to hide beneath tables or certain items. Toggled on or off."
	set category = "Abilities"

	if(stat == DEAD || paralysis || weakened || stunned || restrained() || buckled || LAZYLEN(grabbed_by) || has_buckled_mobs()) //VORE EDIT: Check for has_buckled_mobs() (taur riding)
		return

	if(status_flags & HIDING)
		reveal(FALSE, "<span class='notice'>You have stopped hiding.</span>")
	else
		status_flags |= HIDING
		layer = HIDING_LAYER //Just above cables with their 2.44
		plane = OBJ_PLANE
		to_chat(src,"<span class='notice'>You are now hiding.</span>")

/mob/living/proc/toggle_selfsurgery()
	set name = "Allow Self Surgery"
	set desc = "Toggles the 'safeties' on self-surgery, allowing you to do so."
	set category = "Object"

	allow_self_surgery = !allow_self_surgery

	to_chat(usr, "<span class='notice'>You will [allow_self_surgery ? "now" : "no longer"] attempt to operate upon yourself.</span>")
	log_admin("DEBUG \[[world.timeofday]\]: [src.ckey ? "[src.name]:([src.ckey])" : "[src.name]"] has [allow_self_surgery ? "Enabled" : "Disabled"] self surgery.")
