/proc/playsound(atom/source, soundin, vol as num, vary, extrarange as num, falloff, is_global, frequency = null, channel = 0, pressure_affected = TRUE, ignore_walls = TRUE, preference = null, volume_channel = null)
	if(Master.current_runlevel < RUNLEVEL_LOBBY)
		return

	var/turf/turf_source = get_turf(source)
	if(!turf_source)
		return
	var/area/area_source = turf_source.loc

	//allocate a channel if necessary now so its the same for everyone
	channel = channel || SSsounds.random_available_channel()

	// Looping through the player list has the added bonus of working for mobs inside containers
	var/sound/S = sound(get_sfx(soundin))
	var/maxdistance = (world.view + extrarange) * 2  //VOREStation Edit - 3 to 2
	var/list/listeners = player_list.Copy()
	for(var/mob/M as anything in listeners)
		if(!M || !M.client)
			continue
		var/turf/T = get_turf(M)
		if(!T)
			continue
		var/area/A = T.loc
		if((A.flag_check(AREA_SOUNDPROOF) || area_source.flag_check(AREA_SOUNDPROOF)) && (A != area_source))
			continue
		//var/distance = get_dist(T, turf_source) Save get_dist for later because it's more expensive

		if(!T || T.z != turf_source.z) //^ +1
			continue
		if(get_dist(T, turf_source) > maxdistance)
			continue
		if(!ignore_walls && !can_see(turf_source, T, length = maxdistance * 2))
			continue

		SSmotiontracker.ping(source,vol) // Nearly everything pings this, the quieter the less likely
		M.playsound_local(turf_source, soundin, vol, vary, frequency, falloff, is_global, channel, pressure_affected, S, preference, volume_channel)

/mob/proc/check_sound_preference(list/preference)
	if(!islist(preference))
		preference = list(preference)

	for(var/p in preference)
		// Ignore nulls
		if(p)
			if(!read_preference(p))
				return FALSE

	return TRUE

/mob/proc/playsound_local(turf/turf_source, soundin, vol as num, vary, frequency, falloff, is_global, channel = 0, pressure_affected = TRUE, sound/S, preference, volume_channel = null)
	if(!client || ear_deaf > 0)
		return

	if(!check_sound_preference(preference))
		return

	if(!S)
		S = sound(get_sfx(soundin))

	S.wait = 0 //No queue
	S.channel = channel || SSsounds.random_available_channel()

	// I'm not sure if you can modify S.volume, but I'd rather not try to find out what
	// horrible things lurk in BYOND's internals, so we're just gonna do vol *=
	vol *= client.get_preference_volume_channel(volume_channel)
	vol *= client.get_preference_volume_channel(VOLUME_CHANNEL_MASTER)
	S.volume = vol

	if(vary || frequency)
		if(frequency)
			S.frequency = frequency
		else
			S.frequency = get_rand_frequency()

	if(isturf(turf_source))
		var/turf/T = get_turf(src)

		//sound volume falloff with distance
		var/distance = get_dist(T, turf_source)

		S.volume -= max(distance - world.view, 0) * 2 //multiplicative falloff to add on top of natural audio falloff.

		//Atmosphere affects sound
		var/pressure_factor = 1
		if(pressure_affected)
			var/datum/gas_mixture/hearer_env = T.return_air()
			var/datum/gas_mixture/source_env = turf_source.return_air()

			if(hearer_env && source_env)
				var/pressure = min(hearer_env.return_pressure(), source_env.return_pressure())
				if(pressure < ONE_ATMOSPHERE)
					pressure_factor = max((pressure - SOUND_MINIMUM_PRESSURE)/(ONE_ATMOSPHERE - SOUND_MINIMUM_PRESSURE), 0)
			else //space
				pressure_factor = 0

			if(distance <= 1)
				pressure_factor = max(pressure_factor, 0.15) //touching the source of the sound

			S.volume *= pressure_factor
			//End Atmosphere affecting sound

		//Don't bother with doing anything below.
		if(S.volume <= 0)
			return //No sound

		//Apply a sound environment.
		if(!is_global)
			S.environment = get_sound_env(pressure_factor)

		var/dx = turf_source.x - T.x // Hearing from the right/left
		S.x = dx
		var/dz = turf_source.y - T.y // Hearing from infront/behind
		S.z = dz
		// The y value is for above your head, but there is no ceiling in 2d spessmens.
		S.y = 1
		S.falloff = (falloff ? falloff : FALLOFF_SOUNDS)

	src << S

/proc/sound_to_playing_players(sound, volume = 100, vary)
	sound = get_sfx(sound)
	for(var/M in player_list)
		if(ismob(M) && !isnewplayer(M))
			var/mob/MO = M
			MO.playsound_local(get_turf(MO), sound, volume, vary, pressure_affected = FALSE)

/mob/proc/stop_sound_channel(chan)
	src << sound(null, repeat = 0, wait = 0, channel = chan)

/mob/proc/set_sound_channel_volume(channel, volume)
	var/sound/S = sound(null, FALSE, FALSE, channel, volume)
	S.status = SOUND_UPDATE
	src << S

/proc/get_rand_frequency()
	return rand(32000, 55000) //Frequency stuff only works with 45kbps oggs.

/client/proc/playtitlemusic()
	if(!ticker || !SSmedia_tracks.lobby_tracks.len || !media)	return
	if(prefs?.read_preference(/datum/preference/toggle/play_lobby_music))
		var/datum/track/T = pick(SSmedia_tracks.lobby_tracks)
		media.push_music(T.url, world.time, 0.35)
		to_chat(src,span_notice("Lobby music: " + span_bold("[T.title]") + " by " + span_bold("[T.artist]") + "."))

/proc/get_sfx(soundin)
	if(istext(soundin))
		switch(soundin)
			if ("shatter") soundin = pick('sound/effects/Glassbr1.ogg','sound/effects/Glassbr2.ogg','sound/effects/Glassbr3.ogg')
			if ("explosion") soundin = pick('sound/effects/Explosion1.ogg','sound/effects/Explosion2.ogg','sound/effects/Explosion3.ogg','sound/effects/Explosion4.ogg','sound/effects/Explosion5.ogg','sound/effects/Explosion6.ogg')
			if ("sparks") soundin = pick('sound/effects/sparks1.ogg','sound/effects/sparks2.ogg','sound/effects/sparks3.ogg','sound/effects/sparks5.ogg','sound/effects/sparks6.ogg','sound/effects/sparks7.ogg')
			if ("rustle") soundin = pick('sound/effects/rustle1.ogg','sound/effects/rustle2.ogg','sound/effects/rustle3.ogg','sound/effects/rustle4.ogg','sound/effects/rustle5.ogg')
			if ("punch") soundin = pick('sound/weapons/punch1.ogg','sound/weapons/punch2.ogg','sound/weapons/punch3.ogg','sound/weapons/punch4.ogg')
			if ("clownstep") soundin = pick('sound/effects/clownstep1.ogg','sound/effects/clownstep2.ogg')
			if ("swing_hit") soundin = pick('sound/weapons/genhit1.ogg', 'sound/weapons/genhit2.ogg', 'sound/weapons/genhit3.ogg')
			if ("hiss") soundin = pick('sound/voice/hiss1.ogg','sound/voice/hiss2.ogg','sound/voice/hiss3.ogg','sound/voice/hiss4.ogg')
			if ("pageturn") soundin = pick('sound/effects/pageturn1.ogg', 'sound/effects/pageturn2.ogg','sound/effects/pageturn3.ogg')
			if ("fracture") soundin = pick('sound/effects/bonebreak1.ogg','sound/effects/bonebreak2.ogg','sound/effects/bonebreak3.ogg','sound/effects/bonebreak4.ogg')
			if ("canopen") soundin = pick('sound/effects/can_open1.ogg','sound/effects/can_open2.ogg','sound/effects/can_open3.ogg','sound/effects/can_open4.ogg')
			if ("mechstep") soundin = pick('sound/mecha/mechstep1.ogg', 'sound/mecha/mechstep2.ogg')
			if ("thunder") soundin = pick('sound/effects/thunder/thunder1.ogg', 'sound/effects/thunder/thunder2.ogg', 'sound/effects/thunder/thunder3.ogg', 'sound/effects/thunder/thunder4.ogg',
			'sound/effects/thunder/thunder5.ogg', 'sound/effects/thunder/thunder6.ogg', 'sound/effects/thunder/thunder7.ogg', 'sound/effects/thunder/thunder8.ogg', 'sound/effects/thunder/thunder9.ogg',
			'sound/effects/thunder/thunder10.ogg')
			if ("keyboard") soundin = pick('sound/effects/keyboard/keyboard1.ogg','sound/effects/keyboard/keyboard2.ogg','sound/effects/keyboard/keyboard3.ogg', 'sound/effects/keyboard/keyboard4.ogg')
			if ("button") soundin = pick('sound/machines/button1.ogg','sound/machines/button2.ogg','sound/machines/button3.ogg','sound/machines/button4.ogg')
			if ("switch") soundin = pick('sound/machines/switch1.ogg','sound/machines/switch2.ogg','sound/machines/switch3.ogg','sound/machines/switch4.ogg')
			if ("casing_sound") soundin = pick('sound/weapons/casingfall1.ogg','sound/weapons/casingfall2.ogg','sound/weapons/casingfall3.ogg')
			if ("pickaxe") soundin = pick('sound/weapons/mine/pickaxe1.ogg', 'sound/weapons/mine/pickaxe2.ogg','sound/weapons/mine/pickaxe3.ogg','sound/weapons/mine/pickaxe4.ogg')
			if("shatter")
				soundin = pick('sound/effects/Glassbr1.ogg','sound/effects/Glassbr2.ogg','sound/effects/Glassbr3.ogg')
			if("explosion")
				soundin = pick(
					'sound/effects/Explosion1.ogg',
					'sound/effects/Explosion2.ogg',
					'sound/effects/Explosion3.ogg',
					'sound/effects/Explosion4.ogg',
					'sound/effects/Explosion5.ogg',
					'sound/effects/Explosion6.ogg')
			if("sparks")
				soundin = pick(
					'sound/effects/sparks1.ogg',
					'sound/effects/sparks2.ogg',
					'sound/effects/sparks3.ogg',
					'sound/effects/sparks5.ogg',
					'sound/effects/sparks6.ogg',
					'sound/effects/sparks7.ogg')
			if("rustle")
				soundin = pick('sound/effects/rustle1.ogg','sound/effects/rustle2.ogg','sound/effects/rustle3.ogg','sound/effects/rustle4.ogg','sound/effects/rustle5.ogg')
			if("punch")
				soundin = pick('sound/weapons/punch1.ogg','sound/weapons/punch2.ogg','sound/weapons/punch3.ogg','sound/weapons/punch4.ogg')
			if("clownstep")
				soundin = pick('sound/effects/clownstep1.ogg','sound/effects/clownstep2.ogg')
			if("swing_hit")
				soundin = pick('sound/weapons/genhit1.ogg', 'sound/weapons/genhit2.ogg', 'sound/weapons/genhit3.ogg')
			if("hiss")
				soundin = pick('sound/voice/hiss1.ogg','sound/voice/hiss2.ogg','sound/voice/hiss3.ogg','sound/voice/hiss4.ogg')
			if("pageturn")
				soundin = pick('sound/effects/pageturn1.ogg', 'sound/effects/pageturn2.ogg','sound/effects/pageturn3.ogg')
			if("fracture")
				soundin = pick('sound/effects/bonebreak1.ogg','sound/effects/bonebreak2.ogg','sound/effects/bonebreak3.ogg','sound/effects/bonebreak4.ogg')
			if("canopen")
				soundin = pick('sound/effects/can_open1.ogg','sound/effects/can_open2.ogg','sound/effects/can_open3.ogg','sound/effects/can_open4.ogg')
			if("mechstep")
				soundin = pick('sound/mecha/mechstep1.ogg', 'sound/mecha/mechstep2.ogg')
			if("thunder")
				soundin = pick(
					'sound/effects/thunder/thunder1.ogg',
					'sound/effects/thunder/thunder2.ogg',
					'sound/effects/thunder/thunder3.ogg',
					'sound/effects/thunder/thunder4.ogg',
					'sound/effects/thunder/thunder5.ogg',
					'sound/effects/thunder/thunder6.ogg',
					'sound/effects/thunder/thunder7.ogg',
					'sound/effects/thunder/thunder8.ogg',
					'sound/effects/thunder/thunder9.ogg',
					'sound/effects/thunder/thunder10.ogg')
			if("keyboard")
				soundin = pick(
					'sound/effects/keyboard/keyboard1.ogg',
					'sound/effects/keyboard/keyboard2.ogg',
					'sound/effects/keyboard/keyboard3.ogg',
					'sound/effects/keyboard/keyboard4.ogg')
			if("button")
				soundin = pick('sound/machines/button1.ogg','sound/machines/button2.ogg','sound/machines/button3.ogg','sound/machines/button4.ogg')
			if("switch")
				soundin = pick('sound/machines/switch1.ogg','sound/machines/switch2.ogg','sound/machines/switch3.ogg','sound/machines/switch4.ogg')
			if("casing_sound")
				soundin = pick('sound/weapons/casingfall1.ogg','sound/weapons/casingfall2.ogg','sound/weapons/casingfall3.ogg')
			if("ricochet")
				soundin = pick(
					'sound/weapons/effects/ric1.ogg',
					'sound/weapons/effects/ric2.ogg',
					'sound/weapons/effects/ric3.ogg',
					'sound/weapons/effects/ric4.ogg',
					'sound/weapons/effects/ric5.ogg')
			if("bullet_miss")
				soundin = pick('sound/weapons/bulletflyby.ogg', 'sound/weapons/bulletflyby2.ogg', 'sound/weapons/bulletflyby3.ogg')
			if ("pickaxe")
				soundin = pick(
					'sound/weapons/mine/pickaxe1.ogg',
					'sound/weapons/mine/pickaxe2.ogg',
					'sound/weapons/mine/pickaxe3.ogg',
					'sound/weapons/mine/pickaxe4.ogg')
			//VORESTATION EDIT - vore sounds for better performance
			if ("hunger_sounds") soundin = pick('sound/vore/growl1.ogg','sound/vore/growl2.ogg','sound/vore/growl3.ogg','sound/vore/growl4.ogg','sound/vore/growl5.ogg')

			if("classic_digestion_sounds") soundin = pick(
					'sound/vore/digest1.ogg','sound/vore/digest2.ogg','sound/vore/digest3.ogg','sound/vore/digest4.ogg',
					'sound/vore/digest5.ogg','sound/vore/digest6.ogg','sound/vore/digest7.ogg','sound/vore/digest8.ogg',
					'sound/vore/digest9.ogg','sound/vore/digest10.ogg','sound/vore/digest11.ogg','sound/vore/digest12.ogg')
			if("classic_death_sounds") soundin = pick(
					'sound/vore/death1.ogg','sound/vore/death2.ogg','sound/vore/death3.ogg','sound/vore/death4.ogg','sound/vore/death5.ogg',
					'sound/vore/death6.ogg','sound/vore/death7.ogg','sound/vore/death8.ogg','sound/vore/death9.ogg','sound/vore/death10.ogg')
			if("classic_struggle_sounds") soundin = pick('sound/vore/squish1.ogg','sound/vore/squish2.ogg','sound/vore/squish3.ogg','sound/vore/squish4.ogg')

			if("fancy_prey_struggle") soundin = pick(
					'sound/vore/sunesound/prey/struggle_01.ogg','sound/vore/sunesound/prey/struggle_02.ogg','sound/vore/sunesound/prey/struggle_03.ogg',
					'sound/vore/sunesound/prey/struggle_04.ogg','sound/vore/sunesound/prey/struggle_05.ogg')
			if("fancy_digest_pred") soundin = pick(
					'sound/vore/sunesound/pred/digest_01.ogg','sound/vore/sunesound/pred/digest_02.ogg','sound/vore/sunesound/pred/digest_03.ogg',
					'sound/vore/sunesound/pred/digest_04.ogg','sound/vore/sunesound/pred/digest_05.ogg','sound/vore/sunesound/pred/digest_06.ogg',
					'sound/vore/sunesound/pred/digest_07.ogg','sound/vore/sunesound/pred/digest_08.ogg','sound/vore/sunesound/pred/digest_09.ogg',
					'sound/vore/sunesound/pred/digest_10.ogg','sound/vore/sunesound/pred/digest_11.ogg','sound/vore/sunesound/pred/digest_12.ogg',
					'sound/vore/sunesound/pred/digest_13.ogg','sound/vore/sunesound/pred/digest_14.ogg','sound/vore/sunesound/pred/digest_15.ogg',
					'sound/vore/sunesound/pred/digest_16.ogg','sound/vore/sunesound/pred/digest_17.ogg','sound/vore/sunesound/pred/digest_18.ogg')
			if("fancy_death_pred") soundin = pick(
					'sound/vore/sunesound/pred/death_01.ogg','sound/vore/sunesound/pred/death_02.ogg','sound/vore/sunesound/pred/death_03.ogg',
					'sound/vore/sunesound/pred/death_04.ogg','sound/vore/sunesound/pred/death_05.ogg','sound/vore/sunesound/pred/death_06.ogg',
					'sound/vore/sunesound/pred/death_07.ogg','sound/vore/sunesound/pred/death_08.ogg','sound/vore/sunesound/pred/death_09.ogg',
					'sound/vore/sunesound/pred/death_10.ogg')
			if("fancy_digest_prey") soundin = pick(
					'sound/vore/sunesound/prey/digest_01.ogg','sound/vore/sunesound/prey/digest_02.ogg','sound/vore/sunesound/prey/digest_03.ogg',
					'sound/vore/sunesound/prey/digest_04.ogg','sound/vore/sunesound/prey/digest_05.ogg','sound/vore/sunesound/prey/digest_06.ogg',
					'sound/vore/sunesound/prey/digest_07.ogg','sound/vore/sunesound/prey/digest_08.ogg','sound/vore/sunesound/prey/digest_09.ogg',
					'sound/vore/sunesound/prey/digest_10.ogg','sound/vore/sunesound/prey/digest_11.ogg','sound/vore/sunesound/prey/digest_12.ogg',
					'sound/vore/sunesound/prey/digest_13.ogg','sound/vore/sunesound/prey/digest_14.ogg','sound/vore/sunesound/prey/digest_15.ogg',
					'sound/vore/sunesound/prey/digest_16.ogg','sound/vore/sunesound/prey/digest_17.ogg','sound/vore/sunesound/prey/digest_18.ogg')
			if("fancy_death_prey") soundin = pick(
					'sound/vore/sunesound/prey/death_01.ogg','sound/vore/sunesound/prey/death_02.ogg','sound/vore/sunesound/prey/death_03.ogg',
					'sound/vore/sunesound/prey/death_04.ogg','sound/vore/sunesound/prey/death_05.ogg','sound/vore/sunesound/prey/death_06.ogg',
					'sound/vore/sunesound/prey/death_07.ogg','sound/vore/sunesound/prey/death_08.ogg','sound/vore/sunesound/prey/death_09.ogg',
					'sound/vore/sunesound/prey/death_10.ogg')
			if ("belches") soundin = pick(
					'sound/vore/belches/belch1.ogg','sound/vore/belches/belch2.ogg','sound/vore/belches/belch3.ogg','sound/vore/belches/belch4.ogg',
					'sound/vore/belches/belch5.ogg','sound/vore/belches/belch6.ogg','sound/vore/belches/belch7.ogg','sound/vore/belches/belch8.ogg',
					'sound/vore/belches/belch9.ogg','sound/vore/belches/belch10.ogg','sound/vore/belches/belch11.ogg','sound/vore/belches/belch12.ogg',
					'sound/vore/belches/belch13.ogg','sound/vore/belches/belch14.ogg','sound/vore/belches/belch15.ogg')
			//END VORESTATION EDIT
			if ("terminal_type")
				soundin = pick('sound/machines/terminal_button01.ogg', 'sound/machines/terminal_button02.ogg', 'sound/machines/terminal_button03.ogg', \
								'sound/machines/terminal_button04.ogg', 'sound/machines/terminal_button05.ogg', 'sound/machines/terminal_button06.ogg', \
								'sound/machines/terminal_button07.ogg', 'sound/machines/terminal_button08.ogg')
			if("smcalm")
				soundin = pick('sound/machines/sm/accent/normal/1.ogg', 'sound/machines/sm/accent/normal/2.ogg', 'sound/machines/sm/accent/normal/3.ogg', 'sound/machines/sm/accent/normal/4.ogg', 'sound/machines/sm/accent/normal/5.ogg', 'sound/machines/sm/accent/normal/6.ogg', 'sound/machines/sm/accent/normal/7.ogg', 'sound/machines/sm/accent/normal/8.ogg', 'sound/machines/sm/accent/normal/9.ogg', 'sound/machines/sm/accent/normal/10.ogg', 'sound/machines/sm/accent/normal/11.ogg', 'sound/machines/sm/accent/normal/12.ogg', 'sound/machines/sm/accent/normal/13.ogg', 'sound/machines/sm/accent/normal/14.ogg', 'sound/machines/sm/accent/normal/15.ogg', 'sound/machines/sm/accent/normal/16.ogg', 'sound/machines/sm/accent/normal/17.ogg', 'sound/machines/sm/accent/normal/18.ogg', 'sound/machines/sm/accent/normal/19.ogg', 'sound/machines/sm/accent/normal/20.ogg', 'sound/machines/sm/accent/normal/21.ogg', 'sound/machines/sm/accent/normal/22.ogg', 'sound/machines/sm/accent/normal/23.ogg', 'sound/machines/sm/accent/normal/24.ogg', 'sound/machines/sm/accent/normal/25.ogg', 'sound/machines/sm/accent/normal/26.ogg', 'sound/machines/sm/accent/normal/27.ogg', 'sound/machines/sm/accent/normal/28.ogg', 'sound/machines/sm/accent/normal/29.ogg', 'sound/machines/sm/accent/normal/30.ogg', 'sound/machines/sm/accent/normal/31.ogg', 'sound/machines/sm/accent/normal/32.ogg', 'sound/machines/sm/accent/normal/33.ogg', 'sound/machines/sm/supermatter1.ogg', 'sound/machines/sm/supermatter2.ogg', 'sound/machines/sm/supermatter3.ogg')
			if("smdelam")
				soundin = pick('sound/machines/sm/accent/delam/1.ogg', 'sound/machines/sm/accent/normal/2.ogg', 'sound/machines/sm/accent/normal/3.ogg', 'sound/machines/sm/accent/normal/4.ogg', 'sound/machines/sm/accent/normal/5.ogg', 'sound/machines/sm/accent/normal/6.ogg', 'sound/machines/sm/accent/normal/7.ogg', 'sound/machines/sm/accent/normal/8.ogg', 'sound/machines/sm/accent/normal/9.ogg', 'sound/machines/sm/accent/normal/10.ogg', 'sound/machines/sm/accent/normal/11.ogg', 'sound/machines/sm/accent/normal/12.ogg', 'sound/machines/sm/accent/normal/13.ogg', 'sound/machines/sm/accent/normal/14.ogg', 'sound/machines/sm/accent/normal/15.ogg', 'sound/machines/sm/accent/normal/16.ogg', 'sound/machines/sm/accent/normal/17.ogg', 'sound/machines/sm/accent/normal/18.ogg', 'sound/machines/sm/accent/normal/19.ogg', 'sound/machines/sm/accent/normal/20.ogg', 'sound/machines/sm/accent/normal/21.ogg', 'sound/machines/sm/accent/normal/22.ogg', 'sound/machines/sm/accent/normal/23.ogg', 'sound/machines/sm/accent/normal/24.ogg', 'sound/machines/sm/accent/normal/25.ogg', 'sound/machines/sm/accent/normal/26.ogg', 'sound/machines/sm/accent/normal/27.ogg', 'sound/machines/sm/accent/normal/28.ogg', 'sound/machines/sm/accent/normal/29.ogg', 'sound/machines/sm/accent/normal/30.ogg', 'sound/machines/sm/accent/normal/31.ogg', 'sound/machines/sm/accent/normal/32.ogg', 'sound/machines/sm/accent/normal/33.ogg', 'sound/machines/sm/supermatter1.ogg', 'sound/machines/sm/supermatter2.ogg', 'sound/machines/sm/supermatter3.ogg')
			if ("generic_drop")
				soundin = pick(
					'sound/items/drop/generic1.ogg',
					'sound/items/drop/generic2.ogg' )
			if ("generic_pickup")
				soundin = pick(
					'sound/items/pickup/generic1.ogg',
					'sound/items/pickup/generic2.ogg',
					'sound/items/pickup/generic3.ogg')
			if ("powerloaderstep")
				soundin = pick(
					'sound/effects/mech/powerloader_step.ogg',
					'sound/effects/mech/powerloader_step2.ogg')
	return soundin


//Are these even used?	//Yes
GLOBAL_LIST_INIT(keyboard_sound, list('sound/effects/keyboard/keyboard1.ogg','sound/effects/keyboard/keyboard2.ogg','sound/effects/keyboard/keyboard3.ogg', 'sound/effects/keyboard/keyboard4.ogg'))
GLOBAL_LIST_INIT(bodyfall_sound, list('sound/effects/bodyfall1.ogg','sound/effects/bodyfall2.ogg','sound/effects/bodyfall3.ogg','sound/effects/bodyfall4.ogg'))
GLOBAL_LIST_INIT(teppi_sound, list('sound/voice/teppi/gyooh1.ogg', 'sound/voice/teppi/gyooh2.ogg', 'sound/voice/teppi/gyooh3.ogg',  'sound/voice/teppi/gyooh4.ogg', 'sound/voice/teppi/gyooh5.ogg', 'sound/voice/teppi/gyooh6.ogg', 'sound/voice/teppi/snoot1.ogg', 'sound/voice/teppi/snoot2.ogg'))
GLOBAL_LIST_INIT(talk_sound, list('sound/talksounds/a.ogg','sound/talksounds/b.ogg','sound/talksounds/c.ogg','sound/talksounds/d.ogg','sound/talksounds/e.ogg','sound/talksounds/f.ogg','sound/talksounds/g.ogg','sound/talksounds/h.ogg'))
GLOBAL_LIST_INIT(emote_sound, list('sound/talksounds/me_a.ogg','sound/talksounds/me_b.ogg','sound/talksounds/me_c.ogg','sound/talksounds/me_d.ogg','sound/talksounds/me_e.ogg','sound/talksounds/me_f.ogg'))
GLOBAL_LIST_INIT(goon_speak_one_sound, list('sound/talksounds/goon/speak_1.ogg', 'sound/talksounds/goon/speak_1_ask.ogg', 'sound/talksounds/goon/speak_1_exclaim.ogg'))
GLOBAL_LIST_INIT(goon_speak_two_sound, list('sound/talksounds/goon/speak_2.ogg', 'sound/talksounds/goon/speak_2_ask.ogg', 'sound/talksounds/goon/speak_2_exclaim.ogg'))
GLOBAL_LIST_INIT(goon_speak_three_sound, list('sound/talksounds/goon/speak_3.ogg', 'sound/talksounds/goon/speak_3_ask.ogg', 'sound/talksounds/goon/speak_3_exclaim.ogg'))
GLOBAL_LIST_INIT(goon_speak_four_sound, list('sound/talksounds/goon/speak_4.ogg', 'sound/talksounds/goon/speak_4_ask.ogg', 'sound/talksounds/goon/speak_4_exclaim.ogg'))
GLOBAL_LIST_INIT(goon_speak_blub_sound, list('sound/talksounds/goon/blub.ogg', 'sound/talksounds/goon/blub_ask.ogg', 'sound/talksounds/goon/blub_exclaim.ogg'))
GLOBAL_LIST_INIT(goon_speak_bottalk_sound, list('sound/talksounds/goon/bottalk_1.ogg', 'sound/talksounds/goon/bottalk_2.ogg', 'sound/talksounds/goon/bottalk_3.ogg', 'sound/talksounds/goon/bottalk_4.wav'))
GLOBAL_LIST_INIT(goon_speak_buwoo_sound, list('sound/talksounds/goon/buwoo.ogg', 'sound/talksounds/goon/buwoo_ask.ogg', 'sound/talksounds/goon/buwoo_exclaim.ogg'))
GLOBAL_LIST_INIT(goon_speak_cow_sound, list('sound/talksounds/goon/cow.ogg', 'sound/talksounds/goon/cow_ask.ogg', 'sound/talksounds/goon/cow_exclaim.ogg'))
GLOBAL_LIST_INIT(goon_speak_lizard_sound, list('sound/talksounds/goon/lizard.ogg', 'sound/talksounds/goon/lizard_ask.ogg', 'sound/talksounds/goon/lizard_exclaim.ogg'))
GLOBAL_LIST_INIT(goon_speak_pug_sound, list('sound/talksounds/goon/pug.ogg', 'sound/talksounds/goon/pug_ask.ogg', 'sound/talksounds/goon/pug_exclaim.ogg'))
GLOBAL_LIST_INIT(goon_speak_pugg_sound, list('sound/talksounds/goon/pugg.ogg', 'sound/talksounds/goon/pugg_ask.ogg', 'sound/talksounds/goon/pugg_exclaim.ogg'))
GLOBAL_LIST_INIT(goon_speak_roach_sound, list('sound/talksounds/goon/roach.ogg', 'sound/talksounds/goon/roach_ask.ogg', 'sound/talksounds/goon/roach_exclaim.ogg'))
GLOBAL_LIST_INIT(goon_speak_skelly_sound, list('sound/talksounds/goon/skelly.ogg', 'sound/talksounds/goon/skelly_ask.ogg', 'sound/talksounds/goon/skelly_exclaim.ogg'))

GLOBAL_LIST_INIT(wf_speak_lure_sound, list ('sound/talksounds/wf/lure_1.ogg', 'sound/talksounds/wf/lure_2.ogg', 'sound/talksounds/wf/lure_3.ogg', 'sound/talksounds/wf/lure_4.ogg', 'sound/talksounds/wf/lure_5.ogg'))
GLOBAL_LIST_INIT(wf_speak_lyst_sound, list ('sound/talksounds/wf/lyst_1.ogg', 'sound/talksounds/wf/lyst_2.ogg', 'sound/talksounds/wf/lyst_3.ogg', 'sound/talksounds/wf/lyst_4.ogg', 'sound/talksounds/wf/lyst_5.ogg', 'sound/talksounds/wf/lyst_6.ogg'))
GLOBAL_LIST_INIT(wf_speak_void_sound, list ('sound/talksounds/wf/void_1.ogg', 'sound/talksounds/wf/void_2.ogg', 'sound/talksounds/wf/void_3.ogg'))
GLOBAL_LIST_INIT(wf_speak_vomva_sound, list ('sound/talksounds/wf/vomva_1.ogg', 'sound/talksounds/wf/vomva_2.ogg', 'sound/talksounds/wf/vomva_3.ogg', 'sound/talksounds/wf/vomva_4.ogg'))
GLOBAL_LIST_INIT(xeno_speak_sound, list('sound/talksounds/xeno/xenotalk.ogg', 'sound/talksounds/xeno/xenotalk2.ogg', 'sound/talksounds/xeno/xenotalk3.ogg'))

#define canine_sounds list("cough" = null, "sneeze" = null, "scream" = list('sound/voice/scream/canine/wolf_scream.ogg', 'sound/voice/scream/canine/wolf_scream2.ogg', 'sound/voice/scream/canine/wolf_scream3.ogg', 'sound/voice/scream/canine/wolf_scream4.ogg', 'sound/voice/scream/canine/wolf_scream5.ogg', 'sound/voice/scream/canine/wolf_scream6.ogg'), "pain" = list('sound/voice/pain/canine/wolf_pain.ogg', 'sound/voice/pain/canine/wolf_pain2.ogg', 'sound/voice/pain/canine/wolf_pain3.ogg', 'sound/voice/pain/canine/wolf_pain4.ogg'), "gasp" = list('sound/voice/gasp/canine/wolf_gasp.ogg'), "death" = list('sound/voice/death/canine/wolf_death1.ogg', 'sound/voice/death/canine/wolf_death2.ogg', 'sound/voice/death/canine/wolf_death3.ogg', 'sound/voice/death/canine/wolf_death4.ogg', 'sound/voice/death/canine/wolf_death5.ogg'))
#define feline_sounds list("cough" = null, "sneeze" = null, "scream" = list('sound/voice/scream/feline/feline_scream.ogg'), "pain" = list('sound/voice/pain/feline/feline_pain.ogg'), "gasp" = list('sound/voice/gasp/feline/feline_gasp.ogg'), "death" = list('sound/voice/death/feline/feline_death.ogg'))
#define cervine_sounds list("cough" = null, "sneeze" = null, "scream" = list('sound/voice/scream/cervine/cervine_scream.ogg'), "pain" = null, "gasp" = null, "death" = list('sound/voice/death/cervine/cervine_death.ogg'))
#define robot_sounds list("cough" = list('sound/effects/mob_effects/m_machine_cougha.ogg', 'sound/effects/mob_effects/m_machine_coughb.ogg', 'sound/effects/mob_effects/m_machine_coughc.ogg'), "sneeze" = list('sound/effects/mob_effects/machine_sneeze.ogg'), "scream" = list('sound/voice/scream_silicon.ogg', 'sound/voice/android_scream.ogg', 'sound/voice/scream/robotic/robot_scream1.ogg', 'sound/voice/scream/robotic/robot_scream2.ogg', 'sound/voice/scream/robotic/robot_scream3.ogg'), "pain" = list('sound/voice/pain/robotic/robot_pain1.ogg', 'sound/voice/pain/robotic/robot_pain2.ogg', 'sound/voice/pain/robotic/robot_pain3.ogg'), "gasp" = null, "death" = list('sound/voice/borg_deathsound.ogg'))
#define male_generic_sounds list("cough" = list('sound/effects/mob_effects/m_cougha.ogg','sound/effects/mob_effects/m_coughb.ogg', 'sound/effects/mob_effects/m_coughc.ogg'), "sneeze" = list('sound/effects/mob_effects/sneeze.ogg'), "scream" = list('sound/voice/scream/generic/male/male_scream_1.ogg', 'sound/voice/scream/generic/male/male_scream_2.ogg', 'sound/voice/scream/generic/male/male_scream_3.ogg', 'sound/voice/scream/generic/male/male_scream_4.ogg', 'sound/voice/scream/generic/male/male_scream_5.ogg', 'sound/voice/scream/generic/male/male_scream_6.ogg'), "pain" = list('sound/voice/pain/generic/male/male_pain_1.ogg', 'sound/voice/pain/generic/male/male_pain_2.ogg', 'sound/voice/pain/generic/male/male_pain_3.ogg', 'sound/voice/pain/generic/male/male_pain_4.ogg', 'sound/voice/pain/generic/male/male_pain_5.ogg', 'sound/voice/pain/generic/male/male_pain_6.ogg', 'sound/voice/pain/generic/male/male_pain_7.ogg', 'sound/voice/pain/generic/male/male_pain_8.ogg'), "gasp" = list('sound/voice/gasp/generic/male/male_gasp1.ogg', 'sound/voice/gasp/generic/male/male_gasp2.ogg', 'sound/voice/gasp/generic/male/male_gasp3.ogg'), "death" = list('sound/voice/death/generic/male/male_death_1.ogg', 'sound/voice/death/generic/male/male_death_2.ogg', 'sound/voice/death/generic/male/male_death_3.ogg', 'sound/voice/death/generic/male/male_death_4.ogg', 'sound/voice/death/generic/male/male_death_5.ogg', 'sound/voice/death/generic/male/male_death_6.ogg', 'sound/voice/death/generic/male/male_death_7.ogg'))
#define female_generic_sounds list("cough" = list('sound/effects/mob_effects/f_cougha.ogg','sound/effects/mob_effects/f_coughb.ogg'), "sneeze" = list('sound/effects/mob_effects/f_sneeze.ogg'), "scream" = list('sound/voice/scream/generic/female/female_scream_1.ogg', 'sound/voice/scream/generic/female/female_scream_2.ogg', 'sound/voice/scream/generic/female/female_scream_3.ogg', 'sound/voice/scream/generic/female/female_scream_4.ogg', 'sound/voice/scream/generic/female/female_scream_5.ogg'), "pain" = list('sound/voice/pain/generic/female/female_pain_1.ogg', 'sound/voice/pain/generic/female/female_pain_2.ogg', 'sound/voice/pain/generic/female/female_pain_3.ogg'), "gasp" = list('sound/voice/gasp/generic/female/female_gasp1.ogg', 'sound/voice/gasp/generic/female/female_gasp2.ogg'), "death" = list('sound/voice/death/generic/female/female_death_1.ogg', 'sound/voice/death/generic/female/female_death_2.ogg', 'sound/voice/death/generic/female/female_death_3.ogg', 'sound/voice/death/generic/female/female_death_4.ogg', 'sound/voice/death/generic/female/female_death_5.ogg', 'sound/voice/death/generic/female/female_death_6.ogg'))
#define spider_sounds list("cough" = null, "sneeze" = null, "scream" = list('sound/voice/spiderchitter.ogg'), "pain" = list('sound/voice/spiderchitter.ogg'), "gasp" = null, "death" = list('sound/voice/death/spider/spider_death.ogg'))
#define mouse_sounds list("cough" = list('sound/effects/mouse_squeak.ogg'), "sneeze" = list('sound/effects/mouse_squeak.ogg'), "scream" = list('sound/effects/mouse_squeak_loud.ogg'), "pain" = list('sound/effects/mouse_squeak.ogg'), "gasp" = list('sound/effects/mouse_squeak.ogg'), "death" = list('sound/effects/mouse_squeak_loud.ogg'))
#define lizard_sounds list("cough" = null, "sneeze" = null, "scream" = list('sound/effects/mob_effects/una_scream1.ogg','sound/effects/mob_effects/una_scream2.ogg'), "pain" = list('sound/voice/pain/lizard/lizard_pain.ogg'), "gasp" = null, "death" = list('sound/voice/death/lizard/lizard_death.ogg'))
#define vox_sounds list("cough" = list('sound/voice/shriekcough.ogg'), "sneeze" = list('sound/voice/shrieksneeze.ogg'), "scream" = list('sound/voice/shriek1.ogg'), "pain" = list('sound/voice/shriek1.ogg'), "gasp" = null, "death" = null)
#define slime_sounds list("cough" = list('sound/effects/slime_squish.ogg'), "sneeze" = null, "scream" = null, "pain" = null, "gasp" = null, "death" = null)
#define xeno_sounds list("cough" = null, "sneeze" = null, "scream" = list('sound/effects/mob_effects/x_scream1.ogg','sound/effects/mob_effects/x_scream2.ogg','sound/effects/mob_effects/x_scream3.ogg'), "pain" = list('sound/voice/pain/xeno/alien_roar1.ogg', 'sound/voice/pain/xeno/alien_roar2.ogg', 'sound/voice/pain/xeno/alien_roar3.ogg', 'sound/voice/pain/xeno/alien_roar4.ogg', 'sound/voice/pain/xeno/alien_roar5.ogg', 'sound/voice/pain/xeno/alien_roar6.ogg', 'sound/voice/pain/xeno/alien_roar7.ogg', 'sound/voice/pain/xeno/alien_roar8.ogg', 'sound/voice/pain/xeno/alien_roar9.ogg', 'sound/voice/pain/xeno/alien_roar10.ogg', 'sound/voice/pain/xeno/alien_roar11.ogg', 'sound/voice/pain/xeno/alien_roar12.ogg'), "gasp" = list('sound/voice/gasp/xeno/alien_hiss1.ogg'), "death" = list('sound/voice/death/xeno/xeno_death.ogg', 'sound/voice/death/xeno/xeno_death2.ogg'))
#define teshari_sounds list("cough" = list('sound/effects/mob_effects/tesharicougha.ogg','sound/effects/mob_effects/tesharicoughb.ogg'), "sneeze" = list('sound/effects/mob_effects/tesharisneeze.ogg'), "scream" = list('sound/effects/mob_effects/teshariscream.ogg'), "pain" = null, "gasp" = null, "death" = null)
#define raccoon_sounds list("cough" = null, "sneeze" = null, "scream" = list('sound/voice/raccoon.ogg'), "pain" = list('sound/voice/raccoon.ogg'), "gasp" = null, "death" = list('sound/voice/raccoon.ogg'))
#define metroid_sounds list("cough" = list('sound/metroid/metroid_cough.ogg'), "sneeze" = list('sound/metroid/metroid_sneeze.ogg'), "scream" = list('sound/metroid/metroid_scream.ogg'), "pain" = list('sound/metroid/metroidsee.ogg'), "gasp" = list('sound/metroid/metroid_gasp.ogg'), "death" = list('sound/metroid/metroiddeath.ogg'))
#define vulpine_sounds list("cough" = null, "sneeze" = null, "scream" = list('sound/voice/scream/vulpine/fox_yip1.ogg', 'sound/voice/scream/vulpine/fox_yip2.ogg', 'sound/voice/scream/vulpine/fox_yip3.ogg'), "pain" = list('sound/voice/pain/vulpine/fox_pain1.ogg', 'sound/voice/pain/vulpine/fox_pain2.ogg', 'sound/voice/pain/vulpine/fox_pain3.ogg', 'sound/voice/pain/vulpine/fox_pain4.ogg'), "gasp" = list('sound/voice/gasp/canine/wolf_gasp.ogg'), "death" = list('sound/voice/death/canine/wolf_death1.ogg', 'sound/voice/death/canine/wolf_death2.ogg', 'sound/voice/death/canine/wolf_death3.ogg', 'sound/voice/death/canine/wolf_death4.ogg', 'sound/voice/death/canine/wolf_death5.ogg'))
#define no_sounds list("cough" = null, "sneeze" = null, "scream" = null, "pain" = null, "gasp" = null, "death" = null)
#define use_default list("cough" = null, "sneeze" = null, "scream" = null, "pain" = null, "gasp" = null, "death" = null)
/*
 * TBD Sound Defines below
*/
/*
#define avian_sounds list(
	"scream" = list(),
	"pain" = list(),
	"gasp" = list(),
	"death" = list()
)
#define slime_sounds list(
	"scream" = list(),
	"pain" = list(),
	"gasp" = list(),
	"death" = list()
)
#define vulpine_sounds list(
	"scream" = list(),
	"pain" = list(),
	"gasp" = list(),
	"death" = list()
)
#define lizard_sounds list(
	"scream" = list(),
	"pain" = list(),
	"gasp" = list(),
	"death" = list()
)
*/

// Not sure we even really need this
// var/list/species_sounds = list()

// Global list containing all of our sound options.
var/list/species_sound_map = list(
	"Canine" = canine_sounds,
	"Cervine" = cervine_sounds,
	"Feline" = feline_sounds,
	"Human Male" = male_generic_sounds,
	"Human Female" = female_generic_sounds,
	"Lizard" = lizard_sounds,
	"Metroid" = metroid_sounds,
	"Mouse" = mouse_sounds,
	"Raccoon" = raccoon_sounds,
	"Robotic" = robot_sounds,
	"Slime" = slime_sounds,
	"Spider" = spider_sounds,
	"Teshari" = teshari_sounds,
	"Vox" = vox_sounds,
	"Vulpine" = vulpine_sounds,
	"Xeno" = xeno_sounds,
	"None" = no_sounds,
	"Unset" = use_default
)

/* // Not sure we even really need this
/hook/startup/proc/Init_species_sounds() // The entries we're checking over MUST have unique keys.
	for(var/i in species_sound_map)
		species_sounds |= species_sound_map[i]
	return 1
*/

/*
 * Call this for when you need a sound from an already-identified list - IE, "Canine". pick() cannot parse procs.
 * Indexes must be pre-calculated by the time it reaches here - for instance;
 * var/mob/living/M = user
 * get_species_sound(M.client.pref.species_sound)["scream"] will return get_species_sound("Robotic")["scream"]
 * This can be paired with get_gendered_sound, like so: get_species_sound(get_gendered_sound(M))["emote"] <- get_gendered_sound will return whatever we have of the 3 valid options, and then get_species_sound will match that to the actual sound list.
 * The get_species_sound proc will retrieve and return the list based on the key given - get_species_sound("Robotic")["scream"] will return list('sound/voice/scream_silicon.ogg', 'sound/voice/android_scream.ogg', etc)
 * If you are adding new calls of this, follow the syntax of get_species_sound(species)["scream"] - you must attach ["emote"] to the end, outside the ()
 * If your species has a gendered sound, DON'T PANIC. Simply set the gender_specific_species_sounds var on the species to true, and when you call this, do it like so:
 * get_species_sound(H.species.species_sounds_male)["emote"] // If we're male, and want an emote sound gendered correctly.
*/
/proc/get_species_sound(var/sounds)
	if(!islist(species_sound_map[sounds])) // We check here if this list actually has anything in it, or if we're about to return a null index
		return null // Shitty failsafe but better than rewriting an entire litany of procs rn when I'm low on time - Rykka // list('sound/voice/silence.ogg')
	return species_sound_map[sounds] // Otherwise, successfully return our sound

/*
 * The following helper proc will select a species' default sounds - useful for if we're set to "Unset"
 * This is ONLY called by Unset, meaning we haven't chosen a species sound.
*/
/proc/select_default_species_sound(var/datum/preferences/pref) // Called in character setup. This is similar to check_gendered_sounds, except here we pull from the prefs.
	// First, we determine if we're custom-choosing a body or if we're a base game species.
	var/datum/species/valid = GLOB.all_species[pref.species]
	if(valid.selects_bodytype == (SELECTS_BODYTYPE_CUSTOM || SELECTS_BODYTYPE_SHAPESHIFTER)) // Custom species or xenochimera handling here
		valid = coalesce(GLOB.all_species[pref.custom_base], GLOB.all_species[pref.species])
	// Now we start getting our sounds.
	if(valid.gender_specific_species_sounds) // Do we have gender-specific sounds?
		if(pref.identifying_gender == FEMALE && valid.species_sounds_female)
			return valid.species_sounds_female
		else if(pref.identifying_gender == MALE && valid.species_sounds_male)
			return valid.species_sounds_male
		else // Failsafe. Update if there's ever gendered sounds for HERM/Neuter/etc
			return valid.species_sounds
	else
		return valid.species_sounds

/proc/get_gendered_sound(var/mob/living/user) // Called anywhere we need gender-specific species sounds. Gets the gender-specific sound if one exists, but otherwise, will return the species-generic sound list.
	var/mob/living/carbon/human/H = user
	if(ishuman(H))
		if(H.species.gender_specific_species_sounds) // Do we have gender-specific sounds?
			if(H.identifying_gender == FEMALE && H.species.species_sounds_female)
				return H.species.species_sounds_female
			else if(H.identifying_gender == MALE && H.species.species_sounds_male)
				return H.species.species_sounds_male
			else // Failsafe. Update if there's ever gendered sounds for HERM/Neuter/etc
				return H.species.species_sounds
		else
			return H.species.species_sounds
	else
		return user.species_sounds
