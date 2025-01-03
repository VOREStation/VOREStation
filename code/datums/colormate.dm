/datum/ColorMate
	var/name = "colouring"
	var/atom/movable/inserted
	var/activecolor = "#FFFFFF"
	var/list/color_matrix_last
	var/active_mode = COLORMATE_HSV

	var/build_hue = 0
	var/build_sat = 1
	var/build_val = 1

	/// Minimum lightness for normal mode
	var/minimum_normal_lightness = 50
	/// Minimum lightness for matrix mode, tested using 4 test colors of full red, green, blue, white.
	var/minimum_matrix_lightness = 75
	/// Minimum matrix tests that must pass for something to be considered a valid color (see above)
	var/minimum_matrix_tests = 2
	/// Temporary messages
	var/temp

/datum/ColorMate/New(mob/user)
	color_matrix_last = list(
		1, 0, 0,
		0, 1, 0,
		0, 0, 1,
		0, 0, 0,
	)
	if(istype(user))
		inserted = user
	. = ..()

/datum/ColorMate/Destroy()
	inserted = null
	. = ..()

/datum/ColorMate/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ColorMate", src.name)
		ui.set_autoupdate(FALSE) //This might be a bit intensive, better to not update it every few ticks
		ui.open()

/datum/ColorMate/tgui_state(mob/user)
	return GLOB.tgui_conscious_state

/datum/ColorMate/tgui_data(mob/user)
	. = list()
	.["activemode"] = active_mode
	.["matrixcolors"] = list(
		"rr" = color_matrix_last[1],
		"rg" = color_matrix_last[2],
		"rb" = color_matrix_last[3],
		"gr" = color_matrix_last[4],
		"gg" = color_matrix_last[5],
		"gb" = color_matrix_last[6],
		"br" = color_matrix_last[7],
		"bg" = color_matrix_last[8],
		"bb" = color_matrix_last[9],
		"cr" = color_matrix_last[10],
		"cg" = color_matrix_last[11],
		"cb" = color_matrix_last[12],
	)
	.["buildhue"] = build_hue
	.["buildsat"] = build_sat
	.["buildval"] = build_val
	if(temp)
		.["temp"] = temp
	if(inserted)
		.["item"] = list()
		.["item"]["name"] = inserted.name
		.["item"]["sprite"] = icon2base64(get_flat_icon(inserted,dir=SOUTH,no_anim=TRUE))
		.["item"]["preview"] = icon2base64(build_preview(user))
	else
		.["item"] = null

/datum/ColorMate/tgui_act(action, params)
	. = ..()
	if(.)
		return
	if(inserted)
		switch(action)
			if("switch_modes")
				active_mode = text2num(params["mode"])
				return TRUE
			if("choose_color")
				var/chosen_color = input(inserted, "Choose a color: ", "ColorMate colour picking", activecolor) as color|null
				if(chosen_color)
					activecolor = chosen_color
				return TRUE
			if("paint")
				do_paint(inserted)
				temp = "Painted Successfully!"
				if(isanimal(inserted))
					var/mob/living/simple_mob/M = inserted
					M.has_recoloured = TRUE
				if(isrobot(inserted))
					var/mob/living/silicon/robot/R = inserted
					R.has_recoloured = TRUE
				Destroy()
			if("drop")
				temp = ""
				Destroy()
			if("clear")
				inserted.remove_atom_colour(FIXED_COLOUR_PRIORITY)
				playsound(src, 'sound/effects/spray3.ogg', 50, 1)
				temp = "Cleared Successfully!"
				return TRUE
			if("set_matrix_color")
				color_matrix_last[params["color"]] = params["value"]
				return TRUE
			if("set_matrix_string")
				if(params["value"])
					var/list/colours = splittext(params["value"], ",")
					if(colours.len > 12)
						colours.Cut(13)
					for(var/i = 1, i <= colours.len, i++)
						var/number = text2num(colours[i])
						if(isnum(number))
							color_matrix_last[i] = clamp(number, -10, 10)
				return TRUE
			if("set_hue")
				build_hue = clamp(text2num(params["buildhue"]), 0, 360)
				return TRUE
			if("set_sat")
				build_sat = clamp(text2num(params["buildsat"]), -10, 10)
				return TRUE
			if("set_val")
				build_val = clamp(text2num(params["buildval"]), -10, 10)
				return TRUE

/datum/ColorMate/proc/do_paint(mob/user)
	var/color_to_use
	switch(active_mode)
		if(COLORMATE_TINT)
			color_to_use = activecolor
		if(COLORMATE_MATRIX)
			color_to_use = rgb_construct_color_matrix(
				text2num(color_matrix_last[1]),
				text2num(color_matrix_last[2]),
				text2num(color_matrix_last[3]),
				text2num(color_matrix_last[4]),
				text2num(color_matrix_last[5]),
				text2num(color_matrix_last[6]),
				text2num(color_matrix_last[7]),
				text2num(color_matrix_last[8]),
				text2num(color_matrix_last[9]),
				text2num(color_matrix_last[10]),
				text2num(color_matrix_last[11]),
				text2num(color_matrix_last[12]),
			)
		if(COLORMATE_HSV)
			color_to_use = color_matrix_hsv(build_hue, build_sat, build_val)
			color_matrix_last = color_to_use
	if(!color_to_use || !check_valid_color(color_to_use, user))
		to_chat(user, span_notice("Invalid color."))
		return FALSE
	inserted.add_atom_colour(color_to_use, FIXED_COLOUR_PRIORITY)
	playsound(src, 'sound/effects/spray3.ogg', 50, 1)
	return TRUE

/// Produces the preview image of the item, used in the UI, the way the color is not stacking is a sin.
/datum/ColorMate/proc/build_preview(mob/user)
	if(inserted) //sanity
		var/list/cm
		switch(active_mode)
			if(COLORMATE_MATRIX)
				cm = rgb_construct_color_matrix(
					text2num(color_matrix_last[1]),
					text2num(color_matrix_last[2]),
					text2num(color_matrix_last[3]),
					text2num(color_matrix_last[4]),
					text2num(color_matrix_last[5]),
					text2num(color_matrix_last[6]),
					text2num(color_matrix_last[7]),
					text2num(color_matrix_last[8]),
					text2num(color_matrix_last[9]),
					text2num(color_matrix_last[10]),
					text2num(color_matrix_last[11]),
					text2num(color_matrix_last[12]),
				)
				if(!check_valid_color(cm, user))
					return get_flat_icon(inserted, dir=SOUTH, no_anim=TRUE)

			if(COLORMATE_TINT)
				if(!check_valid_color(activecolor, user))
					return get_flat_icon(inserted, dir=SOUTH, no_anim=TRUE)

			if(COLORMATE_HSV)
				cm = color_matrix_hsv(build_hue, build_sat, build_val)
				color_matrix_last = cm
				if(!check_valid_color(cm, user))
					return get_flat_icon(inserted, dir=SOUTH, no_anim=TRUE)

		var/cur_color = inserted.color
		inserted.color = null
		inserted.color = (active_mode == COLORMATE_TINT ? activecolor : cm)
		var/icon/preview = get_flat_icon(inserted, dir=SOUTH, no_anim=TRUE)
		inserted.color = cur_color
		temp = ""

		. = preview

/datum/ColorMate/proc/check_valid_color(list/cm, mob/user)
	if(!islist(cm))		// normal
		var/list/HSV = ReadHSV(RGBtoHSV(cm))
		if(HSV[3] < minimum_normal_lightness)
			temp = "[cm] is too dark (Minimum lightness: [minimum_normal_lightness])"
			return FALSE
		return TRUE
	else	// matrix
		// We test using full red, green, blue, and white
		// A predefined number of them must pass to be considered valid
		var/passed = 0
#define COLORTEST(thestring, thematrix) passed += (ReadHSV(RGBtoHSV(RGBMatrixTransform(thestring, thematrix)))[3] >= minimum_matrix_lightness)
		COLORTEST("FF0000", cm)
		COLORTEST("00FF00", cm)
		COLORTEST("0000FF", cm)
		COLORTEST("FFFFFF", cm)
#undef COLORTEST
		if(passed < minimum_matrix_tests)
			temp = "Matrix is too dark. (passed [passed] out of [minimum_matrix_tests] required tests. Minimum lightness: [minimum_matrix_lightness])."
			return FALSE
		return TRUE
