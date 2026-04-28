// Adds a list of pre-disabled events to the available events list.
// This keeps them in the rotation, but disabled, so they can be enabled with a click if desired that round.
/datum/event_container/proc/add_disabled_events(var/list/disabled_events)
	for(var/datum/event_meta/EM in disabled_events)
		EM.enabled = 0
		available_events += EM

/datum/event_container/mundane/New()
	available_events = list(
		// Severity level, event name, even type, base weight, role weights, one shot, min weight, max weight. Last two only used if set and non-zero
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Nothing",			/datum/event/nothing,			10),
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "APC Damage",		/datum/event/apc_damage,		2,	null, FALSE, min_jobs = list(DEPARTMENT_ENGINEERING = 1)),
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Brand Intelligence",/datum/event/brand_intelligence,2,	null, TRUE),
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Camera Damage",		/datum/event/camera_damage,		2, null, FALSE, min_jobs = list(DEPARTMENT_ENGINEERING = 1)),
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Canister Leak",		/datum/event/canister_leak,		3, null, FALSE, min_jobs = list(DEPARTMENT_ENGINEERING = 1)),
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Economic News",		/datum/event/economic_event,	1),
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Money Hacker",		/datum/event/money_hacker, 		2,  null, TRUE),
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Money Lotto",		/datum/event/money_lotto, 		2,  null, TRUE),
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Shipping Error",	/datum/event/shipping_error, 	1, 	null, FALSE),
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Trivial News",		/datum/event/trivial_news, 		2),
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Lore News",			/datum/event/lore_news, 		1),
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Vermin Infestation",/datum/event/infestation, 		3,	null, FALSE),
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Wallrot",			/datum/event/wallrot, 			3,	null, FALSE)
	)
	add_disabled_events(list(
	))

/datum/event_container/moderate/New()
	available_events = list(
		new /datum/event_meta(EVENT_LEVEL_MODERATE, "Nothing",					/datum/event/nothing,					12),
		new /datum/event_meta(EVENT_LEVEL_MODERATE, "Atmos Leak",				/datum/event/atmos_leak, 				2,		null, FALSE),
		new /datum/event_meta(EVENT_LEVEL_MODERATE, "Communication Blackout",	/datum/event/communications_blackout,	1,		null, FALSE),
		new /datum/event_meta(EVENT_LEVEL_MODERATE, "Electrical Storm",			/datum/event/electrical_storm, 			5,		null, FALSE),
		new /datum/event_meta(EVENT_LEVEL_MODERATE, "Gravity Failure",			/datum/event/gravity,	 				1,		null, FALSE),
		new /datum/event_meta(EVENT_LEVEL_MODERATE, "Grid Check",				/datum/event/grid_check, 				3,		null, FALSE),
		new /datum/event_meta(EVENT_LEVEL_MODERATE, "Ion Storm",				/datum/event/ionstorm, 					3,		null, FALSE),
		new /datum/event_meta(EVENT_LEVEL_MODERATE, "Rogue Drones",				/datum/event/rogue_drone, 				4,		null, TRUE),
		new /datum/event_meta(EVENT_LEVEL_MODERATE, "Solar Storm",				/datum/event/solar_storm, 				4,		null, TRUE),
		new /datum/event_meta(EVENT_LEVEL_MODERATE, "Spider Infestation",		/datum/event/spider_infestation, 		3,		null, TRUE),
		new /datum/event_meta(EVENT_LEVEL_MODERATE, "Grub Infestation",			/datum/event/grub_infestation,			4,		null, FALSE),
		new /datum/event_meta(EVENT_LEVEL_MODERATE, "Drone Pod Drop",			/datum/event/drone_pod_drop,			4,		null, FALSE),
		new /datum/event_meta(EVENT_LEVEL_MODERATE, "Appendicitis", 			/datum/event/spontaneous_appendicitis, 	4,		null, FALSE),
		new /datum/event_meta(EVENT_LEVEL_MODERATE, "Jellyfish School",			/datum/event/jellyfish_migration,		2,		null, TRUE),
		new /datum/event_meta(EVENT_LEVEL_MODERATE, "Space Vines",				/datum/event/spacevine, 				3,		null, FALSE),
		new /datum/event_meta(EVENT_LEVEL_MODERATE, "Atmos Leak",				/datum/event/atmos_leak, 				5,		null, FALSE),
		new /datum/event_meta(EVENT_LEVEL_MODERATE, "Hostile Runtime", 			/datum/event/hostile_runtime, 			2, 		null, min_jobs = list(DEPARTMENT_ENGINEERING = 1)),
		new /datum/event_meta(EVENT_LEVEL_MODERATE, "Bluespace Lockers", 		/datum/event/bluespace_locker, 			3, 		null, TRUE),
		new /datum/event_meta(EVENT_LEVEL_MODERATE, "Bluespace Anomaly",		/datum/event/anomaly/bluespace,			1,		null, TRUE),
		new /datum/event_meta(EVENT_LEVEL_MODERATE, "Bioscrambler Anomaly",		/datum/event/anomaly/bioscrambler,		1,		null, TRUE, min_jobs = list(DEPARTMENT_MEDICAL = 1)),
		new /datum/event_meta(EVENT_LEVEL_MODERATE, "Dimensional Anomaly",		/datum/event/anomaly/dimensional,		1,		null, TRUE),
		new /datum/event_meta(EVENT_LEVEL_MODERATE, "Gravity Anomaly", 			/datum/event/anomaly/grav, 				1,		null, TRUE),
		new /datum/event_meta(EVENT_LEVEL_MODERATE, "Pyroclastic Anomaly", 		/datum/event/anomaly/pyro,				1,		null, TRUE, min_jobs = list(DEPARTMENT_ENGINEERING = 1)),
		new /datum/event_meta(EVENT_LEVEL_MODERATE, "Hallucination Anomaly",	/datum/event/anomaly/hallucination,		1,		null, TRUE),
		new /datum/event_meta(EVENT_LEVEL_MODERATE, "Flux Anomaly",				/datum/event/anomaly/flux,				1,		null, TRUE),
		new /datum/event_meta(EVENT_LEVEL_MODERATE, "Weather Anomaly",			/datum/event/anomaly/weather,			1,		null, TRUE),
	)
	add_disabled_events(list(
	))

/datum/event_container/major/New()
	available_events = list(
		new /datum/event_meta(EVENT_LEVEL_MAJOR, "Nothing",				/datum/event/nothing						,5),
		new /datum/event_meta(EVENT_LEVEL_MAJOR, "Meteor Wave",			/datum/event/meteor_wave					,2	, null, TRUE),
		new /datum/event_meta(EVENT_LEVEL_MAJOR, "Carp Migration",		/datum/event/carp_migration					,2	, null, TRUE, min_jobs = list(DEPARTMENT_SECURITY = 3)),
		new /datum/event_meta(EVENT_LEVEL_MAJOR, "Jellyfish Migration",	/datum/event/jellyfish_migration			,3	, null, TRUE),
		new /datum/event_meta(EVENT_LEVEL_MAJOR, "Disease Outbreak",	/datum/event/disease_outbreak				,3	, null, TRUE, min_jobs = list(DEPARTMENT_MEDICAL = 2)),
		new /datum/event_meta(EVENT_LEVEL_MAJOR, "Clang",				/datum/event/clang							,2	, null, TRUE, min_jobs = list(DEPARTMENT_ENGINEERING = 2)),
		new /datum/event_meta(EVENT_LEVEL_MAJOR, "Electrical Storm",	/datum/event/electrical_storm				,2	, null, FALSE),
		new /datum/event_meta(EVENT_LEVEL_MAJOR, "Hostile Runtime", 	/datum/event/hostile_runtime				,2  , null, FALSE, min_jobs = list(DEPARTMENT_ENGINEERING = 1)),
	)
	add_disabled_events(list(
	))
