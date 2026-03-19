//////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////// ICONS ////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////

/mob/living/simple_mob/animal/synx/update_icon()
	update_fullness()
	build_icons()
	for(var/belly_class in vore_fullness_ex)
		var/vs_fullness = vore_fullness_ex[belly_class]
		if(vs_fullness > 0)
			if(transformed)
				//transformed bellysprites dont exist yet. Uncomment this when they do. -Reo
				//add_overlay("[iconstate]-t_[belly_class]-[vs_fullness]")
				pass()
			else
				add_overlay("[icon_state]_[belly_class]-[vs_fullness]")


/mob/living/simple_mob/animal/synx/proc/build_icons(var/random)
	cut_overlays()
	if(stat == DEAD)
		icon_state = "synx_dead"
		plane = MOB_LAYER
		return
	if(random)
		var/list/bodycolors = list("#FFFFFF")
		body = pick(body_styles)
		overlay_colors["Body"] = pick(bodycolors)
		horns = pick(horn_styles)
		var/list/horncolors = list("#FFE100","#A75A35","#1C4DFF","#FF0000","#404C6D","#2F2F2F","#55CE21","#711BFF","#DEDEE0")
		overlay_colors["Horns"] = pick(horncolors)
		var/list/markingcolors = list("#2F2F2F")
		markings = pick(marking_styles)
		overlay_colors["Marks"] = pick(markingcolors)
		var/list/eyecolors = list("#FFE100","#FF6A00","#1C4DFF","#FF0000","#3D5EBE","#FF006E","#55CE21","#711BFF","#939EFF")
		eyes = pick(eye_styles)
		overlay_colors["Eyes"] = pick(eyecolors)


	var/image/I = image(icon, "synx_body[body][transformed? "-t" : null][stomach_distended? "-s" : null]")
	I.color = overlay_colors["Body"]
	I.appearance_flags |= (RESET_COLOR|PIXEL_SCALE)
	I.plane = (status_flags & HIDING)? OBJ_PLANE : MOB_PLANE
	I.layer = (status_flags & HIDING)? HIDING_LAYER : MOB_LAYER
	add_overlay(I)

	I = image(icon, "synx_horns[horns][transformed? "-t" : null]")
	I.color = overlay_colors["Horns"]
	I.appearance_flags |= (RESET_COLOR|PIXEL_SCALE)
	I.plane = (status_flags & HIDING)? OBJ_PLANE : MOB_PLANE
	I.layer = (status_flags & HIDING)? HIDING_LAYER : MOB_LAYER
	add_overlay(I)

	I = image(icon, "synx_markings[markings][transformed? "-t" : null]")
	I.color = overlay_colors["Marks"]
	I.appearance_flags |= (RESET_COLOR|PIXEL_SCALE)
	I.plane = (status_flags & HIDING)? OBJ_PLANE : MOB_PLANE
	I.layer = (status_flags & HIDING)? HIDING_LAYER : MOB_LAYER
	add_overlay(I)

	I = image(icon, "synx_eyes[eyes][transformed? "-t" : null]")
	I.color = overlay_colors["Eyes"]
	I.appearance_flags |= (RESET_COLOR|PIXEL_SCALE)
	I.plane = (status_flags & HIDING)? OBJ_PLANE : MOB_PLANE
	I.layer = (status_flags & HIDING)? HIDING_LAYER : MOB_LAYER
	add_overlay(I)

/mob/living/simple_mob/animal/synx/proc/set_style()
	set name = "Set Style"
	set desc = "Customise your icons."
	set category = "Abilities.Synx"

	var/list/options = list("Body","Horns","Marks","Eyes")
	for(var/option in options)
		LAZYSET(options, option, new /image('icons/effects/synx_labels.dmi', option))
	var/choice = show_radial_menu(src, src, options, radius = 60)
	if(!choice || QDELETED(src) || src.incapacitated())
		return FALSE
	. = TRUE
	switch(choice)
		if("Body")
			options = body_styles
			for(var/option in options)
				var/image/I = new /image('icons/mob/synx_modular.dmi', "synx_body[option]", dir = 2)
				LAZYSET(options, option, I)
			choice = show_radial_menu(src, src, options, radius = 90)
			if(!choice || QDELETED(src) || src.incapacitated())
				return 0
			var/new_color = tgui_color_picker(src, "Pick body color:","Body Color", overlay_colors["Body"])
			if(!new_color)
				return 0
			body = choice
			overlay_colors["Body"] = new_color
		if("Horns")
			options = horn_styles
			for(var/option in options)
				var/image/I = new /image('icons/mob/synx_modular.dmi', "synx_horns[option]", dir = 2)
				LAZYSET(options, option, I)
			choice = show_radial_menu(src, src, options, radius = 90)
			if(!choice || QDELETED(src) || src.incapacitated())
				return 0
			var/new_color = tgui_color_picker(src, "Pick horn color:","Horn Color", overlay_colors["Horns"])
			if(!new_color)
				return 0
			horns = choice
			overlay_colors["Horns"] = new_color
		if("Marks")
			options = marking_styles
			for(var/option in options)
				var/image/I = new /image('icons/mob/synx_modular.dmi', "synx_markings[option]", dir = 2)
				LAZYSET(options, option, I)
			choice = show_radial_menu(src, src, options, radius = 90)
			if(!choice || QDELETED(src) || src.incapacitated())
				return 0
			var/new_color = tgui_color_picker(src, "Pick marking color:","Marking Color", overlay_colors["Marks"])
			if(!new_color)
				return 0
			markings = choice
			overlay_colors["Marks"] = new_color
		if("Eyes")
			options = eye_styles
			for(var/option in options)
				var/image/I = new /image('icons/mob/synx_modular.dmi', "synx_eyes[option]", dir = 2)
				LAZYSET(options, option, I)
			choice = show_radial_menu(src, src, options, radius = 90)
			if(!choice || QDELETED(src) || src.incapacitated())
				return 0
			var/new_color = tgui_color_picker(src, "Pick eye color:","Eye Color", overlay_colors["Eyes"])
			if(!new_color)
				return 0
			eyes = choice
			overlay_colors["Eyes"] = new_color
	if(.)
		build_icons()
