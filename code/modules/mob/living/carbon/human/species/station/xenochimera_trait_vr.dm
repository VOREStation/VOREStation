/*
**	For now, these are just neutral traits for Xenochimera only to take.
**	Traits defined as custom_only = FALSE in neutral.dm will be available for Xenochimera to take as well.
**	As such, be careful not to duplicate the traits, and only add dupes where necessary.
**	IE: Heat/Cold Adapt and autohisses are added to Xenochimera because they reasonably could have evolved it, along with custom species.
**	However, if custom_only = FALSE is set, then any species including things like humans can take it. A little silly.
**	Therefore, use this file only for Xenochimera traits that you want to keep custom + Xenochim only.
*/
/datum/trait/positive/weaver/xenochimera
	sort = TRAIT_SORT_SPECIES
	allowed_species = list(SPECIES_XENOCHIMERA)
	name = "Xenochimera: Weaver"
	desc = "You've evolved your body to produce silk that you can fashion into articles of clothing and other objects."
	cost = 0
	category = 0
	custom_only = FALSE

/datum/trait/positive/hardfeet/xenochimera
	sort = TRAIT_SORT_SPECIES
	allowed_species = list(SPECIES_XENOCHIMERA)
	name = "Xenochimera: Hard Feet"
	desc = "Your body has adapted to make your feet immune to glass shards, whether by developing hooves, chitin, or just horrible callous."
	cost = 0
	category = 0
	custom_only = FALSE

// Why put this on Xenochimera of all species? I have no idea, but someone may be enough of a lunatic to take it.
/datum/trait/negative/neural_hypersensitivity/xenochimera
	sort = TRAIT_SORT_SPECIES
	allowed_species = list(SPECIES_XENOCHIMERA)
	name = "Xenochimera: Neural Hypersensitivity"
	desc = "Despite your evolutionary efforts, you are unusually sensitive to pain. \
	Given your species' typical reactions to pain, this can only end well for you!"
	cost = 0
	category = 0
	custom_only = FALSE

/datum/trait/positive/melee_attack_fangs/xenochimera
	sort = TRAIT_SORT_SPECIES
	allowed_species = list(SPECIES_XENOCHIMERA)
	name = "Xenochimera: Sharp Melee & Numbing Fangs"
	desc = "Your hunting instincts manifest in earnest! You have grown numbing fangs alongside your naturally grown hunting weapons."
	cost = 0
	category = 0
	custom_only = FALSE

/datum/trait/positive/snowwalker/xenochimera
	sort = TRAIT_SORT_SPECIES
	allowed_species = list(SPECIES_XENOCHIMERA)
	name = "Xenochimera: Snow Walker"
	desc = "You've adapted to traversing snowy terrain. Snow does not slow you down!"
	cost = 0
	category = 0
	custom_only = FALSE

/datum/trait/positive/water_breather/xenochimera
	sort = TRAIT_SORT_SPECIES
	allowed_species = list(SPECIES_XENOCHIMERA)
	name = "Xenochimera: Water Breather"
	desc = "You can breathe under water."
	cost = 0
	category = 0
	custom_only = FALSE
	
/* // Commented out in lieu of finding a better solution.
/datum/trait/neutral/coldadapt/xenochimera
	sort = TRAIT_SORT_SPECIES
	allowed_species = list(SPECIES_XENOCHIMERA)
	name = "Xenochimera: Temp. Adapted, Cold"
	desc = "You have adapted to withstand much colder temperatures than other species, and can even be comfortable in extremely cold environments. You are also more vulnerable to hot environments, and have a lower body temperature as a consequence of these adaptations, thanks to your evolutionary efforts."
	cost = 0
	category = 0
	can_take = ORGANICS // (Not sure if this is needed for Xenochimera-specific sub-version.)
	custom_only = FALSE
	excludes = list(/datum/trait/neutral/hotadapt, /datum/trait/neutral/hotadapt/xenochimera)

/datum/trait/neutral/hotadapt/xenochimera
	sort = TRAIT_SORT_SPECIES
	allowed_species = list(SPECIES_XENOCHIMERA)
	name = "Xenochimera: Temp. Adapted, Heat"
	desc = "You have adapted to withstand much hotter temperatures than other species, and can even be comfortable in extremely hot environments. You are also more vulnerable to cold environments, and have a higher body temperature as a consequence of these adaptations, thanks to your evolutionary efforts."
	cost = 0
	category = 0
	can_take = ORGANICS // negates the need for suit coolers entirely for synths, so no. (Not sure if this is needed for Xenochimera-specific sub-version.)
	custom_only = FALSE
	excludes = list(/datum/trait/neutral/coldadapt, /datum/trait/neutral/coldadapt/xenochimera)
*/

/datum/trait/neutral/autohiss_unathi/xenochimera
	sort = TRAIT_SORT_SPECIES
	allowed_species = list(SPECIES_XENOCHIMERA)
	name = "Xenochimera: Autohiss (Unathi)"
	desc = "You roll your S's and x's"
	cost = 0
	custom_only = FALSE
	var_changes = list(
	autohiss_basic_map = list(
			"s" = list("ss", "sss", "ssss")
		),
	autohiss_extra_map = list(
			"x" = list("ks", "kss", "ksss")
		),
	autohiss_exempt = list("Sinta'unathi"))
	excludes = list(/datum/trait/neutral/autohiss_tajaran)

/datum/trait/neutral/autohiss_tajaran/xenochimera
	sort = TRAIT_SORT_SPECIES
	allowed_species = list(SPECIES_XENOCHIMERA)
	name = "Xenochimera: Autohiss (Tajaran)"
	desc = "You roll your R's."
	cost = 0
	custom_only = FALSE
	var_changes = list(
	autohiss_basic_map = list(
			"r" = list("rr", "rrr", "rrrr")
		),
	autohiss_exempt = list("Siik"))
	excludes = list(/datum/trait/neutral/autohiss_unathi)