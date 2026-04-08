/image/client_only/motion_echo
	plane = PLANE_FULLSCREEN
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	appearance_flags = (RESET_COLOR|PIXEL_SCALE|KEEP_APART)

/image/client_only/motion_echo/New(icon, loc, icon_state, layer, dir)
	. = ..()
	QDEL_IN(src, 2 SECONDS)

/image/client_only/motion_echo/place_from_root(var/turf/At)
	. = ..()
	var/rand_limit = 12
	pixel_x += rand(-rand_limit,rand_limit)
	pixel_y += rand(-rand_limit,rand_limit)
