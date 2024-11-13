

var/list/talk_sound_map = rlist(
								list(
									"beep-boop",
									"goon speak 1",
									"goon speak 2",
									"goon speak 3",
									"goon speak 4",
									"goon speak blub",
									"goon speak bottalk",
									"goon speak buwoo",
									"goon speak cow",
									"goon speak lizard",
									"goon speak pug",
									"goon speak pugg",
									"goon speak roach",
									"goon speak skelly",
									// "xeno speak" // Does not exist on virgo
								),
								list(
									talk_sound,
									goon_speak_one_sound,
									goon_speak_two_sound,
									goon_speak_three_sound,
									goon_speak_four_sound,
									goon_speak_blub_sound,
									goon_speak_bottalk_sound,
									goon_speak_buwoo_sound,
									goon_speak_cow_sound,
									goon_speak_lizard_sound,
									goon_speak_pug_sound,
									goon_speak_pugg_sound,
									goon_speak_roach_sound,
									goon_speak_skelly_sound,
									// xeno_speak_sound // Does not exist on virgo
									)
								)

/proc/get_talk_sound(var/voice_sound)
	if(!voice_sound)
		return talk_sound_map[1]
	return talk_sound_map[2][voice_sound]

proc/rlist(var/list/keys,var/list/values) //short for reversible list generator
	var/list/rlist = list(list(),list(),FALSE,0)
	var/i = 0
	for(i = 1, i <= LAZYLEN(keys), i++)
		to_chat(world,keys[i])
		rlist[1] += keys[i]
		rlist[2][keys[i]] = values[i]
	rlist += TRUE
	rlist += i
	return rlist

/proc/arlist(var/list/altlist)
	var/list/rlist = list(list(),list(),FALSE,0)
	var/i = 0
	for(i = 1, i <= LAZYLEN(altlist), i++)
		rlist[(i % 2) +1] += altlist[i]
	rlist += TRUE
	rlist += i/2
	return rlist
