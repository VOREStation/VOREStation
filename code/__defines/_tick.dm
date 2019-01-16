#define TICK_LIMIT_RUNNING 80
#define TICK_LIMIT_TO_RUN 70
#define TICK_LIMIT_MC 70
#define TICK_LIMIT_MC_INIT_DEFAULT 98

#define TICK_CHECK ( TICK_USAGE > GLOB.CURRENT_TICKLIMIT )
#define CHECK_TICK if TICK_CHECK stoplag()

<<<<<<< HEAD
#define TICK_USAGE world.tick_usage
=======
#define TICK_CHECK_HIGH_PRIORITY ( TICK_USAGE > 95 )
#define CHECK_TICK_HIGH_PRIORITY ( TICK_CHECK_HIGH_PRIORITY? stoplag() : 0 )

#define UNTIL(X) while(!(X)) stoplag()
