// This file should contain every single global trait in the game in a type-based list, as well as any additional trait-related information that's useful to have on a global basis.
// This file is used in linting, so make sure to add everything alphabetically and what-not.
// Do consider adding your trait entry to the similar list in `admin_tooling.dm` if you want it to be accessible to admins (which is probably the case for 75% of traits).

// Please do note that there is absolutely no bearing on what traits are added to what subtype of `/datum`, this is just an easily referenceable list sorted by type.
// The only thing that truly matters about traits is the code that is built to handle the traits, and where that code is located. Nothing else.
#define WEAKENED_RADIATION_RESISTANCE "Weakened"
#define NORMAL_RADIATION_RESISTANCE "Normal"
#define RESISTANT_RADIATION_RESISTANCE "Resistant"
#define MAJOR_RESISTANT_RADIATION_RESISTANCE "Major Resistance"
#define IMMUNITY_RADIATION_RESISTANCE "Immunity"
GLOBAL_LIST_INIT(radiation_levels, list(
	WEAKENED_RADIATION_RESISTANCE  = list("safe" = 15, "danger_1" = 50, "danger_2" = 150, "danger_3" = 200, "danger_4" = 750),
	NORMAL_RADIATION_RESISTANCE  = list("safe" = 50, "danger_1" = 100, "danger_2" = 300, "danger_3" = 400, "danger_4" = 1500),
	RESISTANT_RADIATION_RESISTANCE  = list("safe" = 70, "danger_1" = 150, "danger_2" = 450, "danger_3" = 600, "danger_4" = 2250),
	MAJOR_RESISTANT_RADIATION_RESISTANCE  = list("safe" = 150, "danger_1" = 300, "danger_2" = 600, "danger_3" = 1000, "danger_4" = 3000),
	IMMUNITY_RADIATION_RESISTANCE  = list("safe" = 10000, "danger_1" = 10001, "danger_2" = 10002, "danger_3" = 10003, "danger_4" = 10004),
))

GLOBAL_LIST_INIT(traits_by_type, list(
	/atom = list(
		"TRAIT_ALT_CLICK_BLOCKER" = TRAIT_ALT_CLICK_BLOCKER,
	),
	/mob = list(
		"TRAIT_THINKING_IN_CHARACTER" = TRAIT_THINKING_IN_CHARACTER,
		"TRAIT_NOFIRE" = TRAIT_NOFIRE,
		"TRAIT_NOFIRE_SPREAD" = TRAIT_NOFIRE_SPREAD,
		"TRAIT_NO_EXTINGUISH" = TRAIT_NO_EXTINGUISH,
		"TRAIT_TESLA_SHOCKIMMUNE" = TRAIT_TESLA_SHOCKIMMUNE,
		"TRAIT_MADNESS_IMMUNE" = TRAIT_MADNESS_IMMUNE,
	),
	/obj = list(
		"TRAIT_CLIMBABLE" = TRAIT_CLIMBABLE,
	)
))
