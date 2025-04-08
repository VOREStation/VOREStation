/mob/living/silicon/robot/update_hud()
	if(modtype)
		hands.icon_state = get_hud_module_icon()
	..()
