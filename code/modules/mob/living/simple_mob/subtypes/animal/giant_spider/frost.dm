// Frost spiders inject cryotoxin, slowing people down (which is very bad if trying to run from spiders).

/mob/living/simple_mob/animal/giant_spider/frost
	desc = "Icy and blue, it makes you shudder to look at it. This one has brilliant blue eyes."
	icon_state = "frost"
	icon_living = "frost"
	icon_dead = "frost_dead"

	maxHealth = 175
	health = 175

	poison_per_bite = 5
	poison_type = "cryotoxin"
	heat_resist = -0.50
	cold_resist = 0.75

// Sif variant with a somewhat different desc.
/mob/living/simple_mob/animal/giant_spider/frost/sif
	desc = "Icy and blue, it makes you shudder to look at it. This one has brilliant blue eyes. \
	It isn't native to Sif."
