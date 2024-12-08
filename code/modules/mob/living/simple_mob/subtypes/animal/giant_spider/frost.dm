// Frost spiders inject cryotoxin, slowing people down (which is very bad if trying to run from spiders).

/datum/category_item/catalogue/fauna/giant_spider/frost_spider
	name = "Giant Spider - Frost"
	desc = "This specific spider has been catalogued as 'Frost', \
	and it belongs to the 'Guard' caste. \
	The spider is blue, and often has ice hanging off of it. It is also said to have an icy gaze, with its blue eyes. \
	<br><br>\
	It has adapted for survival in colder climates, with its body able to insulate itself from colder environments. \
	Unfortunately for it, this also has given them a vulnerability to heat.\
	<br><br>\
	Frost Spider venom causes a sharp decrease in body temperature to those bitten, which causes \
	hypothermia. It also slows down the victim, making it more difficult to escape by fleeing. \
	The danger is amplified by the fact that humans that receive the venom are often wearing \
	thermal insulating clothing, making it more difficult to warm up."
	value = CATALOGUER_REWARD_MEDIUM

/mob/living/simple_mob/animal/giant_spider/frost
	desc = "Icy and blue, it makes you shudder to look at it. This one has brilliant blue eyes."
	catalogue_data = list(/datum/category_item/catalogue/fauna/giant_spider/frost_spider)

	icon_state = "frost"
	icon_living = "frost"
	icon_dead = "frost_dead"

	maxHealth = 175
	health = 175

	poison_per_bite = 5
	poison_type = REAGENT_ID_CRYOTOXIN
	heat_resist = -0.50
	cold_resist = 0.75

// Sif variant with a somewhat different desc.
/mob/living/simple_mob/animal/giant_spider/frost/sif
	desc = "Icy and blue, it makes you shudder to look at it. This one has brilliant blue eyes. \
	It isn't native to Sif."
