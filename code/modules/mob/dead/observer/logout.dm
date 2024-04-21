/mob/observer/dead/Logout()
	..()
	spawn(0)
		if(src && !key)	//we've transferred to another mob. This ghost should be deleted.
			qdel(src)
		else
			cleanup_timer = QDEL_IN_STOPPABLE(src, 10 MINUTES)
