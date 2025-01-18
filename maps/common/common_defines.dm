// Tether
#define Z_LEVEL_SURFACE_LOW					1
#define Z_LEVEL_SURFACE_MID					2
#define Z_LEVEL_SURFACE_HIGH				3
#define Z_LEVEL_TRANSIT						4
#define Z_LEVEL_SPACE_LOW					5
#define Z_LEVEL_SURFACE_MINE				6
#define Z_LEVEL_SOLARS						7
#define Z_LEVEL_UNDERDARK					21
#define Z_LEVEL_PLAINS						22
#define Z_LEVEL_ROGUEMINE_1					23
#define Z_LEVEL_ROGUEMINE_2					24

// Stellar Delight
#define Z_LEVEL_SHIP_LOW					1
#define Z_LEVEL_SHIP_MID					2
#define Z_LEVEL_SHIP_HIGH					3
#define Z_LEVEL_OVERMAP						4
#define Z_LEVEL_SPACE_ROCKS					5

// Groundbase
#define Z_LEVEL_GB_BOTTOM  					1
#define Z_LEVEL_GB_MIDDLE  					2
#define Z_LEVEL_GB_TOP     					3
#define Z_LEVEL_GB_WILD_N  					4
#define Z_LEVEL_GB_WILD_S  					5
#define Z_LEVEL_GB_WILD_E  					6
#define Z_LEVEL_GB_WILD_W  					7

// Common
#define Z_LEVEL_CENTCOM						8
#define Z_LEVEL_MISC						9
#define Z_LEVEL_OFFMAP1						10
#define Z_LEVEL_AEROSTAT					11
#define Z_LEVEL_AEROSTAT_SURFACE			12
#define Z_LEVEL_DEBRISFIELD					13
#define Z_LEVEL_FUELDEPOT					14
#define Z_LEVEL_GATEWAY						15
#define Z_LEVEL_OM_ADVENTURE				16
#define Z_LEVEL_REDGATE						17
#define Z_LEVEL_BEACH						18
#define Z_LEVEL_BEACH_CAVE					19
#define Z_LEVEL_MINING						20

//Camera networks
#define NETWORK_TETHER "Tether"
#define NETWORK_OUTSIDE "Outside"
#define NETWORK_HALLS "Halls"

/obj/effect/landmark/map_data/groundbase
	height = 3

/obj/effect/landmark/map_data/stellar_delight
	height = 3

/obj/effect/overmap/visitable/sector/virgo3b
	name = "Virgo 3B"
	desc = "Full of phoron, and home to the NSB Adephagia."
	scanner_desc = @{"[i]Registration[/i]: NSB Adephagia
[i]Class[/i]: Installation
[i]Transponder[/i]: Transmitting (CIV), NanoTrasen IFF
[b]Notice[/b]: NanoTrasen Base, authorized personnel only"}

	icon = 'icons/obj/overmap_vr.dmi'
	icon_state = "virgo3b"

	skybox_icon = 'icons/skybox/virgo3b.dmi'
	skybox_icon_state = "small"
	skybox_pixel_x = 0
	skybox_pixel_y = 0

	var/mob_announce_cooldown = 0

/obj/effect/overmap/visitable/sector/virgo3c
	name = "Virgo 3C"
	desc = "A small, volcanically active moon."
	scanner_desc = @{"[i]Registration[/i]: NSB Rascal's Pass
[i]Class[/i]: Installation
[i]Transponder[/i]: Transmitting (CIV), NanoTrasen IFF
[b]Notice[/b]: NanoTrasen Base, authorized personnel only"}
	known = TRUE
	in_space = TRUE

	icon = 'icons/obj/overmap.dmi'
	icon_state = "lush"

	skybox_icon = null
	skybox_icon_state = null
	skybox_pixel_x = 0
	skybox_pixel_y = 0

	initial_generic_waypoints = list("groundbase", "gb_excursion_pad","omship_axolotl")
	initial_restricted_waypoints = list()

	extra_z_levels = list(
		Z_LEVEL_MINING,
		Z_LEVEL_GB_WILD_N,
		Z_LEVEL_GB_WILD_S,
		Z_LEVEL_GB_WILD_E,
		Z_LEVEL_GB_WILD_W
		)

/obj/effect/overmap/visitable/ship/stellar_delight
	name = "NRV Stellar Delight"
	icon = 'icons/obj/overmap_vr.dmi'
	icon_state = "stellar_delight_g"
	desc = "Spacefaring vessel. Friendly IFF detected."
	scanner_desc = @{"[i]Registration[/i]: NRV Stellar Delight
[i]Class[/i]: Nanotrasen Response Vessel
[i]Transponder[/i]: Transmitting (CIV), non-hostile"
[b]Notice[/b]: A response vessel registered to Nanotrasen."}
	vessel_mass = 25000
	vessel_size = SHIP_SIZE_LARGE
	initial_generic_waypoints = list("starboard_shuttlepad","port_shuttlepad","sd-1-23-54","sd-1-67-15","sd-1-70-130","sd-1-115-85","sd-2-25-98","sd-2-117-98","sd-3-22-78","sd-3-36-33","sd-3-104-33","sd-3-120-78")
	initial_restricted_waypoints = list("Exploration Shuttle" = list("sd_explo"), "Mining Shuttle" = list("sd_mining"))
	levels_for_distress = list(Z_LEVEL_OFFMAP1, Z_LEVEL_BEACH, Z_LEVEL_AEROSTAT, Z_LEVEL_DEBRISFIELD, Z_LEVEL_FUELDEPOT)
	unowned_areas = list(/area/shuttle/sdboat)
	known = TRUE
	start_x = 2
	start_y = 2

	fore_dir = NORTH

	skybox_icon = 'maps/stellar_delight/stelardelightskybox.dmi'
	skybox_icon_state = "skybox"
	skybox_pixel_x = 450
	skybox_pixel_y = 200

/obj/effect/overmap/visitable/sector/virgo2
	name = "Virgo 2"
	desc = "Includes the Remmi Aerostat and associated ground mining complexes."
	scanner_desc = @{"[i]Stellar Body[/i]: Virgo 2
[i]Class[/i]: R-Class Planet
[i]Habitability[/i]: Low (High Temperature, Toxic Atmosphere)
[b]Notice[/b]: Planetary environment not suitable for life. Landing may be hazardous."}
	icon_state = "globe"
	in_space = 0
	known = TRUE
	icon_state = "chlorine"

	skybox_icon = 'icons/skybox/virgo2.dmi'
	skybox_icon_state = "v2"
	skybox_pixel_x = 0
	skybox_pixel_y = 0

	extra_z_levels = list(Z_LEVEL_AEROSTAT_SURFACE)
