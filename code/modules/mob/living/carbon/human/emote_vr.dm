/mob/living/carbon/human/proc/handle_emote_vr(var/act,var/m_type=1,var/message = null)

	switch(act)
		if ("vwag")
			if(toggle_tail_vr(message = 1))
				m_type = 1
				message = "[wagging ? "starts" : "stops"] wagging their tail."
			else
				return 1
		if ("vflap")
			if(toggle_wing_vr(message = 1))
				m_type = 1
				message = "[flapping ? "starts" : "stops"] flapping their wings."
			else
				return 1
		if ("mlem")
			message = "mlems [get_visible_gender() == MALE ? "his" : get_visible_gender() == FEMALE ? "her" : "their"] tongue up over [get_visible_gender() == MALE ? "his" : get_visible_gender() == FEMALE ? "her" : "their"] nose. Mlem."
			m_type = 1
		if ("awoo")
			var/mob/living/carbon/human/H = src
			var/obj/item/organ/external/L = H.get_organ("chest")
			var/obj/item/organ/external/R = H.get_organ("head")
			var/torso_good = 0
			var/head_good = 0
			if(L && (!(L.status & ORGAN_DESTROYED)) && (!(L.splinted)) && (!(L.status & ORGAN_BROKEN)))
				torso_good = 1
			if(R && (!(R.status & ORGAN_DESTROYED)) && (!(R.splinted)) && (!(R.status & ORGAN_BROKEN)))
				head_good = 1

			if(!torso_good && !head_good)
				to_chat(usr, "<span class='danger'>You need an uninjured head and chest to be obnoxious.</span>") //discourage spam by breaking one or both
				return

			m_type = 2
			message = "lets out an awoo."
			playsound(loc, 'sound/voice/awoo.ogg', 50, 1, -1)


			emoteDanger =  min(1+(emoteDanger*2), 100)
			var/danger = emoteDanger - 5//Base chance to break something.
			var/list/involved_parts = list(BP_HEAD, BP_TORSO) // why there are organ tags and organ names i will never know
			for(var/organ_name in involved_parts)
				var/obj/item/organ/external/E = get_organ(organ_name)
				if(!E || E.is_stump() || E.splinted || (E.status & ORGAN_BROKEN))
					involved_parts -= organ_name
					danger += 7 //Add 7% chance for each involved part


			if(prob(danger))
				spawn(10) //the dreaded spawn
					var/breaking = pick(involved_parts)
					var/obj/item/organ/external/E = get_organ(breaking)
					if(isSynthetic())
						src.Weaken(5)
						E.droplimb(1,DROPLIMB_EDGE)
						message += " <span class='danger'>And falls apart!</span>" //might be redundant, havent seen a synth die yet in testing
						log_and_message_admins("broke their [breaking] with *awoo and were kicked.", src)
						to_chat(usr, "<span class='danger'>You have been automatically logged out for spamming emotes.</span>")
						Logout(src)
					else
						src.Weaken(5)
						if(E.cannot_break) //Prometheans go splat
							E.droplimb(0,DROPLIMB_BLUNT)
						else
							E.fracture()
						message += " <span class='danger'>And breaks something!</span>"
						log_and_message_admins("broke their [breaking] with *awoo and were kicked.", src)
						to_chat(usr, "<span class='danger'>You have been automatically logged out for spamming emotes.</span>")
						Logout(src)
		if ("nya")
			var/mob/living/carbon/human/H = src
			var/obj/item/organ/external/L = H.get_organ("chest")
			var/obj/item/organ/external/R = H.get_organ("head")
			var/torso_good = 0
			var/head_good = 0
			if(L && (!(L.status & ORGAN_DESTROYED)) && (!(L.splinted)) && (!(L.status & ORGAN_BROKEN)))
				torso_good = 1
			if(R && (!(R.status & ORGAN_DESTROYED)) && (!(R.splinted)) && (!(R.status & ORGAN_BROKEN)))
				head_good = 1
//discourage spam by potentially breaking one or both
			if(!torso_good && !head_good)
				to_chat(usr, "<span class='danger'>You need an uninjured head and chest to be obnoxious.</span>")
				return

			message = "lets out a nya."
			m_type = 2
			playsound(loc, 'sound/voice/nya.ogg', 50, 1, -1)


			emoteDanger =  min(1+(emoteDanger*2), 100)
			var/danger = emoteDanger - 5//Base chance to break something.
			var/list/involved_parts = list(BP_HEAD, BP_TORSO) // why there are organ tags and organ names i will never know
			for(var/organ_name in involved_parts)
				var/obj/item/organ/external/E = get_organ(organ_name)
				if(!E || E.is_stump() || E.splinted || (E.status & ORGAN_BROKEN))
					involved_parts -= organ_name
					danger += 5 //Add 5% chance for each involved part


			if(prob(danger))
				spawn(10) //the dreaded spawn
					var/breaking = pick(involved_parts)
					var/obj/item/organ/external/E = get_organ(breaking)
					if(isSynthetic())
						src.Weaken(5)
						E.droplimb(1,DROPLIMB_EDGE)
						message += " <span class='danger'>And loses their [breaking]!</span>" //redundant unless a non-lethal limb is added to the parts list
						log_and_message_admins("broke their [breaking] with *nya and were kicked.", src)
						to_chat(usr, "<span class='danger'>You have been automatically logged out for spamming emotes.</span>")
						Logout(src)
					else
						src.Weaken(5)
						if(E.cannot_break) //Prometheans go splat
							E.droplimb(0,DROPLIMB_BLUNT)
						else
							E.fracture()
						message += " <span class='danger'>And breaks something!</span>"
						log_and_message_admins("broke their [breaking] with *nya and were kicked.", src)
						to_chat(usr, "<span class='danger'>You have been automatically logged out for spamming emotes.</span>")
						Logout(src)
		if ("peep")
			message = "peeps like a bird."
			m_type = 2
			playsound(loc, 'sound/voice/peep.ogg', 50, 1, -1)
		if("chirp")
			message = "chirps!"
			playsound(src.loc, 'sound/misc/nymphchirp.ogg', 50, 0)
			m_type = 2
		if ("weh")
			message = "lets out a weh."
			m_type = 2
			playsound(loc, 'sound/voice/weh.ogg', 50, 1, -1)
		if ("merp")
			message = "lets out a merp."
			m_type = 2
			playsound(loc, 'sound/voice/merp.ogg', 50, 1, -1)
		if ("bark")
			message = "lets out a bark."
			m_type = 2
			playsound(loc, 'sound/voice/bark2.ogg', 50, 1, -1)
		if ("his")
			message = "lets out a hiss."
			m_type = 2
			playsound(loc, 'sound/voice/hiss.ogg', 50, 1, -1)
		if ("nsay")
			nsay()
			return TRUE
		if ("nme")
			nme()
			return TRUE
		if ("flip")
			var/danger = 1 //Base 1% chance to break something.
			var/list/involved_parts = list(BP_L_LEG, BP_R_LEG, BP_L_FOOT, BP_R_FOOT)
			for(var/organ_name in involved_parts)
				var/obj/item/organ/external/E = get_organ(organ_name)
				if(!E || E.is_stump() || E.splinted || (E.status & ORGAN_BROKEN))
					involved_parts -= organ_name
					danger += 5 //Add 5% to the chance for each problem limb

			//Taurs are harder to flip
			if(istype(tail_style, /datum/sprite_accessory/tail/taur))
				danger += 1

			//Check if they are physically capable
			if(src.sleeping || src.resting || src.buckled || src.weakened || src.restrained() || involved_parts.len < 2)
				src << "<span class='warning'>You can't *flip in your current state!</span>"
				return 1
			else
				src.SpinAnimation(7,1)
				message = "does a flip!"
				m_type = 1

				if(prob(danger))
					spawn(10) //Stick the landing.
						var/breaking = pick(involved_parts)
						var/obj/item/organ/external/E = get_organ(breaking)
						if(isSynthetic())
							src.Weaken(5)
							E.droplimb(1,DROPLIMB_EDGE)
							message += " <span class='danger'>And loses a limb!</span>"
							log_and_message_admins("lost their [breaking] with *flip, ahahah.", src)
						else
							src.Weaken(5)
							if(E.cannot_break) //Prometheans go splat
								E.droplimb(0,DROPLIMB_BLUNT)
							else
								E.fracture()
							message += " <span class='danger'>And breaks something!</span>"
							log_and_message_admins("broke their [breaking] with *flip, ahahah.", src)

	if (message)
		custom_emote(m_type,message)
		return 1

	return 0

/mob/living/carbon/human/proc/toggle_tail_vr(var/setting,var/message = 0)
	if(!tail_style || !tail_style.ani_state)
		if(message)
			src << "<span class='warning'>You don't have a tail that supports this.</span>"
		return 0

	var/new_wagging = isnull(setting) ? !wagging : setting
	if(new_wagging != wagging)
		wagging = new_wagging
		update_tail_showing()
	return 1

/mob/living/carbon/human/proc/toggle_wing_vr(var/setting,var/message = 0)
	if(!wing_style || !wing_style.ani_state)
		if(message)
			src << "<span class='warning'>You don't have a tail that supports this.</span>"
		return 0

	var/new_flapping = isnull(setting) ? !flapping : setting
	if(new_flapping != flapping)
		flapping = setting
		update_wing_showing()
	return 1

/mob/living/carbon/human/verb/toggle_gender_identity_vr()
	set name = "Set Gender Identity"
	set desc = "Sets the pronouns when examined and performing an emote."
	set category = "IC"
	var/new_gender_identity = input("Please select a gender Identity.") as null|anything in list(FEMALE, MALE, NEUTER, PLURAL, HERM)
	if(!new_gender_identity)
		return 0
	change_gender_identity(new_gender_identity)
	return 1

/mob/living/carbon/human/verb/switch_tail_layer()
	set name = "Switch tail layer"
	set category = "IC"
	set desc = "Switch tail layer on top."
	tail_alt = !tail_alt
	update_tail_showing()
