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
