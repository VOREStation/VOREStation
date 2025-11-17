///from /obj/belly/HandleBellyReagents() and /obj/belly/update_internal_overlay()
#define COMSIG_BELLY_UPDATE_VORE_FX "update_vore_fx"
///from /obj/belly/process()
#define COMSIG_BELLY_UPDATE_PREY_LOOP "update_prey_loop"

// Spontaneous vore stuff.
///from /mob/living/stumble_into(mob/living/M)
#define COMSIG_LIVING_STUMBLED_INTO "living_stumbled_into"
		///Something has special handling. Don't continue.
	#define CANCEL_STUMBLED_INTO	(1<<0)
///from /mob/living/handle_fall(var/turf/landing) args: landing, drop_mob)
#define COMSIG_LIVING_FALLING_DOWN "living_falling_down"
		//Special handling. Cancel the fall chain.
	#define COMSIG_CANCEL_FALL	(1<<0)
///from /mob/living/hitby(atom/movable/source, var/speed = THROWFORCE_SPEED_DIVISOR)
#define COMSIG_LIVING_HIT_BY_THROWN_ENTITY "hit_by_thrown_entity"
		//Special handling. Cancel the hitby proc.
	#define COMSIG_CANCEL_HITBY	(1<<0)
