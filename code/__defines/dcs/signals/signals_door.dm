// /obj/machinery/door signals

//from /obj/machinery/door/can_open():
#define COMSIG_DOOR_CAN_OPEN "attempt_door_open"
	/// Return to stop the door opening
	#define DOOR_DENY_OPEN (1<<0)
//from /obj/machinery/door/can_close():
#define COMSIG_DOOR_CAN_CLOSE "attempt_door_close"
	/// Return to stop the door closing
	#define DOOR_DENY_CLOSE (1<<0)
//from /obj/machinery/door/open(): (forced)
#define COMSIG_DOOR_OPEN "door_open"
//from /obj/machinery/door/close(): (forced)
#define COMSIG_DOOR_CLOSE "door_close"
///from /obj/machinery/door/airlock/set_bolt():
// #define COMSIG_AIRLOCK_SET_BOLT "airlock_set_bolt" //In signals_object.dm
///from /obj/machinery/door/bumpopen(), to the mob who bumped: (door)
#define COMSIG_MOB_BUMPED_DOOR_OPEN "mob_bumped_door_open"
	/// Return to stop the door opening on bump.
	#define DOOR_STOP_BUMP (1<<0)
