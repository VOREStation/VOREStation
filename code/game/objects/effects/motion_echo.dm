/image/client_only/motion_echo
	plane = PLANE_FULLSCREEN
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	appearance_flags = (RESET_COLOR|PIXEL_SCALE|KEEP_APART)

/image/client_only/motion_echo/New(icon, loc, icon_state, layer, dir)
	. = ..()
	QDEL_IN(src, 2 SECONDS)
