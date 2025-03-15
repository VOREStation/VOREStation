///////////
// Soulcatcher - Like a posibrain, sorta!
/datum/nifsoft/soulcatcher
	name = "Soulcatcher"
	desc = "A mind storage and processing system capable of capturing and supporting human-level minds in a small VR space."
	list_pos = NIF_SOULCATCHER
	cost = 100 //If I wanna trap people's minds and lood them, then by god I'll do so.
	wear = 0
	p_drain = 0.01

	var/setting_flags = (NIF_SC_ALLOW_EARS|NIF_SC_ALLOW_EYES|NIF_SC_BACKUPS|NIF_SC_PROJECTING)
	var/list/brainmobs = list()
	var/inside_flavor = "A small completely white room with a couch, and a window to what seems to be the outside world. A small sign in the corner says 'Configure Me'."

/datum/nifsoft/soulcatcher/New()
	..()
	load_settings()

/datum/nifsoft/soulcatcher/Destroy()
	QDEL_LIST_NULL(brainmobs)
	return ..()

/datum/nifsoft/soulcatcher/activate()
	if((. = ..()))
		show_settings(nif.human)
		spawn(0)
			deactivate()

/datum/nifsoft/soulcatcher/deactivate(var/force = FALSE)
	if((. = ..()))
		return TRUE

/datum/nifsoft/soulcatcher/stat_text()
	return "Change Settings ([brainmobs.len] minds)"

/datum/nifsoft/soulcatcher/install()
	if((. = ..()))
		//nif.set_flag(NIF_O_SCOTHERS,NIF_FLAGS_OTHER)	//Only required on install if the flag is in the default setting_flags list defined few lines above.
		if(nif?.human)
			add_verb(nif.human, /mob/proc/nsay)
			add_verb(nif.human, /mob/proc/nme)

/datum/nifsoft/soulcatcher/uninstall()
	QDEL_LIST_NULL(brainmobs)
	if((. = ..()) && nif?.human) //Sometimes NIFs are deleted outside of a human
		remove_verb(nif.human, /mob/proc/nsay)
		remove_verb(nif.human, /mob/proc/nme)

/datum/nifsoft/soulcatcher/proc/save_settings()
	if(!nif)
		return
	nif.save_data["[list_pos]"] = inside_flavor
	return TRUE

/datum/nifsoft/soulcatcher/proc/load_settings()
	if(!nif)
		return
	var/load = nif.save_data["[list_pos]"]
	if(load)
		inside_flavor = load
	return TRUE

/datum/nifsoft/soulcatcher/proc/notify_into(var/message)
	var/sound = nif.good_sound

	message = " " + span_bold("Soulcatcher") + " displays, \"" + span_notice(span_nif("[message]")) + "\""

	to_chat(nif.human,
			type = MESSAGE_TYPE_NIF,
			html = span_nif(span_bold("\[[icon2html(nif.big_icon, nif.human)]NIF\]") + message))
	nif.human << sound

	for(var/mob/living/carbon/brain/caught_soul/CS as anything in brainmobs)
		to_chat(CS,
				type = MESSAGE_TYPE_NIF,
				html = span_nif(span_bold("\[[icon2html(nif.big_icon, CS.client)]NIF\]") + message))
		CS << sound

/datum/nifsoft/soulcatcher/proc/say_into(var/message, var/mob/living/sender, var/mob/eyeobj, var/whisper)
	var/sender_name = eyeobj ? eyeobj.name : sender.name

	//AR Projecting
	if(eyeobj)
		var/speak_verb = "says"
		message = span_game(span_say(span_bold("[sender_name]") + " [speak_verb], \"[message]\""))
		if(whisper)
			speak_verb = "whispers"
			sender.eyeobj.visible_message(span_italics(message), range = 1)
		else
			sender.eyeobj.visible_message(message)

	//Not AR Projecting
	else
		var/speak_verb = "speaks"
		message = " " + span_bold("[sender_name]") + " [speak_verb], \"[message]\""
		to_chat(nif.human,
				type = MESSAGE_TYPE_NIF,
				html = span_nif(span_bold("\[[icon2html(nif.big_icon, nif.human.client)]NIF\]") + message))
		if(whisper)
			speak_verb = "whispers"
			to_chat(sender,
					type = MESSAGE_TYPE_NIF,
					html = span_nif(span_bold("\[[icon2html(nif.big_icon, sender.client)]NIF\]") + span_italics(message)))
		else
			for(var/mob/living/carbon/brain/caught_soul/CS as anything in brainmobs)
				to_chat(CS,
						type = MESSAGE_TYPE_NIF,
						html = span_nif(span_bold("\[[icon2html(nif.big_icon, CS.client)]NIF\]") + message))

	log_nsay(message,nif.human.real_name,sender)

/datum/nifsoft/soulcatcher/proc/emote_into(var/message, var/mob/living/sender, var/mob/eyeobj, var/whisper)
	var/sender_name = eyeobj ? eyeobj.name : sender.name

	//AR Projecting
	if(eyeobj)
		var/range = world.view
		if(whisper)
			range = 1
		sender.eyeobj.visible_message(span_emote("[sender_name] [message]"), range = range)

	//Not AR Projecting
	else
		message = " " + span_bold("[sender_name]") + " [message]"
		to_chat(nif.human,
				type = MESSAGE_TYPE_NIF,
				html = span_nif(span_bold("\[[icon2html(nif.big_icon,nif.human.client)]NIF\]") + message))
		if(whisper)
			to_chat(sender,
					type = MESSAGE_TYPE_NIF,
					html = span_nif(span_bold("\[[icon2html(nif.big_icon,sender.client)]NIF\]") + span_italics(message)))
		else
			for(var/mob/living/carbon/brain/caught_soul/CS as anything in brainmobs)
				to_chat(CS,
						type = MESSAGE_TYPE_NIF,
						html = span_nif(span_bold("\[[icon2html(nif.big_icon,CS.client)]NIF\]") + message))

	log_nme(message,nif.human.real_name,sender)

/datum/nifsoft/soulcatcher/proc/show_settings(var/mob/living/carbon/human/H)
	set waitfor = FALSE
	var/settings_list = list(
	"Catching You \[[setting_flags & NIF_SC_CATCHING_ME ? "Enabled" : "Disabled"]\]" = NIF_SC_CATCHING_ME,
	"Catching Prey \[[setting_flags & NIF_SC_CATCHING_OTHERS ? "Enabled" : "Disabled"]\]" = NIF_SC_CATCHING_OTHERS,
	"Ext. Hearing \[[setting_flags & NIF_SC_ALLOW_EARS ? "Enabled" : "Disabled"]\]" = NIF_SC_ALLOW_EARS,
	"Ext. Vision \[[setting_flags & NIF_SC_ALLOW_EYES ? "Enabled" : "Disabled"]\]" = NIF_SC_ALLOW_EYES,
	"Mind Backups \[[setting_flags & NIF_SC_BACKUPS ? "Enabled" : "Disabled"]\]" = NIF_SC_BACKUPS,
	"AR Projecting \[[setting_flags & NIF_SC_PROJECTING ? "Enabled" : "Disabled"]\]" = NIF_SC_PROJECTING,
	"Design Inside",
	"Erase Contents")
	var/choice = tgui_input_list(nif.human,"Select a setting to modify:","Soulcatcher NIFSoft", settings_list)
	if(choice in settings_list)
		switch(choice)

			if("Design Inside")
				var/new_flavor = tgui_input_text(nif.human, "Type what the prey sees after being 'caught'. This will be \
				printed after an intro ending with: \"Around you, you see...\" to the prey. If you already \
				have prey, this will be printed to them after \"Your surroundings change to...\". Limit 2048 char.", \
				"VR Environment", html_decode(inside_flavor), MAX_MESSAGE_LEN*2, TRUE, prevent_enter = TRUE)
				new_flavor = sanitize(new_flavor, MAX_MESSAGE_LEN*2)
				inside_flavor = new_flavor
				nif.notify("Updating VR environment...")
				for(var/mob/living/carbon/brain/caught_soul/CS as anything in brainmobs)
					to_chat(CS,span_notice("Your surroundings change to...") + "\n[inside_flavor]")
				save_settings()
				return TRUE

			if("Erase Contents")
				var/mob/living/carbon/brain/caught_soul/brainpick = tgui_input_list(nif.human,"Select a mind to delete:","Erase Mind", brainmobs)

				var/warning = tgui_alert(nif.human,"Are you SURE you want to erase \"[brainpick]\"?","Erase Mind",list("CANCEL","DELETE"))
				if(warning == "DELETE")
					brainmobs -= brainpick
					qdel(brainpick)
				return TRUE

			//Must just be a flag without special handling then.
			else
				var/flag = settings_list[choice]
				return toggle_setting(flag)

/datum/nifsoft/soulcatcher/proc/toggle_setting(var/flag)
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
				for(var/mob/living/carbon/brain/caught_soul/brainmob as anything in brainmobs)
					brainmob.ext_deaf = FALSE
				notify_message = "External audio input enabled."
			else
				for(var/mob/living/carbon/brain/caught_soul/brainmob as anything in brainmobs)
					brainmob.ext_deaf = TRUE
				notify_message = "External audio input disabled."
		if(NIF_SC_ALLOW_EYES)
			if(setting_flags & NIF_SC_ALLOW_EYES)
				for(var/mob/living/carbon/brain/caught_soul/brainmob as anything in brainmobs)
					brainmob.ext_blind = FALSE
				notify_message = "External video input enabled."
			else
				for(var/mob/living/carbon/brain/caught_soul/brainmob as anything in brainmobs)
					brainmob.ext_blind = TRUE
				notify_message = "External video input disabled."

	if(notify_message)
		notify_into(notify_message)

	return TRUE

//Complex version for catching in-round characters
/datum/nifsoft/soulcatcher/proc/catch_mob(var/mob/M)
	if(!M.mind)	return
	if(!(M.soulcatcher_pref_flags & SOULCATCHER_ALLOW_CAPTURE)) return

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

	//Put the mind and player into the mob
	M.mind.transfer_to(brainmob)
	brainmob.name = brainmob.mind.name
	brainmob.real_name = brainmob.mind.name

	//If we caught our owner, special settings.
	if(M == nif.human)
		brainmob.ext_deaf = FALSE
		brainmob.ext_blind = FALSE
		brainmob.parent_mob = TRUE

	//If they have these values, apply them
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		qdel_swap(brainmob.dna, H.dna.Clone())
		brainmob.ooc_notes = H.ooc_notes
		brainmob.ooc_notes_likes = H.ooc_notes_likes
		brainmob.ooc_notes_dislikes = H.ooc_notes_dislikes
		/* Not implemented on virgo
		brainmob.ooc_notes_favs = H.ooc_notes_favs
		brainmob.ooc_notes_maybes = H.ooc_notes_maybes
		brainmob.ooc_notes_style = H.ooc_notes_style
		*/
		brainmob.timeofhostdeath = H.timeofdeath
		SStranscore.m_backup(brainmob.mind,0) //It does ONE, so medical will hear about it.

	//Else maybe they're a joining ghost
	else if(isobserver(M))
		brainmob.transient = TRUE
		qdel(M) //Bye ghost

	//Give them a flavortext message
	var/message = span_notice("Your vision fades in a haze of static, before returning.") + "\n\
					Around you, you see...\n\
					[inside_flavor]"

	to_chat(brainmob,message)

	//Reminder on how this works to host
	if(brainmobs.len == 1) //Only spam this on the first one
		to_chat(nif.human,span_notice("Your occupant's messages/actions can only be seen by you, and you can \
		send messages that only they can hear/see by using the NSay and NMe verbs (or the *nsay and *nme emotes)."))

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
	var/transient = FALSE		//Someone who ghosted into the NIF
	var/client_missing = 0		//How long the client has been missing
	universal_understand = TRUE

	var/obj/item/nif/nif
	var/datum/nifsoft/soulcatcher/soulcatcher
	var/identifying_gender

/mob/living/carbon/brain/caught_soul/Login()
	..()
	plane_holder.set_vis(VIS_AUGMENTED, TRUE)
	plane_holder.set_vis(VIS_SOULCATCHER, TRUE)
	identifying_gender = client.prefs.identifying_gender

/mob/living/carbon/brain/caught_soul/Destroy()
	if(soulcatcher)
		soulcatcher.notify_into("Mind unloaded: [name]")
		soulcatcher.brainmobs -= src
		soulcatcher = null
	if(eyeobj)
		reenter_soulcatcher()
		eyeobj = null //This SHOULD be null already, reenter_soulcatcher destroys and nulls it, but safety first.
	container = null
	nif = null
	return ..()

/mob/living/carbon/brain/caught_soul/Life()
	if(!mind || !key)
		qdel(src)
		return

	. = ..()

	if(!parent_mob && !transient &&(life_tick % 150 == 0) && soulcatcher?.setting_flags & NIF_SC_BACKUPS)
		SStranscore.m_backup(mind,0) //Passed 0 means "Don't touch the nif fields on the mind record"

	life_tick++

	if(!client)
		if(++client_missing == 300)
			qdel(src)
		return
	else
		client_missing = 0

	if(parent_mob) return

	//If they're blinded
	if(soulcatcher) // needs it's own handling to allow vore_fx
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
		//deaf_loop.start(skip_start_sound = TRUE) // Not implemented on Virgo
	else
		ear_deaf = 0
		//deaf_loop.stop()  // Not implemented on Virgo

/mob/living/carbon/brain/caught_soul/hear_say()
	if(ext_deaf || !client)
		return FALSE
	.=..()

/mob/living/carbon/brain/caught_soul/show_message(msg, type, alt, alt_type)
	if(ext_blind || !client)
		return FALSE
	..()

/mob/living/carbon/brain/caught_soul/face_atom(var/atom/A)
	if(eyeobj)
		return eyeobj.face_atom(A)
	else
		return ..(A)

/mob/living/carbon/brain/caught_soul/set_dir(var/direction)
	if(eyeobj)
		return eyeobj.set_dir(direction)
	else
		return ..(direction)

/mob/living/carbon/brain/caught_soul/me_verb_subtle(message as message)
	if(silent) return FALSE
	soulcatcher.emote_into(message,src,eyeobj,TRUE)

/mob/living/carbon/brain/caught_soul/whisper(message as text)
	if(silent) return FALSE
	soulcatcher.say_into(message,src,eyeobj,TRUE)

/mob/living/carbon/brain/caught_soul/say(var/message, var/datum/language/speaking = null, var/whispering = 0)
	if(silent) return FALSE
	soulcatcher.say_into(message,src,eyeobj)

/mob/living/carbon/brain/caught_soul/emote(var/act,var/m_type=1,var/message = null)
	if(silent) return FALSE
	if (act == "me")
		if(silent)
			return
		if (src.client)
			if (client.prefs.muted & MUTE_IC)
				to_chat(src, span_warning("You cannot send IC messages (muted)."))
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
	soulcatcher.emote_into(message,src,eyeobj)

/mob/living/carbon/brain/caught_soul/resist()
	set name = "Resist"
	set category = "IC.Game"

	to_chat(src,span_warning("There's no way out! You're stuck in VR."))

///////////////////
//A projected AR soul thing
/mob/observer/eye/ar_soul
	plane = PLANE_AUGMENTED
	icon = 'icons/obj/machines/ar_elements.dmi'
	icon_state = "beacon"
	var/mob/living/parent_human

/mob/observer/eye/ar_soul/New(var/mob/brainmob, var/human)
	ASSERT(brainmob && brainmob.client)
	..()

	owner = brainmob				//Set eyeobj's owner
	parent_human = human			//E-z reference to human
	sight |= SEE_SELF				//Always see yourself

	name = "[brainmob.name] (AR)"	//Set the name
	real_name = brainmob.real_name	//And the OTHER name

	forceMove(get_turf(parent_human))
	parent_human.AddComponent(/datum/component/recursive_move)
	RegisterSignal(parent_human, COMSIG_OBSERVER_MOVED, /mob/observer/eye/ar_soul/proc/human_moved)

	//Time to play dressup
	if(brainmob.client.prefs)
		var/mob/living/carbon/human/dummy/dummy = new ()
		brainmob.client.prefs.dress_preview_mob(dummy)
		sleep(1 SECOND) //Strange bug in preview code? Without this, certain things won't show up. Yay race conditions?
		dummy.regenerate_icons()

		var/icon/new_icon = getHologramIcon(getCompoundIcon(dummy))
		qdel(dummy)
		icon = new_icon

/mob/observer/eye/ar_soul/Destroy()
	if(parent_human) //It's POSSIBLE they've been deleted before the NIF somehow
		UnregisterSignal(parent_human, COMSIG_OBSERVER_MOVED)
		parent_human = null
	return ..()

/mob/observer/eye/ar_soul/EyeMove(n, direct)
	var/initial = initial(sprint)
	var/max_sprint = 50

	if(cooldown && cooldown < world.timeofday)
		sprint = initial

	for(var/i = 0; i < max(sprint, initial); i += 20)
		var/turf/stepn = get_turf(get_step(src, direct))
		if(stepn)
			set_dir(direct)
			if(can_see(parent_human, stepn))
				forceMove(stepn)

	cooldown = world.timeofday + 5
	if(acceleration)
		sprint = min(sprint + 0.5, max_sprint)
	else
		sprint = initial
	return 1

/mob/observer/eye/ar_soul/proc/human_moved()
	if(!can_see(parent_human,src))
		forceMove(get_turf(parent_human))

///////////////////
//The catching hook
/hook/death/proc/nif_soulcatcher(var/mob/living/L)
	if(!istype(L) || !L.mind) return TRUE //Hooks must return TRUE

	if(isbelly(L.loc)) //Died in someone
		var/obj/belly/B = L.loc
		var/mob/living/owner = B.owner
		var/obj/soulgem/gem = owner.soulgem
		if(gem && gem.flag_check(SOULGEM_ACTIVE | NIF_SC_CATCHING_OTHERS, TRUE))
			var/to_use_custom_name = null
			if(isanimal(L))
				to_use_custom_name = L.name
			gem.catch_mob(L, to_use_custom_name)
			return TRUE
		var/mob/living/carbon/human/HP = B.owner
		var/mob/living/carbon/human/H = L
		if(!istype(H)) return TRUE
		if(istype(HP) && HP.nif && HP.nif.flag_check(NIF_O_SCOTHERS,NIF_FLAGS_OTHER))
			var/datum/nifsoft/soulcatcher/SC = HP.nif.imp_check(NIF_SOULCATCHER)
			SC.catch_mob(H)
	else
		var/obj/soulgem/gem = L.soulgem
		if(gem && gem.flag_check(SOULGEM_ACTIVE | NIF_SC_CATCHING_ME, TRUE))
			var/to_use_custom_name = null
			if(isanimal(L))
				to_use_custom_name = L.name
			gem.catch_mob(L, to_use_custom_name)
			return TRUE
		var/mob/living/carbon/human/H = L
		if(!istype(H)) return TRUE
		if(H.nif && H.nif.flag_check(NIF_O_SCMYSELF,NIF_FLAGS_OTHER)) //They are caught in their own NIF
			var/datum/nifsoft/soulcatcher/SC = H.nif.imp_check(NIF_SOULCATCHER)
			SC.catch_mob(H)
	return TRUE

///////////////////
//Verbs for humans
/mob/proc/nsay(message as text)
	set name = "NSay"
	set desc = "Speak into your NIF's Soulcatcher."
	set category = "IC.NIF"

	src.nsay_act(message)

/mob/proc/nsay_act(message as text)
	to_chat(src, span_warning("You must be a humanoid with a NIF implanted to use that."))

/mob/living/carbon/human/nsay_act(message as text)
	if(stat != CONSCIOUS)
		to_chat(src,span_warning("You can't use NSay while unconscious."))
		return
	if(!nif)
		to_chat(src,span_warning("You can't use NSay without a NIF."))
		return
	var/datum/nifsoft/soulcatcher/SC = nif.imp_check(NIF_SOULCATCHER)
	if(!SC)
		to_chat(src,span_warning("You need the Soulcatcher software to use NSay."))
		return
	if(!SC.brainmobs.len)
		to_chat(src,span_warning("You need a loaded mind to use NSay."))
		return
	if(!message)
		message = tgui_input_text(src, "Type a message to say.","Speak into Soulcatcher")
	if(message)
		var/sane_message = sanitize(message)
		SC.say_into(sane_message,src)

/mob/proc/nme(message as message)
	set name = "NMe"
	set desc = "Emote into your NIF's Soulcatcher."
	set category = "IC.NIF"

	src.nme_act(message)

/mob/proc/nme_act(message as message)
	to_chat(src, span_warning("You must be a humanoid with a NIF implanted to use that."))

/mob/living/carbon/human/nme_act(message as message)
	if(stat != CONSCIOUS)
		to_chat(src,span_warning("You can't use NMe while unconscious."))
		return
	if(!nif)
		to_chat(src,span_warning("You can't use NMe without a NIF."))
		return
	var/datum/nifsoft/soulcatcher/SC = nif.imp_check(NIF_SOULCATCHER)
	if(!SC)
		to_chat(src,span_warning("You need the Soulcatcher software to use NMe."))
		return
	if(!SC.brainmobs.len)
		to_chat(src,span_warning("You need a loaded mind to use NMe."))
		return

	if(!message)
		message = tgui_input_text(src, "Type an action to perform.","Emote into Soulcatcher")
	if(message)
		var/sane_message = sanitize(message)
		SC.emote_into(sane_message,src)

///////////////////
//Verbs for soulbrains
/mob/living/carbon/brain/caught_soul/verb/ar_project()
	set name = "AR/SR Project"
	set desc = "Project your form into Augmented Reality for those around your predator with the appearance of your loaded character."
	set category = "Soulcatcher"

	if(eyeobj)
		to_chat(src,span_warning("You're already projecting in AR!"))
		return

	if(!(soulcatcher.setting_flags & NIF_SC_PROJECTING))
		to_chat(src,span_warning("Projecting from this NIF has been disabled!"))
		return

	if(!client || !client.prefs)
		return //Um...

	eyeobj = new/mob/observer/eye/ar_soul(src,nif.human)
	soulcatcher.notify_into("[src] now AR projecting.")

/mob/living/carbon/brain/caught_soul/verb/jump_to_owner()
	set name = "Jump to Owner"
	set desc = "Jump your projection back to the owner of the soulcatcher you're inside."
	set category = "Soulcatcher"

	if(!eyeobj)
		to_chat(src,span_warning("You're not projecting into AR!"))
		return

	eyeobj.forceMove(get_turf(nif))

/mob/living/carbon/brain/caught_soul/verb/reenter_soulcatcher()
	set name = "Re-enter Soulcatcher"
	set desc = "Leave AR projection and drop back into the soulcatcher."
	set category = "Soulcatcher"

	if(!eyeobj)
		to_chat(src,span_warning("You're not projecting into AR!"))
		return

	QDEL_NULL(eyeobj)
	soulcatcher.notify_into("[src] ended AR projection.")

/mob/living/carbon/brain/caught_soul/verb/nsay_brain(message as text)
	set name = "NSay"
	set desc = "Speak into the NIF's Soulcatcher (circumventing AR speaking)."
	set category = "Soulcatcher"

	if(!message)
		message = tgui_input_text(src, "Type a message to say.","Speak into Soulcatcher")
	if(message)
		var/sane_message = sanitize(message)
		soulcatcher.say_into(sane_message,src,null)

/mob/living/carbon/brain/caught_soul/verb/nme_brain(message as message)
	set name = "NMe"
	set desc = "Emote into the NIF's Soulcatcher (circumventing AR speaking)."
	set category = "Soulcatcher"

	if(!message)
		message = tgui_input_text(src, "Type an action to perform.","Emote into Soulcatcher")
	if(message)
		var/sane_message = sanitize(message)
		soulcatcher.emote_into(sane_message,src,null)
