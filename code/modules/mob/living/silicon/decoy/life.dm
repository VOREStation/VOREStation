/mob/living/silicon/decoy/Life()
	if (src.stat == 2)
		return
	else
		if (src.health <= (-getMaxHealth()) && src.stat != 2)
			death()
			return


/mob/living/silicon/decoy/updatehealth()
	if(SEND_SIGNAL(src, COMSIG_LIVING_HEALTH_UPDATE) & COMSIG_LIVING_HEALTH_UPDATE_GOD_MODE)
		health = getMaxHealth()
		set_stat(CONSCIOUS)
	else
		health = getMaxHealth() - getOxyLoss() - getToxLoss() - getFireLoss() - getBruteLoss()
		if(health <= -getMaxHealth()) //die only once
			death()
			return
