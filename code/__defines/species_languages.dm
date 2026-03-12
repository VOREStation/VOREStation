// Languages.
#define LANGUAGE_GALCOM "Galactic Common"
#define LANGUAGE_EAL "Encoded Audio Language"
#define LANGUAGE_SWARMBOT "Ancient Audio Encryption"
#define LANGUAGE_SOL_COMMON "Sol Common"
#define LANGUAGE_UNATHI "Sinta'unathi"
#define LANGUAGE_SIIK "Siik"
#define LANGUAGE_SKRELLIAN "Common Skrellian"
#define LANGUAGE_TRADEBAND "Tradeband"
#define LANGUAGE_GUTTER "Gutterband"
#define LANGUAGE_SIGN "Sign Language"
#define LANGUAGE_SCHECHI "Schechi"
#define LANGUAGE_ROOTLOCAL "Local Rootspeak"
#define LANGUAGE_ROOTGLOBAL "Global Rootspeak"
#define LANGUAGE_CULT "Cult"
#define LANGUAGE_CHANGELING "Changeling"
#define LANGUAGE_VOX "Vox-Pidgin"
#define LANGUAGE_TERMINUS "Terminus"
#define LANGUAGE_MINBUS "Minbus"
#define LANGUAGE_EVENT1 "Occursus"
#define LANGUAGE_AKHANI "Akhani"
#define LANGUAGE_ALAI "Alai"
#define LANGUAGE_ZADDAT "Vedahq"
#define LANGUAGE_PROMETHEAN "Promethean Biolinguistics"
#define LANGUAGE_GIBBERISH "Babel"
#define LANGUAGE_ROBOT_TALK "Robot Talk"
#define LANGUAGE_DRONE_TALK "Drone Talk"
#define LANGUAGE_DRUDAKAR "D'Rudak'Ar"
#define LANGUAGE_BIRDSONG "Birdsong"
#define LANGUAGE_SAGARU "Sagaru"
#define LANGUAGE_CANILUNZT "Canilunzt"
#define LANGUAGE_ECUREUILIAN "Ecureuilian"
#define LANGUAGE_DAEMON "Daemon"
#define LANGUAGE_ENOCHIAN "Enochian"
#define LANGUAGE_VESPINAE "Vespinae"
#define LANGUAGE_SPACER "Spacer"
#define LANGUAGE_TAVAN "Tavan"
#define LANGUAGE_ECHOSONG "Echo Song"

#define LANGUAGE_ANIMAL "Animal"
#define LANGUAGE_TEPPI "Teppi"
#define LANGUAGE_MOUSE "Mouse"
#define LANNGUAGE_DRAKE "Drake"

#define LANGUAGE_SHADEKIN "Shadekin Empathy"
#define LANGUAGE_LLEILL "Glamour Speak"

#define LANGUAGE_SPARKLE "Sparkle"

#define LANGUAGE_XENOLINGUA "Xenomorph"
#define LANGUAGE_HIVEMIND "Hivemind"
#define LANGUAGE_REDSPACE "Carnem amplecti"

// Language flags.
#define WHITELISTED  1   // Language is available if the speaker is whitelisted.
#define RESTRICTED   2   // Language can only be acquired by spawning or an admin.
#define NONVERBAL    4   // Language uses both verbal and non-verbal components completely to communicate. Out-of-sight speech is garbled.
#define SIGNLANG     8   // Language is completely non-verbal. Speech is displayed through emotes for those who can understand.
#define HIVEMIND     16  // Broadcast to all mobs with this language.
#define NONGLOBAL    32  // Do not add to general languages list.
#define INNATE       64  // All mobs can be assumed to speak and understand this language. (audible emotes)
#define NO_TALK_MSG  128 // Do not show the "\The [speaker] talks into \the [radio]" message
#define NO_STUTTER   256 // No stuttering, slurring, or other speech problems
#define ALT_TRANSMIT 512 // Language is not based on vision or sound (Todo: add this into the say code and use it for the rootspeak languages)
#define INAUDIBLE 1024   // Language is not audible (similar to nonverbal) but is still using hearing-based recognition

#define SKIN_NORMAL 0
#define SKIN_THREAT 1
#define SKIN_CLOAK  2
