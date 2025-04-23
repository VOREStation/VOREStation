/mob/living/Login()
	..()
	//Mind updates
	mind_initialize()	//updates the mind (or creates and initializes one if one doesn't exist)
	mind.active = 1		//indicates that the mind is currently synced with a client
	//If they're SSD, remove it so they can wake back up.
	update_antag_icons(mind)
	client.screen |= GLOB.global_hud.darksight
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
	add_verb(src, /mob/living/proc/mute_entry)
	add_verb(src, /mob/living/proc/liquidbelly_visuals)
	add_verb(src, /mob/living/proc/fix_vore_effects)

	if(!no_vore)
		add_verb(src, /mob/living/proc/vorebelly_printout)
		if(!vorePanel)
			AddComponent(/datum/component/vore_panel)

	add_verb(src,/mob/living/proc/vore_transfer_reagents) // If mob doesnt have bellies it cant use this verb for anything
	add_verb(src,/mob/living/proc/vore_check_reagents) // If mob doesnt have bellies it cant use this verb for anything
	add_verb(src,/mob/living/proc/vore_bellyrub) // If mob doesnt have bellies it probably won't be needing this anyway
	add_verb(src,/mob/proc/nsay_vore)
	add_verb(src,/mob/proc/nme_vore)
	add_verb(src,/mob/proc/nsay_vore_ch)
	add_verb(src,/mob/proc/nme_vore_ch)
	add_verb(src,/mob/proc/enter_soulcatcher)

	if(!voice_sounds_list.len || !voice_sounds_list)
		if(client.prefs.voice_sound)
			var/prefsound = client.prefs.voice_sound
			voice_sounds_list = get_talk_sound(prefsound)
		else
			voice_sounds_list = GLOB.talk_sound
	resize(size_multiplier, animate = FALSE, uncapped = has_large_resize_bounds(), ignore_prefs = TRUE, aura_animation = FALSE)

	return .
