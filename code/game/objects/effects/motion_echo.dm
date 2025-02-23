/obj/effect/abstract/motion_echo
	name = ""
	icon =  'icons/effects/effects.dmi'
	icon_state = "motion_echo"
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	appearance_flags = (RESET_COLOR|PIXEL_SCALE|KEEP_APART)
	plane = PLANE_MOTIONTRACKER
	layer = OBFUSCATION_LAYER

/obj/effect/abstract/motion_echo/Initialize(mapload)
	. = ..()
	var/rand_limit = 12
	pixel_x += rand(-rand_limit,rand_limit)
	pixel_y += rand(-rand_limit,rand_limit)
	QDEL_IN(src, 2 SECONDS)
