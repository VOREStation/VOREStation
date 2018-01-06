//Cat
/mob/living/simple_animal/cat
	name = "cat"
	desc = "A domesticated, feline pet. Has a tendency to adopt crewmembers."
	intelligence_level = SA_ANIMAL
	icon_state = "cat2"
	item_state = "cat2"
	icon_living = "cat2"
	icon_dead = "cat2_dead"
	icon_rest = "cat2_rest"

	hostile = 1 //To mice, anyway.
	investigates = 1
	specific_targets = 1 //Only targets with Found()
	run_at_them = 0 //DOMESTICATED
	view_range = 5

	turns_per_move = 5
	see_in_dark = 6

	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "kicks"

	min_oxy = 16 //Require atleast 16kPA oxygen
	minbodytemp = 223		//Below -50 Degrees Celcius
	maxbodytemp = 323	//Above 50 Degrees Celcius

	holder_type = /obj/item/weapon/holder/cat
	mob_size = MOB_SMALL

	has_langs = list("Cat")
	speak_chance = 1
	speak = list("Meow!","Esp!","Purr!","HSSSSS")
	speak_emote = list("purrs", "meows")
	emote_hear = list("meows","mews")
	emote_see = list("shakes their head", "shivers")
	say_maybe_target = list("Meow?","Mew?","Mao?")
	say_got_target = list("MEOW!","HSSSS!","REEER!")

	meat_amount = 1
	meat_type = /obj/item/weapon/reagent_containers/food/snacks/meat

	var/turns_since_scan = 0
	var/mob/flee_target

/mob/living/simple_animal/cat/Life()
	. = ..()
	if(!.) return

	if(prob(2)) //spooky
		var/mob/observer/dead/spook = locate() in range(src,5)
		if(spook)
			var/turf/T = spook.loc
			var/list/visible = list()
			for(var/obj/O in T.contents)
				if(!O.invisibility && O.name)
					visible += O
			if(visible.len)
				var/atom/A = pick(visible)
				visible_emote("suddenly stops and stares at something unseen[istype(A) ? " near [A]":""].")

	handle_flee_target()

/mob/living/simple_animal/cat/PunchTarget()
	if(istype(target_mob,/mob/living/simple_animal/mouse))
		var/mob/living/simple_animal/mouse/mouse = target_mob
		mouse.splat()
		visible_emote(pick("bites \the [mouse]!","toys with \the [mouse].","chomps on \the [mouse]!"))
		return mouse
	else
		..()

/mob/living/simple_animal/cat/Found(var/atom/found_atom)
	if(istype(found_atom,/mob/living/simple_animal/mouse) && SA_attackable(found_atom))
		return found_atom

/mob/living/simple_animal/cat/proc/handle_flee_target()
	//see if we should stop fleeing
	if (flee_target && !(flee_target in ListTargets(view_range)))
		flee_target = null
		GiveUpMoving()

	if (flee_target && !stat && !buckled)
		if (resting)
			lay_down()
		if(prob(25)) say("HSSSSS")
		stop_automated_movement = 1
		walk_away(src, flee_target, 7, 2)

/mob/living/simple_animal/cat/react_to_attack(var/atom/A)
	if(A == src) return
	flee_target = A
	turns_since_scan = 5

/mob/living/simple_animal/cat/ex_act()
	. = ..()
	react_to_attack(src.loc)

//Basic friend AI
/mob/living/simple_animal/cat/fluff
	var/mob/living/carbon/human/friend
	var/befriend_job = null

/mob/living/simple_animal/cat/fluff/Life()
	. = ..()
	if(!. || ai_inactive || !friend) return

	var/friend_dist = get_dist(src,friend)

	if (friend_dist <= 4)
		if(stance == STANCE_IDLE)
			if(set_follow(friend))
				handle_stance(STANCE_FOLLOW)

	if (friend_dist <= 1)
		if (friend.stat >= DEAD || friend.health <= config.health_threshold_softcrit)
			if (prob((friend.stat < DEAD)? 50 : 15))
				var/verb = pick("meows", "mews", "mrowls")
				audible_emote(pick("[verb] in distress.", "[verb] anxiously."))
		else
			if (prob(5))
				visible_emote(pick("nuzzles [friend].",
								   "brushes against [friend].",
								   "rubs against [friend].",
								   "purrs."))
	else if (friend.health <= 50)
		if (prob(10))
			var/verb = pick("meows", "mews", "mrowls")
			audible_emote("[verb] anxiously.")

/mob/living/simple_animal/cat/fluff/verb/become_friends()
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
						   "purrs."))
	else
		usr << "<span class='notice'>[src] ignores you.</span>"
	return

//RUNTIME IS ALIVE! SQUEEEEEEEE~
/mob/living/simple_animal/cat/fluff/Runtime
	name = "Runtime"
	desc = "Her fur has the look and feel of velvet, and her tail quivers occasionally."
	gender = FEMALE
	icon_state = "cat"
	item_state = "cat"
	icon_living = "cat"
	icon_dead = "cat_dead"
	icon_rest = "cat_rest"
	befriend_job = "Chief Medical Officer"

/mob/living/simple_animal/cat/kitten
	name = "kitten"
	desc = "D'aaawwww"
	icon_state = "kitten"
	item_state = "kitten"
	icon_living = "kitten"
	icon_dead = "kitten_dead"
	gender = NEUTER

// Leaving this here for now.
/obj/item/weapon/holder/cat/fluff/bones
	name = "Bones"
	desc = "It's Bones! Meow."
	gender = MALE
	icon_state = "cat3"

/mob/living/simple_animal/cat/fluff/bones
	name = "Bones"
	desc = "That's Bones the cat. He's a laid back, black cat. Meow."
	gender = MALE
	icon_state = "cat3"
	item_state = "cat3"
	icon_living = "cat3"
	icon_dead = "cat3_dead"
	icon_rest = "cat3_rest"
	holder_type = /obj/item/weapon/holder/cat/fluff/bones
	var/friend_name = "Erstatz Vryroxes"

/mob/living/simple_animal/cat/kitten/New()
	gender = pick(MALE, FEMALE)
	..()
