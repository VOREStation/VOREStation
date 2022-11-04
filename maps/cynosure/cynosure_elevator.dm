/obj/turbolift_map_holder/cynosure
	icon = 'icons/obj/turbolift_preview_5x5.dmi'
	depth = 2
	lift_size_x = 4
	lift_size_y = 4

/obj/turbolift_map_holder/cynosure/west
	name = "Cynosure turbolift map placeholder - West"
	dir = EAST
	depth = 3

	areas_to_use = list(
		/area/turbolift/west_bmt,
		/area/turbolift/west_gnd,
		/area/turbolift/west_snd
		)

/obj/turbolift_map_holder/cynosure/center
	icon = 'icons/obj/turbolift_preview_3x3.dmi'
	name = "Cynosure turbolift map placeholder - Center"
	dir = WEST
	lift_size_x = 3
	lift_size_y = 3

	areas_to_use = list(
		/area/turbolift/center_gnd,
		/area/turbolift/center_snd
		)

/obj/turbolift_map_holder/cynosure/cargo
	name = "Cynosure turbolift map placeholder - Cargo"
	dir = WEST

	areas_to_use = list(
		/area/turbolift/cargo_gnd,
		/area/turbolift/cargo_snd
		)

/obj/turbolift_map_holder/cynosure/engineering
	name = "Cynosure turbolift map placeholder - Engineering"
	dir = SOUTH
	depth = 3

	areas_to_use = list(
		/area/turbolift/eng_bmt,
		/area/turbolift/eng_gnd,
		/area/turbolift/eng_snd
		)

/obj/turbolift_map_holder/cynosure/medbay
	icon = 'icons/obj/turbolift_preview_3x3.dmi'
	name = "Cynosure turbolift map placeholder - Medbay"
	dir = EAST
	depth = 3
	lift_size_x = 3
	lift_size_y = 3

	areas_to_use = list(
		/area/turbolift/med_bmt,
		/area/turbolift/med_gnd,
		/area/turbolift/med_snd
		)

/obj/turbolift_map_holder/cynosure/sci
	name = "Cynosure turbolift map placeholder - Science"
	dir = EAST

	areas_to_use = list(
		/area/turbolift/sci_bmt,
		/area/turbolift/sci_gnd
		)

/obj/turbolift_map_holder/cynosure/sec
	icon = 'icons/obj/turbolift_preview_3x3.dmi'
	name = "Cynosure turbolift map placeholder - Security"
	dir = NORTH
	lift_size_x = 3
	lift_size_y = 3

	areas_to_use = list(
		/area/turbolift/sec_gnd,
		/area/turbolift/sec_snd
		)