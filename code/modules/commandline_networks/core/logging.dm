#define OUT_TIME "time"
#define OUT_STATION_TIME "station_time"
#define OUT_LOGS "logs"
#define OUT_OWNER "owner"
#define OUT_COMMAND "command"
#define OUT_SOURCE "source"

/datum/commandline_log_entry
	var/timestamp = 0 //used for sorting. This is when the COMMAND was created, not the last time it was modified! uses world.time
	var/IC_Timestamp = 0 //used for display(?)
	var/list/logs = list() //assoc list: Node = list(output,output_type)
	var/datum/commandline_network/owner //which network we're from. this is important.
	var/command //str that we inputted
	var/datum/source //what sent it - mostly used for filtering in the UI

/datum/commandline_log_entry/proc/set_log(var/datum/source, var/string = null, var/intensity = COMMAND_OUTPUT_STANDARD)
	to_chat(world,"Adding Log. From: [source], Log: [string]. Intensity: [intensity]");
	logs[source] = list(intensity,string)

/datum/commandline_log_entry/proc/get_log(var/datum/source)
	if(source in logs)
		return logs[source][2]

/datum/commandline_log_entry/New()
	timestamp = world.timeofday
	IC_Timestamp = stationtime2text()
	. = ..()

/datum/commandline_log_entry/proc/serializeLog()
	var/list/out = list()
	out[OUT_SOURCE] = "\ref[source]"
	out[OUT_TIME] = timestamp
	out[OUT_STATION_TIME] = IC_Timestamp
	out[OUT_OWNER] = owner.name
	out[OUT_COMMAND] = command

	var/list/logout = list()
	for(var/datum/x in logs)
		logout["\ref[x]"] = logs[x]

	out[OUT_LOGS] = logout

	return out

#undef OUT_TIME
#undef OUT_STATION_TIME
#undef OUT_LOGS
#undef OUT_OWNER
#undef OUT_COMMAND
#undef OUT_SOURCE
