/mob/living/Logout()
	..()
	if (mind)
		//Per BYOND docs key remains set if the player DCs, becomes null if switching bodies.
		if(!key)	//key and mind have become seperated.
			mind.active = 0	//This is to stop say, a mind.transfer_to call on a corpse causing a ghost to re-enter its body.

	spawn(15 SECONDS) //15 seconds to get back into the mob before it goes wild
		if(src && !src.client)
			if(ai_holder)
				ai_holder.go_wake()
