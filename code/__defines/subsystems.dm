//! Defines for subsystems and overlays
//!
//! Lots of important stuff in here, make sure you have your brain switched on
//! when editing this file

//! ## Timing subsystem
/**
 * Don't run if there is an identical unique timer active
 *
 * if the arguments to addtimer are the same as an existing timer, it doesn't create a new timer,
 * and returns the id of the existing timer
 */
#define TIMER_UNIQUE (1<<0)

///For unique timers: Replace the old timer rather then not start this one
#define TIMER_OVERRIDE (1<<1)

/**
 * Timing should be based on how timing progresses on clients, not the server.
 *
 * Tracking this is more expensive,
 * should only be used in conjunction with things that have to progress client side, such as
 * animate() or sound()
 */
#define TIMER_CLIENT_TIME (1<<2)

///Timer can be stopped using deltimer()
#define TIMER_STOPPABLE (1<<3)

///prevents distinguishing identical timers with the wait variable
///
///To be used with TIMER_UNIQUE
#define TIMER_NO_HASH_WAIT (1<<4)

///Loops the timer repeatedly until qdeleted
///
///In most cases you want a subsystem instead, so don't use this unless you have a good reason
#define TIMER_LOOP (1<<5)

///Delete the timer on parent datum Destroy() and when deltimer'd
#define TIMER_DELETE_ME (1<<6)

///Empty ID define
#define TIMER_ID_NULL -1

/// Used to trigger object removal from a processing list
#define PROCESS_KILL 26


//! ## Initialization subsystem

///New should not call Initialize
#define INITIALIZATION_INSSATOMS 0
///New should call Initialize(TRUE)
#define INITIALIZATION_INNEW_MAPLOAD 1
///New should call Initialize(FALSE)
#define INITIALIZATION_INNEW_REGULAR 2

//! ### Initialization hints

///Nothing happens
#define INITIALIZE_HINT_NORMAL 0
/**
 * call LateInitialize at the end of all atom Initialization
 *
 * The item will be added to the late_loaders list, this is iterated over after
 * initialization of subsystems is complete and calls LateInitalize on the atom
 * see [this file for the LateIntialize proc](atom.html#proc/LateInitialize)
 */
#define INITIALIZE_HINT_LATELOAD 1

///Call qdel on the atom after initialization
#define INITIALIZE_HINT_QDEL 2

///type and all subtypes should always immediately call Initialize in New()
#define INITIALIZE_IMMEDIATE(X) ##X/New(loc, ...){\
	..();\
	if(!(flags & ATOM_INITIALIZED)) {\
		args[1] = TRUE;\
		SSatoms.InitAtom(src, args);\
	}\
}

// SS runlevels

#define RUNLEVEL_INIT 0			// "Initialize Only" - Used for subsystems that should never be fired (Should also have SS_NO_FIRE set)
#define RUNLEVEL_LOBBY 1		// Initial runlevel before setup.  Returns to here if setup fails.
#define RUNLEVEL_SETUP 2		// While the gamemode setup is running.  I.E gameticker.setup()
#define RUNLEVEL_GAME 4			// After successful game ticker setup, while the round is running.
#define RUNLEVEL_POSTGAME 8		// When round completes but before reboot

#define RUNLEVELS_DEFAULT (RUNLEVEL_SETUP | RUNLEVEL_GAME | RUNLEVEL_POSTGAME)

var/global/list/runlevel_flags = list(RUNLEVEL_LOBBY, RUNLEVEL_SETUP, RUNLEVEL_GAME, RUNLEVEL_POSTGAME)
#define RUNLEVEL_FLAG_TO_INDEX(flag) (log(2, flag) + 1)	// Convert from the runlevel bitfield constants to index in runlevel_flags list

//! ### SS initialization hints
/**
 * Negative values indicate a failure or warning of some kind, positive are good.
 * 0 and 1 are unused so that TRUE and FALSE are guaranteed to be invalid values.
 */

/// Subsystem failed to initialize entirely. Print a warning, log, and disable firing.
#define SS_INIT_FAILURE -2

/// The default return value which must be overridden. Will succeed with a warning.
#define SS_INIT_NONE -1

/// Subsystem initialized successfully.
#define SS_INIT_SUCCESS 2

/// If your system doesn't need to be initialized (by being disabled or something)
#define SS_INIT_NO_NEED 3

//! ### SS initialization load orders
// Subsystem init_order, from highest priority to lowest priority
// Subsystems shutdown in the reverse of the order they initialize in
// The numbers just define the ordering, they are meaningless otherwise.
#define INIT_ORDER_SERVER_MAINT		93
#define INIT_ORDER_ADMIN_VERBS 		84 // needs to be pretty high, admins can't do much without it
#define INIT_ORDER_WEBHOOKS			50
#define INIT_ORDER_SQLITE			41
#define INIT_ORDER_GARBAGE			40
#define INIT_ORDER_DBCORE			39
#define INIT_ORDER_MEDIA_TRACKS		38 // Gotta get that lobby music up, yo
#define INIT_ORDER_INPUT			37
#define INIT_ORDER_CHEMISTRY		35
#define INIT_ORDER_ROBOT_SPRITES	34
#define INIT_ORDER_VIS				32
#define INIT_ORDER_MAPPING			25
#define INIT_ORDER_SOUNDS			23
#define INIT_ORDER_INSTRUMENTS		22
#define INIT_ORDER_DECALS			20
#define INIT_ORDER_PLANTS			19 // Must initialize before atoms.
#define INIT_ORDER_PLANETS			18
#define INIT_ORDER_JOB				17
#define INIT_ORDER_ALARM			16 // Must initialize before atoms.
#define INIT_ORDER_TRANSCORE		15
#define INIT_ORDER_ATOMS			14
#define INIT_ORDER_MACHINES			10
#define INIT_ORDER_SHUTTLES			3
#define INIT_ORDER_TIMER			1
#define INIT_ORDER_DEFAULT			0
#define INIT_ORDER_LIGHTING			0
#define INIT_ORDER_AIR				-1
#define INIT_ORDER_ASSETS			-3
#define INIT_ORDER_HOLOMAPS			-5
#define INIT_ORDER_NIGHTSHIFT		-6
#define INIT_ORDER_OVERLAY			-7
#define INIT_ORDER_XENOARCH			-20
#define INIT_ORDER_CIRCUIT			-21
#define INIT_ORDER_AI				-22
#define INIT_ORDER_AI_FAST			-23
#define INIT_ORDER_GAME_MASTER		-24
#define INIT_ORDER_PERSISTENCE		-25
#define INIT_ORDER_SKYBOX			-30 //Visual only, irrelevant to gameplay, but needs to be late enough to have overmap populated fully
#define INIT_ORDER_TICKER			-50
#define INIT_ORDER_MAPRENAME		-60 //Initiating after Ticker to ensure everything is loaded and everything we rely on us working
#define INIT_ORDER_STATPANELS		-98
#define INIT_ORDER_CHAT				-100 //Should be last to ensure chat remains smooth during init.

// Subsystem fire priority, from lowest to highest priority
// If the subsystem isn't listed here it's either DEFAULT or PROCESS (if it's a processing subsystem child)
#define FIRE_PRIORITY_ATC			1
#define FIRE_PRIORITY_PLAYERTIPS	5
#define FIRE_PRIORITY_SHUTTLES		5
#define FIRE_PRIORITY_SUPPLY		5
#define FIRE_PRIORITY_NIGHTSHIFT	5
#define FIRE_PRIORITY_PLANTS		5
#define FIRE_PRIORITY_VIS			5
#define FIRE_PRIORITY_MOTIONTRACKER 6
#define FIRE_PRIORITY_ORBIT			7
#define FIRE_PRIORITY_VOTE			8
#define FIRE_PRIORITY_INSTRUMENTS	9
#define FIRE_PRIORITY_PING			10
#define FIRE_PRIORITY_SERVER_MAINT	10
#define FIRE_PRIORITY_AI			10
#define FIRE_PRIORITY_GARBAGE		15
#define FIRE_PRIORITY_ASSETS 		20
#define FIRE_PRIORITY_ALARM			20
#define FIRE_PRIORITY_CHARSETUP     25
#define FIRE_PRIORITY_AIRFLOW		30
#define FIRE_PRIORITY_AIR			35
#define FIRE_PRIORITY_OBJ			40
#define FIRE_PRIORITY_PROCESS		45
#define FIRE_PRIORITY_DEFAULT		50
#define FIRE_PRIORITY_TICKER		60
#define FIRE_PRIORITY_PLANETS		75
#define FIRE_PRIORITY_MACHINES		100
#define FIRE_PRIORITY_TGUI			110
#define FIRE_PRIORITY_PROJECTILES	150
#define FIRE_PRIORITY_STATPANEL		390
#define FIRE_PRIORITY_CHAT			400
#define FIRE_PRIORITY_RUNECHAT		410
#define FIRE_PRIORITY_OVERLAYS		500
#define FIRE_PRIORITY_TIMER			700
#define FIRE_PRIORITY_SPEECH_CONTROLLER 900
#define FIRE_PRIORITY_DELAYED_VERBS 950
#define FIRE_PRIORITY_INPUT			1000 // This must always always be the max highest priority. Player input must never be lost.

/**
	Create a new timer and add it to the queue.
	* Arguments:
	* * callback the callback to call on timer finish
	* * wait deciseconds to run the timer for
	* * flags flags for this timer, see: code\__DEFINES\subsystems.dm
	* * timer_subsystem the subsystem to insert this timer into
*/
#define addtimer(args...) _addtimer(args, file = __FILE__, line = __LINE__)

/// The timer key used to know how long subsystem initialization takes
#define SS_INIT_TIMER_KEY "ss_init"
