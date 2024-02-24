// Possum catalog entry.
/datum/category_item/catalogue/fauna/opossum
	name = "Opossums"
	desc = "The opossum is a small, scavenging marsupial of the order Didelphimorphia, previously \
	endemic to the Americas of Earth, but now inexplicably found across settled space. Nobody is \
	entirely sure how they travel to such disparate locations, with the leading theories including \
	smuggling, cargo stowaways, fungal spore reproduction, teleportation, or unknown quantum effects."
	value = CATALOGUER_REWARD_TRIVIAL
	unlocked_by_any = list(/datum/category_item/catalogue/fauna/opossum)

// Possum spawner, WAS GOING TO BE used for loot piles BUT CERB IS A DORK.
/obj/item/animal_spawner
	var/critter_type = /mob/living/simple_mob/animal/passive/mouse

/obj/item/animal_spawner/Initialize()
	..()

	var/mob/living/simple_mob/critter = critter_type
	if(!ispath(critter, /mob/living/simple_mob))
		return INITIALIZE_HINT_QDEL

	var/obj/item/weapon/holder/critter_holder = initial(critter.holder_type)
	if(!ispath(critter_holder, /obj/item/weapon/holder))
		return INITIALIZE_HINT_QDEL

	var/mob/M = loc
	var/was_in_hands = istype(M) && (src == M.get_active_hand() || src == M.get_inactive_hand())

	critter = new critter(critter_holder)
	critter_holder = new(loc, critter)

	if(istype(M))
		M.drop_from_inventory(src)
		if(was_in_hands)
			M.put_in_hands(critter_holder)

	return INITIALIZE_HINT_QDEL

/obj/item/animal_spawner/possum
	name = "possum"
	desc = "The abstract concept of possum, embodied in physical form. If you witness the majesty of abstract possum, please make a bug report on the tracker."
	icon = 'icons/mob/animal.dmi'
	icon_state = "possum"
	critter_type = /mob/living/simple_mob/animal/passive/opossum

// Possum AI holder, mostly just handles playing dead.
/datum/ai_holder/simple_mob/passive/possum
	var/is_angry = FALSE
	var/play_dead_until = 0
	var/be_angery_until = 0

/datum/ai_holder/simple_mob/passive/possum/handle_special_strategical()
	. = ..()
	if(holder?.stat != DEAD && !holder.ckey && isturf(holder.loc))
		if(holder.resting && world.time < play_dead_until)
			return

		var/last_resting = holder.resting
		var/last_angery = is_angry
		holder.resting = (holder.stat == UNCONSCIOUS)
		if(!holder.resting)
			wander = initial(wander)
			speak_chance = initial(speak_chance)
			holder.set_stat(CONSCIOUS)
			is_angry = (world.time < be_angery_until) || prob(1)
		else
			wander = FALSE
			speak_chance = 0
			holder.set_stat(UNCONSCIOUS)
			is_angry = FALSE

		if(last_resting != holder.resting || last_angery != is_angry)
			holder.update_icon()

/datum/ai_holder/simple_mob/passive/possum/poppy
	var/static/list/aaa_words = list(
		"delaminat",
		"meteor",
		"fire",
		"breach",
		"loose",
		"level 7",
		"level seven",
		"biohazard",
		"blob",
		"vine"
	)

/datum/ai_holder/simple_mob/passive/possum/poppy/on_hear_say(mob/living/speaker, message)
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(check_keywords), message), rand(1 SECOND, 3 SECONDS))

/datum/ai_holder/simple_mob/passive/possum/poppy/proc/check_keywords(var/message)
	var/mob/living/simple_mob/animal/passive/opossum/poss = holder
	if(!istype(poss) || holder.client || holder.stat != CONSCIOUS)
		return
	message = lowertext(message)
	for(var/aaa in aaa_words)
		if(findtext(message, aaa))
			poss.respond_to_damage()
			return

/datum/say_list/possum
	speak = list("Hiss!","Aaa!","Aaa?")
	emote_hear = list("hisses")
	emote_see = list("forages for trash", "lounges")

// The poss itself.
/mob/living/simple_mob/animal/passive/opossum
	name = "opossum"
	real_name = "opossum"
	tt_desc = "Didelphis astrum"
	desc = "It's an opossum, a small scavenging marsupial."
	icon = 'icons/mob/pets.dmi'
	icon_state = "possum"
	item_state = "possum"
	icon_living = "possum"
	icon_dead = "possum_dead"
	icon_rest = "possum_dead"
	speak_emote = list("hisses")
	pass_flags = PASSTABLE
	ai_holder_type = /datum/ai_holder/simple_mob/passive/possum
	see_in_dark = 6
	maxHealth = 50
	health = 50
	response_help = "pets"
	response_disarm = "gently pushes aside"
	response_harm = "stamps on"
	density = FALSE
	organ_names = /decl/mob_organ_names/possum
	minbodytemp = 223
	maxbodytemp = 323
	universal_speak = FALSE
	universal_understand = TRUE
	holder_type = /obj/item/weapon/holder/possum
	mob_size = MOB_SMALL
	can_pull_size = 2
	can_pull_mobs = MOB_PULL_SMALLER
	say_list_type = /datum/say_list/possum
	catalogue_data = list(/datum/category_item/catalogue/fauna/opossum)
	meat_amount = 2

/mob/living/simple_mob/animal/passive/opossum/adjustBruteLoss(var/amount,var/include_robo)
	. = ..()
	if(amount >= 3)
		respond_to_damage()

/mob/living/simple_mob/animal/passive/opossum/adjustFireLoss(var/amount,var/include_robo)
	. = ..()
	if(amount >= 3)
		respond_to_damage()

/mob/living/simple_mob/animal/passive/opossum/lay_down()
	. = ..()
	update_icon()

/mob/living/simple_mob/animal/passive/opossum/proc/respond_to_damage()
	if(!resting && stat == CONSCIOUS)
		var/datum/ai_holder/simple_mob/passive/possum/poss_ai = ai_holder
		if(!client && istype(poss_ai))
			if(!poss_ai.is_angry)
				visible_message("<b>\The [src]</b> hisses!")
				poss_ai.is_angry = TRUE
				poss_ai.be_angery_until = world.time + rand(30 SECONDS, 1 MINUTE)
			else
				visible_message("<b>\The [src]</b> dies!")
				resting = TRUE
				poss_ai.play_dead_until = world.time + rand(1 MINUTE, 2 MINUTES)
		update_icon()

/mob/living/simple_mob/animal/passive/opossum/update_icon()
	update_icon()

/mob/living/simple_mob/animal/passive/opossum/update_icon()
	var/datum/ai_holder/simple_mob/passive/possum/poss_ai = ai_holder
	var/is_angry = (!client && istype(poss_ai) && poss_ai.is_angry)
	if(stat == DEAD || (resting && is_angry))
		icon_state = icon_dead
	else if(resting || stat == UNCONSCIOUS)
		icon_state = "[icon_living]_sleep"
	else if(is_angry)
		icon_state = "[icon_living]_aaa"
	else
		icon_state = icon_living

/mob/living/simple_mob/animal/passive/opossum/Initialize()
	. = ..()
	verbs += /mob/living/proc/ventcrawl
	verbs += /mob/living/proc/hide

/mob/living/simple_mob/animal/passive/opossum/poppy
	name = "Poppy the Safety Possum"
	desc = "It's an opossum, a small scavenging marsupial. It's wearing appropriate personal protective equipment, though."
	icon_state = "poppy"
	item_state = "poppy"
	icon_living = "poppy"
	icon_dead = "poppy_dead"
	icon_rest = "poppy_dead"
	tt_desc = "Didelphis astrum salutem"
	organ_names = /decl/mob_organ_names/poppy
	holder_type = /obj/item/weapon/holder/possum/poppy
	ai_holder_type = /datum/ai_holder/simple_mob/passive/possum/poppy

/decl/mob_organ_names/possum
	hit_zones = list("head", "body", "left foreleg", "right foreleg", "left hind leg", "right hind leg", "pouch")

/decl/mob_organ_names/poppy
	hit_zones = list("head", "body", "left foreleg", "right foreleg", "left hind leg", "right hind leg", "pouch", "cute little jacket")
