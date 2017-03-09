/mob/living/simple_animal/fox
	name = "fox"
	desc = "It's a fox. I wonder what it says?"
	icon = 'icons/mob/fox_vr.dmi'
	icon_state = "fox"
	icon_living = "fox"
	icon_dead = "fox_dead"
	speak = list("Ack-Ack","Ack-Ack-Ack-Ackawoooo","Awoo","Tchoff")
	speak_emote = list("geckers", "barks")
	emote_hear = list("howls","barks")
	emote_see = list("shakes its head", "shivers", "geckers")
	speak_chance = 1
	turns_per_move = 5
	see_in_dark = 6
	meat_type = /obj/item/weapon/reagent_containers/food/snacks/meat/fox
	response_help = "scritches"
	response_disarm = "gently pushes aside"
	response_harm = "kicks"
	var/turns_since_scan = 0
	var/mob/living/simple_animal/mouse/movement_target
	var/mob/flee_target
	min_oxy = 16 			//Require atleast 16kPA oxygen
	minbodytemp = 223		//Below -50 Degrees Celcius
	maxbodytemp = 323		//Above 50 Degrees Celcius
	mob_size = MOB_TINY
	isPredator = 1

/mob/living/simple_animal/fox/New()
	if(!vore_organs.len)
		var/datum/belly/B = new /datum/belly(src)
		B.immutable = 1
		B.name = "Stomach"
		B.inside_flavor = "Slick foxguts. Cute on the outside, slimy on the inside!"
		B.human_prey_swallow_time = swallowTime
		B.nonhuman_prey_swallow_time = swallowTime
		vore_organs[B.name] = B
		vore_selected = B.name

		B.emote_lists[DM_HOLD] = list(
			"The foxguts knead and churn around you harmlessly.",
			"With a loud glorp, some air shifts inside the belly.",
			"A thick drop of warm bellyslime drips onto you from above.",
			"The fox turns suddenly, causing you to shift a little.",
			"During a moment of relative silence, you can hear the fox breathing.",
			"The slimey stomach walls squeeze you lightly, then relax.")

		B.emote_lists[DM_DIGEST] = list(
			"The guts knead at you, trying to work you into thick soup.",
			"You're ground on by the slimey walls, treated like a mouse.",
			"The acrid air is hard to breathe, and stings at your lungs.",
			"You can feel the acids coating you, ground in by the slick walls.",
			"The fox's stomach churns hungrily over your form, trying to take you.",
			"With a loud glorp, the stomach spills more acids onto you.")
	..()

//For resting sprites
/mob/living/simple_animal/fox/lay_down()
	..()
	if(icon_rest)
		icon_state = resting ? icon_rest : icon_living

// All them complicated fox procedures.
/mob/living/simple_animal/fox/Life()
	//MICE!
	if((loc) && isturf(loc))
		if(!stat && !resting && !buckled)
			for(var/mob/living/simple_animal/mouse/M in loc)
				if(isPredator) //If the fox is a predator,
					movement_target = null
					custom_emote(1, "greedily stuffs [M] into their gaping maw!")
					if(M in oview(1, src))
						animal_nom(M)
					else
						M << "You just manage to slip away from [src]'s jaws before you can be sent to a fleshy prison!"
					break
				else
					if(!M.stat)
						M.splat()
						visible_emote(pick("bites \the [M]!","toys with \the [M].","chomps on \the [M]!"))
						movement_target = null
						stop_automated_movement = 0
						break
	..()

	for(var/mob/living/simple_animal/mouse/snack in oview(src,5))
		if(snack.stat < DEAD && prob(15))
			audible_emote(pick("hunkers down!","acts stealthy!","eyes [snack] hungrily."))
		break

	if(!stat && !resting && !buckled) //SEE A MICRO AND ARE A PREDATOR, EAT IT!
		for(var/mob/living/carbon/human/food in oview(src, 5))

			if(food.size_multiplier <= RESIZE_A_SMALLTINY)
				if(prob(10))
					custom_emote(1, pick("eyes [food] hungrily!","licks their lips and turns towards [food] a little!","pants as they imagine [food] being in their belly."))
					break
				else
					if(prob(5))
						movement_target = food
						break

		for(var/mob/living/carbon/human/bellyfiller in oview(1, src))
			if(bellyfiller in src.prey_excludes)
				continue

			if(bellyfiller.size_multiplier <= RESIZE_A_SMALLTINY && isPredator)
				movement_target = null
				custom_emote(1, pick("slurps [bellyfiller] with their slimey tongue.","looms over [bellyfiller] with their maw agape.","sniffs at [bellyfiller], their belly grumbling hungrily."))
				sleep(10)
				custom_emote(1, "starts to scoop [bellyfiller] into their maw!")
				if(bellyfiller in oview(1, src))
					animal_nom(bellyfiller)
				else
					bellyfiller << "You just manage to slip away from [src]'s jaws before you can be sent to a fleshy prison!"
				break

	if(!stat && !resting && !buckled)
		turns_since_scan++
		if (turns_since_scan > 5)
			walk_to(src,0)
			turns_since_scan = 0

			if (flee_target) //fleeing takes precendence
				handle_flee_target()
			else
				handle_movement_target()

/mob/living/simple_animal/fox/proc/handle_movement_target()
	//if our target is neither inside a turf or inside a human(???), stop
	if((movement_target) && !(isturf(movement_target.loc) || ishuman(movement_target.loc) ))
		movement_target = null
		stop_automated_movement = 0
	//if we have no target or our current one is out of sight/too far away
	if( !movement_target || !(movement_target.loc in oview(src, 4)) )
		movement_target = null
		stop_automated_movement = 0
		for(var/mob/living/simple_animal/mouse/snack in oview(src)) //search for a new target
			if(isturf(snack.loc) && !snack.stat)
				movement_target = snack
				break

	if(movement_target)
		stop_automated_movement = 1
		walk_to(src,movement_target,0,10)

/mob/living/simple_animal/fox/proc/handle_flee_target()
	//see if we should stop fleeing
	if (flee_target && !(flee_target.loc in view(src)))
		flee_target = null
		stop_automated_movement = 0

	if (flee_target)
		if(prob(25)) say("GRRRRR!")
		stop_automated_movement = 1
		walk_away(src, flee_target, 7, 2)

/mob/living/simple_animal/fox/proc/set_flee_target(atom/A)
	if(A)
		flee_target = A
		turns_since_scan = 5

/mob/living/simple_animal/fox/attackby(var/obj/item/O, var/mob/user)
	. = ..()
	if(O.force)
		set_flee_target(user? user : src.loc)


/mob/living/simple_animal/fox/attack_hand(mob/living/carbon/human/M as mob)
	. = ..()
	if(M.a_intent == "hurt")
		set_flee_target(M)

/mob/living/simple_animal/fox/ex_act()
	. = ..()
	set_flee_target(src.loc)

/mob/living/simple_animal/fox/bullet_act(var/obj/item/projectile/proj)
	. = ..()
	set_flee_target(proj.firer? proj.firer : src.loc)

/mob/living/simple_animal/fox/hitby(atom/movable/AM)
	. = ..()
	set_flee_target(AM.thrower? AM.thrower : src.loc)

/mob/living/simple_animal/fox/MouseDrop(atom/over_object)

	var/mob/living/carbon/H = over_object
	if(!istype(H) || !Adjacent(H)) return ..()

	if(H.a_intent == "help")
		get_scooped(H)
		return
	else
		return ..()

/mob/living/simple_animal/fox/get_scooped(var/mob/living/carbon/grabber)
	if (stat >= DEAD)
		return //since the holder icon looks like a living cat
	..()

//Basic friend AI
/mob/living/simple_animal/fox/fluff
	var/mob/living/carbon/human/friend
	var/befriend_job = null

/mob/living/simple_animal/fox/fluff/handle_movement_target()
	if (friend)
		var/follow_dist = 5
		if (friend.stat >= DEAD || friend.health <= config.health_threshold_softcrit) //danger
			follow_dist = 1
		else if (friend.stat || friend.health <= 50) //danger or just sleeping
			follow_dist = 2
		var/near_dist = max(follow_dist - 2, 1)
		var/current_dist = get_dist(src, friend)

		if (movement_target != friend)
			if (current_dist > follow_dist && !istype(movement_target, /mob/living/simple_animal/mouse) && (friend in oview(src)))
				//stop existing movement
				walk_to(src,0)
				turns_since_scan = 0

				//walk to friend
				stop_automated_movement = 1
				movement_target = friend
				walk_to(src, movement_target, near_dist, 4)

		//already following and close enough, stop
		else if (current_dist <= near_dist)
			walk_to(src,0)
			movement_target = null
			stop_automated_movement = 0
			if (prob(10))
				say("Yap!")

	if (!friend || movement_target != friend)
		..()

/mob/living/simple_animal/fox/fluff/Life()
	..()
	if (stat || !friend)
		return
	if (get_dist(src, friend) <= 1)
		if (friend.stat >= DEAD || friend.health <= config.health_threshold_softcrit)
			if (prob((friend.stat < DEAD)? 50 : 15))
				var/verb = pick("huffs", "whines", "yowls")
				audible_emote(pick("[verb] in distress.", "[verb] anxiously."))
		else
			if (prob(5))
				visible_emote(pick("nips [friend] affectionately.",
								   "yaps at [friend].",
								   "looks at [friend], wagging.",
								   "wags happily."))
	else if (friend.health <= 50)
		if (prob(10))
			var/verb = pick("huffs", "whines", "yowls")
			audible_emote("[verb] anxiously.")

/mob/living/simple_animal/fox/fluff/verb/friend()
	set name = "Become Friends"
	set category = "IC"
	set src in view(1)

	if(friend && usr == friend)
		set_dir(get_dir(src, friend))
		say("Yap!")
		return

	if (!(ishuman(usr) && befriend_job && usr.job == befriend_job))
		usr << "<span class='notice'>[src] ignores you.</span>"
		return

	friend = usr
	prey_excludes |= usr

	set_dir(get_dir(src, friend))
	say("Yap!")

/obj/item/weapon/reagent_containers/food/snacks/meat/fox
	name = "Fox meat"
	desc = "The fox doesn't say a god damn thing, now."

//Captain fox
/mob/living/simple_animal/fox/fluff/Renault
	name = "Renault"
	desc = "Renault, the Colony Director's trustworthy fox. I wonder what it says?"
	isPredator = 1
	befriend_job = "Colony Director"

/mob/living/simple_animal/fox/fluff/Renault/New()
	if(!vore_organs.len)
		var/datum/belly/B = new /datum/belly(src)
		B.immutable = 1
		B.name = "Stomach"
		B.inside_flavor = "Slick foxguts. They seem somehow more regal than perhaps other foxes!"
		B.human_prey_swallow_time = swallowTime
		B.nonhuman_prey_swallow_time = swallowTime
		vore_organs[B.name] = B
		vore_selected = B.name

		B.emote_lists[DM_HOLD] = list(
			"Renault's stomach walls squeeze around you more tightly for a moment, before relaxing, as if testing you a bit.",
			"There's a sudden squeezing as Renault presses a forepaw against his gut over you, squeezng you against the slick walls.",
			"The 'head fox' has a stomach that seems to think you belong to it. It might be hard to argue, as it kneads at your form.",
			"If being in the captain's fox is a promotion, it might not feel like one. The belly just coats you with more thick foxslime.",
			"It doesn't seem like Renault wants to let you out. The stomach and owner possessively squeeze around you.",
			"Renault's stomach walls squeeze closer, as he belches quietly, before swallowing more air. Does he do that on purpose?")

		B.emote_lists[DM_DIGEST] = list(
			"Renault's stomach walls grind hungrily inwards, kneading acids against your form, and treating you like any other food.",
			"The captain's fox impatiently kneads and works acids against you, trying to claim your body for fuel.",
			"The walls knead in firmly, squeezing and tossing you around briefly in disorienting aggression.",
			"Renault belches, letting the remaining air grow more acrid. It burns your lungs with each breath.",
			"A thick glob of acids drip down from above, adding to the pool of caustic fluids in Renault's belly.",
			"There's a loud gurgle as the stomach declares the intent to make you a part of Renault.")

	..()

/mob/living/simple_animal/fox/syndicate
	name = "syndi-fox"
	desc = "It's a DASTARDLY fox! The horror! Call the shuttle!"
	icon = 'icons/mob/fox_vr.dmi'
	icon_state = "syndifox"
	icon_living = "syndifox"
	icon_dead = "syndifox_dead"
	icon_rest = "syndifox_rest"
