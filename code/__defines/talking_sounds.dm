// This is a global define so that downstream modular files can use this, instead of making a ton of messy lists like it was before.
GLOBAL_LIST_EMPTY(talk_sound_map)
#define FIND_TALK_SOUND(X) GLOB.talk_sound_map[X]

#define DEFAULT_TALK_SOUND GLOB.talk_sound_map[GLOB.talk_sound_map[1]]
#define FALLBACK_TALK_SOUND GLOB.talk_sound
