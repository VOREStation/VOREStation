#define EMPTY_BITFIELD 0

/* Directions */
///All the cardinal direction bitflags.
#define ALL_CARDINALS (NORTH|SOUTH|EAST|WEST)


/* -- /datum/var/datum_flags -- */

#define DF_VAR_EDITED			(1<<0)
#define DF_ISPROCESSING			(1<<1)
#define DF_USE_TAG				(1<<2)


/* -- /atom/var/atom_flags -- */

/// The atom has been initialized.
#define ATOM_INITIALIZED (1<<0)

/// The atom does not conduct electricity.
#define ATOM_IS_INSULATED (1<<1)

/// The atom should be considered ahead of others when changing turfs.
#define ATOM_HAS_TRANSITION_PRIORITY (1<<2)

/// For the purpose of reagents transfer, this atom can be interacted with syringes etc.
#define ATOM_REAGENTS_IS_OPEN (1<<3)

/// Reagents do not react inside this atom, regardless of recipes.
#define	ATOM_REAGENTS_SKIP_REACTIONS (1<<4)

/// This atom is queued for an overlay update.
#define ATOM_AWAITING_OVERLAY_UPDATE (1<<5)


/* -- /turf/var/turf_flags -- */

/// The turf is blessed; it interferes with cult behaviors.
#define TURF_IS_BLESSED (1<<0)

/// The turf prevents wizard movement spells.
#define TURF_PREVENTS_JAUNT (1<<1)


/* -- /atom/movable/var/movement_type -- */

#define UNSTOPPABLE				(1<<0)			//Can not be stopped from moving from Cross(), CanPass(), or Uncross() failing. Still bumps everything it passes through, though.

<<<<<<< HEAD
// Flags bitmasks. - Used in /atom/var/flags
#define NOBLUDGEON				(1<<0)	// When an item has this it produces no "X has been hit by Y with Z" message with the default handler.
#define NOCONDUCT					(1<<1)	// Conducts electricity. (metal etc.)
#define ON_BORDER				(1<<2)	// Item has priority to check when entering or leaving.
#define NOBLOODY				(1<<3)	// Used for items if they don't want to get a blood overlay.
#define OPENCONTAINER			(1<<4)	// Is an open container for chemistry purposes.
#define PHORONGUARD				(1<<5)	// Does not get contaminated by phoron.
#define	NOREACT					(1<<6)	// Reagents don't react inside this container.
#define OVERLAY_QUEUED			(1<<7)// Atom queued to SSoverlay for COMPILE_OVERLAYS
#define IS_BUSY					(1<<8)	// Atom has a TASK_TARGET_EXCLUSIVE do_after with it as the target.

//Flags for items (equipment) - Used in /obj/item/var/item_flags
=======

/* -- /obj/item/var/item_flags -- */

>>>>>>> 56bf74c21f8... Merge pull request #8762 from Spookerton/spkrtn/sys/flagging
#define THICKMATERIAL			(1<<0)	// Prevents syringes, parapens and hyposprays if equipped to slot_suit or slot_head.
#define AIRTIGHT				(1<<1)	// Functions with internals.
#define NOSLIP					(1<<2)	// Prevents from slipping on wet floors, in space, etc.
#define BLOCK_GAS_SMOKE_EFFECT	(1<<3)	// Blocks the effect that chemical clouds would have on a mob -- glasses, mask and helmets ONLY! (NOTE: flag shared with ONESIZEFITSALL)
#define FLEXIBLEMATERIAL		(1<<4)	// At the moment, masks with this flag will not prevent eating even if they are covering your face.
#define ALLOW_SURVIVALFOOD		(1<<5)	// Allows special survival food items to be eaten through it
#define NOBLOODY				(1<<6)	// Used for items if they don't want to get a blood overlay.
#define NOBLUDGEON				(1<<7)	// When an item has this it produces no "X has been hit by Y with Z" message with the default handler.
#define PHORONGUARD				(1<<8)	// Item does not get contaminated by phoron.


/* -- /atom/var/pass_flags -- */

#define PASSTABLE				(1<<0)
#define PASSGLASS				(1<<1)
#define PASSGRILLE				(1<<2)
#define PASSBLOB				(1<<3)
#define PASSMOB					(1<<4)

<<<<<<< HEAD
// Flags for do_after/do_mob exclusivity.
#define TASK_TARGET_EXCLUSIVE	(1<<1)
#define TASK_USER_EXCLUSIVE		(1<<2)
#define TASK_ALL_EXCLUSIVE		TASK_TARGET_EXCLUSIVE | TASK_USER_EXCLUSIVE
=======

/* -- /obj/effect/shuttle_landmark/var/landmark_flags -- */

/// This atom is a shuttle landmark that should create its own landing point.
#define LANDMARK_CREATES_SAFE_SITE (1<<0)

/// This atom is a shuttle landmark that causes arriving shuttles to have no gravity.
#define LANDMARK_REMOVES_GRAVITY (1<<1)
>>>>>>> 56bf74c21f8... Merge pull request #8762 from Spookerton/spkrtn/sys/flagging
