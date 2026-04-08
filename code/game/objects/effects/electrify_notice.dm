/image/client_only/electrify_notice
	plane = PLANE_FULLSCREEN
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	appearance_flags = (RESET_COLOR|PIXEL_SCALE|KEEP_APART)

/image/client_only/electrify_notice/New(icon, loc, icon_state, layer, dir)
	. = ..()
	QDEL_IN(src, 1 SECOND)

/image/client_only/electrify_notice/place_from_root(var/turf/At)
	. = ..()
	pixel_y += 8
	animate(src, pixel_y = 32, alpha = 0, time = 1 SECOND)
