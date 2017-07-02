
// SS runlevels

#define RUNLEVEL_INIT 0			// "Initialize Only" - Used for subsystems that should never be fired (Should also have SS_NO_FIRE set)
#define RUNLEVEL_LOBBY 1		// Initial runlevel before setup.  Returns to here if setup fails.
#define RUNLEVEL_SETUP 2		// While the gamemode setup is running.  I.E gameticker.setup()
#define RUNLEVEL_GAME 4			// After successful game ticker setup, while the round is running.
#define RUNLEVEL_POSTGAME 8		// When round completes but before reboot

#define RUNLEVELS_DEFAULT (RUNLEVEL_SETUP | RUNLEVEL_GAME | RUNLEVEL_POSTGAME)

var/global/list/runlevel_flags = list(RUNLEVEL_LOBBY, RUNLEVEL_SETUP, RUNLEVEL_GAME, RUNLEVEL_POSTGAME)
#define RUNLEVEL_FLAG_TO_INDEX(flag) (log(2, flag) + 1)	// Convert from the runlevel bitfield constants to index in runlevel_flags list

#define INIT_ORDER_LIGHTING 0
