// List indexes for software datum references on mobs
// This also controls the order they are displayed in the NIF stat panel
//AR Overlays
#define NIF_CIVILIAN_AR			1
#define NIF_MEDICAL_AR			2
#define NIF_SECURITY_AR			3
#define NIF_ENGINE_AR			4
#define NIF_SCIENCE_AR			5
#define NIF_OMNI_AR				6
//Misc Vision
#define NIF_CORRECTIVE_GLASS	7
#define NIF_MESONS				8
#define NIF_MATERIAL			9
#define NIF_THERMALS			10
#define	NIF_NIGHTVIS			11
#define NIF_UVFILTER			12
#define NIF_FLASHPROT			13
//Health-related
#define NIF_BACKUP				14
#define NIF_MEDMONITOR			15
#define NIF_ENGMONITOR			16
#define NIF_ORGANIC_HEAL		17
#define NIF_SYNTH_HEAL			18
#define NIF_AUTOSTASIS			19 //These two are just part of
#define NIF_MED_ALARM			20 //medichines right now
#define NIF_TOXHEAL				21 //And this, for organics
#define NIF_SPAREBREATH			22
//Combat Related
#define NIF_BRUTEARMOR			23
#define NIF_BURNARMOR			24
#define NIF_PAINKILLERS			25
#define NIF_HARDCLAWS			26
#define NIF_HIDDENLASER			27
//Other
#define NIF_COMMLINK			28
#define NIF_APCCHARGE			29
#define NIF_PRESSURE			30
#define NIF_HEATSINK			31
#define NIF_COMPLIANCE			32
#define NIF_SIZECHANGE			33
#define NIF_SOULCATCHER			34
#define NIF_WORLDBEND			35
#define NIF_MALWARE				36

// Must be equal to the highest number above
#define TOTAL_NIF_SOFTWARE		36

//////////////////////
// NIF flag list hints
#define NIF_FLAGS_VISION	1
#define NIF_FLAGS_HEALTH	2
#define NIF_FLAGS_COMBAT	3
#define NIF_FLAGS_OTHER		4

// NIF flags
//Vision
#define	NIF_V_AR_CIVILIAN		0x1
#define	NIF_V_AR_MEDICAL		0x2
#define NIF_V_AR_SECURITY		0x4
#define NIF_V_AR_ENGINE			0x8
#define NIF_V_AR_SCIENCE		0x10
#define NIF_V_AR_OMNI			0x20
#define	NIF_V_CORRECTIVE		0x40
#define NIF_V_MESONS			0x80
#define NIF_V_MATERIAL			0x100
#define NIF_V_THERMALS			0x200
#define NIF_V_NIGHTVIS			0x400
#define NIF_V_UVFILTER			0x800
#define NIF_V_FLASHPROT			0x1000

//Health
#define NIF_H_ORGREPAIR			0x1
#define NIF_H_SYNTHREPAIR		0x2
#define NIF_H_AUTOSTASIS		0x4 //These two are just part of
#define NIF_H_ALERTMED			0x8 //medichines right now
#define NIF_H_TOXREGEN			0x10
#define NIF_H_SPAREBREATH		0x20

//Combat
#define NIF_C_BRUTEARMOR		0x1
#define NIF_C_BURNARMOR			0x2
#define NIF_C_PAINKILLERS		0x4
#define NIF_C_HARDCLAWS			0x8
#define NIF_C_HIDELASER			0x10

//Other
#define NIF_O_COMMLINK			0x1
#define NIF_O_APCCHARGE			0x2
#define NIF_O_PRESSURESEAL		0x4
#define NIF_O_HEATSINKS			0x8
#define NIF_O_SCMYSELF			0x10 //Soulcatcher stuff
#define NIF_O_SCOTHERS			0x20

///////////////////
// applies_to flags
#define NIF_ORGANIC		0x1
#define NIF_SYNTHETIC	0x2

/////////////
// stat flags
#define NIF_WORKING		0
#define NIF_POWFAIL		1
#define NIF_TEMPFAIL	2
#define NIF_INSTALLING	3
#define NIF_PREINSTALL	4

///////////////////
// tick_flags flags
#define NIF_NEVERTICK	0
#define NIF_ALWAYSTICK	1
#define NIF_ACTIVETICK	2
