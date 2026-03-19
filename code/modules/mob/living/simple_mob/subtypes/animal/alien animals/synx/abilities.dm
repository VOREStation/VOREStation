//////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////// POWERS!!!! /////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////

/mob/living/simple_mob/animal/synx/Initialize(mapload, is_pet) //this is really cool. Should be able to ventcrawl canonicaly, contort, and make random speech.
//some things should be here that arent tho.
	. = ..()
	if(is_pet)
		return
	add_verb(src,/mob/living/proc/ventcrawl)
	add_verb(src,/mob/living/simple_mob/animal/synx/proc/distend_stomach)
	add_verb(src,/mob/living/simple_mob/proc/contort)
	add_verb(src,/mob/living/simple_mob/animal/synx/proc/sonar_ping)
	add_verb(src,/mob/living/proc/shred_limb)
	add_verb(src,/mob/living/simple_mob/animal/synx/proc/disguise)
	add_verb(src,/mob/living/simple_mob/animal/synx/proc/randomspeech)
	add_verb(src,/mob/living/simple_mob/animal/synx/proc/set_style)
	realname = name
	voices += "Garbled voice"
	voices += "Unidentifiable Voice"
	speak += "Who is there?"
	speak += "What is that thing?!"


/mob/living/simple_mob/proc/contort()
	set name = "contort"
	set desc = "Allows to hide beneath tables or certain items. Toggled on or off."
	set category = "Abilities.Synx"

	if(stat == DEAD || paralysis || weakened || stunned || restrained())
		return

	if(status_flags & HIDING)
		status_flags &= ~HIDING
		reset_plane_and_layer()
		to_chat(src,span_notice("You have stopped hiding."))
	else
		status_flags |= HIDING
		layer = HIDING_LAYER //Just above cables with their 2.44
		plane = OBJ_PLANE
		to_chat(src,span_notice("You are now hiding."))


	update_icons()

/mob/living/simple_mob/animal/synx/proc/disguise()
	set name = "Toggle Form"
	set desc = "Switch between amorphous and humanoid forms."
	set category = "Abilities.Synx"

	if(stat == DEAD || paralysis || weakened || stunned || restrained())
		return

	// If transform isn't true
	if(stomach_distended)
		to_chat(src,span_warning("You can't disguise with your stomach outside of your body!"))
		return
	if(!transformed)
		to_chat(src,span_warning("Now they see your true form."))
		icon_living = transformed_state //Switch state to transformed state
		movement_cooldown = 3
	else // If transformed is true.
		to_chat(src,span_warning("You changed back into your disguise."))
		icon_living = initial(icon_living) //Switch state to what it was originally defined.
		movement_cooldown = 6


	transformed = !transformed
	update_icons()

/mob/living/simple_mob/animal/synx/proc/randomspeech()
	set name = "speak"
	set desc = "Take a sentence you heard and speak it."
	set category = "Abilities.Synx"
	if(speak && voices)
		handle_mimic()
	else
		usr << span_warning("YOU NEED TO HEAR THINGS FIRST, try using Ventcrawl to eevesdrop on nerds.")

/mob/living/simple_mob/animal/synx/proc/handle_mimic()
	name = pick(voices)
	spawn(2)
		src.say(pick(speak))
	spawn(5)
		name = realname

//lo- procs adjusted to mobs.

/mob/living/simple_mob/animal/synx
	var/next_sonar_ping = 0

/mob/living/simple_mob/animal/synx/proc/sonar_ping()
	set name = "Listen In"
	set desc = "Allows you to listen in to movement and noises around you."
	set category = "Abilities.Synx"

	if(incapacitated())
		to_chat(src, span_warning("You need to recover before you can use this ability."))
		return
	if(world.time < next_sonar_ping)
		to_chat(src, span_warning("You need another moment to focus."))
		return
	if(is_deaf() || is_below_sound_pressure(get_turf(src)))
		to_chat(src, span_warning("You are for all intents and purposes currently deaf!"))
		return
	next_sonar_ping = world.time + 10 SECONDS
	var/heard_something = FALSE
	to_chat(src, span_notice("You take a moment to listen in to your environment..."))
	for(var/mob/living/L in range(client.view, src))
		var/turf/T = get_turf(L)
		if(!T || L == src || L.stat == DEAD || is_below_sound_pressure(T))
			continue
		heard_something = TRUE
		var/feedback = list()
		feedback += "There are noises of movement "
		var/direction = get_dir(src, L)
		if(direction)
			feedback += "towards the [dir2text(direction)], "
			switch(get_dist(src, L) / client.view)
				if(0 to 0.2)
					feedback += "very close by."
				if(0.2 to 0.4)
					feedback += "close by."
				if(0.4 to 0.6)
					feedback += "some distance away."
				if(0.6 to 0.8)
					feedback += "further away."
				else
					feedback += "far away."
		else // No need to check distance if they're standing right on-top of us
			feedback += "right on top of you."
		to_chat(src,span_notice(jointext(feedback,null)))
	if(!heard_something)
		to_chat(src, span_notice("You hear no movement but your own."))


/mob/living/simple_mob/animal/synx/proc/distend_stomach()
	set name = "Distend Stomach"
	set desc = "Allows you to throw up your stomach, giving your attacks burn damage at the cost of your stomach contents going everywhere. Yuck."
	set category = "Abilities.Synx"

	if(transformed)
		to_chat(src,span_warning("Your limbs are in the way!")) //Kind of a weak excuse but since you already can't transform when your stomach is out, this avoids situations calling a sprite that doesn't exist and lightens my workload on making and implementing them
		return

	if(!stomach_distended && !transformed) //true if stomach distended is null, 0, or ""
		stomach_distended = !stomach_distended //switch statement
		to_chat (src, span_notice("You disgorge your stomach, spilling its contents!"))
		melee_damage_lower = 1 //Hopefully this will make all brute damage not apply while stomach is distended. I don't see a better way to do this.
		melee_damage_upper = 1
		icon_living = stomach_distended_state
		attack_armor_type = "bio" //apply_melee_effects should handle all burn damage code so this might not be necessary.
		attacktext += distend_attacktext
		attacktext -= initial_attacktext

		for(var/belly in src.vore_organs) //Spit out all contents because our insides are now outsides
			var/obj/belly/B = belly
			for(var/atom/movable/A in B)
				playsound(src, 'sound/effects/splat.ogg', 50, 1)
				B.release_specific_contents(A)
		update_icons()
		return

	if(stomach_distended) //If our stomach has been vomitted
		stomach_distended = !stomach_distended
		to_chat (src, span_notice("You swallow your insides!"))
		melee_damage_lower = SYNX_LOWER_DAMAGE //This is why I'm using a define
		melee_damage_upper = SYNX_UPPER_DAMAGE
		icon_living = initial(icon_living)
		attack_armor_type = "melee"
		attacktext += initial_attacktext
		attacktext -= distend_attacktext
		update_icons()
		return
