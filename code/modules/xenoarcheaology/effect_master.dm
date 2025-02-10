
/*
 * Here there be the base component for artifacts.
 */

//The reagents used to be a very small list of only certain reagent IDs previously.
//Now, we use modifiable lists that allows /types/ of reagents to be used. Nifty, right?
//Now if you dump reagent/toxin/really_bad_deadly_stuff it'll activate it just like reagent/toxin will.
#define HYDROGEN_PATH /datum/reagent/hydrogen
#define WATER_PATH /datum/reagent/water
#define ACID_PATH /datum/reagent/acid
#define DIETHYLAMINE_PATH /datum/reagent/diethylamine
#define PHORON_PATH /datum/reagent/toxin/phoron
#define HYDROPHORON_PATH /datum/reagent/toxin/hydrophoron
#define THERMITE_PATH /datum/reagent/thermite
#define TOXIN_PATH /datum/reagent/toxin

var/list/water_reagents = list(HYDROGEN_PATH, WATER_PATH)
var/list/acid_reagents = list(ACID_PATH, DIETHYLAMINE_PATH)
var/list/volatile_reagents = list(PHORON_PATH, HYDROPHORON_PATH, THERMITE_PATH)
var/list/toxic_reagents = list(TOXIN_PATH)

/atom/proc/is_anomalous()
	return (GetComponent(/datum/component/artifact_master))

/atom/proc/become_anomalous()
	if(!is_anomalous())
		AddComponent(/datum/component/artifact_master)
		if(istype(src, /obj/item))
			var/obj/item/I = src
			var/list/new_tech
			if(I.origin_tech)
				new_tech = I.origin_tech.Copy()
			else
				new_tech = list()
			if(prob(50))
				new_tech[TECH_PRECURSOR] += 1
			else
				new_tech[TECH_ARCANE] += 1
			var/rand_tech = pick(\
				TECH_MATERIAL,\
				TECH_ENGINEERING,\
				TECH_PHORON,\
				TECH_POWER,\
				TECH_BLUESPACE,\
				TECH_BIO,\
				TECH_COMBAT,\
				TECH_MAGNET,\
				TECH_DATA,\
				TECH_ILLEGAL\
				)
			LAZYSET(new_tech, rand_tech, rand(4,7))
			I.origin_tech = new_tech

/datum/component/artifact_master
	var/atom/holder
	var/list/my_effects

	dupe_type = /datum/component/artifact_master

	var/effect_generation_chance = 100

	var/list/make_effects

	var/artifact_id

/datum/component/artifact_master/New()
	. = ..()
	holder = parent

	if(!holder)
		qdel(src)
		return

	my_effects = list()

	START_PROCESSING(SSobj, src)

	do_setup()
	return

/*
 * Component System Registry.
 * Here be dragons.
 */
/*
 * Hi, it's me 3 years in the future
 * Why would you do this to us
 */

/datum/component/artifact_master/proc/DoRegistry()
//Melee Hit
	RegisterSignal(holder, COMSIG_PARENT_ATTACKBY, /datum/component/artifact_master/proc/on_attackby, override = FALSE)
//Explosions
	RegisterSignal(holder, COMSIG_ATOM_EX_ACT, /datum/component/artifact_master/proc/on_exact, override = FALSE)
//Bullets
	RegisterSignal(holder, COMSIG_ATOM_BULLET_ACT, /datum/component/artifact_master/proc/on_bullet, override = FALSE)

//Attackhand
	RegisterSignal(holder, COMSIG_ATOM_ATTACK_HAND, /datum/component/artifact_master/proc/on_attack_hand, override = FALSE)

//Bumped / Bumping
	RegisterSignal(holder, COMSIG_MOVABLE_BUMP, /datum/component/artifact_master/proc/on_bump, override = FALSE)
	RegisterSignal(holder, COMSIG_ATOM_BUMPED, /datum/component/artifact_master/proc/on_bumped, override = FALSE)

//Moved
	RegisterSignal(holder, COMSIG_MOVABLE_MOVED, /datum/component/artifact_master/proc/on_moved, override = FALSE)

//Splashed with a reagent.
	RegisterSignal(holder, COMSIG_REAGENTS_TOUCH, /datum/component/artifact_master/proc/on_reagent, override = FALSE)

/*
 *
 */

/datum/component/artifact_master/proc/do_unregister()
	UnregisterSignal(holder, COMSIG_PARENT_ATTACKBY)
	UnregisterSignal(holder, COMSIG_ATOM_EX_ACT)
	UnregisterSignal(holder, COMSIG_ATOM_BULLET_ACT)
	UnregisterSignal(holder, COMSIG_ATOM_ATTACK_HAND)
	UnregisterSignal(holder, COMSIG_MOVABLE_BUMP)
	UnregisterSignal(holder, COMSIG_ATOM_BUMPED)
	UnregisterSignal(holder, COMSIG_MOVABLE_MOVED)
	UnregisterSignal(holder, COMSIG_REAGENTS_TOUCH)

/datum/component/artifact_master/proc/get_active_effects()
	var/list/active_effects = list()
	for(var/datum/artifact_effect/my_effect in my_effects)
		if(my_effect.activated)
			active_effects |= my_effect

	return active_effects

/datum/component/artifact_master/proc/get_all_effects()
	var/list/effects = list()
	for(var/datum/artifact_effect/my_effect in my_effects)
		effects |= my_effect

	return effects

/datum/component/artifact_master/proc/add_effect()
	var/effect_type = tgui_input_list(usr, "What type do you want?", "Effect Type", subtypesof(/datum/artifact_effect))
	if(effect_type)
		var/datum/artifact_effect/my_effect = new effect_type(src)
		if(istype(holder, my_effect.req_type))
			my_effects += my_effect

		else
			to_chat(usr, span_filter_notice("This effect can not be applied to this atom type."))
			qdel(my_effect)

/datum/component/artifact_master/proc/remove_effect()
	var/to_remove_effect = tgui_input_list(usr, "What effect do you want to remove?", "Remove Effect", my_effects)

	if(to_remove_effect)
		var/datum/artifact_effect/AE = to_remove_effect
		my_effects.Remove(to_remove_effect)
		qdel(AE)

/datum/component/artifact_master/Destroy()
	do_unregister()
	holder = null
	for(var/datum/artifact_effect/AE in my_effects)
		AE.master = null
		my_effects -= AE
		qdel(AE)

	STOP_PROCESSING(SSobj,src)

	. = ..()

/datum/component/artifact_master/proc/do_setup()
	if(LAZYLEN(make_effects))
		for(var/path in make_effects)
			var/datum/artifact_effect/new_effect = new path(src)
			if(istype(holder, new_effect.req_type))
				my_effects += new_effect

	else
		generate_effects()

	DoRegistry()

/datum/component/artifact_master/proc/generate_effects()
	while(effect_generation_chance > 0)
		var/chosen_path = pick(subtypesof(/datum/artifact_effect) - /datum/artifact_effect/extreme)
		if(effect_generation_chance >= 100)	// If we're above 100 percent, just cut a flat amount and add an effect.
			var/datum/artifact_effect/AE = new chosen_path(src)
			if(istype(holder, AE.req_type))
				my_effects += AE
				effect_generation_chance -= 30
			else
				AE.master = src
				qdel(AE)
			continue

		effect_generation_chance /= 2

		if(prob(effect_generation_chance))	// Otherwise, add effects as normal, with decreasing probability.
			my_effects += new chosen_path(src)

		effect_generation_chance = round(effect_generation_chance)

/datum/component/artifact_master/proc/get_holder()	// Returns the holder.
	return holder

/datum/component/artifact_master/proc/get_primary()
	if(LAZYLEN(my_effects))
		return my_effects[1]
	return FALSE

/*
 * Trigger code.
 */

/datum/component/artifact_master/proc/on_exact()
	var/severity = args[2]
	var/triggered = FALSE
	for(var/datum/artifact_effect/my_effect in my_effects)
		switch(severity)
			if(1.0)
				if(my_effect.trigger == TRIGGER_FORCE || my_effect.trigger == TRIGGER_HEAT ||  my_effect.trigger == TRIGGER_ENERGY)
					my_effect.ToggleActivate()
					triggered = TRUE
			if(2.0)
				if(my_effect.trigger == TRIGGER_FORCE || my_effect.trigger == TRIGGER_HEAT)
					my_effect.ToggleActivate()
					triggered = TRUE
			if(3.0)
				if (my_effect.trigger == TRIGGER_FORCE)
					my_effect.ToggleActivate()
					triggered = TRUE

	if(triggered)
		return COMPONENT_IGNORE_EXPLOSION

	return

/datum/component/artifact_master/proc/on_bullet()
	var/obj/item/projectile/P = args[2]
	var/triggered = TRUE
	for(var/datum/artifact_effect/my_effect in my_effects)
		if(istype(P,/obj/item/projectile/bullet))
			if(my_effect.trigger == TRIGGER_FORCE)
				my_effect.ToggleActivate()
				triggered = TRUE

		else if(istype(P,/obj/item/projectile/beam) ||\
			istype(P,/obj/item/projectile/ion) ||\
			istype(P,/obj/item/projectile/energy))
			if(my_effect.trigger == TRIGGER_ENERGY)
				my_effect.ToggleActivate()
				triggered = TRUE

	if(triggered)
		return COMPONENT_CANCEL_ATTACK_CHAIN

	return

/datum/component/artifact_master/proc/on_bump()
	var/atom/bumped = args[2]
	var/warn = FALSE
	for(var/datum/artifact_effect/my_effect in my_effects)
		if(istype(bumped,/obj))
			if(bumped:throwforce >= 10)
				if(my_effect.trigger == TRIGGER_FORCE)
					my_effect.ToggleActivate()

		else if(ishuman(bumped) && GetAnomalySusceptibility(bumped) >= 0.5)
			if (my_effect.trigger == TRIGGER_TOUCH)
				my_effect.ToggleActivate()
				if(my_effect.activated && my_effect.effect == EFFECT_TOUCH)
					my_effect.DoEffectTouch(bumped)
				warn = 1

	if(warn && isliving(bumped))
		to_chat(bumped, span_filter_notice(span_bold("You accidentally touch \the [holder] as it hits you.")))

/datum/component/artifact_master/proc/on_bumped()
	var/atom/movable/M = args[2]
	var/warn = FALSE
	for(var/datum/artifact_effect/my_effect in my_effects)
		if(istype(M,/obj))
			if(M:throwforce >= 10)
				if(my_effect.trigger == TRIGGER_FORCE)
					my_effect.ToggleActivate()

		else if(ishuman(M) && !istype(M:gloves,/obj/item/clothing/gloves))
			if (my_effect.trigger == TRIGGER_TOUCH)
				my_effect.ToggleActivate(M)
				if(my_effect.activated && my_effect.effect == EFFECT_TOUCH)
					my_effect.DoEffectTouch(M)
				warn = 1

	if(warn && isliving(M))
		to_chat(M, span_filter_notice(span_bold("You accidentally touch \the [holder].")))

/datum/component/artifact_master/proc/on_attack_hand()
	var/mob/living/user = args[2]
	if(!istype(user))
		return

	if (get_dist(user, holder) > 1)
		to_chat(user, span_filter_notice("[span_red("You can't reach [holder] from here.")]"))
		return

	var/triggered = FALSE

	if(ishuman(user) && !istype(user:gloves,/obj/item/clothing/gloves))
		for(var/datum/artifact_effect/my_effect in my_effects)
			if(my_effect.trigger == TRIGGER_TOUCH)
				triggered = TRUE
				my_effect.ToggleActivate()
				if(my_effect.activated && my_effect.effect == EFFECT_TOUCH)
					my_effect.DoEffectTouch(user)

	if(triggered)
		to_chat(user, span_filter_notice(span_bold("You touch [holder].")))

	else
		to_chat(user, span_filter_notice(span_bold("You touch [holder],") + " [pick("but nothing of note happens","but nothing happens","but nothing interesting happens","but you notice nothing different","but nothing seems to have happened")]."))


/datum/component/artifact_master/proc/on_attackby()
	var/obj/item/W = args[2]

	for(var/datum/artifact_effect/my_effect in my_effects)
		//If we were splashed by a reagent, let's check to see if we have a trigger for that.
		if (istype(W, /obj/item/reagent_containers))
			if(my_effect.trigger == TRIGGER_WATER)
				for(var/datum/reagent/R in W.reagents.reagent_list) //What chems are in the beaker?
					var/T = R.type
					if(is_path_in_list(T,water_reagents)) //Check the reagent and activate!
						my_effect.ToggleActivate()

			else if(my_effect.trigger == TRIGGER_ACID)
				for(var/datum/reagent/R in W.reagents.reagent_list)
					var/T = R.type
					if(is_path_in_list(T,acid_reagents))
						my_effect.ToggleActivate()

			else if(my_effect.trigger == TRIGGER_VOLATILE)
				for(var/datum/reagent/R in W.reagents.reagent_list)
					var/T = R.type
					if(is_path_in_list(T,volatile_reagents))
						my_effect.ToggleActivate()

			else if(my_effect.trigger == TRIGGER_TOXIN)
				for(var/datum/reagent/R in W.reagents.reagent_list)
					var/T = R.type
					if(is_path_in_list(T,toxic_reagents))
						my_effect.ToggleActivate()
		//If we weren't splashed, let's see if we were hit by a energy item and if we're energy activation.
		else if(istype(W,/obj/item/melee/baton) && W:status ||\
				istype(W,/obj/item/melee/energy) ||\
				istype(W,/obj/item/melee/cultblade) ||\
				istype(W,/obj/item/card/emag) ||\
				istype(W,/obj/item/multitool))

			if (my_effect.trigger == TRIGGER_ENERGY)
				my_effect.ToggleActivate()

		//If we weren't hit by energy, let's see if we were hit by a lighter or welding tool and if we are heat.
		else if (istype(W,/obj/item/flame) && W:lit ||\
				istype(W,/obj/item/weldingtool) && W:welding)
			if(my_effect.trigger == TRIGGER_HEAT)
				my_effect.ToggleActivate()

		//Otherwise, let's see if we were hit with something with enough force to activate us.
		else
			if (my_effect.trigger == TRIGGER_FORCE && W.force >= 10)
				my_effect.ToggleActivate()

/datum/component/artifact_master/proc/on_reagent()
	//A strange bug here is that, when a reagent is splashed on an artifact, it calls this proc twice.
	//Why? I have no clue. I only accidentally stumbled upon it during debugging!
	//I left one of the debug logs commented out so others can confirm this.
	var/datum/reagent/touching = args[2]
	var/T = touching.type //What type of reagent is being splashed on it?

	for(var/datum/artifact_effect/my_effect in my_effects)
		if(is_path_in_list(T,water_reagents))
			//log_debug("ON REAGENT T in path = [is_path_in_list(T,water_reagents)]!")
			if(my_effect.trigger == TRIGGER_WATER)
				my_effect.ToggleActivate()
		else if(is_path_in_list(T,acid_reagents))
			if(my_effect.trigger == TRIGGER_ACID)
				my_effect.ToggleActivate()
		else if(is_path_in_list(T,volatile_reagents))
			if(my_effect.trigger == TRIGGER_VOLATILE)
				my_effect.ToggleActivate()
		else if(is_path_in_list(T,toxic_reagents))
			if(my_effect.trigger == TRIGGER_TOXIN)
				my_effect.ToggleActivate()

/datum/component/artifact_master/proc/on_moved()
	for(var/datum/artifact_effect/my_effect in my_effects)
		if(my_effect)
			my_effect.UpdateMove()

/datum/component/artifact_master/process()
	if(!holder)	// Some instances can be created and rapidly lose their holder, if they are destroyed rapidly on creation. IE, during excavation.
		STOP_PROCESSING(SSobj, src)
		if(!QDELETED(src))
			qdel(src)
			return

	var/turf/L = holder.loc
	if(!istype(L) && !isliving(L)) 	// We're inside a non-mob container or on null turf, either way stop processing effects
		return

	if(istype(holder, /atom/movable))
		var/atom/movable/HA = holder
		if(HA.pulledby)
			on_bumped(holder, HA.pulledby)

	for(var/datum/artifact_effect/my_effect in my_effects)
		if(my_effect)
			my_effect.UpdateMove()

	//if any of our effects rely on environmental factors, work that out
	var/trigger_cold = 0
	var/trigger_hot = 0

	var/turf/T = get_turf(holder)
	var/datum/gas_mixture/env = T.return_air()
	if(env)
		if(env.temperature < ARTIFACT_COLD_TRIGGER)
			trigger_cold = 1
		else if(env.temperature > ARTIFACT_HEAT_TRIGGER)
			trigger_hot = 1

	for(var/datum/artifact_effect/my_effect in my_effects)
		my_effect.artifact_id = artifact_id

		my_effect.process()

		//COLD ACTIVATION
		if(my_effect.trigger == TRIGGER_COLD && (trigger_cold ^ my_effect.activated))
			my_effect.ToggleActivate()

		//HEAT ACTIVATION
		if(my_effect.trigger == TRIGGER_HEAT && (trigger_hot ^ my_effect.activated))
			my_effect.ToggleActivate()

#undef HYDROGEN_PATH
#undef WATER_PATH
#undef ACID_PATH
#undef DIETHYLAMINE_PATH
#undef PHORON_PATH
#undef HYDROPHORON_PATH
#undef THERMITE_PATH
#undef TOXIN_PATH
