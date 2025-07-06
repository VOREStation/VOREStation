#define OUT_TIME "TIME"
#define OUT_STATION_TIME "STATION_TIME"
#define OUT_LOGS "LOGS"
#define OUT_OWNER "OWNER"
#define OUT_COMMAND "COMMAND"

/datum/commandline_log_entry
	var/timestamp = 0 //used for sorting. This is when the COMMAND was created, not the last time it was modified! uses world.time
	var/IC_Timestamp = 0 //used for display(?)
	var/list/logs = list() //assoc list: Node = list(output,output_type)
	var/datum/commandline_network/owner //which network we're from. this is important.
	var/command //str that we inputted

/datum/commandline_log_entry/proc/set_log(var/datum/source, var/string = null, var/intensity = "normal")
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
	out[OUT_TIME] = timestamp
	out[OUT_STATION_TIME] = IC_Timestamp
	out[OUT_OWNER] = owner.name

	var/list/logout = list()
	for(var/datum/x in logs)
		logout["\ref[x]"] = logs[x]

	out[OUT_LOGS] = logout

	return out
