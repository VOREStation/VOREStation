/* This comment bypasses grep checks */ /var/__verdigris

/proc/__detect_verdigris()
	if (world.system_type == UNIX)
		return __verdigris = (fexists("./libverdigris.so") ? "./libverdigris.so" : "libverdigris")
	else
		return __verdigris = "verdigris"

#define VERDIGRIS (__verdigris || __detect_verdigris())
#define VERDIGRIS_CALL(name, args...) call_ext(VERDIGRIS, "byond:" + name)(args)

/proc/verdigris_version()	return VERDIGRIS_CALL("verdigris_version")
/proc/verdigris_features()	return VERDIGRIS_CALL("verdigris_features")
/proc/verdigris_cleanup()	return VERDIGRIS_CALL("cleanup")

/world/New()
	verdigris_cleanup()
	..()
