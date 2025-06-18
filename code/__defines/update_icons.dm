// These are used as the layers for the icons, as well as indexes in a list that holds onto them.
// Technically the layers used are all -100+layer to make them FLOAT_LAYER overlays.
//Human Overlays Indexes/////////
#define MUTATIONS_LAYER			1		//Mutations like fat, and lasereyes
#define TAIL_LOWER_LAYER		2		//Tail as viewed from the south
#define WING_LOWER_LAYER		3		//Wings as viewed from the south
#define BODYPARTS_LAYER			4		//Bodyparts layer
#define SKIN_LAYER				5		//Skin things added by a call on species
#define BLOOD_LAYER				6		//Bloodied hands/feet/anything else
#define MOB_DAM_LAYER			7		//Injury overlay sprites like open wounds
#define SURGERY_LAYER			8		//Overlays for open surgical sites
#define UNDERWEAR_LAYER  		9		//Underwear/bras/etc
#define SHOES_LAYER_ALT			10		//Shoe-slot item (when set to be under uniform via verb)
#define TAIL_UPPER_LAYER_LOW	11		//Modified tail-sprite layer. Tend to be larger.
#define UNIFORM_LAYER			12		//Uniform-slot item
#define ID_LAYER				13		//ID-slot item
#define SHOES_LAYER				14		//Shoe-slot item
#define GLOVES_LAYER			15		//Glove-slot item
#define BELT_LAYER				16		//Belt-slot item
#define SUIT_LAYER				17		//Suit-slot item
#define TAIL_UPPER_LAYER		18		//Some species have tails to render (As viewed from the N, E, or W)
#define GLASSES_LAYER			19		//Eye-slot item
#define BELT_LAYER_ALT			20		//Belt-slot item (when set to be above suit via verb)
#define SUIT_STORE_LAYER		21		//Suit storage-slot item
#define BACK_LAYER				22		//Back-slot item
#define HAIR_LAYER				23		//The human's hair
#define HAIR_ACCESSORY_LAYER	24		//Simply move this up a number if things are added.
#define EARS_LAYER				25		//Both ear-slot items (combined image)
#define EYES_LAYER				26		//Mob's eyes (used for glowing eyes)
#define FACEMASK_LAYER			27		//Mask-slot item
#define GLASSES_LAYER_ALT		28		//So some glasses can appear on top of hair and things
#define HEAD_LAYER				29		//Head-slot item
#define HANDCUFF_LAYER			30		//Handcuffs, if the human is handcuffed, in a secret inv slot
#define LEGCUFF_LAYER			31		//Same as handcuffs, for legcuffs
#define L_HAND_LAYER			32		//Left-hand item
#define R_HAND_LAYER			33		//Right-hand item
#define WING_LAYER				34		//Wings or protrusions over the suit.
#define VORE_BELLY_LAYER		35		//Move this and everything after up if things are added.
#define VORE_TAIL_LAYER			36		//Move this and everything after up if things are added.
#define TAIL_UPPER_LAYER_HIGH	37		//Modified tail-sprite layer. Tend to be larger.
#define MODIFIER_EFFECTS_LAYER	38		//Effects drawn by modifiers
#define FIRE_LAYER				39		//'Mob on fire' overlay layer
#define MOB_WATER_LAYER			40		//'Mob submerged' overlay layer
#define TARGETED_LAYER			41		//'Aimed at' overlay layer
#define TOTAL_LAYERS			41		// <---- KEEP THIS UPDATED, should always equal the highest number here, used to initialize a list.


//These two are only used for gargoyles currently
#define HUMAN_BODY_LAYERS list(MUTATIONS_LAYER, TAIL_LOWER_LAYER, WING_LOWER_LAYER, BODYPARTS_LAYER, SKIN_LAYER, BLOOD_LAYER, MOB_DAM_LAYER, TAIL_UPPER_LAYER, HAIR_LAYER, HAIR_ACCESSORY_LAYER, EYES_LAYER, WING_LAYER, VORE_BELLY_LAYER, VORE_TAIL_LAYER, TAIL_UPPER_LAYER_HIGH, TAIL_UPPER_LAYER_LOW)
#define HUMAN_OTHER_LAYERS list(MODIFIER_EFFECTS_LAYER, FIRE_LAYER, MOB_WATER_LAYER, TARGETED_LAYER)
