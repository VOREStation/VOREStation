#define ECO_MODIFIER 10

// Because of omnihud having overlapping issues, we have extra ones.
#define     BACKUP_HUD 11 // HUD for showing whether or not they have a backup implant.
#define   STATUS_R_HUD 12 // HUD for showing the same STATUS_HUD info on the right side, but not for 'boring' statuses (transparent icons)
#define  HEALTH_VR_HUD 13 // HUD with blank 100% bar so it's hidden most of the time.
#define     VANTAG_HUD 14 // HUD for showing being-an-antag-target prefs

#undef TOTAL_HUDS //Undo theirs.
#define     TOTAL_HUDS 14 // Total number of HUDs.

#define VANTAG_NONE    "hudblank"
#define VANTAG_VORE    "vantag_vore"
#define VANTAG_KIDNAP  "vantag_kidnap"
#define VANTAG_KILL    "vantag_kill"

#define DEPARTMENT_OFFDUTY			"Off-Duty"

#define ANNOUNCER_NAME "Facility PA"

//For custom species
#define STARTING_SPECIES_POINTS 2
#define MAX_SPECIES_TRAITS 5

// Xenochimera thing mostly
#define REVIVING_NOW		-1
#define REVIVING_DONE		0
#define REVIVING_READY		1

// Resleeving Mind Record Status
#define MR_NORMAL 0
#define MR_UNSURE 1
#define MR_DEAD 2

//Shuttle madness!
#define SHUTTLE_CRASHED 3 // Yup that can happen now

#define BLUE_SHIELDED 2 // Shield from bluespace teleportation (telescience)

//Assistant/Visitor/Whatever
#define USELESS_JOB "Visitor"

//Herm Gender
#define HERM "herm"

// Bluespace shelter deploy checks
#define SHELTER_DEPLOY_ALLOWED "allowed"
#define SHELTER_DEPLOY_BAD_TURFS "bad turfs"
#define SHELTER_DEPLOY_BAD_AREA "bad area"
#define SHELTER_DEPLOY_ANCHORED_OBJECTS "anchored objects"
#define SHELTER_DEPLOY_SHIP_SPACE "ship not in space"

#define PTO_SECURITY		"Security"
#define PTO_MEDICAL			"Medical"
#define PTO_ENGINEERING 	"Engineering"
#define PTO_SCIENCE			"Science"
#define PTO_EXPLORATION 	"Exploration"
#define PTO_CARGO			"Cargo"
#define PTO_CIVILIAN		"Civilian"
#define PTO_CYBORG			"Cyborg"

#define DEPARTMENT_TALON	"ITV Talon"

#define MAT_TITANIUMGLASS		"ti-glass"
#define MAT_PLASTITANIUM		"plastitanium"
#define MAT_PLASTITANIUMHULL		"plastitanium hull"
#define MAT_PLASTITANIUMGLASS	"plastitanium glass"
#define MAT_GOLDHULL	"gold hull"

#define RESIZE_MINIMUM 0.25
#define RESIZE_MAXIMUM 2
#define RESIZE_MINIMUM_DORMS 0.01
#define RESIZE_MAXIMUM_DORMS 6

#define RESIZE_HUGE 2
#define RESIZE_BIG 1.5
#define RESIZE_NORMAL 1
#define RESIZE_SMALL 0.5
#define RESIZE_TINY 0.25
#define RESIZE_A_HUGEBIG (RESIZE_HUGE + RESIZE_BIG) / 2
#define RESIZE_A_BIGNORMAL (RESIZE_BIG + RESIZE_NORMAL) / 2
#define RESIZE_A_NORMALSMALL (RESIZE_NORMAL + RESIZE_SMALL) / 2
#define RESIZE_A_SMALLTINY (RESIZE_SMALL + RESIZE_TINY) / 2