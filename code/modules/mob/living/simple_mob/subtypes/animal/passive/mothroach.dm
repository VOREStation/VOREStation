/datum/category_item/catalogue/fauna/mothroach
	name = "Alien Wildlife - Mothroach"
	desc = "The Mothroach is a terrestrial creature that is a hybrid between a mothperson and a cockroach."
	value = CATALOGUER_REWARD_MEDIUM

/mob/living/simple_mob/animal/passive/mothroach
	name = "mothroach"
	desc = "This is the adorable by-product of multiple attempts at genetically mixing mothpeople with cockroaches."
	catalogue_data = list(/datum/category_item/catalogue/fauna/mothroach)

	icon = 'icons/mob/animal.dmi'
	icon_state = "mothroach"
	icon_living = "mothroach"
	icon_dead = "mothroach_dead"
	icon_rest = "mothroach_rest"

	faction = FACTION_MOTHROACH
	maxHealth = 50
	health = 50
	movement_cooldown = -1

	see_in_dark = 10

	meat_amount = 2
	meat_type = /obj/item/reagent_containers/food/snacks/meat
	holder_type = /obj/item/holder/mothroach

	response_help   = "pats"
	response_disarm = "shoos"
	response_harm   = "hits"
	speak_emote = list("flutters")

	harm_intent_damage = 1
	melee_damage_lower = 1
	melee_damage_upper = 2
	attack_sharp = FALSE
	attacktext = list("hits")

	mob_size = MOB_SMALL
	pass_flags = PASSTABLE
	density = FALSE
	friendly = list("pats")
	can_climb = TRUE
	climbing_delay = 2.0

	say_list_type = /datum/say_list/mothroach

	allow_mind_transfer = TRUE

/mob/living/simple_mob/animal/passive/mothroach/Initialize(mapload)
	. = ..()

	add_verb(src, /mob/living/proc/ventcrawl)
	add_verb(src, /mob/living/proc/hide)

	real_name = name

/mob/living/simple_mob/animal/passive/mothroach/attack_hand(mob/user)
	. = ..()

	if(stat != DEAD)
		playsound(src, 'sound/voice/scream/moth/moth_scream.ogg', 50, TRUE)

/mob/living/simple_mob/animal/passive/mothroach/attackby(obj/item/O, mob/user)
	. = ..()

	if(stat != DEAD)
		playsound(src, 'sound/voice/scream/moth/moth_scream.ogg', 50, TRUE)

/datum/say_list/mothroach
	emote_hear = list("flutters")

/obj/item/holder/mothroach
	name = "mothroach"
	desc = "This is the adorable by-product of multiple attempts at genetically mixing mothpeople with cockroaches."

	icon = 'icons/mob/animal.dmi'
	icon_state = "mothroach"

	item_state = "mothroach"
	slot_flags = SLOT_HEAD
	w_class = ITEMSIZE_TINY
	item_icons = list(
		slot_l_hand_str = 'icons/mob/lefthand_holder.dmi',
		slot_r_hand_str = 'icons/mob/righthand_holder.dmi',
		slot_head_str = 'icons/mob/head.dmi',
	)

/mob/living/simple_mob/animal/passive/mothroach/bar
	name = "mothroach bartender"
	desc = "A mothroach serving drinks. Look at him go."
	icon_state = "barroach"
	icon_living = "barroach"
	icon_dead = "barroach_dead"

	holder_type = /obj/item/holder/mothroach/bar

/obj/item/holder/mothroach/bar
	item_state = "barroach"
