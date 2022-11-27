/mob/living/simple_mob/animal/sif/grafadreka
	// Some mobtypes are immune to stun, so trying to incapacitate them
	// is pointless. Track them here so we don't endlessly run away from
	// Beepsky until he beats us to death.
	var/static/list/stun_immune_types = list(
		/mob/living/bot,
		/mob/living/simple_mob/humanoid/merc
	)

/mob/living/simple_mob/animal/sif/grafadreka/ICheckRangedAttack(atom/A)
	. = ..() && isliving(A) && has_sap(2) && (world.time >= next_spit)
	if(.)

		var/mob/living/M = A
		if(M.lying || M.confused || M.incapacitated())
			return FALSE // They're already stunned, go bite their nipples off.

		for(var/mobtype in stun_immune_types)
			if(istype(A, mobtype))
				return FALSE

/mob/living/simple_mob/animal/sif/grafadreka/IIsAlly(mob/living/L)
	. = ..()
	// If we're starving or we've been attacked by a neutral party, all bets are off.
	if(!. && (nutrition > max_nutrition * 0.15) && !attacked_by_neutral)
		// Robots aren't every tasty.
		if(isrobot(L))
			return TRUE
		// We don't normally target anything bigger than us.
		if(L.mob_size > mob_size)
			return TRUE
		// Leave humans alone generally, unless they look like a snack.
		if(ishuman(L) && !issmall(L))
			return TRUE
		// Avoid cannibalism.
		if(istype(L, /mob/living/simple_mob/animal/sif/grafadreka))
			return TRUE

/mob/living/simple_mob/animal/sif/grafadreka/proc/IDoInteraction(var/obj/item/target)
	set waitfor = FALSE
	face_atom(target)
	do_interaction(target)

/mob/living/simple_mob/animal/sif/grafadreka/proc/is_supposedly_neutral(var/mob/living/person)
	return istype(person) && (ishuman(person) || isrobot(person) || person.faction == "station")

// If we get attacked by a nominally neutral mob, set us to angery mode.
/mob/living/simple_mob/animal/sif/grafadreka/IWasAttackedBy(var/mob/living/attacker)
	. = ..()
	if(is_supposedly_neutral(attacker))
		attacked_by_neutral = TRUE
		ai_holder.hostile = TRUE

/datum/ai_holder/simple_mob/intentional/grafadreka
	hostile =             TRUE
	retaliate =           TRUE
	cooperative =         TRUE
	can_flee =            TRUE
	flee_when_dying =     TRUE
	home_low_priority =   TRUE
	var/next_food_check = 0
	var/next_sap_check =  0
	var/next_heal_check = 0

/datum/ai_holder/simple_mob/intentional/grafadreka/should_flee(force)
	. = ..()
	if(!. && isliving(target))
		var/mob/living/prey = target
		var/mob/living/simple_mob/animal/sif/grafadreka/drake = holder
		// If they're incapacitated, don't need to spit on them again.
		if(!istype(drake) || drake.can_bite(prey))
			return FALSE
		// We can spit at them - disengage so you can pew pew.
		if(get_dist(target, holder) <= 1 && drake.has_sap(2) && (world.time >= drake.next_spit))
			// No point spitting at immune mobs.
			for(var/mobtype in drake.stun_immune_types)
				if(istype(target, mobtype))
					return FALSE
			return TRUE

/datum/ai_holder/simple_mob/intentional/grafadreka/pre_ranged_attack(atom/A)
	holder.a_intent = I_HURT

/datum/ai_holder/simple_mob/intentional/grafadreka/pre_melee_attack(atom/A)
	holder.a_intent = I_HURT

/datum/ai_holder/simple_mob/intentional/grafadreka/post_melee_attack()
	if(holder.has_modifier_of_type(/datum/modifier/ace))
		request_help()
	return ..()

/datum/ai_holder/simple_mob/intentional/grafadreka/handle_special_strategical()
	follow_distance = rand(initial(follow_distance), initial(follow_distance) + 2)
	if(holder.has_modifier_of_type(/datum/modifier/ace))
		if(leader)
			lose_follow()
	else
		if(!leader)
			var/mob/living/simple_mob/animal/sif/grafadreka/drake = holder
			if(istype(drake))
				set_follow(drake.get_pack_leader())
	return ..()

/datum/ai_holder/simple_mob/intentional/grafadreka/handle_stance_strategical()

	. = ..()

	var/mob/living/simple_mob/animal/sif/grafadreka/drake = holder
	if(!istype(drake))
		return

	if(drake.resting && stance != STANCE_IDLE)
		drake.lay_down()

	if(stance in STANCES_COMBAT)
		return

	// Heal anyone near us who needs it.
	if(stance == STANCE_IDLE && drake.has_sap(10)) // explicit stance check so they stop trying to heal for 15 seconds during flee behavior
		for(var/mob/living/friend in range(1, get_turf(holder)))
			if(!holder.Adjacent(friend) || friend == target || friend.stat == DEAD)
				continue
			// Some specific checks here rather than IIsAlly() as we have some behavior to avoid
			// attacking humans, but don't necessarily want to go lick them if they get a papercut.
			if(!(friend in drake.friends) && !(friend in drake.tamers) && drake.faction != friend.faction)
				continue
			if(!friend.has_modifier_of_type(/datum/modifier/sifsap_salve) && drake.can_tend_wounds(friend))
				drake.a_intent = I_HELP
				drake.IDoInteraction(friend)
				return
		if(world.time >= next_heal_check)
			next_heal_check = world.time + 15 SECONDS
			for(var/mob/living/friend in view(world.view, drake))
				if(target == friend || friend.stat == DEAD || friend.has_modifier_of_type(/datum/modifier/sifsap_salve))
					continue
				if(((friend in drake.friends) || (friend in drake.tamers) || drake.faction == friend.faction) && drake.can_tend_wounds(friend))
					give_destination(get_turf(friend))
					return

	// These actions need space in our stomach to be worth considering at all.
	if(drake.has_appetite() && !(locate(/datum/reagent/nutriment) in drake.reagents.reagent_list))

		// Find some sap if we're low and aren't already digesting some.
		if(!drake.has_sap(20) && !drake.reagents.has_reagent("sifsap"))
			for(var/obj/structure/flora/tree/sif/tree in range(1, holder))
				if(holder.Adjacent(tree) && tree.can_forage(drake))
					drake.a_intent = I_HELP
					drake.IDoInteraction(tree)
					return
			if(world.time >= next_sap_check)
				next_sap_check = world.time + 15 SECONDS
				for(var/obj/structure/flora/tree/sif/tree in view(world.view, drake))
					if(tree.can_forage(drake))
						give_destination(get_turf(tree))
						return

		// Are we hungy?
		if(drake.nutrition < drake.max_nutrition * 0.6)
			var/atom/movable/food
			for(var/thing in range(1, drake))
				if(istype(thing, /obj/item/reagent_containers/food) || istype(thing, /obj/item/organ))
					food = thing
					break
				if(isliving(thing))
					var/mob/living/M = thing
					if(M.stat == DEAD)
						food = M
						break
			if(food)
				drake.a_intent = I_HURT
				drake.IDoInteraction(food)
				return
			if(world.time >= next_food_check)
				food = null
				next_food_check = world.time + 15 SECONDS
				for(var/thing in view(world.view, drake))
					if(istype(thing, /obj/item/reagent_containers/food) || istype(thing, /obj/item/organ))
						food = thing
					else if(isliving(thing))
						var/mob/living/M = thing
						if(M.stat == DEAD)
							food = M
					if(food)
						give_destination(get_turf(food))
						return

/mob/living/simple_mob/animal/sif/grafadreka/hatchling/IWasAttackedBy(var/mob/living/attacker)
	. = ..()
	if(is_supposedly_neutral(attacker))
		for(var/mob/living/simple_mob/animal/sif/grafadreka/friend in viewers(world.view, src))
			if(friend == src || !IIsAlly(friend))
				continue
			friend.IWasAttackedBy(attacker)
