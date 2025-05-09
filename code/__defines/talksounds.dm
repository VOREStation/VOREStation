// This is a global define so that downstream modular files can use this, instead of making a ton of messy lists like it was before.
#define FIND_TALK_SOUND(X) SSsounds.talk_sound_map[X]
#define DEFAULT_TALK_SOUND SSsounds.talk_sound_map[SSsounds.talk_sound_map[1]]
#define FALLBACK_TALK_SOUND SSsounds.talk_sound

/proc/get_talk_sound(var/voice_sound)
	if(!voice_sound)
		return DEFAULT_TALK_SOUND
	return FIND_TALK_SOUND(voice_sound)

/proc/rlist(var/list/keys,var/list/values) //short for reversible list generator
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
