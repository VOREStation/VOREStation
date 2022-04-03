// Z-level flags bitfield - Set these flags to determine the z level's purpose
#define MAP_LEVEL_STATION		0x001 // Z-levels the station exists on
#define MAP_LEVEL_ADMIN			0x002 // Z-levels for admin functionality (Centcom, shuttle transit, etc)
#define MAP_LEVEL_CONTACT		0x004 // Z-levels that can be contacted from the station, for eg announcements
#define MAP_LEVEL_PLAYER		0x008 // Z-levels a character can typically reach
#define MAP_LEVEL_SEALED		0x010 // Z-levels that don't allow random transit at edge
#define MAP_LEVEL_EMPTY			0x020 // Empty Z-levels that may be used for various things (currently used by bluespace jump)
#define MAP_LEVEL_CONSOLES		0x040 // Z-levels available to various consoles, such as the crew monitor (when that gets coded in). Defaults to station_levels if unset.
#define MAP_LEVEL_XENOARCH_EXEMPT 0x080	// Z-levels exempt from xenoarch digsite generation.
#define MAP_LEVEL_PERSIST       0x100   // Z-levels where SSpersistence should persist between rounds
#define MAP_LEVEL_MAPPABLE       0x200   // Z-levels where mapping units will work fully
<<<<<<< HEAD
#define MAP_LEVEL_BELOW_BLOCKED   0x400   // Z-levels in multiz with level below not meant to be 'normally' accessible
=======
#define MAP_LEVEL_UNDERGROUND	0x400	// Z-levels that are subterranean.
>>>>>>> 4780b1efe52... Planetary Meteors (#8422)

// Misc map defines.
#define SUBMAP_MAP_EDGE_PAD 8 // Automatically created submaps are forbidden from being this close to the main map's edge.	//VOREStation Edit
