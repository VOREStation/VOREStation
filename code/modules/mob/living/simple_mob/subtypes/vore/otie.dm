/datum/category_item/catalogue/fauna/otie		//TODO: VIRGO_LORE_WRITING_WIP
	name = "Creature - Otie"
	desc = "A bioengineered longdog, the otie is very long, and very cute, depending on if you like dogs, \
	especially long ones. They are black-and-grey furred, typically, and tanky, hard to kill. \
	They seem hostile at first, but are also tame-able if you can approach one. Nipnipnip-ACK \
	**the catalogue entry ends here.**"
	value = CATALOGUER_REWARD_MEDIUM

/mob/living/simple_mob/vore/otie //Spawn this one only if you're looking for a bad time. Not friendly.
	name = "otie"
	desc = "The classic bioengineered longdog."
	tt_desc = "Otus robustus"
	icon = 'icons/mob/vore64x32.dmi'
	icon_state = "otie"
	icon_living = "otie"
	icon_dead = "otie-dead"
	icon_rest = "otie_rest"
	faction = "otie"
	maxHealth = 150
	health = 150
	minbodytemp = 200
	melee_damage_lower = 10
	melee_damage_upper = 20 //Don't break my bones bro
	see_in_dark = 8
	response_help = "pets"
	response_disarm = "bops"
	response_harm = "hits"
	attacktext = list("mauled")
	friendly = list("nuzzles", "slobberlicks", "noses softly at", "noseboops", "headbumps against", "leans on", "nibbles affectionately on")
	meat_amount = 6
	old_x = -16
	old_y = 0
	default_pixel_x = -16
	pixel_x = -16
	pixel_y = 0

	max_buckled_mobs = 1 //Yeehaw
	can_buckle = TRUE
	buckle_movable = TRUE
	buckle_lying = FALSE
	mount_offset_y = 10

	ai_holder_type = /datum/ai_holder/simple_mob/melee/evasive/otie
	say_list_type = /datum/say_list/otie

	var/mob/living/carbon/human/friend
	var/tamed = 0
	var/tame_chance = 50 //It's a fiddy-fiddy default you may get a buddy pal or you may get mauled and ate. Win-win!

// Activate Noms!

/mob/living/simple_mob/vore/otie
	vore_active = 1
	vore_capacity = 1
	vore_pounce_chance = 20
	vore_icons = SA_ICON_LIVING | SA_ICON_REST
	vore_stomach_name = "Grut"
	vore_stomach_flavor = "You have ended up in the otie's primary stomach. The end of the line for the solidness of the most of its food. It is very hot and humid here, and it doesn't help that the little air left is saturated with pungent fumes of digesting food. The slimy folds of this powerful belly knead and squeeze firmly against your form, the globs and strands of the dark, almost tar-like internal slop within feel rather thick compared to the usual. The muscular walls seem awfully eager to cling and rub against you, while oozing numbingly thick and dense juices against your body."
	vore_default_contamination_flavor = "Acrid"
	vore_default_contamination_color = "black"
	vore_default_item_mode = IM_DIGEST

/mob/living/simple_mob/vore/otie/feral //gets the pet2tame feature. starts out hostile tho so get gamblin'
	name = "mutated feral otie"
	desc = "The classic bioengineered longdog. No pets. Only bite. This one has mutated from too much time out on the surface of Virgo-3B."
	tt_desc = "Otus phoronis"
	icon_state = "photie"
	icon_living = "photie"
	icon_dead = "photie-dead"
	icon_rest = "photie_rest"
	faction = "virgo3b"
	tame_chance = 5 // Only a 1 in 20 chance of success. It's feral. What do you expect?
	// Lazy way of making sure this otie survives outside.
	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	has_eye_glow = TRUE

/mob/living/simple_mob/vore/otie/feral/chubby
	name = "chubby mutated feral otie"
	desc = "The classic bioengineered longdog. No pets. Only bite. This one has mutated from too much time out on the surface of Virgo-3B. What an absolute unit."
	icon_state = "photiec"
	icon_living = "photiec"
	icon_rest = "photiec_rest"

/mob/living/simple_mob/vore/otie/red
	name = "feral red otie"
	desc = "Seems this ominous looking longdog has been infused with wicked infernal forces."
	tt_desc = "Otus infernalis"
	icon_state = "hotie"
	icon_living = "hotie"
	icon_dead = "hotie-dead"
	icon_rest = "hotie_rest"
	faction = "cult"
	tame_chance = 20
	// Lazy way of making sure this otie survives outside.
	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	maxbodytemp = 1000
	has_eye_glow = TRUE

/mob/living/simple_mob/vore/otie/red/friendly //gets the pet2tame feature and doesn't kill you right away
	name = "red otie"
	desc = "Seems this ominous looking longdog has been infused with wicked infernal forces. This one seems rather peaceful though."
	faction = "neutral"
	tamed = 1

/mob/living/simple_mob/vore/otie/red/chubby //gets the pet2tame feature and doesn't kill you right away
	name = "chubby red otie"
	desc = "Seems this ominous looking longdog has been infused with wicked infernal forces. What an absolute unit."
	icon_state = "hotiec"
	icon_living = "hotiec"
	icon_rest = "hotiec_rest"
	faction = "neutral"
	tamed = 1

/mob/living/simple_mob/vore/otie/friendly //gets the pet2tame feature and doesn't kill you right away
	name = "otie"
	desc = "The classic bioengineered longdog. This one might even tolerate you!"
	faction = "neutral"
	tamed = 1

/mob/living/simple_mob/vore/otie/friendly/chubby
	name = "chubby otie"
	desc = "The classic bioengineered longdog. This one might even tolerate you! What an absolute unit"
	icon_state = "fotie"
	icon_living = "fotie"
	icon_rest = "fotie_rest"

/mob/living/simple_mob/vore/otie/cotie //same as above but has a little collar :v
	name = "tamed otie"
	desc = "The classic bioengineered longdog. This one has a nice little collar on its neck. However a proper domesticated otie is an oxymoron and the collar is likely just a decoration."
	icon_state = "cotie"
	icon_living = "cotie"
	icon_rest = "cotie_rest"
	faction = "neutral"
	tamed = 1

/mob/living/simple_mob/vore/otie/cotie/chubby
	name = "chubby tamed otie"
	desc = "The classic bioengineered longdog. This one has a nice little collar on its neck. What an absolute unit."
	icon_state = "fcotie"
	icon_living = "fcotie"
	icon_rest = "fcotie_rest"

/mob/living/simple_mob/vore/otie/cotie/phoron //friendly phoron pup with collar
	name = "mutated otie"
	desc = "Looks like someone did manage to domesticate one of those wild phoron mutants. What a badass."
	tt_desc = "Otus phoronis"
	icon_state = "pcotie"
	icon_living = "pcotie"
	icon_rest = "pcotie_rest"
	icon_dead = "photie-dead"
	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	has_eye_glow = TRUE

/mob/living/simple_mob/vore/otie/security //tame by default unless you're a marked crimester. can be befriended to follow with pets tho.
	name = "guard otie"
	desc = "The VARMAcorp bioengineering division flagship product on big mean guard dogs."
	icon_state = "sotie"
	icon_living = "sotie"
	icon_rest = "sotie_rest"
	icon_dead = "sotie-dead"
	faction = "neutral"
	maxHealth = 200 //armored or something
	health = 200
	tamed = 1
	has_eye_glow = TRUE
	loot_list = list(/obj/item/clothing/glasses/sunglasses/sechud,/obj/item/clothing/suit/armor/vest/alt)
	vore_pounce_chance = 60 // Good boys don't do too much police brutality.

	var/check_records = 0 // If true, arrests people without a record.
	var/check_arrest = 1 // If true, arrests people who are set to arrest.

/mob/living/simple_mob/vore/otie/security/chubby
	name = "chubby guard otie"
	desc = "The VARMAcorp bioengineering division flagship product on big mean guard dogs. What an absolute unit."
	icon_state = "fsotie"
	icon_living = "fsotie"
	icon_rest = "fsotie_rest"
	icon_dead = "fsotie-dead"

/mob/living/simple_mob/vore/otie/security/phoron
	name = "mutated guard otie"
	desc = "An extra rare phoron resistant version of the VARMAcorp trained guard dogs adapted for hostile environments."
	tt_desc = "Otus phoronis"
	icon_state = "secphotie"
	icon_living = "secphotie"
	icon_rest = "secphotie_rest"
	icon_dead = "secphotie-dead"
	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0

/mob/living/simple_mob/vore/otie/security/phoron/red
	name = "red guard otie"
	desc = "An ominous looking version of the big mean VARMAcorp guard dogs."
	tt_desc = "Otus infernalis"
	icon_state = "sechotie"
	icon_living = "sechotie"
	icon_rest = "sechotie_rest"
	icon_dead = "sechotie-dead"
	maxbodytemp = 1000

/mob/living/simple_mob/vore/otie/security/phoron/red/chubby
	name = "chubby red guard otie"
	desc = "An ominous looking version of the big mean VARMAcorp guard dogs. What an absolute unit."
	icon_state = "hotiesc"
	icon_living = "hotiesc"
	icon_rest = "hotiesc_rest"

/mob/living/simple_mob/vore/otie/attackby(var/obj/item/O, var/mob/user) // Trade donuts for bellybrig victims.
	if(istype(O, /obj/item/weapon/reagent_containers/food))
		qdel(O)
		playsound(src,'sound/items/eatfood.ogg', rand(10,50), 1)
		if(!has_AI())//No autobarf on player control.
			return
		if(istype(O, /obj/item/weapon/reagent_containers/food/snacks/donut) && istype(src, /mob/living/simple_mob/vore/otie/security))
			to_chat(user,"<span class='notice'>The guard pup accepts your offer for their catch.</span>")
			release_vore_contents()
		else if(prob(2)) //Small chance to get prey out from non-sec oties.
			to_chat(user,"<span class='notice'>The pup accepts your offer for their catch.</span>")
			release_vore_contents()
		return
	. = ..()

/mob/living/simple_mob/vore/otie/security/feed_grabbed_to_self(var/mob/living/user, var/mob/living/prey) // Make the gut start out safe for bellybrigging.
	if(ishuman(prey))
		vore_selected.digest_mode = DM_HOLD
		if(check_threat(prey) >= 4)
			global_announcer.autosay("[src] is detaining suspect <b>[target_name(prey)]</b> in <b>[get_area(src)]</b>.", "SmartCollar oversight", "Security")
	if(istype(prey,/mob/living/simple_mob/animal/passive/mouse))
		vore_selected.digest_mode = DM_DIGEST
	. = ..()

/mob/living/simple_mob/vore/otie/security/proc/check_threat(var/mob/living/M)
	if(!M || !ishuman(M) || M.stat == DEAD || src == M)
		return 0
	return M.assess_perp(0, 0, 0, check_records, check_arrest)

/mob/living/simple_mob/vore/otie/security/proc/target_name(mob/living/T)
	if(ishuman(T))
		var/mob/living/carbon/human/H = T
		return H.get_id_name("unidentified person")
	return "unidentified lifeform"

//Pet 4 friendly

/mob/living/simple_mob/vore/otie/attack_hand(mob/living/carbon/human/M as mob)

	switch(M.a_intent)
		if(I_HELP)
			if(health > 0)
				M.visible_message("<span class='notice'>[M] [response_help] \the [src].</span>")
				if(has_AI())
					var/datum/ai_holder/AI = ai_holder
					AI.set_stance(STANCE_IDLE)
					if(prob(tame_chance))
						AI.hostile = FALSE
						friend = M
						AI.set_follow(friend)
						if(tamed != 1)
							tamed = 1
							faction = M.faction
					sleep(1 SECOND)

		if(I_GRAB)
			if(health > 0)
				if(has_AI())
					var/datum/ai_holder/AI = ai_holder
					audible_emote("growls disapprovingly at [M].")
					if(M == friend)
						AI.lose_follow()
						friend = null
				return
			else
				..()

		else
			..()

/mob/living/simple_mob/vore/otie/death(gibbed, deathmessage = "dies!")
	.=..()
	resting = 0
	icon_state = icon_dead

/mob/living/simple_mob/vore/otie/Login()
	. = ..()
	if(!riding_datum)
		riding_datum = new /datum/riding/simple_mob(src)
	verbs |= /mob/living/simple_mob/proc/animal_mount
	verbs |= /mob/living/proc/toggle_rider_reins
	movement_cooldown = 0

/mob/living/simple_mob/vore/otie/MouseDrop_T(mob/living/M, mob/living/user)
	return

/datum/say_list/otie
	speak = list("Boof.","Waaf!","Prurr.","Bork!","Rurrr..","Arf.")
	emote_hear = list("rurrs", "rumbles", "rowls", "groans softly", "murrs", "yawns")
	emote_see = list("stares ferociously", "snarls", "licks their chops", "stretches", "yawns")
	say_maybe_target = list("Ruh?", "Waf?")
	say_got_target = list("Rurrr!", "ROAR!", "MARR!", "RERR!", "RAHH!", "RAH!", "WARF!")

/datum/ai_holder/simple_mob/melee/evasive/otie

/datum/ai_holder/simple_mob/melee/evasive/otie/New(var/mob/living/simple_mob/vore/otie/new_holder)
	.=..()
	if(new_holder.tamed)
		hostile = FALSE
