/mob/living/silicon/robot/updateicon()
	overlays.Cut()
	if(stat == CONSCIOUS)
		overlays += "eyes-[module_sprites[icontype]]"
		if(sleeper_g == 1)
			overlays += "[module_sprites[icontype]]-sleeper_g"
		if(sleeper_r == 1)
			overlays += "[module_sprites[icontype]]-sleeper_r"

	if(opened)
		var/panelprefix = custom_sprite ? src.ckey : "ov"
		if(wiresexposed)
			overlays += "[panelprefix]-openpanel +w"
		else if(cell)
			overlays += "[panelprefix]-openpanel +c"
		else
			overlays += "[panelprefix]-openpanel -c"

	if(module_active && istype(module_active,/obj/item/borg/combat/shield))
		overlays += "[module_sprites[icontype]]-shield"

	if(modtype == "Combat")
		if(module_active && istype(module_active,/obj/item/borg/combat/mobility))
			icon_state = "[module_sprites[icontype]]-roll"
		else
			icon_state = module_sprites[icontype]
		return
	if(stat == 0)
		if(sleeper_g == 1)
			overlays += "[module_sprites[icontype]]-sleeper_g"
		if(sleeper_r == 1)
			overlays += "[module_sprites[icontype]]-sleeper_r"
