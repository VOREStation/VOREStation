/obj/proc/buckle_level(var/mob/victim)
	if(!buckled_mobs)
		return UNBUCKLED
	if(victim in buckled_mobs)
		return PARTIALLY_BUCKLED