/mob/living/silicon/robot/Login()
	..()
	regenerate_icons()
	update_hud()

	show_laws(0)

	// Override the DreamSeeker macro with the borg version!
	client.set_hotkeys_macro("borgmacro", "borghotkeymode")

	// Forces synths to select an icon relevant to their module
	if(!icon_selected)
		icon_selection_tries = SSrobot_sprites.get_module_sprites_len(modtype, src) + 1
		choose_icon(icon_selection_tries)

		if(sprite_datum && module)
			sprite_datum.do_equipment_glamour(module)

	plane_holder.set_vis(VIS_AUGMENTED, TRUE)