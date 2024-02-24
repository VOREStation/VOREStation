/mob/living/silicon/pai/say(var/message, var/datum/language/speaking = null, var/whispering = 0)
	if(silence_time)
		to_chat(src, span_green("Communication circuits remain uninitialized."))
	else if(card.speech_synthesizer != PP_FUNCTIONAL)
		to_chat(src, "<span class='warning'>Communication circuits damaged. Service required.</span>")
	else
		..()
