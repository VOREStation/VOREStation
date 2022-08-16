/mob/living/simple_mob/animal/sif/grafadreka/ICheckRangedAttack(atom/A)
	. = ..() && isliving(A)
	if(.)
		var/mob/living/M = A
		if(M.lying || M.incapacitated())
			. = FALSE // They're already stunned, go bite their nipples off.

/mob/living/simple_mob/animal/sif/grafadreka/IIsAlly(mob/living/L)
	. = ..()
	// Avoid humans unless we're very hungry, very angry, or they are small).
	if(!. && ishuman(L) && !attacked_by_human)
		. = !issmall(L) && (nutrition > max_nutrition * 0.15)

/mob/living/simple_mob/animal/sif/grafadreka/proc/IDoInteraction(var/obj/item/target)
	set waitfor = FALSE
	face_atom(target)
	do_interaction(target)

/mob/living/simple_mob/animal/sif/grafadreka/IWasAttackedBy(var/mob/living/attacker)
	if(ishuman(attacker))
		attacked_by_human = TRUE
		if(istype(ai_holder, /datum/ai_holder/simple_mob/intentional/grafadreka))
			var/datum/ai_holder/simple_mob/intentional/grafadreka/drake_brain = ai_holder
			drake_brain.hostile = TRUE

/datum/ai_holder/simple_mob/intentional/grafadreka
	hostile =         TRUE
	retaliate =       TRUE
	cooperative =     TRUE
	can_flee =        TRUE
	flee_when_dying = TRUE
	var/next_food_check
	var/next_sap_check
	var/next_heal_check

/datum/ai_holder/simple_mob/intentional/grafadreka/should_flee(force)
	. = ..()
	if(!. && ismob(target))
		var/mob/living/prey = target
		var/mob/living/simple_mob/animal/sif/grafadreka/drake = holder
		// If they're incapacitated, don't need to spit on them again.
		if(!istype(drake) || prey.lying || prey.incapacitated())
			return FALSE
		// We can spit at them - disengage so you can pew pew.
		if(get_dist(target, holder) <= 1 && drake.has_sap(2))
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
				set_follow(drake.get_local_alpha())
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
	if(drake.reagents && abs(drake.reagents.total_volume - drake.reagents.maximum_volume) >= 10)

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
