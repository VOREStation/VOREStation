// Specialized AI for slime simplemobs.
// Unlike the parent AI code, this will probably break a lot of things if you put it on something that isn't /mob/living/simple_mob/slime/xenobio

/datum/ai_holder/simple_mob/xenobio_slime
	hostile = TRUE
	cooperative = TRUE
	firing_lanes = TRUE
	mauling = TRUE // They need it to get the most out of monkeys.
	var/rabid = FALSE	// Will attack regardless of discipline.
	var/discipline = 0	// Beating slimes makes them less likely to lash out.  In theory.
	var/resentment = 0	// 'Unjustified' beatings make this go up, and makes it more likely for abused slimes to go rabid.
	var/obedience = 0	// Conversely, 'justified' beatings make this go up, and makes discipline decay slower, potentially making it not decay at all.

	var/always_stun = FALSE // If true, the slime will elect to attempt to permastun the target.

	var/last_discipline_decay = null // Last world.time discipline was reduced from decay.
	var/discipline_decay_time = 5 SECONDS // Earliest that one discipline can decay.

	var/list/grudges = list() // List of Prometheans who are jerks.

/datum/ai_holder/simple_mob/xenobio_slime/Destroy()
	grudges.Cut()
	..()

/datum/ai_holder/simple_mob/xenobio_slime/sapphire
	always_stun = TRUE // They know that stuns are godly.
	intelligence_level = AI_SMART // Also knows not to walk while confused if it risks death.

/datum/ai_holder/simple_mob/xenobio_slime/light_pink
	discipline = 10
	obedience = 10

/datum/ai_holder/simple_mob/xenobio_slime/passive/New() // For Kendrick.
	..()
	pacify()

/datum/ai_holder/simple_mob/xenobio_slime/New()
	..()
	ASSERT(istype(holder, /mob/living/simple_mob/slime/xenobio))

// Checks if disciplining the slime would be 'justified' right now.
/datum/ai_holder/simple_mob/xenobio_slime/proc/is_justified_to_discipline()
	ai_log("xenobio_slime/is_justified_to_discipline() : Entered.", AI_LOG_TRACE)
	if(!can_act())
		ai_log("xenobio_slime/is_justified_to_discipline() : Judged to be unjustified because we cannot act. Exiting.", AI_LOG_DEBUG)
		return FALSE // The slime considers it abuse if they get stunned while already stunned.
	if(rabid)
		ai_log("xenobio_slime/is_justified_to_discipline() : Judged to be justified because we're rabid. Exiting.", AI_LOG_TRACE)
		return TRUE
	if(target && can_attack(target))
		if(ishuman(target))
			var/mob/living/carbon/human/H = target
			if(istype(H.species, /datum/species/monkey))
				ai_log("xenobio_slime/is_justified_to_discipline() : Judged to be unjustified because we're targeting a monkey. Exiting.", AI_LOG_DEBUG)
				return FALSE // Attacking monkeys is okay.
		ai_log("xenobio_slime/is_justified_to_discipline() : Judged to be justified because we are targeting a non-monkey. Exiting.", AI_LOG_TRACE)
		return TRUE // Otherwise attacking other things is bad.
	ai_log("xenobio_slime/is_justified_to_discipline() : Judged to be unjustified because we are not targeting anything. Exiting.", AI_LOG_DEBUG)
	return FALSE // Not attacking anything.

/datum/ai_holder/simple_mob/xenobio_slime/proc/can_command(mob/living/commander)
	if(rabid)
		return FALSE
	if(!hostile)
		return SLIME_COMMAND_OBEY
//	if(commander in friends)
//		return SLIME_COMMAND_FRIEND
	if(holder.IIsAlly(commander))
		return SLIME_COMMAND_FACTION
	if(discipline > resentment && obedience >= 5)
		return SLIME_COMMAND_OBEY
	return FALSE

/datum/ai_holder/simple_mob/xenobio_slime/proc/adjust_discipline(amount, silent)
	var/mob/living/simple_mob/slime/xenobio/my_slime = holder
	if(amount > 0)
		if(rabid)
			return
		if(my_slime.untamable)
			holder.say("Grrr...")
			holder.add_modifier(/datum/modifier/berserk, 30 SECONDS)
			enrage()
		var/justified = my_slime.is_justified_to_discipline() // This will also consider the AI-side of that proc.
		remove_target() // Stop attacking.

		if(justified)
			obedience++
			if(!silent)
				holder.say(pick("Fine...", "Okay...", "Sorry...", "I yield...", "Mercy..."))
		else
			if(prob(resentment * 20))
				enrage()
				holder.say(pick("Evil...", "Kill...", "Tyrant..."))
			else
				if(!silent)
					holder.say(pick("Why...?", "I don't understand...?", "Cruel...", "Stop...", "Nooo..."))
			resentment++ // Done after check so first time will never enrage.

	discipline = between(0, discipline + amount, 10)
	my_slime.update_mood()

/datum/ai_holder/simple_mob/xenobio_slime/handle_special_strategical()
	discipline_decay()

/datum/ai_holder/simple_mob/xenobio_slime/request_help()
	if(target)
		if(istype(target, /mob/living/simple_mob/slime/xenobio))	//Don't call reinforcements for internal disputes
			return
		if(istype(target, /mob/living/carbon/human))
			var/mob/living/carbon/human/H = target
			if(istype(H.species, /datum/species/monkey))			//Or for food
				return
	..()

// Handles decay of discipline.
/datum/ai_holder/simple_mob/xenobio_slime/proc/discipline_decay()
	if(discipline > 0 && last_discipline_decay + discipline_decay_time < world.time)
		if(!prob(75 + (obedience * 5)))
			adjust_discipline(-1)
			last_discipline_decay = world.time

/datum/ai_holder/simple_mob/xenobio_slime/handle_special_tactic()
	evolve_and_reproduce()

// Hit the correct verbs to keep the slime species going.
/datum/ai_holder/simple_mob/xenobio_slime/proc/evolve_and_reproduce()
	var/mob/living/simple_mob/slime/xenobio/my_slime = holder
	if(my_slime.amount_grown >= 10)
		// Press the correct verb when we can.
		if(my_slime.is_adult)
			my_slime.reproduce() // Splits into four new baby slimes.
		else
			my_slime.evolve() // Turns our holder into an adult slime.


// Called when pushed too far (or a red slime core was used).
/datum/ai_holder/simple_mob/xenobio_slime/proc/enrage()
	var/mob/living/simple_mob/slime/xenobio/my_slime = holder
	if(my_slime.harmless)
		return
	rabid = TRUE
	my_slime.update_mood()
	my_slime.visible_message(span("danger", "\The [my_slime] enrages!"))

// Called to relax from being rabid (when blue slime core was used).
/datum/ai_holder/simple_mob/xenobio_slime/proc/relax()
	var/mob/living/simple_mob/slime/xenobio/my_slime = holder
	if(my_slime.harmless)
		return
	if(rabid)
		rabid = FALSE
		my_slime.update_mood()
		my_slime.visible_message(span("danger", "\The [my_slime] calms down."))

// Called when using a pacification agent (or it's Kendrick being initalized).
/datum/ai_holder/simple_mob/xenobio_slime/proc/pacify()
	remove_target() // So it stops trying to kill them.
	rabid = FALSE
	hostile = FALSE
	retaliate = FALSE
	cooperative = FALSE
	holder.a_intent = I_HELP

// The holder's attack changes based on intent. This lets the AI choose what effect is desired.
/datum/ai_holder/simple_mob/xenobio_slime/pre_melee_attack(atom/A)
	if(istype(A, /mob/living))
		var/mob/living/L = A
		var/mob/living/simple_mob/slime/xenobio/my_slime = holder

		if( (!L.lying && prob(30 + (my_slime.power_charge * 7) ) || (!L.lying && always_stun) ))
			my_slime.a_intent = I_DISARM // Stun them first.
		else if(my_slime.can_consume(L) && L.lying)
			my_slime.a_intent = I_GRAB // Then eat them.
		else
			my_slime.a_intent = I_HURT // Otherwise robust them.

/datum/ai_holder/simple_mob/xenobio_slime/closest_distance(atom/movable/AM)
	if(istype(AM, /mob/living))
		var/mob/living/L = AM
		if(ishuman(L))
			var/mob/living/carbon/human/H = L
			if(istype(H.species, /datum/species/monkey))
				return 1 // Otherwise ranged slimes will eat a lot less often.
		if(L.stat >= UNCONSCIOUS)
			return 1 // Melee (eat) the target if dead/dying, don't shoot it.
	return ..()

/datum/ai_holder/simple_mob/xenobio_slime/can_attack(atom/movable/AM, var/vision_required = TRUE)
	. = ..()
	if(.) // Do some additional checks because we have Special Code(tm).
		if(ishuman(AM))
			var/mob/living/carbon/human/H = AM
			if(istype(H.species, /datum/species/monkey)) // istype() is so they'll eat the alien monkeys too.
				return TRUE // Monkeys are always food (sorry Pun Pun).
			else if(H.species && H.species.name == SPECIES_PROMETHEAN) // Prometheans are always our friends.
				if(!(H in grudges)) // Unless they're an ass.
					return FALSE
		if(discipline && !rabid)
			holder.a_intent = I_HELP
			return FALSE // We're a good slime.

/datum/ai_holder/simple_mob/xenobio_slime/react_to_attack(atom/movable/attacker, ignore_timers = FALSE)
	. = ..(attacker)

	if(ishuman(attacker))
		var/mob/living/carbon/human/H = attacker
		if(H.species && H.species.name == SPECIES_PROMETHEAN)	// They're a jerk.
			grudges |= H

// Commands, reactions, etc
/datum/ai_holder/simple_mob/xenobio_slime/on_hear_say(mob/living/speaker, message)
	ai_log("xenobio_slime/on_hear_say([speaker], [message]) : Entered.", AI_LOG_DEBUG)
	var/mob/living/simple_mob/slime/xenobio/my_slime = holder

	if((findtext(message, num2text(my_slime.number)) || findtext(message, my_slime.name) || findtext(message, "slimes"))) // Talking to us.

		// First, make sure it's actually a player saying something and not an AI, or else we risk infinite loops.
		if(!speaker.client)
			return

		// Are all slimes being referred to?
	//	var/mass_order = FALSE
	//	if(findtext(message, "slimes"))
	//		mass_order = TRUE

		// Say hello back.
		if(findtext(message, "hello") || findtext(message, "hi") || findtext(message, "greetings"))
			delayed_say(pick("Hello...", "Hi..."), speaker)

		// Follow request.
		if(findtext(message, "follow") || findtext(message, "come with me"))
			if(!can_command(speaker))
				delayed_say(pick("No...", "I won't follow..."), speaker)
				return

			delayed_say("Yes... I follow \the [speaker]...", speaker)
			set_follow(speaker)

		// Squish request.
		if(findtext(message , "squish"))
			if(!can_command(speaker))
				delayed_say("No...", speaker)
				return

			spawn(rand(1 SECOND, 2 SECONDS))
				if(!src || !holder || !can_act())  // We might've died/got deleted/etc in the meantime.
					return
				my_slime.squish()


		// Stop request.
		if(findtext(message, "stop") || findtext(message, "halt") || findtext(message, "cease"))
			if(my_slime.victim) // We're being asked to stop eatting someone.
				if(!can_command(speaker) || !is_justified_to_discipline())
					delayed_say("No...", speaker)
					return
				else
					delayed_say("Fine...", speaker)
					adjust_discipline(1, TRUE)
					my_slime.stop_consumption()

			if(target) // We're being asked to stop chasing someone.
				if(!can_command(speaker) || !is_justified_to_discipline())
					delayed_say("No...", speaker)
					return
				else
					delayed_say("Fine...", speaker)
					adjust_discipline(1, TRUE) // This must come before losing the target or it will be unjustified.
					remove_target()


			if(leader) // We're being asked to stop following someone.
				if(can_command(speaker) == SLIME_COMMAND_FRIEND || leader == speaker)
					delayed_say("Yes... I'll stop...", speaker)
					lose_follow()
				else
					delayed_say("No... I'll keep following \the [leader]...", speaker)

		/* // Commented out since its mostly useless now due to slimes refusing to attack if it would make them naughty.
		// Murder request
		if(findtext(message, "harm") || findtext(message, "attack") || findtext(message, "kill") || findtext(message, "murder") || findtext(message, "eat") || findtext(message, "consume") || findtext(message, "absorb"))
			if(can_command(speaker) < SLIME_COMMAND_FACTION)
				delayed_say("No...", speaker)
				return

			for(var/mob/living/L in view(7, my_slime) - list(my_slime, speaker))
				if(L == src)
					continue // Don't target ourselves.
				var/list/valid_names = splittext(L.name, " ") // Should output list("John", "Doe") as an example.
				for(var/line in valid_names) // Check each part of someone's name.
					if(findtext(message, lowertext(line))) // If part of someone's name is in the command, the slime targets them if allowed to.
						if(!(mass_order && line == "slime"))	//don't think random other slimes are target
							if(can_attack(L))
								delayed_say("Okay... I attack \the [L]...", speaker)
								give_target(L)
								return
							else
								delayed_say("No... I won't attack \the [L].", speaker)
								return

			// If we're here, it couldn't find anyone with that name.
			delayed_say("No... I don't know who to attack...", speaker)
		*/
	ai_log("xenobio_slime/on_hear_say() : Exited.", AI_LOG_DEBUG)

/datum/ai_holder/simple_mob/xenobio_slime/can_violently_breakthrough()
	if(discipline && !rabid) // Good slimes don't shatter the windows because their buddy in an adjacent cell decided to piss off Slimesky.
		return FALSE
	return ..()
