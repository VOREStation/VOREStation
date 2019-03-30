// Thermic spiders inject a special variant of thermite that burns someone from the inside.

/datum/category_item/catalogue/fauna/giant_spider/thermic_spider
	name = "Giant Spider - Thermic"
	desc = "This specific spider has been catalogued as 'Thermic', \
	and it belongs to the 'Guard' caste. \
	The spider is colored orange, both body and eyes.\
	<br><br>\
	Compared to the other spiders in its caste, it has less strength and resilience, but instead has \
	an adaptation to more easily survive in high temperature environments. This was discovered when a group of \
	humans had an infestation of these, and their plan to \"kill it with fire\" failed.\
	<br><br>\
	The venom Thermic spiders use is very dangerous and unconventional, as it injects a liquid that combusts very \
	easily, even when inside of another living organism. The result is a gruesome death from literally burning from \
	the inside out."
	value = CATALOGUER_REWARD_MEDIUM

/mob/living/simple_mob/animal/giant_spider/thermic
	desc = "Mirage-cloaked and orange, it makes you shudder to look at it. This one has simmering orange eyes."
	catalogue_data = list(/datum/category_item/catalogue/fauna/giant_spider/thermic_spider)

	icon_state = "pit"
	icon_living = "pit"
	icon_dead = "pit_dead"

	maxHealth = 175
	health = 175

	melee_damage_lower = 10
	melee_damage_upper = 25

	heat_resist = 0.75
	cold_resist = -0.50

	poison_chance = 30
	poison_per_bite = 1
	poison_type = "thermite_v"
