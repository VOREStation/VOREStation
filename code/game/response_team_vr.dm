GLOBAL_VAR(ert_loaded)

/proc/consider_ert_load()
	if(!GLOB.ert_loaded)
		GLOB.ert_loaded = TRUE
		var/datum/map_template/MT = SSmapping.map_templates["Special Area - ERT"]
		if(!istype(MT))
			error("ERT Area is not a valid map template!")
		else
			MT.load_new_z(centered = TRUE)
			log_and_message_admins("Loaded the ERT shuttle just now.")