//Cat
/mob/living/simple_animal/cat/bird
	name = "parrot"
	desc = "A domesticated bird. Has a tendency to 'adopt' crewmembers."
	isPredator = 1
	icon = 'icons/mob/birds.dmi'
	icon_state = "parrot-flap"
	item_state = null
	icon_living = "parrot-flap"
	icon_dead = "parrot-dead"
	speak = list("Chirp!","Caw!","Screech!","Squawk!")
	speak_emote = list("chirps", "caws")
	emote_hear = list("chirps","caws")
	emote_see = list("shakes their head", "ruffles their feathers")
	holder_type = /obj/item/weapon/holder/bird

/mob/living/simple_animal/cat/bird/New()
	if(!vore_organs.len)
		var/datum/belly/B = new /datum/belly(src)
		B.immutable = 1
		B.name = "Stomach"
		B.inside_flavor = "Slick birdguts. Cute on the outside, slimy on the inside!"
		B.human_prey_swallow_time = swallowTime
		B.nonhuman_prey_swallow_time = swallowTime
		vore_organs[B.name] = B
		vore_selected = B.name

		B.emote_lists[DM_HOLD] = list(
			"The birdguts knead and churn around you harmlessly.",
			"With a loud glorp, some air shifts inside the belly.",
			"A thick drop of warm bellyslime drips onto you from above.",
			"The bird goes into the air suddenly, causing you to be tossed about.",
			"During a moment of relative silence, you can hear the bird breathing.",
			"The slimey stomach walls squeeze you lightly, then relax.")

		B.emote_lists[DM_DIGEST] = list(
			"The guts knead at you, trying to work you into thick soup.",
			"You're ground on by the slimey walls, treated like a mouse.",
			"The acrid air is hard to breathe, and stings at your lungs.",
			"You can feel the acids coating you, ground in by the slick walls.",
			"The bird's stomach churns hungrily over your form, trying to take you.",
			"With a loud glorp, the stomach spills more acids onto you.")
	..()



/mob/living/simple_animal/cat/bird/Life()
	//MICE!
	if((src.loc) && isturf(src.loc))
		if(!stat && !resting && !buckled)
			for(var/mob/living/simple_animal/mouse/M in loc)
				if(!M.stat)
					M.splat()
					visible_emote(pick("bites \the [M]!","toys with \the [M].","chomps on \the [M]!"))
					movement_target = null
					stop_automated_movement = 0
					break

	..()

	for(var/mob/living/simple_animal/mouse/snack in oview(src,5))
		if(snack.stat < DEAD && prob(15))
			audible_emote(pick("chirps and caws!","squawks fiercely!","eyes [snack] hungrily."))
		break

	if(!stat && !resting && !buckled)
		turns_since_scan++
		if (turns_since_scan > 5)
			walk_to(src,0)
			turns_since_scan = 0

			if (flee_target) //fleeing takes precendence
				handle_flee_target_b()
			else
				handle_movement_target()

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
				custom_emote(1, pick("pecks at [bellyfiller] with their beak.","looms over [bellyfiller] with their beak agape.","sniffs at [bellyfiller], their belly grumbling hungrily."))
				sleep(10)
				custom_emote(1, "starts to scoop [bellyfiller] into their beak!")
				if(bellyfiller in oview(1, src))
					animal_nom(bellyfiller)
				else
					bellyfiller << "You just manage to slip away from [src]'s jaws before you can be sent to a fleshy prison!"
					break

/mob/living/simple_animal/cat/bird/proc/handle_flee_target_b()
	//see if we should stop fleeing
	if (flee_target && !(flee_target.loc in view(src)))
		flee_target = null
		stop_automated_movement = 0

	if (flee_target)
		if(prob(25)) say("Squawk!")
		stop_automated_movement = 1
		walk_away(src, flee_target, 7, 2)


//Basic friend AI
/mob/living/simple_animal/cat/bird/fluff
	var/mob/living/carbon/human/friend
	var/befriend_job = null

/mob/living/simple_animal/cat/bird/fluff/handle_movement_target()
	if (friend)
		var/follow_dist = 4
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
				say("Caw!")

	if (!friend || movement_target != friend)
		..()

/mob/living/simple_animal/cat/bird/fluff/Life()
	..()
	if (stat || !friend)
		return
	if (get_dist(src, friend) <= 1)
		if (friend.stat >= DEAD || friend.health <= config.health_threshold_softcrit)
			if (prob((friend.stat < DEAD)? 50 : 15))
				var/verb = pick("Chirps", "Caws", "Squawks")
				audible_emote(pick("[verb] in distress.", "[verb] anxiously."))
		else
			if (prob(5))
				visible_emote(pick("nuzzles [friend].",
								   "brushes against [friend].",
								   "rubs against [friend].",
								   "chirps."))
	else if (friend.health <= 50)
		if (prob(10))
			var/verb = pick("meows", "mews", "mrowls")
			audible_emote("[verb] anxiously.")

/mob/living/simple_animal/cat/bird/fluff/verb/become_friends_b()
	set name = "Become Friends"
	set category = "IC"
	set src in view(1)

	if(!friend)
		var/mob/living/carbon/human/H = usr
		if(istype(H) && (!befriend_job || H.job == befriend_job))
			friend = usr
			. = 1
	else if(usr == friend)
		. = 1 //already friends, but show success anyways

	if(.)
		set_dir(get_dir(src, friend))
		visible_emote(pick("nuzzles [friend].",
						   "brushes against [friend].",
						   "rubs against [friend].",
						   "chirps."))
	else
		usr << "<span class='notice'>[src] ignores you.</span>"
	return

/mob/living/simple_animal/cat/bird/fluff/kea
	name = "Kea"
	icon_state = "kea-flap"
	icon_living = "kea-flap"
	icon_dead = "kea-dead"

/mob/living/simple_animal/cat/bird/fluff/eclectus
	name = "Eclectus"
	icon_state = "eclectus-flap"
	icon_living = "eclectus-flap"
	icon_dead = "eclectus-dead"

/mob/living/simple_animal/cat/bird/fluff/eclectusf
	name = "Eclectus"
	icon_state = "eclectusf-flap"
	icon_living = "eclectusf-flap"
	icon_dead = "eclectusf-dead"

/mob/living/simple_animal/cat/bird/fluff/greybird
	name = "Grey Bird"
	icon_state = "agrey-flap"
	icon_living = "agrey-flap"
	icon_dead = "agrey-dead"

/mob/living/simple_animal/cat/bird/fluff/blue_caique
	name = "Blue Caique "
	icon_state = "bcaique-flap"
	icon_living = "bcaique-flap"
	icon_dead = "bcaique-dead"

/mob/living/simple_animal/cat/bird/fluff/white_caique
	name = "White caique"
	icon_state = "wcaique-flap"
	icon_living = "wcaique-flap"
	icon_dead = "wcaique-dead"

/mob/living/simple_animal/cat/bird/fluff/green_budgerigar
	name = "Green Budgerigar"
	icon_state = "gbudge-flap"
	icon_living = "gbudge-flap"
	icon_dead = "gbudge-dead"

/mob/living/simple_animal/cat/bird/fluff/blue_Budgerigar
	name = "Blue Budgerigar"
	icon_state = "bbudge-flap"
	icon_living = "bbudge-flap"
	icon_dead = "bbudge-dead"

/mob/living/simple_animal/cat/bird/fluff/bluegreen_Budgerigar
	name = "Bluegreen Budgerigar"
	icon_state = "bgbudge-flap"
	icon_living = "bgbudge-flap"
	icon_dead = "bgbudge-dead"

/mob/living/simple_animal/cat/bird/fluff/commonblackbird
	name = "Black Bird"
	icon_state = "commonblackbird"
	icon_living = "commonblackbird"
	icon_dead = "commonblackbird-dead"

/mob/living/simple_animal/cat/bird/fluff/azuretit
	name = "Azure Tit"
	icon_state = "azuretit"
	icon_living = "azuretit"
	icon_dead = "azuretit-dead"

/mob/living/simple_animal/cat/bird/fluff/europeanrobin
	name = "European Robin"
	icon_state = "europeanrobin"
	icon_living = "europeanrobin"
	icon_dead = "europeanrobin-dead"

/mob/living/simple_animal/cat/bird/fluff/goldcrest
	name = "Goldcrest"
	icon_state = "goldcrest"
	icon_living = "goldcrest"
	icon_dead = "goldcrest-dead"

/mob/living/simple_animal/cat/bird/fluff/ringneckdove
	name = "Ringneck Dove"
	icon_state = "ringneckdove"
	icon_living = "ringneckdove"
	icon_dead = "ringneckdove-dead"

/mob/living/simple_animal/cat/bird/fluff/cockatiel
	name = "Cockatiel"
	icon_state = "tiel-flap"
	icon_living = "tiel-flap"
	icon_dead = "tiel-dead"

/mob/living/simple_animal/cat/bird/fluff/white_cockatiel
	name = "White Cockatiel"
	icon_state = "wtiel-flap"
	icon_living = "wtiel-flap"
	icon_dead = "wtiel-dead"

/mob/living/simple_animal/cat/bird/fluff/yellowish_cockatiel
	name = "Yellowish Cockatiel"
	icon_state = "luttiel-flap"
	icon_living = "luttiel-flap"
	icon_dead = "luttiel-dead"

/mob/living/simple_animal/cat/bird/fluff/grey_cockatiel
	name = "Grey Cockatiel"
	icon_state = "blutiel-flap"
	icon_living = "blutiel-flap"
	icon_dead = "blutiel-dead"

/mob/living/simple_animal/cat/bird/fluff/too
	name = "Too"
	icon_state = "too-flap"
	icon_living = "too-flap"
	icon_dead = "too-dead"

/mob/living/simple_animal/cat/bird/fluff/hooded_too
	name = "Utoo"
	icon_state = "utoo-flap"
	icon_living = "utoo-flap"
	icon_dead = "utoo-dead"

/mob/living/simple_animal/cat/bird/fluff/pink_too
	name = "Mtoo"
	icon_state = "mtoo-flap"
	icon_living = "mtoo-flap"
	icon_dead = "mtoo-dead"

/obj/item/weapon/holder/bird
	name = "Bird"
	desc = "It's a bird!"
	icon_state = null
	item_icons = null