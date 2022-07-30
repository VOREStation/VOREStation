/obj/item/integrated_electronics/detailer
	name = "assembly detailer"
	desc = "A combination autopainter and flash anodizer designed to give electronic assemblies a colorful, wear-resistant finish."
	icon = 'icons/obj/integrated_electronics/electronic_tools.dmi'
	icon_state = "detailer"
	item_flags = NOBLUDGEON
	w_class = ITEMSIZE_SMALL
	var/detail_color = COLOR_ASSEMBLY_WHITE
	var/list/color_list = list(
		"dark gray" = COLOR_ASSEMBLY_BLACK,
		"machine gray" = COLOR_ASSEMBLY_BGRAY,
		"white" = COLOR_ASSEMBLY_WHITE,
		"red" = COLOR_ASSEMBLY_RED,
		"orange" = COLOR_ASSEMBLY_ORANGE,
		"beige" = COLOR_ASSEMBLY_BEIGE,
		"brown" = COLOR_ASSEMBLY_BROWN,
		"gold" = COLOR_ASSEMBLY_GOLD,
		"yellow" = COLOR_ASSEMBLY_YELLOW,
		"gurkha" = COLOR_ASSEMBLY_GURKHA,
		"light green" = COLOR_ASSEMBLY_LGREEN,
		"green" = COLOR_ASSEMBLY_GREEN,
		"light blue" = COLOR_ASSEMBLY_LBLUE,
		"blue" = COLOR_ASSEMBLY_BLUE,
		"purple" = COLOR_ASSEMBLY_PURPLE,
		"hot pink" = COLOR_ASSEMBLY_HOT_PINK
		)

/obj/item/integrated_electronics/detailer/Initialize()
	update_icon()
	return ..()

/obj/item/integrated_electronics/detailer/update_icon()
	cut_overlays()
	var/mutable_appearance/detail_overlay = mutable_appearance('icons/obj/integrated_electronics/electronic_tools.dmi', "detailer-color")
	detail_overlay.color = detail_color
	add_overlay(detail_overlay)

/obj/item/integrated_electronics/detailer/tgui_state(mob/user)
	return GLOB.tgui_inventory_state

/obj/item/integrated_electronics/detailer/tgui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ICDetailer", name)
		ui.open()

/obj/item/integrated_electronics/detailer/tgui_data(mob/user, datum/tgui/ui, datum/tgui_state/state)
	var/list/data = ..()
	data["detail_color"] = detail_color
	data["color_list"] = color_list
	return data

/obj/item/integrated_electronics/detailer/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
	if(..())
		return TRUE

	switch(action)
		if("change_color")
			if(!(params["color"] in color_list))
				return // to prevent href exploits causing runtimes
			detail_color = color_list[params["color"]]
			update_icon()
			return TRUE

/obj/item/integrated_electronics/detailer/attack_self(mob/user)
	tgui_interact(user)

	// Leaving this commented out in case someone decides that this would be better as an "any color" selection system
	// Just uncomment this and get rid of all of the TGUI bullshit lol
	// if(!in_range(user, src))
	// 	return
	// var/new_color = input(user, "Pick a color", "Color Selection", detail_color) as color|null
	// if(!new_color)
	// 	return
	// detail_color = new_color
	// update_icon()
