// Based on Aurora's anti-spam system.
/client/
	var/last_message_time = 0
	var/spam_alert = 0

/client/proc/handle_spam_prevention(var/mute_type = MUTE_ALL, var/spam_delay = 0.5 SECONDS)
	if(world.time - last_message_time < spam_delay)
		spam_alert++
		if(spam_alert > 5)
			cmd_admin_mute(src.mob, mute_type, 1)
	else
		spam_alert = max(0, spam_alert--)
	last_message_time = world.time