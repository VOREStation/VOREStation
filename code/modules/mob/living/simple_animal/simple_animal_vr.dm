// Flags for specifying which states we have vore icon_states for.
#define SA_ICON_LIVING	0x01
#define SA_ICON_DEAD	0x02
#define SA_ICON_REST	0x03

/mob/living/simple_animal
	var/vore_active = 0					// If vore behavior is enabled for this mob

	var/vore_capacity = 1				// The capacity (in people) this person can hold
	var/vore_max_size = RESIZE_HUGE		// The max size this mob will consider eating
	var/vore_min_size = RESIZE_TINY 	// The min size this mob will consider eating
	var/vore_bump_chance = 0			// Chance of trying to eat anyone that bumps into them, regardless of hostility
	var/vore_bump_emote	= "grabs hold of"				// Allow messages for bumpnom mobs to have a flavorful bumpnom
	var/vore_pounce_chance = 5			// Chance of this mob knocking down an opponent
	var/vore_standing_too = 0			// Can also eat non-stunned mobs
	var/vore_ignores_undigestable = 1	// Refuse to eat mobs who are undigestable by the prefs toggle.

	var/vore_default_mode = DM_DIGEST	// Default bellymode (DM_DIGEST, DM_HOLD, DM_ABSORB)
	var/vore_digest_chance = 25			// Chance to switch to digest mode if resisted
	var/vore_absorb_chance = 0			// Chance to switch to absorb mode if resisted
	var/vore_escape_chance = 25			// Chance of resisting out of mob

	var/vore_stomach_name				// The name for the first belly if not "stomach"
	var/vore_stomach_flavor				// The flavortext for the first belly if not the default

	var/vore_fullness = 0				// How "full" the belly is (controls icons)
	var/vore_icons = 0					// Bitfield for which fields we have vore icons for.

/mob/living/simple_animal/New()
	..()
	if(vore_active)
		init_belly()
	verbs |= /mob/living/proc/animal_nom

// Release belly contents beforey being gc'd!
/mob/living/simple_animal/Destroy()
	for(var/I in vore_organs)
		var/datum/belly/B = vore_organs[I]
		B.release_all_contents(include_absorbed = TRUE) // When your stomach is empty
	prey_excludes.Cut()
	. = ..()

//For all those ID-having mobs
/mob/living/simple_animal/GetIdCard()
	if(myid)
		return myid

// Update fullness based on size & quantity of belly contents
/mob/living/simple_animal/proc/update_fullness()
	var/new_fullness = 0
	for(var/I in vore_organs)
		var/datum/belly/B = vore_organs[I]
		for(var/mob/living/M in B.internal_contents)
			new_fullness += M.size_multiplier
		new_fullness = round(new_fullness, 1) // Because intervals of 0.25 are going to make sprite artists cry.
	vore_fullness = min(vore_capacity, new_fullness)

/mob/living/simple_animal/update_icon()
	..() // Call sideways "parent" to decide state
	if(vore_active)
		update_fullness()
		if(!vore_fullness)
			// Nothing
		else if(icon_state == icon_living && (vore_icons & SA_ICON_LIVING))
			icon_state = "[icon_state]-[vore_fullness]"
		else if(icon_state == icon_dead && (vore_icons & SA_ICON_DEAD))
			icon_state = "[icon_state]-[vore_fullness]"
		else if(icon_state == icon_rest && (vore_icons & SA_ICON_REST))
			icon_state = "[icon_state]-[vore_fullness]"

/mob/living/simple_animal/proc/will_eat(var/mob/living/M)
	if(!istype(M)) //Can't eat 'em if they ain't /mob/living
		ai_log("vr/wont eat [M] because they are not /mob/living", 3)
		return 0
	if(vore_ignores_undigestable && !M.digestable) //Don't eat people with nogurgle prefs
		ai_log("vr/wont eat [M] because I am picky", 3)
		return 0
	if(!M.allowmobvore) // Don't eat people who don't want to be ate by mobs
		ai_log("vr/wont eat [M] because they don't allow mob vore", 3)
		return 0
	if(M in prey_excludes) // They're excluded
		ai_log("vr/wont eat [M] because they are excluded", 3)
		return 0
	if(M.size_multiplier < vore_min_size || M.size_multiplier > vore_max_size)
		ai_log("vr/wont eat [M] because they too small or too big", 3)
		return 0
	if(vore_capacity != 0 && (vore_fullness + M.size_multiplier > vore_capacity)) // We're too full to fit them
		ai_log("vr/wont eat [M] because I am too full", 3)
		return 0
	return 1

/mob/living/simple_animal/PunchTarget()
	ai_log("vr/PunchTarget() [target_mob]", 3)
	// For things we don't want to eat, call the sideways "parent" to do normal punching
	if(!vore_active || !will_eat(target_mob))
		return ..()

	// If target is standing we might pounce and eat them
	if(target_mob.canmove && prob(vore_pounce_chance))
		target_mob.Weaken(5)
		target_mob.visible_message("<span class='danger'>\the [src] pounces on \the [target_mob]!</span>!")

	// If they're down or we can eat standing, do it
	if(!target_mob.canmove || vore_standing_too)
		return EatTarget()
	else
		return ..()

// Attempt to eat target
// TODO - Review this.  Could be some issues here
/mob/living/simple_animal/proc/EatTarget()
	ai_log("vr/EatTarget() [target_mob]",2)
	init_belly()
	stop_automated_movement = 1
	var/old_target = target_mob
	handle_stance(STANCE_BUSY)
	. = animal_nom(target_mob)
	update_icon()
	if(.)
		// If we succesfully ate them, lose the target
		LoseTarget()
		return old_target
	else if(old_target == target_mob)
		// If we didn't but they are still our target, go back to attack.
		// but don't run the handler immediately, wait until next tick
		// Otherwise we'll be in a possibly infinate loop
		set_stance(STANCE_ATTACK)
	stop_automated_movement = 0

/mob/living/simple_animal/death()
	for(var/I in vore_organs)
		var/datum/belly/B = vore_organs[I]
		B.release_all_contents(include_absorbed = TRUE) // When your stomach is empty
	..() // then you have my permission to die.

// Simple animals have only one belly.  This creates it (if it isn't already set up)
/mob/living/simple_animal/proc/init_belly()
	if(vore_organs.len)
		return
	if(no_vore) //If it can't vore, let's not give it a stomach.
		return

	var/datum/belly/B = new /datum/belly(src)
	B.immutable = 1
	B.name = vore_stomach_name ? vore_stomach_name : "stomach"
	B.inside_flavor = vore_stomach_flavor ? vore_stomach_flavor : "Your surroundings are warm, soft, and slimy. Makes sense, considering you're inside \the [name]."
	B.digest_mode = vore_default_mode
	B.escapable = vore_escape_chance > 0
	B.escapechance = vore_escape_chance
	B.digestchance = vore_digest_chance
	B.absorbchance = vore_absorb_chance
	B.human_prey_swallow_time = swallowTime
	B.nonhuman_prey_swallow_time = swallowTime
	B.vore_verb = "swallow"
	// TODO - Customizable per mob
	B.emote_lists[DM_HOLD] = list( // We need more that aren't repetitive. I suck at endo. -Ace
		"The insides knead at you gently for a moment.",
		"The guts glorp wetly around you as some air shifts.",
		"The predator takes a deep breath and sighs, shifting you somewhat.",
		"The stomach squeezes you tight for a moment, then relaxes harmlessly.",
		"The predator's calm breathing and thumping heartbeat pulses around you.",
		"The warm walls kneads harmlessly against you.",
		"The liquids churn around you, though there doesn't seem to be much effect.",
		"The sound of bodily movements drown out everything for a moment.",
		"The predator's movements gently force you into a different position.")
	B.emote_lists[DM_DIGEST] = list(
		"The burning acids eat away at your form.",
		"The muscular stomach flesh grinds harshly against you.",
		"The caustic air stings your chest when you try to breathe.",
		"The slimy guts squeeze inward to help the digestive juices soften you up.",
		"The onslaught against your body doesn't seem to be letting up; you're food now.",
		"The predator's body ripples and crushes against you as digestive enzymes pull you apart.",
		"The juices pooling beneath you sizzle against your sore skin.",
		"The churning walls slowly pulverize you into meaty nutrients.",
		"The stomach glorps and gurgles as it tries to work you into slop.")
	src.vore_organs[B.name] = B
	src.vore_selected = B.name

/mob/living/simple_animal/Bumped(var/atom/movable/AM, yes)
	if(ismob(AM))
		var/mob/tmob = AM
		if(will_eat(tmob) && !istype(tmob, type) && prob(vore_bump_chance) && !ckey) //check if they decide to eat. Includes sanity check to prevent cannibalism.
			if(tmob.canmove && prob(vore_pounce_chance)) //if they'd pounce for other noms, pounce for these too, otherwise still try and eat them if they hold still
				tmob.Weaken(5)
			tmob.visible_message("<span class='danger'>\the [src] [vore_bump_emote] \the [tmob]!</span>!")
			stop_automated_movement = 1
			animal_nom(tmob)
			update_icon()
			stop_automated_movement = 0
	..()