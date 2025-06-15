/// Use this when copying vars[] to skip some built in byond ones that get really unhappy when you access them like that. Used like if(BLACKLISTED_COPY_VARS) in switch or list(BLACKLISTED_COPY_VARS)
#define BLACKLISTED_COPY_VARS "ATOM_TOPIC_EXAMINE","type","loc","locs","vars","parent","parent_type","verbs","ckey","key","_active_timers", "_datum_components", "_listen_lookup", "_signal_procs"
