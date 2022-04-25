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
var/global/BLINDBLOCK    = 0
var/global/DEAFBLOCK     = 0
var/global/HULKBLOCK     = 0
var/global/TELEBLOCK     = 0
var/global/FIREBLOCK     = 0
var/global/XRAYBLOCK     = 0
var/global/CLUMSYBLOCK   = 0
var/global/FAKEBLOCK     = 0
var/global/COUGHBLOCK    = 0
var/global/GLASSESBLOCK  = 0
var/global/EPILEPSYBLOCK = 0
var/global/TWITCHBLOCK   = 0
var/global/NERVOUSBLOCK  = 0
var/global/MONKEYBLOCK   = STRUCDNASIZE

var/global/BLOCKADD = 0
var/global/DIFFMUT  = 0

var/global/HEADACHEBLOCK      = 0
var/global/NOBREATHBLOCK      = 0
var/global/REMOTEVIEWBLOCK    = 0
var/global/REGENERATEBLOCK    = 0
var/global/INCREASERUNBLOCK   = 0
var/global/REMOTETALKBLOCK    = 0
var/global/MORPHBLOCK         = 0
var/global/BLENDBLOCK         = 0
var/global/HALLUCINATIONBLOCK = 0
var/global/NOPRINTSBLOCK      = 0
var/global/SHOCKIMMUNITYBLOCK = 0
var/global/SMALLSIZEBLOCK     = 0
