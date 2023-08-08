/mob/living/silicon/robot/Login()
	..()
	regenerate_icons()
	update_hud()

	show_laws(0)

	// Override the DreamSeeker macro with the borg version!
	client.set_hotkeys_macro("borgmacro", "borghotkeymode")

	// Forces synths to select an icon relevant to their module
	if(!icon_selected)
		icon_selection_tries = SSrobot_sprites.get_module_sprites_len(modtype) + 1
		choose_icon(icon_selection_tries)
	plane_holder.set_vis(VIS_AUGMENTED, TRUE) //VOREStation Add - ROBOT VISION IS AUGMENTED