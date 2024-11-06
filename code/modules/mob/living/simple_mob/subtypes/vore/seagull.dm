/datum/category_item/catalogue/fauna/seagull		// TODO: write actual lore if ever needed
	name = "Wildlife - Seagull"
	desc = "Classification: Larus brachyrhynchus\
	<br><br>\
	Gulls, or colloquially seagulls, are seabirds of the family Laridae in the suborder Lari. \
	They are most closely related to the terns and skimmers and only distantly related to auks, and even more distantly to waders."
	value = CATALOGUER_REWARD_TRIVIAL

/mob/living/simple_mob/vore/seagull
	name = "seagull"
	desc = "The most dangerous and hostile scavenger of seashores. Beware!"
	tt_desc = "Larus brachyrhynchus"
	catalogue_data = list(/datum/category_item/catalogue/fauna/seagull)

	icon_state = "seagull"
	icon_living = "seagull"
	icon_dead = "seagull_dead"
	icon_rest = "seagull"
	icon = 'icons/mob/vore.dmi'

	faction = FACTION_SEAGULL
	maxHealth = 25
	health = 25

	response_help = "pats"
	response_disarm = "gently pushes aside"
	response_harm = "hits"

	meat_amount = 2
	meat_type = /obj/item/reagent_containers/food/snacks/meat/chicken

	harm_intent_damage = 3
	melee_damage_lower = 4
	melee_damage_upper = 6
	attacktext = list("pecked", "pinched", "wingslapped")

	say_list_type = /datum/say_list/seagull
	ai_holder_type = /datum/ai_holder/simple_mob/passive

	vore_active = 1
	vore_capacity = 5
	vore_bump_chance = 25
	vore_bump_emote	= "greedily dives at"
	vore_pounce_chance = 70
	vore_default_mode = DM_HOLD
	vore_icons = SA_ICON_LIVING
	belly_size_multiplier = 2.5

/datum/say_list/seagull
	speak = list("Ha-Ha-Ha!","Huoh-Huoh-Huoh!","Keow?")
	emote_hear = list("screams!","chirps.")
	emote_see = list("pecks at the ground","looks around hungrily")

/mob/living/simple_mob/vore/seagull/update_icon()
	. = ..()

	if(vore_fullness >= 2)
		movement_cooldown = 10
	else if(movement_cooldown == 10)
		movement_cooldown = initial(movement_cooldown)
