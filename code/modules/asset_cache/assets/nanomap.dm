/datum/asset/simple/holo_nanomap
	keep_local_name = TRUE

/datum/asset/simple/holo_nanomap/register()
	assets = SSholomaps.dump_nanomap_icons()
	. = ..()
