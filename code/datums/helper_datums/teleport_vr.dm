/datum/teleport/proc/try_televore()
	//Destination is in a belly
	if(isbelly(destination.loc))
		var/obj/belly/B = destination.loc
	
		teleatom.forceMove(get_turf(B)) //So we can splash the sound and sparks and everything.
		playSpecials(destination,effectout,soundout)
		teleatom.forceMove(B)
		return 1

	//No fun!
	return 0
	