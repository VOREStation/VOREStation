/obj/structure/window/reinforced/full/holiday/Initialize(mapload, start_dir, constructed)
	var/pattern = PATTERN_VERTICAL_STRIPE
	color = request_decoration_colors(src, pattern)
	return ..()
