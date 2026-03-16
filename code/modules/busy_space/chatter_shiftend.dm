/datum/atc_chatter/shift_end/squak()
	switch(phase)
		if(1)
			SSatc.msg("[GLOB.using_map.shuttle_name], this is [GLOB.using_map.dock_name] Control, you are cleared to complete routine transfer from [GLOB.using_map.station_name] to [GLOB.using_map.dock_name].")
			next()
		else
			SSatc.msg("[GLOB.using_map.shuttle_name] departing [GLOB.using_map.dock_name] for [GLOB.using_map.station_name] on routine transfer route. Estimated time to arrival: ten minutes.","[GLOB.using_map.shuttle_name]")
			finish()
