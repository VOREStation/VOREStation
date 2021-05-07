// This datum allows one to add and subtract various lengths of time.  It really shines when using an alternate time system.

/datum/time
	// Note that the following is actually measured in 10ths of a second.
	var/seconds_in_day = 60 * 60 * 24 * 10 	// 86,400 seconds
	var/seconds_in_hour = 60 * 60 * 10 		// 3,600 seconds
	var/seconds_in_minute = 60 * 10

	// This holds the amount of seconds.
	var/seconds_stored = 0

/datum/time/New(new_time)
	if(new_time)
		if(new_time >= seconds_in_day)
			new_time = rollover(new_time)
		seconds_stored = new_time
	..()

/datum/time/proc/add_seconds(amount)
	var/answer = seconds_stored + amount * 10
	if(answer >= seconds_in_day)
		answer = rollover(answer)
	return new type(answer)

/datum/time/proc/add_minutes(amount)
	var/real_amount = amount * seconds_in_minute
	var/answer = real_amount + seconds_stored
	if(answer >= seconds_in_day)
		answer = rollover(answer)
	return new type(answer)

/datum/time/proc/add_hours(amount)
	var/real_amount = amount * seconds_in_hour
	var/answer = real_amount + seconds_stored
	if(answer >= seconds_in_day)
		answer = rollover(answer)
	return new type(answer)

/datum/time/proc/rollover(time)
	return max(time - seconds_in_day, 0)

/datum/time/proc/make_random_time()
	return new type(rand(0, seconds_in_day - 1))

// 'day' as in not hours since the epoch
/datum/time/proc/get_day_hour()
	var/day_seconds = seconds_stored % seconds_in_day
	return FLOOR(day_seconds / seconds_in_hour, 1)

/datum/time/proc/get_day_minute()
	var/day_seconds = seconds_stored % seconds_in_day
	return day_seconds % seconds_in_hour

/datum/time/proc/get_day_second()
	var/day_seconds = seconds_stored % seconds_in_day
	return day_seconds % seconds_in_minute

// negative return values mean noon is behind you
/datum/time/proc/hours_until_noon()
	var/day_seconds = seconds_stored % seconds_in_day
	var/day_hour = day_seconds / seconds_in_hour
	var/midday = (seconds_in_day / seconds_in_hour) / 2

	return (midday - day_hour)

// This works almost exactly like time2text.
// The advantage of this is that it can handle time systems beyond 24h.
// The downside is a lack of date capability.
/datum/time/proc/show_time(format)
	var/time = seconds_stored
	while(time >= seconds_in_day) // First, get rid of extra days.
		time = rollover(time)

	var/hours = time / seconds_in_hour
	var/remaining_hour = time % seconds_in_hour
	var/minutes = remaining_hour / seconds_in_minute
	var/seconds = remaining_hour % seconds_in_minute / 10


	var/hour_text = num2text(FLOOR(hours, 1))
	if(length(hour_text) < 2)
		hour_text = "0[hour_text]" // Add padding if needed, to look more like time2text().

	var/minute_text = num2text(FLOOR(minutes, 1))
	if(length(minute_text) < 2)
		minute_text = "0[minute_text]"

	var/second_text = num2text(FLOOR(seconds, 1))
	if(length(second_text) < 2)
		second_text = "0[second_text]"

	var/answer = replacetext(format, "hh", hour_text)
	answer = replacetext(answer, "mm", minute_text)
	answer = replacetext(answer, "ss", second_text)
	return answer
