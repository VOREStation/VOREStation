/mob/living/carbon/brain/emote(var/act,var/m_type=1,var/message = null)
	if(!(container && istype(container, /obj/item/device/mmi)))//No MMI, no emotes
		return

	if(findtext(act, "-", 1, null))
		var/t1 = findtext(act, "-", 1, null)
		act = copytext(act, 1, t1)

	if(stat == DEAD)
		return
	switch(act)
		if("alarm")
			to_chat(src, "You sound an alarm.")
			message = "<B>[src]</B> sounds an alarm."
			m_type = 2
		if("alert")
			to_chat(src, "You let out a distressed noise.")
			message = "<B>[src]</B> lets out a distressed noise."
			m_type = 2
		if("notice")
			to_chat(src, "You play a loud tone.")
			message = "<B>[src]</B> plays a loud tone."
			m_type = 2
		if("flash")
			message = "The lights on <B>[src]</B> flash quickly."
			m_type = 1
		if("blink")
			message = "<B>[src]</B> blinks."
			m_type = 1
		if("whistle")
			to_chat(src, "You whistle.")
			message = "<B>[src]</B> whistles."
			m_type = 2
		if("beep")
			to_chat(src, "You beep.")
			message = "<B>[src]</B> beeps."
			m_type = 2
		if("boop")
			to_chat(src, "You boop.")
			message = "<B>[src]</B> boops."
			m_type = 2
		if("help")
			to_chat(src, "<span class='filter_say'>alarm, alert, notice, flash, blink, whistle, beep, boop</span>")

	if(!stat)
		..(act, m_type, message)
		