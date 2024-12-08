// Overmap object for Sif, hanging in the void of space
/obj/effect/overmap/visitable/planet/Sif
	name = "Sif"
	map_z = list(Z_LEVEL_SURFACE, Z_LEVEL_SURFACE_MINE, Z_LEVEL_SURFACE_WILD)
	in_space = 0
	start_x  = 10
	start_y  = 10
	skybox_offset_x = 128
	skybox_offset_y = 128
	surface_color = "#2D545B"
	mountain_color = "#735555"
	ice_color = "FFFFFF"
	icecaps = "icecaps"
	icon_state = "frozen"

/obj/effect/overmap/visitable/planet/Sif/Initialize()
	atmosphere = new(CELL_VOLUME)
	atmosphere.adjust_gas_temp(GAS_O2, MOLES_O2STANDARD, 273)
	atmosphere.adjust_gas_temp(GAS_N2, MOLES_N2STANDARD, 273)

	. = ..()

/obj/effect/overmap/visitable/planet/Sif/Initialize()
	. = ..()
	docking_codes = null

/obj/effect/overmap/visitable/planet/Sif/get_skybox_representation()
	var/image/tmp = ..()
	tmp.pixel_x = skybox_offset_x
	tmp.pixel_y = skybox_offset_y
	return tmp

/obj/effect/overmap/visitable/Southern_Cross
	name = "Southern Cross"
	icon_state = "object"
	base = 1
	in_space = 1
	start_x =  10
	start_y =  10
	map_z = list(Z_LEVEL_STATION_ONE, Z_LEVEL_STATION_TWO, Z_LEVEL_STATION_THREE)
	extra_z_levels = list(Z_LEVEL_TRANSIT) // Hopefully temporary, so arrivals announcements work.

/obj/effect/overmap/visitable/planet/Sif/Initialize()
	. = ..()
	docking_codes = null
