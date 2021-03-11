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
		if("blep")
			message = "bleps [get_visible_gender() == MALE ? "his" : get_visible_gender() == FEMALE ? "her" : "their"] tongue out. Blep."
			m_type = 1
		if("awoo")
			m_type = 2
			message = "lets out an awoo."
			playsound(src, 'sound/voice/awoo.ogg', 50, 1, -1, preference = /datum/client_preference/emote_noises)
		if("awoo2")
			m_type = 2
			message = "lets out an awoo."
			playsound(src, 'sound/voice/long_awoo.ogg', 50, 1, -1, preference = /datum/client_preference/emote_noises)
		if("growl")
			m_type = 2
			message = "lets out a growl."
			playsound(src, 'sound/voice/growl.ogg', 50, 1, -1, preference = /datum/client_preference/emote_noises)
		if("woof")
			m_type = 2
			message = "lets out a woof."
			playsound(src, 'sound/voice/woof.ogg', 50, 1, -1, preference = /datum/client_preference/emote_noises)
		if("woof2")
			m_type = 2
			message = "lets out a woof."
			playsound(src, 'sound/voice/woof2.ogg', 50, 1, -1, preference = /datum/client_preference/emote_noises)
		if("nya")
			message = "lets out a nya."
			m_type = 2
			playsound(src, 'sound/voice/nya.ogg', 50, 1, -1, preference = /datum/client_preference/emote_noises)
		if("mrowl")
			message = "mrowls."
			m_type = 2
			playsound(src, 'sound/voice/mrow.ogg', 50, 1, -1, preference = /datum/client_preference/emote_noises)
		if("peep")
			message = "peeps like a bird."
			m_type = 2
			playsound(src, 'sound/voice/peep.ogg', 50, 1, -1, preference = /datum/client_preference/emote_noises)
		if("chirp")
			message = "chirps!"
			playsound(src, 'sound/misc/nymphchirp.ogg', 50, 0, preference = /datum/client_preference/emote_noises)
			m_type = 2
		if("hoot")
			message = "hoots!"
			playsound(src, 'sound/voice/hoot.ogg', 50, 1, ,-1, preference = /datum/client_preference/emote_noises)
			m_type = 2
		if("weh")
			message = "lets out a weh."
			m_type = 2
			playsound(src, 'sound/voice/weh.ogg', 50, 1, -1, preference = /datum/client_preference/emote_noises)
		if("merp")
			message = "lets out a merp."
			m_type = 2
			playsound(src, 'sound/voice/merp.ogg', 50, 1, -1, preference = /datum/client_preference/emote_noises)
		if("myarp")
			message = "lets out a myarp."
			m_type = 2
			playsound(src, 'sound/voice/myarp.ogg', 50, 1, -1, preference = /datum/client_preference/emote_noises)
		if("bark")
			message = "lets out a bark."
			m_type = 2
			playsound(src, 'sound/voice/bark2.ogg', 50, 1, -1, preference = /datum/client_preference/emote_noises)
		if("bork")
			m_type = 2
			message = "lets out a bork."
			playsound(src, 'sound/voice/bork.ogg', 50, 1, -1, preference = /datum/client_preference/emote_noises)
		if ("mrow")
			m_type = 2
			message = "lets out a mrow."
			playsound(src, 'sound/voice/mrow.ogg', 50, 1, -1, preference = /datum/client_preference/emote_noises)
		if ("hypno")
			m_type = 2
			message = "lets out a mystifying tone."
			playsound(src, 'sound/voice/hypno.ogg', 50, 1, -1, preference = /datum/client_preference/emote_noises)
		if("hiss")
			message = "lets out a hiss."
			m_type = 2
			playsound(src, 'sound/voice/hiss.ogg', 50, 1, -1, preference = /datum/client_preference/emote_noises)
		if("rattle")
			message = "rattles!"
			m_type = 2
			playsound(src, 'sound/voice/rattle.ogg', 50, 1, -1, preference = /datum/client_preference/emote_noises)
		if("squeak")
			message = "lets out a squeak."
			m_type = 2
			playsound(src, 'sound/effects/mouse_squeak.ogg', 50, 1, -1, preference = /datum/client_preference/emote_noises)
		if("geck")
			message = "geckers!"
			m_type = 2
			playsound(src, 'sound/voice/geck.ogg', 50, 1, -1, preference = /datum/client_preference/emote_noises)
		if("baa")
			message = "lets out a baa."
			m_type = 2
			playsound(src, 'sound/voice/baa.ogg', 50, 1, -1, preference = /datum/client_preference/emote_noises)
		if("baa2")
			message = "bleats."
			m_type = 2
			playsound(src, 'sound/voice/baa2.ogg', 50, 1, -1, preference = /datum/client_preference/emote_noises)
		if("deathgasp2")
			message = "[species.get_death_message()]"
			m_type = 1
			playsound(src, 'sound/voice/deathgasp2.ogg', 50, 1, -1, preference = /datum/client_preference/emote_noises)
		if("mar")
			message = "lets out a mar."
			m_type = 2
			playsound(src, 'sound/voice/mar.ogg', 50, 1, -1, preference = /datum/client_preference/emote_noises)
		if("wurble")
			message = "lets out a wurble."
			m_type = 2
			playsound(src, 'sound/voice/wurble.ogg', 50, 1, -1, preference = /datum/client_preference/emote_noises)
		if("snort")
			message = "snorts!"
			m_type = 2
			playsound(src, 'sound/voice/Snort.ogg', 50, 0, preference = /datum/client_preference/emote_noises)
		if("meow")
			message = "gently meows!"
			m_type = 2
			playsound(src, 'sound/voice/Meow.ogg', 50, 0, preference = /datum/client_preference/emote_noises)
		if("moo")
			message = "takes a breath and lets out a moo."
			m_type = 2
			playsound(src, 'sound/voice/Moo.ogg', 50, 0, preference = /datum/client_preference/emote_noises)
		if("croak")
			message = "rumbles their throat, puffs their cheeks and croaks."
			m_type = 2
			playsound(src, 'sound/voice/Croak.ogg', 50, 0, preference = /datum/client_preference/emote_noises)
		if("gao")
			message = "lets out a gao."
			m_type = 2
			playsound(src, 'sound/voice/gao.ogg', 50, 0, preference = /datum/client_preference/emote_noises)
		if("cackle")
			message = "cackles hysterically!"
			m_type = 2
			playsound(src, 'sound/voice/YeenCackle.ogg', 50, 0, preference = /datum/client_preference/emote_noises)
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
			to_chat(src, "vwag, vflap, mlem, blep, awoo, awoo2, growl, nya, peep, chirp, hoot, weh, merp, myarp, bark, bork, mrow, mrowl, hypno, hiss, rattle, squeak, geck, baa, baa2, mar, wurble, snort, meow, moo, croak, gao, cackle, nsay, nme, flip")
			return TRUE

	if(message)
		custom_emote(m_type,message)
		return TRUE

	return FALSE

/mob/living/carbon/human/verb/toggle_resizing_immunity()
	set name = "Toggle Resizing Immunity"
	set desc = "Toggles your ability to resist resizing attempts"
	set category = "IC"

	resizable = !resizable
	to_chat(src, "<span class='notice'>You are now [resizable ? "susceptible" : "immune"] to being resized.</span>")


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

/mob/living/carbon/human/verb/hide_wings_vr()
	set name = "Show/Hide wings"
	set category = "IC"
	set desc = "Hide your wings, or show them if you already hid them."
	wings_hidden = !wings_hidden
	update_wing_showing()
	var/message = ""
	if(!wings_hidden)
		message = "reveals their wings!"
	else
		message = "hides their wings."
	visible_message("[src] [message]")
