/mob/living/Login()
	..()
	//Mind updates
	mind_initialize()	//updates the mind (or creates and initializes one if one doesn't exist)
	mind.active = 1		//indicates that the mind is currently synced with a client
	//If they're SSD, remove it so they can wake back up.
	update_antag_icons(mind)
	client.screen |= global_hud.darksight
	client.images |= dsoverlay

	if(ai_holder && !ai_holder.autopilot)
		ai_holder.go_sleep()
		to_chat(src,"<span class='notice'>Mob AI disabled while you are controlling the mob.</span>")

	AddComponent(/datum/component/character_setup)

	// Vore stuff
	verbs |= /mob/living/proc/escapeOOC
	verbs |= /mob/living/proc/lick
	verbs |= /mob/living/proc/smell
	verbs |= /mob/living/proc/switch_scaling

	if(!no_vore)
		verbs |= /mob/living/proc/vorebelly_printout
		if(!vorePanel)
			AddComponent(/datum/component/vore_panel)
	//VOREStation Add Start
	if(client.prefs.voice_sounds_list)
		voice_sounds_list = client.prefs.voice_sounds_list
	else
		voice_sounds_list = talk_sound
	//VOREStation Add End

	return .
