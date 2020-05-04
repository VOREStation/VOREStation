/mob
	var/nextemote = 1

/mob/living/carbon/human/proc/handle_emote_vr(var/act,var/m_type=1,var/message = null)
	//Reduces emote spamming
	if(nextemote >= world.time)// || user.stat != CONSCIOUS
		return 1
	nextemote = world.time + 12

	switch(act)
		if("vwag")
			if(toggle_tail_vr(message = 1))
				m_type = 1
				message = "[wagging ? "starts" : "stops"] wagging their tail."
			else
				return 1
		if("vflap")
			if(toggle_wing_vr(message = 1))
				m_type = 1
				message = "[flapping ? "starts" : "stops"] flapping their wings."
			else
				return 1
		if("mlem")
			message = "mlems [get_visible_gender() == MALE ? "his" : get_visible_gender() == FEMALE ? "her" : "their"] tongue up over [get_visible_gender() == MALE ? "his" : get_visible_gender() == FEMALE ? "her" : "their"] nose. Mlem."
			m_type = 1
		if("awoo")
			m_type = 2
			message = "lets out an awoo."
			playsound(loc, 'sound/voice/awoo.ogg', 50, 1, -1, preference = /datum/client_preference/emote_noises)
		if("nya")
			message = "lets out a nya."
			m_type = 2
			playsound(loc, 'sound/voice/nya.ogg', 50, 1, -1, preference = /datum/client_preference/emote_noises)
		if("peep")
			message = "peeps like a bird."
			m_type = 2
			playsound(loc, 'sound/voice/peep.ogg', 50, 1, -1, preference = /datum/client_preference/emote_noises)
		if("chirp")
			message = "chirps!"
			playsound(loc, 'sound/misc/nymphchirp.ogg', 50, 0, preference = /datum/client_preference/emote_noises)
			m_type = 2
		if("weh")
			message = "lets out a weh."
			m_type = 2
			playsound(loc, 'sound/voice/weh.ogg', 50, 1, -1, preference = /datum/client_preference/emote_noises)
		if("merp")
			message = "lets out a merp."
			m_type = 2
			playsound(loc, 'sound/voice/merp.ogg', 50, 1, -1, preference = /datum/client_preference/emote_noises)
		if("myarp")
			message = "lets out a myarp."
			m_type = 2
			playsound(loc, 'sound/voice/myarp.ogg', 50, 1, -1, preference = /datum/client_preference/emote_noises)
		if("bark")
			message = "lets out a bark."
			m_type = 2
			playsound(loc, 'sound/voice/bark2.ogg', 50, 1, -1, preference = /datum/client_preference/emote_noises)
		if("hiss")
			message = "lets out a hiss."
			m_type = 2
			playsound(loc, 'sound/voice/hiss.ogg', 50, 1, -1, preference = /datum/client_preference/emote_noises)
		if("squeak")
			message = "lets out a squeak."
			m_type = 2
			playsound(loc, 'sound/effects/mouse_squeak.ogg', 50, 1, -1, preference = /datum/client_preference/emote_noises)
		if("nsay")
			nsay()
			return TRUE
		if("nme")
			nme()
			return TRUE
		if("flip")
			var/list/involved_parts = list(BP_L_LEG, BP_R_LEG, BP_L_FOOT, BP_R_FOOT)
			//Check if they are physically capable
			if(sleeping || resting || buckled || weakened || restrained() || involved_parts.len < 2)
				to_chat(src, "<span class='warning'>You can't *flip in your current state!</span>")
				return 1
			else
				nextemote += 12 //Double delay
				handle_flip_vr()
				message = "does a flip!"
				m_type = 1
		if("vhelp") //Help for Virgo-specific emotes.
			to_chat(src, "vwag, vflap, mlem, awoo, nya, peep, chirp, weh, merp, myarp, bark, hiss, squeak, nsay, nme, flip")
			return TRUE

	if(message)
		custom_emote(m_type,message)
		return TRUE

	return FALSE


/mob/living/carbon/human/proc/handle_flip_vr()
	var/original_density = density
	var/original_passflags = pass_flags

	//Briefly un-dense to dodge projectiles
	density = FALSE

	//Parkour!
	var/parkour_chance = 20 //Default
	if(species)
		parkour_chance = species.agility
	if(prob(parkour_chance))
		pass_flags |= PASSTABLE
	else
		Confuse(1) //Thud

	if(dir & WEST)
		SpinAnimation(7,1,0)
	else
		SpinAnimation(7,1,1)

	spawn(7)
		density = original_density
		pass_flags = original_passflags

/mob/living/carbon/human/proc/toggle_tail_vr(var/setting,var/message = 0)
	if(!tail_style || !tail_style.ani_state)
		if(message)
			to_chat(src, "<span class='warning'>You don't have a tail that supports this.</span>")
		return 0

	var/new_wagging = isnull(setting) ? !wagging : setting
	if(new_wagging != wagging)
		wagging = new_wagging
		update_tail_showing()
	return 1

/mob/living/carbon/human/proc/toggle_wing_vr(var/setting,var/message = 0)
	if(!wing_style || !wing_style.ani_state)
		if(message)
			to_chat(src, "<span class='warning'>You don't have a tail that supports this.</span>")
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
