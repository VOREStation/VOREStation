/image/motion_echo
	plane = PLANE_FULLSCREEN
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	appearance_flags = (RESET_COLOR|PIXEL_SCALE|KEEP_APART)
	var/list/clients = list()

/image/motion_echo/New(icon, loc, icon_state, layer, dir)
	. = ..()
	QDEL_IN(src, 2 SECONDS)

/image/motion_echo/proc/place_from_root(var/turf/At)
	var/rand_limit = 12
	pixel_x += ((At.x - loc.x) * 32) + rand(-rand_limit,rand_limit)
	pixel_y += ((At.y - loc.y) * 32) + rand(-rand_limit,rand_limit)

/image/motion_echo/proc/append_client(var/datum/weakref/C)
	var/client/CW = C?.resolve()
	if(CW)
		CW.images += src
		clients.Add(C)

/image/motion_echo/Destroy(force)
	. = ..()
	for(var/datum/weakref/C in clients)
		var/client/CW = C?.resolve()
		if(CW)
			CW.images -= src
