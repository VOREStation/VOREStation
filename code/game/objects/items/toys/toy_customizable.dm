/obj/item/toy/plushie/customizable
	name = "You shouldn't be seeing this..."
	desc = "Allan, please add details!"
	icon = 'icons/obj/customizable_toys/durg.dmi'
	icon_state = "blankdurg"
	pokephrase = "Squeaky!"

	var/base_color = "#FFFFFF"
	var/list/possible_overlays = list()
	var/list/added_overlays = list()

/obj/item/toy/plushie/customizable/update_icon()
	cut_overlays()
	var/mutable_appearance/B = mutable_appearance(icon, icon_state)
	B.color = base_color
	add_overlay(B)
	for(var/K,V in added_overlays)
		var/mutable_appearance/i = mutable_appearance(icon, K)
		i.color = V["color"]
		i.alpha = V["alpha"]
		add_overlay(i)

/obj/item/toy/plushie/customizable/Initialize(mapload)
	. = ..()
	update_icon()

/obj/item/toy/plushie/customizable/tgui_state(mob/user)
	return GLOB.tgui_conscious_state

/obj/item/toy/plushie/customizable/tgui_interact(mob/user, datum/tgui/ui = null)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "PlushieEditor")
		ui.open()
	update_icon()

/obj/item/toy/plushie/customizable/tgui_data(mob/user)
	. = list()
	.["base_color"] = base_color
	.["icon"] = icon
	.["preview"] = icon2base64(get_flat_icon(src))
	.["possible_overlays"] = list()
	for(var/state,name in possible_overlays)
		.["possible_overlays"] += list(list(
			"name" = name,
			"icon_state" = state
		))
	.["overlays"] = list()
	for(var/state,overlay in added_overlays)
		.["overlays"] += list(list(
			"icon_state" = state,
			"color" = overlay["color"],
			"alpha" = overlay["alpha"]
		))

/obj/item/toy/plushie/customizable/tgui_act(action, params, datum/tgui/ui)
	if(..())
		return TRUE
	add_fingerprint(ui.user)

	switch(action)
		if("add_overlay")
			. = TRUE
			added_overlays[params["new_overlay"]] = list( color = "#FFFFFF", alpha = 255 )

		if("remove_overlay")
			. = TRUE
			var/rem = params["removed_overlay"]
			added_overlays.Remove(rem)

		if("change_overlay_color")
			. = TRUE
			var/target = added_overlays[params["icon_state"]]
			var/new_color = tgui_color_picker(ui.user, "Choose a color:", possible_overlays[params["icon_state"]], base_color)
			target["color"] = new_color

		if("move_overlay_up")
			. = TRUE
			var/target = params["icon_state"]
			var/idx = added_overlays.Find(target)
			if (idx < added_overlays.len)
				added_overlays.Swap(idx, idx + 1)

		if("move_overlay_down")
			. = TRUE
			var/target = params["icon_state"]
			var/idx = added_overlays.Find(target)
			if (idx > 1)
				added_overlays.Swap(idx, idx - 1)

		if("change_base_color")
			. = TRUE
			var/new_color = tgui_color_picker(ui.user, "Choose a color:", "Plushie base color", base_color)
			base_color = new_color

		if("set_overlay_alpha")
			. = TRUE
			var/target = added_overlays[params["icon_state"]]
			var/new_alpha = params["alpha"]
			target["alpha"] = new_alpha

		if("import_config")
			. = TRUE
			added_overlays.Cut()
			var/config = params["config"]
			base_color = config["base_color"]
			for(var/overlay in config["overlays"])
				if(possible_overlays.Find(overlay["icon_state"]))
					added_overlays[overlay["icon_state"]] = list( color = overlay["color"], alpha = overlay["alpha"] )

		if("clear")
			. = TRUE
			added_overlays.Cut()
			base_color = "#FFFFFF"

		if("rename")
			. = TRUE
			rename_plushie()

	update_icon()

/obj/item/toy/plushie/customizable/AltClick(mob/user)
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
		"angular_w_1" = "Wings, Angular, L",
		"angular_w_2" = "Wings, Angular, R",
		"double_h_1" = "Horns, Double, L",
		"double_h_2" = "Horns, Double, R",
		"classic_h_1" = "Horns, Classic, L",
		"classic_h_2" = "Horns, Classic, R",
		"thick_h_1" = "Horns, Thick, L",
		"thick_h_2" = "Horns, Thick, R"
	)
