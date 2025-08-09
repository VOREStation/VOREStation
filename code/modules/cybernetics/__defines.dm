//where it's allowed to be installed
#define ENDOWARE_TYPE_ALL (ENDOWARE_TYPE_PROSTHETIC | ENDOWARE_TYPE_SYNTH | ENDOWARE_TYPE_ORGANIC)

#define ENDOWARE_TYPE_PROSTHETIC 0x1 //prosthetics only
#define ENDOWARE_TYPE_SYNTH 0x2      //synths only
#define ENDOWARE_TYPE_ORGANIC 0x4    //organics only
#define ENDOWARE_TYPE_NANOFORM 0x8   //proteans only, note that they can also eat anything allowed to be installed in synths

#define ENDOWARE_TYPE_ARTIFICAL (ENDOWARE_TYPE_PROSTHEITC | ENDOWARE_TYPE_SYNTH)
#define ENDOWARE_TYPE_LIVING (ENDOWARE_TYPE_PROSTHEITC | ENDOWARE_TYPE_ORGANIC)

#define ENDOWARE_STATE_NOMINAL 0			//cream gravy
#define ENDOWARE_STATE_MINOR_MALFUNCTION 1  //physically damaged, but works fine enough beyond a few software quirks
#define ENDOWARE_STATE_FUCKED 2				//needs to be torn out and repaired by hand or replaced
#define ENDOWARE_STATE_FUBAR 3 				//needs to be replaced
//what can damage our shit?
#define ENDOWARE_DAMAGEABLE_ALL (ENDOWARE_DAMAGEABLE_BRUTE | ENDOWARE_DAMAGEABLE_BURN | ENDOWARE_DAMAGEABLE_TOXIN | ENDOWARE_DAMAGEABLE_OXYLOSS | ENDOWARE_DAMAGEABLE_CLONE | ENDOWARE_DAMAGEABLE_HALLOSS | ENDOWARE_DAMAGEABLE_ELECTRO | ENDOWARE_DAMAGEABLE_ELECTROMAG)

#define ENDOWARE_DAMAGEABLE_BRUTE      0x1
#define ENDOWARE_DAMAGEABLE_BURN 	   0x2
#define ENDOWARE_DAMAGEABLE_TOXIN      0x8
#define ENDOWARE_DAMAGEABLE_OXYLOSS    0x10
#define ENDOWARE_DAMAGEABLE_CLONE      0x20
#define ENDOWARE_DAMAGEABLE_HALLOSS	   0x40 //stunbatons, lightning, doorshocks, tasers, etc.
#define ENDOWARE_DAMAGEABLE_ELECTRO    0x80
#define ENDOWARE_DAMAGEABLE_ELECTROMAG 0x100
//health pools
#define ENDOWARE_MAX_HEALTH_MINOR    20 //small sensitive things
#define ENDOWARE_MAX_HEALTH_MODERATE 30
#define ENDOWARE_MAX_HEALTH_ROBUST   45 //big boys

#define DMG_2_ENDOWARE_DMG(comparing)
