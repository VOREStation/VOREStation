/datum/trait/aquatic
	name = "Aquatic"
	desc = "You can breathe under water and can traverse water more efficiently. Additionally, you can eat others in the water."
	cost = 1
	custom_only = FALSE
	var_changes = list("water_breather" = 1, "water_movement" = -4) //Negate shallow water. Half the speed in deep water.
	allowed_species = list(SPECIES_HANNER, SPECIES_CUSTOM, SPECIES_REPLICANT_CREW) //So it only shows up for custom species, hanner, and Gamma replicants
	custom_only = FALSE
	excludes = list(/datum/trait/good_swimmer, /datum/trait/negative/bad_swimmer, /datum/trait/aquatic/plus)
	category = TRAIT_TYPE_POSITIVE

/datum/trait/aquatic/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	..()
	add_verb(H, /mob/living/carbon/human/proc/water_stealth)
	add_verb(H, /mob/living/carbon/human/proc/underwater_devour)

/datum/trait/aquatic/plus
	name = "Aquatic 2"
	desc = "You can breathe under water and can traverse water more efficiently than most aquatic humanoids. Additionally, you can eat others in the water."
	cost = 2
	custom_only = FALSE
	var_changes = list("water_breather" = 1, "water_movement" = -4, "swim_mult" = 0.5) //Negate shallow water. Half the speed in deep water.
	allowed_species = list(SPECIES_HANNER, SPECIES_CUSTOM, SPECIES_REPLICANT_CREW) //So it only shows up for custom species, hanner, and Gamma replicants
	custom_only = FALSE
	excludes = list(/datum/trait/good_swimmer, /datum/trait/negative/bad_swimmer, /datum/trait/aquatic)
	category = TRAIT_TYPE_POSITIVE

/datum/trait/good_swimmer
	name = "Pro Swimmer"
	desc = "You were top of your group in swimming class! This is of questionable usefulness on most planets, but hey, maybe you'll get to visit a nice beach world someday?"
	tutorial = "You move faster in water, and can move up and down z-levels faster than other swimmers!"
	cost = 1
	custom_only = FALSE
	var_changes = list("water_movement" = -2, "swim_mult" = 0.5)
	varchange_type = TRAIT_VARCHANGE_LESS_BETTER
	excludes = list(/datum/trait/negative/bad_swimmer)
	banned_species = list(SPECIES_AKULA)	// They already swim better than this
	category = TRAIT_TYPE_POSITIVE
