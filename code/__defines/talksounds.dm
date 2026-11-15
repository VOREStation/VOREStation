#define DEFAULT_TALK_SOUNDS GLOB.talk_sound

/proc/get_talk_sound(voice_sound)
	if(!voice_sound)
		return DEFAULT_TALK_SOUNDS
	return SSsounds.talk_sound_map[voice_sound]

/proc/rlist(list/keys,list/values) //short for reversible list generator
	var/list/rlist = list(list(),list(),FALSE,0)
	var/i = 0
	for(i = 1, i <= LAZYLEN(keys), i++)
		to_chat(world,keys[i])
		rlist[1] += keys[i]
		rlist[2][keys[i]] = values[i]
	rlist += TRUE
	rlist += i
	return rlist

/proc/arlist(list/altlist)
	var/list/rlist = list(list(),list(),FALSE,0)
	var/i = 0
	for(i = 1, i <= LAZYLEN(altlist), i++)
		rlist[(i % 2) +1] += altlist[i]
	rlist += TRUE
	rlist += i/2
	return rlist
