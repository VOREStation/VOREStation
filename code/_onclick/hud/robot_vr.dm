/mob/living/silicon/robot/update_hud()
	if(ui_style_vr)
		hands.icon = 'icons/mob/screen1_robot_vr.dmi'
	if(modtype)
		hands.icon_state = get_hud_module_icon()
	..()