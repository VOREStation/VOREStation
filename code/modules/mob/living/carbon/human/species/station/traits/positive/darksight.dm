/datum/trait/darksight
	name = "Darksight"
	desc = "Allows you to see significantly further in the dark and be 10% more susceptible to flashes."
	cost = 1
	var_changes = list("darksight" = 5, "flash_mod" = 1.1)
	custom_only = FALSE
	banned_species = list(SPECIES_TAJARAN, SPECIES_SHADEKIN_CREW, SPECIES_SHADEKIN, SPECIES_XENOHYBRID, SPECIES_VULPKANIN, SPECIES_XENO, SPECIES_XENOCHIMERA, SPECIES_VASILISSAN, SPECIES_WEREBEAST) //These species already have strong darksight by default.
	excludes = list(/datum/trait/darksight_plus)
	category = TRAIT_TYPE_POSITIVE

/datum/trait/darksight_plus
	name = "Darksight, Major"
	desc = "Allows you to see in the dark for the whole screen and be 20% more susceptible to flashes."
	cost = 2
	var_changes = list("darksight" = 8, "flash_mod" = 1.2)
	custom_only = FALSE
	banned_species = list(SPECIES_TAJARAN, SPECIES_SHADEKIN_CREW, SPECIES_SHADEKIN, SPECIES_XENOHYBRID, SPECIES_VULPKANIN, SPECIES_XENO, SPECIES_XENOCHIMERA, SPECIES_VASILISSAN, SPECIES_WEREBEAST) //These species already have strong darksight by default.
	excludes = list(/datum/trait/darksight)
	category = TRAIT_TYPE_POSITIVE
