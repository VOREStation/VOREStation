/datum/teleport/proc/try_televore()
	var/datum/belly/target_belly

	//Destination is a living thing
	target_belly = check_belly(destination)

	//Destination has a living thing on it
	if(!target_belly)
		for(var/mob/living/M in get_turf(destination))
			if(M.vore_organs.len)
				var/I = M.vore_organs[1]
				target_belly = M.vore_organs[I]

	if(target_belly)
		teleatom.forceMove(destination.loc)
		playSpecials(destination,effectout,soundout)
		target_belly.internal_contents += teleatom
		playsound(destination, target_belly.vore_sound, 100, 1)
		return 1

	//No fun!
	return 0