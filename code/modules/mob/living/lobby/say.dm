/mob/living/lobby/say(var/message)
	message = sanitize(message)

	if (!message)
		return

	log_say("Lobby/[src.key] : [message]")

	src << "<span class='name'>[src]</span> says, \"[message]\"" // Since lobby mobs are "isolated", only they hear themselves.


/mob/living/lobby/emote(var/act, var/type, var/message)
	//message = sanitize(message) - already sanitized in verb/me_verb()

	if(!message)
		return

	if(act != "me")
		return

	log_emote("Lobby/[src.key] : [message]")

	src << "<span class='name'>[src]</span> [message]"