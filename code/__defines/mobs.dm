// /mob/var/stat things.
#define CONSCIOUS   0
#define UNCONSCIOUS 1
#define DEAD        2

// Bitflags defining which status effects could be or are inflicted on a mob.
#define CANSTUN     0x1
#define CANWEAKEN   0x2
#define CANPARALYSE 0x4
#define CANPUSH     0x8
#define LEAPING     0x10
#define PASSEMOTES  0x32    // Mob has a cortical borer or holders inside of it that need to see emotes.
#define GODMODE     0x1000
#define FAKEDEATH   0x2000  // Replaces stuff like changeling.changeling_fakedeath.
#define DISFIGURED  0x4000  // Set but never checked. Remove this sometime and replace occurences with the appropriate organ code

// Grab levels.
#define GRAB_PASSIVE    1
#define GRAB_AGGRESSIVE 2
#define GRAB_NECK       3
#define GRAB_UPGRADING  4
#define GRAB_KILL       5

#define BORGMESON 0x1
#define BORGTHERM 0x2
#define BORGXRAY  0x4
#define BORGMATERIAL  8

#define STANCE_IDLE      1	// Looking for targets if hostile.  Does idle wandering.
#define STANCE_ALERT     2	// Bears
#define STANCE_ATTACK    3	// Attempting to get into attack position
#define STANCE_ATTACKING 4	// Doing attacks
#define STANCE_TIRED     5	// Bears
#define STANCE_FOLLOW    6	// Following somone
#define STANCE_BUSY      7	// Do nothing on life ticks (Other code is running)

#define LEFT  0x1
#define RIGHT 0x2
#define UNDER 0x4

// Pulse levels, very simplified.
#define PULSE_NONE    0 // So !M.pulse checks would be possible.
#define PULSE_SLOW    1 // <60     bpm
#define PULSE_NORM    2 //  60-90  bpm
#define PULSE_FAST    3 //  90-120 bpm
#define PULSE_2FAST   4 // >120    bpm
#define PULSE_THREADY 5 // Occurs during hypovolemic shock
#define GETPULSE_HAND 0 // Less accurate. (hand)
#define GETPULSE_TOOL 1 // More accurate. (med scanner, sleeper, etc.)

//intent flags, why wasn't this done the first time?
#define I_HELP		"help"
#define I_DISARM	"disarm"
#define I_GRAB		"grab"
#define I_HURT		"harm"

//These are used Bump() code for living mobs, in the mob_bump_flag, mob_swap_flags, and mob_push_flags vars to determine whom can bump/swap with whom.
#define HUMAN 1
#define MONKEY 2
#define ALIEN 4
#define ROBOT 8
#define SLIME 16
#define SIMPLE_ANIMAL 32
#define HEAVY 64
#define ALLMOBS (HUMAN|MONKEY|ALIEN|ROBOT|SLIME|SIMPLE_ANIMAL|HEAVY)

// Robot AI notifications
#define ROBOT_NOTIFICATION_NEW_UNIT 1
#define ROBOT_NOTIFICATION_NEW_NAME 2
#define ROBOT_NOTIFICATION_NEW_MODULE 3
#define ROBOT_NOTIFICATION_MODULE_RESET 4

// Appearance change flags
#define APPEARANCE_UPDATE_DNA  0x1
#define APPEARANCE_RACE       (0x2|APPEARANCE_UPDATE_DNA)
#define APPEARANCE_GENDER     (0x4|APPEARANCE_UPDATE_DNA)
#define APPEARANCE_SKIN        0x8
#define APPEARANCE_HAIR        0x10
#define APPEARANCE_HAIR_COLOR  0x20
#define APPEARANCE_FACIAL_HAIR 0x40
#define APPEARANCE_FACIAL_HAIR_COLOR 0x80
#define APPEARANCE_EYE_COLOR 0x100
#define APPEARANCE_ALL_HAIR (APPEARANCE_HAIR|APPEARANCE_HAIR_COLOR|APPEARANCE_FACIAL_HAIR|APPEARANCE_FACIAL_HAIR_COLOR)
#define APPEARANCE_ALL       0xFFFF

// Click cooldown
#define DEFAULT_ATTACK_COOLDOWN 8 //Default timeout for aggressive actions
#define DEFAULT_QUICK_COOLDOWN  4


#define MIN_SUPPLIED_LAW_NUMBER 15
#define MAX_SUPPLIED_LAW_NUMBER 50

//default item on-mob icons
#define INV_HEAD_DEF_ICON 'icons/mob/head.dmi'
#define INV_BACK_DEF_ICON 'icons/mob/back.dmi'
#define INV_L_HAND_DEF_ICON 'icons/mob/items/lefthand.dmi'
#define INV_R_HAND_DEF_ICON 'icons/mob/items/righthand.dmi'
#define INV_W_UNIFORM_DEF_ICON 'icons/mob/uniform.dmi'
#define INV_ACCESSORIES_DEF_ICON 'icons/mob/ties.dmi'
#define INV_SUIT_DEF_ICON 'icons/mob/ties.dmi'
#define INV_SUIT_DEF_ICON 'icons/mob/suit.dmi'
#define MAX_SUPPLIED_LAW_NUMBER 50

// Character's economic class
#define CLASS_UPPER 		"Wealthy"
#define CLASS_UPMID			"Well-off"
#define CLASS_MIDDLE 		"Average"
#define CLASS_LOWMID		"Underpaid"
#define CLASS_LOWER			"Poor"

#define ECONOMIC_CLASS		list(CLASS_UPPER,CLASS_UPMID,CLASS_MIDDLE,CLASS_LOWMID,CLASS_LOWER)


// Defines mob sizes, used by lockers and to determine what is considered a small sized mob, etc.
#define MOB_HUGE  		40
#define MOB_LARGE		30
#define MOB_MEDIUM 		20
#define MOB_SMALL 		10
#define MOB_TINY 		5
#define MOB_MINISCULE	1

#define TINT_NONE 0
#define TINT_MODERATE 1
#define TINT_HEAVY 2
#define TINT_BLIND 3

#define FLASH_PROTECTION_VULNERABLE -2
#define FLASH_PROTECTION_REDUCED -1
#define FLASH_PROTECTION_NONE 0
#define FLASH_PROTECTION_MODERATE 1
#define FLASH_PROTECTION_MAJOR 2

#define ANIMAL_SPAWN_DELAY round(config.respawn_delay / 6)
#define DRONE_SPAWN_DELAY  round(config.respawn_delay / 3)

#define ANIMAL_SPAWN_DELAY round(config.respawn_delay / 6)
#define DRONE_SPAWN_DELAY  round(config.respawn_delay / 3)

// Incapacitation flags, used by the mob/proc/incapacitated() proc
#define INCAPACITATION_RESTRAINED 1
#define INCAPACITATION_BUCKLED_PARTIALLY 2
#define INCAPACITATION_BUCKLED_FULLY 4
#define INCAPACITATION_STUNNED 8
#define INCAPACITATION_FORCELYING 16 //needs a better name - represents being knocked down BUT still conscious.
#define INCAPACITATION_KNOCKOUT 32
#define INCAPACITATION_NONE 0

#define INCAPACITATION_DEFAULT (INCAPACITATION_RESTRAINED|INCAPACITATION_BUCKLED_FULLY)
#define INCAPACITATION_KNOCKDOWN (INCAPACITATION_KNOCKOUT|INCAPACITATION_FORCELYING)
#define INCAPACITATION_DISABLED (INCAPACITATION_KNOCKDOWN|INCAPACITATION_STUNNED)
#define INCAPACITATION_ALL (~INCAPACITATION_NONE)

#define MODIFIER_STACK_FORBID	1	// Disallows stacking entirely.
#define MODIFIER_STACK_EXTEND	2	// Disallows a second instance, but will extend the first instance if possible.
#define MODIFIER_STACK_ALLOWED	3	// Multiple instances are allowed.

#define MODIFIER_GENETIC	1	// Modifiers with this flag will be copied to mobs who get cloned.

// Bodyparts and organs.
#define O_MOUTH    "mouth"
#define O_EYES     "eyes"
#define O_HEART    "heart"
#define O_CELL     "cell"
#define O_LUNGS    "lungs"
#define O_BRAIN    "brain"
#define O_LIVER    "liver"
#define O_KIDNEYS  "kidneys"
#define O_APPENDIX "appendix"
#define O_PLASMA   "plasma vessel"
#define O_HIVE     "hive node"
#define O_NUTRIENT "nutrient vessel"
#define O_STRATA   "neural strata"
#define O_RESPONSE "response node"
#define O_GBLADDER "gas bladder"
#define O_POLYP    "polyp segment"
#define O_ANCHOR   "anchoring ligament"
#define O_ACID     "acid gland"
#define O_EGG      "egg sac"
#define O_RESIN    "resin spinner"

#define BP_L_FOOT "l_foot"
#define BP_R_FOOT "r_foot"
#define BP_L_LEG  "l_leg"
#define BP_R_LEG  "r_leg"
#define BP_L_HAND "l_hand"
#define BP_R_HAND "r_hand"
#define BP_L_ARM  "l_arm"
#define BP_R_ARM  "r_arm"
#define BP_HEAD   "head"
#define BP_TORSO  "torso"
#define BP_GROIN  "groin"
#define BP_ALL list(BP_GROIN, BP_TORSO, BP_HEAD, BP_L_ARM, BP_R_ARM, BP_L_HAND, BP_R_HAND, BP_L_FOOT, BP_R_FOOT, BP_L_LEG, BP_R_LEG)

#define SYNTH_BLOOD_COLOUR "#030303"
#define SYNTH_FLESH_COLOUR "#575757"

#define MOB_PULL_NONE 0
#define MOB_PULL_SMALLER 1
#define MOB_PULL_SAME 2
#define MOB_PULL_LARGER 3

//XENOBIO2 FLAGS
#define NOMUT		0
#define COLORMUT 	1
#define SPECIESMUT	2

//carbon taste sensitivity defines, used in mob/living/carbon/proc/ingest
#define TASTE_HYPERSENSITIVE 3 //anything below 5%
#define TASTE_SENSITIVE 2 //anything below 7%
#define TASTE_NORMAL 1 //anything below 15%
#define TASTE_DULL 0.5 //anything below 30%
#define TASTE_NUMB 0.1 //anything below 150%

// If they're in an FBP, what braintype.
#define FBP_NONE	""
#define FBP_CYBORG	"Cyborg"
#define FBP_POSI	"Positronic"
#define FBP_DRONE	"Drone"

// Used to seperate simple animals by ""intelligence"".
#define SA_PLANT	1
#define SA_ANIMAL	2
#define SA_ROBOTIC	3
#define SA_HUMANOID	4

// For slime commanding.  Higher numbers allow for more actions.
#define SLIME_COMMAND_OBEY		1 // When disciplined.
#define SLIME_COMMAND_FACTION	2 // When in the same 'faction'.
#define SLIME_COMMAND_FRIEND	3 // When befriended with a slime friendship agent.

//Vision flags, for dealing with plane visibility
#define VIS_FULLBRIGHT		1
#define VIS_LIGHTING		2
#define VIS_GHOSTS			3
#define VIS_AI_EYE			4

#define VIS_CH_STATUS		5
#define VIS_CH_HEALTH		6
#define VIS_CH_LIFE			7
#define VIS_CH_ID			8
#define VIS_CH_WANTED		9
#define VIS_CH_IMPLOYAL		10
#define VIS_CH_IMPTRACK		11
#define VIS_CH_IMPCHEM		12
#define VIS_CH_SPECIAL		13
#define VIS_CH_STATUS_OOC	14

#define VIS_D_COLORBLIND	15
#define VIS_D_COLORBLINDI	16

#define VIS_ADMIN1			17
#define VIS_ADMIN2			18
#define VIS_ADMIN3			19

#define VIS_MESONS			20

#define VIS_COUNT			20 //Must be highest number from above.
