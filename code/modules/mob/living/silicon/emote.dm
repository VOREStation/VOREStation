/mob/living/silicon/emote(var/act, var/m_type = 1,var/message = null)
	var/param = null
	if(findtext(act, "-", 1, null))
		var/t1 = findtext(act, "-", 1, null)
		param = copytext(act, t1 + 1, length(act) + 1)
		act = copytext(act, 1, t1)

	if(findtext(act, "s", -1) && !findtext(act, "_", -2))//Removes ending s's unless they are prefixed with a '_'
		act = copytext(act, 1, length(act))

	switch(act)
		if("beep")
			var/M = null
			if(param)
				for (var/mob/A in view(null, null))
					if (param == A.name)
						M = A
						break
			if(!M)
				param = null

			if (param)
				message = "<b>[src]</b> beeps at [param]."
			else
				message = "<b>[src]</b> beeps."
			playsound(src, 'sound/machines/twobeep.ogg', 50, 0)
			m_type = 1

		if("ping")
			var/M = null
			if(param)
				for (var/mob/A in view(null, null))
					if (param == A.name)
						M = A
						break
			if(!M)
				param = null

			if (param)
				message = "<b>[src]</b> pings at [param]."
			else
				message = "<b>[src]</b> pings."
			playsound(src, 'sound/machines/ping.ogg', 50, 0)
			m_type = 1

		if("buzz")
			var/M = null
			if(param)
				for (var/mob/A in view(null, null))
					if (param == A.name)
						M = A
						break
			if(!M)
				param = null

			if (param)
				message = "<b>[src]</b> buzzes at [param]."
			else
				message = "<b>[src]</b> buzzes."
			playsound(src, 'sound/machines/buzz-sigh.ogg', 50, 0)
			m_type = 1

		if("yes", "ye")
			var/M = null
			if(param)
				for (var/mob/A in view(null, null))
					if (param == A.name)
						M = A
						break
			if(!M)
				param = null

			if (param)
				message = "<b>[src]</b> emits an affirmative blip at [param]."
			else
				message = "<b>[src]</b> emits an affirmative blip."
			playsound(src, 'sound/machines/synth_yes.ogg', 50, 0)
			m_type = 1

		if("dwoop")
			var/M = null
			if(param)
				for (var/mob/A in view(null, null))
					M = A
					break
			if(!M)
				param = null

			if (param)
				message = "<b>[src]</b> chirps happily at [param]"
			else
				message = "<b>[src]</b> chirps happily."
			playsound(src, 'sound/machines/dwoop.ogg', 50, 0)
			m_type = 1

		if("no")
			var/M = null
			if(param)
				for (var/mob/A in view(null, null))
					if (param == A.name)
						M = A
						break
			if(!M)
				param = null

			if (param)
				message = "<b>[src]</b> emits a negative blip at [param]."
			else
				message = "<b>[src]</b> emits a negative blip."
			playsound(src, 'sound/machines/synth_no.ogg', 50, 0)
			m_type = 1

	..(act, m_type, message)