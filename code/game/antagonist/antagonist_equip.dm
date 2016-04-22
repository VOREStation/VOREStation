/datum/antagonist/proc/equip(var/mob/living/carbon/human/player)

	if(!istype(player))
		return 0

	// This could use work.
	if(flags & ANTAG_CLEAR_EQUIPMENT)
		for(var/obj/item/thing in player.contents)
			if(player.removeItem(thing, force = 1))
				qdel(thing)
	return 1

/datum/antagonist/proc/unequip(var/mob/living/carbon/human/player)
	if(!istype(player))
		return 0
	return 1