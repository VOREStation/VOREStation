//Special map objects
/obj/effect/landmark/map_data/virgo3b
    height = 7

/obj/turbolift_map_holder/tether
	name = "Tether Climber"
	depth = 3
	lift_size_x = 4
	lift_size_y = 4
	icon = 'icons/obj/turbolift_preview_5x5.dmi'

	areas_to_use = list(
		/area/turbolift/tether/surface,
		/area/turbolift/tether/transit,
		/area/turbolift/tether/space
		)

/obj/turbolift_map_holder/t_surface
	name = "Surface Turbolift"
	depth = 3
	lift_size_x = 4
	lift_size_y = 4
	icon = 'icons/obj/turbolift_preview_5x5.dmi'

	areas_to_use = list(
		/area/turbolift/t_surface/level1,
		/area/turbolift/t_surface/level2,
		/area/turbolift/t_surface/level3
		)

/obj/turbolift_map_holder/t_station
	name = "Station turbolift"
	depth = 3
	lift_size_x = 4
	lift_size_y = 4
	icon = 'icons/obj/turbolift_preview_5x5.dmi'

	areas_to_use = list(
		/area/turbolift/t_station/level1,
		/area/turbolift/t_station/level2,
		/area/turbolift/t_station/level3
		)
