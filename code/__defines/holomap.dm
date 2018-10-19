//
// Constants and standard colors for the holomap
//

#define WORLD_ICON_SIZE 32	// Size of a standard tile in pixels (world.icon_size)
#define PIXEL_MULTIPLIER WORLD_ICON_SIZE/32	// Convert from normal icon size of 32 to whatever insane thing this server is using.
#define HOLOMAP_ICON 'icons/480x480.dmi' // Icon file to start with when drawing holomaps (to get a 480x480 canvas).
#define HOLOMAP_ICON_SIZE 480 // Pixel width & height of the holomap icon.  Used for auto-centering etc.
#define ui_holomap "CENTER-7, CENTER-7" // Screen location of the holomap "hud"

// Holomap colors
#define HOLOMAP_OBSTACLE	"#FFFFFFDD"	// Color of walls and barriers
#define HOLOMAP_PATH		"#66666699"	// Color of floors
#define HOLOMAP_ROCK		"#66666644"	// Color of mineral walls
#define HOLOMAP_HOLOFIER	"#79FF79"	// Whole map is multiplied by this to give it a green holoish look

#define HOLOMAP_AREACOLOR_COMMAND		"#0000F099"
#define HOLOMAP_AREACOLOR_SECURITY		"#AE121299"
#define HOLOMAP_AREACOLOR_MEDICAL		"#447FC299"
#define HOLOMAP_AREACOLOR_SCIENCE		"#A154A699"
#define HOLOMAP_AREACOLOR_ENGINEERING	"#F1C23199"
#define HOLOMAP_AREACOLOR_CARGO			"#E06F0099"
#define HOLOMAP_AREACOLOR_HALLWAYS		"#FFFFFF66"
#define HOLOMAP_AREACOLOR_ARRIVALS		"#0000FFCC"
#define HOLOMAP_AREACOLOR_ESCAPE		"#FF0000CC"
#define HOLOMAP_AREACOLOR_DORMS			"#CCCC0099"

#define LIST_NUMERIC_SET(L, I, V) if(!L) { L = list(); } if (L.len < I) { L.len = I; } L[I] = V

// Handy defines to lookup the pixel offsets for this Z-level.  Cache these if you use them in a loop tho.
#define HOLOMAP_PIXEL_OFFSET_X(zLevel) ((using_map.holomap_offset_x.len >= zLevel) ? using_map.holomap_offset_x[zLevel] : 0)
#define HOLOMAP_PIXEL_OFFSET_Y(zLevel) ((using_map.holomap_offset_y.len >= zLevel) ? using_map.holomap_offset_y[zLevel] : 0)
#define HOLOMAP_LEGEND_X(zLevel) ((using_map.holomap_legend_x.len >= zLevel) ? using_map.holomap_legend_x[zLevel] : 96)
#define HOLOMAP_LEGEND_Y(zLevel) ((using_map.holomap_legend_y.len >= zLevel) ? using_map.holomap_legend_y[zLevel] : 96)

// VG stuff we probably won't use
// #define HOLOMAP_FILTER_DEATHSQUAD				1
// #define HOLOMAP_FILTER_ERT						2
// #define HOLOMAP_FILTER_NUKEOPS					4
// #define HOLOMAP_FILTER_ELITESYNDICATE			8
// #define HOLOMAP_FILTER_VOX						16
// #define HOLOMAP_FILTER_STATIONMAP				32
// #define HOLOMAP_FILTER_STATIONMAP_STRATEGIC		64//features markers over the captain's office, the armory, the SMES

// #define HOLOMAP_MARKER_SMES				"smes"
// #define HOLOMAP_MARKER_DISK				"diskspawn"
// #define HOLOMAP_MARKER_SKIPJACK			"skipjack"
// #define HOLOMAP_MARKER_SYNDISHUTTLE		"syndishuttle"

#define HOLOMAP_EXTRA_STATIONMAP			"stationmapformatted"
#define HOLOMAP_EXTRA_STATIONMAPAREAS		"stationareas"
#define HOLOMAP_EXTRA_STATIONMAPSMALL		"stationmapsmall"