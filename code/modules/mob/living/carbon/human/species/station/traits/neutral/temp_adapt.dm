/datum/trait/coldadapt
	name = "Temp. Adapted, Cold"
	desc = "You are able to withstand much colder temperatures than other species. You are also more vulnerable to hot environments."
	cost = 0
	var_changes = list("cold_level_1" = 220,  "cold_level_2" = 190, "cold_level_3" = 160, "breath_cold_level_1" = 200, "breath_cold_level_2" = 170, "breath_cold_level_3" = 140, "cold_discomfort_level" = 253, "heat_level_1" = 330, "heat_level_2" = 380, "heat_level_3" = 700, "breath_heat_level_1" = 360, "breath_heat_level_2" = 400, "breath_heat_level_3" = 850, "heat_discomfort_level" = 295)
	can_take = ORGANICS // just in case following hot adapt
	excludes = list(/datum/trait/hotadapt, /datum/trait/notadapt)

	// Traitgenes Replaces /datum/trait/superpower_cold_resist, made into a genetrait
	is_genetrait = TRUE
	hidden = FALSE
	category = TRAIT_TYPE_NEUTRAL

	activation_message="Your body is filled with warmth."
	primitive_expression_messages=list("pants, sweat dripping down their head.")

/datum/trait/hotadapt
	name = "Temp. Adapted, Heat"
	desc = "You are able to withstand much hotter temperatures than other species. You are also more vulnerable to cold environments."
	cost = 0
	var_changes = list("heat_level_1" = 400, "heat_level_2" = 440, "heat_level_3" = 1100, "breath_heat_level_1" = 420, "breath_heat_level_2" = 500, "breath_heat_level_3" = 1200, "heat_discomfort_level" = 360, "cold_level_1" = 280, "cold_level_2" = 220, "cold_level_3" = 140, "breath_cold_level_1" = 260, "breath_cold_level_2" = 240, "breath_cold_level_3" = 120, "cold_discomfort_level" = 280)
	can_take = ORGANICS // negates the need for suit coolers entirely for synths, so no
	excludes = list(/datum/trait/coldadapt, /datum/trait/notadapt)

	// Traitgenes Made into a genetrait
	is_genetrait = TRUE
	hidden = FALSE
	category = TRAIT_TYPE_NEUTRAL

	activation_message="Your body feels chilly."
	primitive_expression_messages=list("shivers.")

/datum/trait/notadapt
	name = "Temp. Unadapted" //British
	desc = "Your particular biology causes you to have trouble handling both hot and cold temperatures. You should take precautions when going out!"
	cost = 0
	var_changes = list("heat_level_1" = 330, "heat_level_2" = 380, "heat_level_3" = 700, "breath_heat_level_1" = 360, "breath_heat_level_2" = 400, "breath_heat_level_3" = 850, "heat_discomfort_level" = 295, "cold_level_1" = 280, "cold_level_2" = 220, "cold_level_3" = 140, "breath_cold_level_1" = 260, "breath_cold_level_2" = 240, "breath_cold_level_3" = 120, "cold_discomfort_level" = 280)
	can_take = ORGANICS // just in case following hot adapt
	custom_only = FALSE
	category = TRAIT_TYPE_NEUTRAL
	excludes = list(/datum/trait/coldadapt, /datum/trait/hotadapt)
