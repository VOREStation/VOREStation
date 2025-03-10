/obj/effect/overmap/visitable/sector/common_gateway/honlethhighlands
	name = "bluespace shimmer"
	desc = "The shimmering reflection of some sort of bluespace phenomena."
	scanner_desc = @{"It is difficult to tell just what is beyond this strange shimmering shape. The air beyond seems breathable, if very cold."}
	icon = 'icons/obj/overmap_vr.dmi'
	icon_state = "shimmer"
	color = "#171DFF" //bloo
	in_space = 0
	unknown_state = "field"

	skybox_icon = 'icons/skybox/anomaly.dmi'
	skybox_icon_state = "shimmer_b"
	skybox_pixel_x = 0
	skybox_pixel_y = 0


/datum/map_template/common_lateload/gateway/honlethhighlands_a/on_map_loaded(z)
	. = ..()
	new /datum/random_map/automata/cave_system/no_cracks(null, 3, 3, z, world.maxx - 4, world.maxy - 4) // Create the mining Z-level.
	new /datum/random_map/noise/ore(null, 1, 1, z, 64, 64)         // Create the mining ore distribution map.

/datum/map_template/common_lateload/gateway/honlethhighlands_b/on_map_loaded(z)
	. = ..()
	new /datum/random_map/automata/cave_system/no_cracks(null, 3, 3, z, world.maxx - 4, world.maxy - 4) // Create the mining Z-level.
	new /datum/random_map/noise/ore(null, 1, 1, z, 64, 64)         // Create the mining ore distribution map.


//Areas//

/area/gateway/honlethhighlands
	name = "Winterland"
	icon = 'icons/turf/areas_vr.dmi'
	icon_state = "bluwhicir"
	requires_power = TRUE
	dynamic_lighting = TRUE
	flags = RAD_SHIELDED
	base_turf = /turf/simulated/floor/outdoors/newdirt

/area/gateway/honlethhighlands/beach
	name = "frozen beach"

/area/gateway/honlethhighlands/caves
	name = "frozen caves"

/area/gateway/honlethhighlands/gate
	name = "abandoned gateway"
	icon_state = "magwhicir"

/area/gateway/honlethhighlands/town
	icon_state = "bluwhisqu"
	name = "abandoned town"

/area/gateway/honlethhighlands/town/command
	icon_state = "cyawhisqu"
	name = "command"

/area/gateway/honlethhighlands/town/garden
	icon_state = "cyawhisqu"
	name = "garden"

/area/gateway/honlethhighlands/town/xenobio
	icon_state = "cyawhisqu"
	name = "xenobio"

/area/gateway/honlethhighlands/town/bar
	icon_state = "cyawhisqu"
	name = "bar"

/area/gateway/honlethhighlands/town/supply
	icon_state = "cyawhisqu"
	name = "supply"

/area/gateway/honlethhighlands/town/engineering
	icon_state = "cyawhisqu"
	name = "engineering"

/area/gateway/honlethhighlands/town/kitchen
	icon_state = "cyawhisqu"
	name = "kitchen"
