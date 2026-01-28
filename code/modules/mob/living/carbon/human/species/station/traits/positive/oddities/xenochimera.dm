
/datum/trait/weaver/xenochimera
	sort = TRAIT_SORT_SPECIES
	allowed_species = list(SPECIES_XENOCHIMERA)
	name = "Xenochimera: Weaver"
	desc = "You've evolved your body to produce silk that you can fashion into articles of clothing and other objects."
	cost = 0
	category = 0
	custom_only = FALSE

/datum/trait/hardfeet/xenochimera
	sort = TRAIT_SORT_SPECIES
	allowed_species = list(SPECIES_XENOCHIMERA)
	name = "Xenochimera: Hard Feet"
	desc = "Your body has adapted to make your feet immune to glass shards, whether by developing hooves, chitin, or just horrible callous."
	cost = 0
	category = 0
	custom_only = FALSE

/datum/trait/melee_attack_fangs/xenochimera
	sort = TRAIT_SORT_SPECIES
	allowed_species = list(SPECIES_XENOCHIMERA)
	name = "Xenochimera: Sharp Melee & Numbing Fangs"
	desc = "Your hunting instincts manifest in earnest! You have grown numbing fangs alongside your naturally grown hunting weapons."
	cost = 0
	category = 0
	custom_only = FALSE
	var_changes = list("unarmed_types" = list(/datum/unarmed_attack/stomp, /datum/unarmed_attack/kick, /datum/unarmed_attack/claws/chimera, /datum/unarmed_attack/bite/sharp, /datum/unarmed_attack/bite/sharp/numbing)) // Fixes the parent forgetting to add 'chimera-specific claws

/datum/trait/snowwalker/xenochimera
	sort = TRAIT_SORT_SPECIES
	allowed_species = list(SPECIES_XENOCHIMERA)
	name = "Xenochimera: Snow Walker"
	desc = "You've adapted to traversing snowy terrain. Snow does not slow you down!"
	cost = 0
	category = 0
	custom_only = FALSE

/datum/trait/aquatic/xenochimera
	sort = TRAIT_SORT_SPECIES
	allowed_species = list(SPECIES_XENOCHIMERA)
	name = "Xenochimera: Aquatic"
	desc = "You can breathe under water and can traverse water more efficiently. Additionally, you can eat others in the water."
	cost = 0
	category = 0
	excludes = list(/datum/trait/winged_flight/xenochimera)
	custom_only = FALSE

/datum/trait/winged_flight/xenochimera
	sort = TRAIT_SORT_SPECIES
	allowed_species = list(SPECIES_XENOCHIMERA)
	name = "Xenochhimera: Winged Flight"
	desc = "Allows you to fly by using your wings. Don't forget to bring them!"
	cost = 0
	excludes = list(/datum/trait/aquatic/xenochimera)
	custom_only = FALSE

/datum/trait/cocoon_tf/xenochimera
	sort = TRAIT_SORT_SPECIES
	allowed_species = list(SPECIES_XENOCHIMERA)
	custom_only = FALSE
	name = "Xenochimera: Cocoon Spinner"
	desc = "Allows you to build a cocoon around yourself, using it to transform your body if you desire."
	cost = 0
	category = 0
