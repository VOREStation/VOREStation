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
#define HIDING      0x20
#define PASSEMOTES  0x40    // Mob has a cortical borer or holders inside of it that need to see emotes.
#define GODMODE     0x1000
#define FAKEDEATH   0x2000  // Replaces stuff like changeling.changeling_fakedeath.
#define DISFIGURED  0x4000  // Set but never checked. Remove this sometime and replace occurences with the appropriate organ code
#define DOING_TASK	0x8000  // Performing a do_after or do_mob that's exclusive

// Grab levels.
#define GRAB_PASSIVE    1
#define GRAB_AGGRESSIVE 2
#define GRAB_NECK       3
#define GRAB_UPGRADING  4
#define GRAB_KILL       5

#define BORGMESON 0x1
#define BORGTHERM 0x2
#define BORGXRAY  0x4
#define BORGMATERIAL  0x8

#define STANCE_ATTACK    11 // Backwards compatability
#define STANCE_ATTACKING 12 // Ditto
/*
#define STANCE_IDLE      1	// Looking for targets if hostile.  Does idle wandering.
#define STANCE_ALERT     2	// Bears
#define STANCE_ATTACK    3	// Attempting to get into attack position
#define STANCE_ATTACKING 4	// Doing attacks
#define STANCE_TIRED     5	// Bears
#define STANCE_FOLLOW    6	// Following somone
#define STANCE_BUSY      7	// Do nothing on life ticks (Other code is running)
*/
#define STANCE_SLEEP        0	// Doing (almost) nothing, to save on CPU because nobody is around to notice or the mob died.
#define STANCE_IDLE         1	// The more or less default state. Wanders around, looks for baddies, and spouts one-liners.
#define STANCE_ALERT        2	// A baddie is visible but not too close, and essentially we tell them to go away or die.
#define STANCE_APPROACH     3	// Attempting to get into range to attack them.
#define STANCE_FIGHT	    4	// Actually fighting, with melee or ranged.
#define STANCE_BLINDFIGHT   5	// Fighting something that cannot be seen by the mob, from invisibility or out of sight.
#define STANCE_REPOSITION   6	// Relocating to a better position while in combat. Also used when moving away from a danger like grenades.
#define STANCE_MOVE         7	// Similar to above but for out of combat. If a baddie is seen, they'll cancel and fight them.
#define STANCE_FOLLOW       8	// Following somone, without trying to murder them.
#define STANCE_FLEE         9	// Run away from the target because they're too spooky/we're dying/some other reason.
#define STANCE_DISABLED     10	// Used when the holder is afflicted with certain status effects, such as stuns or confusion.

#define STANCES_COMBAT      list(STANCE_ALERT, STANCE_APPROACH, STANCE_FIGHT, STANCE_BLINDFIGHT, STANCE_REPOSITION)

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
#define ROBOT_NOTIFICATION_AI_SHELL 5

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
<<<<<<< HEAD
#define INV_L_HAND_DEF_ICON 'icons/mob/items/lefthand.dmi'
#define INV_R_HAND_DEF_ICON 'icons/mob/items/righthand.dmi'
#define INV_WEAR_ID_DEF_ICON 'icons/mob/mob.dmi'
#define INV_HCUFF_DEF_ICON 'icons/mob/mob.dmi'
#define INV_LCUFF_DEF_ICON 'icons/mob/mob.dmi'
=======
#define INV_W_UNIFORM_DEF_STRING "icons/mob/uniform"
#define INV_SUIT_DEF_STRING      "icons/mob/suit"

#define INV_HEAD_DEF_ICON        'icons/mob/head.dmi'
#define INV_BACK_DEF_ICON        'icons/mob/back.dmi'
#define INV_L_HAND_DEF_ICON      'icons/mob/items/lefthand.dmi'
#define INV_R_HAND_DEF_ICON      'icons/mob/items/righthand.dmi'
#define INV_W_UNIFORM_DEF_ICON   'icons/mob/uniform.dmi'
#define INV_ACCESSORIES_DEF_ICON 'icons/mob/ties.dmi'
#define INV_TIE_DEF_ICON         'icons/mob/ties.dmi'
#define INV_SUIT_DEF_ICON        'icons/mob/suit.dmi'
#define INV_SPACESUIT_DEF_ICON   'icons/mob/spacesuit.dmi'
#define INV_WEAR_ID_DEF_ICON     'icons/mob/mob.dmi'
#define INV_GLOVES_DEF_ICON      'icons/mob/hands.dmi'
#define INV_EYES_DEF_ICON        'icons/mob/eyes.dmi'
#define INV_EARS_DEF_ICON        'icons/mob/ears.dmi'
#define INV_FEET_DEF_ICON        'icons/mob/feet.dmi'
#define INV_BELT_DEF_ICON        'icons/mob/belt.dmi'
#define INV_MASK_DEF_ICON        'icons/mob/mask.dmi'
#define INV_HCUFF_DEF_ICON       'icons/mob/mob.dmi'
#define INV_LCUFF_DEF_ICON       'icons/mob/mob.dmi'
>>>>>>> 9a846673232... Reworks on-mob overlay icon generation. (#8920)

#define INV_HEAD_DEF_ICON 'icons/inventory/head/mob.dmi'
#define INV_BACK_DEF_ICON 'icons/inventory/back/mob.dmi'
#define INV_W_UNIFORM_DEF_ICON 'icons/inventory/uniform/mob.dmi'
#define INV_ACCESSORIES_DEF_ICON 'icons/inventory/accessory/mob.dmi'
#define INV_SUIT_DEF_ICON 'icons/inventory/suit/mob.dmi'
#define INV_GLOVES_DEF_ICON 'icons/inventory/hands/mob.dmi'
#define INV_EYES_DEF_ICON 'icons/inventory/eyes/mob.dmi'
#define INV_EARS_DEF_ICON 'icons/inventory/ears/mob.dmi'
#define INV_FEET_DEF_ICON 'icons/inventory/feet/mob.dmi'
#define INV_BELT_DEF_ICON 'icons/inventory/belt/mob.dmi'
#define INV_MASK_DEF_ICON 'icons/inventory/face/mob.dmi'

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
#define O_EYES     "eyes"
#define O_HEART    "heart"
#define O_LUNGS    "lungs"
#define O_BRAIN    "brain"
#define O_LIVER    "liver"
#define O_KIDNEYS  "kidneys"
#define O_APPENDIX "appendix"
#define O_VOICE    "voicebox"
#define O_SPLEEN   "spleen"
#define O_STOMACH  "stomach"
#define O_INTESTINE "intestine"
#define O_STANDARD list(O_EYES, O_HEART, O_LUNGS, O_BRAIN, O_LIVER, O_KIDNEYS, O_SPLEEN, O_APPENDIX, O_VOICE, O_STOMACH, O_INTESTINE)

// Augments
#define O_AUG_EYES "occular augment"

#define O_AUG_L_FOREARM "left forearm augment"
#define O_AUG_R_FOREARM "right forearm augment"
#define O_AUG_L_UPPERARM "left upperarm augment"
#define O_AUG_R_UPPERARM "right upperarm augment"
#define O_AUG_L_HAND "left hand augment"
#define O_AUG_R_HAND "right hand augment"

#define O_AUG_RIBS "rib augment"
#define O_AUG_SPINE "spinal augment"
#define O_AUG_PELVIC "pelvic augment"

// FBP components.

#define O_PUMP     "hydraulic hub"
#define O_CYCLER   "reagent cycler"
#define O_HEATSINK "thermal regulator"
#define O_DIAGNOSTIC "diagnostic controller"

// Non-Standard organs
#define O_MOUTH    "mouth"
#define O_CELL     "cell"
#define O_PLASMA   "plasma vessel"
#define O_HIVE     "hive node"
#define O_NUTRIENT "nutrient vessel"
#define O_STRATA   "neural strata"
#define O_RESPONSE "response node"
#define O_GBLADDER "gas bladder"
#define O_POLYP    "polyp segment"
#define O_ANCHOR   "anchoring ligament"
#define O_REGBRUTE "pneumoregenitor"
#define O_REGBURN  "thermoregenitor"
#define O_REGOXY   "respiroregenitor"
#define O_REGTOX   "toxoregenitor"
#define O_ACID     "acid gland"
#define O_EGG      "egg sac"
#define O_RESIN    "resin spinner"
#define O_AREJECT  "immune hub"
#define O_VENTC    "morphoplastic node"
#define O_VRLINK   "virtual node"
#define O_ALL list(O_STANDARD, O_MOUTH, O_CELL, O_PLASMA, O_HIVE, O_NUTRIENT, O_STRATA, O_RESPONSE, O_GBLADDER, O_POLYP, O_ANCHOR, O_REGBRUTE, O_REGBURN, O_REGOXY, O_REGTOX, O_ACID, O_EGG, O_RESIN, O_AREJECT, O_VENTC, O_VRLINK)

// External organs, aka limbs
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
#define BP_ALL list(BP_TORSO, BP_HEAD, BP_GROIN, BP_L_ARM, BP_R_ARM, BP_L_HAND, BP_R_HAND, BP_L_LEG, BP_R_LEG, BP_L_FOOT, BP_R_FOOT) //keep so that parent comes before child

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

//Used by emotes
#define VISIBLE_MESSAGE 1
#define AUDIBLE_MESSAGE 2

// If they're in an FBP, what braintype.
#define FBP_NONE	""
#define FBP_CYBORG	"Cyborg"
#define FBP_POSI	"Positronic"
#define FBP_DRONE	"Drone"

// Similar to above but for borgs.
// Seperate defines are unfortunately required since borgs display the brain differently for some reason.
#define BORG_BRAINTYPE_CYBORG	"Cyborg"
#define BORG_BRAINTYPE_POSI		"Robot"
#define BORG_BRAINTYPE_DRONE	"Drone"
#define BORG_BRAINTYPE_PLATFORM	"Platform"
#define BORG_BRAINTYPE_AI_SHELL	"AI Shell"

// 'Regular' species.
#define SPECIES_HUMAN			"Human"
#define SPECIES_HUMAN_VATBORN	"Vatborn"
#define SPECIES_UNATHI			"Unathi"
#define SPECIES_SKRELL			"Skrell"
#define SPECIES_TESHARI			"Teshari"
#define SPECIES_TAJ				"Tajara"
#define SPECIES_PROMETHEAN		"Promethean"
#define SPECIES_DIONA			"Diona"
#define SPECIES_VOX				"Vox"
#define SPECIES_ZADDAT			"Zaddat"

// Monkey and alien monkeys.
#define SPECIES_MONKEY			"Monkey"
#define SPECIES_MONKEY_TAJ		"Farwa"
#define SPECIES_MONKEY_SKRELL	"Neaera"
#define SPECIES_MONKEY_UNATHI	"Stok"

// Virtual Reality IDs.
#define SPECIES_VR				"Virtual Reality Avatar"
#define SPECIES_VR_HUMAN		"Virtual Reality Human"
#define SPECIES_VR_UNATHI		"Virtual Reality Unathi"
#define SPECIES_VR_TAJ			"Virtual Reality Tajara" // NO CHANGING.
#define SPECIES_VR_SKRELL		"Virtual Reality Skrell"
#define SPECIES_VR_TESHARI		"Virtual Reality Teshari"
#define SPECIES_VR_DIONA		"Virtual Reality Diona"
#define SPECIES_VR_MONKEY		"Virtual Reality Monkey"
#define SPECIES_VR_SKELETON		"Virtual Reality Skeleton"
#define SPECIES_VR_VOX			"Virtual Reality Vox"

// Ayyy IDs.
#define SPECIES_XENO			"Xenomorph"
#define SPECIES_XENO_DRONE		"Xenomorph Drone"
#define SPECIES_XENO_HUNTER		"Xenomorph Hunter"
#define SPECIES_XENO_SENTINEL	"Xenomorph Sentinel"
#define SPECIES_XENO_QUEEN		"Xenomorph Queen"

// Misc species. Mostly unused but might as well be complete.
#define SPECIES_SHADOW			"Shadow"
#define SPECIES_SKELETON		"Skeleton"
#define SPECIES_GOLEM			"Golem"
#define SPECIES_EVENT1			"X Occursus"
#define SPECIES_EVENT2			"X Anomalous"
#define SPECIES_EVENT3			"X Unowas"

// Replicant types. Currently only used for alien pods and events.
#define SPECIES_REPLICANT		"Replicant"
#define SPECIES_REPLICANT_ALPHA	"Alpha Replicant"
#define SPECIES_REPLICANT_BETA	"Beta Replicant"

// Used to seperate simple animals by ""intelligence"".
#define SA_PLANT	1
#define SA_ANIMAL	2
#define SA_ROBOTIC	3
#define SA_HUMANOID	4

// More refined version of SA_* ""intelligence"" seperators.
// Now includes bitflags, so to target two classes you just do 'MOB_CLASS_ANIMAL|MOB_CLASS_HUMANOID'
#define MOB_CLASS_NONE 			0	// Default value, and used to invert for _ALL.

#define MOB_CLASS_PLANT			1	// Unused at the moment.
#define MOB_CLASS_ANIMAL		2	// Animals and beasts like spiders, saviks, and bears.
#define MOB_CLASS_HUMANOID		4	// Non-robotic humanoids, including /simple_mob and /carbon/humans and their alien variants.
#define MOB_CLASS_SYNTHETIC		8	// Silicons, mechanical simple mobs, FBPs, and anything else that would pass is_synthetic()
#define MOB_CLASS_SLIME			16	// Everyone's favorite xenobiology specimen (and maybe prometheans?).
#define MOB_CLASS_ABERRATION	32	// Weird shit.
#define MOB_CLASS_DEMONIC		64	// Cult stuff.
#define MOB_CLASS_BOSS			128	// Future megafauna hopefully someday.
#define MOB_CLASS_ILLUSION		256	// Fake mobs, e.g. Technomancer illusions.
#define MOB_CLASS_PHOTONIC		512	// Holographic mobs like holocarp, similar to _ILLUSION, but that make no attempt to hide their true nature.

#define MOB_CLASS_ALL (~MOB_CLASS_NONE)

// For slime commanding.  Higher numbers allow for more actions.
#define SLIME_COMMAND_OBEY		1 // When disciplined.
#define SLIME_COMMAND_FACTION	2 // When in the same 'faction'.
#define SLIME_COMMAND_FRIEND	3 // When befriended with a slime friendship agent.

// Threshold for mobs being able to damage things like airlocks or reinforced glass windows.
// If the damage is below this, nothing will happen besides a message saying that the attack was ineffective.
// Generally, this was not a define but was commonly set to 10, however 10 may be too low now since simple_mobs now attack twice as fast,
// at half damage compared to the old mob system, meaning mobs who could hurt structures may not be able to now, so now it is 5.
#define STRUCTURE_MIN_DAMAGE_THRESHOLD 5

//Vision flags, for dealing with plane visibility
#define VIS_FULLBRIGHT		1
#define VIS_LIGHTING		2
#define VIS_O_LIGHT         3
#define VIS_EMISSIVE        4
#define VIS_OPENSPACE       5

#define VIS_GHOSTS			6
#define VIS_AI_EYE			7

#define VIS_CH_STATUS		8
#define VIS_CH_HEALTH		9
#define VIS_CH_LIFE			10
#define VIS_CH_ID			11
#define VIS_CH_WANTED		12
#define VIS_CH_IMPLOYAL		13
#define VIS_CH_IMPTRACK		14
#define VIS_CH_IMPCHEM		15
#define VIS_CH_SPECIAL		16
#define VIS_CH_STATUS_OOC	17

#define VIS_ADMIN1			18
#define VIS_ADMIN2			19
#define VIS_ADMIN3			20

#define VIS_MESONS			21

#define VIS_TURFS			22
#define VIS_OBJS			23
#define VIS_MOBS		    24

#define VIS_BUILDMODE		25

#define VIS_CLOAKED			26

#define VIS_STATUS			27

#define VIS_COUNT			27 //Must be highest number from above.

//Some mob icon layering defines
#define BODY_LAYER		-100

// Clothing flags, organized in roughly top-bottom
#define EXAMINE_SKIPHELMET			0x0001
#define EXAMINE_SKIPEARS			0x0002
#define EXAMINE_SKIPEYEWEAR			0x0004
#define EXAMINE_SKIPMASK			0x0008
#define EXAMINE_SKIPJUMPSUIT		0x0010
#define EXAMINE_SKIPTIE				0x0020
#define EXAMINE_SKIPHOLSTER			0x0040
#define EXAMINE_SKIPSUITSTORAGE		0x0080
#define EXAMINE_SKIPBACKPACK		0x0100
#define EXAMINE_SKIPGLOVES			0x0200
#define EXAMINE_SKIPBELT			0x0400
#define EXAMINE_SKIPSHOES			0x0800

// Body flags
#define EXAMINE_SKIPHEAD			0x0001
#define EXAMINE_SKIPEYES			0x0002
#define EXAMINE_SKIPFACE			0x0004
#define EXAMINE_SKIPBODY			0x0008
#define EXAMINE_SKIPGROIN			0x0010
#define EXAMINE_SKIPARMS			0x0020
#define EXAMINE_SKIPHANDS			0x0040
#define EXAMINE_SKIPLEGS			0x0080
#define EXAMINE_SKIPFEET			0x0100

#define MAX_NUTRITION	6000 //VOREStation Edit

#define FAKE_INVIS_ALPHA_THRESHOLD 127 // If something's alpha var is at or below this number, certain things will pretend it is invisible.

#define DEATHGASP_NO_MESSAGE "no message"

#define RESIST_COOLDOWN		2 SECONDS

#define VISIBLE_GENDER_FORCE_PLURAL 1		// Used by get_visible_gender to return PLURAL
#define VISIBLE_GENDER_FORCE_IDENTIFYING 2	// Used by get_visible_gender to return the mob's identifying gender
#define VISIBLE_GENDER_FORCE_BIOLOGICAL 3	// Used by get_visible_gender to return the mob's biological gender
