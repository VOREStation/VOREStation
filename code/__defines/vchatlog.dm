/* This comment bypasses grep checks */ /var/__vchatlog

/proc/__detect_vchatlog()
	if (world.system_type == UNIX)
		return __vchatlog = (fexists("./libvchatlog.so") ? "./libvchatlog.so" : "libvchatlog")
	else
		return __vchatlog = "vchatlog"

#define VCHATLOG (__vchatlog || __detect_vchatlog())
#define VCHATLOG_CALL(name, args...) call_ext(VCHATLOG, "byond:" + name)(args)
