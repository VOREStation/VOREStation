//Timing subsystem
//Don't run if there is an identical unique timer active
//if the arguments to addtimer are the same as an existing timer, it doesn't create a new timer, and returns the id of the existing timer
#define TIMER_UNIQUE			(1<<0)
//For unique timers: Replace the old timer rather then not start this one
#define TIMER_OVERRIDE			(1<<1)
//Timing should be based on how timing progresses on clients, not the sever.
//	tracking this is more expensive,
//	should only be used in conjuction with things that have to progress client side, such as animate() or sound()
#define TIMER_CLIENT_TIME		(1<<2)
//Timer can be stopped using deltimer()
#define TIMER_STOPPABLE			(1<<3)
//To be used with TIMER_UNIQUE
//prevents distinguishing identical timers with the wait variable
#define TIMER_NO_HASH_WAIT		(1<<4)
//Loops the timer repeatedly until qdeleted
//In most cases you want a subsystem instead
#define TIMER_LOOP				(1<<5)

#define TIMER_ID_NULL -1

#define INITIALIZATION_INSSATOMS 0	//New should not call Initialize
#define INITIALIZATION_INNEW_MAPLOAD 1	//New should call Initialize(TRUE)
#define INITIALIZATION_INNEW_REGULAR 2	//New should call Initialize(FALSE)

#define INITIALIZE_HINT_NORMAL   0  //Nothing happens
#define INITIALIZE_HINT_LATELOAD 1  //Call LateInitialize
#define INITIALIZE_HINT_QDEL     2  //Call qdel on the atom

//type and all subtypes should always call Initialize in New()
#define INITIALIZE_IMMEDIATE(X) ##X/New(loc, ...){\
	..();\
	if(!initialized) {\
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

// Subsystem init_order, from highest priority to lowest priority
// Subsystems shutdown in the reverse of the order they initialize in
// The numbers just define the ordering, they are meaningless otherwise.
#define INIT_ORDER_SQLITE		40
#define INIT_ORDER_CHEMISTRY	35
#define INIT_ORDER_SKYBOX		30
#define INIT_ORDER_MAPPING		25
#define INIT_ORDER_DECALS		20
#define INIT_ORDER_PLANTS		19 // Must initialize before atoms.
#define INIT_ORDER_PLANETS		18
#define INIT_ORDER_JOB			17
#define INIT_ORDER_ALARM		16 // Must initialize before atoms.
#define INIT_ORDER_ATOMS		15
#define INIT_ORDER_MACHINES		10
#define INIT_ORDER_SHUTTLES		3
#define INIT_ORDER_TIMER		1
#define INIT_ORDER_DEFAULT		0
#define INIT_ORDER_LIGHTING		0
#define INIT_ORDER_AIR			-1
#define INIT_ORDER_ASSETS		-3
#define INIT_ORDER_HOLOMAPS		-5
#define INIT_ORDER_NIGHTSHIFT	-6
#define INIT_ORDER_OVERLAY		-7
#define INIT_ORDER_OPENSPACE	-10
#define INIT_ORDER_XENOARCH		-20
#define INIT_ORDER_CIRCUIT		-21
#define INIT_ORDER_AI			-22
#define INIT_ORDER_AI_FAST		-23
#define INIT_ORDER_GAME_MASTER	-24
#define INIT_ORDER_PERSISTENCE	-25
#define INIT_ORDER_TICKER		-50
#define INIT_ORDER_CHAT			-100 //Should be last to ensure chat remains smooth during init.


// Subsystem fire priority, from lowest to highest priority
// If the subsystem isn't listed here it's either DEFAULT or PROCESS (if it's a processing subsystem child)
#define FIRE_PRIORITY_SHUTTLES		5
#define FIRE_PRIORITY_SUPPLY		5
#define FIRE_PRIORITY_NIGHTSHIFT	5
#define FIRE_PRIORITY_PLANTS		5
#define FIRE_PRIORITY_ORBIT			8
#define FIRE_PRIORITY_VOTE			9
#define FIRE_PRIORITY_AI			10
#define FIRE_PRIORITY_GARBAGE		15
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
#define FIRE_PRIORITY_CHAT			400
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
