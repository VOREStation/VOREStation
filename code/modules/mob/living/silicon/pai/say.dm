/mob/living/silicon/pai/say(var/message, var/datum/language/speaking = null, var/whispering = 0)
	if(silence_time)
		to_chat(src, "<font color=green>Communication circuits remain uninitialized.</font>")
	else
		..()