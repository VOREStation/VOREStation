// Bitflags for mutations.
#define STRUCDNASIZE 27
#define   UNIDNASIZE 13

// Generic mutations:
#define TK              1
#define COLD_RESISTANCE 2
#define XRAY            3
#define HULK            4
#define CLUMSY          5
#define FAT             6
#define HUSK            7
#define NOCLONE         8
#define LASER           9  // Harm intent - click anywhere to shoot lasers from eyes.
#define HEAL            10 // Healing people with hands.

#define SKELETON      29
#define PLANT         30

// Other Mutations:
#define mNobreath      100 // No need to breathe.
#define mRemote        101 // Remote viewing.
#define mRegen         102 // Health regeneration.
#define mRun           103 // No slowdown.
#define mRemotetalk    104 // Remote talking.
#define mMorph         105 // Hanging appearance.
#define mBlend         106 // Nothing. (seriously nothing)
#define mHallucination 107 // Hallucinations.
#define mFingerprints  108 // No fingerprints.
#define mShock         109 // Insulated hands.
#define mSmallsize     110 // Table climbing.

// disabilities
#define NEARSIGHTED 0x1
#define EPILEPSY    0x2
#define COUGHING    0x4
#define TOURETTES   0x8
#define NERVOUS     0x10

// sdisabilities
#define BLIND 0x1
#define MUTE  0x2
#define DEAF  0x4

// The way blocks are handled badly needs a rewrite, this is horrible.
// Too much of a project to handle at the moment, TODO for later.
var/BLINDBLOCK    = 0
var/DEAFBLOCK     = 0
var/HULKBLOCK     = 0
var/TELEBLOCK     = 0
var/FIREBLOCK     = 0
var/XRAYBLOCK     = 0
var/CLUMSYBLOCK   = 0
var/FAKEBLOCK     = 0
var/COUGHBLOCK    = 0
var/GLASSESBLOCK  = 0
var/EPILEPSYBLOCK = 0
var/TWITCHBLOCK   = 0
var/NERVOUSBLOCK  = 0
var/MONKEYBLOCK   = STRUCDNASIZE

var/BLOCKADD = 0
var/DIFFMUT  = 0

var/HEADACHEBLOCK      = 0
var/NOBREATHBLOCK      = 0
var/REMOTEVIEWBLOCK    = 0
var/REGENERATEBLOCK    = 0
var/INCREASERUNBLOCK   = 0
var/REMOTETALKBLOCK    = 0
var/MORPHBLOCK         = 0
var/BLENDBLOCK         = 0
var/HALLUCINATIONBLOCK = 0
var/NOPRINTSBLOCK      = 0
var/SHOCKIMMUNITYBLOCK = 0
var/SMALLSIZEBLOCK     = 0

// Define block bounds (off-low,off-high,on-low,on-high)
// Used in setupgame.dm
#define DNA_DEFAULT_BOUNDS list(1,2049,2050,4095)
#define DNA_HARDER_BOUNDS  list(1,3049,3050,4095)
#define DNA_HARD_BOUNDS    list(1,3490,3500,4095)

// UI Indices (can change to mutblock style, if desired)
#define DNA_UI_HAIR_R      1
#define DNA_UI_HAIR_G      2
#define DNA_UI_HAIR_B      3
#define DNA_UI_BEARD_R     4
#define DNA_UI_BEARD_G     5
#define DNA_UI_BEARD_B     6
#define DNA_UI_SKIN_TONE   7
#define DNA_UI_SKIN_R      8
#define DNA_UI_SKIN_G      9
#define DNA_UI_SKIN_B      10
#define DNA_UI_EYES_R      11
#define DNA_UI_EYES_G      12
#define DNA_UI_EYES_B      13
#define DNA_UI_GENDER      14
#define DNA_UI_BEARD_STYLE 15
#define DNA_UI_HAIR_STYLE  16
#define DNA_UI_EAR_STYLE   17 // VOREStation snippet.
#define DNA_UI_EAR_SECONDARY_STYLE   18 // VOREStation snippet.
#define DNA_UI_TAIL_STYLE  19
#define DNA_UI_PLAYERSCALE 20
#define DNA_UI_TAIL_R      21
#define DNA_UI_TAIL_G      22
#define DNA_UI_TAIL_B      23
#define DNA_UI_TAIL2_R     24
#define DNA_UI_TAIL2_G     25
#define DNA_UI_TAIL2_B     26
#define DNA_UI_TAIL3_R     27
#define DNA_UI_TAIL3_G     28
#define DNA_UI_TAIL3_B     29

#define DNA_UI_EARS_R      30
#define DNA_UI_EARS_G      31
#define DNA_UI_EARS_B      32
#define DNA_UI_EARS2_R     33
#define DNA_UI_EARS2_G     34
#define DNA_UI_EARS2_B     35
#define DNA_UI_EARS3_R     36
#define DNA_UI_EARS3_G     37
#define DNA_UI_EARS3_B     38

#define DNA_UI_EARS_SECONDARY_START 39
#define DNA_UI_EARS_SECONDARY_COLOR_CHANNEL_COUNT 3

#define DNA_UI_EARS_SECONDARY_R      39
#define DNA_UI_EARS_SECONDARY_G      40
#define DNA_UI_EARS_SECONDARY_B      41
#define DNA_UI_EARS_SECONDARY2_R     42
#define DNA_UI_EARS_SECONDARY2_G     43
#define DNA_UI_EARS_SECONDARY2_B     44
#define DNA_UI_EARS_SECONDARY3_R     45
#define DNA_UI_EARS_SECONDARY3_G     46
#define DNA_UI_EARS_SECONDARY3_B     47

#define DNA_UI_WING_STYLE  48
#define DNA_UI_WING_R      49
#define DNA_UI_WING_G      50
#define DNA_UI_WING_B      51
#define DNA_UI_WING2_R     52
#define DNA_UI_WING2_G     53
#define DNA_UI_WING2_B     54
#define DNA_UI_WING3_R     55
#define DNA_UI_WING3_G     56
#define DNA_UI_WING3_B     57 // VOREStation snippet end.
#define DNA_UI_LENGTH      57 // VOREStation Edit - Needs to match the highest number above.

#define DNA_SE_LENGTH 49 // VOREStation Edit (original was UI+11)

//DNA modifiers
// Buffer datatype flags.
#define DNA2_BUF_UI 1
#define DNA2_BUF_UE 2
#define DNA2_BUF_SE 4

// Mutation flags
#define MUTCHK_FORCED        1

// Gene flags
#define GENE_ALWAYS_ACTIVATE 1
#define MUTCHK_HIDEMSG       2
