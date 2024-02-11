#define TimeOfGame (get_game_time())
#define TimeOfTick (TICK_USAGE*0.01*world.tick_lag)

#define DS2NEARESTTICK(DS) TICKS2DS(-round(-(DS2TICKS(DS))))

var/world_startup_time

/proc/get_game_time()
	var/global/time_offset = 0
	var/global/last_time = 0
	var/global/last_usage = 0

	var/wtime = world.time
	var/wusage = TICK_USAGE * 0.01

	if(last_time < wtime && last_usage > 1)
		time_offset += last_usage - 1

	last_time = wtime
	last_usage = wusage

	return wtime + (time_offset + wusage) * world.tick_lag

GLOBAL_VAR_INIT(roundstart_hour, pick(2,7,12,17))
var/station_date = ""
var/next_station_date_change = 1 DAY

#define duration2stationtime(time) time2text(station_time_in_ds + time, "hh:mm")
#define roundstart_delay_time (world.time - round_duration_in_ds)
#define world_time_in_ds(time) (GLOB.roundstart_hour HOURS + time - roundstart_delay_time)
#define round_duration_in_ds (GLOB.round_start_time ? REALTIMEOFDAY - GLOB.round_start_time : 0)
#define station_time_in_ds (GLOB.roundstart_hour HOURS + round_duration_in_ds)

/proc/stationtime2text()
	return time2text(station_time_in_ds + GLOB.timezoneOffset, "hh:mm")

/proc/worldtime2stationtime(time)
	return time2text(world_time_in_ds(time) + GLOB.timezoneOffset, "hh:mm")

/proc/stationdate2text()
	var/update_time = FALSE
	if(station_time_in_ds > next_station_date_change)
		next_station_date_change += 1 DAY
		update_time = TRUE
	if(!station_date || update_time)
		station_date = num2text((text2num(time2text(REALTIMEOFDAY, "YYYY"))+300)) + "-" + time2text(REALTIMEOFDAY, "MM-DD") //VOREStation Edit
	return station_date

//ISO 8601
/proc/time_stamp()
	var/date_portion = time2text(world.timeofday, "YYYY-MM-DD")
	var/time_portion = time2text(world.timeofday, "hh:mm:ss")
	return "[date_portion]T[time_portion]"

/proc/get_timezone_offset()
	var/midnight_gmt_here = text2num(time2text(0,"hh")) * 36000
	if(midnight_gmt_here > 12 HOURS)
		return 24 HOURS - midnight_gmt_here
	else
		return midnight_gmt_here

/proc/gameTimestamp(format = "hh:mm:ss", wtime=null)
	if(!wtime)
		wtime = world.time
	return time2text(wtime - GLOB.timezoneOffset, format)

/* Returns 1 if it is the selected month and day */
/proc/isDay(var/month, var/day)
	if(isnum(month) && isnum(day))
		var/MM = text2num(time2text(world.timeofday, "MM")) // get the current month
		var/DD = text2num(time2text(world.timeofday, "DD")) // get the current day
		if(month == MM && day == DD)
			return 1

		// Uncomment this out when debugging!
		//else
			//return 1

var/next_duration_update = 0
var/last_round_duration = 0
GLOBAL_VAR_INIT(round_start_time, 0)

/hook/roundstart/proc/start_timer()
	GLOB.round_start_time = REALTIMEOFDAY
	return 1

/proc/roundduration2text()
	if(!GLOB.round_start_time)
		return "00:00"
	if(last_round_duration && world.time < next_duration_update)
		return last_round_duration

	var/mills = round_duration_in_ds // 1/10 of a second, not real milliseconds but whatever
	//var/secs = ((mills % 36000) % 600) / 10 //Not really needed, but I'll leave it here for refrence.. or something
	var/mins = round((mills % 36000) / 600)
	var/hours = round(mills / 36000)

	mins = mins < 10 ? add_zero(mins, 1) : mins
	hours = hours < 10 ? add_zero(hours, 1) : hours

	last_round_duration = "[hours]:[mins]"
	next_duration_update = world.time + 1 MINUTES
	return last_round_duration

/var/midnight_rollovers = 0
/var/rollovercheck_last_timeofday = 0
/var/rollover_safety_date = 0 // set in world/New to the server startup day-of-month
/proc/update_midnight_rollover()
	// Day has wrapped (world.timeofday drops to 0 at the start of each real day)
	if (world.timeofday < rollovercheck_last_timeofday)
		// If the day started/last wrap was < 12 hours ago, this is spurious
		if(rollover_safety_date < world.realtime - (12 HOURS))
			midnight_rollovers++
			rollover_safety_date = world.realtime
		else
			warning("Time rollover error: world.timeofday decreased from previous check, but the day or last rollover is less than 12 hours old. System clock?")
	rollovercheck_last_timeofday = world.timeofday
	return midnight_rollovers

//Increases delay as the server gets more overloaded,
//as sleeps aren't cheap and sleeping only to wake up and sleep again is wasteful
#define DELTA_CALC max(((max(TICK_USAGE, world.cpu) / 100) * max(Master.sleep_delta-1,1)), 1)

//returns the number of ticks slept
/proc/stoplag(initial_delay)
	if (!Master || !(Master.current_runlevel & RUNLEVELS_DEFAULT))
		sleep(world.tick_lag)
		return 1
	if (!initial_delay)
		initial_delay = world.tick_lag
	. = 0
	var/i = DS2TICKS(initial_delay)
	do
		. += CEILING(i*DELTA_CALC, 1)
		sleep(i*world.tick_lag*DELTA_CALC)
		i *= 2
	while (TICK_USAGE > min(TICK_LIMIT_TO_RUN, Master.current_ticklimit))

#undef DELTA_CALC


//Takes a value of time in deciseconds.
//Returns a text value of that number in hours, minutes, or seconds.
/proc/DisplayTimeText(time_value, round_seconds_to = 0.1)
	var/second = round(time_value * 0.1, round_seconds_to)
	if(!second)
		return "right now"
	if(second < 60)
		return "[second] second[(second != 1)? "s":""]"
	var/minute = FLOOR(second / 60, 1)
	second = MODULUS(second, 60)
	var/secondT
	if(second)
		secondT = " and [second] second[(second != 1)? "s":""]"
	if(minute < 60)
		return "[minute] minute[(minute != 1)? "s":""][secondT]"
	var/hour = FLOOR(minute / 60, 1)
	minute = MODULUS(minute, 60)
	var/minuteT
	if(minute)
		minuteT = " and [minute] minute[(minute != 1)? "s":""]"
	if(hour < 24)
		return "[hour] hour[(hour != 1)? "s":""][minuteT][secondT]"
	var/day = FLOOR(hour / 24, 1)
	hour = MODULUS(hour, 24)
	var/hourT
	if(hour)
		hourT = " and [hour] hour[(hour != 1)? "s":""]"
	return "[day] day[(day != 1)? "s":""][hourT][minuteT][secondT]"
