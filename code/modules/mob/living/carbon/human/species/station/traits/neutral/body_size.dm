/datum/trait/taller
	name = "Tall"
	desc = "Your body is taller than average."
	sort = TRAIT_SORT_BODYTYPE
	cost = 0
	custom_only = FALSE
	category = TRAIT_TYPE_NEUTRAL
	var_changes = list("icon_scale_y" = 1.09)
	excludes = list(/datum/trait/tall, /datum/trait/tallest, /datum/trait/short, /datum/trait/shorter, /datum/trait/shortest)

/datum/trait/taller/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	..()
	H.update_transform()

/datum/trait/tall
	name = "Tall, Minor"
	desc = "Your body is a bit taller than average."
	sort = TRAIT_SORT_BODYTYPE
	cost = 0
	custom_only = FALSE
	category = TRAIT_TYPE_NEUTRAL
	var_changes = list("icon_scale_y" = 1.05)
	excludes = list(/datum/trait/taller, /datum/trait/tallest, /datum/trait/short, /datum/trait/shorter, /datum/trait/shortest)

/datum/trait/tall/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	..()
	H.update_transform()

/datum/trait/tallest
	name = "Tall, Major"
	desc = "Your body is way taller than average."
	sort = TRAIT_SORT_BODYTYPE
	cost = 0
	custom_only = FALSE
	category = TRAIT_TYPE_NEUTRAL
	var_changes = list("icon_scale_y" = 1.15)
	excludes = list(/datum/trait/tall, /datum/trait/taller, /datum/trait/short, /datum/trait/shorter, /datum/trait/shortest)

/datum/trait/tallest/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	..()
	H.update_transform()

/datum/trait/short
	name = "Short, Minor"
	desc = "Your body is a bit shorter than average."
	sort = TRAIT_SORT_BODYTYPE
	cost = 0
	custom_only = FALSE
	category = TRAIT_TYPE_NEUTRAL
	var_changes = list("icon_scale_y" = 0.95)
	excludes = list(/datum/trait/taller, /datum/trait/tall, /datum/trait/tallest, /datum/trait/shorter, /datum/trait/shortest)

/datum/trait/short/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	..()
	H.update_transform()

/datum/trait/shorter
	name = "Short"
	desc = "Your body is shorter than average."
	sort = TRAIT_SORT_BODYTYPE
	cost = 0
	custom_only = FALSE
	category = TRAIT_TYPE_NEUTRAL
	var_changes = list("icon_scale_y" = 0.915)
	excludes = list(/datum/trait/taller, /datum/trait/tall, /datum/trait/tallest, /datum/trait/short, /datum/trait/shortest)

/datum/trait/shorter/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	..()
	H.update_transform()

/datum/trait/shortest
	name = "Short, Major"
	desc = "Your body is way shorter than average."
	sort = TRAIT_SORT_BODYTYPE
	cost = 0
	custom_only = FALSE
	category = TRAIT_TYPE_NEUTRAL
	var_changes = list("icon_scale_y" = 0.85)
	excludes = list(/datum/trait/taller, /datum/trait/tall, /datum/trait/tallest, /datum/trait/short, /datum/trait/shorter)

/datum/trait/shortest/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	..()
	H.update_transform()

/datum/trait/obese
	name = "Bulky, Major"
	desc = "Your body is much wider than average."
	sort = TRAIT_SORT_BODYTYPE
	cost = 0
	custom_only = FALSE
	category = TRAIT_TYPE_NEUTRAL
	var_changes = list("icon_scale_x" = 1.095)
	excludes = list(/datum/trait/fat, /datum/trait/thin, /datum/trait/thinner)

/datum/trait/obese/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	..()
	H.update_transform()

/datum/trait/fat
	name = "Bulky"
	desc = "Your body is wider than average."
	sort = TRAIT_SORT_BODYTYPE
	cost = 0
	custom_only = FALSE
	category = TRAIT_TYPE_NEUTRAL
	var_changes = list("icon_scale_x" = 1.054)
	excludes = list(/datum/trait/obese, /datum/trait/thin, /datum/trait/thinner)

/datum/trait/fat/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	..()
	H.update_transform()

/datum/trait/thin
	name = "Thin"
	desc = "Your body is thinner than average."
	sort = TRAIT_SORT_BODYTYPE
	cost = 0
	custom_only = FALSE
	category = TRAIT_TYPE_NEUTRAL
	var_changes = list("icon_scale_x" = 0.945)
	excludes = list(/datum/trait/fat, /datum/trait/obese, /datum/trait/thinner)

/datum/trait/thin/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	..()
	H.update_transform()

/datum/trait/thinner
	name = "Thin, Major"
	desc = "Your body is much thinner than average."
	sort = TRAIT_SORT_BODYTYPE
	cost = 0
	custom_only = FALSE
	category = TRAIT_TYPE_NEUTRAL
	var_changes = list("icon_scale_x" = 0.905)
	excludes = list(/datum/trait/fat, /datum/trait/obese, /datum/trait/thin)

/datum/trait/thinner/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	..()
	H.update_transform()
