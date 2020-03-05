// Shuttle flags
#define SHUTTLE_FLAGS_NONE    0
#define SHUTTLE_FLAGS_PROCESS 1		// Should be processed by shuttle subsystem
#define SHUTTLE_FLAGS_SUPPLY  2		// This is the supply shuttle.  Why is this a tag?
#define SHUTTLE_FLAGS_ZERO_G  4		// Shuttle has no internal gravity generation
#define SHUTTLE_FLAGS_ALL (~SHUTTLE_FLAGS_NONE)

// shuttle_landmark flags
#define SLANDMARK_FLAG_AUTOSET 1    // If set, will set base area and turf type to same as where it was spawned at
#define SLANDMARK_FLAG_ZERO_G  2    // Zero-G shuttles moved here will lose gravity unless the area has ambient gravity.

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
