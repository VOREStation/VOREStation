/mob/living/silicon/pai/say(message, datum/language/speaking = null, whispering = 0)
	if(silence_time)
		to_chat(src, span_green("Communication circuits remain uninitialized."))
	else if(card.speech_synthesizer != PP_FUNCTIONAL)
		to_chat(src, span_warning("Communication circuits damaged. Service required."))
	else
		..()
