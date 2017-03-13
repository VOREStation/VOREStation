proc/process_omni_hud(var/mob/M, var/mode, var/mob/Alt)
	if(!can_process_hud(M))
		return

	var/datum/arranged_hud_process/P = arrange_hud_process(M, Alt, med_hud_users)
	for(var/mob/living/carbon/human/guy in P.Mob.in_view(P.Turf))
		if(P.Mob.see_invisible < guy.invisibility)
			continue

		P.Client.images += guy.hud_list[ID_HUD]
		P.Client.images += guy.hud_list[HEALTH_VR_HUD]

		if(mode == "med") //Medical advanced version
			P.Client.images += guy.hud_list[STATUS_R_HUD]
			P.Client.images += guy.hud_list[BACKUP_HUD]
		if(mode == "sec") //Security advanced version
			P.Client.images += guy.hud_list[WANTED_HUD]
		if(mode == "best") //Command/omni advanced version
			P.Client.images += guy.hud_list[WANTED_HUD]
			P.Client.images += guy.hud_list[STATUS_R_HUD]
			P.Client.images += guy.hud_list[BACKUP_HUD]
