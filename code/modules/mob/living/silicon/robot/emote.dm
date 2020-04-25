/mob/living/silicon/robot/emote(var/act,var/m_type=1,var/message = null)
	var/param = null
	if(findtext(act, "-", 1, null))
		var/t1 = findtext(act, "-", 1, null)
		param = copytext(act, t1 + 1, length(act) + 1)
		act = copytext(act, 1, t1)

	if(findtext(act,"s",-1) && !findtext(act,"_",-2))//Removes ending s's unless they are prefixed with a '_'
		act = copytext(act,1,length(act))

	switch(act)
		if("salute")
			if(!src.buckled)
				var/M = null
				if(param)
					for (var/mob/A in view(null, null))
						if(param == A.name)
							M = A
							break
				if(!M)
					param = null

				if(param)
					message = "<b>[src]</b> salutes to [param]."
				else
					message = "<b>[src]</b> salutes."
			m_type = 1
		if("bow")
			if(!src.buckled)
				var/M = null
				if(param)
					for (var/mob/A in view(null, null))
						if(param == A.name)
							M = A
							break
				if(!M)
					param = null

				if(param)
					message = "<b>[src]</b> bows to [param]."
				else
					message = "<b>[src]</b> bows."
			m_type = 1

		if("clap")
			if(!src.restrained())
				message = "<b>[src]</b> claps."
				m_type = 2
		if("flap")
			if(!src.restrained())
				message = "<b>[src]</b> flaps its wings."
				m_type = 2

		if("aflap")
			if(!src.restrained())
				message = "<b>[src]</b> flaps its wings ANGRILY!"
				m_type = 2

		if("twitch")
			message = "<b>[src]</b> twitches."
			m_type = 1

		if("twitch_v")
			message = "<b>[src]</b> twitches violently."
			m_type = 1

		if("nod")
			message = "<b>[src]</b> nods."
			m_type = 1

		if("deathgasp")
			message = "<b>[src]</b> shudders violently for a moment, then becomes motionless, its eyes slowly darkening."
			m_type = 1

		if("glare")
			var/M = null
			if(param)
				for (var/mob/A in view(null, null))
					if(param == A.name)
						M = A
						break
			if(!M)
				param = null

			if(param)
				message = "<b>[src]</b> glares at [param]."
			else
				message = "<b>[src]</b> glares."

		if("stare")
			var/M = null
			if(param)
				for (var/mob/A in view(null, null))
					if(param == A.name)
						M = A
						break
			if(!M)
				param = null

			if(param)
				message = "<b>[src]</b> stares at [param]."
			else
				message = "<b>[src]</b> stares."

		if("look")
			var/M = null
			if(param)
				for (var/mob/A in view(null, null))
					if(param == A.name)
						M = A
						break

			if(!M)
				param = null

			if(param)
				message = "<b>[src]</b> looks at [param]."
			else
				message = "<b>[src]</b> looks."
			m_type = 1

		if("law")
			if(istype(module,/obj/item/weapon/robot_module/robot/security) || istype(module,/obj/item/weapon/robot_module/robot/knine)) //VOREStation Add - K9
				message = "<b>[src]</b> shows its legal authorization barcode."

				playsound(src.loc, 'sound/voice/biamthelaw.ogg', 50, 0)
				m_type = 2
			else
				to_chat(src, "You are not THE LAW, pal.")

		if("halt")
			if(istype(module,/obj/item/weapon/robot_module/robot/security) || istype(module,/obj/item/weapon/robot_module/robot/knine)) //VOREStation Add - K9
				message = "<b>[src]</b> <B>'s</B> speakers skreech, \"Halt! Security!\"."

				playsound(src.loc, 'sound/voice/halt.ogg', 50, 0)
				m_type = 2
			else
				to_chat(src, "You are not security.")

		if("help")
			to_chat(src, "salute, bow-(none)/mob, clap, flap, aflap, twitch, twitch_s, nod, deathgasp, glare-(none)/mob, stare-(none)/mob, look, beep, ping, \nbuzz, law, halt, yes, dwoop, no")

	..(act, m_type, message)