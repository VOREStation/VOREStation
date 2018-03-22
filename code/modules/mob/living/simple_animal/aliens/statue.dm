// A mob which only moves when it isn't being watched by living beings.
//SCP - 173 hype
//Horrible shitcoding and stolen code adaptations below. You have been warned.

/mob/living/simple_animal/hostile/statue
	name = "statue" // matches the name of the statue with the flesh-to-stone spell
	desc = "An incredibly lifelike marble carving. Its eyes seems to follow you..." // same as an ordinary statue with the added "eye following you" description
	icon = 'icons/obj/statue.dmi'
	icon_state = "human_male"
	icon_living = "human_male"
	icon_dead = "human_male"
	intelligence_level = SA_HUMANOID
	var/annoyance = 0 //stop fucking staring you creep
	var/last_response = 0
	faction = "statue"
	mob_size = MOB_HUGE
	response_help = "touches"
	response_disarm = "pushes"
	environment_smash = 2
	can_be_antagged = 1
	speed = -1
	maxHealth = 50000
	health = 50000
//	investigates = 1


	harm_intent_damage = 35
	melee_damage_lower = 30
	melee_damage_upper = 45
	attacktext = "clawed"
	attack_sound = 'sound/hallucinations/growl1.ogg'

	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0
	maxbodytemp = 9000
	run_at_them = 0


	move_to_delay = 0 // Very fast

	animate_movement = NO_STEPS // Do not animate movement, you jump around as you're a scary statue.

	see_in_dark = 13
	view_range = 35 //So it can run at the victim when out of the view
//	supernatural = 1
/*	aggro_vision_range = 12
	idle_vision_range = 12
*/
	melee_miss_chance = 0


	see_invisible = SEE_INVISIBLE_NOLIGHTING
	sight = SEE_SELF|SEE_MOBS|SEE_OBJS|SEE_TURFS
	anchored = 1
	status_flags = GODMODE // Cannot push also
	var/last_hit = 0
	var/cannot_be_seen = 1
	var/mob/living/creator = null
	mob_swap_flags = null

// No movement while seen code.

/mob/living/simple_animal/hostile/statue/New(loc, var/mob/living/creator)
	..()
	last_response = world.time
	// Give spells
	add_spell(new/spell/aoe_turf/flicker_lights)
	add_spell(new/spell/aoe_turf/blindness)
	add_spell(new/spell/aoe_turf/shatter)


	// Set creator
	if(creator)
		src.creator = creator

/mob/living/simple_animal/hostile/statue/DestroySurroundings()
	if(can_be_seen(get_turf(loc)))
		if(client)
			to_chat(src, "<span class='warning'>You cannot move, there are eyes on you!</span>")
		return 0
	return ..()

/mob/living/simple_animal/hostile/statue/Move(turf/NewLoc)
	if(can_be_seen(NewLoc))
		if(client)
			to_chat(src, "<span class='warning'>You cannot move, there are eyes on you!</span>")
		return 0
	return ..()

/mob/living/simple_animal/hostile/statue/Life()
	..()
	handleAnnoyance()
	if ((annoyance - 2) > 0)
		annoyance -= 2
	if(target_mob)
		if((annoyance + 5) < 800)
			annoyance += 5

/mob/living/simple_animal/hostile/statue/handle_stance()
	if(!..())
		return
	if(target_mob) // If we have a target and we're AI controlled
		var/mob/watching = can_be_seen()
		// If they're not our target
		if(watching && watching != target_mob)
			// This one is closer.
			if(get_dist(watching, src) > get_dist(target_mob, src))
				LoseTarget()
				target_mob = watching


/mob/living/simple_animal/hostile/statue/proc/handleAnnoyance()
	if(last_response + 3 SECONDS < world.time) //so it won't blind people 24/7
		return
	var/turf/T = get_turf(loc)
	if (annoyance > 60)
		AI_blind()
		annoyance -= 25
		if (prob(50))
			if(T.get_lumcount() * 10 > 1.5)
				AI_flash()
				annoyance -= 35
	last_response = world.time
	return


/mob/living/simple_animal/hostile/statue/proc/AI_blind()
	for(var/mob/living/L in range(7, src))
		if(L == src)
			continue
		if (prob(75))
			if(istype(L , /mob/living/carbon/human))
				var/mob/living/carbon/human/H = L
				if (H.species == "Diona" || H.species == "Promethean")// can't blink and organic
					return
			to_chat(L, "<span class='notice'>Your eyes feel very heavy.</span>")
			L.Blind(5)
	return

/mob/living/simple_animal/hostile/statue/proc/AI_flash()
	if (prob(60))
		visible_message("The statue slowly points at the light.")
	for(var/obj/machinery/light/L in range(10, src))
		L.flicker()
	return


/mob/living/simple_animal/hostile/statue/proc/AI_mirrorshmash()
	for(var/obj/structure/mirror/M in range(10, src))
		if ((!M.shattered )||(!M.glass))
			visible_message("The mirror shatters!")
			M.shatter()
	return



/mob/living/simple_animal/hostile/statue/AttackTarget()
	if(can_be_seen(get_turf(loc)))
		if(client)
			to_chat(src, "<span class='warning'>You cannot attack, there are eyes on you!</span>")
			return
	else if(prob(80))
		spawn(4)
		..()



/mob/living/simple_animal/hostile/statue/face_atom()
	if(!can_be_seen(get_turf(loc)))
		..()

/mob/living/simple_animal/hostile/statue/proc/can_be_seen(turf/destination)
	if(!cannot_be_seen)
		return null
	// Check for darkness
	var/turf/T = get_turf(loc)
	if(T && destination && T.lighting_overlay)
		if(T.get_lumcount() * 10 < 1 && destination.get_lumcount() * 10 < 1) // No one can see us in the darkness, right?
			return null
		if(T == destination)
			destination = null

	// We aren't in darkness, loop for viewers.
	var/list/check_list = list(src)
	if(destination)
		check_list += destination

	// This loop will, at most, loop twice.
	for(var/atom/check in check_list)
		for(var/mob/living/M in viewers(world.view + 1, check) - src)
			if(!(M.sdisabilities & BLIND) || !(M.blinded))
				if(M.has_vision() && !M.isSynthetic())
					return M
		for(var/obj/mecha/M in view(world.view + 1, check)) //assuming if you can see them they can see you
			if(M.occupant && M.occupant.client)
				if(M.occupant.has_vision() && !M.occupant.isSynthetic())
					return M.occupant
		for(var/obj/structure/mirror/M in view(7, check)) //Weeping angels hate mirrors. Probably because they're ugly af
			if ((!M.shattered )||(!M.glass))
				annoyance += 2
				if ((annoyance > 200) && (ai_inactive == 0))
					AI_mirrorshmash()
					annoyance -= 200
				return src //if it sees the mirror, it sees itself, right?
	return null

// Cannot talk

/mob/living/simple_animal/hostile/statue/say()
	return 0

// Turn to dust when gibbed

/mob/living/simple_animal/hostile/statue/gib()
	dust()


// Stop attacking clientless mobs

/mob/living/simple_animal/hostile/statue/proc/CanAttack(atom/the_target) //ignore clientless mobs
	if(isliving(the_target))
		var/mob/living/L = the_target
		if(!L.client && !L.ckey)
			return 0
	return ..()

// Statue powers

// Flicker lights
/spell/aoe_turf/flicker_lights
	name = "Flicker Lights"
	desc = "You will trigger a large amount of lights around you to flicker."
	spell_flags = 0
	charge_max = 400
	range = 14

/spell/aoe_turf/flicker_lights/cast(list/targets, mob/user = usr)
	for(var/turf/T in targets)
		for(var/obj/machinery/light/L in T)
			L.flicker()
	return

//Blind AOE
/spell/aoe_turf/blindness
	name = "Blindness"
	desc = "Your prey will be momentarily blind for you to advance on them."

	message = "<span class='notice'>You glare your eyes.</span>"
	charge_max = 250
	spell_flags = 0
	range = 10

/spell/aoe_turf/blindness/cast(list/targets, mob/user = usr)
	for(var/mob/living/L in living_mob_list)
		if(L == user)
			continue
		var/turf/T = get_turf(L.loc)
		if(T && T in targets)
			L.Blind(7)
	return


/spell/aoe_turf/shatter
	name = "Shatter mirrors!"
	desc = "That handsome devil has to wait. You have people to make into corpses."

	message = "<span class='notice'>You glare your eyes.</span>"
	charge_max = 2000
	silenced = 500
	spell_flags = 0
	range = 10




/spell/aoe_turf/shatter/cast(list/targets, mob/user = usr)
	for(var/obj/structure/mirror/M in range(10, src))
		if ((!M.shattered )||(!M.glass))
			M.shatter()
	return



/mob/living/simple_animal/hostile/statue/verb/toggle_darkness()
	set name = "Toggle Darkness"
	set desc = "You ARE the darkness."
	set category = "Abilities"
	seedarkness = !seedarkness
	plane_holder.set_vis(VIS_FULLBRIGHT, !seedarkness)
	to_chat(src,"You [seedarkness ? "now" : "no longer"] see darkness.")



/mob/living/simple_animal/hostile/statue/restrained()
	. = ..()
	if(can_be_seen(loc))
		return 1



/mob/living/simple_animal/hostile/statue/ListTargets()
	. = ..()

	for(var/mob/living/V in mobs_in_xray_view(20, src))
		. += V


	return .
