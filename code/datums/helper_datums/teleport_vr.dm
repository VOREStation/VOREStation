//wrapper
/proc/do_noeffect_teleport(ateleatom, adestination, aprecision=0, afteleport=1, aeffectin=null, aeffectout=null, asoundin=null, asoundout=null, local=FALSE)
	new /datum/teleport/instant/science/noeffect(arglist(args))
	return

/datum/teleport/instant/science/noeffect/setEffects(datum/effect/effect/system/aeffectin,datum/effect/effect/system/aeffectout)
	return 1

/datum/teleport/proc/try_televore()
	//Destination is in a belly
	if(isbelly(destination.loc))
		var/obj/belly/B = destination.loc

		teleatom.forceMove(get_turf(B)) //So we can splash the sound and sparks and everything.
		playSpecials(destination,effectout,soundout)
		teleatom.forceMove(B)
		return TRUE

	//No fun!
	return FALSE
