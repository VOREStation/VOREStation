/mob/living/carbon/human/emote_vr(var/act,var/m_type=1,var/message = null)

	switch(act)
		if ("mlem")
			message = "mlems their tongue up over their nose. Mlem."
			m_type = 1
		if ("awoo")
			message = "awoos loudly. AwoooOOOOoooo!"
			m_type = 2

	if (message)
		log_emote("[name]/[key] : [message]")
		custom_emote(m_type,message)
		return 1

	return 0
