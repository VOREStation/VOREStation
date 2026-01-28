/datum/trait/metabolism_up
	name = "Metabolism, Fast"
	desc = "You process ingested and injected reagents faster, but get hungry faster (Teshari speed)."
	cost = 0
	can_take = ORGANICS|SYNTHETICS
	var_changes = list("metabolic_rate" = 1.2, "hunger_factor" = 0.2, "metabolism" = 0.06) // +20% rate and 4x hunger (Teshari level)
	excludes = list(/datum/trait/metabolism_down, /datum/trait/metabolism_apex, /datum/trait/singularity_metabolism)
	custom_only = FALSE
	category = TRAIT_TYPE_NEUTRAL

/datum/trait/metabolism_down
	name = "Metabolism, Slow"
	desc = "You process ingested and injected reagents slower, but get hungry slower."
	cost = 0
	can_take = ORGANICS|SYNTHETICS
	var_changes = list("metabolic_rate" = 0.8, "hunger_factor" = 0.04, "metabolism" = 0.0012) // -20% of default.
	excludes = list(/datum/trait/metabolism_up, /datum/trait/metabolism_apex, /datum/trait/singularity_metabolism)
	custom_only = FALSE
	category = TRAIT_TYPE_NEUTRAL

/datum/trait/metabolism_apex
	name = "Metabolism, Apex"
	desc = "Finally a proper excuse for your predatory actions. Essentially doubles the fast trait rates. Good for characters with big appetites."
	cost = 0
	can_take = ORGANICS|SYNTHETICS
	var_changes = list("metabolic_rate" = 1.4, "hunger_factor" = 0.4, "metabolism" = 0.012) // +40% rate and 8x hunger (Double Teshari)
	excludes = list(/datum/trait/metabolism_up, /datum/trait/metabolism_down, /datum/trait/singularity_metabolism)
	custom_only = FALSE
	category = TRAIT_TYPE_NEUTRAL

/datum/trait/singularity_metabolism
	name = "Metabolism, Singularity"
	desc = "You are insanely hungry. You can seemingly never get enough to eat. Perhaps you had a singularity as an ancestor, or maybe one is currently living inside of your gut."
	cost = 0
	var_changes = list("metabolic_rate" = 2, "hunger_factor" = 1.6, "metabolism" = 0.012)	//2x metabolism speed, 32x hunger speed
	custom_only = FALSE
	category = TRAIT_TYPE_NEUTRAL

	excludes = list(/datum/trait/metabolism_up, /datum/trait/metabolism_down, /datum/trait/metabolism_apex)
