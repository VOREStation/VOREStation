/datum/event/dust
	startWhen	= 10
	endWhen		= 30

/datum/event/dust/announce()
	command_announcement.Announce("Debris resulting from activity on another nearby asteroid is approaching your colony.", "Dust Alert", new_sound = 'sound/AI/AI_vr/Debris-beginning.ogg')	//VOREStation edit: Event announcements

/datum/event/dust/start()
	dust_swarm(get_severity())

/datum/event/dust/end()
	command_announcement.Announce("The colony is no longer in danger of impact from space debris.", "Dust Notice", new_sound = 'sound/AI/AI_vr/Debris-end.ogg')	//VOREStation edit: Event announcements

/datum/event/dust/proc/get_severity()
	switch(severity)
		if(EVENT_LEVEL_MUNDANE)
			return "weak"
		if(EVENT_LEVEL_MODERATE)
			return prob(80) ? "norm" : "strong"
		if(EVENT_LEVEL_MAJOR)
			return "super"
	return "weak"
