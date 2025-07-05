/**
 * Return the markup to for the dropdown list for the VV panel for this atom
 *
 * Override in subtypes to add custom VV handling in the VV panel
 */
/atom/vv_get_dropdown()
	. = ..()
	VV_DROPDOWN_OPTION("", "---------")
	if(!ismovable(src))
		var/turf/curturf = get_turf(src)
		if(curturf)
			. += "<option value='?_src_=holder;[HrefToken()];adminplayerobservecoodjump=1;X=[curturf.x];Y=[curturf.y];Z=[curturf.z]'>Jump To</option>"
	VV_DROPDOWN_OPTION(VV_HK_MODIFY_TRANSFORM, "Modify Transform")
	VV_DROPDOWN_OPTION(VV_HK_SPIN_ANIMATION, "SpinAnimation")
	VV_DROPDOWN_OPTION(VV_HK_STOP_ALL_ANIMATIONS, "Stop All Animations")
	VV_DROPDOWN_OPTION(VV_HK_TRIGGER_EMP, "EMP Pulse")
	VV_DROPDOWN_OPTION(VV_HK_TRIGGER_EXPLOSION, "Explosion")
	VV_DROPDOWN_OPTION(VV_HK_EDIT_FILTERS, "Edit Filters")
	//VV_DROPDOWN_OPTION(VV_HK_EDIT_COLOR_MATRIX, "Edit Color as Matrix")
	VV_DROPDOWN_OPTION(VV_HK_TEST_MATRIXES, "Test Matrices")
	//if(greyscale_colors)
	//	VV_DROPDOWN_OPTION(VV_HK_MODIFY_GREYSCALE, "Modify greyscale colors")

/atom/vv_do_topic(list/href_list)
	. = ..()

	if(!.)
		return

	if(href_list[VV_HK_TRIGGER_EXPLOSION])
		return SSadmin_verbs.dynamic_invoke_verb(usr, /datum/admin_verb/admin_explosion, src)

	if(href_list[VV_HK_TRIGGER_EMP])
		return SSadmin_verbs.dynamic_invoke_verb(usr, /datum/admin_verb/admin_emp, src)

	if(href_list[VV_HK_MODIFY_TRANSFORM])
		if(!check_rights(R_VAREDIT))
			return
		var/result = input(usr, "Choose the transformation to apply","Transform Mod") as null|anything in list("Scale","Translate","Rotate","Shear")
		var/matrix/M = transform
		if(!result)
			return
		switch(result)
			if("Scale")
				var/x = input(usr, "Choose x mod","Transform Mod") as null|num
				var/y = input(usr, "Choose y mod","Transform Mod") as null|num
				if(isnull(x) || isnull(y))
					return
				transform = M.Scale(x,y)
			if("Translate")
				var/x = input(usr, "Choose x mod (negative = left, positive = right)","Transform Mod") as null|num
				var/y = input(usr, "Choose y mod (negative = down, positive = up)","Transform Mod") as null|num
				if(isnull(x) || isnull(y))
					return
				transform = M.Translate(x,y)
			if("Shear")
				var/x = input(usr, "Choose x mod","Transform Mod") as null|num
				var/y = input(usr, "Choose y mod","Transform Mod") as null|num
				if(isnull(x) || isnull(y))
					return
				transform = M.Shear(x,y)
			if("Rotate")
				var/angle = input(usr, "Choose angle to rotate","Transform Mod") as null|num
				if(isnull(angle))
					return
				transform = M.Turn(angle)
		SEND_SIGNAL(src, COMSIG_ATOM_VV_MODIFY_TRANSFORM)

	if(href_list[VV_HK_SPIN_ANIMATION])
		if(!check_rights(R_VAREDIT))
			return
		var/num_spins = input(usr, "Do you want infinite spins?", "Spin Animation") in list("Yes", "No")
		if(num_spins == "No")
			num_spins = input(usr, "How many spins?", "Spin Animation") as null|num
		else
			num_spins = -1
		if(!num_spins)
			return
		var/spins_per_sec = input(usr, "How many spins per second?", "Spin Animation") as null|num
		if(!spins_per_sec)
			return
		var/direction = input(usr, "Which direction?", "Spin Animation") in list("Clockwise", "Counter-clockwise")
		switch(direction)
			if("Clockwise")
				direction = 1
			if("Counter-clockwise")
				direction = 0
			else
				return
		SpinAnimation(1 SECONDS / spins_per_sec, num_spins, direction)

	if(href_list[VV_HK_STOP_ALL_ANIMATIONS])
		if(!check_rights(R_VAREDIT))
			return
		var/result = input(usr, "Are you sure?", "Stop Animating") in list("Yes", "No")
		if(result == "Yes")
			animate(src, transform = null, flags = ANIMATION_END_NOW) // Literally just fucking stop animating entirely because admin said so
		return

	if(href_list[VV_HK_AUTO_RENAME])
		if(!check_rights(R_VAREDIT))
			return
		var/newname = input(usr, "What do you want to rename this to?", "Automatic Rename") as null|text
		// Check the new name against the chat filter. If it triggers the IC chat filter, give an option to confirm.
		//if(newname && !(is_ic_filtered(newname) || is_soft_ic_filtered(newname) && tgui_alert(usr, "Your selected name contains words restricted by IC chat filters. Confirm this new name?", "IC Chat Filter Conflict", list("Confirm", "Cancel")) != "Confirm"))
		if(newname)
			vv_auto_rename(newname)

	if(href_list[VV_HK_EDIT_FILTERS])
		if(!check_rights(R_VAREDIT))
			return
		usr.client?.open_filter_editor(src)

	//if(href_list[VV_HK_EDIT_COLOR_MATRIX])
	//	if(!check_rights(R_VAREDIT))
	//		return
	//	usr.client?.open_color_matrix_editor(src)

	if(href_list[VV_HK_TEST_MATRIXES])
		if(!check_rights(R_VAREDIT))
			return
		usr.client?.open_matrix_tester(src)

/atom/vv_get_header()
	. = ..()
	var/refid = REF(src)
	. += "[VV_HREF_TARGETREF(refid, VV_HK_AUTO_RENAME, "<b id='name'>[src]</b>")]"
	. += "<br><font size='1'><a href='byond://?_src_=vars;[HrefToken()];rotatedatum=[refid];rotatedir=left'><<</a> <a href='byond://?_src_=vars;[HrefToken()];datumedit=[refid];varnameedit=dir' id='dir'>[dir2text(dir) || dir]</a> <a href='byond://?_src_=vars;[HrefToken()];rotatedatum=[refid];rotatedir=right'>>></a></font>"

/**
 * call back when a var is edited on this atom
 *
 * Can be used to implement special handling of vars
 *
 * At the atom level, if you edit a var named "color" it will add the atom colour with
 * admin level priority to the atom colours list
 *
 * Also, if GLOB.Debug2 is FALSE, it sets the [ADMIN_SPAWNED_1] flag on [flags_1][/atom/var/flags_1], which signifies
 * the object has been admin edited
 */
/atom/vv_edit_var(var_name, var_value)
	//var/old_light_flags = light_flags
	// Disable frozen lights for now, so we can actually modify it
	/*
	light_flags &= ~LIGHT_FROZEN
	switch(var_name)
		if(NAMEOF(src, light_range))
			if(light_system == COMPLEX_LIGHT)
				set_light(l_range = var_value)
			else
				set_light_range(var_value)
			. = TRUE
		if(NAMEOF(src, light_power))
			if(light_system == COMPLEX_LIGHT)
				set_light(l_power = var_value)
			else
				set_light_power(var_value)
			. = TRUE
		if(NAMEOF(src, light_color))
			if(light_system == COMPLEX_LIGHT)
				set_light(l_color = var_value)
			else
				set_light_color(var_value)
			. = TRUE
		if(NAMEOF(src, light_angle))
			if(light_system == COMPLEX_LIGHT)
				set_light(l_angle = var_value)
				. = TRUE
		if(NAMEOF(src, light_dir))
			if(light_system == COMPLEX_LIGHT)
				set_light(l_dir = var_value)
				. = TRUE
		if(NAMEOF(src, light_height))
			if(light_system == COMPLEX_LIGHT)
				set_light(l_height = var_value)
				. = TRUE
		if(NAMEOF(src, light_on))
			if(light_system == COMPLEX_LIGHT)
				set_light(l_on = var_value)
			else
				set_light_on(var_value)
			. = TRUE
		if(NAMEOF(src, light_flags))
			set_light_flags(var_value)
			// I'm sorry
			old_light_flags = var_value
			. = TRUE
		if(NAMEOF(src, smoothing_junction))
			set_smoothed_icon_state(var_value)
			. = TRUE
		if(NAMEOF(src, opacity))
			set_opacity(var_value)
			. = TRUE
		if(NAMEOF(src, base_pixel_x))
			set_base_pixel_x(var_value)
			. = TRUE
		if(NAMEOF(src, base_pixel_y))
			set_base_pixel_y(var_value)
			. = TRUE
		if(NAMEOF(src, material_flags))
			toggle_material_flags(var_value)
			. = TRUE
		if(NAMEOF(src, material_modifier))
			change_material_modifier(var_value)
			. = TRUE
	*/
	switch(var_name)
		if(NAMEOF(src, light_range))
			if(light_system == STATIC_LIGHT)
				set_light(l_range = var_value)
			else
				set_light_range(var_value)
			. =  TRUE
		if(NAMEOF(src, light_power))
			if(light_system == STATIC_LIGHT)
				set_light(l_power = var_value)
			else
				set_light_power(var_value)
			. =  TRUE
		if(NAMEOF(src, light_color))
			if(light_system == STATIC_LIGHT)
				set_light(l_color = var_value)
			else
				set_light_color(var_value)
			. =  TRUE
		if(NAMEOF(src, light_on))
			set_light_on(var_value)
			. =  TRUE
		if(NAMEOF(src, light_flags))
			set_light_flags(var_value)
			. =  TRUE
		if(NAMEOF(src, opacity))
			set_opacity(var_value)
			. =  TRUE

	//light_flags = old_light_flags
	if(!isnull(.))
		datum_flags |= DF_VAR_EDITED
		return

	//if(!GLOB.Debug2)
	//	flags_1 |= ADMIN_SPAWNED_1

	. = ..()

	switch(var_name)
		if(NAMEOF(src, color))
			add_atom_colour(color, ADMIN_COLOUR_PRIORITY)
			//update_appearance()
			update_icon()

/atom/proc/vv_auto_rename(newname)
	name = newname
