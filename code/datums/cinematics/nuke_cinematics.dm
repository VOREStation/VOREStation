/// Simple, base cinematic for all animations based around a nuke detonating.
/datum/cinematic/nuke
	/// If set, this is the summary screen that pops up after the nuke is done.
	var/after_nuke_summary_state


/datum/cinematic/nuke/play_cinematic()
	flick("intro_nuke", screen)
	stoplag(3.5 SECONDS)
	play_nuke_effect()
	if(special_callback)
		special_callback.Invoke()
	if(after_nuke_summary_state)
		screen.icon_state = after_nuke_summary_state

/// Specific effects for each type of cinematics goes here.
/datum/cinematic/nuke/proc/play_nuke_effect()
	return

/// The syndicate nuclear bomb was activated, and destroyed the station!
/datum/cinematic/nuke/ops_victory
	after_nuke_summary_state = "summary_nukewin"

/datum/cinematic/nuke/ops_victory/play_nuke_effect()
	flick("station_explode_fade_red", screen)
	play_cinematic_sound(sound('sound/effects/explosionfar.ogg'))

/// The syndicate nuclear bomb was activated, but just barely missed the station!
/datum/cinematic/nuke/ops_miss
	after_nuke_summary_state = "summary_nukefail"

/datum/cinematic/nuke/ops_miss/play_nuke_effect()
	flick("station_intact_fade_red", screen)
	play_cinematic_sound(sound('sound/effects/explosionfar.ogg'))

/// The self destruct, or another station-destroying entity like a blob, destroyed the station!
/datum/cinematic/nuke/self_destruct
	after_nuke_summary_state = "summary_selfdes"

/datum/cinematic/nuke/self_destruct/play_nuke_effect()
	flick("station_explode_fade_red", screen)
	play_cinematic_sound(sound('sound/effects/explosionfar.ogg'))

/// The self destruct was activated, yet somehow avoided destroying the station!
/datum/cinematic/nuke/self_destruct_miss
	after_nuke_summary_state = "station_intact"

/datum/cinematic/nuke/self_destruct_miss/play_nuke_effect()
	play_cinematic_sound(sound('sound/effects/explosionfar.ogg'))
	special_callback?.Invoke()

/// The syndicate nuclear bomb was activated, but just missed the station by a whole z-level!
/datum/cinematic/nuke/far_explosion
	cleanup_time = 0 SECONDS

/datum/cinematic/nuke/far_explosion/play_cinematic()
	// This one has no intro sequence.
	// It's actually just a global sound, which makes you wonder why it's a cinematic.
	play_cinematic_sound(sound('sound/effects/explosionfar.ogg'))
	special_callback?.Invoke()

/*
/datum/controller/subsystem/ticker/proc/station_explosion_cinematic(var/station_missed=0, var/override = null)
	if( cinematic )	return	//already a cinematic in progress!

	//initialise our cinematic screen object
	cinematic = new(src)
	cinematic.icon = 'icons/effects/station_explosion.dmi'
	cinematic.icon_state = "station_intact"
	cinematic.layer = 100
	cinematic.plane = PLANE_PLAYER_HUD
	cinematic.mouse_opacity = 0
	cinematic.screen_loc = "1,0"

	var/obj/structure/bed/temp_buckle = new(src)
	//Incredibly hackish. It creates a bed within the gameticker (lol) to stop mobs running around
	if(station_missed)
		for(var/mob/living/M in living_mob_list)
			M.buckled = temp_buckle				//buckles the mob so it can't do anything
			if(M.client)
				M.client.screen += cinematic	//show every client the cinematic
	else	//nuke kills everyone on z-level 1 to prevent "hurr-durr I survived"
		for(var/mob/living/M in living_mob_list)
			M.buckled = temp_buckle
			if(M.client)
				M.client.screen += cinematic

			switch(M.z)
				if(0)	//inside a crate or something
					var/turf/T = get_turf(M)
					if(T && (T.z in using_map.station_levels))				//we don't use M.death(0) because it calls a for(/mob) loop and
						M.health = 0
						M.set_stat(DEAD)
				if(1)	//on a z-level 1 turf.
					M.health = 0
					M.set_stat(DEAD)

	//Now animate the cinematic
	switch(station_missed)
		if(1)	//nuke was nearby but (mostly) missed
			if( mode && !override )
				override = mode.name
			switch( override )
				if("mercenary") //Nuke wasn't on station when it blew up
					flick("intro_nuke",cinematic)
					sleep(35)
					world << sound('sound/effects/explosionfar.ogg')
					flick("station_intact_fade_red",cinematic)
					cinematic.icon_state = "summary_nukefail"
				else
					flick("intro_nuke",cinematic)
					sleep(35)
					world << sound('sound/effects/explosionfar.ogg')
					//flick("end",cinematic)


		if(2)	//nuke was nowhere nearby	//TODO: a really distant explosion animation
			sleep(50)
			world << sound('sound/effects/explosionfar.ogg')


		else	//station was destroyed
			if( mode && !override )
				override = mode.name
			switch( override )
				if("mercenary") //Nuke Ops successfully bombed the station
					flick("intro_nuke",cinematic)
					sleep(35)
					flick("station_explode_fade_red",cinematic)
					world << sound('sound/effects/explosionfar.ogg')
					cinematic.icon_state = "summary_nukewin"
				if("AI malfunction") //Malf (screen,explosion,summary)
					flick("intro_malf",cinematic)
					sleep(76)
					flick("station_explode_fade_red",cinematic)
					world << sound('sound/effects/explosionfar.ogg')
					cinematic.icon_state = "summary_malf"
				if("blob") //Station nuked (nuke,explosion,summary)
					flick("intro_nuke",cinematic)
					sleep(35)
					flick("station_explode_fade_red",cinematic)
					world << sound('sound/effects/explosionfar.ogg')
					cinematic.icon_state = "summary_selfdes"
				else //Station nuked (nuke,explosion,summary)
					flick("intro_nuke",cinematic)
					sleep(35)
					flick("station_explode_fade_red", cinematic)
					world << sound('sound/effects/explosionfar.ogg')
					cinematic.icon_state = "summary_selfdes"
			for(var/mob/living/M in living_mob_list)
				if(M.loc.z in using_map.station_levels)
					M.death()//No mercy
	//If its actually the end of the round, wait for it to end.
	//Otherwise if its a verb it will continue on afterwards.
	sleep(300)

	if(cinematic)	qdel(cinematic)		//end the cinematic
	if(temp_buckle)	qdel(temp_buckle)	//release everybody
	return
*/
