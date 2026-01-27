/datum/trait/deep_breather
	name ="Deep Breather"
	desc = "You need more air for your lungs to properly work.."
	cost = -1

	custom_only = FALSE
	can_take = ORGANICS

	var_changes = list("minimum_breath_pressure" = 18)
	excludes = list(/datum/trait/light_breather)
	category = TRAIT_TYPE_NEGATIVE

/datum/trait/breathes
	cost = -2
	can_take = ORGANICS

	//Traitgenes
	is_genetrait = TRUE
	hidden = FALSE

	activation_message="You feel like breathing is more difficult..."
	primitive_expression_messages=list("gasps")
	category = TRAIT_TYPE_NEGATIVE

/datum/trait/breathes/phoron
	name = "Phoron Breather"
	desc = "You breathe phoron instead of oxygen (which is poisonous to you), much like a Vox."
	var_changes = list("breath_type" = GAS_PHORON, "poison_type" = GAS_O2, "ideal_air_type" = /datum/gas_mixture/belly_air/vox)
	category = TRAIT_TYPE_NEGATIVE

/datum/trait/breathes/nitrogen
	name = "Nitrogen Breather"
	desc = "You breathe nitrogen instead of oxygen (which is poisonous to you). Incidentally, phoron isn't poisonous to breathe to you."
	var_changes = list("breath_type" = GAS_N2, "poison_type" = GAS_O2, "ideal_air_type" = /datum/gas_mixture/belly_air/nitrogen_breather)
	category = TRAIT_TYPE_NEGATIVE

/datum/trait/breathes/methane
	name = "Methane Breather"
	desc = "You breathe methane instead of oxygen (which is poisonous to you)."
	var_changes = list("breath_type" = GAS_CH4, "poison_type" = GAS_O2, "ideal_air_type" = /datum/gas_mixture/belly_air/methane_breather)
	category = TRAIT_TYPE_NEGATIVE

/datum/trait/breathes/carbon_dioxide
	name = "Carbon Dioxide Breather"
	desc = "You breathe carbon dioxide instead of oxygen, much like a plant. Oxygen is not poisonous to you."
	var_changes = list("breath_type" = GAS_CO2, "exhale_type" = GAS_O2, "ideal_air_type" = /datum/gas_mixture/belly_air/carbon_dioxide_breather)
	category = TRAIT_TYPE_NEGATIVE
