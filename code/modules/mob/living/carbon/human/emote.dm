/mob/living/carbon/human/emote(var/act,var/m_type=1,var/message = null)
	var/param = null

	var/datum/gender/T = gender_datums[get_visible_gender()]

	if(findtext(act, "-", 1, null))
		var/t1 = findtext(act, "-", 1, null)
		param = copytext(act, t1 + 1, length(act) + 1)
		act = copytext(act, 1, t1)

	var/muzzled = is_muzzled()
	//var/m_type = 1

	for(var/obj/item/organ/O in organs)
		for(var/obj/item/weapon/implant/I in O)
			if(I.implanted)
				I.trigger(act, src)

	if(stat == DEAD && (act != "deathgasp"))
		return

	if(attempt_vr(src, "handle_emote_vr", list(act, m_type, message))) return //VOREStation Add - Custom Emote Handler

	switch(act)
		if("airguitar")
			if(!restrained())
				message = "is strumming the air and headbanging like a safari chimp."
				m_type = 1

		//Machine-only emotes
		if("ping", "beep", "buzz", "yes", "ye", "dwoop", "no", "rcough", "rsneeze")

			if(!isSynthetic())
				to_chat(src, "<span class='warning'>You are not a synthetic.</span>")
				return

			var/M = null
			if(param)
				for(var/mob/A in view(null, null))
					if(param == A.name)
						M = A
						break
			if(!M)
				param = null

			var/display_msg = "beeps"
			var/use_sound = 'sound/machines/twobeep.ogg'
			if(act == "buzz")
				display_msg = "buzzes"
				use_sound = 'sound/machines/buzz-sigh.ogg'
			else if(act == "ping")
				display_msg = "pings"
				use_sound = 'sound/machines/ping.ogg'
			else if(act == "yes" || act == "ye")
				display_msg = "emits an affirmative blip"
				use_sound = 'sound/machines/synth_yes.ogg'
			else if(act == "dwoop")
				display_msg = "chirps happily"
				use_sound = 'sound/machines/dwoop.ogg'
			else if(act == "no")
				display_msg = "emits a negative blip"
				use_sound = 'sound/machines/synth_no.ogg'
			else if(act == "rcough")
				display_msg = "emits a robotic cough"
				if(get_gender() == FEMALE)
					use_sound = pick('sound/effects/mob_effects/f_machine_cougha.ogg','sound/effects/mob_effects/f_machine_coughb.ogg')
				else
					use_sound = pick('sound/effects/mob_effects/m_machine_cougha.ogg','sound/effects/mob_effects/m_machine_coughb.ogg', 'sound/effects/mob_effects/m_machine_coughc.ogg')
			else if(act == "rsneeze")
				display_msg = "emits a robotic sneeze"
				if(get_gender() == FEMALE)
					use_sound = 'sound/effects/mob_effects/machine_sneeze.ogg'
				else
					use_sound = 'sound/effects/mob_effects/f_machine_sneeze.ogg'

			if(param)
				message = "[display_msg] at [param]."
			else
				message = "[display_msg]."
			playsound(src, use_sound, 50, 0, preference = /datum/client_preference/emote_noises) //VOREStation Add
			m_type = 1

		//Promethean-only emotes
		if("squish")
			/* VOREStation Removal Start - Eh. People can squish maybe.
			if(species.bump_flag != SLIME) //This should definitely do it.
				to_chat(src, "<span class='warning'>You are not a slime thing!</span>")
				return
			*/ //VOREStation Removal End
			playsound(src, 'sound/effects/slime_squish.ogg', 50, 0, preference = /datum/client_preference/emote_noises) //VOREStation Add //Credit to DrMinky (freesound.org) for the sound.
			message = "squishes."
			m_type = 1

		//Skrell-only emotes
		if("warble")
			if(species.name != SPECIES_SKRELL)
				to_chat(src, "<span class='warning'>You are not a Skrell!</span>")
				return

			playsound(src, 'sound/effects/warble.ogg', 50, 0, preference = /datum/client_preference/emote_noises) //VOREStation Add // Copyright CC BY 3.0 alienistcog (freesound.org) for the sound.
			message = "warbles."
			m_type = 2

		if("blink")
			message = "blinks."
			m_type = 1

		if("blink_r")
			message = "blinks rapidly."
			m_type = 1

		if("bow")
			if(!buckled)
				var/M = null
				if(param)
					for(var/mob/A in view(null, null))
						if(param == A.name)
							M = A
							break
				if(!M)
					param = null

				if(param)
					message = "bows to [param]."
				else
					message = "bows."
			m_type = 1

		if("custom")
			var/input = sanitize(input("Choose an emote to display.") as text|null)
			if(!input)
				return
			var/input2 = input("Is this a visible or hearable emote?") in list("Visible","Hearable")
			if(input2 == "Visible")
				m_type = 1
			else if(input2 == "Hearable")
				if(miming)
					return
				m_type = 2
			else
				alert("Unable to use this emote, must be either hearable or visible.")
				return
			return custom_emote(m_type, input)

		if("me")

			//if(silent && silent > 0 && findtext(message,"\"",1, null) > 0)
			//	return //This check does not work and I have no idea why, I'm leaving it in for reference.

			if(client)
				if(client.prefs.muted & MUTE_IC)
					to_chat(src, "<font color='red'>You cannot send IC messages (muted).</font>")
					return
			if(stat)
				return
			if(!(message))
				return
			return custom_emote(m_type, message)

		if("salute")
			if(!buckled)
				var/M = null
				if(param)
					for(var/mob/A in view(null, null))
						if(param == A.name)
							M = A
							break
				if(!M)
					param = null

				if(param)
					message = "salutes to [param]."
				else
					message = "salutes."
			m_type = 1

		if("choke")
			if(miming)
				message = "clutches [T.his] throat desperately!"
				m_type = 1
			else
				if(!muzzled)
					message = "chokes!"
					m_type = 2
				else
					message = "makes a strong noise."
					m_type = 2

		if("clap")
			if(!restrained())
				message = "claps."
				playsound(src, 'sound/misc/clapping.ogg')
				m_type = 2
				if(miming)
					m_type = 1

		if("flap")
			if(!restrained())
				message = "flaps [T.his] wings."
				m_type = 2
				if(miming)
					m_type = 1

		if("aflap")
			if(!restrained())
				message = "flaps [T.his] wings ANGRILY!"
				m_type = 2
				if(miming)
					m_type = 1

		if("drool")
			message = "drools."
			m_type = 1

		if("eyebrow")
			message = "raises an eyebrow."
			m_type = 1

		if("chuckle")
			if(miming)
				message = "appears to chuckle."
				m_type = 1
			else
				if(!muzzled)
					message = "chuckles."
					m_type = 2
				else
					message = "makes a noise."
					m_type = 2

		if("twitch")
			message = "twitches."
			m_type = 1

		if("twitch_v")
			message = "twitches violently."
			m_type = 1

		if("faint")
			message = "faints."
			if(sleeping)
				return //Can't faint while asleep
			Sleeping(10)
			m_type = 1

		if("cough", "coughs")
			if(miming)
				message = "appears to cough!"
				m_type = 1
			else
				if(!muzzled)
					var/robotic = 0
					m_type = 2
					if(should_have_organ(O_LUNGS))
						var/obj/item/organ/internal/lungs/L = internal_organs_by_name[O_LUNGS]
						if(L && L.robotic == 2)	//Hard-coded to 2, incase we add lifelike robotic lungs
							robotic = 1
					if(!robotic && !isSynthetic())
						message = "coughs!"
						if(get_gender() == FEMALE)
							if(species.female_cough_sounds)
								playsound(src, pick(species.female_cough_sounds), 120, preference = /datum/client_preference/emote_noises) //VOREStation Add
						else
							if(species.male_cough_sounds)
								playsound(src, pick(species.male_cough_sounds), 120, preference = /datum/client_preference/emote_noises) //VOREStation Add
					else
						message = "emits a robotic cough"
						var/use_sound
						if(get_gender() == FEMALE)
							use_sound = pick('sound/effects/mob_effects/f_machine_cougha.ogg','sound/effects/mob_effects/f_machine_coughb.ogg')
						else
							use_sound = pick('sound/effects/mob_effects/m_machine_cougha.ogg','sound/effects/mob_effects/m_machine_coughb.ogg', 'sound/effects/mob_effects/m_machine_coughc.ogg')
						playsound(src, use_sound, 50, 0, preference = /datum/client_preference/emote_noises) //VOREStation Add
				else
					message = "makes a strong noise."
					m_type = 2

		if("frown")
			message = "frowns."
			m_type = 1

		if("nod")
			message = "nods."
			m_type = 1

		if("blush")
			message = "blushes."
			m_type = 1

		if("wave")
			message = "waves."
			m_type = 1

		if("gasp")
			if(miming)
				message = "appears to be gasping!"
				m_type = 1
			else
				if(!muzzled)
					message = "gasps!"
					m_type = 2
				else
					message = "makes a weak noise."
					m_type = 2

		if("deathgasp")
			message = "[species.get_death_message()]"
			m_type = 1

		if("giggle")
			if(miming)
				message = "giggles silently!"
				m_type = 1
			else
				if(!muzzled)
					message = "giggles."
					m_type = 2
				else
					message = "makes a noise."
					m_type = 2

		if("glare")
			var/M = null
			if(param)
				for(var/mob/A in view(null, null))
					if(param == A.name)
						M = A
						break
			if(!M)
				param = null

			if(param)
				message = "glares at [param]."
			else
				message = "glares."

		if("stare")
			var/M = null
			if(param)
				for(var/mob/A in view(null, null))
					if(param == A.name)
						M = A
						break
			if(!M)
				param = null

			if(param)
				message = "stares at [param]."
			else
				message = "stares."

		if("look")
			var/M = null
			if(param)
				for(var/mob/A in view(null, null))
					if(param == A.name)
						M = A
						break

			if(!M)
				param = null

			if(param)
				message = "looks at [param]."
			else
				message = "looks."
			m_type = 1

		if("grin")
			message = "grins."
			m_type = 1

		if("cry")
			if(miming)
				message = "cries."
				m_type = 1
			else
				if(!muzzled)
					message = "cries."
					m_type = 2
				else
					message = "makes a weak noise. [T.he] [get_visible_gender() == NEUTER ? "frown" : "frowns"]." // no good, non-unwieldy alternative to this ternary at the moment
					m_type = 2

		if("sigh")
			if(miming)
				message = "sighs."
				m_type = 1
			else
				if(!muzzled)
					message = "sighs."
					m_type = 2
				else
					message = "makes a weak noise."
					m_type = 2

		if("laugh")
			if(miming)
				message = "acts out a laugh."
				m_type = 1
			else
				if(!muzzled)
					message = "laughs."
					m_type = 2
				else
					message = "makes a noise."
					m_type = 2

		if("mumble")
			message = "mumbles!"
			m_type = 2
			if(miming)
				m_type = 1

		if("grumble")
			if(miming)
				message = "grumbles!"
				m_type = 1
			if(!muzzled)
				message = "grumbles!"
				m_type = 2
			else
				message = "makes a noise."
				m_type = 2

		if("groan")
			if(miming)
				message = "appears to groan!"
				m_type = 1
			else
				if(!muzzled)
					message = "groans!"
					m_type = 2
				else
					message = "makes a loud noise."
					m_type = 2

		if("moan")
			if(miming)
				message = "appears to moan!"
				m_type = 1
			else
				message = "moans!"
				m_type = 2

		if("johnny")
			var/M
			if(param)
				M = param
			if(!M)
				param = null
			else
				if(miming)
					message = "takes a drag from a cigarette and blows \"[M]\" out in smoke."
					m_type = 1
				else
					message = "says, \"[M], please. He had a family.\" [name] takes a drag from a cigarette and blows his name out in smoke."
					m_type = 2

		if("point")
			if(!restrained())
				var/mob/M = null
				if(param)
					for(var/atom/A as mob|obj|turf|area in view(null, null))
						if(param == A.name)
							M = A
							break

				if(!M)
					message = "points."
				else
					pointed(M)

				if(M)
					message = "points to [M]."
				else
			m_type = 1
			
		if("crack")
			if(!restrained())
				message = "cracks [T.his] knuckles."
				playsound(src, 'sound/voice/knuckles.ogg', 50, 1, preference = /datum/client_preference/emote_noises)
				m_type = 1

		if("raise")
			if(!restrained())
				message = "raises a hand."
			m_type = 1

		if("shake")
			message = "shakes [T.his] head."
			m_type = 1

		if("shrug")
			message = "shrugs."
			m_type = 1

		if("signal")
			if(!restrained())
				var/t1 = round(text2num(param))
				if(isnum(t1))
					if(t1 <= 5 && (!r_hand || !l_hand))
						message = "raises [t1] finger\s."
					else if(t1 <= 10 && (!r_hand && !l_hand))
						message = "raises [t1] finger\s."
			m_type = 1

		if("smile")
			message = "smiles."
			m_type = 1

		if("shiver")
			message = "shivers."
			m_type = 2
			if(miming)
				m_type = 1

		if("pale")
			message = "goes pale for a second."
			m_type = 1

		if("tremble")
			message = "trembles in fear!"
			m_type = 1

		if("sneeze", "sneezes")
			if(miming)
				message = "sneezes."
				m_type = 1
			else
				if(!muzzled)
					var/robotic = 0
					m_type = 2
					if(should_have_organ(O_LUNGS))
						var/obj/item/organ/internal/lungs/L = internal_organs_by_name[O_LUNGS]
						if(L && L.robotic == 2)	//Hard-coded to 2, incase we add lifelike robotic lungs
							robotic = 1
					if(!robotic && !isSynthetic())
						message = "sneezes."
						if(get_gender() == FEMALE)
							playsound(src, species.female_sneeze_sound, 70, preference = /datum/client_preference/emote_noises) //VOREStation Add
						else
							playsound(src, species.male_sneeze_sound, 70, preference = /datum/client_preference/emote_noises) //VOREStation Add
						m_type = 2
					else
						message = "emits a robotic sneeze"
						var/use_sound
						if(get_gender() == FEMALE)
							use_sound = 'sound/effects/mob_effects/machine_sneeze.ogg'
						else
							use_sound = 'sound/effects/mob_effects/f_machine_sneeze.ogg'
						playsound(src, use_sound, 50, 0, preference = /datum/client_preference/emote_noises) //VOREStation Add
				else
					message = "makes a strange noise."
					m_type = 2

		if("sniff")
			message = "sniffs."
			m_type = 2
			if(miming)
				m_type = 1

		if("snore")
			if(miming)
				message = "sleeps soundly."
				m_type = 1
			else
				if(!muzzled)
					message = "snores."
					m_type = 2
				else
					message = "makes a noise."
					m_type = 2

		if("whimper")
			if(miming)
				message = "appears hurt."
				m_type = 1
			else
				if(!muzzled)
					message = "whimpers."
					m_type = 2
				else
					message = "makes a weak noise."
					m_type = 2

		if("wink")
			message = "winks."
			m_type = 1

		if("yawn")
			if(!muzzled)
				message = "yawns."
				m_type = 2
				if(miming)
					m_type = 1

		if("collapse")
			Paralyse(2)
			message = "collapses!"
			m_type = 2
			if(miming)
				m_type = 1

		if("hug")
			m_type = 1
			if(!restrained())
				var/M = null
				if(param)
					for(var/mob/A in view(1, null))
						if(param == A.name)
							M = A
							break
				if(M == src)
					M = null

				if(M)
					message = "hugs [M]."
				else
					message = "hugs [T.himself]."

		if("handshake")
			m_type = 1
			if(!restrained() && !r_hand)
				var/mob/living/M = null
				if(param)
					for(var/mob/living/A in view(1, null))
						if(param == A.name)
							M = A
							break
				if(M == src)
					M = null

				if(M)
					if(M.canmove && !M.r_hand && !M.restrained())
						message = "shakes hands with [M]."
					else
						message = "holds out [T.his] hand to [M]."

		if("dap")
			m_type = 1
			if(!restrained())
				var/M = null
				if(param)
					for(var/mob/A in view(1, null))
						if(param == A.name)
							M = A
							break
				if(M)
					message = "gives daps to [M]."
				else
					message = "sadly can't find anybody to give daps to, and daps [T.himself]. Shameful."

		if("slap", "slaps")
			m_type = 1
			if(!restrained())
				var/M = null
				if(param)
					for(var/mob/A in view(1, null))
						if(param == A.name)
							M = A
							break
				if(M)
					message = "<span class='danger'>slaps [M] across the face. Ouch!</span>"
					playsound(src, 'sound/effects/snap.ogg', 50, 1, preference = /datum/client_preference/emote_noises) //VOREStation Add
					if(ishuman(M)) //Snowflakey!
						var/mob/living/carbon/human/H = M
						if(istype(H.wear_mask,/obj/item/clothing/mask/smokable))
							H.drop_from_inventory(H.wear_mask)
				else
					message = "<span class='danger'>slaps [T.himself]!</span>"
					playsound(src, 'sound/effects/snap.ogg', 50, 1, preference = /datum/client_preference/emote_noises) //VOREStation Add

		if("scream", "screams")
			if(miming)
				message = "acts out a scream!"
				m_type = 1
			else
				if(!muzzled)
					message = "[species.scream_verb]!"
					m_type = 2
					/* Removed, pending the location of some actually good, properly licensed sounds.
					if(get_gender() == FEMALE)
						playsound(src, "[species.female_scream_sound]", 80, 1)
					else
						playsound(src, "[species.male_scream_sound]", 80, 1) //default to male screams if no gender is present.
					*/
				else
					message = "makes a very loud noise."
					m_type = 2

		if("snap", "snaps")
			m_type = 2
			var/mob/living/carbon/human/H = src
			var/obj/item/organ/external/L = H.get_organ("l_hand")
			var/obj/item/organ/external/R = H.get_organ("r_hand")
			var/left_hand_good = 0
			var/right_hand_good = 0
			if(L && (!(L.status & ORGAN_DESTROYED)) && (!(L.splinted)) && (!(L.status & ORGAN_BROKEN)))
				left_hand_good = 1
			if(R && (!(R.status & ORGAN_DESTROYED)) && (!(R.splinted)) && (!(R.status & ORGAN_BROKEN)))
				right_hand_good = 1

			if(!left_hand_good && !right_hand_good)
				to_chat(usr, "You need at least one hand in good working order to snap your fingers.")
				return

			message = "snaps [T.his] fingers."
			playsound(src, 'sound/effects/fingersnap.ogg', 50, 1, -3, preference = /datum/client_preference/emote_noises) //VOREStation Add

		if("swish")
			animate_tail_once()

		if("wag", "sway")
			animate_tail_start()

		if("qwag", "fastsway")
			animate_tail_fast()

		if("swag", "stopsway")
			animate_tail_stop()

		if("vomit")
			if(isSynthetic())
				to_chat(src, "<span class='warning'>You are unable to vomit.</span>")
				return
			vomit()
			return

		if("whistle" || "whistles")
			if(!muzzled)
				if(!isSynthetic())
					message = "whistles a tune."
					playsound(src, 'sound/voice/longwhistle.ogg', 50, 1, preference = /datum/client_preference/emote_noises) //praying this doesn't get abused
				else
					message = "whistles a robotic tune."
					playsound(src, 'sound/voice/longwhistle_robot.ogg', 50, 1, preference = /datum/client_preference/emote_noises)
			else
				message = "makes a light spitting noise, a poor attempt at a whistle."

		if("qwhistle")
			if(!muzzled)
				if(!isSynthetic())
					message = "whistles quietly."
					playsound(src, 'sound/voice/shortwhistle.ogg', 50, 1, preference = /datum/client_preference/emote_noises)
				else
					message = "whistles robotically."
					playsound(src, 'sound/voice/shortwhistle_robot.ogg', 50, 1, preference = /datum/client_preference/emote_noises)
			else
				message = "makes a light spitting noise, a poor attempt at a whistle."

		if("wwhistle")
			if(!muzzled)
				if(!isSynthetic())
					message = "whistles inappropriately."
					playsound(src, 'sound/voice/wolfwhistle.ogg', 50, 1, preference = /datum/client_preference/emote_noises)
				else
					message = "beeps inappropriately."
					playsound(src, 'sound/voice/wolfwhistle_robot.ogg', 50, 1, preference = /datum/client_preference/emote_noises)
			else
				message = "makes a light spitting noise, a poor attempt at a whistle."

		if("swhistle")
			if(!muzzled)
				if(!isSynthetic())
					message = "summon whistles."
					playsound(src, 'sound/voice/summon_whistle.ogg', 50, 1, preference = /datum/client_preference/emote_noises)
				else
					message = "summon whistles robotically."
					playsound(src, 'sound/voice/summon_whistle_robot.ogg', 50, 1, preference = /datum/client_preference/emote_noises)
			else
				message = "makes a light spitting noise, a poor attempt at a whistle."

		if("flip")
			m_type = 1
			if (!src.restrained())
				//message = "performs an amazing, gravity-defying backflip before landing skillfully back to the ground."
				playsound(src.loc, 'sound/effects/bodyfall4.ogg', 50, 1)
				src.SpinAnimation(7,1)
			else
				to_chat(usr, "You can't quite do something as difficult as a backflip while so... restricted.")

		if("spin")
			m_type = 1
			if (!src.restrained())
				//message = "spins in a dance smoothly on their feet. Wow!"
				src.spin(20, 1)
			else
				to_chat(usr, "You can't quite do something as difficult as a spin while so... restricted.")

		if("floorspin")
			m_type = 1
			if (!src.restrained())
				//message = "gets down on the floor and spins their entire body around!"
				spawn(0)
					for(var/i in list(1,2,4,8,4,2,1,2,4,8,4,2,1,2,4,8,4,2))
						set_dir(i)
						sleep(1)
				src.SpinAnimation(20,1)
			else
				to_chat(usr, "You can't quite do something as difficult as a spin while so... restricted.")

		if("sidestep")
			m_type = 1
			if (!src.restrained())
				//message = "steps rhymatically and conservatively as they move side to side."
				playsound(src.loc, 'sound/effects/bodyfall4.ogg', 50, 1)
				var/default_pixel_x = initial(pixel_x)
				var/default_pixel_y = initial(pixel_y)
				default_pixel_x = src.default_pixel_x
				default_pixel_y = src.default_pixel_y

				animate(src, pixel_x = 5, time = 20)
				sleep(3)
				animate(src, pixel_x = -5, time = 20)
				animate(pixel_x = default_pixel_x, pixel_y = default_pixel_y, time = 2)
			else
				to_chat(usr, "Sidestepping sure seems unachieveable when you're this restricted.")

		if("help")
			to_chat(src, "<span class='filter_say'>blink, blink_r, blush, bow-(none)/mob, burp, choke, chuckle, clap, collapse, cough, cry, custom, deathgasp, drool, eyebrow, fastsway/qwag, \
					frown, gasp, giggle, glare-(none)/mob, grin, groan, grumble, handshake, hug-(none)/mob, laugh, look-(none)/mob, moan, mumble, nod, pale, point-atom, \
					qwhistle, raise, salute, scream, sneeze, shake, shiver, shrug, sigh, signal-#1-10, slap-(none)/mob, smile, sneeze, sniff, snore, stare-(none)/mob, stopsway/swag, sway/wag, swish, swhistle, \
					tremble, twitch, twitch_v, vomit, whimper, wink, whistle, wwhistle, yawn. Prometheans: squish Synthetics: beep, buzz, dwoop, yes, no, rcough, rsneeze, ping. Skrell: warble</span>")

		else
			to_chat(src, "<span class='filter_say'><font color='blue'>Unusable emote '[act]'. Say *help or *vhelp for a list.</font></span>") //VOREStation Edit, mention *vhelp for Virgo-specific emotes located in emote_vr.dm.

	if(message)
		custom_emote(m_type,message)

/mob/living/carbon/human/verb/pose()
	set name = "Set Pose"
	set desc = "Sets a description which will be shown when someone examines you."
	set category = "IC"

	var/datum/gender/T = gender_datums[get_visible_gender()]

	pose = sanitize(input(usr, "This is [src]. [T.he]...", "Pose", null)  as text)

/mob/living/carbon/human/verb/set_flavor()
	set name = "Set Flavour Text"
	set desc = "Sets an extended description of your character's features."
	set category = "IC"

	var/HTML = "<body>"
	HTML += "<tt><center>"
	HTML += "<b>Update Flavour Text</b> <hr />"
	HTML += "<br></center>"
	HTML += "<a href='byond://?src=\ref[src];flavor_change=general'>General:</a> "
	HTML += TextPreview(flavor_texts["general"])
	HTML += "<br>"
	HTML += "<a href='byond://?src=\ref[src];flavor_change=head'>Head:</a> "
	HTML += TextPreview(flavor_texts["head"])
	HTML += "<br>"
	HTML += "<a href='byond://?src=\ref[src];flavor_change=face'>Face:</a> "
	HTML += TextPreview(flavor_texts["face"])
	HTML += "<br>"
	HTML += "<a href='byond://?src=\ref[src];flavor_change=eyes'>Eyes:</a> "
	HTML += TextPreview(flavor_texts["eyes"])
	HTML += "<br>"
	HTML += "<a href='byond://?src=\ref[src];flavor_change=torso'>Body:</a> "
	HTML += TextPreview(flavor_texts["torso"])
	HTML += "<br>"
	HTML += "<a href='byond://?src=\ref[src];flavor_change=arms'>Arms:</a> "
	HTML += TextPreview(flavor_texts["arms"])
	HTML += "<br>"
	HTML += "<a href='byond://?src=\ref[src];flavor_change=hands'>Hands:</a> "
	HTML += TextPreview(flavor_texts["hands"])
	HTML += "<br>"
	HTML += "<a href='byond://?src=\ref[src];flavor_change=legs'>Legs:</a> "
	HTML += TextPreview(flavor_texts["legs"])
	HTML += "<br>"
	HTML += "<a href='byond://?src=\ref[src];flavor_change=feet'>Feet:</a> "
	HTML += TextPreview(flavor_texts["feet"])
	HTML += "<br>"
	HTML += "<hr />"
	HTML +="<a href='?src=\ref[src];flavor_change=done'>\[Done\]</a>"
	HTML += "<tt>"
	src << browse(HTML, "window=flavor_changes;size=430x300")
