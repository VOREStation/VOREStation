/proc/get_overmap_sector(var/z)
	if(GLOB.using_map.use_overmap)
		return GLOB.map_sectors["[z]"]
	else
		return null
