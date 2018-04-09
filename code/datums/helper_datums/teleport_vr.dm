/datum/teleport/proc/try_televore()
	//Destination is in a belly
	if(isbelly(destination.loc) && isliving(teleatom))
		var/mob/living/L = teleatom
		var/obj/belly/B = destination.loc
		
		if(!L.can_be_drop_prey) //Overloading this as a pref for 'want to be unexpectedly eaten'
			return FALSE
		
		teleatom.forceMove(get_turf(B)) //So we can splash the sound and sparks and everything.
		playSpecials(destination,effectout,soundout)
		teleatom.forceMove(B)
		return TRUE

	//No fun!
	return FALSE
	