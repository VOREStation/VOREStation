var/global/list/gen_hud_users            = list() // List of all entities using a generic AR shades.
var/global/list/eng_hud_users            = list() // List of all entities using a engineer HUD.
var/global/list/sci_hud_users            = list() // List of all entities using a science HUD.

var/global/list/vantag_hud_users		 = list() // List of all mobs with the VANTAG hud on.

/proc/broadcast_engineering_hud_message(var/message, var/broadcast_source)
	broadcast_hud_message(message, broadcast_source, eng_hud_users, /obj/item/clothing/glasses/omnihud/eng)

/proc/broadcast_science_hud_message(var/message, var/broadcast_source)
	broadcast_hud_message(message, broadcast_source, sci_hud_users, /obj/item/clothing/glasses/omnihud/rnd)

proc/process_omni_hud(var/mob/M, var/mode, var/mob/Alt)
	if(!can_process_hud(M))
		return

	var/datum/arranged_hud_process/P
	switch(mode)
		if("med")
			P = arrange_hud_process(M, Alt, med_hud_users)
		if("sec")
			P = arrange_hud_process(M, Alt, sec_hud_users)
		if("eng")
			P = arrange_hud_process(M, Alt, eng_hud_users)
		if("sci")
			P = arrange_hud_process(M, Alt, sci_hud_users)
		if("best")
			P = arrange_hud_process(M, Alt, sec_hud_users)
		else
			P = arrange_hud_process(M, Alt, gen_hud_users)

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


proc/process_vantag_hud(var/mob/M)
	if(!M.vantag_hud || !can_process_hud(M))
		return

	var/datum/arranged_hud_process/P = arrange_hud_process(M, null, vantag_hud_users)

	for(var/mob/living/carbon/human/guy in P.Mob.in_view(P.Turf))
		if(P.Mob.see_invisible < guy.invisibility)
			continue

		P.Client.images += guy.hud_list[VANTAG_HUD]
