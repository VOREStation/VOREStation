// Ticker game states, turns out these are  equivilent to runlevels1
#define GAME_STATE_INIT			0	// RUNLEVEL_INIT
#define GAME_STATE_PREGAME		1	// RUNLEVEL_LOBBY
#define GAME_STATE_SETTING_UP	2	// RUNLEVEL_SETUP
#define GAME_STATE_PLAYING		3	// RUNLEVEL_GAME
#define GAME_STATE_FINISHED		4	// RUNLEVEL_POSTGAME

//End game state, to manage round end.
#define END_GAME_NOT_OVER		1	// Still playing normally
#define END_GAME_MODE_FINISHED	2	// Mode has finished but game has not, wait for game to end too.
#define END_GAME_READY_TO_END	3	// Game and Mode have finished, do rounded stuff.
#define END_GAME_ENDING			4	// Just waiting for ending timer.
#define END_GAME_DELAYED		5	// Admin has delayed the round.

// Security levels.
#define SEC_LEVEL_GREEN 0
#define SEC_LEVEL_YELLOW  1
#define SEC_LEVEL_VIOLET  2
#define SEC_LEVEL_ORANGE  3
#define SEC_LEVEL_BLUE  4
#define SEC_LEVEL_RED   5
#define SEC_LEVEL_DELTA 6

#define BE_TRAITOR    0x1
#define BE_OPERATIVE  0x2
#define BE_CHANGELING 0x4
#define BE_WIZARD     0x8
#define BE_MALF       0x10
#define BE_REV        0x20
#define BE_ALIEN      0x40
#define BE_AI         0x80
#define BE_CULTIST    0x100
#define BE_RENEGADE   0x200
#define BE_NINJA      0x400
#define BE_RAIDER     0x800
#define BE_PLANT      0x1000
#define BE_MUTINEER   0x2000
#define BE_LOYALIST   0x4000
#define BE_PAI        0x8000
//VOREStation Add
#define BE_LOSTDRONE	0x10000
#define BE_MAINTPRED	0x20000
#define BE_MORPH		0x40000
#define BE_CORGI		0x80000
#define BE_CURSEDSWORD	0x100000
#define BE_SURVIVOR		0x200000
#define BE_EVENT		0x400000
//VOREStation Add End

var/list/be_special_flags = list(
	"Traitor"          = BE_TRAITOR,
	"Operative"        = BE_OPERATIVE,
	"Changeling"       = BE_CHANGELING,
	"Wizard"           = BE_WIZARD,
	"Malf AI"          = BE_MALF,
	"Revolutionary"    = BE_REV,
	"Xenomorph"        = BE_ALIEN,
	"Positronic Brain" = BE_AI,
	"Cultist"          = BE_CULTIST,
	"Renegade"         = BE_RENEGADE,
	"Ninja"            = BE_NINJA,
	"Raider"           = BE_RAIDER,
	"Diona"            = BE_PLANT,
	"Mutineer"         = BE_MUTINEER,
	"Loyalist"         = BE_LOYALIST,
	"pAI"              = BE_PAI,
	//VOREStation Add
	"Lost Drone"       = BE_LOSTDRONE,
	"Maint Pred"       = BE_MAINTPRED,
	"Morph"            = BE_MORPH,
	"Corgi"            = BE_CORGI,
	"Cursed Sword"     = BE_CURSEDSWORD,
	"Ship Survivor"	   = BE_SURVIVOR
	//VOREStation Add End
)


// Antagonist datum flags.
#define ANTAG_OVERRIDE_JOB        0x1 // Assigned job is set to MODE when spawning.
#define ANTAG_OVERRIDE_MOB        0x2 // Mob is recreated from datum mob_type var when spawning.
#define ANTAG_CLEAR_EQUIPMENT     0x4 // All preexisting equipment is purged.
#define ANTAG_CHOOSE_NAME         0x8 // Antagonists are prompted to enter a name.
#define ANTAG_IMPLANT_IMMUNE     0x10 // Cannot be loyalty implanted.
#define ANTAG_SUSPICIOUS         0x20 // Shows up on roundstart report.
#define ANTAG_HAS_LEADER         0x40 // Generates a leader antagonist.
#define ANTAG_HAS_NUKE           0x80 // Will spawn a nuke at supplied location.
#define ANTAG_RANDSPAWN         0x100 // Potentially randomly spawns due to events.
#define ANTAG_VOTABLE           0x200 // Can be voted as an additional antagonist before roundstart.
#define ANTAG_SET_APPEARANCE    0x400 // Causes antagonists to use an appearance modifier on spawn.

// Mode/antag template macros.
#define MODE_BORER "borer"
#define MODE_XENOMORPH "xeno"
#define MODE_LOYALIST "loyalist"
#define MODE_MUTINEER "mutineer"
#define MODE_COMMANDO "commando"
#define MODE_DEATHSQUAD "deathsquad"
#define MODE_ERT "ert"
#define MODE_TRADE "trader"
#define MODE_MERCENARY "mercenary"
#define MODE_NINJA "ninja"
#define MODE_RAIDER "raider"
#define MODE_WIZARD "wizard"
#define MODE_TECHNOMANCER "technomancer"
#define MODE_CHANGELING "changeling"
#define MODE_CULTIST "cultist"
#define MODE_HIGHLANDER "highlander"
#define MODE_MONKEY "monkey"
#define MODE_RENEGADE "renegade"
#define MODE_REVOLUTIONARY "revolutionary"
#define MODE_MALFUNCTION "malf"
#define MODE_TRAITOR "traitor"
#define MODE_AUTOTRAITOR "autotraitor"
#define MODE_INFILTRATOR "infiltrator"
#define MODE_THUG "thug"
#define MODE_STOWAWAY "stowaway"
#define MODE_SURVIVOR "Shipwreck Survivor"
#define MODE_EVENT "Event Character"

#define DEFAULT_TELECRYSTAL_AMOUNT 120

/////////////////
////WIZARD //////
/////////////////

/*		WIZARD SPELL FLAGS		*/
#define GHOSTCAST		0x1		//can a ghost cast it?
#define NEEDSCLOTHES	0x2		//does it need the wizard garb to cast? Nonwizard spells should not have this
#define NEEDSHUMAN		0x4		//does it require the caster to be human?
#define Z2NOCAST		0x8		//if this is added, the spell can't be cast at CentCom
#define STATALLOWED		0x10	//if set, the user doesn't have to be conscious to cast. Required for ghost spells
#define IGNOREPREV		0x20	//if set, each new target does not overlap with the previous one
//The following flags only affect different types of spell, and therefore overlap
//Targeted spells
#define INCLUDEUSER		0x40	//does the spell include the caster in its target selection?
#define SELECTABLE		0x80	//can you select each target for the spell?
//AOE spells
#define IGNOREDENSE		0x40	//are dense turfs ignored in selection?
#define IGNORESPACE		0x80	//are space turfs ignored in selection?
//End split flags
#define CONSTRUCT_CHECK	0x100	//used by construct spells - checks for nullrods
#define NO_BUTTON		0x200	//spell won't show up in the HUD with this

//invocation
#define SpI_SHOUT	"shout"
#define SpI_WHISPER	"whisper"
#define SpI_EMOTE	"emote"
#define SpI_NONE	"none"

//upgrading
#define Sp_SPEED	"speed"
#define Sp_POWER	"power"
#define Sp_TOTAL	"total"

//casting costs
#define Sp_RECHARGE	"recharge"
#define Sp_CHARGES	"charges"
#define Sp_HOLDVAR	"holdervar"

#define CHANGELING_STASIS_COST 20

//Spell stuff, for Technomancer and Cult.
//cast_method flags
#define CAST_USE		1	// Clicking the spell in your hand.
#define CAST_MELEE		2	// Clicking an atom in melee range.
#define CAST_RANGED		4	// Clicking an atom beyond melee range.
#define CAST_THROW		8	// Throwing the spell and hitting an atom.
#define CAST_COMBINE	16	// Clicking another spell with this spell.
#define CAST_INNATE		32	// Activates upon verb usage, used for mobs without hands.

//Aspects
#define ASPECT_FIRE			"fire" 		//Damage over time and raising body-temp.  Firesuits protect from this.
#define ASPECT_FROST		"frost"		//Slows down the affected, also involves imbedding with icicles.  Winter coats protect from this.
#define ASPECT_SHOCK		"shock"		//Energy-expensive, usually stuns.  Insulated armor protects from this.
#define ASPECT_AIR			"air"		//Mostly involves manipulation of atmos, useless in a vacuum.  Magboots protect from this.
#define ASPECT_FORCE		"force" 	//Manipulates gravity to push things away or towards a location.
#define ASPECT_TELE			"tele"		//Teleportation of self, other objects, or other people.
#define ASPECT_DARK			"dark"		//Makes all those photons vanish using magic-- WITH SCIENCE.  Used for sneaky stuff.
#define ASPECT_LIGHT		"light"		//The opposite of dark, usually blinds, makes holo-illusions, or makes laser lightshows.
#define ASPECT_BIOMED		"biomed"	//Mainly concerned with healing and restoration.
#define ASPECT_EMP			"emp"		//Unused now.
#define ASPECT_UNSTABLE		"unstable"	//Heavily RNG-based, causes instability to the victim.
#define ASPECT_CHROMATIC	"chromatic"	//Used to combine with other spells.
#define ASPECT_UNHOLY		"unholy"	//Involves the dead, blood, and most things against divine beings.
