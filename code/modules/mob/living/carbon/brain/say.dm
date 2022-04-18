//TODO: Convert this over for languages.
/mob/living/carbon/brain/say(var/message, var/datum/language/speaking = null, var/whispering = 0)
	if(silent)
		return

	message = sanitize(message)

	if(!(container && container.can_speak))
		return //Certain objects can speak, like MMIs. Most others cannot. -Q
	else
		if(prob(emp_damage * 4))
			if(prob(10))//10% chance to drop the message entirely
				return
			else
				message = Gibberish(message, (emp_damage*6))//scrambles the message, gets worse when emp_damage is higher

		..()

/mob/living/carbon/brain/handle_message_mode(message_mode, message, verb, speaking, used_radios)
	..()
	if(message_mode)
		var/obj/item/mmi/R = container
		if(R.radio && R.radio.radio_enabled)
			if(message_mode == "general")
				message_mode = null
			return R.radio.talk_into(src, message, message_mode, verb, speaking)
		else
			to_chat(src, "<span class='danger'>Your radio is disabled.</span>")
			return 0
