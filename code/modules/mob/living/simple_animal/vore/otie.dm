/mob/living/simple_animal/otie //Spawn this one only if you're looking for a bad time.
	name = "otie"
	desc = "The classic bioengineered longdog."
	icon = 'icons/mob/vore64x32.dmi'
	icon_state = "otie"
	icon_living = "otie"
	icon_dead = "otie-dead"
	icon_rest = "otie_rest"
	faction = "otie"
	recruitable = 1
	maxHealth = 120
	health = 120
	minbodytemp = 200
	move_to_delay = 4
	hostile = 1
	cooperative = 1
	investigates = 1
	reacts = 1
	retaliate = 1
	specific_targets = 1
	run_at_them = 0
	attack_same = 0
	speak_chance = 4
	speak = list("Boof.","Waaf!","Prurrrr.","Growl!","Bork!","Rurrr..","Aruur!","Awoo!")
	speak_emote = list("growls", "roars", "yaps", "Awoos")
	emote_hear = list("rurrs", "rumbles", "rowls", "groans softly", "murrs", "sounds hungry", "yawns")
	emote_see = list("stares ferociously", "snarls", "licks their chops", "stretches", "yawns")
	say_maybe_target = list("Ruh?", "Waf?")
	say_got_target = list("Rurrr!", "ROAR!", "MINE!", "RAHH!", "Slurp.. RAH!")
	melee_damage_lower = 5
	melee_damage_upper = 20
	response_help = "pets the"
	response_disarm = "bops the"
	response_harm = "hits the"
	attacktext = "mauled"
	friendly = list("nuzzles", "slobberlicks", "noses softly at", "noseboops")
	meat_amount = 5
	old_x = -16
	old_y = 0
	pixel_x = -16
	pixel_y = 0

	var/mob/living/carbon/human/friend
	var/tamed = 0

/mob/living/simple_animal/otie/fluff
	name = "otie"
	desc = "The classic bioengineered longdog. This one might even tolerate you!"
	icon_state = "otie"
	icon_living = "otie"
	icon_rest = "otie_rest"
	faction = "neutral"

/mob/living/simple_animal/otie/fluff/cotie
	name = "tamed otie"
	desc = "The classic bioengineered longdog. This one has a nice little collar on its neck. However a proper domesticated otie is an oxymoron and the collar is likely just a decoration."
	icon_state = "cotie"
	icon_living = "cotie"
	icon_rest = "cotie_rest"
	faction = "neutral"

/mob/living/simple_animal/otie/fluff/security
	name = "guard otie"
	desc = "The V.A.R.M.A.corp bioengineering division flagship product on trained optimal snowflake guard dogs."
	icon_state = "sotie"
	icon_living = "sotie"
	icon_rest = "sotie_rest"
	icon_dead = "sotie-dead"
	faction = "neutral"
	tamed = 1
	maxHealth = 150
	health = 150
	loot_list = list(/obj/item/clothing/glasses/sunglasses/sechud,/obj/item/clothing/suit/armor/vest/alt)

	var/check_records = 1 // If true, arrests people without a record.
	var/check_arrest = 1 // If true, arrests people who are set to arrest.

/mob/living/simple_animal/otie/PunchTarget()
	if(istype(target_mob,/mob/living/simple_animal/mouse))
		return EatTarget()
	else ..()

/mob/living/simple_animal/otie/Found(var/atom/found_atom)
	if(!SA_attackable(found_atom))
		return null
	if(istype(found_atom,/mob/living/simple_animal/mouse))
		return found_atom
	if(will_eat(found_atom))
		if(found_atom in friends)
			return null
		else if(found_atom in faction_friends)
			return null
		else if (friend == found_atom)
			return null
		else if(tamed == 1 && ishuman(found_atom))
			return null
		else if(tamed == 1 && isrobot(found_atom))
			return null
		else
			return found_atom

/mob/living/simple_animal/otie/fluff/security/Found(var/atom/found_atom)
	if(!SA_attackable(found_atom))
		return null
	if(istype(found_atom,/mob/living/simple_animal/mouse))
		return found_atom
	if(check_threat(found_atom) >= 4)
		return found_atom
	if(will_eat(found_atom))
		if(found_atom in friends)
			return null
		else if(found_atom in faction_friends)
			return null
		else if (friend == found_atom)
			return null
		else if(tamed == 1 && ishuman(found_atom))
			return null
		else if(tamed == 1 && isrobot(found_atom))
			return null
		else
			return found_atom

/mob/living/simple_animal/otie/fluff/security/proc/check_threat(var/mob/living/M)
	if(!M || !ishuman(M) || M.stat == DEAD || src == M)
		return 0
	return M.assess_perp(0, 0, 0, check_records, check_arrest)

/mob/living/simple_animal/otie/fluff/security/set_target(var/mob/M)
	ai_log("SetTarget([M])",2)
	if(!M || (world.time - last_target_time < 5 SECONDS) && target_mob)
		ai_log("SetTarget() can't set it again so soon",3)
		return 0

	var/turf/seen = get_turf(M)

	if(investigates && (annoyed < 10))
		try_say_list(say_maybe_target)
		face_atom(seen)
		annoyed += 14
		sleep(1 SECOND) //For realism

	if(M in ListTargets(view_range))
		try_say_list(say_got_target)
		target_mob = M
		last_target_time = world.time
		return M
		if(check_threat(M) >= 4)
			broadcast_security_hud_message("[src] is attempting to 'detain' suspect <b>[target_name(M)]</b> in <b>[get_area(src)]</b>.", src)
	else if(investigates)
		spawn(1)
			WanderTowards(seen)

	return 0


/mob/living/simple_animal/otie/fluff/security/proc/target_name(mob/living/T)
	if(ishuman(T))
		var/mob/living/carbon/human/H = T
		return H.get_id_name("unidentified person")
	return "unidentified lifeform"

//Basic friend AI

/mob/living/simple_animal/otie/fluff/Life()
	. = ..()
	if(!. || ai_inactive || !friend) return

	var/friend_dist = get_dist(src,friend)

	if (friend_dist <= 4)
		if(stance == STANCE_IDLE)
			if(set_follow(friend))
				handle_stance(STANCE_FOLLOW)
				if(resting)
					lay_down()

	if (friend_dist <= 1)
		if (friend.stat >= DEAD || friend.health <= config.health_threshold_softcrit)
			if (prob((friend.stat < DEAD)? 50 : 15))
				var/verb = pick("whines", "yelps", "whimpers")
				audible_emote(pick("[verb] in distress.", "[verb] anxiously."))
		else
			if (prob(5))
				visible_emote(pick("nuzzles [friend].",
								   "brushes against [friend].",
								   "rubs against [friend].",
								   "noses softly at [friend].",
								   "slobberlicks [friend].",
								   "murrs."))
	else if (friend.health <= 50)
		if (prob(10))
			var/verb = pick("whines", "yelps", "whimpers")
			audible_emote("[verb] anxiously.")

/mob/living/simple_animal/otie/Life()
	. = ..()
	if(!. || ai_inactive) return

	if(prob(5))
		lay_down()

//Pet 4 frond

/mob/living/simple_animal/otie/attack_hand(mob/living/carbon/human/M as mob)
	..()
	if(M.a_intent == I_HELP)
		if (health > 0)
			LoseTarget()
			handle_stance(STANCE_IDLE)
			if(prob(50)) //It's a fiddy-fiddy you may get a buddy pal or you may get mauled and ate. Win-win!
				friend = M
				if(tamed != 1)
					tamed = 1
			sleep(1 SECOND)
			return
			..()

// Activate Noms!

/mob/living/simple_animal/otie
	vore_active = 1
	vore_capacity = 1
	vore_escape_chance = 8
	vore_pounce_chance = 16
	vore_icons = SA_ICON_LIVING
