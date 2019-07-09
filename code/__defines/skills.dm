// These defines are for tweaking the 'balance' of the skill system.

#define SKILL_POINT_FLOOR			20		// Default minimum amount of skill points, generally when at the min age.
#define SKILL_POINT_CEILING			150		// Default maximum amount of skill points, generally when at the max age.
#define SKILL_POINT_ANTAG_BONUS		50		// Flat bonus points given to antagonists. This is applied after the age-based curve and can exceed SKILL_POINT_CEILING.

#define SKILL_DISCOUNT_FACTOR		0.5
#define SKILL_DISCOUNT_MAX_POINTS	100

// Defines for each skill leve, so you don't need to remember how BYOND counts.
// Skills generally are capped at SKILL_LEVEL_FOUR, however some are capped at SKILL_LEVEL_THREE.
#define SKILL_LEVEL_ZERO		1 // Default level for everyone.
#define SKILL_LEVEL_ONE			2 // Basic stuff.
#define SKILL_LEVEL_TWO			3 // Less basic.
#define SKILL_LEVEL_THREE		4 // Competency in a skill, can do everything they could've done before the skill system.
#define SKILL_LEVEL_FOUR		5 // Gets bonuses to whatever the skill is involved in.


// These defines are used in a few places.
// Firstly, they act as the index for a special list in the global skill collection object.
// Secondly, they are used as input for skill check procs.
// Thirdly, they are also used for savefile purposes (so try to avoid changing it if possible).

#define SKILL_EXOSUITS	"Exosuits"
#define SKILL_EVA		"EVA"