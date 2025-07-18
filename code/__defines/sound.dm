//max channel is 1024. Only go lower from here, because byond tends to pick the first available channel to play sounds on
#define CHANNEL_LOBBYMUSIC 1024
#define CHANNEL_ADMIN 1023
#define CHANNEL_VOX 1022
#define CHANNEL_JUKEBOX 1021
#define CHANNEL_HEARTBEAT 1020 //sound channel for heartbeats
#define CHANNEL_AMBIENCE_FORCED 1019
#define CHANNEL_AMBIENCE 1018
#define CHANNEL_BUZZ 1017
#define CHANNEL_BICYCLE 1016
#define CHANNEL_PREYLOOP 1015
//THIS SHOULD ALWAYS BE THE LOWEST ONE!
//KEEP IT UPDATED
#define CHANNEL_HIGHEST_AVAILABLE 1014

#define MAX_INSTRUMENT_CHANNELS (128 * 6)

/// This is the lowest volume that can be used by playsound otherwise it gets ignored
/// Most sounds around 10 volume can barely be heard. Almost all sounds at 5 volume or below are inaudible
/// This is to prevent sound being spammed at really low volumes due to distance calculations
/// Recommend setting this to anywhere from 10-3 (or 0 to disable any sound minimum volume restrictions)
/// Ex. For a 70 volume sound, 17 tile range, 3 exponent, 2 falloff_distance:
/// Setting SOUND_AUDIBLE_VOLUME_MIN to 0 for the above will result in 17x17 radius (289 turfs)
/// Setting SOUND_AUDIBLE_VOLUME_MIN to 5 for the above will result in 14x14 radius (196 turfs)
/// Setting SOUND_AUDIBLE_VOLUME_MIN to 10 for the above will result in 11x11 radius (121 turfs)
#define SOUND_AUDIBLE_VOLUME_MIN 3

/* Calculates the max distance of a sound based on audible volume
 *
 * Note - you should NEVER pass in a volume that is lower than SOUND_AUDIBLE_VOLUME_MIN otherwise distance will be insanely large (like +250,000)
 *
 * Arguments:
 * * volume: The initial volume of the sound being played
 * * max_distance: The range of the sound in tiles (technically not real max distance since the furthest areas gets pruned due to SOUND_AUDIBLE_VOLUME_MIN)
 * * falloff_distance: Distance at which falloff begins. Sound is at peak volume (in regards to falloff) aslong as it is in this range.
 * * falloff_exponent: Rate of falloff for the audio. Higher means quicker drop to low volume. Should generally be over 1 to indicate a quick dive to 0 rather than a slow dive.
 * Returns: The max distance of a sound based on audible volume range
 */
#define CALCULATE_MAX_SOUND_AUDIBLE_DISTANCE(volume, max_distance, falloff_distance, falloff_exponent)\
	floor(((((-(max(max_distance - falloff_distance, 0) ** (1 / falloff_exponent)) / volume) * (SOUND_AUDIBLE_VOLUME_MIN - volume)) ** falloff_exponent) + falloff_distance))

/* Calculates the volume of a sound based on distance
 *
 * https://www.desmos.com/calculator/sqdfl8ipgf
 *
 * Arguments:
 * * volume: The initial volume of the sound being played
 * * distance: How far away the sound is in tiles from the source
 * * falloff_distance: Distance at which falloff begins. Sound is at peak volume (in regards to falloff) aslong as it is in this range.
 * * falloff_exponent: Rate of falloff for the audio. Higher means quicker drop to low volume. Should generally be over 1 to indicate a quick dive to 0 rather than a slow dive.
 * Returns: The max distance of a sound based on audible volume range
 */
#define CALCULATE_SOUND_VOLUME(volume, distance, max_distance, falloff_distance, falloff_exponent)\
	((max(distance - falloff_distance, 0) ** (1 / falloff_exponent)) / ((max(max_distance, distance) - falloff_distance) ** (1 / falloff_exponent)) * volume)

///Default range of a sound.
#define SOUND_RANGE 17
///Percentage of sound's range where no falloff is applied
#define SOUND_DEFAULT_FALLOFF_DISTANCE 1 //For a normal sound this would be 1 tile of no falloff
///The default exponent of sound falloff
#define SOUND_FALLOFF_EXPONENT 6

#define SOUND_MINIMUM_PRESSURE 10

//default byond sound environments
#define SOUND_ENVIRONMENT_NONE -1
#define SOUND_ENVIRONMENT_GENERIC 0
#define SOUND_ENVIRONMENT_PADDED_CELL 1
#define SOUND_ENVIRONMENT_ROOM 2
#define SOUND_ENVIRONMENT_BATHROOM 3
#define SOUND_ENVIRONMENT_LIVINGROOM 4
#define SOUND_ENVIRONMENT_STONEROOM 5
#define SOUND_ENVIRONMENT_AUDITORIUM 6
#define SOUND_ENVIRONMENT_CONCERT_HALL 7
#define SOUND_ENVIRONMENT_CAVE 8
#define SOUND_ENVIRONMENT_ARENA 9
#define SOUND_ENVIRONMENT_HANGAR 10
#define SOUND_ENVIRONMENT_CARPETED_HALLWAY 11
#define SOUND_ENVIRONMENT_HALLWAY 12
#define SOUND_ENVIRONMENT_STONE_CORRIDOR 13
#define SOUND_ENVIRONMENT_ALLEY 14
#define SOUND_ENVIRONMENT_FOREST 15
#define SOUND_ENVIRONMENT_CITY 16
#define SOUND_ENVIRONMENT_MOUNTAINS 17
#define SOUND_ENVIRONMENT_QUARRY 18
#define SOUND_ENVIRONMENT_PLAIN 19
#define SOUND_ENVIRONMENT_PARKING_LOT 20
#define SOUND_ENVIRONMENT_SEWER_PIPE 21
#define SOUND_ENVIRONMENT_UNDERWATER 22
#define SOUND_ENVIRONMENT_DRUGGED 23
#define SOUND_ENVIRONMENT_DIZZY 24
#define SOUND_ENVIRONMENT_PSYCHOTIC 25
//If we ever make custom ones add them here

//"sound areas": easy way of keeping different types of areas consistent.
#define STANDARD_STATION SOUND_ENVIRONMENT_STONEROOM
#define LARGE_ENCLOSED SOUND_ENVIRONMENT_HANGAR
#define SMALL_ENCLOSED SOUND_ENVIRONMENT_BATHROOM
#define TUNNEL_ENCLOSED SOUND_ENVIRONMENT_CAVE
#define LARGE_SOFTFLOOR SOUND_ENVIRONMENT_CARPETED_HALLWAY
#define MEDIUM_SOFTFLOOR SOUND_ENVIRONMENT_LIVINGROOM
#define SMALL_SOFTFLOOR SOUND_ENVIRONMENT_ROOM
#define ASTEROID SOUND_ENVIRONMENT_CAVE
#define SPACE SOUND_ENVIRONMENT_UNDERWATER

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
	'sound/ambience/highsec/highsec2.ogg',\
	'sound/ambience/highsec/highsec3.ogg',\
	'sound/ambience/highsec/highsec4.ogg'\
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
	'sound/ambience/generic/generic3.ogg'\
	)
// 'sound/ambience/generic/generic4.ogg'

// Sounds of PA announcements, presumably involving shuttles?
#define AMBIENCE_ARRIVALS list(\
	'sound/ambience/arrivals/arrivals1.ogg',\
	'sound/ambience/arrivals/arrivals2.ogg',\
	'sound/ambience/arrivals/arrivals3.ogg',\
	'sound/ambience/arrivals/arrivals4.ogg',\
	'sound/ambience/arrivals/arrivals5.ogg',\
	'sound/ambience/arrivals/arrivals6.ogg',\
	'sound/ambience/arrivals/arrivals7.ogg'\
	)

// Sounds suitable for being inside dark, tight corridors in the underbelly of the station.
#define AMBIENCE_MAINTENANCE list(\
	'sound/ambience/maintenance/maintenance1.ogg',\
	'sound/ambience/maintenance/maintenance2.ogg',\
	'sound/ambience/maintenance/maintenance3.ogg',\
	'sound/ambience/maintenance/maintenance4.ogg',\
	'sound/ambience/maintenance/maintenance5.ogg',\
	'sound/ambience/maintenance/maintenance6.ogg',\
	'sound/ambience/maintenance/maintenance7.ogg',\
	'sound/ambience/maintenance/maintenance8.ogg',\
	'sound/ambience/maintenance/maintenance9.ogg'\
	)

// Life support machinery at work, keeping everyone breathing.
#define AMBIENCE_ENGINEERING list(\
	'sound/ambience/engineering/engineering1.ogg',\
	'sound/ambience/engineering/engineering2.ogg',\
	'sound/ambience/engineering/engineering3.ogg'\
	)

// Creepy AI/borg stuff.
#define AMBIENCE_AI list(\
	'sound/ambience/ai/ai1.ogg',\
	'sound/ambience/ai/ai2.ogg',\
	'sound/ambience/ai/ai3.ogg'\
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
	'sound/ambience/foreboding/foreboding2.ogg',\
	'sound/ambience/foreboding/foreboding3.ogg',\
	'sound/ambience/foreboding/foreboding4.ogg',\
	'sound/ambience/foreboding/foreboding5.ogg',\
	'sound/ambience/foreboding/foreboding6.ogg'\
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

#define AMBIENCE_OUTPOST list(\
	'sound/ambience/expoutpost/expoutpost1.ogg',\
	'sound/ambience/expoutpost/expoutpost2.ogg',\
	'sound/ambience/expoutpost/expoutpost3.ogg',\
	'sound/ambience/expoutpost/expoutpost4.ogg'\
	)

#define AMBIENCE_SUBSTATION list(\
	'sound/ambience/substation/substation1.ogg',\
	'sound/ambience/substation/substation2.ogg'\
	)

#define AMBIENCE_HANGAR list(\
	'sound/ambience/hangar/hangar1.ogg',\
	'sound/ambience/hangar/hangar2.ogg',\
	'sound/ambience/hangar/hangar3.ogg',\
	'sound/ambience/hangar/hangar4.ogg',\
	'sound/ambience/hangar/hangar5.ogg',\
	'sound/ambience/hangar/hangar6.ogg'\
	)

#define AMBIENCE_ATMOS list(\
	'sound/ambience/engineering/engineering1.ogg',\
	'sound/ambience/engineering/engineering2.ogg',\
	'sound/ambience/engineering/engineering3.ogg',\
	'sound/ambience/atmospherics/atmospherics1.ogg'\
	)

/**
# assoc list of datum by key
* k = SFX_KEY (see below)
* v = singleton sound_effect datum ref
* initialized in SSsounds init
*/
GLOBAL_LIST_EMPTY(sfx_datum_by_key)

/* List of all of our sound keys.
	used with /datum/sound_effect as the key
	see code\game\sound_keys.dm
*/
#define SFX_BODYFALL "bodyfall"
#define SFX_BULLET_MISS "bullet_miss"
#define SFX_CAN_OPEN "can_open"
#define SFX_CLOWN_STEP "clown_step"
#define SFX_EXPLOSION "explosion"
#define SFX_HISS "hiss"
#define SFX_PAGE_TURN "page_turn"
#define SFX_PUNCH "punch"
#define SFX_RICOCHET "ricochet"
#define SFX_RUSTLE "rustle"
#define SFX_SHATTER "shatter"
#define SFX_SM_CALM "sm_calm"
#define SFX_SM_DELAM "sm_delam"
#define SFX_SPARKS "sparks"
#define SFX_SWING_HIT "swing_hit"
#define SFX_TERMINAL_TYPE "terminal_type"
#define SFX_THUNDER "thunder"
#define SFX_FRACTURE "fracture"
#define SFX_MECHSTEP "mechstep"
#define SFX_CASING_SOUNDS "casing_sounds"
#define SFX_PICKAXE "pickaxe"
#define SFX_GENERIC_DROP "generic_drop"
#define SFX_GENERIC_PICKUP "generic_pickup"
#define SFX_TEPPI "teppi"
#define SFX_EMOTE "emote"
/* List of all of our vore sound keys.
	used with /datum/sound_effect as the key
	see code\game\sound_keys.dm
*/
#define SFX_HUNGER_SOUNDS "hunger_sounds"
#define SFX_CLASSIC_DIGESTION_SOUNDS "classic_digestion_sounds"
#define SFX_CLASSIC_DEATH_SOUNDS "classic_death_sounds"
#define SFX_CLASSIC_STRUGGLE_SOUNDS "classic_struggle_sounds"
#define SFX_BELCHES "belches"
#define SFX_FANCY_PREY_STRUGGLE "fancy_prey_struggle"
#define SFX_FANCY_DIGEST_PRED "fancy_digest_pred"
#define SFX_FANCY_DEATH_PRED "fancy_death_pred"
#define SFX_FANCY_DIGEST_PREY "fancy_digest_prey"
#define SFX_FANCY_DEATH_PREY "fancy_death_prey"
