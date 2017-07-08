/datum/trait/metabolism_up
	name = "Fast Metabolism"
	desc = "You process ingested and injected reagents faster, but get hungry faster."
	cost = 0
	var_changes = list("metabolic_rate" = 1.2)
	excludes = list(/datum/trait/metabolism_down, /datum/trait/metabolism_apex)

/datum/trait/metabolism_down
	name = "Slow Metabolism"
	desc = "You process ingested and injected reagents slower, but get hungry slower."
	cost = 0
	var_changes = list("metabolic_rate" = 0.8)
	excludes = list(/datum/trait/metabolism_up, /datum/trait/metabolism_apex)

/datum/trait/metabolism_apex
	name = "Apex Metabolism"
	desc = "Finally a proper excuse for your predatory actions. Also makes you process reagents faster but that's totally irrelevant. May cause excessive immersions with large/taur characters. Not recommended for efficient law-abiding workers or eco-aware NIF users."
	cost = 0
	var_changes = list("metabolic_rate" = 2)
	excludes = list(/datum/trait/metabolism_up, /datum/trait/metabolism_down)

/datum/trait/vore_numbing
	name = "Prey Numbing"
	desc = "Adds a 'Digest (Numbing)' belly mode, to douse prey in numbing enzymes during digestion."
	cost = 0
	var_changes = list("vore_numbing" = TRUE)

/datum/trait/cold_discomfort
	name = "Hot-Blooded"
	desc = "You are too hot at the standard 20C. 18C is more suitable. Rolling down your jumpsuit or being unclothed helps."
	cost = 0
	var_changes = list("heat_discomfort_level" = T0C+19)
	excludes = list(/datum/trait/hot_discomfort)

/datum/trait/hot_discomfort
	name = "Cold-Blooded"
	desc = "You are too cold at the standard 20C. 22C is more suitable. Wearing clothing that covers your legs and torso helps."
	cost = 0
	var_changes = list("cold_discomfort_level" = T0C+21)
	excludes = list(/datum/trait/cold_discomfort)
