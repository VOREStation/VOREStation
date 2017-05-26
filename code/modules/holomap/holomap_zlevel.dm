//
// TODO - Remove this temporary hack and convert to using the new /datum/map_z_level system
//
/datum/map
	var/list/holomap_smoosh		// List of lists of zlevels to smoosh into single icons
	var/list/holomap_offset_x = list()
	var/list/holomap_offset_y = list()
	var/list/holomap_legend_x = list()
	var/list/holomap_legend_y = list()

/datum/map/New()
	..()
	// Auto-calculate any missing holomap offsets to center them, assuming they are full sized maps.
	for(var/i in (holomap_offset_x.len + 1) to world.maxx)
		holomap_offset_x += ((480 - world.maxx) / 2)
	for(var/i in (holomap_offset_y.len + 1) to world.maxy)
		holomap_offset_y += ((480 - world.maxy) / 2)
	for(var/z in 1 to world.maxz)
		holomap_legend_x += 96
		holomap_legend_y += 96
