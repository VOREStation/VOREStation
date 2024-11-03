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
		to_chat(src,span_notice("Mob AI disabled while you are controlling the mob."))

	AddComponent(/datum/component/character_setup)

	// Vore stuff
	add_verb(src, /mob/living/proc/escapeOOC)
	add_verb(src, /mob/living/proc/lick)
	add_verb(src, /mob/living/proc/smell)
	add_verb(src, /mob/living/proc/switch_scaling)
	add_verb(src, /mob/living/proc/center_offset)

	if(!no_vore)
		add_verb(src, /mob/living/proc/vorebelly_printout)
		if(!vorePanel)
			AddComponent(/datum/component/vore_panel)
	//VOREStation Add Start
	if(!voice_sounds_list.len || !voice_sounds_list)
		if(client.prefs.voice_sound)
			var/prefsound = client.prefs.voice_sound
			voice_sounds_list = get_talk_sound(prefsound)
		else
			voice_sounds_list = talk_sound
	//VOREStation Add End

	return .
