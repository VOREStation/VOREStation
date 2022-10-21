// Shuttle flags
#define SHUTTLE_FLAGS_NONE    0
#define SHUTTLE_FLAGS_PROCESS 1		// Should be processed by shuttle subsystem
#define SHUTTLE_FLAGS_SUPPLY  2		// This is the supply shuttle.  Why is this a tag?
#define SHUTTLE_FLAGS_ZERO_G  4		// Shuttle has no internal gravity generation
#define SHUTTLE_FLAGS_ALL (~SHUTTLE_FLAGS_NONE)

// Overmap landable shuttles (/obj/effect/overmap/visitable/ship/landable on a /datum/shuttle/autodock/overmap)
#define SHIP_STATUS_LANDED   1		// Ship is at any other shuttle landmark.
#define SHIP_STATUS_TRANSIT  2		// Ship is at it's shuttle datum's transition shuttle landmark.
#define SHIP_STATUS_OVERMAP  3		// Ship is at its "overmap" shuttle landmark (allowed to move on overmap now)

// Ferry shuttle location constants
#define FERRY_LOCATION_STATION	0
#define FERRY_LOCATION_OFFSITE	1
#define FERRY_GOING_TO_STATION	0
#define FERRY_GOING_TO_OFFSITE	1

#ifndef DEBUG_SHUTTLES
	#define log_shuttle(M)
#else
	#define log_shuttle(M) log_debug("[M]")
#endif
