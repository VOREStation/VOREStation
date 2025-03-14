/datum/atc_chatter/shift_end/squak()
	switch(phase)
		if(1)
			SSatc.msg("[using_map.shuttle_name], this is [using_map.dock_name] Control, you are cleared to complete routine transfer from [using_map.station_name] to [using_map.dock_name].")
			next()
		else
			SSatc.msg("[using_map.shuttle_name] departing [using_map.dock_name] for [using_map.station_name] on routine transfer route. Estimated time to arrival: ten minutes.","[using_map.shuttle_name]")
			finish()
