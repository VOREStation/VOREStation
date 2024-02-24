
/// Module is compatible with All Cyborg models, utility upgrades
#define BORG_UTILITY				(1<<0)
/// Module is compatible with All Cyborg models, basic upgrades
#define BORG_BASIC					(1<<1)
/// Module is compatible with All Cyborg models, advanced upgrades
#define BORG_ADVANCED				(1<<2)
/// Module is compatible with Security Cyborg models
#define BORG_MODULE_SECURITY 		(1<<3)
/// Module is compatible with Miner Cyborg models
#define BORG_MODULE_MINER			(1<<4)
/// Module is compatible with Janitor Cyborg models
#define BORG_MODULE_JANITOR			(1<<5)
/// Module is compatible with Medical Cyborg models
#define BORG_MODULE_MEDICAL			(1<<6)
/// Module is compatible with Engineering Cyborg models
#define BORG_MODULE_ENGINEERING		(1<<7)
/// Module is compatible with Science Cyborg models
#define BORG_MODULE_SCIENCE			(1<<8)
/// Module is compatible with Service Cyborg models
#define BORG_MODULE_SERVICE			(1<<9)
/// Module is compatible with Clerical Cyborg models
#define BORG_MODULE_CLERIC			(1<<10)
/// Module is compatible with Combat Cyborg models
#define BORG_MODULE_COMBAT			(1<<11)
/// Module is compatible with Exploration Cyborg models
#define BORG_MODULE_EXPLO			(1<<12)
/// Module is compatible with Ripley Exosuit models
#define EXOSUIT_MODULE_RIPLEY		(1<<0)
/// Module is compatible with Odyseeus Exosuit models
#define EXOSUIT_MODULE_ODYSSEUS		(1<<1)
/// Module is compatible with Gygax Exosuit models
#define EXOSUIT_MODULE_GYGAX		(1<<2)
/// Module is compatible with Durand Exosuit models
#define EXOSUIT_MODULE_DURAND		(1<<3)
/// Module is compatible with Phazon Exosuit models
#define EXOSUIT_MODULE_PHAZON		(1<<4)

/// Module is compatible with "Working" Exosuit models - Ripley
#define EXOSUIT_MODULE_WORKING		EXOSUIT_MODULE_RIPLEY
/// Module is compatible with "Combat" Exosuit models - Gygax, Durand and Phazon
#define EXOSUIT_MODULE_COMBAT		EXOSUIT_MODULE_GYGAX  | EXOSUIT_MODULE_DURAND | EXOSUIT_MODULE_PHAZON
/// Module is compatible with "Medical" Exosuit modelsm - Odysseus
#define EXOSUIT_MODULE_MEDICAL		EXOSUIT_MODULE_ODYSSEUS
