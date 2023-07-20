#define ASSIGNMENT_ANY "Any"
#define ASSIGNMENT_AI "AI"
#define ASSIGNMENT_CYBORG "Cyborg"
#define ASSIGNMENT_ENGINEER "Engineer"
#define ASSIGNMENT_GARDENER "Botanist"
#define ASSIGNMENT_JANITOR "Janitor"
#define ASSIGNMENT_MEDICAL "Medical"
#define ASSIGNMENT_SCIENTIST "Scientist"
#define ASSIGNMENT_SECURITY "Security"

//
// VOREStation overrides to the default event manager configuration.
//
// This file lets us configure which events we want in the rotation without conflicts with upstream.
// It works because the actual event containers don't define New(), allowing us to use New() to replace
// the lists of available events.  If they ever do define New() this will need to be changed.
//
// Specifically the change is to move events we don't want down into the disabled_events list
//

// Adds a list of pre-disabled events to the available events list.
// This keeps them in the rotation, but disabled, so they can be enabled with a click if desired that round.
/datum/event_container/proc/add_disabled_events(var/list/disabled_events)
	for(var/datum/event_meta/EM in disabled_events)
		EM.enabled = 0
		available_events += EM

/datum/event_container/mundane/New()
	available_events = list(
		// Severity level, event name, even type, base weight, role weights, one shot, min weight, max weight. Last two only used if set and non-zero
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Nothing",			/datum/event/nothing,			400),
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "APC Damage",		/datum/event/apc_damage,		20, 	list(ASSIGNMENT_ENGINEER = 20), min_jobs = list(ASSIGNMENT_ENGINEER = 1)),
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Brand Intelligence",/datum/event/brand_intelligence, 0, 	list(ASSIGNMENT_ENGINEER = 10),	1, min_jobs = list(ASSIGNMENT_ENGINEER = 1)),
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Camera Damage",		/datum/event/camera_damage,		20, 	list(ASSIGNMENT_ENGINEER = 20, ASSIGNMENT_SECURITY = 5), min_jobs = list(ASSIGNMENT_ENGINEER = 1)),
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Canister Leak",		/datum/event/canister_leak,		10, 	list(ASSIGNMENT_ENGINEER = 20), min_jobs = list(ASSIGNMENT_ENGINEER = 1)),
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Economic News",		/datum/event/economic_event,	300),
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Money Hacker",		/datum/event/money_hacker, 		0, 		list(ASSIGNMENT_ANY = 4), 1, 10, 25),
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Money Lotto",		/datum/event/money_lotto, 		0, 		list(ASSIGNMENT_ANY = 1), 1, 5, 15),
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Shipping Error",	/datum/event/shipping_error	, 	30, 	list(ASSIGNMENT_ANY = 2), 0),
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Trivial News",		/datum/event/trivial_news, 		400),
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Lore News",			/datum/event/lore_news, 		400),
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Vermin Infestation",/datum/event/infestation, 		50,		list(ASSIGNMENT_JANITOR = 25), 1),
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Wallrot",			/datum/event/wallrot, 			0,		list(ASSIGNMENT_ENGINEER = 30), 1, min_jobs = list(ASSIGNMENT_ENGINEER = 1)),
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Passing Wildlife",  /datum/event/roaming_wildlife,  40,		list(ASSIGNMENT_SECURITY = 20), min_jobs = list(ASSIGNMENT_SECURITY = 1)),
	)
	add_disabled_events(list(
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Ian Storm",			/datum/event/ianstorm,	 		1,		list(), 1),
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Supply Demand",		/datum/event/supply_demand,		0,		list(ASSIGNMENT_ANY = 5, ASSIGNMENT_SCIENCE = 15, ASSIGNMENT_GARDENER = 10, ASSIGNMENT_ENGINEER = 10, ASSIGNMENT_MEDICAL = 15), 1),
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Aurora Caelus",		/datum/event/aurora_caelus,		2,		list(), 1),
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Space Dust",		/datum/event/dust,	 			0, 		list(ASSIGNMENT_ENGINEER = 20), 0, 0, 50, min_jobs = list(ASSIGNMENT_ENGINEER = 2)),
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Lone Spacefish",	/datum/event/spacefish_migration, 	0,	list(ASSIGNMENT_SECURITY = 15), 1, min_jobs = list(ASSIGNMENT_SECURITY = 3)),
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Lost Carp",			/datum/event/carp_migration, 	0, 		list(ASSIGNMENT_SECURITY = 10), 1, min_jobs = list(ASSIGNMENT_SECURITY = 3)),
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Stray Ray",			/datum/event/ray_migration, 	0, 		list(ASSIGNMENT_SECURITY = 10), 1, min_jobs = list(ASSIGNMENT_SECURITY = 3)),
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Gnat Cloud",		/datum/event/gnat_migration, 	0, 		list(ASSIGNMENT_SECURITY = 10), 1, min_jobs = list(ASSIGNMENT_SECURITY = 3)),
	))

/datum/event_container/moderate/New()
	available_events = list(
		new /datum/event_meta(EVENT_LEVEL_MODERATE, "Nothing",					/datum/event/nothing,					1600),
		new /datum/event_meta(EVENT_LEVEL_MODERATE, "Atmos Leak",				/datum/event/atmos_leak, 				30,		list(ASSIGNMENT_ENGINEER = 25), 1, min_jobs = list(ASSIGNMENT_ENGINEER = 1)),
		new /datum/event_meta(EVENT_LEVEL_MODERATE, "Communication Blackout",	/datum/event/communications_blackout,	500,	list(), 1),
		new /datum/event_meta(EVENT_LEVEL_MODERATE, "Electrical Storm",			/datum/event/electrical_storm, 			70,		list(ASSIGNMENT_ENGINEER = 25, ASSIGNMENT_JANITOR = 100), 1),
		new /datum/event_meta(EVENT_LEVEL_MODERATE, "Grid Check",				/datum/event/grid_check, 				0,		list(ASSIGNMENT_ENGINEER = 25), 1, min_jobs = list(ASSIGNMENT_ENGINEER = 1)),
		new /datum/event_meta(EVENT_LEVEL_MODERATE, "Ion Storm",				/datum/event/ionstorm, 					0,		list(ASSIGNMENT_AI = 80, ASSIGNMENT_CYBORG = 50, ASSIGNMENT_SCIENTIST = 20), min_jobs = list(ASSIGNMENT_AI = 1)),
		new /datum/event_meta(EVENT_LEVEL_MODERATE, "Prison Break",				/datum/event/prison_break,				10,		list(ASSIGNMENT_SECURITY = 15, ASSIGNMENT_ENGINEER = 15), 1),
		new /datum/event_meta(EVENT_LEVEL_MODERATE, "Virology Breach",			/datum/event/prison_break/virology,		0,		list(ASSIGNMENT_MEDICAL = 15, ASSIGNMENT_ENGINEER = 15), 1),
		new /datum/event_meta(EVENT_LEVEL_MODERATE, "Xenobiology Breach",		/datum/event/prison_break/xenobiology,	0,		list(ASSIGNMENT_SCIENTIST = 15, ASSIGNMENT_ENGINEER = 15), 1),
		new /datum/event_meta(EVENT_LEVEL_MODERATE, "Spider Infestation",		/datum/event/spider_infestation, 		0,		list(ASSIGNMENT_SECURITY = 30), 1, min_jobs = list(ASSIGNMENT_SECURITY = 2)),
		new /datum/event_meta(EVENT_LEVEL_MODERATE, "Grub Infestation",			/datum/event/grub_infestation,			0,		list(ASSIGNMENT_SECURITY = 15, ASSIGNMENT_ENGINEER = 30), 1, min_jobs = list(ASSIGNMENT_SECURITY = 1, ASSIGNMENT_ENGINEER = 1)),
		new /datum/event_meta(EVENT_LEVEL_MODERATE, "Drone Pod Drop",			/datum/event/drone_pod_drop,			40,		list(ASSIGNMENT_SCIENTIST = 40), 1),
		new /datum/event_meta(EVENT_LEVEL_MODERATE, "Morph Spawn",				/datum/event/morph_spawn,				75,		list(ASSIGNMENT_ANY = 5), 0),
		new /datum/event_meta(EVENT_LEVEL_MODERATE, "Maintenance Predator",		/datum/event/maintenance_predator,		100,	list(ASSIGNMENT_ANY = 5), 0),
		new /datum/event_meta(EVENT_LEVEL_MODERATE, "Roaming Wildlife",			/datum/event/roaming_wildlife,  		20,		list(ASSIGNMENT_SECURITY = 20, ASSIGNMENT_MEDICAL = 5), min_jobs = list(ASSIGNMENT_SECURITY = 2)),
	)
	add_disabled_events(list(
		new /datum/event_meta(EVENT_LEVEL_MODERATE, "Appendicitis", 			/datum/event/spontaneous_appendicitis, 	0,		list(ASSIGNMENT_MEDICAL = 30), 1),
		new /datum/event_meta(EVENT_LEVEL_MODERATE, "Meteor Shower",			/datum/event/meteor_wave,				30,		list(ASSIGNMENT_ENGINEER = 20)),
		new /datum/event_meta(EVENT_LEVEL_MODERATE, "Radiation Storm",			/datum/event/radiation_storm, 			50,		list(ASSIGNMENT_MEDICAL = 50), 1),
		new /datum/event_meta(EVENT_LEVEL_MODERATE, "Random Antagonist",		/datum/event/random_antag,		 		0,		list(ASSIGNMENT_SECURITY = 1), 1, 0, 5),
		new /datum/event_meta(EVENT_LEVEL_MODERATE, "Supply Demand",			/datum/event/supply_demand,				0,		list(ASSIGNMENT_ANY = 5, ASSIGNMENT_SCIENCE = 15, ASSIGNMENT_GARDENER = 10, ASSIGNMENT_ENGINEER = 10, ASSIGNMENT_MEDICAL = 15), 1),
		new /datum/event_meta(EVENT_LEVEL_MODERATE, "Solar Storm",				/datum/event/solar_storm, 				30,		list(ASSIGNMENT_ENGINEER = 40, ASSIGNMENT_SECURITY = 30), 1),
		new /datum/event_meta(EVENT_LEVEL_MODERATE, "Gravity Failure",			/datum/event/gravity,	 				75,		list(ASSIGNMENT_ENGINEER = 60), 1),
		new /datum/event_meta(EVENT_LEVEL_MODERATE, "Space Dust",				/datum/event/dust,	 					0,		list(ASSIGNMENT_ENGINEER = 20), 1, 0, 50, min_jobs = list(ASSIGNMENT_ENGINEER = 3)),
		new /datum/event_meta(EVENT_LEVEL_MODERATE, "Rogue Drones",				/datum/event/rogue_drone, 				0,		list(ASSIGNMENT_SECURITY = 20), 1, min_jobs = list(ASSIGNMENT_SECURITY = 3)),
		new /datum/event_meta(EVENT_LEVEL_MODERATE, "Spacefish Migration",		/datum/event/spacefish_migration,		0, 		list(ASSIGNMENT_SECURITY = 40, ASSIGNMENT_MEDICAL = 5), 1, min_jobs = list(ASSIGNMENT_SECURITY = 3)),
		new /datum/event_meta(EVENT_LEVEL_MODERATE, "Carp School",				/datum/event/carp_migration,			0, 		list(ASSIGNMENT_SECURITY = 25, ASSIGNMENT_MEDICAL = 5), 1, min_jobs = list(ASSIGNMENT_SECURITY = 3)),
		new /datum/event_meta(EVENT_LEVEL_MODERATE, "Jellyfish School",			/datum/event/jellyfish_migration,		0,		list(ASSIGNMENT_SECURITY = 15, ASSIGNMENT_MEDICAL = 5), 1, min_jobs = list(ASSIGNMENT_SECURITY = 2)),
		new /datum/event_meta(EVENT_LEVEL_MODERATE, "Gliding Rays",			/datum/event/ray_migration,					0,		list(ASSIGNMENT_SECURITY = 15, ASSIGNMENT_MEDICAL = 5), 1, min_jobs = list(ASSIGNMENT_SECURITY = 3)),
		new /datum/event_meta(EVENT_LEVEL_MODERATE, "Shark Pack",			/datum/event/shark_migration,				0,		list(ASSIGNMENT_SECURITY = 15, ASSIGNMENT_MEDICAL = 3), 1, min_jobs = list(ASSIGNMENT_SECURITY = 3)),
		new /datum/event_meta(EVENT_LEVEL_MODERATE, "Gnat Swarm",			/datum/event/gnat_migration,				0,		list(ASSIGNMENT_SECURITY = 15, ASSIGNMENT_MEDICAL = 3), 1, min_jobs = list(ASSIGNMENT_SECURITY = 3)),
	))

/datum/event_container/major/New()
	available_events = list(
		new /datum/event_meta(EVENT_LEVEL_MAJOR, "Nothing",				/datum/event/nothing,				3600),
		new /datum/event_meta(EVENT_LEVEL_MAJOR, "Atmos Leak",			/datum/event/atmos_leak, 			20,		list(ASSIGNMENT_ENGINEER = 25), 1, min_jobs = list(ASSIGNMENT_ENGINEER = 1)),
		new /datum/event_meta(EVENT_LEVEL_MAJOR, "Space Vines",			/datum/event/spacevine, 			10,		list(ASSIGNMENT_ENGINEER = 3, ASSIGNMENT_GARDENER = 3, ASSIGNMENT_SCIENTIST = 3), 1),
		new /datum/event_meta(EVENT_LEVEL_MAJOR, "Containment Breach",	/datum/event/prison_break/station,	0,		list(ASSIGNMENT_ENGINEER = 5, ASSIGNMENT_MEDICAL = 5, ASSIGNMENT_SECURITY = 5, ASSIGNMENT_SCIENTIST = 5), 1),
		new /datum/event_meta(EVENT_LEVEL_MAJOR, "Amassing Wildlife",	/datum/event/roaming_wildlife,  	0,		list(ASSIGNMENT_SECURITY = 10, ASSIGNMENT_MEDICAL = 3), 1, min_jobs = list(ASSIGNMENT_SECURITY = 3)),
	)
	add_disabled_events(list(
		new /datum/event_meta(EVENT_LEVEL_MAJOR, "Meteor Strike",		/datum/event/meteor_strike,			10,		list(ASSIGNMENT_ENGINEER = 15), 1),
		new /datum/event_meta(EVENT_LEVEL_MAJOR, "Blob",				/datum/event/blob, 					10,		list(ASSIGNMENT_ENGINEER = 60), 1),
		new /datum/event_meta(EVENT_LEVEL_MAJOR, "Meteor Wave",			/datum/event/meteor_wave,			30,		list(ASSIGNMENT_ENGINEER = 15),	1),
		new /datum/event_meta(EVENT_LEVEL_MAJOR, "Supply Demand",		/datum/event/supply_demand,			0,		list(ASSIGNMENT_ANY = 5, ASSIGNMENT_SCIENCE = 15, ASSIGNMENT_GARDENER = 10, ASSIGNMENT_ENGINEER = 10, ASSIGNMENT_MEDICAL = 15), 1),
		new /datum/event_meta(EVENT_LEVEL_MAJOR, "Spacefish Swarm",		/datum/event/spacefish_migration,	10,		list(ASSIGNMENT_SECURITY = 5, ASSIGNMENT_MEDICAL = 3), 1, min_jobs = list(ASSIGNMENT_SECURITY = 3)),
		new /datum/event_meta(EVENT_LEVEL_MAJOR, "Carp Migration",		/datum/event/carp_migration,		10,		list(ASSIGNMENT_SECURITY = 5), 1, min_jobs = list(ASSIGNMENT_SECURITY = 3)),
		new /datum/event_meta(EVENT_LEVEL_MAJOR, "Jellyfish Migration",	/datum/event/jellyfish_migration,	5,		list(ASSIGNMENT_SECURITY = 5, ASSIGNMENT_MEDICAL = 3), 1, min_jobs = list(ASSIGNMENT_SECURITY = 2)),
		new /datum/event_meta(EVENT_LEVEL_MAJOR, "Gliding Rays",		/datum/event/ray_migration,			0,		list(ASSIGNMENT_SECURITY = 15, ASSIGNMENT_MEDICAL = 5), 1, min_jobs = list(ASSIGNMENT_SECURITY = 3)),
		new /datum/event_meta(EVENT_LEVEL_MAJOR, "Shark Pack",			/datum/event/shark_migration,		5,		list(ASSIGNMENT_SECURITY = 5, ASSIGNMENT_MEDICAL = 3), 1, min_jobs = list(ASSIGNMENT_SECURITY = 3)),
		new /datum/event_meta(EVENT_LEVEL_MAJOR, "Gnat Swarm",			/datum/event/gnat_migration,		5,		list(ASSIGNMENT_SECURITY = 5, ASSIGNMENT_MEDICAL = 3), 1, min_jobs = list(ASSIGNMENT_SECURITY = 3)),
	))

#undef ASSIGNMENT_ANY
#undef ASSIGNMENT_AI
#undef ASSIGNMENT_CYBORG
#undef ASSIGNMENT_ENGINEER
#undef ASSIGNMENT_GARDENER
#undef ASSIGNMENT_JANITOR
#undef ASSIGNMENT_MEDICAL
#undef ASSIGNMENT_SCIENTIST
#undef ASSIGNMENT_SECURITY
