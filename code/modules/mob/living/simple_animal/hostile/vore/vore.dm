/*
--------------
NOTES FOR DEVS
--------------

If your predator has a limited capacity, it should have sprites for every interval of its size, rounded to the nearest whole number.
Example: If I have a snake predator who has a capacity of 3, I need sprites for snake-1, snake-2, and snake-3.

Capacity should always be a whole number.

Also max_size and min_size should never exceed capacity or the icon will break.

Don't use ranged mobs for vore mobs.
*/


/mob/living/simple_animal/hostile/vore
	name = "voracious lizard"
	desc = "These gluttonous little bastards used to be regular lizards that were mutated by long-term exposure to phoron!"
	icon_dead = "dino-dead"
	icon_living = "dino"
	icon_state = "dino"
	icon = 'icons/mob/vore.dmi'
	var/capacity = 1 // Zero is infinite. Do not set higher than you have icons to update.
	var/max_size = 1 // Max: 2
	var/min_size = 0.25 // Min: 0.25
	var/picky = 1 // Won't eat undigestable prey by default
	var/fullness = 0
	var/endo = 0 // Determines if a mob doesn't digest by default or not. Set to false by default.

	var/pouncechance = 5 // Determines how likely a mob is to pounce on you per attack. 5% by default.
	var/escapable = 1 // Determines if a mob belly can be escaped without abusing OOC escape. Set true by default.
	var/escapechance = 25 // Determines how likely struggling will allow you to escape a vore mob. 25% by default.
	var/digestchance = 0 // Determines how likely struggling will start digestion in a mob defaulted to hold. Set to 0% by default.

	swallowTime = 1 // Hungry little bastards.

	// By default, this is what most vore mobs are capable of.
	response_help = "pets"
	response_disarm = "gently pushes aside"
	response_harm = "hits"
	speed = 4
	harm_intent_damage = 5
	melee_damage_lower = 10
	melee_damage_upper = 25
	attacktext = "bitten"
	attack_sound = 'sound/weapons/bite.ogg'
	min_oxy = 5
	max_oxy = 0
	min_tox = 0
	max_tox = 1
	min_co2 = 0
	max_co2 = 5
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 270
	maxbodytemp = 370
	heat_damage_per_tick = 15
	cold_damage_per_tick = 10
	unsuitable_atoms_damage = 10

/mob/living/simple_animal/hostile/vore/update_icons()
	if(stat == DEAD)
		return

	if(capacity)
		fullness = 0
		for(var/I in vore_organs)
			var/datum/belly/B = vore_organs[I]
			for(var/mob/living/M in B.internal_contents)
				fullness += M.size_multiplier
			fullness = round(fullness, 1) // Because intervals of 0.25 are going to make sprite artists cry.
		if(fullness)
			if (fullness > capacity) // Player controlled.
				icon_state = "[initial(icon_state)]-[capacity]"
			else
				icon_state = "[initial(icon_state)]-[fullness]"
		else
			icon_state = initial(icon_state)
	..()

/mob/living/simple_animal/hostile/vore/New()

// ToDo: Add support for multiple stomachs.

	if(!vore_organs.len)
		var/datum/belly/B = new /datum/belly(src)
		B.immutable = 1
		B.name = "stomach"
		B.inside_flavor = "Your surroundings are warm, soft, and slimy. Makes sense, considering you're inside \the [name]."
		if (faction == "neutral" || endo)
			B.digest_mode = "Hold"
		else
			B.digest_mode = "Digest"
		B.escapable = escapable
		B.escapechance = escapechance
		B.digestchance = digestchance
		vore_organs[B.name] = B
		vore_selected = "stomach"
		B.vore_verb = "swallow"
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
	..()

/mob/living/simple_animal/hostile/vore/AttackingTarget()
	if(isliving(target_mob.loc)) //They're inside a mob, maybe us, ignore!
		return

	if(!isliving(target_mob)) //Can't eat 'em if they ain't alive. Prevents eating borgs/bots.
		..()
		return

	if(picky && !target_mob.digestable) //Don't eat people with nogurgle prefs
		..()
		return

	// Is our target edible and standing up?
	if(target_mob.canmove && target_mob.size_multiplier >= min_size && target_mob.size_multiplier <= max_size && !(target_mob in prey_exclusions))
		if(prob(pouncechance))
			target_mob.Weaken(5)
			target_mob.visible_message("<span class='danger'>\the [src] pounces on \the [target_mob]!</span>!")
			animal_nom(target_mob)
			LoseTarget()
			return
		else
			..()

	if(!target_mob.canmove && target_mob.size_multiplier >= min_size && target_mob.size_multiplier <= max_size && !(target_mob in prey_exclusions))
		if(!capacity || (target_mob.size_multiplier + fullness) <= capacity)
			stance = HOSTILE_STANCE_EATING
			stop_automated_movement = 1
			animal_nom(target_mob)
			LoseTarget()
			return
	..()

/mob/living/simple_animal/hostile/vore/death()
	for(var/I in vore_organs)
		var/datum/belly/B = vore_organs[I]
		B.release_all_contents() // When your stomach is empty
	..() // then you have my permission to die.


// ------- Big Preds ------- //

/mob/living/simple_animal/hostile/vore/large
	name = "giant snake"
	desc = "Snakes. Why did it have to be snakes?"
	icon = 'icons/mob/vore64x64.dmi'
	icon_dead = "snake-dead"
	icon_living = "snake"
	icon_state = "snake"
	old_x = -16
	old_y = -16
	pixel_x = -16
	pixel_y = -16
	maxHealth = 200
	health = 200
	pouncechance = 50 // Bigger mobs, bigger appetite.