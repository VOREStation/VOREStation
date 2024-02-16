// Bitflag values for c_airblock()
#define AIR_BLOCKED 1	// Blocked
#define ZONE_BLOCKED 2	// Not blocked, but zone boundaries will not cross.
#define BLOCKED 3		// Blocked, zone boundaries will not cross even if opened.

#define ZONE_MIN_SIZE 14 // Zones with less than this many turfs will always merge, even if the connection is not direct

// Used for quickly making certain things allow airflow or not.
// More complicated, conditional airflow should override CanZASPass().
#define ATMOS_PASS_YES			1	// Always blocks air and zones.
#define ATMOS_PASS_NO			2	// Never blocks air or zones.
#define ATMOS_PASS_DENSITY		3	// Blocks air and zones if density = TRUE, allows both if density = FALSE
#define ATMOS_PASS_PROC			4	// Call CanZASPass() using c_airblock

#define NORTHUP (NORTH|UP)
#define EASTUP (EAST|UP)
#define SOUTHUP (SOUTH|UP)
#define WESTUP (WEST|UP)
#define NORTHDOWN (NORTH|DOWN)
#define EASTDOWN (EAST|DOWN)
#define SOUTHDOWN (SOUTH|DOWN)
#define WESTDOWN (WEST|DOWN)

#ifdef MULTIZAS

GLOBAL_LIST_INIT(gzn_check, list(
	NORTH,
	SOUTH,
	EAST,
	WEST,
	UP,
	DOWN
))

GLOBAL_LIST_INIT(csrfz_check, list(
	NORTHEAST,
	NORTHWEST,
	SOUTHEAST,
	SOUTHWEST,
	NORTHUP,
	EASTUP,
	WESTUP,
	SOUTHUP,
	NORTHDOWN,
	EASTDOWN,
	WESTDOWN,
	SOUTHDOWN
))

#define ATMOS_CANPASS_TURF(ret,A,B) \
	if (A.blocks_air & AIR_BLOCKED || B.blocks_air & AIR_BLOCKED) { \
		ret = BLOCKED; \
	} \
	else if (B.z != A.z) { \
		if (B.z < A.z) { \
			ret = istype(A, /turf/simulated/open) ? ZONE_BLOCKED : BLOCKED; \
		} \
		else { \
			ret = istype(B, /turf/simulated/open) ? ZONE_BLOCKED : BLOCKED; \
		} \
	} \
	else if (A.blocks_air & ZONE_BLOCKED || B.blocks_air & ZONE_BLOCKED) { \
		ret = (A.z == B.z) ? ZONE_BLOCKED : AIR_BLOCKED; \
	} \
	else if (A.contents.len) { \
		ret = 0;\
		for (var/thing in A) { \
			var/atom/movable/AM = thing; \
			switch (AM.can_atmos_pass) { \
				if (ATMOS_PASS_YES) { \
					continue; \
				} \
				if (ATMOS_PASS_DENSITY) { \
					if (AM.density) { \
						ret |= AIR_BLOCKED; \
					} \
				} \
				if (ATMOS_PASS_PROC) { \
					ret |= AM.c_airblock(B); \
				} \
				if (ATMOS_PASS_NO) { \
					ret = BLOCKED; \
				} \
			} \
			if (ret == BLOCKED) { \
				break;\
			}\
		}\
	}
#else

GLOBAL_LIST_INIT(csrfz_check, list(
	NORTHEAST,
	NORTHWEST,
	SOUTHEAST,
	SOUTHWEST
))

GLOBAL_LIST_INIT(gzn_check, list(
	NORTH,
	SOUTH,
	EAST,
	WEST
))

#define ATMOS_CANPASS_TURF(ret,A,B) \
	if (A.blocks_air & AIR_BLOCKED || B.blocks_air & AIR_BLOCKED) { \
		ret = BLOCKED; \
	} \
	else if (A.blocks_air & ZONE_BLOCKED || B.blocks_air & ZONE_BLOCKED) { \
		ret = ZONE_BLOCKED; \
	} \
	else if (A.contents.len) { \
		ret = 0;\
		for (var/thing in A) { \
			var/atom/movable/AM = thing; \
			switch (AM.atmos_canpass) { \
				if (ATMOS_PASS_YES) { \
					continue; \
				} \
				if (ATMOS_PASS_DENSITY) { \
					if (AM.density) { \
						ret |= AIR_BLOCKED; \
					} \
				} \
				if (ATMOS_PASS_PROC) { \
					ret |= AM.c_airblock(B); \
				} \
				if (ATMOS_PASS_NO) { \
					ret = BLOCKED; \
				} \
			} \
			if (ret == BLOCKED) { \
				break;\
			}\
		}\
	}
#endif
