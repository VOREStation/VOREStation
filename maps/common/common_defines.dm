// Z_LEVEL are just hard coded z-levels
// Z_NAME are late loaded z-level maps that can be looked up in GLOB.map_templates_loaded
// GLOB.map_templates_loaded is populated as /datum/map_template/proc/on_map_preload(z) is called
// Some Z_NAME ultimately will be indexed under an alias however e.g. Z_NAME_ALIAS_GATEWAY

// Tether
#define Z_LEVEL_TETHER_SURFACE_LOW			1
#define Z_LEVEL_TETHER_SURFACE_MID			2
#define Z_LEVEL_TETHER_SURFACE_HIGH			3
#define Z_LEVEL_TETHER_TRANSIT				4
#define Z_LEVEL_TETHER_SPACE_LOW			5
#define Z_LEVEL_TETHER_SURFACE_MINE			6
#define Z_LEVEL_TETHER_SOLARS				7

#define Z_NAME_TETHER_CENTCOM				"Tether - Centcom" // Aliased to Z_NAME_ALIAS_CENTCOM
#define Z_NAME_TETHER_MISC					"Tether - Misc" // Aliased to Z_NAME_ALIAS_MISC
#define Z_NAME_TETHER_UNDERDARK				"Tether - Underdark"
#define Z_NAME_TETHER_PLAINS				"Tether - Plains"
#define Z_NAME_TETHER_ROGUEMINE_1			"Asteroid Belt 1"
#define Z_NAME_TETHER_ROGUEMINE_2			"Asteroid Belt 2"

// Stellar Delight
#define Z_LEVEL_SHIP_LOW					1
#define Z_LEVEL_SHIP_MID					2
#define Z_LEVEL_SHIP_HIGH					3

#define Z_NAME_SHIP_CENTCOM					"Ship - Central Command" // Aliased to Z_NAME_ALIAS_CENTCOM
#define Z_NAME_SHIP_MISC					"Ship - Misc" // Aliased to Z_NAME_ALIAS_MISC
#define Z_NAME_SPACE_ROCKS					"V3b Asteroid Field"
#define Z_NAME_OVERMAP						"Overmap"

// Groundbase
#define Z_LEVEL_GB_BOTTOM					1
#define Z_LEVEL_GB_MIDDLE					2
#define Z_LEVEL_GB_TOP						3

#define Z_NAME_GB_WILDS_N1					"Northern Wilds 1"
#define Z_NAME_GB_WILDS_N2					"Northern Wilds 2"
#define Z_NAME_GB_WILDS_S1					"Southern Wilds 1"
#define Z_NAME_GB_WILDS_S2					"Southern Wilds 2"
#define Z_NAME_GB_WILDS_S3					"Southern Wilds 3"
#define Z_NAME_GB_WILDS_E1					"Eastern Wilds 1"
#define Z_NAME_GB_WILDS_E2					"Eastern Wilds 2"
#define Z_NAME_GB_WILDS_W1					"Western Wilds 1"
#define Z_NAME_GB_WILDS_W2					"Western Wilds 2"

#define Z_NAME_GB_CENTCOM					"Groundbase - Central Command" // Aliased to Z_NAME_ALIAS_CENTCOM
#define Z_NAME_GB_MISC						"Groundbase - Misc" // Aliased to Z_NAME_ALIAS_MISC
#define Z_NAME_GB_MINING					"V3c Underground"

#define Z_NAME_ALIAS_GB_WILDS_N				"GB WILDS NORTH"
#define Z_NAME_ALIAS_GB_WILDS_S				"GB WILDS SOUTH"
#define Z_NAME_ALIAS_GB_WILDS_E				"GB WILDS EAST"
#define Z_NAME_ALIAS_GB_WILDS_W				"GB WILDS WEST"

// Common
#define Z_NAME_OFFMAP1						"Offmap Ship - Talon V2"
#define Z_NAME_AEROSTAT						"Remmi Aerostat - Z1 Aerostat"
#define Z_NAME_AEROSTAT_SURFACE				"Remmi Aerostat - Z2 Surface"
#define Z_NAME_DEBRISFIELD					"Debris Field - Z1 Space"
#define Z_NAME_FUELDEPOT					"Fuel Depot - Z1 Space"
#define Z_NAME_BEACH						"Desert Planet - Z1 Beach"
#define Z_NAME_BEACH_CAVE					"Desert Planet - Z2 Cave"

#define Z_NAME_ALIAS_GATEWAY				"GATEWAY"
#define Z_NAME_ALIAS_OM_ADVENTURE			"OVERMAP ADVENTURE"
#define Z_NAME_ALIAS_REDGATE				"REDGATE"
#define Z_NAME_ALIAS_CENTCOM				"CENTRAL COMMAND"
#define Z_NAME_ALIAS_MISC					"MISC"

// Gateways (Aliased to Z_NAME_ALIAS_GATEWAY)
#define Z_NAME_GATEWAY_CARP_FARM			"Gateway - Carp Farm"
#define Z_NAME_GATEWAY_SNOW_FIELD			"Gateway - Snow Field"
#define Z_NAME_GATEWAY_LISTENING_POST		"Gateway - Listening Post"
#define Z_NAME_GATEWAY_HONLETH_A			"Gateway - Honleth Highlands A"
#define Z_NAME_GATEWAY_HONLETH_B			"Gateway - Honleth Highlands B"
#define Z_NAME_GATEWAY_ARYNTHI_CAVE_A		"Gateway - Arynthi Lake Underground A"
#define Z_NAME_GATEWAY_ARYNTHI_A			"Gateway - Arynthi Lake A"
#define Z_NAME_GATEWAY_ARYNTHI_CAVE_B		"Gateway - Arynthi Lake Underground B"
#define Z_NAME_GATEWAY_ARYNTHI_B			"Gateway - Arynthi Lake B"
#define Z_NAME_GATEWAY_WILD_WEST			"Gateway - Wild West"

// Overmap Adventures (Aliased to Z_NAME_ALIAS_OM_ADVENTURE)
#define Z_NAME_OM_GRASS_CAVE				"Grass Cave"

// Redgates (Aliased to Z_NAME_ALIAS_REDGATE)
#define Z_NAME_REDGATE_TEPPI_RANCH			"Redgate - Teppi Ranch"
#define Z_NAME_REDGATE_INNLAND				"Redgate - Innland"
#define Z_NAME_REDGATE_ABANDONED_ISLAND		"Redgate - Abandoned Island" // Commented out currently
#define Z_NAME_REDGATE_DARK_ADVENTURE		"Redgate - Dark Adventure"
#define Z_NAME_REDGATE_EGGNOG_CAVE			"Redgate - Eggnog Town Underground"
#define Z_NAME_REDGATE_EGGNOG_TOWN			"Redgate - Eggnog Town"
#define Z_NAME_REDGATE_STAR_DOG				"Redgate - Star Dog"
#define Z_NAME_REDGATE_HOTSPRINGS			"Redgate - Hotsprings"
#define Z_NAME_REDGATE_RAIN_CITY			"Redgate - Rain City"
#define Z_NAME_REDGATE_ISLANDS_UNDERWATER	"Redgate - Islands Underwater"
#define Z_NAME_REDGATE_ISLANDS				"Redgate - Islands"
#define Z_NAME_REDGATE_MOVING_TRAIN			"Redgate - Moving Train"
#define Z_NAME_REDGATE_MOVING_TRAIN_UPPER	"Redgate - Moving Train Upper Level"
#define Z_NAME_REDGATE_FANTASY_DUNGEON		"Redgate - Fantasy Dungeon"
#define Z_NAME_REDGATE_FANTASY_TOWN			"Redgate - Fantasy Town"
#define Z_NAME_REDGATE_LASERDOME			"Redgate - Laserdome"
#define Z_NAME_REDGATE_CASCADING_FALLS		"Redgate - Cascading Falls"
#define Z_NAME_REDGATE_JUNGLE_CAVE			"Redgate - Jungle Underground"
#define Z_NAME_REDGATE_JUNGLE				"Redgate - Jungle"
#define Z_NAME_REDGATE_FACILITY				"Redgate - Facility"

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

	mob_announce_cooldown = 0

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
	levels_for_distress = list(Z_NAME_OFFMAP1, Z_NAME_BEACH, Z_NAME_AEROSTAT, Z_NAME_DEBRISFIELD, Z_NAME_FUELDEPOT)
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

	extra_z_levels = list(Z_NAME_AEROSTAT_SURFACE)
