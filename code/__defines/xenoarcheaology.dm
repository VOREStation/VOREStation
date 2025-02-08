/// <summary>
/// This is how much artifacts take to activate.
/// </summary>
#define ARTIFACT_GAS_TRIGGER 200	//In MOL
#define ARTIFACT_HEAT_TRIGGER 375	//In Kelvin
#define ARTIFACT_COLD_TRIGGER 225	//In Kelvin
#define ARTIFACT_HEAT_BREAK 2500	//In Kelvin

/// <summary>
/// These are the defines for the SMALL (can hold in hand) artifacts.
/// </summary>
#define ARCHAEO_BOWL 1
#define ARCHAEO_URN 2
#define ARCHAEO_SYRINGE 3
#define ARCHAEO_STATUETTE 4
#define ARCHAEO_INSTRUMENT 5
#define ARCHAEO_KNIFE 6
#define ARCHAEO_COIN 7
#define ARCHAEO_HANDCUFFS 8
#define ARCHAEO_BEARTRAP 9
#define ARCHAEO_LIGHTER 10
#define ARCHAEO_BOX 11
#define ARCHAEO_GASTANK 12
#define ARCHAEO_TOOL 13
#define ARCHAEO_METAL 14
#define ARCHAEO_PEN 15
#define ARCHAEO_CRYSTAL 16
#define ARCHAEO_CULTBLADE 17
#define ARCHAEO_TELEBEACON 18
#define ARCHAEO_CLAYMORE 19
#define ARCHAEO_CULTROBES 20
#define ARCHAEO_SOULSTONE 21
#define ARCHAEO_CLUB 22
#define ARCHAEO_RING 23
#define ARCHAEO_STOCKPARTS 24
#define ARCHAEO_KATANA 25
#define ARCHAEO_LASER 26
#define ARCHAEO_GUN 27
#define ARCHAEO_UNKNOWN 28
#define ARCHAEO_FOSSIL 29
#define ARCHAEO_SHELL 30
#define ARCHAEO_PLANT 31
#define ARCHAEO_REMAINS_HUMANOID 32
#define ARCHAEO_REMAINS_ROBOT 33
#define ARCHAEO_REMAINS_XENO 34
#define ARCHAEO_GASMASK 35
#define ARCHAEO_ALIEN_ITEM 36
#define ARCHAEO_ALIEN_BOAT 37
#define ARCHAEO_IMPERION_CIRCUIT 38
#define ARCHAEO_TELECUBE 39
#define ARCHAEO_BATTERY 40
#define ARCHAEO_TOME 41
#define MAX_ARCHAEO 41

/// <summary>
/// These are the defines for the DIGSITES (which determine what artifacts will spawn in that cluster of artifact tiles)
/// </summary>
#define DIGSITE_GARDEN 1
#define DIGSITE_MIDDEN 2
#define DIGSITE_HOUSE 3
#define DIGSITE_TECHNICAL 4
#define DIGSITE_TEMPLE 5
#define DIGSITE_WAR 6

/// <summary>
/// These are the defines for what type of effect the artifact has.
/// </summary>
/// <example>
/// Touch requires you to touch it to have effects
/// Aura will require the artifact to be activated (on sprite) and will occasionally effect things in a short range
/// Pulse will require the artifact to be activated, will take a long while to charge, then hit things in a long range (possibly Z wide)
/// </example>
#define EFFECT_TOUCH 0
#define EFFECT_AURA 1
#define EFFECT_PULSE 2
#define MAX_EFFECT 2

/// <summary>
/// These are the defines for what is required to ACTIVATE the artifact.
/// </summary>
/// TODO: Get rid of TRIGGER_PHORON/OXY/CO2/NITRO. They're unfun and tedious.
#define TRIGGER_TOUCH 0
#define TRIGGER_WATER 1
#define TRIGGER_ACID 2
#define TRIGGER_VOLATILE 3
#define TRIGGER_TOXIN 4
#define TRIGGER_FORCE 5
#define TRIGGER_ENERGY 6
#define TRIGGER_HEAT 7
#define TRIGGER_COLD 8
#define TRIGGER_PHORON 9
#define TRIGGER_OXY 10
#define TRIGGER_CO2 11
#define TRIGGER_NITRO 12
#define MAX_TRIGGER 12

/// <summary>
/// These are defines of what TYPE of artifact it is. See code/modules/xenoarcheaology/effects for each artifact.
/// </summary>
#define EFFECT_UNKNOWN 0
#define EFFECT_ANIMATE 1
#define EFFECT_BERSERK 2
#define EFFECT_FEELINGS 3
#define EFFECT_CELL 4
#define EFFECT_ELECTIC_FIELD 5
#define EFFECT_EMP 6
#define EFFECT_FEYSIGHT 7
#define EFFECT_FORCEFIELD 8
#define EFFECT_GAIA 9
#define EFFECT_GAS 10
#define EFFECT_GRAVIATIONAL_WAVES 11
#define EFFECT_TEMPERATURE 12
#define EFFECT_POLTERGEIST 13
#define EFFECT_RADIATE 14
#define EFFECT_RESURRECT 15
#define EFFECT_ROBOT_HEALTH 16
#define EFFECT_SLEEPY 17
#define EFFECT_STUN 18
#define EFFECT_TELEPORT 19
#define EFFECT_VAMPIRE 20
#define EFFECT_HEALTH 21
#define EFFECT_GENERATOR 22
#define EFFECT_DNASWITCH 23 //Not in as of yet.
