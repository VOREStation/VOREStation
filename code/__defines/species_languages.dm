// Species flags.
#define NO_MINOR_CUT      	0x1	// Can step on broken glass with no ill-effects. Either thick skin (diona), cut resistant (slimes) or incorporeal (shadows)
#define IS_PLANT          	0x2	// Is a treeperson.
#define NO_SLEEVE        	0x4	// Cannot be resleeved by clonepods
#define NO_PAIN           	0x8	// Cannot suffer halloss/recieves deceptive health indicator.
#define NO_SLIP           	0x10	// Cannot fall over.
#define NO_POISON         	0x20	// Cannot not suffer toxloss.
#define NO_EMBED		0x40	// Can step on broken glass with no ill-effects and cannot have shrapnel embedded in it.
#define NO_HALLUCINATION  	0x80	// Don't hallucinate, ever
#define NO_BLOOD		0x100	// Never bleed, never show blood amount
#define UNDEAD			0x200	// Various things that living things don't do, mostly for skeletons
#define NO_INFECT		0x400	// Don't allow infections in limbs or organs, similar to IS_PLANT, without other strings.
#define NO_DEFIB		0x800	// Don't allow them to be defibbed
#define NO_DNA          0x1000	// Cannot have mutations or have their dna changed by genetics/radiation/genome-stolen.
#define THICK_SKIN		0x2000	// Needles have a chain to fail when attempted to be used on them.
// unused: 0x8000 - higher than this will overflow

// Species EMP vuln for carbons
#define EMP_PAIN	0x1	// EMPs cause pain
#define EMP_BLIND	0x2	// EMPs cause screenflash and blindness
#define EMP_DEAFEN	0x4	// EMPs cause deafness
#define EMP_CONFUSE	0x8	// EMPs cause disorientation
#define EMP_WEAKEN	0x10	// EMPs cause collapsing (at high severity only)
#define EMP_BRUTE_DMG	0x20	// EMPs inflict brute damage
#define EMP_BURN_DMG	0x40	// EMPs inflict burn damage
#define EMP_TOX_DMG	0x80	// EMPs inflict toxin damage
#define EMP_OXY_DMG	0x100	// EMPs inflict oxy damage

// Species allergens
#define ALLERGEN_MEAT		0x1		// Skrell won't like this.
#define ALLERGEN_FISH		0x2		// Seperate for completion's sake. Still bad for skrell.
#define ALLERGEN_FRUIT		0x4		// An apple a day only keeps the doctor away if they're allergic.
#define ALLERGEN_VEGETABLE	0x8		// Taters 'n' carrots. Potato allergy is a thing, apparently.
#define ALLERGEN_GRAINS		0x10	// Wheat, oats, etc.
#define ALLERGEN_BEANS		0x20	// The musical fruit! Includes soy.
#define ALLERGEN_SEEDS		0x40	// Hope you don't have a nut allergy.
#define ALLERGEN_DAIRY		0x80	// Lactose intolerance, ho! Also bad for skrell.
#define ALLERGEN_FUNGI		0x100	// Delicious shrooms.
#define ALLERGEN_COFFEE		0x200	// Mostly here for tajara.
#define ALLERGEN_SUGARS		0x400	// For unathi-like reactions
#define ALLERGEN_EGGS		0x800	// For Skrell eggs allergy
#define ALLERGEN_STIMULANT	0x1000	// Stimulants are what makes the Tajaran heart go ruh roh - not just coffee!
#define ALLERGEN_CHOCOLATE	0x2000	// Makes dogs die if they want to?

// Allergen reactions
#define AG_PHYS_DMG	0x1	// brute
#define AG_BURN_DMG	0x2	// burns
#define AG_TOX_DMG	0x4	// the classic
#define AG_OXY_DMG	0x8	// intense airway reactions
#define AG_EMOTE	0x10	// general emote reactions based on affect type
#define AG_PAIN		0x20	// short-lived hurt
#define AG_WEAKEN	0x40	// too weak to move, oof
#define AG_BLURRY	0x80	// blurred vision!
#define AG_SLEEPY	0x100	// fatigue/exhaustion
#define AG_CONFUSE	0x200	// disorientation

// Species spawn flags
#define SPECIES_IS_WHITELISTED      0x1  // Must be whitelisted to play.
#define SPECIES_IS_RESTRICTED       0x2  // Is not a core/normally playable species. (castes, mutantraces)
#define SPECIES_CAN_JOIN            0x4  // Species is selectable in chargen.
#define SPECIES_NO_FBP_CONSTRUCTION 0x8  // FBP of this species can't be made in-game.
#define SPECIES_NO_FBP_CHARGEN      0x10 // FBP of this species can't be selected at chargen.
#define SPECIES_NO_POSIBRAIN        0x20 // FBP of this species cannot have a positronic brain.
#define SPECIES_NO_DRONEBRAIN       0x40 // FBP of this species cannot have a drone intelligence.

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
//VOREStation edit 08/23/20
#define LANGUAGE_GUTTER "Gutterband"
//VS edit end
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
