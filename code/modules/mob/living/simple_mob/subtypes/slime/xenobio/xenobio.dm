// These slimes have the mechanics xenobiologists care about, such as reproduction, mutating into new colors, and being able to submit through fear.

/mob/living/simple_mob/slime/xenobio
	desc = "The most basic of slimes.  The grey slime has no remarkable qualities, however it remains one of the most useful colors for scientists."
	layer = MOB_LAYER + 1 // Need them on top of other mobs or it looks weird when consuming something.
	ai_holder_type = /datum/ai_holder/simple_mob/xenobio_slime // This should never be changed for xenobio slimes.
	max_nutrition = 1000
	var/is_adult = FALSE // Slimes turn into adults when fed enough. Adult slimes are somewhat stronger, and can reproduce if fed enough.
	var/maxHealth_adult = 200
	var/power_charge = 0 // Disarm attacks can shock someone if high/lucky enough.
	var/mob/living/victim = null // the person the slime is currently feeding on
	var/rainbow_core_candidate = TRUE // If false, rainbow cores cannot make this type randomly.
	var/mutation_chance = 25 // Odds of spawning as a new color when reproducing.  Can be modified by certain xenobio products.  Carried across generations of slimes.
	var/split_amount = 4 // Amount of children we will normally have. Half of that for dead adult slimes. Is NOT carried across generations.
	var/untamable = FALSE //Makes slime untamable via discipline.
	var/untamable_inheirit = FALSE //Makes slime inheirit its untamability.
	var/list/slime_mutation = list(
		/mob/living/simple_mob/slime/xenobio/orange,
		/mob/living/simple_mob/slime/xenobio/metal,
		/mob/living/simple_mob/slime/xenobio/blue,
		/mob/living/simple_mob/slime/xenobio/purple
	)
	var/amount_grown = 0 // controls how long the slime has been overfed, if 10, grows or reproduces
	var/number = 0 // This is used to make the slime semi-unique for indentification.
	var/harmless = FALSE // Set to true when pacified. Makes the slime harmless, not get hungry, and not be able to grow/reproduce.

/mob/living/simple_mob/slime/xenobio/Initialize(mapload, var/mob/living/simple_mob/slime/xenobio/my_predecessor)
	ASSERT(ispath(ai_holder_type, /datum/ai_holder/simple_mob/xenobio_slime))
	number = rand(1, 1000)
	update_name()

	. = ..() // This will make the AI and do the other mob constructor things. It will also return the default hint at the end.

	if(my_predecessor)
		inherit_information(my_predecessor)


/mob/living/simple_mob/slime/xenobio/Destroy()
	if(victim)
		stop_consumption() // Unbuckle us from our victim.
	return ..()

// Called when a slime makes another slime by splitting. The predecessor slime will be deleted shortly afterwards.
/mob/living/simple_mob/slime/xenobio/proc/inherit_information(var/mob/living/simple_mob/slime/xenobio/predecessor)
	if(!predecessor)
		return

	var/datum/ai_holder/simple_mob/xenobio_slime/AI = ai_holder
	var/datum/ai_holder/simple_mob/xenobio_slime/previous_AI = predecessor.ai_holder
	ASSERT(istype(AI))
	ASSERT(istype(previous_AI))

	// Now to transfer the information.
	// Newly made slimes are bit more rebellious than their predecessors, but they also somewhat forget the atrocities the xenobiologist may have done.
	AI.discipline = max(previous_AI.discipline - 1, 0)
	AI.obedience = max(previous_AI.obedience - 1, 0)
	AI.resentment = max(previous_AI.resentment - 1, 0)
	AI.rabid = previous_AI.rabid

/mob/living/simple_mob/slime/xenobio/update_icon()
	icon_living = "[icon_state_override ? "[icon_state_override] slime" : "slime"] [is_adult ? "adult" : "baby"][victim ? " eating" : ""]"
	icon_dead = "[icon_state_override ? "[icon_state_override] slime" : "slime"] [is_adult ? "adult" : "baby"] dead"
	icon_rest = icon_dead
	..() // This will apply the correct icon_state and do the other overlay-related things.


/mob/living/simple_mob/slime/xenobio/handle_special()
	if(stat != DEAD)
		handle_nutrition()

		if(victim)
			handle_consumption()

		handle_stuttering() // ??

	..()

/mob/living/simple_mob/slime/xenobio/examine(mob/user)
	. = ..()
	if(hat)
		. += "It is wearing \a [hat]."

	if(stat == DEAD)
		. += "It appears to be dead."
	else if(incapacitated(INCAPACITATION_DISABLED))
		. += "It appears to be incapacitated."
	else if(harmless)
		. += "It appears to have been pacified."
	else
		if(has_AI())
			var/datum/ai_holder/simple_mob/xenobio_slime/AI = ai_holder
			if(AI.rabid)
				. += "It seems very, very angry and upset."
			else if(AI.obedience >= 5)
				. += "It looks rather obedient."
			else if(AI.discipline)
				. += "It has been subjugated by force, at least for now."

/mob/living/simple_mob/slime/xenobio/proc/make_adult()
	if(is_adult)
		return

	is_adult = TRUE
	melee_damage_lower = round(melee_damage_lower * 2) // 20
	melee_damage_upper = round(melee_damage_upper * 2) // 30
	maxHealth = maxHealth_adult
	max_nutrition = 1200
	amount_grown = 0
	update_icon()
	update_name()

/mob/living/simple_mob/slime/xenobio/proc/make_baby()
	if(!is_adult)
		return

	is_adult = FALSE
	melee_damage_lower = round(melee_damage_lower / 2) // 20
	melee_damage_upper = round(melee_damage_upper / 2) // 30
	maxHealth = initial(maxHealth)
	health = clamp(health, 0, maxHealth)
	max_nutrition = initial(max_nutrition)
	nutrition = 400
	amount_grown = 0
	update_icon()
	update_name()

/mob/living/simple_mob/slime/xenobio/proc/update_name()
	if(harmless) // Docile slimes are generally named, so we shouldn't mess with it.
		return
	name = "[slime_color] [is_adult ? "adult" : "baby"] [initial(name)] ([number])"
	real_name = name

/mob/living/simple_mob/slime/xenobio/update_mood()
	var/old_mood = mood
	if(incapacitated(INCAPACITATION_DISABLED))
		mood = "sad"
	else if(harmless)
		mood = ":33"
	else if(has_AI())
		var/datum/ai_holder/simple_mob/xenobio_slime/AI = ai_holder
		if(AI.rabid)
			mood = "angry"
		else if(AI.target)
			mood = "mischevous"
		else if(AI.discipline)
			mood = "pout"
		else
			mood = ":3"
	else
		mood = ":3"

	if(old_mood != mood)
		update_icon()

/mob/living/simple_mob/slime/xenobio/proc/enrage()
	if(harmless)
		return
	if(has_AI())
		var/datum/ai_holder/simple_mob/xenobio_slime/AI = ai_holder
		AI.enrage()

/mob/living/simple_mob/slime/xenobio/proc/relax()
	if(harmless)
		return
	if(has_AI())
		var/datum/ai_holder/simple_mob/xenobio_slime/AI = ai_holder
		AI.relax()

/mob/living/simple_mob/slime/xenobio/proc/pacify()
	harmless = TRUE
	if(has_AI())
		var/datum/ai_holder/simple_mob/xenobio_slime/AI = ai_holder
		AI.pacify()

	faction = "neutral"

	// If for whatever reason the mob AI (or player) decides to try to attack something anyways.
	melee_damage_upper = 0
	melee_damage_lower = 0

	update_mood()


// These are verbs so that player slimes can evolve/split.
/mob/living/simple_mob/slime/xenobio/verb/evolve()
	set category = "Slime"
	set desc = "This will let you evolve from baby to adult slime."

	if(stat)
		to_chat(src, span("warning", "I must be conscious to do this..."))
		return

	if(harmless)
		to_chat(src, span("warning", "I have been pacified. I cannot evolve..."))
		return

	if(!is_adult)
		if(amount_grown >= 10)
			make_adult()
		else
			to_chat(src, span("warning", "I am not ready to evolve yet..."))
	else
		to_chat(src, span("warning", "I have already evolved..."))


/mob/living/simple_mob/slime/xenobio/verb/reproduce()
	set category = "Slime"
	set desc = "This will make you split into four new slimes."

	if(stat)
		to_chat(src, span("warning", "I must be conscious to do this..."))
		return

	if(harmless)
		to_chat(src, span("warning", "I have been pacified. I cannot reproduce..."))
		return

	if(is_adult)
		if(amount_grown >= 10)
			// Check if there's enough 'room' to split.
			var/list/nearby_things = orange(1, src)
			var/free_tiles = 0
			for(var/turf/T in nearby_things)
				var/free = TRUE
				if(T.density) // No walls.
					continue
				for(var/atom/movable/AM in T)
					if(istype(AM, /mob/living/simple_mob/slime) || !(AM.CanPass(src, T)))
						free = FALSE
						break
				for(var/atom/movable/AM in get_turf(src))
					if(!(AM.CanPass(src, T)) && !(AM == src))
						free = FALSE
						break

				if(free)
					free_tiles++

			if(free_tiles < split_amount-1) // Three free tiles are needed, as four slimes are made and the 4th tile is from the center tile that the current slime occupies.
				to_chat(src, span("warning", "It is too cramped here to reproduce..."))
				return

			var/list/babies = list()
			for(var/i = 1 to split_amount)
				babies.Add(make_new_slime(no_step = i))

			var/mob/living/simple_mob/slime/new_slime = pick(babies)
			new_slime.universal_speak = universal_speak
			if(src.mind)
				src.mind.transfer_to(new_slime)
			else
				new_slime.key = src.key
			qdel(src)
		else
			to_chat(src, span("warning", "I am not ready to reproduce yet..."))
	else
		to_chat(src, span("warning", "I have not evolved enough to reproduce yet..."))

// Used when reproducing or dying.
/mob/living/simple_mob/slime/xenobio/proc/make_new_slime(var/desired_type, var/no_step)
	var/t = src.type
	if(desired_type)
		t = desired_type
	if(prob(mutation_chance / 10))
		t = /mob/living/simple_mob/slime/xenobio/rainbow
	else if(prob(mutation_chance) && slime_mutation.len)
		t = slime_mutation[rand(1, slime_mutation.len)]
	var/mob/living/simple_mob/slime/xenobio/baby = new t(loc, src)

	// Handle 'inheriting' from parent slime.
	baby.mutation_chance = mutation_chance
	baby.power_charge = round(power_charge / 4)

	if(!istype(baby, /mob/living/simple_mob/slime/xenobio/rainbow))
		baby.unity = unity
	if(untamable_inheirit)
		baby.untamable = untamable
	baby.untamable_inheirit = untamable_inheirit
	baby.faction = faction
	baby.friends = friends.Copy()

	if(no_step != 1)
		step_away(baby, src)
	return baby

/mob/living/simple_mob/slime/xenobio/get_description_interaction()
	var/list/results = list()

	if(!stat)
		results += "[desc_panel_image("slimebaton")]to stun the slime, if it's being bad."

	results += ..()

	return results

/mob/living/simple_mob/slime/xenobio/get_description_info()
	var/list/lines = list()
	var/intro_line = "Slimes are generally the test subjects of Xenobiology, with different colors having different properties.  \
	They can be extremely dangerous if not handled properly."
	lines.Add(intro_line)
	lines.Add(null) // To pad the line breaks.

	var/list/rewards = list()
	for(var/potential_color in slime_mutation)
		var/mob/living/simple_mob/slime/S = potential_color
		rewards.Add(initial(S.slime_color))
	var/reward_line = "This color of slime can mutate into [english_list(rewards)] colors, when it reproduces.  It will do so when it has eatten enough."
	lines.Add(reward_line)
	lines.Add(null)

	lines.Add(description_info)
	return lines.Join("\n")
