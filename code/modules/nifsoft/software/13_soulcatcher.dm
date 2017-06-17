//These two also have NIF FLAG representations. These are the local setting representations.
#define NIF_SC_CATCHING_ME			0x1
#define NIF_SC_CATCHING_OTHERS		0x2
//These are purely local setings flags, without global representation.
#define NIF_SC_ALLOW_EARS			0x4
#define NIF_SC_ALLOW_EYES			0x8
#define NIF_SC_BACKUPS				0x10

///////////
// Soulcatcher - Like a posibrain, sorta!
/datum/nifsoft/soulcatcher
	name = "Soulcatcher"
	desc = "A mind storage and processing system capable of capturing and supporting human-level minds in a small VR space."
	list_pos = NIF_SOULCATCHER
	cost = 950
	wear = 1
	p_drain = 0.01
	other_flags = (NIF_O_SCMYSELF|NIF_O_SCOTHERS) // Default on when installed, clear when uninstalled

	var/setting_flags = (NIF_SC_CATCHING_ME|NIF_SC_CATCHING_OTHERS|NIF_SC_ALLOW_EARS|NIF_SC_ALLOW_EYES|NIF_SC_BACKUPS)
	var/list/brainmobs = list()
	var/inside_flavor = "A small completely white room with a couch, and a window to what seems to be the outside world. A small sign in the corner says 'Configure Me'."

	New()
		..()
		load_settings()

	Destroy()
		qdel_null_list(brainmobs)
		return ..()

	activate()
		if((. = ..()))
			show_settings(nif.human)
			spawn(0)
				deactivate()

	deactivate()
		if((. = ..()))
			return TRUE

	stat_text()
		return "Change Settings ([brainmobs.len] minds)"

	proc/save_settings()
		nif.save_data["[list_pos]"] = inside_flavor
		return TRUE

	proc/load_settings()
		var/load = nif.save_data["[list_pos]"]
		if(load)
			inside_flavor = load
		return TRUE

	proc/notify_into(var/message)
		var/sound = nif.good_sound

		to_chat(nif.human,"<b>\[\icon[nif.big_icon]NIF\]</b> <b>Soulcatcher</b> displays, \"<span class='notice'>[message]</span>\"")
		nif.human << sound

		for(var/brainmob in brainmobs)
			var/mob/living/carbon/brain/caught_soul/CS = brainmob
			to_chat(CS,"<b>\[\icon[nif.big_icon]NIF\]</b> <b>Soulcatcher</b> displays, \"<span class='notice'>[message]</span>\"")
			brainmob << sound

	proc/say_into(var/message, var/mob/living/sender)
		var/sender_name = sender.name
		log_nsay("[sender_name]/[sender.key] : [message]",nif.human)

		to_chat(nif.human,"<b>\[\icon[nif.big_icon]NIF\]</b> <b>[sender_name]</b> speaks, \"[message]\"")
		for(var/brainmob in brainmobs)
			var/mob/living/carbon/brain/caught_soul/CS = brainmob
			to_chat(CS,"<b>\[\icon[nif.big_icon]NIF\]</b> <b>[sender_name]</b> speaks, \"[message]\"")

	proc/emote_into(var/message, var/mob/living/sender)
		var/sender_name = sender.name
		log_nme("[sender_name]/[sender.key] : [message]",nif.human)

		to_chat(nif.human,"<b>\[\icon[nif.big_icon]NIF\]</b> <b>[sender_name]</b> [message]")
		for(var/brainmob in brainmobs)
			var/mob/living/carbon/brain/caught_soul/CS = brainmob
			to_chat(CS,"<b>\[\icon[nif.big_icon]NIF\]</b> <b>[sender_name]</b> [message]")

	proc/show_settings(var/mob/living/carbon/human/H)
		set waitfor = FALSE
		var/settings_list = list(
		"Catching You \[[setting_flags & NIF_SC_CATCHING_ME ? "Enabled" : "Disabled"]\]" = NIF_SC_CATCHING_ME,
		"Catching Prey \[[setting_flags & NIF_SC_CATCHING_OTHERS ? "Enabled" : "Disabled"]\]" = NIF_SC_CATCHING_OTHERS,
		"Ext. Hearing \[[setting_flags & NIF_SC_ALLOW_EARS ? "Enabled" : "Disabled"]\]" = NIF_SC_ALLOW_EARS,
		"Ext. Vision \[[setting_flags & NIF_SC_ALLOW_EYES ? "Enabled" : "Disabled"]\]" = NIF_SC_ALLOW_EYES,
		"Mind Backups \[[setting_flags & NIF_SC_BACKUPS ? "Enabled" : "Disabled"]\]" = NIF_SC_BACKUPS,
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
					for(var/brain in brainmobs)
						var/mob/living/carbon/brain/caught_soul/CS = brain
						to_chat(CS,"<span class='notice'>Your surroundings change to...</span>\n[inside_flavor]")
					save_settings()
					return TRUE

				if("Erase Contents")
					var/mob/living/carbon/brain/caught_soul/brainpick = input(nif.human,"Select a mind to delete:","Erase Mind") as null|anything in brainmobs

					var/warning = alert(nif.human,"Are you SURE you want to erase \"[brainpick]\"?","Erase Mind","CANCEL","DELETE","CANCEL")
					if(warning == "DELETE")
						brainmobs -= brainpick
						qdel(brainpick)
					return TRUE

				//Must just be a flag without special handling then.
				else
					var/flag = settings_list[choice]
					return toggle_setting(flag)

	proc/toggle_setting(var/flag)
		setting_flags ^= flag

		var/notify_message
		//Special treatment
		switch(flag)
			if(NIF_SC_BACKUPS)
				if(setting_flags & NIF_SC_BACKUPS)
					notify_message = "Mind backup system enabled."
				else
					notify_message = "Mind backup system disabled."

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
					for(var/brain in brainmobs)
						var/mob/living/carbon/brain/caught_soul/brainmob = brain
						brainmob.ext_deaf = FALSE
					notify_message = "External audio input enabled."
				else
					for(var/brain in brainmobs)
						var/mob/living/carbon/brain/caught_soul/brainmob = brain
						brainmob.ext_deaf = TRUE
					notify_message = "External audio input disabled."
			if(NIF_SC_ALLOW_EYES)
				if(setting_flags & NIF_SC_ALLOW_EYES)
					for(var/brain in brainmobs)
						var/mob/living/carbon/brain/caught_soul/brainmob = brain
						brainmob.ext_blind = FALSE
					notify_message = "External video input enabled."
				else
					for(var/brain in brainmobs)
						var/mob/living/carbon/brain/caught_soul/brainmob = brain
						brainmob.ext_blind = TRUE
					notify_message = "External video input disabled."

		if(notify_message)
			notify_into(notify_message)

		return TRUE

	proc/catch_mob(var/mob/living/carbon/human/H)
		//Create a new brain mob
		var/mob/living/carbon/brain/caught_soul/brainmob = new(nif)
		brainmob.nif = nif
		brainmob.soulcatcher = src
		brainmob.container = src
		brainmob.stat = 0
		brainmob.silent = FALSE
		dead_mob_list -= brainmob
		brainmob.add_language(LANGUAGE_GALCOM)
		brainmobs |= brainmob

		//If we caught our owner, special settings.
		if(H == nif.human)
			brainmob.ext_deaf = FALSE
			brainmob.ext_blind = FALSE
			brainmob.parent_mob = TRUE
			SStranscore.m_backup(H.mind,H) //ONE backup. Won't be called in life due to avoidance of parent_mob backups.

		//Set some basics on the mob.
		brainmob.dna = H.dna
		brainmob.timeofhostdeath = H.timeofdeath
		brainmob.stat = 0

		//Put the mind and player into the mob
		H.mind.transfer_to(brainmob)
		brainmob.name = brainmob.mind.name
		SStranscore.m_backup(brainmob.mind,0) //It does ONE, so medical will hear about it.

		//Give them a flavortext message
		var/message = "<span class='notice'>Your vision fades in a haze of static, before returning.</span>\n\
						Around you, you see...\n\
						[inside_flavor]"

		to_chat(brainmob,message)

		//Reminder on how this works to host
		if(brainmobs.len == 1) //Only spam this on the first one
			to_chat(nif.human,"<span class='notice'>Your occupant's messages/actions can only be seen by you, and you can \
			send messages that only they can hear/see by 'say'ing either '*nsay' or '*nme'.</span>")

		//Announce to host and other minds
		notify_into("New mind loaded: [brainmob.name]")
		return TRUE

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
	var/datum/nifsoft/soulcatcher/soulcatcher

/mob/living/carbon/brain/caught_soul/Destroy()
	if(soulcatcher)
		soulcatcher.notify_into("Mind unloaded: [name]")
		soulcatcher.brainmobs -= src
		soulcatcher = null
	if(nif)
		nif = null
	container = null
	return ..()

/mob/living/carbon/brain/caught_soul/Life()
	if(!mind)
		qdel(src)
		return

	. = ..()

	if(!parent_mob && (life_tick % 150 == 0) && soulcatcher.setting_flags & NIF_SC_BACKUPS)
		SStranscore.m_backup(mind,0) //Passed 0 means "Don't touch the nif fields on the mind record"

	life_tick++

	if(!client) return
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

/mob/living/carbon/brain/caught_soul/me_verb_subtle()
	set hidden = TRUE

	return FALSE

/mob/living/carbon/brain/caught_soul/whisper()
	set hidden = TRUE

	return FALSE

/mob/living/carbon/brain/caught_soul/say(var/message)
	if(parent_mob) return ..()
	if(silent) return FALSE
	soulcatcher.say_into(message,src)

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
	soulcatcher.emote_into(message,src)

/mob/living/carbon/brain/caught_soul/resist()
	set name = "Resist"
	set category = "IC"

	to_chat(src,"<span class='warning'>There's no way out! You're stuck in VR.</span>")

///////////////////
//The catching hook
/hook/death/proc/nif_soulcatcher(var/mob/living/carbon/human/H)
	if(!istype(H) || !H.mind) return TRUE //Hooks must return TRUE

	if(H.nif && H.nif.flag_check(NIF_O_SCMYSELF,NIF_FLAGS_OTHER)) //They are caught in their own NIF
		var/datum/nifsoft/soulcatcher/SC = H.nif.imp_check(NIF_SOULCATCHER)
		SC.catch_mob(H,TRUE)
	else if(ishuman(H.loc)) //Died in someone
		var/mob/living/carbon/human/HP = H.loc
		if(HP.nif && HP.nif.flag_check(NIF_O_SCOTHERS,NIF_FLAGS_OTHER))
			var/datum/nifsoft/soulcatcher/SC = HP.nif.imp_check(NIF_SOULCATCHER)
			SC.catch_mob(H,FALSE)

	return TRUE