//These two also have NIF FLAG representations. These are the local setting representations.
#define NIF_SC_CATCHING_ME			0x1
#define NIF_SC_CATCHING_OTHERS		0x2
//These are purely local setings flags, without global representation.
#define NIF_SC_ALLOW_EARS			0x4
#define NIF_SC_ALLOW_EYES			0x8

///////////
// Soulcatcher - Like a posibrain, sorta!
/datum/nifsoft/soulcatcher
	name = "Soulcatcher"
	desc = "A mind storage and processing system capable of capturing and supporting a single human-intelligence mind on body death, into a small VR space."
	list_pos = NIF_SOULCATCHER
	cost = 1265
	wear = 1
	p_drain = 0.01

	var/setting_flags = (NIF_SC_CATCHING_ME|NIF_SC_CATCHING_OTHERS|NIF_SC_ALLOW_EARS|NIF_SC_ALLOW_EYES)
	var/mob/living/carbon/brain/caught_soul/brainmob
	var/inside_flavor = "A small completely white room with a couch, and a window to what seems to be the outside world. A small sign in the corner says 'Configure Me'."

	New()
		..()
		brainmob = new(nif)
		brainmob.nif = nif
		brainmob.container = src
		brainmob.stat = 0
		brainmob.silent = FALSE
		dead_mob_list -= src.brainmob
		load_settings()

	Destroy()
		if(brainmob)
			brainmob.container = null
			qdel(brainmob)
		..()

	install()
		if((. = ..()))
			nif.set_flag(NIF_O_SCMYSELF,NIF_FLAGS_OTHER)
			nif.set_flag(NIF_O_SCOTHERS,NIF_FLAGS_OTHER)

	uninstall()
		if((. = ..()))
			nif.clear_flag(NIF_O_SCMYSELF,NIF_FLAGS_OTHER)
			nif.clear_flag(NIF_O_SCOTHERS,NIF_FLAGS_OTHER)

	activate()
		if((. = ..()))
			show_settings(nif.human)
			spawn(0)
				deactivate()

	deactivate()
		if((. = ..()))
			return TRUE

	stat_text()
		return "Change Settings[brainmob.mind ? " (Mind Stored)" : ""]"

	proc/save_settings()
		nif.save_data["[list_pos]"] = inside_flavor
		return TRUE

	proc/load_settings()
		var/load = nif.save_data["[list_pos]"]
		if(load)
			inside_flavor = load
		return TRUE

	proc/show_settings(var/mob/living/carbon/human/H)
		var/settings_list = list(
		"Catching You \[[setting_flags & NIF_SC_CATCHING_ME ? "Enabled" : "Disabled"]\]" = NIF_SC_CATCHING_ME,
		"Catching Others \[[setting_flags & NIF_SC_CATCHING_OTHERS ? "Enabled" : "Disabled"]\]" = NIF_SC_CATCHING_OTHERS,
		"Ext. Hearing \[[setting_flags & NIF_SC_ALLOW_EARS ? "Enabled" : "Disabled"]\]" = NIF_SC_ALLOW_EARS,
		"Ext. Vision \[[setting_flags & NIF_SC_ALLOW_EYES ? "Enabled" : "Disabled"]\]" = NIF_SC_ALLOW_EYES,
		"Design Inside",
		"Erase Contents")
		var/choice = input(nif.human,"Select a setting to modify:","Soulcatcher NIFSoft") as null|anything in settings_list
		if(choice in settings_list)
			switch(choice)
				if("Design Inside")
					var/new_flavor = input(nif.human, "Type what the prey sees after being 'caught'. This will be \
					printed after an intro ending with: \"Around you, you see...\" to the prey. If you already \
					have prey, this will be printed to them after \"Your surroundings change to...\". Limit 2048 char.", \
					"VR Environment", html_decode(inside_flavor)) as message
					new_flavor = sanitize(new_flavor)
					inside_flavor = new_flavor
					nif.notify("Updating VR environment...")
					to_chat(brainmob,"<span class='notice'>Your surroundings change to...</span>\n[inside_flavor]")
					save_settings()
					return TRUE

				if("Erase Contents")
					if(brainmob && brainmob.mind)
						var/warning = alert(nif.human,"Are you SURE you want to erase [brainmob.mind.name]?","Erase Mind","CANCEL","DELETE","CANCEL")
						if(warning == "DELETE")
							brainmob.ghostize()
							qdel(brainmob)
							brainmob = new(nif)
						nif.notify("Mind deleted!",TRUE)
						return TRUE
					else
						nif.notify("No mind to delete!",TRUE)
						return TRUE

				//Must just be a flag without special handling then.
				else
					var/flag = settings_list[choice]
					return toggle_setting(flag)

	proc/toggle_setting(var/flag)
		setting_flags ^= flag

		//Special treatment
		switch(flag)
			if(NIF_SC_CATCHING_ME)
				if(setting_flags & NIF_SC_CATCHING_ME)
					nif.set_flag(NIF_O_SCMYSELF,NIF_FLAGS_OTHER)
				else
					nif.clear_flag(NIF_O_SCMYSELF,NIF_FLAGS_OTHER)
			if(NIF_SC_CATCHING_OTHERS)
				if(setting_flags & NIF_SC_CATCHING_OTHERS)
					nif.set_flag(NIF_O_SCOTHERS,NIF_FLAGS_OTHER)
				else
					nif.clear_flag(NIF_O_SCOTHERS,NIF_FLAGS_OTHER)
			if(NIF_SC_ALLOW_EARS)
				if(setting_flags & NIF_SC_ALLOW_EARS)
					brainmob.ext_deaf = FALSE
					to_chat(brainmob,"<b>\[\icon[nif.big_icon]NIF\]</b> <span class='notice'>Your access to your host's auditory sense has been unrestricted.</span>")
				else
					brainmob.ext_deaf = TRUE
					to_chat(brainmob,"<b>\[\icon[nif.big_icon]NIF\]</b> <span class='warning'>Your access to your host's auditory sense has been restricted.</span>")
			if(NIF_SC_ALLOW_EYES)
				if(setting_flags & NIF_SC_ALLOW_EYES)
					brainmob.ext_blind = FALSE
					to_chat(brainmob,"<b>\[\icon[nif.big_icon]NIF\]</b> <span class='notice'>Your access to your host's visual sense has been unrestricted.</span>")
				else
					brainmob.ext_blind = TRUE
					to_chat(brainmob,"<b>\[\icon[nif.big_icon]NIF\]</b> <span class='warning'>Your access to your host's visual sense has been restricted.</span>")

		return TRUE

	proc/catch_mob(var/mob/living/carbon/human/H)
		if(istype(H))
			if(H == nif.human) //Reset our permissions to be permissive to the owner.
				brainmob.ext_deaf = FALSE
				brainmob.ext_blind = FALSE
				brainmob.parent_mob = TRUE

			brainmob.dna = H.dna
			brainmob.timeofhostdeath = H.timeofdeath
			brainmob.stat = 0
			if(H.mind)
				H.mind.transfer_to(brainmob)
				brainmob.name = brainmob.mind.name
			var/message = "<span class='notice'>Your vision fades in a haze of static, before returning.</span>\nAround you, you see...\n[inside_flavor]"
			to_chat(brainmob,message)
			nif.notify("Mind loaded into VR space: [brainmob.name]")
			to_chat(nif.human,"<span class='notice'>Your occupant's messages/actions can only be seen by you, and you can \
			send messages that only they can hear/see by 'say'ing either '*nsay' or '*nme'.</span>")
			return TRUE

		return FALSE

////////////////
//The caught mob
/mob/living/carbon/brain/caught_soul
	name = "recorded mind"
	desc = "A mind recorded and being played on digital hardware."
	use_me = 1
	var/ext_deaf = FALSE		//Forbidden from 'ear' access on host
	var/ext_blind = FALSE		//Forbidden from 'eye' access on host
	var/parent_mob = FALSE		//If we've captured our owner
	var/obj/item/device/nif/nif

/mob/living/carbon/brain/caught_soul/Destroy()
	nif = null
	..()

/mob/living/carbon/brain/caught_soul/Life()
	if(!client) return

	. = ..()

	if(parent_mob) return
	//If they're blinded
	if(ext_blind)
		eye_blind = 5
		client.screen.Remove(global_hud.whitense)
		overlay_fullscreen("blind", /obj/screen/fullscreen/blind)
	else
		eye_blind = 0
		clear_fullscreens()
		client.screen.Add(global_hud.whitense)

	//If they're deaf
	if(ext_deaf)
		ear_deaf = 5
	else
		ear_deaf = 0

/mob/living/carbon/brain/caught_soul/hear_say()
	if(ext_deaf || !client)
		return FALSE
	..()

/mob/living/carbon/brain/caught_soul/show_message()
	if(ext_blind || !client)
		return FALSE
	..()

/mob/living/carbon/brain/caught_soul/say(var/message)
	if(parent_mob) return ..()
	if(silent) return FALSE
	to_chat(nif.human,"<b>\[\icon[nif.big_icon]NIF\]</b> <b>[name]</b> speaks, \"[message]\"")
	to_chat(src,"<b>\[\icon[nif.big_icon]NIF\]</b> <b>[name]</b> speaks, \"[message]\"")

/mob/living/carbon/brain/caught_soul/emote(var/act,var/m_type=1,var/message = null)
	if(parent_mob) return ..()
	if(silent) return FALSE
	if (act == "me")
		if(silent)
			return
		if (src.client)
			if (client.prefs.muted & MUTE_IC)
				src << "<span class='warning'>You cannot send IC messages (muted).</span>"
				return
		if (stat)
			return
		if(!(message))
			return
		return custom_emote(m_type, message)
	else
		return FALSE

/mob/living/carbon/brain/caught_soul/custom_emote(var/m_type, var/message)
	if(silent) return FALSE
	to_chat(nif.human,"<b>\[\icon[nif.big_icon]NIF\]</b> <b>[name]</b> [message]")
	to_chat(src,"<b>\[\icon[nif.big_icon]NIF\]</b> <b>[name]</b> [message]")

///////////////////
//The catching hook
/hook/death/proc/nif_soulcatcher(var/mob/living/carbon/human/H)
	if(!istype(H)) return TRUE //Hooks must return TRUE

	if(H.nif && H.nif.flag_check(NIF_O_SCMYSELF,NIF_FLAGS_OTHER)) //They are caught in their own NIF
		var/datum/nifsoft/soulcatcher/SC = H.nif.imp_check(NIF_SOULCATCHER)
		if(!SC.brainmob.mind) //As long as they don't have one
			SC.catch_mob(H,TRUE)
	else if(ishuman(H.loc)) //Died in someone
		var/mob/living/carbon/human/HP = H.loc
		if(HP.nif && HP.nif.flag_check(NIF_O_SCOTHERS,NIF_FLAGS_OTHER))
			var/datum/nifsoft/soulcatcher/SC = HP.nif.imp_check(NIF_SOULCATCHER)
			if(!SC.brainmob.mind) //As long as they don't have one
				SC.catch_mob(H,FALSE)

	return TRUE