//Straight import from Mexico and a direct hit to your heart
/mob/living/simple_mob/animal/passive/armadillo
	name = "armadillo"
	desc = "A small, armored mammal. It seems to enjoy rolling around and sleep as a ball."
	tt_desc = "Dasypus novemcinctus"
	//faction = "mexico" //They are from Mexico. //Amusing but this prompts aggression from crew-aligned mobs.

	icon = 'icons/mob/animal.dmi'
	icon_state = "armadillo"
	item_state = "armadillo_rest"
	icon_living = "armadillo"
	icon_rest = "armadillo_rest"
	icon_dead = "armadillo_dead"

	health = 30
	maxHealth = 30

	mob_size = MOB_SMALL
	pass_flags = PASSTABLE
	can_pull_size = ITEMSIZE_TINY
	can_pull_mobs = MOB_PULL_NONE
	layer = MOB_LAYER
	density = 0
	movement_cooldown = 0.75 //roughly a bit faster than a person

	response_help  = "pets"
	response_disarm = "rolls aside"
	response_harm   = "stomps"

	melee_damage_lower = 2
	melee_damage_upper = 1
	attacktext = list("nips", "bumps", "scratches")

	vore_taste = "sand"

	min_oxy = 16 //Require atleast 16kPA oxygen
	minbodytemp = 223		//Below -50 Degrees Celcius
	maxbodytemp = 523	//Above 80 Degrees Celcius
	heat_damage_per_tick = 3
	cold_damage_per_tick = 3

	meat_amount = 2
	holder_type = /obj/item/holder/armadillo
	ai_holder_type = /datum/ai_holder/simple_mob/armadillo

	speak_emote = list("rumbles", "chirr?", "churr")

	say_list_type = /datum/say_list/armadillo

	var/obj/item/clothing/head/hat = null // The hat the armadillo may be wearing.

//Hat simulator stolen from slime code.
/mob/living/simple_mob/animal/passive/armadillo/Destroy()
	if(hat)
		drop_hat()
	return ..()

/mob/living/simple_mob/animal/passive/armadillo/update_icon()
	..() // Do the regular stuff first.

	// Hat simulator.
	if(hat)
		var/hat_state = hat.item_state ? hat.item_state : hat.icon_state
		var/image/I = image('icons/inventory/head/mob.dmi', src, hat_state)
		I.pixel_y = -7 // Smol
		I.appearance_flags = RESET_COLOR
		add_overlay(I)

// Clicked on by empty hand.
/mob/living/simple_mob/animal/passive/armadillo/attack_hand(mob/living/L)
	if(L.a_intent == I_GRAB && hat)
		remove_hat(L)
	else
		..()

/mob/living/simple_mob/animal/passive/armadillo/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/clothing/head)) // Handle hat simulator.
		give_hat(I, user)
		return
	..()

// Hat simulator
/mob/living/simple_mob/animal/passive/armadillo/proc/give_hat(var/obj/item/clothing/head/new_hat, var/mob/living/user)
	if(!istype(new_hat))
		to_chat(user, span_warning("\The [new_hat] isn't a hat."))
		return
	if(hat)
		to_chat(user, span_warning("\The [src] is already wearing \a [hat]."))
		return
	else
		user.drop_item(new_hat)
		hat = new_hat
		new_hat.forceMove(src)
		to_chat(user, span_notice("You place \a [new_hat] on \the [src].  How adorable!"))
		update_icon()
		return

/mob/living/simple_mob/animal/passive/armadillo/proc/remove_hat(var/mob/living/user)
	if(!hat)
		to_chat(user, span_warning("\The [src] doesn't have a hat to remove."))
	else
		hat.forceMove(get_turf(src))
		user.put_in_hands(hat)
		to_chat(user, span_warning("You take away \the [src]'s [hat.name].  How mean."))
		hat = null
		update_icon()

/mob/living/simple_mob/animal/passive/armadillo/proc/drop_hat()
	if(!hat)
		return
	hat.forceMove(get_turf(src))
	hat = null
	update_icon()

/obj/item/holder/armadillo
	origin_tech = list(TECH_BIO = 1)
	default_worn_icon = 'icons/mob/head.dmi'
	//item_state = "armadillo_rest" //Commented here as a reminder that holders will always set the item_state to icon_rest. You cannot override it like this.

/mob/living/simple_mob/animal/passive/armadillo/torta
	name = "Torta"
	desc = "A small, armored mammal. It seems to be territorial and protective of the dorms."
	ai_holder_type = /datum/ai_holder/simple_mob/armadillo/torta

/mob/living/simple_mob/animal/passive/armadillo/torta/Initialize(mapload)
	. = ..()
	if(!hat)
		hat = new /obj/item/clothing/head/sombrero
		hat.forceMove(src)
		update_icon()

/datum/say_list/armadillo
	emote_hear = list("churrs","rumbles","chirrs")
	emote_see = list("rolls in place", "shuffles", "scritches at something")

/datum/ai_holder/simple_mob/armadillo
	hostile = FALSE
	retaliate = TRUE
	can_flee = TRUE
	flee_when_dying = TRUE
	dying_threshold = 0.9
	speak_chance = 1

/datum/ai_holder/simple_mob/armadillo/torta

/datum/ai_holder/simple_mob/armadillo/torta/on_hear_say(mob/living/speaker, message)
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(grande), message), 1 SECOND)

/datum/ai_holder/simple_mob/armadillo/torta/proc/grande(var/message)
	var/mob/living/simple_mob/animal/passive/armadillo/bol = holder
	if(!istype(bol))
		return
	message = lowertext(message)
	if(findtext(message, "grande"))
		bol.resize(bol.size_multiplier + 0.01)
		return
