// Pepper spiders inject condensed capsaicin into their victims.

/datum/category_item/catalogue/fauna/giant_spider/pepper_spider
	name = "Giant Spider - Pepper"
	desc = "This specific spider has been catalogued as 'Pepper', \
	and it belongs to the 'Guard' caste. \
	Red makes up a majority of the spider's appearance, including its eyes, with some brown on its body as well. \
	<br><br>\
	Pepper spiders are named due to producing capsaicin, and using it as a venom to incapacitate their prey, in an \
	incredibly painful way. Their raw strength is considerably less than some of the other spiders, however \
	they share a similar level of endurance with the other spiders in their caste, making them difficult to put down."
	value = CATALOGUER_REWARD_MEDIUM

/mob/living/simple_mob/animal/giant_spider/pepper
	desc = "Red and brown, it makes you shudder to look at it. This one has glinting red eyes."
	catalogue_data = list(/datum/category_item/catalogue/fauna/giant_spider/pepper_spider)

	icon_state = "pepper"
	icon_living = "pepper"
	icon_dead = "pepper_dead"

	maxHealth = 210
	health = 210

	melee_damage_lower = 8
	melee_damage_upper = 15

	poison_chance = 20
	poison_per_bite = 5
	poison_type = REAGENT_ID_CONDENSEDCAPSAICINV

/mob/living/simple_mob/animal/giant_spider/pepper/Initialize(mapload)
	adjust_scale(1.1)
	return ..()
