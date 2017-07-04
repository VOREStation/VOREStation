/mob/living/silicon/pai/proc/pai_nom(var/mob/living/T in oview(1))
	set name = "pAI Nom"
	set category = "pAI Commands"
	set desc = "Allows you to eat someone while unfolded. Can't be used while in card form."
    
	if (stat != CONSCIOUS)
		return
	return feed_grabbed_to_self(src,T)
