
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
#define INIT_ORDER_DEFAULT	0
#define INIT_ORDER_LIGHTING 0
#define INIT_ORDER_AIR		-1
#define INIT_ORDER_HOLOMAPS -5
#define INIT_ORDER_OVERLAY	-6
#define INIT_ORDER_XENOARCH	-20
 

// Subsystem fire priority, from lowest to highest priority
// If the subsystem isn't listed here it's either DEFAULT or PROCESS (if it's a processing subsystem child)
#define FIRE_PRIORITY_SHUTTLES		5
#define FIRE_PRIORITY_ORBIT			8
#define FIRE_PRIORITY_GARBAGE		15
#define FIRE_PRIORITY_AIRFLOW		30
#define FIRE_PRIORITY_AIR			35
#define FIRE_PRIORITY_DEFAULT		50
#define FIRE_PRIORITY_MACHINES		100
#define FIRE_PRIORITY_OVERLAYS		500

// Macro defining the actual code applying our overlays lists to the BYOND overlays list. (I guess a macro for speed)
// TODO - I don't really like the location of this macro define.  Consider it. ~Leshana
#define COMPILE_OVERLAYS(A)\
	if (TRUE) {\
		var/list/oo = A.our_overlays;\
		var/list/po = A.priority_overlays;\
		if(LAZYLEN(po)){\
			if(LAZYLEN(oo)){\
				A.overlays = oo + po;\
			}\
			else{\
				A.overlays = po;\
			}\
		}\
		else if(LAZYLEN(oo)){\
			A.overlays = oo;\
		}\
		else{\
			A.overlays.Cut();\
		}\
		A.flags &= ~OVERLAY_QUEUED;\
	}
