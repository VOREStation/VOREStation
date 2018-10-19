//max channel is 1024. Only go lower from here, because byond tends to pick the first availiable channel to play sounds on
#define CHANNEL_LOBBYMUSIC 1024
#define CHANNEL_ADMIN 1023
#define CHANNEL_VOX 1022
#define CHANNEL_JUKEBOX 1021
#define CHANNEL_HEARTBEAT 1020 //sound channel for heartbeats
#define CHANNEL_AMBIENCE_FORCED 1019
#define CHANNEL_AMBIENCE 1018
#define CHANNEL_BUZZ 1017
#define CHANNEL_BICYCLE 1016

//THIS SHOULD ALWAYS BE THE LOWEST ONE!
//KEEP IT UPDATED

#define CHANNEL_HIGHEST_AVAILABLE 1015

#define SOUND_MINIMUM_PRESSURE 10
#define FALLOFF_SOUNDS 0.5

//Sound environment defines. Reverb preset for sounds played in an area, see sound datum reference for more.
#define GENERIC 0
#define PADDED_CELL 1
#define ROOM 2
#define BATHROOM 3
#define LIVINGROOM 4
#define STONEROOM 5
#define AUDITORIUM 6
#define CONCERT_HALL 7
#define CAVE 8
#define ARENA 9
#define HANGAR 10
#define CARPETED_HALLWAY 11
#define HALLWAY 12
#define STONE_CORRIDOR 13
#define ALLEY 14
#define FOREST 15
#define CITY 16
#define MOUNTAINS 17
#define QUARRY 18
#define PLAIN 19
#define PARKING_LOT 20
#define SEWER_PIPE 21
#define UNDERWATER 22
#define DRUGGED 23
#define DIZZY 24
#define PSYCHOTIC 25

#define STANDARD_STATION STONEROOM
#define LARGE_ENCLOSED HANGAR
#define SMALL_ENCLOSED BATHROOM
#define TUNNEL_ENCLOSED CAVE
#define LARGE_SOFTFLOOR CARPETED_HALLWAY
#define MEDIUM_SOFTFLOOR LIVINGROOM
#define SMALL_SOFTFLOOR ROOM
#define ASTEROID CAVE
#define SPACE UNDERWATER

// Ambience presets.
// All you need to do to make an area play one of these is set their ambience var to one of these lists.
// You can even combine them by adding them together, since they're just lists, however you'd have to do that in initialization.

// For weird alien places like the crashed UFO.
#define AMBIENCE_OTHERWORLDLY list(\
	'sound/ambience/otherworldly/otherworldly1.ogg',\
	'sound/ambience/otherworldly/otherworldly2.ogg',\
	'sound/ambience/otherworldly/otherworldly3.ogg'\
	)

// Restricted, military, or mercenary aligned locations like the armory, the merc ship/base, BSD, etc.
#define AMBIENCE_HIGHSEC list(\
	'sound/ambience/highsec/highsec1.ogg',\
	'sound/ambience/highsec/highsec2.ogg'\
	)

// Ruined structures found on the surface or in the caves.
#define AMBIENCE_RUINS list(\
	'sound/ambience/ruins/ruins1.ogg',\
	'sound/ambience/ruins/ruins2.ogg',\
	'sound/ambience/ruins/ruins3.ogg',\
	'sound/ambience/ruins/ruins4.ogg',\
	'sound/ambience/ruins/ruins5.ogg',\
	'sound/ambience/ruins/ruins6.ogg'\
	)

// Similar to the above, but for more technology/signaling based ruins.
#define AMBIENCE_TECH_RUINS list(\
	'sound/ambience/tech_ruins/tech_ruins1.ogg',\
	'sound/ambience/tech_ruins/tech_ruins2.ogg',\
	'sound/ambience/tech_ruins/tech_ruins3.ogg'\
	)

// The actual chapel room, and maybe some other places of worship.
#define AMBIENCE_CHAPEL list(\
	'sound/ambience/chapel/chapel1.ogg',\
	'sound/ambience/chapel/chapel2.ogg',\
	'sound/ambience/chapel/chapel3.ogg',\
	'sound/ambience/chapel/chapel4.ogg'\
	)

// For peaceful, serene areas, distinct from the Chapel.
#define AMBIENCE_HOLY list(\
	'sound/ambience/holy/holy1.ogg',\
	'sound/ambience/holy/holy2.ogg'\
	)

// Generic sounds for less special rooms.
#define AMBIENCE_GENERIC list(\
	'sound/ambience/generic/generic1.ogg',\
	'sound/ambience/generic/generic2.ogg',\
	'sound/ambience/generic/generic3.ogg',\
	'sound/ambience/generic/generic4.ogg'\
	)

// Sounds of PA announcements, presumably involving shuttles?
#define AMBIENCE_ARRIVALS list(\
	'sound/ambience/arrivals/arrivals1.ogg',\
	'sound/ambience/arrivals/arrivals2.ogg'\
	)

// Sounds suitable for being inside dark, tight corridors in the underbelly of the station.
#define AMBIENCE_MAINTENANCE list(\
	'sound/ambience/maintenance/maintenance1.ogg',\
	'sound/ambience/maintenance/maintenance2.ogg',\
	'sound/ambience/maintenance/maintenance3.ogg',\
	'sound/ambience/maintenance/maintenance4.ogg',\
	'sound/ambience/maintenance/maintenance5.ogg',\
	'sound/ambience/maintenance/maintenance6.ogg'\
	)

// Life support machinery at work, keeping everyone breathing.
#define AMBIENCE_ENGINEERING list(\
	'sound/ambience/engineering/engineering1.ogg',\
	'sound/ambience/engineering/engineering2.ogg',\
	'sound/ambience/engineering/engineering3.ogg'\
	)

// Creepy AI/borg stuff.
#define AMBIENCE_AI list(\
	'sound/ambience/ai/ai1.ogg'\
	)

// Peaceful sounds when floating in the void.
#define AMBIENCE_SPACE list(\
	'sound/ambience/space/space_serithi.ogg',\
	'sound/ambience/space/space1.ogg'\
	)

// Vaguely spooky sounds when around dead things.
#define AMBIENCE_GHOSTLY list(\
	'sound/ambience/ghostly/ghostly1.ogg',\
	'sound/ambience/ghostly/ghostly2.ogg'\
	)

// Concerning sounds, for when one discovers something horrible happened in a PoI.
#define AMBIENCE_FOREBODING list(\
	'sound/ambience/foreboding/foreboding1.ogg',\
	'sound/ambience/foreboding/foreboding2.ogg'\
	)

// Ambience heard when aboveground on Sif and not in a Point of Interest.
#define AMBIENCE_SIF list(\
	'sound/ambience/sif/sif1.ogg'\
	)

// If we ever add geothermal PoIs or other places that are really hot, this will do.
#define AMBIENCE_LAVA list(\
	'sound/ambience/lava/lava1.ogg'\
	)

// Cult-y ambience, for some PoIs, and maybe when the cultists darken the world with the ritual.
#define AMBIENCE_UNHOLY list(\
	'sound/ambience/unholy/unholy1.ogg'\
	)

// For the memes.
#define AMBIENCE_AESTHETIC list(\
	'sound/ambience/vaporwave.ogg'\
	)