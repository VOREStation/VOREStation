#define ORGANICS	1
#define SYNTHETICS	2

/datum/trait/metabolism_up
	name = "Fast Metabolism"
	desc = "You process ingested and injected reagents faster, but get hungry faster (Teshari speed)."
	cost = 0
	var_changes = list("metabolic_rate" = 1.2, "hunger_factor" = 0.2, "metabolism" = 0.06) // +20% rate and 4x hunger (Teshari level)
	excludes = list(/datum/trait/metabolism_down, /datum/trait/metabolism_apex)

/datum/trait/metabolism_down
	name = "Slow Metabolism"
	desc = "You process ingested and injected reagents slower, but get hungry slower."
	cost = 0
	var_changes = list("metabolic_rate" = 0.8, "hunger_factor" = 0.04, "metabolism" = 0.0012) // -20% of default.
	excludes = list(/datum/trait/metabolism_up, /datum/trait/metabolism_apex)

/datum/trait/metabolism_apex
	name = "Apex Metabolism"
	desc = "Finally a proper excuse for your predatory actions. Essentially doubles the fast trait rates. Good for characters with big appetites."
	cost = 0
	var_changes = list("metabolic_rate" = 1.4, "hunger_factor" = 0.4, "metabolism" = 0.012) // +40% rate and 8x hunger (Double Teshari)
	excludes = list(/datum/trait/metabolism_up, /datum/trait/metabolism_down)

/datum/trait/coldadapt
	name = "Cold-Adapted"
	desc = "You are able to withstand much colder temperatures than other species, and can even be comfortable in extremely cold environments. You are also more vulnerable to hot environments, and have a lower body temperature as a consequence of these adaptations."
	cost = 0
	var_changes = list("cold_level_1" = 200,  "cold_level_2" = 150, "cold_level_3" = 90, "breath_cold_level_1" = 180, "breath_cold_level_2" = 100, "breath_cold_level_3" = 60, "cold_discomfort_level" = 210, "heat_level_1" = 305, "heat_level_2" = 360, "heat_level_3" = 700, "breath_heat_level_1" = 345, "breath_heat_level_2" = 380, "breath_heat_level_3" = 780, "heat_discomfort_level" = 295, "body_temperature" = 290)
	excludes = list(/datum/trait/hotadapt)

/datum/trait/hotadapt
	name = "Heat-Adapted"
	desc = "You are able to withstand much hotter temperatures than other species, and can even be comfortable in extremely hot environments. You are also more vulnerable to cold environments, and have a higher body temperature as a consequence of these adaptations."
	cost = 0
	var_changes = list("heat_level_1" = 420, "heat_level_2" = 460, "heat_level_3" = 1100, "breath_heat_level_1" = 440, "breath_heat_level_2" = 510, "breath_heat_level_3" = 1500, "heat_discomfort_level" = 390, "cold_level_1" = 280, "cold_level_2" = 220, "cold_level_3" = 140, "breath_cold_level_1" = 260, "breath_cold_level_2" = 240, "breath_cold_level_3" = 120, "cold_discomfort_level" = 280, "body_temperature" = 330)
	excludes = list(/datum/trait/coldadapt)

/datum/trait/autohiss_unathi
	name = "Autohiss (Unathi)"
	desc = "You roll your S's and x's"
	cost = 0
	var_changes = list(
	autohiss_basic_map = list(
			"s" = list("ss", "sss", "ssss")
		),
	autohiss_extra_map = list(
			"x" = list("ks", "kss", "ksss")
		),
	autohiss_exempt = list("Sinta'unathi"))

	excludes = list(/datum/trait/autohiss_tajaran)

/datum/trait/autohiss_tajaran
	name = "Autohiss (Tajaran)"
	desc = "You roll your R's."
	cost = 0
	var_changes = list(
	autohiss_basic_map = list(
			"r" = list("rr", "rrr", "rrrr")
		),
	autohiss_exempt = list("Siik"))
	excludes = list(/datum/trait/autohiss_unathi)

/datum/trait/bloodsucker
	name = "Bloodsucker"
	desc = "Makes you unable to gain nutrition from anything but blood. To compenstate, you get fangs that can be used to drain blood from prey."
	cost = 0
	custom_only = FALSE
	var_changes = list("organic_food_coeff" = 0) //The verb is given in human.dm

/datum/trait/bloodsucker/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	..(S,H)
	H.verbs |= /mob/living/carbon/human/proc/bloodsuck

/datum/trait/succubus_drain
	name = "Succubus Drain"
	desc = "Makes you able to gain nutrition from draining prey in your grasp."
	cost = 0
	custom_only = FALSE

/datum/trait/succubus_drain/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	..(S,H)
	H.verbs |= /mob/living/carbon/human/proc/succubus_drain
	H.verbs |= /mob/living/carbon/human/proc/succubus_drain_finalize
	H.verbs |= /mob/living/carbon/human/proc/succubus_drain_lethal

/datum/trait/feeder
	name = "Feeder"
	desc = "Allows you to feed your prey using your own body."
	cost = 0
	custom_only = FALSE

/datum/trait/feeder/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	..(S,H)
	H.verbs |= /mob/living/carbon/human/proc/slime_feed

/datum/trait/hard_vore
	name = "Brutal Predation"
	desc = "Allows you to tear off limbs & tear out internal organs."
	cost = 0
	custom_only = FALSE

/datum/trait/hard_vore/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	..(S,H)
	H.verbs |= /mob/living/proc/shred_limb

/datum/trait/trashcan
	name = "Trash Can"
	desc = "Allows you to dispose of some garbage on the go instead of having to look for a bin or littering like an animal."
	cost = 0
	custom_only = FALSE
	var_changes = list("trashcan" = 1)

/datum/trait/trashcan/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	..(S,H)
	H.verbs |= /mob/living/proc/eat_trash

/datum/trait/gem_eater
	name = "Expensive Taste"
	desc = "You only gain nutrition from raw ore and refined minerals. There's nothing that sates the appetite better than precious gems, exotic or rare minerals and you have damn fine taste. Anything else is beneath you."
	cost = 0
	custom_only = FALSE
	var_changes = list("organic_food_coeff" = 0, "eat_minerals" = 1)

/datum/trait/gem_eater/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	..(S,H)
	H.verbs |= /mob/living/proc/eat_minerals
	
/datum/trait/synth_chemfurnace
	name = "Biofuel Processor"
	desc = "You are able to gain energy through consuming and processing normal food. Energy-dense foods such as protein bars and survival food will yield the best results."
	cost = 0
	custom_only = FALSE
	can_take = SYNTHETICS
	var_changes = list("organic_food_coeff" = 0, "synthetic_food_coeff" = 0.25)

/datum/trait/glowing_eyes
	name = "Glowing Eyes"
	desc = "Your eyes show up above darkness. SPOOKY! And kinda edgey too."
	cost = 0
	custom_only = FALSE
	var_changes = list("has_glowing_eyes" = 1)

/datum/trait/glowing_body
	name = "Glowing Body"
	desc = "Your body glows about as much as a PDA light! Settable color and toggle in Abilities tab ingame."
	cost = 0
	custom_only = FALSE

/datum/trait/glowing_body/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	..(S,H)
	H.verbs |= /mob/living/proc/glow_toggle
	H.verbs |= /mob/living/proc/glow_color


//Allergen traits! Not available to any species with a base allergens var.
/datum/trait/allergy
	name = "Allergy: Gluten"
	desc = "You're highly allergic to gluten proteins, which are found in most common grains."
	cost = 0
	custom_only = FALSE
	var/allergen = GRAINS

/datum/trait/allergy/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	S.allergens |= allergen
	..(S,H)

/datum/trait/allergy/meat
	name = "Allergy: Meat"
	desc = "You're highly allergic to just about any form of meat. You're probably better off just sticking to vegetables."
	cost = 0
	custom_only = FALSE
	allergen = MEAT

/datum/trait/allergy/fish
	name = "Allergy: Fish"
	desc = "You're highly allergic to fish. It's probably best to avoid seafood in general..."
	cost = 0
	custom_only = FALSE
	allergen = FISH

/datum/trait/allergy/fruit
	name = "Allergy: Fruit"
	desc = "You're highly allergic to fruit. Vegetables are fine, but you should probably read up on how to tell the difference."
	cost = 0
	custom_only = FALSE
	allergen = FRUIT

/datum/trait/allergy/vegetable
	name = "Allergy: Vegetable"
	desc = "You're highly allergic to vegetables. Fruit are fine, but you should probably read up on how to tell the difference."
	cost = 0
	custom_only = FALSE
	allergen = VEGETABLE

/datum/trait/allergy/nuts
	name = "Allergy: Nuts"
	desc = "You're highly allergic to hard-shell seeds, such as peanuts."
	cost = 0
	custom_only = FALSE
	allergen = SEEDS

/datum/trait/allergy/soy
	name = "Allergy: Soy"
	desc = "You're highly allergic to soybeans, and some other kinds of bean."
	cost = 0
	custom_only = FALSE
	allergen = BEANS

/datum/trait/allergy/dairy
	name = "Allergy: Lactose"
	desc = "You're highly allergic to lactose, and consequently, just about all forms of dairy."
	cost = 0
	custom_only = FALSE
	allergen = DAIRY

/datum/trait/allergy/fungi
	name = "Allergy: Fungi"
	desc = "You're highly allergic to Fungi such as mushrooms."
	cost = 0
	custom_only = FALSE
	allergen = FUNGI

/datum/trait/allergy/coffee
	name = "Allergy: Coffee"
	desc = "You're highly allergic to coffee in specific."
	cost = 0
	custom_only = FALSE
	allergen = COFFEE

// Spicy Food Traits, from negative to positive.
/datum/trait/spice_intolerance_extreme
	name = "Extreme Spice Intolerance"
	desc = "Spicy (and chilly) peppers are three times as strong. (This does not affect pepperspray.)"
	cost = 0
	custom_only = FALSE
	var_changes = list("spice_mod" = 3) // 300% as effective if spice_mod is set to 1. If it's not 1 in species.dm, update this!

/datum/trait/spice_intolerance_basic
	name = "Heavy Spice Intolerance"
	desc = "Spicy (and chilly) peppers are twice as strong. (This does not affect pepperspray.)"
	cost = 0
	custom_only = FALSE
	var_changes = list("spice_mod" = 2) // 200% as effective if spice_mod is set to 1. If it's not 1 in species.dm, update this!

/datum/trait/spice_intolerance_slight
	name = "Slight Spice Intolerance"
	desc = "You have a slight struggle with spicy foods. Spicy (and chilly) peppers are one and a half times stronger. (This does not affect pepperspray.)"
	cost = 0
	custom_only = FALSE
	var_changes = list("spice_mod" = 1.5) // 150% as effective if spice_mod is set to 1. If it's not 1 in species.dm, update this!

/datum/trait/spice_tolerance_basic
	name = "Spice Tolerance"
	desc = "Spicy (and chilly) peppers are only three-quarters as strong. (This does not affect pepperspray.)"
	cost = 0
	custom_only = FALSE
	var_changes = list("spice_mod" = 0.75) // 75% as effective if spice_mod is set to 1. If it's not 1 in species.dm, update this!

/datum/trait/spice_tolerance_advanced
	name = "Strong Spice Tolerance"
	desc = "Spicy (and chilly) peppers are only half as strong. (This does not affect pepperspray.)"
	cost = 0
	custom_only = FALSE
	var_changes = list("spice_mod" = 0.5) // 50% as effective if spice_mod is set to 1. If it's not 1 in species.dm, update this!

/datum/trait/spice_immunity
	name = "Extreme Spice Tolerance"
	desc = "Spicy (and chilly) peppers are basically ineffective! (This does not affect pepperspray.)"
	cost = 0
	custom_only = FALSE
	var_changes = list("spice_mod" = 0.25) // 25% as effective if spice_mod is set to 1. If it's not 1 in species.dm, update this!

// Alcohol Traits Start Here, from negative to positive.
/datum/trait/alcohol_intolerance_advanced
	name = "Liver of Air"
	desc = "The only way you can hold a drink is if it's in your own two hands, and even then you'd best not inhale too deeply near it. Drinks are three times as strong."
	cost = 0
	custom_only = FALSE
	var_changes = list("alcohol_mod" = 3) // 300% as effective if alcohol_mod is set to 1. If it's not 1 in species.dm, update this!

/datum/trait/alcohol_intolerance_basic
	name = "Liver of Lilies"
	desc = "You have a hard time with alcohol. Maybe you just never took to it, or maybe it doesn't agree with you... either way, drinks are twice as strong."
	cost = 0
	custom_only = FALSE
	var_changes = list("alcohol_mod" = 2) // 200% as effective if alcohol_mod is set to 1. If it's not 1 in species.dm, update this!

/datum/trait/alcohol_intolerance_slight
	name = "Liver of Tulips"
	desc = "You have a slight struggle with alcohol. Drinks are one and a half times stronger."
	cost = 0
	custom_only = FALSE
	var_changes = list("alcohol_mod" = 1.5) // 150% as effective if alcohol_mod is set to 1. If it's not 1 in species.dm, update this!

/datum/trait/alcohol_tolerance_basic
	name = "Liver of Iron"
	desc = "You can hold drinks much better than those lily-livered land-lubbers! Arr! Drinks are only three-quarters as strong."
	cost = 0
	custom_only = FALSE
	var_changes = list("alcohol_mod" = 0.75) // 75% as effective if alcohol_mod is set to 1. If it's not 1 in species.dm, update this!

/datum/trait/alcohol_tolerance_advanced
	name = "Liver of Steel"
	desc = "Drinks tremble before your might! You can hold your alcohol twice as well as those blue-bellied barnacle boilers! Drinks are only half as strong."
	cost = 0
	custom_only = FALSE
	var_changes = list("alcohol_mod" = 0.5) // 50% as effective if alcohol_mod is set to 1. If it's not 1 in species.dm, update this!

/datum/trait/alcohol_immunity
	name = "Liver of Durasteel"
	desc = "You've drunk so much that most booze doesn't even faze you. It takes something like a Pan-Galactic or a pint of Deathbell for you to even get slightly buzzed."
	cost = 0
	custom_only = FALSE
	var_changes = list("alcohol_mod" = 0.25) // 25% as effective if alcohol_mod is set to 1. If it's not 1 in species.dm, update this!
// Alcohol Traits End Here.

// Body shape traits
/datum/trait/taller
	name = "Tall"
	desc = "Your body is taller than average."
	cost = 0
	custom_only = FALSE
	var_changes = list("icon_scale_y" = 1.09)
	excludes = list(/datum/trait/tall, /datum/trait/short, /datum/trait/shorter)

/datum/trait/taller/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	..(S,H)
	H.update_transform()

/datum/trait/tall
	name = "Slightly Tall"
	desc = "Your body is a bit taller than average."
	cost = 0
	custom_only = FALSE
	var_changes = list("icon_scale_y" = 1.05)
	excludes = list(/datum/trait/taller, /datum/trait/short, /datum/trait/shorter)

/datum/trait/tall/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	..(S,H)
	H.update_transform()

/datum/trait/short
	name = "Slightly Short"
	desc = "Your body is a bit shorter than average."
	cost = 0
	custom_only = FALSE
	var_changes = list("icon_scale_y" = 0.95)
	excludes = list(/datum/trait/taller, /datum/trait/tall, /datum/trait/shorter)

/datum/trait/short/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	..(S,H)
	H.update_transform()

/datum/trait/shorter
	name = "Short"
	desc = "Your body is shorter than average."
	cost = 0
	custom_only = FALSE
	var_changes = list("icon_scale_y" = 0.915)
	excludes = list(/datum/trait/taller, /datum/trait/tall, /datum/trait/short)

/datum/trait/shorter/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	..(S,H)
	H.update_transform()

/datum/trait/obese
	name = "Very Bulky"
	desc = "Your body is much wider than average."
	cost = 0
	custom_only = FALSE
	var_changes = list("icon_scale_x" = 1.095)
	excludes = list(/datum/trait/fat, /datum/trait/thin, /datum/trait/thinner)

/datum/trait/obese/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	..(S,H)
	H.update_transform()

/datum/trait/fat
	name = "Bulky"
	desc = "Your body is wider than average."
	cost = 0
	custom_only = FALSE
	var_changes = list("icon_scale_x" = 1.054)
	excludes = list(/datum/trait/obese, /datum/trait/thin, /datum/trait/thinner)

/datum/trait/fat/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	..(S,H)
	H.update_transform()

/datum/trait/thin
	name = "Thin"
	desc = "Your body is thinner than average."
	cost = 0
	custom_only = FALSE
	var_changes = list("icon_scale_x" = 0.945)
	excludes = list(/datum/trait/fat, /datum/trait/obese, /datum/trait/thinner)

/datum/trait/thin/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	..(S,H)
	H.update_transform()

/datum/trait/thinner
	name = "Very Thin"
	desc = "Your body is much thinner than average."
	cost = 0
	custom_only = FALSE
	var_changes = list("icon_scale_x" = 0.905)
	excludes = list(/datum/trait/fat, /datum/trait/obese, /datum/trait/thin)

/datum/trait/thinner/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	..(S,H)
	H.update_transform()
