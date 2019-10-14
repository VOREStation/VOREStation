/obj/machinery/power/apc/proc/update_area()
	var/area/NA = get_area(src)
	if(!(NA == area))
		if(area.apc == src)
			area.apc = null
		NA.apc = src
		area = NA
		name = "[area.name] APC"
	update()