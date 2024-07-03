/mob/living/Life()
	set invisibility = 0
	set background = BACKGROUND_ENABLED

	..()

	if (transforming)
		return
	handle_modifiers() //VOREStation Edit - Needs to be done even if in nullspace.
	if(!loc)
		return

	var/datum/gas_mixture/environment
	if(isbelly(loc))
		environment = loc.return_air_for_internal_lifeform(src)
	else
		environment = loc.return_air()

	//handle_modifiers() // Do this early since it might affect other things later. //VOREStation Edit

	handle_light()

	if(stat != DEAD)
		//Breathing, if applicable
		handle_breathing()

		//Mutations and radiation
		handle_mutations_and_radiation()



		//Blood
		handle_blood()

		//Random events (vomiting etc)
		handle_random_events()

		. = 1

		if(client)
			var/idle_limit = 10 MINUTES
			if(client.inactivity >= idle_limit && !away_from_keyboard && src.is_preference_enabled(/datum/client_preference/auto_afk))	//if we're not already afk and we've been idle too long, and we have automarking enabled... then automark it
				add_status_indicator("afk")
				to_chat(src, "<span class='notice'>You have been idle for too long, and automatically marked as AFK.</span>")
				away_from_keyboard = TRUE
			else if(away_from_keyboard && client.inactivity < idle_limit && !manual_afk) //if we're afk but we do something AND we weren't manually flagged as afk, unmark it
				remove_status_indicator("afk")
				to_chat(src, "<span class='notice'>You have been automatically un-marked as AFK.</span>")
				away_from_keyboard = FALSE

	//Chemicals in the body, this is moved over here so that blood can be added after death
	handle_chemicals_in_body()

	//Handle temperature/pressure differences between body and environment
	if(environment)
		handle_environment(environment)

	//Check if we're on fire
	handle_fire()

	if(client && !(client.prefs.ambience_freq == 0))	// Handle re-running ambience to mobs if they've remained in an area, AND have an active client assigned to them, and do not have repeating ambience disabled.
		handle_ambience()

	//stuff in the stomach
	//handle_stomach() //VOREStation Code

	update_gravity(mob_has_gravity())

	update_pulling()

	for(var/obj/item/weapon/grab/G in src)
		G.process()

	if(handle_regular_status_updates()) // Status & health update, are we dead or alive etc.
		handle_disabilities() // eye, ear, brain damages
		handle_statuses() //all special effects, stunned, weakened, jitteryness, hallucination, sleeping, etc

	handle_actions()

	update_canmove()

	handle_regular_hud_updates()

	handle_vision()

	handle_tf_holder()	//VOREStation Addition

/mob/living/proc/handle_breathing()
	return

/mob/living/proc/handle_mutations_and_radiation()
	return

/mob/living/proc/handle_chemicals_in_body()
	return

/mob/living/proc/handle_blood()
	return

/mob/living/proc/handle_random_events()
	return

/mob/living/proc/handle_environment(var/datum/gas_mixture/environment)
	return

/mob/living/proc/handle_stomach()
	return

/mob/living/proc/handle_ambience() // If you're in an ambient area and have not moved out of it for x time as configured per-client, and do not have it disabled, we're going to play ambience again to you, to help break up the silence.
	if(world.time >= (lastareachange + client.prefs.ambience_freq MINUTES)) // Every 5 minutes (by default, set per-client), we're going to run a 35% chance (by default, also set per-client) to play ambience.
		var/area/A = get_area(src)
		if(A)
			lastareachange = world.time // This will refresh the last area change to prevent this call happening LITERALLY every life tick.
			A.play_ambience(src, initial = FALSE)

/mob/living/proc/update_pulling()
	if(pulling)
		if(incapacitated())
			stop_pulling()

//This updates the health and status of the mob (conscious, unconscious, dead)
/mob/living/proc/handle_regular_status_updates()
	updatehealth()
	if(stat != DEAD)
		if(paralysis)
			set_stat(UNCONSCIOUS)
		else if (status_flags & FAKEDEATH)
			set_stat(UNCONSCIOUS)
		else
			set_stat(CONSCIOUS)
		return 1

/mob/living/proc/handle_statuses()
	handle_stunned()
	handle_weakened()
	handle_paralysed()
	handle_stuttering()
	handle_silent()
	handle_drugged()
	handle_slurring()
	handle_confused()
	handle_sleeping()

/mob/living/proc/handle_stunned()
	if(stunned)
		AdjustStunned(-1)
		throw_alert("stunned", /obj/screen/alert/stunned)
	else
		clear_alert("stunned")
	return stunned

/mob/living/proc/handle_weakened()
	if(weakened)
		AdjustWeakened(-1)
		throw_alert("weakened", /obj/screen/alert/weakened)
	else
		clear_alert("weakened")
	return weakened

/mob/living/proc/handle_stuttering()
	if(stuttering)
		stuttering = max(stuttering-1, 0)
	return stuttering

/mob/living/proc/handle_silent()
	if(silent)
		silent = max(silent-1, 0)
	return silent

/mob/living/proc/handle_drugged()
	if(druggy)
		druggy = max(druggy-1, 0)
		throw_alert("high", /obj/screen/alert/high)
	else
		clear_alert("high")
	return druggy

/mob/living/proc/handle_slurring()
	if(slurring)
		slurring = max(slurring-1, 0)
	return slurring

/mob/living/proc/handle_paralysed()
	if(paralysis)
		AdjustParalysis(-1)
		throw_alert("paralyzed", /obj/screen/alert/paralyzed)
	else
		clear_alert("paralyzed")
	return paralysis

/mob/living/proc/handle_confused()
	if(confused)
		AdjustConfused(-1)
		throw_alert("confused", /obj/screen/alert/confused)
	else
		clear_alert("confused")
	return confused

/mob/living/proc/handle_disabilities()
	//Eyes
	if(sdisabilities & BLIND || stat)	//blindness from disability or unconsciousness doesn't get better on its own
		SetBlinded(1)
		throw_alert("blind", /obj/screen/alert/blind)
	else if(eye_blind)			//blindness, heals slowly over time
		AdjustBlinded(-1)
		throw_alert("blind", /obj/screen/alert/blind)
	else
		clear_alert("blind")

	if(eye_blurry)			//blurry eyes heal slowly
		eye_blurry = max(eye_blurry-1, 0)

	//Ears
	if(sdisabilities & DEAF)		//disabled-deaf, doesn't get better on its own
		setEarDamage(-1, max(ear_deaf, 1))
	else
		// deafness heals slowly over time, unless ear_damage is over 100
		if(ear_damage < 100)
			adjustEarDamage(-0.05,-1)

/mob/living/handle_regular_hud_updates()
	if(!client)
		return 0
	..()

	handle_darksight()
	handle_hud_icons()

	return 1

/mob/living/proc/update_sight()
	if(!seedarkness)
		see_invisible = SEE_INVISIBLE_NOLIGHTING
	else
		see_invisible = initial(see_invisible)

	sight = initial(sight)

	for(var/datum/modifier/M in modifiers)
		if(!isnull(M.vision_flags))
			sight |= M.vision_flags

	return

/mob/living/proc/handle_hud_icons()
	handle_hud_icons_health()
	return

/mob/living/proc/handle_hud_icons_health()
	return

/mob/living/proc/handle_light()
	if(glow_override)
		return FALSE

	if(instability >= TECHNOMANCER_INSTABILITY_MIN_GLOW)
		var/distance = round(sqrt(instability / 2))
		if(distance)
			set_light(distance, distance * 4, l_color = "#660066")
			return TRUE

	else if(glow_toggle)
		set_light(glow_range, glow_intensity, glow_color)

	else
		set_light(0)
		return FALSE

/mob/living/proc/handle_darksight()
	if(!seedarkness) //Cheap 'always darksight' var
		dsoverlay.alpha = 255
		return

	var/darksightedness = min(see_in_dark/world.view,1.0)	//A ratio of how good your darksight is, from 'nada' to 'really darn good'
	var/current = dsoverlay.alpha/255						//Our current adjustedness

	var/brightness = 0.0 //We'll assume it's superdark if we can't find something else.

	if(isturf(loc))
		var/turf/T = loc //Will be true 99% of the time, thus avoiding the whole elif chain
		brightness = T.get_lumcount()

	//Snowflake treatment of potential locations
	else if(istype(loc,/obj/mecha)) //I imagine there's like displays and junk in there. Use the lights!
		brightness = 1
	else if(istype(loc,/obj/item/weapon/holder)) //Poor carried teshari and whatnot should adjust appropriately
		var/turf/T = get_turf(src)
		brightness = T.get_lumcount()

	var/darkness = 1-brightness					//Silly, I know, but 'alpha' and 'darkness' go the same direction on a number line
	var/adjust_to = min(darkness,darksightedness)//Capped by how darksighted they are
	var/distance = abs(current-adjust_to)		//Used for how long to animate for
	if(distance < 0.01) return					//We're already all set

	//to_world("[src] in B:[round(brightness,0.1)] C:[round(current,0.1)] A2:[round(adjust_to,0.1)] D:[round(distance,0.01)] T:[round(distance*10 SECONDS,0.1)]")
	animate(dsoverlay, alpha = (adjust_to*255), time = (distance*10 SECONDS))

/mob/living/proc/handle_sleeping()
	if(stat != DEAD && toggled_sleeping)
		Sleeping(2)
	if(sleeping)
		set_stat(UNCONSCIOUS)
		AdjustSleeping(-1)
		throw_alert("asleep", /obj/screen/alert/asleep)
	else
		set_stat(CONSCIOUS)
		clear_alert("asleep")
	return sleeping
