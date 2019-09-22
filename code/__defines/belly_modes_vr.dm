// Normal digestion modes
#define DM_HOLD									"Hold"
#define DM_DIGEST								"Digest"
#define DM_ABSORB								"Absorb"
#define DM_UNABSORB								"Unabsorb"
#define DM_DRAIN								"Drain"
#define DM_SHRINK								"Shrink"
#define DM_GROW									"Grow"
#define DM_SIZE_STEAL							"Size Steal"
#define DM_HEAL									"Heal"
#define DM_EGG 									"Encase In Egg"
#define DM_TRANSFORM							"Transform"

//#define DM_ITEMWEAK							"Digest (Item Friendly)"
//#define DM_STRIPDIGEST						"Strip Digest (Items Only)"
//#define DM_DIGEST_NUMB						"Digest (Numbing)"

//TF modes
#define DM_TRANSFORM_HAIR_AND_EYES					"Transform (Hair and eyes)"
#define DM_TRANSFORM_MALE							"Transform (Male)"
#define DM_TRANSFORM_FEMALE							"Transform (Female)"
#define DM_TRANSFORM_KEEP_GENDER					"Transform (Keep Gender)"
#define DM_TRANSFORM_REPLICA						"Transform (Replica Of Self)"
#define DM_TRANSFORM_CHANGE_SPECIES_AND_TAUR		"Transform (Change Species and Taur)"
#define DM_TRANSFORM_CHANGE_SPECIES_AND_TAUR_EGG	"Transform (Change Species and Taur) (EGG)"
#define DM_TRANSFORM_REPLICA_EGG					"Transform (Replica Of Self) (EGG)"
#define DM_TRANSFORM_KEEP_GENDER_EGG				"Transform (Keep Gender) (EGG)"
#define DM_TRANSFORM_MALE_EGG						"Transform (Male) (EGG)"
#define DM_TRANSFORM_FEMALE_EGG						"Transform (Female) (EGG)"

//Addon mode flags
#define DM_FLAG_NUMBING			0x1
#define DM_FLAG_STRIPPING		0x2
#define DM_FLAG_LEAVEREMAINS	0x4
#define DM_FLAG_THICKBELLY		0x8

//Item related modes
#define IM_HOLD									"Hold"
#define IM_DIGEST_FOOD							"Digest (Food Only)"
#define IM_DIGEST								"Digest"

//Stance for hostile mobs to be in while devouring someone.
#define HOSTILE_STANCE_EATING	99

// Defines for weight system
#define MIN_MOB_WEIGHT			70
#define MAX_MOB_WEIGHT			500
#define MIN_NUTRITION_TO_GAIN	450	// Above this amount you will gain weight
#define MAX_NUTRITION_TO_LOSE	50	// Below this amount you will lose weight
// #define WEIGHT_PER_NUTRITION	0.0285 // Tuned so 1050 (nutrition for average mob) = 30 lbs
