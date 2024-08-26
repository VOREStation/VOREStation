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
	if(!ignore_walls) //these sounds don't carry through walls
		for(var/mob/listen in listeners)
			if(!(get_turf(listen) in hear(maxdistance,source)))
				listeners -= listen
	for(var/mob/M as anything in listeners)
		if(!M || !M.client)
			continue
		var/turf/T = get_turf(M)
		if(!T)
			continue
		var/area/A = T.loc
		if((A.soundproofed || area_source.soundproofed) && (A != area_source))
			continue
		var/distance = get_dist(T, turf_source)

		if(distance <= maxdistance)
			if(T && T.z == turf_source.z)
				M.playsound_local(turf_source, soundin, vol, vary, frequency, falloff, is_global, channel, pressure_affected, S, preference, volume_channel)

/mob/proc/check_sound_preference(list/preference)
	if(!islist(preference))
		preference = list(preference)

	for(var/p in preference)
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

	if(vary)
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
		media.push_music(T.url, world.time, 0.85)
		to_chat(src,"<span class='notice'>Lobby music: <b>[T.title]</b> by <b>[T.artist]</b>.</span>")

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
	return soundin

//Are these even used?	//Yes
var/list/keyboard_sound = list ('sound/effects/keyboard/keyboard1.ogg','sound/effects/keyboard/keyboard2.ogg','sound/effects/keyboard/keyboard3.ogg', 'sound/effects/keyboard/keyboard4.ogg')
var/list/bodyfall_sound = list('sound/effects/bodyfall1.ogg','sound/effects/bodyfall2.ogg','sound/effects/bodyfall3.ogg','sound/effects/bodyfall4.ogg')
var/list/teppi_sound = list('sound/voice/teppi/gyooh1.ogg', 'sound/voice/teppi/gyooh2.ogg', 'sound/voice/teppi/gyooh3.ogg',  'sound/voice/teppi/gyooh4.ogg', 'sound/voice/teppi/gyooh5.ogg', 'sound/voice/teppi/gyooh6.ogg', 'sound/voice/teppi/snoot1.ogg', 'sound/voice/teppi/snoot2.ogg')
var/list/talk_sound = list('sound/talksounds/a.ogg','sound/talksounds/b.ogg','sound/talksounds/c.ogg','sound/talksounds/d.ogg','sound/talksounds/e.ogg','sound/talksounds/f.ogg','sound/talksounds/g.ogg','sound/talksounds/h.ogg')
var/list/emote_sound = list('sound/talksounds/me_a.ogg','sound/talksounds/me_b.ogg','sound/talksounds/me_c.ogg','sound/talksounds/me_d.ogg','sound/talksounds/me_e.ogg','sound/talksounds/me_f.ogg')

//Goon sounds
var/list/goon_speak_one_sound = list('sound/talksounds/goon/speak_1.ogg', 'sound/talksounds/goon/speak_1_ask.ogg', 'sound/talksounds/goon/speak_1_exclaim.ogg')
var/list/goon_speak_two_sound = list('sound/talksounds/goon/speak_2.ogg', 'sound/talksounds/goon/speak_2_ask.ogg', 'sound/talksounds/goon/speak_2_exclaim.ogg')
var/list/goon_speak_three_sound = list('sound/talksounds/goon/speak_3.ogg', 'sound/talksounds/goon/speak_3_ask.ogg', 'sound/talksounds/goon/speak_3_exclaim.ogg')
var/list/goon_speak_four_sound = list('sound/talksounds/goon/speak_4.ogg', 'sound/talksounds/goon/speak_4_ask.ogg', 'sound/talksounds/goon/speak_4_exclaim.ogg')
var/list/goon_speak_blub_sound = list('sound/talksounds/goon/blub.ogg', 'sound/talksounds/goon/blub_ask.ogg', 'sound/talksounds/goon/blub_exclaim.ogg')
var/list/goon_speak_bottalk_sound = list('sound/talksounds/goon/bottalk_1.ogg', 'sound/talksounds/goon/bottalk_2.ogg', 'sound/talksounds/goon/bottalk_3.ogg', 'sound/talksounds/goon/bottalk_4.wav')
var/list/goon_speak_buwoo_sound = list('sound/talksounds/goon/buwoo.ogg', 'sound/talksounds/goon/buwoo_ask.ogg', 'sound/talksounds/goon/buwoo_exclaim.ogg')
var/list/goon_speak_cow_sound = list('sound/talksounds/goon/cow.ogg', 'sound/talksounds/goon/cow_ask.ogg', 'sound/talksounds/goon/cow_exclaim.ogg')
var/list/goon_speak_lizard_sound = list('sound/talksounds/goon/lizard.ogg', 'sound/talksounds/goon/lizard_ask.ogg', 'sound/talksounds/goon/lizard_exclaim.ogg')
var/list/goon_speak_pug_sound = list('sound/talksounds/goon/pug.ogg', 'sound/talksounds/goon/pug_ask.ogg', 'sound/talksounds/goon/pug_exclaim.ogg')
var/list/goon_speak_pugg_sound = list('sound/talksounds/goon/pugg.ogg', 'sound/talksounds/goon/pugg_ask.ogg', 'sound/talksounds/goon/pugg_exclaim.ogg')
var/list/goon_speak_roach_sound = list('sound/talksounds/goon/roach.ogg', 'sound/talksounds/goon/roach_ask.ogg', 'sound/talksounds/goon/roach_exclaim.ogg')
var/list/goon_speak_skelly_sound = list('sound/talksounds/goon/skelly.ogg', 'sound/talksounds/goon/skelly_ask.ogg', 'sound/talksounds/goon/skelly_exclaim.ogg')
