
#define INITIALIZATION_INSSATOMS 0	//New should not call Initialize
#define INITIALIZATION_INNEW_MAPLOAD 1	//New should call Initialize(TRUE)
#define INITIALIZATION_INNEW_REGULAR 2	//New should call Initialize(FALSE)

#define INITIALIZE_HINT_NORMAL   0  //Nothing happens
#define INITIALIZE_HINT_LATELOAD 1  //Call LateInitialize
#define INITIALIZE_HINT_QDEL     2  //Call qdel on the atom

// SS runlevels

#define RUNLEVEL_INIT 0			// "Initialize Only" - Used for subsystems that should never be fired (Should also have SS_NO_FIRE set)
#define RUNLEVEL_LOBBY 1		// Initial runlevel before setup.  Returns to here if setup fails.
#define RUNLEVEL_SETUP 2		// While the gamemode setup is running.  I.E gameticker.setup()
#define RUNLEVEL_GAME 4			// After successful game ticker setup, while the round is running.
#define RUNLEVEL_POSTGAME 8		// When round completes but before reboot

#define RUNLEVELS_DEFAULT (RUNLEVEL_SETUP | RUNLEVEL_GAME | RUNLEVEL_POSTGAME)

var/global/list/runlevel_flags = list(RUNLEVEL_LOBBY, RUNLEVEL_SETUP, RUNLEVEL_GAME, RUNLEVEL_POSTGAME)
#define RUNLEVEL_FLAG_TO_INDEX(flag) (log(2, flag) + 1)	// Convert from the runlevel bitfield constants to index in runlevel_flags list

// Subsystem init_order, from highest priority to lowest priority
// Subsystems shutdown in the reverse of the order they initialize in
// The numbers just define the ordering, they are meaningless otherwise.
#define INIT_ORDER_MAPPING	20  // VOREStation Edit
#define INIT_ORDER_DECALS	16
#define INIT_ORDER_ATOMS	15
#define INIT_ORDER_MACHINES 10
#define INIT_ORDER_SHUTTLES 3
#define INIT_ORDER_LIGHTING 0
#define INIT_ORDER_AIR -1
