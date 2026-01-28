/datum/trait/speed_fast
	name = "Haste"
	desc = "Allows you to move faster on average than baseline."
	cost = 4
	var_changes = list("slowdown" = -0.5)
//	banned_species = list(SPECIES_ALRAUNE, SPECIES_SHADEKIN_CREW, SPECIES_TESHARI, SPECIES_TAJARAN, SPECIES_DIONA, SPECIES_UNATHI) //Either not applicable or buffs ruin species flavour/balance
//	custom_only = FALSE //Keeping these in comments in case we decide to open them up in future, so the species are already organised.

	// Traitgenes Replaces /datum/trait/superpower_increaserun, made into a genetrait
	is_genetrait = TRUE
	hidden = FALSE
	category = TRAIT_TYPE_POSITIVE

	activation_message="Your leg muscles pulsate."
	primitive_expression_messages=list("dances around.")
	excludes = list(/datum/trait/unusual_running) // you best not be naruto running in this house

/datum/trait/unusual_running
	name = "Unusual Gait"
	desc = "Your method of running is unorthodox, you move faster when not holding things in your hands."
	cost = 2
	var_changes = list("unusual_running" = 1)
	category = TRAIT_TYPE_POSITIVE

	custom_only = FALSE //I think this is probably fine since it's half RP trait and half mechanical trait. also you can't have speed and use your hands so this is kinda niche outside of travel time reduction.
	banned_species = list(SPECIES_ALRAUNE, SPECIES_SHADEKIN_CREW, SPECIES_TESHARI, SPECIES_TAJARAN, SPECIES_DIONA, SPECIES_UNATHI, SPECIES_VASILISSAN, SPECIES_XENOCHIMERA, SPECIES_VOX) //i assume if a dev made your base slowdown different then you shouldn't have this.
	excludes = list(/datum/trait/speed_fast) // olympic sprinters don't naruto run
