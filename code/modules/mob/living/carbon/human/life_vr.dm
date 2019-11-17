/mob/living/carbon/human/proc/weightgain()
	if (nutrition >= 0 && stat != 2)
		if (nutrition > MIN_NUTRITION_TO_GAIN && weight < MAX_MOB_WEIGHT && weight_gain)
			weight += species.metabolism*(0.01*weight_gain)

		else if (nutrition <= MAX_NUTRITION_TO_LOSE && stat != 2 && weight > MIN_MOB_WEIGHT && weight_loss)
			weight -= species.metabolism*(0.01*weight_loss) // starvation weight loss

/mob/living/carbon/human/proc/handle_hud_list_vr()

	//Right-side status hud updates with left side one.
	if (BITTEST(hud_updateflag, STATUS_HUD))
		var/image/other_status = hud_list[STATUS_HUD]
		var/image/status_r = grab_hud(STATUS_R_HUD)
		status_r.icon_state = other_status.icon_state
		apply_hud(STATUS_R_HUD, status_r)

	//Our custom health bar HUD
	if (BITTEST(hud_updateflag, HEALTH_HUD))
		var/image/other_health = hud_list[HEALTH_HUD]
		var/image/health_us = grab_hud(HEALTH_VR_HUD)
		health_us.icon_state = other_health.icon_state
		apply_hud(HEALTH_VR_HUD, health_us)

	//Backup implant hud status
	if (BITTEST(hud_updateflag, BACKUP_HUD))
		var/image/holder = grab_hud(BACKUP_HUD)

		holder.icon_state = "hudblank"

		for(var/obj/item/organ/external/E in organs)
			for(var/obj/item/weapon/implant/I in E.implants)
				if(I.implanted)
					if(istype(I,/obj/item/weapon/implant/backup))
						if(!mind)
							holder.icon_state = "hud_backup_nomind"
						else if(!(mind.name in SStranscore.body_scans))
							holder.icon_state = "hud_backup_nobody"
						else
							holder.icon_state = "hud_backup_norm"

		apply_hud(BACKUP_HUD, holder)

	//VOREStation Antag Hud
	if (BITTEST(hud_updateflag, VANTAG_HUD))
		var/image/vantag = grab_hud(VANTAG_HUD)
		if(vantag_pref)
			vantag.icon_state = vantag_pref
		else
			vantag.icon_state = "hudblank"
		apply_hud(VANTAG_HUD, vantag)

//Our call for the NIF to do whatever
/mob/living/carbon/human/proc/handle_nif()
	if(!nif) return

	//Process regular life stuff
	nif.life()

//Overriding carbon move proc that forces default hunger factor
/mob/living/carbon/Move(NewLoc, direct)
	. = ..()
	if(.)
		if(src.nutrition && src.stat != 2)
			if(ishuman(src))
				var/mob/living/carbon/human/M = src
				if(M.stat != 2 && M.nutrition > 0)
					M.nutrition -= M.species.hunger_factor/10
					if(M.m_intent == "run")
						M.nutrition -= M.species.hunger_factor/10
					if(M.nutrition < 0)
						M.nutrition = 0
			else
				src.nutrition -= DEFAULT_HUNGER_FACTOR/10
				if(src.m_intent == "run")
					src.nutrition -= DEFAULT_HUNGER_FACTOR/10
		// Moving around increases germ_level faster
		if(germ_level < GERM_LEVEL_MOVE_CAP && prob(8))
			germ_level++