/obj/effect/overmap/visitable/sector/common_gateway/arynthilake
	name = "bluespace shimmer"
	desc = "The shimmering reflection of some sort of bluespace phenomena."
	scanner_desc = @{"It is difficult to tell just what is beyond this strange shimmering shape. The air beyond seems breathable."}
	icon = 'icons/obj/overmap_vr.dmi'
	icon_state = "shimmer"
	color = "#171DFF" //bloo
	in_space = 0
	unknown_state = "field"
	known = FALSE

	skybox_icon = 'icons/skybox/anomaly.dmi'
	skybox_icon_state = "shimmer_b"
	skybox_pixel_x = 0
	skybox_pixel_y = 0


/datum/map_template/common_lateload/gateway/arynthilake/on_map_loaded(z)
	. = ..()
	new /datum/random_map/automata/cave_system/no_cracks(null, 3, 3, z, world.maxx - 4, world.maxy - 4) // Create the mining Z-level.
	new /datum/random_map/noise/ore(null, 1, 1, z, 64, 64)		// Create the mining ore distribution map.

/datum/map_template/common_lateload/gateway/arynthilakeunderground/on_map_loaded(z)
	. = ..()
	new /datum/random_map/automata/cave_system/no_cracks(null, 3, 3, z, world.maxx - 4, world.maxy - 4) // Create the mining Z-level.
	new /datum/random_map/noise/ore(null, 1, 1, z, 64, 64)		// Create the mining ore distribution map.

/datum/map_template/common_lateload/gateway/arynthilake_b/on_map_loaded(z)
	. = ..()
	new /datum/random_map/automata/cave_system/no_cracks(null, 3, 3, z, world.maxx - 4, world.maxy - 4) // Create the mining Z-level.
	new /datum/random_map/noise/ore(null, 1, 1, z, 64, 64)		// Create the mining ore distribution map.

/datum/map_template/common_lateload/gateway/arynthilakeunderground_b/on_map_loaded(z)
	. = ..()
	new /datum/random_map/automata/cave_system/no_cracks(null, 3, 3, z, world.maxx - 4, world.maxy - 4) // Create the mining Z-level.
	new /datum/random_map/noise/ore(null, 1, 1, z, 64, 64)		// Create the mining ore distribution map.


/obj/effect/landmark/map_data/arynthilake
	height = 2


//Areas//

/area/gateway/arynthilake
	name = "Arynthi Lake"
	icon = 'icons/turf/areas_vr.dmi'
	icon_state = "bluwhicir"
	requires_power = TRUE
	dynamic_lighting = TRUE
	flags = RAD_SHIELDED
	base_turf = /turf/simulated/floor/outdoors/newdirt

/area/gateway/arynthilake/dome
	name = "Dome Power Grid"
	icon_state = "cyawhisqu"

/area/gateway/arynthilake/caves
	name = "caves"
	icon_state = "purblacir"

/area/gateway/arynthilake/gateway
	name = "gateway"
	icon_state = "cyawhisqu"

/area/gateway/arynthilake/caveruins
	icon_state = "cyawhisqu"

/area/gateway/arynthilake/oldcabin
	icon_state = "cyawhisqu"

/area/gateway/arynthilake/engine
	name = "Power Plant"
	icon_state = "orawhisqu"

/area/gateway/arynthilake/underground
	icon_state = "purblacir"

/area/gateway/arynthilake/underground/maintenance
	name = "Underground Maintenance"
	icon_state = "bluwhisqu"

/area/gateway/arynthilake/underground/intocave
	icon_state = "redwhisqu"

/obj/item/paper/gateway/arynthilake
	name = "Maintenance Tunnel Notes"
	info = "<font size=15><b>Please be advised</b></font><p>Beyond this point the underground maintenance tunnels are dangerous. Monsters have taken to making their nests in the tunnels. As such we have installed an automatic defense system.</p><p>The turrets and supply caches in the tunnels are powered by this facility. Should there be undesired creatures or personnel in the tunnels, the turrets exist to keep them clear.</p><p>The turret control system is situated within the local administration building. It is advised that you never enter the tunnels outside of regulatly scheduled maintenance windows, and never without secturity escort.</p><p>If you should need to enter the tunnels outside of regularly scheduled maintenance windows, it is advised that you contact the administration building to disable the turrets, and when you are done, contact them again to re-enable them.</p><p>Your safety is important to us. Should you end up within the tunnels when dangerous entities are present, it is advised to seek out the supply caches scattered throughout. Survival equipment can be obtained from within.</p>"