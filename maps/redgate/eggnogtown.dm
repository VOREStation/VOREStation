/obj/effect/overmap/visitable/sector/common_gateway/eggnogtown
	name = "bluespace shimmer"
	desc = "The shimmering reflection of some sort of bluespace phenomena."
	scanner_desc = @{"It is difficult to tell just what is beyond this strange shimmering shape. The air beyond seems breathable, if cold."}
	icon = 'icons/obj/overmap_vr.dmi'
	icon_state = "shimmer"
	color = "#171DFF" //bloo
	in_space = 0

	skybox_icon = 'icons/skybox/anomaly.dmi'
	skybox_icon_state = "shimmer_b"
	skybox_pixel_x = 0
	skybox_pixel_y = 0
/*
/datum/map_template/common_lateload/gateway/eggnogtown/on_map_loaded(z)
	. = ..()
	new /datum/random_map/automata/cave_system/no_cracks(null, 3, 3, z, world.maxx - 4, world.maxy - 4) // Create the mining Z-level.
	new /datum/random_map/noise/ore(null, 1, 1, z, 64, 64)		// Create the mining ore distribution map.

/datum/map_template/common_lateload/gateway/eggnogtownunderground/on_map_loaded(z)
	. = ..()
	new /datum/random_map/automata/cave_system/no_cracks(null, 3, 3, z, world.maxx - 4, world.maxy - 4) // Create the mining Z-level.
	new /datum/random_map/noise/ore(null, 1, 1, z, 64, 64)		// Create the mining ore distribution map.
*/

/obj/effect/landmark/map_data/eggnogtown
	height = 2

//Areas//

/area/redgate/eggnogtown
	name = "Eggnog Town"
	icon = 'icons/turf/areas_vr.dmi'
	icon_state = "purwhicir"
	requires_power = FALSE
	dynamic_lighting = TRUE
	flags = RAD_SHIELDED
	base_turf = /turf/simulated/floor/outdoors/newdirt


/area/redgate/eggnogtown/telecomms
	name = "Eggnog Town Telecomms"
	icon_state = "cyawhisqu"

/area/redgate/eggnogtown/bar
	name = "Heart's Hearth Bar"
	icon_state = "cyawhisqu"

/area/redgate/eggnogtown/hall
	name = "Eggnog Town Event Hall"
	icon_state = "cyawhisqu"
/area/redgate/eggnogtown/hall/north
	name = "Eggnog Town Event Hall north"
	icon_state = "cyawhisqu"
/area/redgate/eggnogtown/hall/south
	name = "Eggnog Town Event Hall south"
	icon_state = "cyawhisqu"

/area/redgate/eggnogtown/dining
	name = "Eggnog Town Dining Hall"
	icon_state = "cyawhisqu"
/area/redgate/eggnogtown/dining/kitchen
	name = "Eggnog Town Dining Hall Kitchen"
	icon_state = "cyawhisqu"
/area/redgate/eggnogtown/dining/botany
	name = "Eggnog Town Dining Hall Botany"
	icon_state = "cyawhisqu"
/area/redgate/eggnogtown/dining/storage
	name = "Eggnog Town Dining Hall Storage"
	icon_state = "cyawhisqu"

/area/redgate/eggnogtown/storage
	name = "Eggnog Town Storage Shed"
	icon_state = "cyawhisqu"

/area/redgate/eggnogtown/visitorlounge
	name = "Eggnog Town Visitor Lounge"
	icon_state = "cyawhisqu"
/area/redgate/eggnogtown/visitorlounge/room1
	name = "Eggnog Town Visitor Lounge Room 1"
/area/redgate/eggnogtown/visitorlounge/room2
	name = "Eggnog Town Visitor Lounge Room 2"

/area/redgate/eggnogtown/houserhomestead
	name = "Houser Homestead"
	icon_state = "redwhisqu"
/area/redgate/eggnogtown/houserhomestead/basement
	name = "Houser Homestead Basement"

/area/redgate/eggnogtown/teshnest
	name = "Je'rehi's Nest"
	icon_state = "redwhisqu"

/area/redgate/eggnogtown/arturoswolfden
	name = "Arturo's Wolf Den"
	icon_state = "redwhisqu"

/area/redgate/eggnogtown/kitchihome
	name = "Kitchi's House"
	icon_state = "redwhisqu"
/area/redgate/eggnogtown/kitchihome/bedroom
	name = "Kitchi's Bedroom"
/area/redgate/eggnogtown/kitchihome/kitchen
	name = "Kitchi's Kitchen"
/area/redgate/eggnogtown/kitchihome/diningroom
	name = "Kitchi's Dining Room"
/area/redgate/eggnogtown/kitchihome/guestroom
	name = "Kitchi's Guest Room"
/area/redgate/eggnogtown/kitchihome/den
	name = "Kitchi's House's Den"

/area/redgate/eggnogtown/alipad
	name = "Ali's Kickass Pad of Awesomeness"
	icon_state = "redwhisqu"
/area/redgate/eggnogtown/alipad/bedroom
	name = "Ali's Bedroom"

/area/redgate/eggnogtown/loniabode
	name = "Loni Nesumi's Humble Abode"
	icon_state = "redwhisqu"

/area/redgate/eggnogtown/vibeout
	name = "Voided Vibeout"
	icon_state = "redwhisqu"
/area/redgate/eggnogtown/vibeout/underground
	name = "Voided Vibeout Underground"

/area/redgate/eggnogtown/stokeswashere
	name = "Underground Sneakzone"
	icon_state = "redwhisqu"
/area/redgate/eggnogtown/stokeswashere/bathroom
	name = "Underground Sneakzone Bathroom"
/area/redgate/eggnogtown/stokeswashere/bedroom
	name = "Underground Sneakzone Bedroom"

/area/redgate/eggnogtown/cavehome
	name = "Cave Home"
	icon_state = "redwhisqu"
/area/redgate/eggnogtown/cavehome/office
	name = "Cave Home Office"
/area/redgate/eggnogtown/cavehome/bedroom
	name = "Cave Home Bedroom"

/area/redgate/eggnogtown/sigloo
	name = "Southern Igloo"
	icon_state = "cyawhisqu"

/area/redgate/eggnogtown/nigloo
	name = "Northern Igloo"
	icon_state = "redwhisqu"

/area/redgate/eggnogtown/eastcaveland
	name = "Cave Lounge"
	icon_state = "redwhisqu"

/area/redgate/eggnogtown/hotspring
	name = "Eggnog Town Hotspring"
	icon_state = "redwhisqu"

/area/redgate/eggnogtown/caves
	name = "caves"
	icon_state = "purblacir"

/area/redgate/eggnogtown/underground
	name = "underground"
	icon_state = "purblacir"

/area/redgate/eggnogtown/hotsprings
	name = "Eggnog Town Hotsprings"
	icon_state = "cyawhisqu"

/area/redgate/eggnogtown/greenhouse
	name = "Eggnog Town Greenhouse"
	icon_state = "cyawhisqu"
