/obj/item/toy/plushie/customizable
	name = "You shouldn't be seeing this..."
	desc = "Allan, please add details!"
	icon = 'icons/obj/customizable_toys/durg.dmi'
	icon_state = "blankdurg"
	pokephrase = "Squeaky!"

	var/base_color = "#FFFFFF"
	var/list/possible_overlays
	var/list/added_overlays

/obj/item/toy/plushie/customizable/update_icon()
	cut_overlays()
	var/mutable_appearance/B = mutable_appearance(icon, icon_state)
	B.color = base_color
	add_overlay(B)
	if(added_overlays)
		for(var/key, value in added_overlays)
			var/mutable_appearance/our_image = mutable_appearance(icon, key)
			our_image.color = value["color"]
			our_image.alpha = value["alpha"]
			add_overlay(our_image)

/obj/item/toy/plushie/customizable/Initialize(mapload)
	. = ..()
	update_icon()

/obj/item/toy/plushie/customizable/tgui_state(mob/user)
	return GLOB.tgui_conscious_state

/obj/item/toy/plushie/customizable/tgui_interact(mob/user, datum/tgui/ui = null)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "PlushieEditor")
		ui.set_autoupdate(FALSE) //This might be a bit intensive, better to not update it every few ticks
		ui.open()

/obj/item/toy/plushie/customizable/tgui_data(mob/user)

	var/list/possible_overlay_data = list()
	if(possible_overlays)
		for(var/state,name in possible_overlays)
			UNTYPED_LIST_ADD(possible_overlay_data, list(
				"name" = name,
				"icon_state" = state
			))

	var/list/our_overlays = list()
	if(added_overlays)
		for(var/state,overlay in added_overlays)
			UNTYPED_LIST_ADD(our_overlays, list(
				"icon_state" = state,
				"name" = possible_overlays[state],
				"color" = overlay["color"],
				"alpha" = overlay["alpha"]
			))

	var/list/data = list(
		"base_color" = base_color,
		"name" = name,
		"icon" = icon,
		"preview" = icon2base64(get_flat_icon(src)),
		"possible_overlays" = possible_overlay_data,
		"overlays" = our_overlays
	)
	return data

/obj/item/toy/plushie/customizable/tgui_act(action, params, datum/tgui/ui)
	if(..())
		return TRUE
	add_fingerprint(ui.user)

	if(!added_overlays)
		added_overlays = list()

	switch(action)
		if("add_overlay")
			if(!possible_overlays)
				return FALSE
			var/new_overlay = params["new_overlay"]
			if(!(new_overlay in possible_overlays))
				return FALSE
			. = TRUE
			added_overlays[new_overlay] = list(color = "#FFFFFF", alpha = 255)
			update_icon()

		if("remove_overlay")
			if(!added_overlays)
				return FALSE
			var/removed_overlay = params["removed_overlay"]
			if(!(removed_overlay in added_overlays))
				return FALSE
			. = TRUE
			added_overlays.Remove(removed_overlay)
			update_icon()

		if("change_overlay_color")
			if(!possible_overlays)
				return FALSE
			var/selected_icon_state = params["icon_state"]
			if(!(selected_icon_state in possible_overlays))
				return FALSE
			. = TRUE
			var/target = added_overlays[selected_icon_state]
			var/mob/our_user = ui.user
			var/new_color = tgui_color_picker(our_user, "Choose a color:", possible_overlays[selected_icon_state], base_color)
			if(!new_color || our_user.stat || !Adjacent(our_user))
				return FALSE
			target["color"] = new_color
			update_icon()

		if("move_overlay_up")
			var/target = params["icon"]
			var/idx = added_overlays.Find(target)
			if(!idx)
				return FALSE
			. = TRUE
			if (idx < added_overlays.len)
				added_overlays.Swap(idx, idx + 1)
			update_icon()

		if("move_overlay_down")
			var/target = params["icon"]
			var/idx = added_overlays.Find(target)
			if(!idx)
				return FALSE
			. = TRUE
			if (idx > 1)
				added_overlays.Swap(idx, idx - 1)
			update_icon()

		if("change_base_color")
			. = TRUE
			var/mob/our_user = ui.user
			var/new_color = tgui_color_picker(our_user, "Choose a color:", "Plushie base color", base_color)
			if(!new_color || our_user.stat || !Adjacent(our_user))
				return FALSE
			base_color = new_color
			update_icon()

		if("set_overlay_alpha")
			var/target = added_overlays[params["icon_state"]]
			if(!target)
				return FALSE
			. = TRUE
			var/new_alpha = params["alpha"]
			target["alpha"] = new_alpha
			update_icon()

		if("import_config")
			. = TRUE
			var/our_data = params["config"]
			base_color = sanitize_hexcolor(our_data["base_color"])
			var/new_name = sanitize_name(our_data["name"])
			if(new_name)
				set_new_name(new_name)
			added_overlays.Cut()
			if(!possible_overlays)
				return
			for(var/overlay in our_data["overlays"])
				if(possible_overlays.Find(overlay["icon_state"]))
					var/new_color = sanitize_hexcolor(overlay["color"])
					var/new_alpha = CLAMP(text2num(overlay["alpha"]), 0, 255)
					added_overlays[overlay["icon_state"]] = list(color = new_color, alpha = new_alpha)
			update_icon()

		if("clear")
			. = TRUE
			added_overlays.Cut()
			base_color = "#FFFFFF"
			update_icon()

		if("rename")
			return set_new_name(params["name"])

/obj/item/toy/plushie/customizable/proc/set_new_name(new_name)
	var/sane_name = sanitize_name(new_name)
	if(!sane_name)
		return FALSE
	name = sane_name
	adjusted_name = sane_name
	return TRUE

/obj/item/toy/plushie/customizable/click_alt(mob/user)
	tgui_interact(user)

/obj/item/toy/plushie/customizable/dragon
	name = "custom dragon plushie"
	desc = "A customizable, modular plushie in the shape of a dragon. How cute!"
	pokephrase = "Gawr!"
	possible_overlays = list(
		"durg_underbelly" = "Underbelly",
		"durg_fur" = "Fur",
		"durg_spines" = "Spines",
		"classic_w_1" = "Wings, Western, L",
		"classic_w_2" = "Wings, Western, R",
		"classic_w_misc" = "Wings, Western, Underside",
		"fairy_w_1" = "Wings, Fairy, L",
		"fairy_w_2" = "Wings, Fairy, R",
		"fairy_w_misc" = "Wings, Fairy, L Extra",
		"angular_w_1" = "Wings, Angular, L",
		"angular_w_2" = "Wings, Angular, R",
		"angular_w_misc" = "Wings, Angular, L Extra",
		"double_h_1" = "Horns, Double, L",
		"double_h_2" = "Horns, Double, R",
		"classic_h_1" = "Horns, Classic, L",
		"classic_h_2" = "Horns, Classic, R",
		"thick_h_1" = "Horns, Thick, L",
		"thick_h_2" = "Horns, Thick, R"
	)
