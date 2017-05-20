//
// An enhancement to /datum/map to store more and better meta-info about Z-levels
//

// Structure to hold zlevel info together in one nice convenient package.
// Wouldn't this be nicer than having to do those dumb arrays?
/datum/map_z_level
	var/name					// Friendly name of the zlevel
	var/z = -1					// Actual z-index of the zlevel. This had better be right!
	var/holomap_offset_x = 0	// Number of pixels to offset right (for centering)
	var/holomap_offset_y = 0	// Number of pixels to offset up (for centering)
	var/holomap_legend_x = 96	// x position of the holomap legend for this z
	var/holomap_legend_y = 96	// y position of the holomap legend for this z

/datum/map_z_level/New(z, name, holomap_zoom = initial(holomap_zoom), holomap_offset_x = initial(holomap_offset_x), holomap_offset_y = initial(holomap_offset_y))
	src.z = z
	src.name = name
	src.holomap_offset_x = holomap_offset_x
	src.holomap_offset_y = holomap_offset_y

// Map datum stuff we need
// TODO - Put this into ~map_system/maps.dm
/datum/map
	var/list/zlevels = list()

// LEGACY - This is how /vg does it, and how the code uses it. I'm in transition to use my new way (above)
// but for now lets just initialize this stuff so the code works.
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
