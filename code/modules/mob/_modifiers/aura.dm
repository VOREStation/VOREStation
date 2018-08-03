/*
'Aura' modifiers are semi-permanent, in that they do not have a set duration, but will expire if out of range of the 'source' of the aura.
Note: The source is defined as an argument in New(), and if not specified, it is assumed the holder is the source,
making it not expire ever, which is likely not what you want.
*/

/datum/modifier/aura
	var/aura_max_distance = 5 // If more than this many tiles away from the source, the modifier expires next tick.

/datum/modifier/aura/check_if_valid()
	if(!origin)
		expire()
	var/atom/A = origin.resolve()
	if(istype(A)) // Make sure we're not null.
		if(get_dist(holder, A) > aura_max_distance)
			expire()
	else
		expire() // Source got deleted or something.