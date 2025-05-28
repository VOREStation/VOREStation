GLOBAL_VAR(trader_loaded)

/proc/consider_trader_load()
	if(!GLOB.trader_loaded)
		GLOB.trader_loaded = TRUE
		var/datum/map_template/MT = SSmapping.map_templates["Special Area - Salamander Trader"] //was: "Special Area - Trader"
		if(!istype(MT))
			error("Trader is not a valid map template!")
		else
			MT.load_new_z(centered = TRUE)
			log_and_message_admins("Loaded the trade shuttle just now.")
