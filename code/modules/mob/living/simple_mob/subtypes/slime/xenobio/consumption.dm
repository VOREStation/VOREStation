// Handles hunger, starvation, growth, and eatting humans.

/mob/living/simple_mob/slime/xenobio/adjust_nutrition(input, var/heal = 1)
	..(input)

	if(input > 0)
		// Gain around one level per 50 nutrition.
		if(prob(input * 2))
			power_charge = min(power_charge++, 10)
			if(power_charge == 10)
				adjustToxLoss(-10)

		// Heal 1 point of damage per 5 nutrition coming in.
		if(heal)
			adjustBruteLoss(-input * 0.2)
			adjustFireLoss(-input * 0.2)
			adjustToxLoss(-input * 0.2)
			adjustOxyLoss(-input * 0.2)
			adjustCloneLoss(-input * 0.2)

/mob/living/simple_mob/slime/xenobio/proc/get_grow_nutrition() // Above it we grow, below it we can eat
	return is_adult ? 1000 : 800

/mob/living/simple_mob/slime/xenobio/proc/get_hunger_nutrition() // Below it we will always eat
	return is_adult ? 600 : 500

/mob/living/simple_mob/slime/xenobio/proc/get_starve_nutrition() // Below it we will eat before everything else
	return is_adult ? 300 : 200

// Called by Life().
/mob/living/simple_mob/slime/xenobio/proc/handle_nutrition()
	if(harmless)
		return

	if(prob(15))
		adjust_nutrition(is_adult ? -2 : -1) // Adult slimes get hungry faster.

	if(nutrition <= get_starve_nutrition())
		handle_starvation()

	else if(nutrition >= get_grow_nutrition() && amount_grown < 10)
		adjust_nutrition(-20)
		amount_grown = between(0, amount_grown + 1, 10)

// Called if above proc happens while below a nutrition threshold.
/mob/living/simple_mob/slime/xenobio/proc/handle_starvation()
	if(nutrition < get_starve_nutrition() && !client) // if a slime is starving, it starts losing its friends
		if(friends.len && prob(1))
			var/mob/nofriend = pick(friends)
			if(nofriend)
				friends -= nofriend
				say("[nofriend]... food now...")

	if(nutrition <= 0)
		adjustToxLoss(rand(1,3))
		if(client && prob(5))
			to_chat(src, span_danger("You are starving!"))


/mob/living/simple_mob/slime/xenobio/proc/handle_consumption()
	if(victim && !stat)
		if(istype(victim) && consume(victim, 20))
			if(prob(25))
				to_chat(src, span_notice("You continue absorbing \the [victim]."))

		else
			var/list/feedback = list(
				"This subject is incompatible",
				"This subject does not have a life energy",
				"This subject is empty",
				"I am not satisfied",
				"I can not feed from this subject",
				"I do not feel nourished",
				"This subject is not food"
				)
			to_chat(src, span_warning("[pick(feedback)]..."))
			stop_consumption()

		if(victim)
			victim.updatehealth()

	else
		stop_consumption()

/mob/living/simple_mob/slime/xenobio/proc/start_consuming(mob/living/L)
	if(!can_consume(L))
		return
	if(!Adjacent(L))
		return

	step_towards(src, L) // Get on top of them to feed.
	if(loc != L.loc)
		return

	if(L.buckle_mob(src, forced = TRUE))
		victim = L
		update_icon()
		set_AI_busy(TRUE) // Don't want the AI to interfere with eatting.
		victim.visible_message(
			span_danger("\The [src] latches onto \the [victim]!"),
			span_critical("\The [src] latches onto you!")
			)

/mob/living/simple_mob/slime/xenobio/proc/stop_consumption(mob/living/L)
	if(!victim)
		return
	victim.unbuckle_mob()
	victim.visible_message(
		span_notice("\The [src] slides off of [victim]!"),
		span_notice("\The [src] slides off of you!")
		)
	victim = null
	update_icon()
	set_AI_busy(FALSE) // Resume normal operations.

/mob/living/simple_mob/slime/xenobio/proc/can_consume(mob/living/L)
	if(!L || !istype(L))
		to_chat(src, "This subject is incomparable...")
		return FALSE
	if(harmless)
		to_chat(src, "I am pacified... I cannot eat...")
		return FALSE
	if(L.mob_class & MOB_CLASS_SLIME)
		to_chat(src, "I cannot feed on other slimes...")
		return FALSE
	if(L.isSynthetic())
		to_chat(src, "This subject is not biological...")
		return FALSE
	if(L.getarmor(null, "bio") >= 75)
		to_chat(src, "I cannot reach this subject's biological matter...")
		return FALSE
	if(!Adjacent(L))
		to_chat(src, "This subject is too far away...")
		return FALSE
	if(L.getCloneLoss() >= L.getMaxHealth() * 1.5)
		to_chat(src, "This subject does not have an edible life energy...")
		return FALSE
	//VOREStation Addition start
	if(istype(L, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = L
		if(H.species.flags & NO_SCAN)
			to_chat(src, "This subject's life energy is beyond my reach...")
			return FALSE
	//VOREStation Addition end
	if(L.has_buckled_mobs())
		for(var/A in L.buckled_mobs)
			if(istype(A, /mob/living/simple_mob/slime/xenobio))
				if(A != src)
					to_chat(src, "\The [A] is already feeding on this subject...")
					return FALSE
	return TRUE

// This does the actual damage, as well as give nutrition and heals.
// Assuming no bio armor, calling consume(10) will result in;
// 6 clone damage to victim
// 4 tox damage to victim.
// 25 nutrition for the slime.
// 2 points of damage healed on the slime (as a result of the nutrition).
// 50% of giving +1 charge to the slime (same as above).
/mob/living/simple_mob/slime/xenobio/proc/consume(mob/living/victim, amount)
	if(can_consume(victim))
		var/armor_modifier = abs((victim.getarmor(null, "bio") / 100) - 1)
		var/damage_done = amount * armor_modifier
		if(damage_done > 0)
			victim.adjustCloneLoss(damage_done * 0.6)
			victim.adjustToxLoss(damage_done * 0.4)
			adjust_nutrition(damage_done * 5)
			Beam(victim, icon_state = "slime_consume", time = 8)
			to_chat(src, span_notice("You absorb some biomaterial from \the [victim]."))
			to_chat(victim, span_danger("\The [src] consumes some of your flesh!"))
			return TRUE
	return FALSE
