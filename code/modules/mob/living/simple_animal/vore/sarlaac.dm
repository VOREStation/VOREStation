

/mob/living/simple_animal/hostile/testmob
	name = "Sarlacc"	//Need a new name so no suing.
	desc = "Some sort of massive maw sticking out of the ground. Seems safe." //Placeholder plz suggest better.
	//tt_desc = "Semaeostomeae virginus" //No idea what name it should have
	icon = 'icons/mob/vore-sarlacc64x64.dmi'//Placeholder.
	icon_dead = "sarlacc-dead"
	icon_living = "sarlacc"
	icon_state = "sarlacc"

	stop_automated_movement = 1
	density = 1
	anchored = 1
	speed = 500 //SLOOOOW if it ever moves.
	mob_bump_flag = HEAVY

	health = 800 //Sturdy


	var/special_rangedcooldown = 5 SECONDS
	var/lastspecialattack = null // Uses world.time
	spattack_prob = 90
	spattack_min_range = 0
	spattack_max_range = 3
	melee_damage_lower = 40 // Break legs and eat
	melee_damage_upper = 25
	attacktext = list("thrashed")
	friendly = "caressed"

	response_help   = "brushes"	// If clicked on help intent
	response_disarm = "pushes" // If clicked on disarm intent
	response_harm   = "punches"	// If clicked on harm intent

	wander = 0 //No move
	returns_home = 1
	follow_dist = 0

	minbodytemp = 0 //Can be outside
	maxbodytemp = 350

	min_oxy = 0
	max_oxy = 60 // Does not like oxygen very much.
	min_tox = 0 // Needs phoron to survive.
	max_tox = 60
	min_co2 = 0
	max_co2 = 60
	min_n2 = 0
	max_n2 = 60

	armor = list(			// Values for normal getarmor() checks
				"melee" = 40,		//Insides are underground
				"bullet" = 0,
				"laser" = 0,
				"energy" = 0,
				"bomb" = -100,			//This kill the insides
				"bio" = -100,
				"rad" = -100)
	taser_kill = 0	//No, this is dumb why would taser kill animals.
	run_at_them = 0

	old_x = -16
	old_y = 0
	default_pixel_x = -16
	pixel_x = -16
	pixel_y = -16

// Activate Noms!
/mob/living/simple_animal/hostile/testmob
	vore_active = 1
	vore_capacity = 3
	vore_bump_chance = 100 //How did you not see this coming
	vore_bump_emote = "wraps its tentacles around"
	vore_default_mode = DM_DRAIN
	vore_icons = 0 //SA_ICON_LIVING


	vore_digest_chance = 0			// Chance to switch to digest mode if resisted
	vore_absorb_chance = 0
	vore_pounce_chance = 0			// Testing.
	vore_standing_too = 1
	vore_ignores_undigestable = 1	// If you come close to something that big you deserve it.

//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

/*
/mob/living/simple_animal/hostile/testmob/ClosestDistance() // Needed or the SA AI won't ever try to teleport.
	if(world.time > lastspecialattack + special_rangedcooldown)
		return spattack_max_range - 1
	return ..()
*/

/mob/living/simple_animal/hostile/testmob/SpecialAtkTarget()
	// Teleport attack.
	if(!target_mob)
		to_chat(src, "<span class='warning'>There's nothing to teleport to.</span>")
		return FALSE	
	var/list/nearby_things = range(1, target_mob)
	var/list/valid_turfs = list()

	// All this work to just go to a non-dense tile.
	for(var/turf/potential_turf in nearby_things)
		var/valid_turf = TRUE
		if(potential_turf.density)
			continue
		for(var/atom/movable/AM in potential_turf)
			if(AM.density)
				valid_turf = FALSE
		if(valid_turf)
			valid_turfs.Add(potential_turf)

	//if(special_rangedcooldown <= world.time + ranged_cooldown_time*0.25 && !pre_attack)
	if(world.time < lastspecialattack + special_rangedcooldown)
		to_chat(src, "<span class='warning'>You can't teleport right now, wait a few seconds.</span>")
		return FALSE
	var/turf/target_turf = pick(valid_turfs)
	if(!target_turf)
		to_chat(src, "<span class='warning'>no</span>")
	playsound(src, 'sound/weapons/heavysmash.ogg', 50, 1)
	target_mob.Weaken(20)
	if(prob(30))
		target_mob.Stun(10)
	target_mob.throw_at(pick(target_turf), 10, 3)	//All this to throw them near mouth.
	sleep(20)	//Grab ur friend
	lastspecialattack = world.time


/*
/mob/living/simple_animal/hostile/testmob/proc/handle_preattack()
	if(ranged_cooldown <= world.time + ranged_cooldown_time*0.25 && !pre_attack)
		pre_attack++
	if(!pre_attack || stat || AIStatus == AI_IDLE)
		return
	icon_state = pre_attack_icon

/mob/living/simple_animal/hostile/testmob/proc/handle_tentacles()
	if(stance == STANCE_IDLE)
		var/tturf = get_turf(target)
		if(!isturf(tturf))
			return
		if(get_dist(src, target) <= 3)//Screen range check, so you can't get tentacle'd offscreen
			visible_message("<span class='warning'>[src] digs its tentacles under [target]!</span>")
			new /obj/effect/temp_visual/goliath_tentacle/original(tturf, src)
			ranged_cooldown = world.time + ranged_cooldown_time
			icon_state = icon_aggro
			pre_attack = 0*/


//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////


// Make sure you don't call ..() on this one, otherwise you duplicate work.
/mob/living/simple_animal/init_vore()

	var/obj/belly/B1 = new /obj/belly(src)
	vore_selected = B1
	B1.immutable = 1
	B1.name = "internal chamber"
	B1.desc = "Your surroundings are tight, constantly shiftting, and slimy. Makes sense, considering you're inside \the [name]."
	B1.digest_mode = DM_HOLD
	B1.mode_flags = vore_default_flags
	B1.escapable = vore_escape_chance > 0
	B1.escapechance = 30
	B1.digestchance = 0
	B1.transferchance = 70
	B1.transferlocation = "deeper chamber"
	B1.absorbchance = 0

	B1.human_prey_swallow_time = swallowTime
	B1.nonhuman_prey_swallow_time = swallowTime
	B1.vore_verb = "swallow"
	B1.emote_lists[DM_HOLD] = list( //Please change them they suck.
		"The insides knead at you for a moment.",
		"The guts glorp wetly around you as some air shifts.",
		"The predator takes a deep breath and sighs, shifting you somewhat.",
		"The stomach squeezes you tight for a moment, then relaxes.",
		"The predator's breathing and thumping heartbeat pulses around you.",
		"The warm walls kneads against you.",
		"The liquids churn around you, though there doesn't seem to be much effect.",
		"The sound of bodily movements drown out everything for a moment.",
		"The predator's movements force you into a different position.")
	B1.emote_lists[DM_DIGEST] = list(
		"The burning acids eat away at your form.",
		"The muscular stomach flesh grinds harshly against you.",
		"The caustic air stings your chest when you try to breathe.",
		"The slimy guts squeeze inward to help the digestive juices soften you up.",
		"The onslaught against your body doesn't seem to be letting up; you're food now.",
		"The predator's body ripples and crushes against you as digestive enzymes pull you apart.",
		"The juices pooling beneath you sizzle against your sore skin.",
		"The churning walls slowly pulverize you into meaty nutrients.",
		"The stomach glorps and gurgles as it tries to work you into slop.")

	var/obj/belly/B2 = new /obj/belly(src)
	B2.immutable = 1
	B2.name = "deeper chamber"
	B2.desc = "Your surroundings are tight, constantly shiftting, and slimy. Makes sense, considering you're inside \the [name]."
	B2.digest_mode = DM_DRAIN
	B2.mode_flags = vore_default_flags
	B2.escapable = vore_escape_chance > 0
	B2.escapechance = 0
	B2.digestchance = 5
	B2.transferchance = 15	//Escape to upper level
	B2.transferlocation = "internal chamber"
	B2.absorbchance = 50

	B2.human_prey_swallow_time = 10
	B2.nonhuman_prey_swallow_time = 10
	B2.vore_verb = "swallow"
	B2.emote_lists[DM_DRAIN] = list( // We need more that aren't repetitive. I suck at endo. -Ace
		"The insides knead at you for a moment.",
		"The guts glorp wetly around you as some air shifts.",
		"The predator takes a deep breath and sighs, shifting you somewhat.",
		"The stomach squeezes you tight for a moment, then relaxes.",
		"The predator's breathing and thumping heartbeat pulses around you.",
		"The warm walls kneads against you.",
		"The liquids churn around you, though there doesn't seem to be much effect.",
		"The sound of bodily movements drown out everything for a moment.",
		"You're practically smothered in the oppressive heat of the creature's stomach!",//Stolen
		"The predator's movements force you into a different position.")
	B2.emote_lists[DM_DIGEST] = list(
		"The burning acids eat away at your form.",
		"The muscular stomach flesh grinds harshly against you.",
		"The caustic air stings your chest when you try to breathe.",
		"The slimy guts squeeze inward to help the digestive juices soften you up.",
		"The onslaught against your body doesn't seem to be letting up; you're food now.",
		"The predator's body ripples and crushes against you as digestive enzymes pull you apart.",
		"The juices pooling beneath you sizzle against your sore skin.",
		"The churning walls slowly pulverize you into meaty nutrients.",
		"The stomach glorps and gurgles as it tries to work you into slop.")
