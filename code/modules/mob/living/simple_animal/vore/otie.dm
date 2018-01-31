// ToDo: Make this code not a fucking snowflaky horrible broken mess. Do not use until it's actually fixed. It's miserably bad right now.
// Also ToDo: Dev-to-dev communication to ensure responsible parties (if available. In this case, yes.) are aware of what's going on and what's broken.
// Probably easier to troubleshoot when we ain't breaking the server by spawning a buttload of heavily extra feature coded snowflake mobs to the wilderness as mass cannonfodder.
// Also ToDo: An actual "simple" mob for that purpose if necessary :v

/mob/living/simple_animal/otie //Spawn this one only if you're looking for a bad time. Not friendly.
	name = "otie"
	desc = "The classic bioengineered longdog."
	icon = 'icons/mob/vore64x32.dmi'
	icon_state = "otie"
	icon_living = "otie"
	icon_dead = "otie-dead"
	icon_rest = "otie_rest"
	faction = "otie"
	recruitable = 1
	maxHealth = 150
	health = 150
	minbodytemp = 200
	move_to_delay = 4
	hostile = 1
	investigates = 1
	reacts = 1
	retaliate = 1
	specific_targets = 1
	run_at_them = 0
	attack_same = 0
	speak_chance = 4
	speak = list("Boof.","Waaf!","Prurr.","Bork!","Rurrr..","Arf.")
	speak_emote = list("growls", "roars", "yaps", "Awoos")
	emote_hear = list("rurrs", "rumbles", "rowls", "groans softly", "murrs", "sounds hungry", "yawns")
	emote_see = list("stares ferociously", "snarls", "licks their chops", "stretches", "yawns")
	say_maybe_target = list("Ruh?", "Waf?")
	say_got_target = list("Rurrr!", "ROAR!", "MARR!", "RERR!", "RAHH!", "RAH!", "WARF!")
	melee_damage_lower = 5
	melee_damage_upper = 15 //Don't break my bones bro
	response_help = "pets the"
	response_disarm = "bops the"
	response_harm = "hits the"
	attacktext = "mauled"
	friendly = list("nuzzles", "slobberlicks", "noses softly at", "noseboops", "headbumps against", "leans on", "nibbles affectionately on")
	meat_amount = 6
	old_x = -16
	old_y = 0
	pixel_x = -16
	pixel_y = 0

	var/mob/living/carbon/human/friend
	var/tamed = 0
	var/tame_chance = 50 //It's a fiddy-fiddy default you may get a buddy pal or you may get mauled and ate. Win-win!

// Activate Noms!

/mob/living/simple_animal/otie
	vore_active = 1
	vore_capacity = 1
	vore_pounce_chance = 20
	vore_icons = SA_ICON_LIVING

/mob/living/simple_animal/otie/feral //gets the pet2tame feature. starts out hostile tho so get gamblin'
	name = "mutated feral otie"
	desc = "The classic bioengineered longdog. No pets. Only bite. This one has mutated from too much time out on the surface of Virgo-3B."
	icon_state = "siftusian"
	icon_living = "siftusian"
	icon_dead = "siftusian-dead"
	icon_rest = "siftusian_rest"
	faction = "virgo3b"
	tame_chance = 5 // Only a 1 in 20 chance of success. It's feral. What do you expect?
	melee_damage_lower = 10
	melee_damage_upper = 25
	// Lazy way of making sure this otie survives outside.
	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0

/mob/living/simple_animal/otie/friendly //gets the pet2tame feature and doesn't kill you right away
	name = "otie"
	desc = "The classic bioengineered longdog. This one might even tolerate you!"
	faction = "neutral"
	tamed = 1

/mob/living/simple_animal/otie/cotie //same as above but has a little collar :v
	name = "tamed otie"
	desc = "The classic bioengineered longdog. This one has a nice little collar on its neck. However a proper domesticated otie is an oxymoron and the collar is likely just a decoration."
	icon_state = "cotie"
	icon_living = "cotie"
	icon_rest = "cotie_rest"
	faction = "neutral"
	tamed = 1

/mob/living/simple_animal/otie/cotie/phoron //friendly phoron pup with collar
	name = "mutated otie"
	desc = "Looks like someone did manage to domesticate one of those wild phoron mutants. What a badass."
	icon_state = "pcotie"
	icon_living = "pcotie"
	icon_rest = "pcotie_rest"
	icon_dead = "siftusian-dead"
	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0

/mob/living/simple_animal/otie/security //tame by default unless you're a marked crimester. can be befriended to follow with pets tho.
	name = "guard otie"
	desc = "The VARMAcorp bioengineering division flagship product on trained optimal snowflake guard dogs."
	icon_state = "sotie"
	icon_living = "sotie"
	icon_rest = "sotie_rest"
	icon_dead = "sotie-dead"
	faction = "neutral"
	maxHealth = 200 //armored or something
	health = 200
	tamed = 1
	loot_list = list(/obj/item/clothing/glasses/sunglasses/sechud,/obj/item/clothing/suit/armor/vest/alt)
	vore_pounce_chance = 60 // Good boys don't do too much police brutality.

	var/check_records = 0 // If true, arrests people without a record.
	var/check_arrest = 1 // If true, arrests people who are set to arrest.

/mob/living/simple_animal/otie/security/phoron
	name = "mutated guard otie"
	desc = "An extra rare phoron resistant version of the VARMAcorp trained snowflake guard dogs."
	icon_state = "sifguard"
	icon_living = "sifguard"
	icon_rest = "sifguard_rest"
	icon_dead = "sifguard-dead"
	melee_damage_lower = 10
	melee_damage_upper = 25
	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0

/mob/living/simple_animal/otie/PunchTarget()
	if(istype(target_mob,/mob/living/simple_animal/mouse))
		return EatTarget()
	else ..()

/mob/living/simple_animal/otie/Found(var/atom/found_atom)
	if(!SA_attackable(found_atom))
		return null
	if(istype(found_atom,/mob/living/simple_animal/mouse))
		return found_atom
	else if(ismob(found_atom))
		var/mob/found_mob = found_atom
		if(found_mob.faction == faction)
			return null
		else if(friend == found_atom)
			return null
		else if(tamed == 1 && ishuman(found_atom))
			return null
		else if(tamed == 1 && isrobot(found_atom))
			return null
		else
			if(resting)
				lay_down()
			return found_atom
	else
		return null

/mob/living/simple_animal/otie/security/Found(var/atom/found_atom)
	if(check_threat(found_atom) >= 4)
		if(resting)
			lay_down()
		return found_atom
	..()

/mob/living/simple_animal/otie/attackby(var/obj/item/O, var/mob/user) // Trade donuts for bellybrig victims.
	if(istype(O, /obj/item/weapon/reagent_containers/food))
		qdel(O)
		playsound(src.loc,'sound/items/eatfood.ogg', rand(10,50), 1)
		if(ai_inactive)//No autobarf on player control.
			return
		if(istype(O, /obj/item/weapon/reagent_containers/food/snacks/donut) && istype(src, /mob/living/simple_animal/otie/security))
			user << "<span class='notice'>The guard pup accepts your offer for their catch.</span>"
			for(var/I in vore_organs)
				var/datum/belly/B = vore_organs[I]
				B.release_all_contents()
			return
		if(prob(2)) //Small chance to get prey out from non-sec oties.
			for(var/I in vore_organs)
				var/datum/belly/B = vore_organs[I]
				B.release_all_contents()
			return
		return
	..()

/mob/living/simple_animal/otie/security/feed_grabbed_to_self(var/mob/living/user, var/mob/living/prey) // Make the gut start out safe for bellybrigging.
	var/datum/belly/B = user.vore_selected
	var/datum/belly/belly_target = user.vore_organs[B]
	if(ishuman(target_mob))
		belly_target.digest_mode = DM_HOLD
	if(istype(prey,/mob/living/simple_animal/mouse))
		belly_target.digest_mode = DM_DIGEST
	..()

/mob/living/simple_animal/otie/security/proc/check_threat(var/mob/living/M)
	if(!M || !ishuman(M) || M.stat == DEAD || src == M)
		return 0
	return M.assess_perp(0, 0, 0, check_records, check_arrest)

/mob/living/simple_animal/otie/security/set_target(var/mob/M)
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
			global_announcer.autosay("[src] is attempting to 'detain' suspect <b>[target_name(M)]</b> in <b>[get_area(src)]</b>.", "[src]", "Security")
	else if(investigates)
		spawn(1)
			WanderTowards(seen)

	return 0


/mob/living/simple_animal/otie/security/proc/target_name(mob/living/T)
	if(ishuman(T))
		var/mob/living/carbon/human/H = T
		return H.get_id_name("unidentified person")
	return "unidentified lifeform"

//Basic friend AI

/mob/living/simple_animal/otie/Life()
	. = ..()
	if(!. || ai_inactive) return

	if(prob(5) && (stance == STANCE_IDLE))
		lay_down()

	if(!friend) return

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
								   "noses at [friend].",
								   "slobberlicks [friend].",
								   "murrs contently.",
								   "leans on [friend].",
								   "nibbles affectionately on [friend]."))
	else if (friend.health <= 50)
		if (prob(10))
			var/verb = pick("whines", "yelps", "whimpers")
			audible_emote("[verb] anxiously.")

//Pet 4 friendly

/mob/living/simple_animal/otie/attack_hand(mob/living/carbon/human/M as mob)

	switch(M.a_intent)
		if(I_HELP)
			if(health > 0)
				M.visible_message("<span class='notice'>[M] [response_help] \the [src].</span>")
				if(ai_inactive)
					return
				LoseTarget()
				handle_stance(STANCE_IDLE)
				if(prob(tame_chance))
					friend = M
					if(tamed != 1)
						tamed = 1
						faction = M.faction
				sleep(1 SECOND)

		if(I_GRAB)
			if(health > 0)
				if(ai_inactive)
					return
				audible_emote("growls disapprovingly at [M].")
				if(M == friend)
					friend = null
				return
			else
				..()

		else
			..()

/mob/living/simple_animal/otie/death(gibbed, deathmessage = "dies!")
	resting = 0
	icon_state = icon_dead
	update_icon()
	..()
