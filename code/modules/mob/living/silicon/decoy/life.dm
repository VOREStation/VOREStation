/mob/living/silicon/decoy/Life()
	if (src.stat == 2)
		return
	else
		if (src.health <= (-getMaxHealth()) && src.stat != 2)
			death()
			return


/mob/living/silicon/decoy/updatehealth()
	if(SEND_SIGNAL(src, COMSIG_UPDATE_HEALTH) & COMSIG_UPDATE_HEALTH_GOD_MODE)
		health = getMaxHealth()
		set_stat(CONSCIOUS)
	else
		health = getMaxHealth() - getOxyLoss() - getToxLoss() - getFireLoss() - getBruteLoss()
