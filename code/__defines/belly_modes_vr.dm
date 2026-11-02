// Normal digestion modes
#define DM_DEFAULT								"Default"				// Not a real bellymode, used for handling on 'selective' bellymode prefs.
#define DM_HOLD									"Hold"
#define DM_HOLD_ABSORBED						"Hold Absorbed"			// Not a real bellymode, used for handling different idle messages for absorbed prey.
#define DM_DIGEST								"Digest"
#define DM_ABSORB								"Absorb"
#define DM_UNABSORB								"Unabsorb"
#define DM_DRAIN								"Drain"
#define DM_SHRINK								"Shrink"
#define DM_GROW									"Grow"
#define DM_SIZE_STEAL							"Size Steal"
#define DM_HEAL									"Heal"
#define DM_EGG 									"Encase In Egg"
#define DM_SELECT								"Selective"

//Addon mode flags
#define DM_FLAG_NUMBING			0x1
#define DM_FLAG_STRIPPING		0x2
#define DM_FLAG_LEAVEREMAINS	0x4
#define DM_FLAG_THICKBELLY		0x8
#define DM_FLAG_AFFECTWORN		0x10
#define DM_FLAG_JAMSENSORS		0x20
#define DM_FLAG_FORCEPSAY		0x40
#define DM_FLAG_SPARELIMB		0x80
#define DM_FLAG_SLOWBODY		0x100
#define DM_FLAG_MUFFLEITEMS		0x200
#define DM_FLAG_TURBOMODE		0x400
#define DM_FLAG_ABSORBEDVORE	0x800
#define DM_FLAG_WETTENS			0x1000

//Item related modes
#define IM_HOLD									"Hold"
#define IM_DIGEST_FOOD							"Digest (Food Only)"
#define IM_DIGEST								"Digest"
#define IM_DIGEST_PARALLEL						"Digest (Dispersed Damage)"

//Stance for hostile mobs to be in while devouring someone.
#define HOSTILE_STANCE_EATING	99

// Defines for weight system
#define MIN_MOB_WEIGHT			70
#define MAX_MOB_WEIGHT			500
#define MIN_NUTRITION_TO_GAIN	450	// Above this amount you will gain weight
#define MAX_NUTRITION_TO_LOSE	50	// Below this amount you will lose weight
// #define WEIGHT_PER_NUTRITION	0.0285 // Tuned so 1050 (nutrition for average mob) = 30 lbs

// Drain modes
#define DR_NORMAL								"Normal"
#define DR_SLEEP 								"Sleep"
#define DR_FAKE									"False Sleep"
#define DR_WEIGHT								"Weight Drain"

//Vore Sprite Flags
#define DM_FLAG_VORESPRITE_BELLY    0x1
#define DM_FLAG_VORESPRITE_TAIL     0x2
#define DM_FLAG_VORESPRITE_MARKING  0x4
#define DM_FLAG_VORESPRITE_ARTICLE	0x8

//Belly Reagents mode flags
#define DM_FLAG_REAGENTSNUTRI	0x1
#define DM_FLAG_REAGENTSDIGEST	0x2
#define DM_FLAG_REAGENTSABSORB	0x4
#define DM_FLAG_REAGENTSDRAIN	0x8

//For belly fullscreen shennanigans outside of bellies, due to Life() clearing belly fullscreens outside of bellies.
#define ATOM_BELLY_FULLSCREEN "belly_atom_vfx"

//Auto-transfer options
#define AT_CREATURES	"Creatures"
#define AT_ABSORBED		"Absorbed"
#define AT_CARBON		"Carbon"
#define AT_SILICON		"Silicon"
#define AT_MOBS			"Mobs"
#define AT_ANIMALS		"Animals"
#define AT_MICE			"Mice"
#define AT_DEAD			"Dead"
#define AT_CANDIGEST	"Digestable Creatures"
#define AT_CANABSORB	"Absorbable Creatures"
#define AT_HEALTHY		"Full Health"
#define AT_OBSERVERS	"Observers"

//Auto-transfer mob flags
#define AT_FLAG_CREATURES		0x1
#define AT_FLAG_ABSORBED		0x2
#define AT_FLAG_CARBON			0x4
#define AT_FLAG_SILICON			0x8
#define AT_FLAG_MOBS			0x10
#define AT_FLAG_ANIMALS			0x20
#define AT_FLAG_MICE			0x40
#define AT_FLAG_DEAD			0x80
#define AT_FLAG_CANDIGEST		0x100
#define AT_FLAG_CANABSORB		0x200
#define AT_FLAG_HEALTHY			0x400
#define AT_FLAG_OBSERVERS		0x800

//Auto-transfer item options
#define AT_ITEMS		"Items"
#define AT_TRASH		"Trash"
#define AT_EGGS			"Eggs"
#define AT_REMAINS		"Remains"
#define AT_INDIGESTIBLE	"Indigestible Items"
#define AT_RECYCLABLE	"Recyclable Items"
#define AT_ORES			"Ores"
#define AT_CLOTHES		"Clothes and Bags"
#define AT_FOOD			"Food"

//Auto-transfer item flags
#define AT_FLAG_ITEMS			0x1
#define AT_FLAG_TRASH			0x2
#define AT_FLAG_EGGS			0x4
#define AT_FLAG_REMAINS			0x8
#define AT_FLAG_INDIGESTIBLE	0x10
#define AT_FLAG_RECYCLABLE		0x20
#define AT_FLAG_ORES			0x40
#define AT_FLAG_CLOTHES			0x80
#define AT_FLAG_FOOD			0x100

//Vorespawn flags
#define VS_FLAG_ABSORB_YES		0x1
#define VS_FLAG_ABSORB_PREY		0x2

//Message display flags
#define MS_FLAG_STRUGGLE_OUTSIDE			0x1
#define MS_FLAG_STRUGGLE_ABSORBED_OUTSIDE	0x2

//Escapable resist options
#define B_ESCAPABLE_NONE		0
#define B_ESCAPABLE_DEFAULT		1
#define B_ESCAPABLE_INTENT		2

#define VORE_TYPE_FLAG_ORAL			0x1
#define VORE_TYPE_FLAG_ANAL			0x2
#define VORE_TYPE_FLAG_COCK			0x4
#define VORE_TYPE_FLAG_SHEATH		0x8
#define VORE_TYPE_FLAG_BLADDER		0x10
#define VORE_TYPE_FLAG_UNBIRTH		0x20
#define VORE_TYPE_FLAG_UDDER		0x40
#define VORE_TYPE_FLAG_TAIL			0x80
#define VORE_TYPE_FLAG_ABSORB		0x100
#define VORE_TYPE_FLAG_SOUL			0x200
#define VORE_TYPE_FLAG_HARD			0x400
#define VORE_TYPE_FLAG_DIRTY		0x800
#define VORE_TYPE_FLAG_HIGH_DAMAGE	0x1000
#define VORE_TYPE_FLAG_PLINKO		0x2000
#define VORE_TYPE_FLAG_UNLISTED_V	0x4000
#define VORE_TYPE_FLAG_COCK_TF		0x8000
#define VORE_TYPE_FLAG_PUSSY_TF		0x10000
#define VORE_TYPE_FLAG_ANUS_TF		0x20000
#define VORE_TYPE_FLAG_PAW_TF		0x40000
#define VORE_TYPE_FLAG_TAIL_TF		0x80000
#define VORE_TYPE_FLAG_OBJECT_TF	0x100000
#define VORE_TYPE_FLAG_UNLISTED_TF	0x200000

GLOBAL_ALIST_INIT(vore_pref_types, alist(
	"Oral Vore" = VORE_TYPE_FLAG_ORAL,
	"Anal Vore" = VORE_TYPE_FLAG_ANAL,
	"Cock Vore" = VORE_TYPE_FLAG_COCK,
	"Sheath Vore" = VORE_TYPE_FLAG_SHEATH,
	"Bladder Vore" = VORE_TYPE_FLAG_BLADDER,
	"Unbirth" = VORE_TYPE_FLAG_UNBIRTH,
	"Udder Vore" = VORE_TYPE_FLAG_UDDER,
	"Tail Vore" = VORE_TYPE_FLAG_TAIL,
	"Absorption" = VORE_TYPE_FLAG_ABSORB,
	"Soul Vore" = VORE_TYPE_FLAG_SOUL,
	"Hard Vore" = VORE_TYPE_FLAG_HARD,
	"Dirty / Filth" = VORE_TYPE_FLAG_DIRTY,
	"High Damage" = VORE_TYPE_FLAG_HIGH_DAMAGE,
	"Plinko" = VORE_TYPE_FLAG_PLINKO,
	"Other / Unlisted Vore" = VORE_TYPE_FLAG_UNLISTED_V,
	"Cock Transformation" = VORE_TYPE_FLAG_COCK_TF,
	"Pussy Transformation" = VORE_TYPE_FLAG_PUSSY_TF,
	"Anus Transformation" = VORE_TYPE_FLAG_ANUS_TF,
	"Paw Transformation" = VORE_TYPE_FLAG_PAW_TF,
	"Tail Transformation" = VORE_TYPE_FLAG_TAIL_TF,
	"Object Transformation" = VORE_TYPE_FLAG_OBJECT_TF,
	"Other / Unlisted Transformation" = VORE_TYPE_FLAG_UNLISTED_TF,
))
