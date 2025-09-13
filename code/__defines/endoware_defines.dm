//defines for code/modules/cybernetics
#define ENDOWARE_TYPE_ALL (ENDOWARE_TYPE_PROSTHETIC | ENDOWARE_TYPE_SYNTH | ENDOWARE_TYPE_ORGANIC)

#define ENDOWARE_TYPE_PROSTHETIC (1 << 1) //prosthetics only
#define ENDOWARE_TYPE_SYNTH 0x2      //synths only
#define ENDOWARE_TYPE_ORGANIC 0x4    //organics only
#define ENDOWARE_TYPE_NANOFORM 0x8   //proteans only, note that they can also eat anything allowed to be installed in synths

#define ENDOWARE_TYPE_ARTIFICAL (ENDOWARE_TYPE_PROSTHEITC | ENDOWARE_TYPE_SYNTH)
#define ENDOWARE_TYPE_LIVING (ENDOWARE_TYPE_PROSTHEITC | ENDOWARE_TYPE_ORGANIC)

//passive checks we can do
#define ENDOWARE_FLAG_NERVE_PATCH 			 	(1 << 0)// negates the Joe Swanson trait
#define ENDOWARE_FLAG_NEUROLOGICAL_STABILITY 	(1 << 1)//minimizes epilepsy
#define ENDOWARE_FLAG_NO_DEAF 					(1 << 2)//negates the deaf trait
#define ENDOWARE_FLAG_VISION_CORRECT 			(1 << 3)//blind ass bitch robot fixed eyes
//not just for traits or whatever either
#define ENDOWARE_FLAG_NO_WELD_EYE_DMG			(1 << 4) //safety squints, that'll do er
#define ENDOWARE_FLAG_NO_FLASH					(1 << 5) //god fears the flashbang stare contest winner
#define ENDOWARE_FLAG_UI						(1 << 6) //UI stuff

//how fucked up are we
#define ENDOWARE_STATE_NOMINAL 0			//cream gravy
#define ENDOWARE_STATE_MINOR_MALFUNCTION 1  //physically damaged, but works fine enough beyond a few software quirks
#define ENDOWARE_STATE_MAJOR_MALFUNCTION 2	//lotta software issues
#define ENDOWARE_STATE_FUCKED 3				//needs to be torn out and repaired by hand or replaced
#define ENDOWARE_STATE_FUBAR 4				//needs to be replaced

//what can damage our shit?
#define ENDOWARE_DAMAGEABLE_ALL (ENDOWARE_DAMAGEABLE_BRUTE | ENDOWARE_DAMAGEABLE_BURN | ENDOWARE_DAMAGEABLE_TOXIN | ENDOWARE_DAMAGEABLE_OXYLOSS | ENDOWARE_DAMAGEABLE_CLONE | ENDOWARE_DAMAGEABLE_HALLOSS | ENDOWARE_DAMAGEABLE_ELECTRO | ENDOWARE_DAMAGEABLE_ELECTROMAG)

#define ENDOWARE_DAMAGEABLE_BRUTE      (1 << 0)
#define ENDOWARE_DAMAGEABLE_BURN 	   (1 << 1)
#define ENDOWARE_DAMAGEABLE_TOXIN      (1 << 2)
#define ENDOWARE_DAMAGEABLE_OXYLOSS    (1 << 3)
#define ENDOWARE_DAMAGEABLE_CLONE      (1 << 4)//slimes mostly
#define ENDOWARE_DAMAGEABLE_HALLOSS	   (1 << 5)//stunbatons, lightning, doorshocks, tasers, etc.
#define ENDOWARE_DAMAGEABLE_ELECTRO    (1 << 6)//zap - handled via callback on endoware
#define ENDOWARE_DAMAGEABLE_ELECTROMAG (1 << 7)//vshshsh - handled via callback

//health pools
#define ENDOWARE_MAX_HEALTH_MINOR    20 //small sensitive things
#define ENDOWARE_MAX_HEALTH_MODERATE 30
#define ENDOWARE_MAX_HEALTH_ROBUST   45 //big boys

//species
#define ENDOWARE_SPECIES_COMPATIBLE 1    //can install any that fit in the limb

//can't install any at all because it makes no sense to. note that there's a species flag on endoware to override this
// prommies,
#define ENDOWARE_SPECIES_INCOMPATIBLE 2  //can't install any at all beyond things flagged as universal (ae, backup implants)

//CAN install it, but it's a real bad idea. anything not flagged as universal gets fucked up over time/when species gimmicks are used. Not to the point of actual damage, but it'll constantly add quirks.
// mostly meant for stuff that COULD install it, but have freaky enough biology that most software vendors deem them too much of a PITA.
// Hanners, Shadekin, Replicants
#define ENDOWARE_SPECIES_CUCKOLDED 3
