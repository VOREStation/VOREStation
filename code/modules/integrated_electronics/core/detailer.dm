/obj/item/device/integrated_electronics/detailer
	name = "assembly detailer"
	desc = "A combination autopainter and flash anodizer designed to give electronic assemblies a colorful, wear-resistant finish."
	icon = 'icons/obj/integrated_electronics/electronic_tools.dmi'
	icon_state = "detailer"
	item_flags = NOBLUDGEON
	w_class = ITEMSIZE_SMALL
	var/detail_color = COLOR_ASSEMBLY_WHITE
	var/list/color_list = list(
		"black" = COLOR_ASSEMBLY_BLACK,
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

/obj/item/device/integrated_electronics/detailer/Initialize()
	update_icon()
	return ..()

/obj/item/device/integrated_electronics/detailer/update_icon()
	cut_overlays()
	var/mutable_appearance/detail_overlay = mutable_appearance('icons/obj/integrated_electronics/electronic_tools.dmi', "detailer-color")
	detail_overlay.color = detail_color
	add_overlay(detail_overlay)

/obj/item/device/integrated_electronics/detailer/attack_self(mob/user)
	var/color_choice = input(user, "Select color.", "Assembly Detailer", detail_color) as null|anything in color_list
	if(!color_list[color_choice])
		return
	if(!in_range(src, user))
		return
	detail_color = color_list[color_choice]
	update_icon()
