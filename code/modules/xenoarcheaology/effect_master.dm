
/*
 * Here there be the base component for artifacts.
 */

/atom/proc/is_anomalous()
	return (GetComponent(/datum/component/artifact_master))

/atom/proc/become_anomalous()
	if(!is_anomalous())
		AddComponent(/datum/component/artifact_master)
		if(istype(src, /obj/item))
			var/obj/item/I = src
			LAZYINITLIST(I.origin_tech)
			if(prob(50))
				I.origin_tech[TECH_PRECURSOR] += 1
			else
				I.origin_tech[TECH_ARCANE] += 1
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
			LAZYSET(I.origin_tech, rand_tech, rand(4,7))

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

/datum/component/artifact_master/proc/get_active_effects()
	var/list/active_effects = list()
	for(var/datum/artifact_effect/my_effect in my_effects)
		if(my_effect.activated)
			active_effects |= my_effect

	return active_effects

/datum/component/artifact_master/proc/add_effect()
	var/effect_type = input(usr, "What type do you want?", "Effect Type") as null|anything in subtypesof(/datum/artifact_effect)
	if(effect_type)
		var/datum/artifact_effect/my_effect = new effect_type(src)
		if(istype(holder, my_effect.req_type))
			my_effects += my_effect

		else
			to_chat(usr, "<span class='filter_notice'>This effect can not be applied to this atom type.</span>")
			qdel(my_effect)

/datum/component/artifact_master/proc/remove_effect()
	var/to_remove_effect = input(usr, "What effect do you want to remove?", "Remove Effect") as null|anything in my_effects

	if(to_remove_effect)
		var/datum/artifact_effect/AE = to_remove_effect
		my_effects.Remove(to_remove_effect)
		qdel(AE)

/datum/component/artifact_master/Destroy()
	holder = null
	for(var/datum/artifact_effect/AE in my_effects)
		AE.master = null
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
		var/chosen_path = pick(subtypesof(/datum/artifact_effect))
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
			if (my_effect.trigger == TRIGGER_TOUCH && prob(50))
				my_effect.ToggleActivate()
				warn = 1

			if (my_effect.effect == EFFECT_TOUCH && prob(50))
				my_effect.DoEffectTouch(bumped)
				warn = 1

	if(warn && isliving(bumped))
		to_chat(bumped, "<span class='filter_notice'><b>You accidentally touch \the [holder] as it hits you.</b></span>")

/datum/component/artifact_master/proc/on_bumped()
	var/atom/movable/M = args[2]
	var/warn = FALSE
	for(var/datum/artifact_effect/my_effect in my_effects)
		if(istype(M,/obj))
			if(M:throwforce >= 10)
				if(my_effect.trigger == TRIGGER_FORCE)
					my_effect.ToggleActivate()

		else if(ishuman(M) && !istype(M:gloves,/obj/item/clothing/gloves))
			if (my_effect.trigger == TRIGGER_TOUCH && prob(50))
				my_effect.ToggleActivate()
				warn = 1

			if (my_effect.effect == EFFECT_TOUCH && prob(50))
				my_effect.DoEffectTouch(M)
				warn = 1

	if(warn && isliving(M))
		to_chat(M, "<span class='filter_notice'><b>You accidentally touch \the [holder].</b></span>")

/datum/component/artifact_master/proc/on_attack_hand()
	var/mob/living/user = args[2]
	if(!istype(user))
		return

	if (get_dist(user, holder) > 1)
		to_chat(user, "<span class='filter_notice'>[span_red("You can't reach [holder] from here.")]</span>")
		return
	if(ishuman(user) && user:gloves)
		to_chat(user, "<span class='filter_notice'><b>You touch [holder]</b> with your gloved hands, [pick("but nothing of note happens","but nothing happens","but nothing interesting happens","but you notice nothing different","but nothing seems to have happened")].</span>")
		return

	var/triggered = FALSE

	for(var/datum/artifact_effect/my_effect in my_effects)

		if(my_effect.trigger == TRIGGER_TOUCH)
			triggered = TRUE
			my_effect.ToggleActivate()

		if (my_effect.effect == EFFECT_TOUCH)
			triggered = TRUE
			my_effect.DoEffectTouch(user)

	if(triggered)
		to_chat(user, "<span class='filter_notice'><b>You touch [holder].</b></span>")

	else
		to_chat(user, "<span class='filter_notice'><b>You touch [holder],</b> [pick("but nothing of note happens","but nothing happens","but nothing interesting happens","but you notice nothing different","but nothing seems to have happened")].</span>")


/datum/component/artifact_master/proc/on_attackby()
	var/obj/item/weapon/W = args[2]
	for(var/datum/artifact_effect/my_effect in my_effects)

		if (istype(W, /obj/item/weapon/reagent_containers))
			if(W.reagents.has_reagent("hydrogen", 1) || W.reagents.has_reagent("water", 1))
				if(my_effect.trigger == TRIGGER_WATER)
					my_effect.ToggleActivate()
			else if(W.reagents.has_reagent("sacid", 1) || W.reagents.has_reagent("pacid", 1) || W.reagents.has_reagent("diethylamine", 1))
				if(my_effect.trigger == TRIGGER_ACID)
					my_effect.ToggleActivate()
			else if(W.reagents.has_reagent("phoron", 1) || W.reagents.has_reagent("thermite", 1))
				if(my_effect.trigger == TRIGGER_VOLATILE)
					my_effect.ToggleActivate()
			else if(W.reagents.has_reagent("toxin", 1) || W.reagents.has_reagent("cyanide", 1) || W.reagents.has_reagent("amatoxin", 1) || W.reagents.has_reagent("neurotoxin", 1))
				if(my_effect.trigger == TRIGGER_TOXIN)
					my_effect.ToggleActivate()
		else if(istype(W,/obj/item/weapon/melee/baton) && W:status ||\
				istype(W,/obj/item/weapon/melee/energy) ||\
				istype(W,/obj/item/weapon/melee/cultblade) ||\
				istype(W,/obj/item/weapon/card/emag) ||\
				istype(W,/obj/item/device/multitool))
			if (my_effect.trigger == TRIGGER_ENERGY)
				my_effect.ToggleActivate()

		else if (istype(W,/obj/item/weapon/flame) && W:lit ||\
				istype(W,/obj/item/weapon/weldingtool) && W:welding)
			if(my_effect.trigger == TRIGGER_HEAT)
				my_effect.ToggleActivate()
		else
			if (my_effect.trigger == TRIGGER_FORCE && W.force >= 10)
				my_effect.ToggleActivate()

/datum/component/artifact_master/proc/on_reagent()
	var/datum/reagent/Touching = args[2]

	var/list/water = list("hydrogen", "water")
	var/list/acid = list("sacid", "pacid", "diethylamine")
	var/list/volatile = list("phoron","thermite")
	var/list/toxic = list("toxin","cyanide","amatoxin","neurotoxin")

	for(var/datum/artifact_effect/my_effect in my_effects)
		if(Touching.id in water)
			if(my_effect.trigger == TRIGGER_WATER)
				my_effect.ToggleActivate()
		else if(Touching.id in acid)
			if(my_effect.trigger == TRIGGER_ACID)
				my_effect.ToggleActivate()
		else if(Touching.id in volatile)
			if(my_effect.trigger == TRIGGER_VOLATILE)
				my_effect.ToggleActivate()
		else if(Touching.id in toxic)
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
	var/trigger_phoron = 0
	var/trigger_oxy = 0
	var/trigger_co2 = 0
	var/trigger_nitro = 0

	var/turf/T = get_turf(holder)
	var/datum/gas_mixture/env = T.return_air()
	if(env)
		if(env.temperature < 225)
			trigger_cold = 1
		else if(env.temperature > 375)
			trigger_hot = 1

		if(env.gas["phoron"] >= 10)
			trigger_phoron = 1
		if(env.gas["oxygen"] >= 10)
			trigger_oxy = 1
		if(env.gas["carbon_dioxide"] >= 10)
			trigger_co2 = 1
		if(env.gas["nitrogen"] >= 10)
			trigger_nitro = 1

	for(var/datum/artifact_effect/my_effect in my_effects)
		my_effect.artifact_id = artifact_id

		my_effect.process()

		//COLD ACTIVATION
		if(my_effect.trigger == TRIGGER_COLD && (trigger_cold ^ my_effect.activated))
			my_effect.ToggleActivate()

		//HEAT ACTIVATION
		if(my_effect.trigger == TRIGGER_HEAT && (trigger_hot ^ my_effect.activated))
			my_effect.ToggleActivate()

		//PHORON GAS ACTIVATION
		if(my_effect.trigger == TRIGGER_PHORON && (trigger_phoron ^ my_effect.activated))
			my_effect.ToggleActivate()

		//OXYGEN GAS ACTIVATION
		if(my_effect.trigger == TRIGGER_OXY && (trigger_oxy ^ my_effect.activated))
			my_effect.ToggleActivate()

		//CO2 GAS ACTIVATION
		if(my_effect.trigger == TRIGGER_CO2 && (trigger_co2 ^ my_effect.activated))
			my_effect.ToggleActivate()

		//NITROGEN GAS ACTIVATION
		if(my_effect.trigger == TRIGGER_NITRO && (trigger_nitro ^ my_effect.activated))
			my_effect.ToggleActivate()
