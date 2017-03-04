/mob/living/carbon/human/proc/handle_emote_vr(var/act,var/m_type=1,var/message = null)

	switch(act)
		if ("mlem")
			message = "mlems their tongue up over their nose. Mlem."
			m_type = 1
		if ("awoo")
			message = "awoos loudly. AwoooOOOOoooo!"
			m_type = 2
		if ("flip")
			message = "does a flip!"
			if(!src.sleeping || !src.resting || !src.buckled || !src.restrained())
				src.SpinAnimation(7,1)
			m_type = 1

	if (message)
		log_emote("[name]/[key] : [message]")
		custom_emote(m_type,message)
		return 1

	return 0

