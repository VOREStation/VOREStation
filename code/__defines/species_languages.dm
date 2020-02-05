// Species flags.
#define NO_MINOR_CUT      0x1    // Can step on broken glass with no ill-effects. Either thick skin (diona), cut resistant (slimes) or incorporeal (shadows)
#define IS_PLANT          0x2    // Is a treeperson.
#define NO_SCAN           0x4    // Cannot be scanned in a DNA machine/genome-stolen.
#define NO_PAIN           0x8    // Cannot suffer halloss/recieves deceptive health indicator.
#define NO_SLIP           0x10   // Cannot fall over.
#define NO_POISON         0x20   // Cannot not suffer toxloss.
#define NO_EMBED		  0x40	 // Can step on broken glass with no ill-effects and cannot have shrapnel embedded in it.
#define NO_HALLUCINATION  0x80	 // Don't hallucinate, ever
#define NO_BLOOD		  0x100  // Never bleed, never show blood amount
#define UNDEAD			  0x200	 // Various things that living things don't do, mostly for skeletons
#define NO_INFECT		  0x400  // Don't allow infections in limbs or organs, similar to IS_PLANT, without other strings.
// unused: 0x8000 - higher than this will overflow

// Species spawn flags
#define SPECIES_IS_WHITELISTED    0x1    // Must be whitelisted to play.
#define SPECIES_IS_RESTRICTED     0x2    // Is not a core/normally playable species. (castes, mutantraces)
#define SPECIES_CAN_JOIN                  0x4    // Species is selectable in chargen.
#define SPECIES_NO_FBP_CONSTRUCTION 0x8    // FBP of this species can't be made in-game.
#define SPECIES_NO_FBP_CHARGEN      0x10    // FBP of this species can't be selected at chargen.

// Species appearance flags
#define HAS_SKIN_TONE     0x1    // Skin tone selectable in chargen. (0-255)
#define HAS_SKIN_COLOR    0x2    // Skin colour selectable in chargen. (RGB)
#define HAS_LIPS          0x4    // Lips are drawn onto the mob icon. (lipstick)
#define HAS_UNDERWEAR     0x8    // Underwear is drawn onto the mob icon.
#define HAS_EYE_COLOR     0x10   // Eye colour selectable in chargen. (RGB)
#define HAS_HAIR_COLOR    0x20   // Hair colour selectable in chargen. (RGB)
#define RADIATION_GLOWS   0x40   // Radiation causes this character to glow.

// Languages.
#define LANGUAGE_GALCOM "Galactic Common"
#define LANGUAGE_EAL "Encoded Audio Language"
#define LANGUAGE_SWARMBOT "Ancient Audio Encryption"
#define LANGUAGE_SOL_COMMON "Sol Common"
#define LANGUAGE_UNATHI "Sinta'unathi"
#define LANGUAGE_SIIK "Siik"
#define LANGUAGE_SKRELLIAN "Common Skrellian"
#define LANGUAGE_TRADEBAND "Tradeband"
#define LANGUAGE_GUTTER "Gutter"
#define LANGUAGE_SIGN "Sign Language"
#define LANGUAGE_SCHECHI "Schechi"
#define LANGUAGE_ROOTLOCAL "Local Rootspeak"
#define LANGUAGE_ROOTGLOBAL "Global Rootspeak"
#define LANGUAGE_CULT "Cult"
#define LANGUAGE_OCCULT "Occult"
#define LANGUAGE_CHANGELING "Changeling"
#define LANGUAGE_VOX "Vox-Pidgin"
#define LANGUAGE_TERMINUS "Terminus"
#define LANGUAGE_SKRELLIANFAR "High Skrellian"
#define LANGUAGE_MINBUS "Minbus"
#define LANGUAGE_EVENT1 "Occursus"
#define LANGUAGE_AKHANI "Akhani"
#define LANGUAGE_ALAI "Alai"
#define LANGUAGE_ZADDAT "Vedahq"
#define LANGUAGE_GIBBERISH "Babel"

// Language flags.
#define WHITELISTED  1   // Language is available if the speaker is whitelisted.
#define RESTRICTED   2   // Language can only be acquired by spawning or an admin.
#define NONVERBAL    4   // Language has a significant non-verbal component. Speech is garbled without line-of-sight.
#define SIGNLANG     8   // Language is completely non-verbal. Speech is displayed through emotes for those who can understand.
#define HIVEMIND     16  // Broadcast to all mobs with this language.
#define NONGLOBAL    32  // Do not add to general languages list.
#define INNATE       64  // All mobs can be assumed to speak and understand this language. (audible emotes)
#define NO_TALK_MSG  128 // Do not show the "\The [speaker] talks into \the [radio]" message
#define NO_STUTTER   256 // No stuttering, slurring, or other speech problems
#define ALT_TRANSMIT 512 // Language is not based on vision or sound (Todo: add this into the say code and use it for the rootspeak languages)

#define SKIN_NORMAL 0
#define SKIN_THREAT 1
#define SKIN_CLOAK  2
