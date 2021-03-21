/mob/living/silicon/robot/platform/update_icon()
	updateicon()

/mob/living/silicon/robot/platform/updateicon()

	cut_overlays()
	underlays.Cut()
	var/obj/item/weapon/robot_module/robot/platform/tank_module = module
	if(!istype(tank_module))
		icon = initial(icon)
		icon_state = initial(icon_state)
		color = initial(color)
		return

	// This is necessary due to Polaris' liberal use of KEEP_TOGETHER and propensity for scaling transforms.
	// If we just apply state/colour to the base icon, RESET_COLOR on the additional overlays is ignored.
	icon = tank_module.user_icon
	icon_state = "blank"
	color = null
	var/image/I = image(tank_module.user_icon, tank_module.user_icon_state)
	I.color = tank_module.base_color
	I.appearance_flags |= (RESET_COLOR|PIXEL_SCALE)
	underlays += I

	if(tank_module.armor_color)
		I = image(icon, "[tank_module.user_icon_state]_armour")
		I.color = tank_module.armor_color
		I.appearance_flags |= (RESET_COLOR|PIXEL_SCALE)
		add_overlay(I)

	for(var/decal in tank_module.decals)
		I = image(icon, "[tank_module.user_icon_state]_[decal]")
		I.color = tank_module.decals[decal]
		I.appearance_flags |= (RESET_COLOR|PIXEL_SCALE)
		add_overlay(I)

	if(tank_module.eye_color)
		I = image(icon, "[tank_module.user_icon_state]_eyes")
		I.color = tank_module.eye_color
		I.appearance_flags |= (RESET_COLOR|PIXEL_SCALE)
		add_overlay(I)

	if(client && key && stat == CONSCIOUS && tank_module.pupil_color)
		I = image(icon, "[tank_module.user_icon_state]_pupils")
		I.color = tank_module.pupil_color
		I.plane = PLANE_LIGHTING_ABOVE
		I.appearance_flags |= (RESET_COLOR|PIXEL_SCALE)
		add_overlay(I)

	if(opened)
		add_overlay("[tank_module.user_icon_state]-open")
		if(wiresexposed)
			I = image(icon, "[tank_module.user_icon_state]-wires")
		else if(cell)
			I = image(icon, "[tank_module.user_icon_state]-cell")
		else
			I = image(icon, "[tank_module.user_icon_state]-nowires")
		I.appearance_flags |= (RESET_COLOR|PIXEL_SCALE)
		add_overlay(I)

/mob/living/silicon/robot/platform/proc/try_paint(var/obj/item/device/floor_painter/painting, var/mob/user)

	var/obj/item/weapon/robot_module/robot/platform/tank_module = module
	if(!istype(tank_module))
		to_chat(user, SPAN_WARNING("\The [src] is not paintable."))
		return FALSE

	var/list/options = list("Eyes", "Armour", "Body", "Clear Colors")
	if(length(tank_module.available_decals))
		options += "Decal"
	if(length(tank_module.decals))
		options += "Clear Decals"
	for(var/option in options)
		LAZYSET(options, option, new /image('icons/effects/thinktank_labels.dmi', option))

	var/choice = show_radial_menu(user, painting, options, radius = 42, require_near = TRUE)
	if(!choice || QDELETED(src) || QDELETED(painting) || QDELETED(user) || user.incapacitated() || tank_module.loc != src)
		return FALSE

	if(choice == "Decal")
		choice = null
		options = list()
		for(var/decal_name in tank_module.available_decals)
			LAZYSET(options, decal_name, new /image('icons/effects/thinktank_labels.dmi', decal_name))
		choice = show_radial_menu(user, painting, options, radius = 42, require_near = TRUE)
		if(!choice || QDELETED(src) || QDELETED(painting) || QDELETED(user) || user.incapacitated() || tank_module.loc != src)
			return FALSE

	. = TRUE
	switch(choice)
		if("Eyes")
			tank_module.eye_color =   painting.paint_colour
		if("Armour")
			tank_module.armor_color = painting.paint_colour
		if("Body")
			tank_module.base_color =  painting.paint_colour
		if("Clear Colors")
			tank_module.eye_color =   initial(tank_module.eye_color)
			tank_module.armor_color = initial(tank_module.armor_color)
			tank_module.base_color =  initial(tank_module.base_color)
		if("Clear Decals")
			tank_module.decals = null
		else
			if(choice in tank_module.available_decals)
				LAZYSET(tank_module.decals, tank_module.available_decals[choice], painting.paint_colour)
			else
				. = FALSE
	if(.)
		updateicon()
