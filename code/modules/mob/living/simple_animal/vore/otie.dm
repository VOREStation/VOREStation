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
	maxHealth = 160
	health = 160
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
	var/threat = null

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

	var/check_records = 1 // If true, arrests people without a record.
	var/check_arrest = 1 // If true, arrests people who are set to arrest.

//Holy shit oh god how do I make it not destroy and devour everything indiscriminately!

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

/mob/living/simple_animal/otie/FindTarget()
	var/atom/T = null
	for(var/atom/A in ListTargets(view_range))

		if(A == src)
			continue

		var/atom/F = Found(A)
		if(F)
			T = F
			break
		else if(specific_targets)
			return 0

		if(isliving(A))
			var/mob/living/L = A
			if(L.faction == src.faction && !attack_same)
				continue
			else if(L in friends)
				continue
			else if(!SA_attackable(L))
				continue
			else if(tamed == 1 && ishuman(L))
				continue
			else if(tamed == 1 && isrobot(L))
				continue
			else
				T = L
				break

		else if(istype(A, /obj/mecha)) // Our line of sight stuff was already done in ListTargets().
			var/obj/mecha/M = A
			if(!SA_attackable(M))
				continue
			if((M.occupant.faction != src.faction) || attack_same)
				T = M
				break

	if(T) //Permission to fuck up and vore GET!
		ai_log("FindTarget() found [T]!",1)
		if(set_target(T))
			handle_stance(STANCE_ATTACK)

	return T

/mob/living/simple_animal/otie/fluff/security/FindTarget()
	var/atom/T = null
	for(var/atom/A in ListTargets(view_range))

		if(A == src)
			continue

		var/atom/F = Found(A)
		if(F)
			T = F
			break
		else if(specific_targets)
			return 0

		if(isliving(A))
			var/mob/living/L = A
			if(L.faction == src.faction && !attack_same)
				continue
			else if(L in friends)
				continue
			else if(!SA_attackable(L))
				continue
			else if(tamed == 1 && ishuman(L))
				continue
			else if(tamed == 1 && isrobot(L))
				continue
			else
				T = L
				break

		else if(istype(A, /obj/mecha)) // Our line of sight stuff was already done in ListTargets().
			var/obj/mecha/M = A
			if(!SA_attackable(M))
				continue
			if((M.occupant.faction != src.faction) || attack_same)
				T = M
				break

	if(T) //Permission to fuck up and vore GET!
		ai_log("FindTarget() found [T]!",1)
		if(set_target(T))
			if(check_threat(T) >= 4)
				broadcast_security_hud_message("[src] is attempting to 'detain' suspect <b>[target_name(T)]</b> in <b>[get_area(src)]</b>.", src)
				handle_stance(STANCE_ATTACK)
			else
				handle_stance(STANCE_ATTACK)

	return T

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
	switch(M.a_intent)

		if(I_HELP)
			if (health > 0)
				LoseTarget()
				handle_stance(STANCE_IDLE)
				if(prob(50)) //It's a fiddy-fiddy you may get a buddy pal or you may get mauled and ate. Win-win!
					friend = M
					if(tamed != 1)
						tamed = 1
				return
				..()

// Activate Noms!

/mob/living/simple_animal/otie
	vore_active = 1
	vore_capacity = 1
	vore_escape_chance = 8
	vore_pounce_chance = 19
	vore_icons = SA_ICON_LIVING
