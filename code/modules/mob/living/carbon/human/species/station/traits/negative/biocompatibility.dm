/datum/trait/reduced_biocompat_minor
	name = "Reduced Biocompatibility, Minor"
	desc = "For whatever reason, you're one of the unlucky few who don't get as much benefit from modern-day chemicals. Remember to note this down in your medical records! Chems are only 80% as effective on you!"
	cost = -1
	var_changes = list("chem_strength_heal" = 0.8)
	can_take = ORGANICS
	category = TRAIT_TYPE_NEGATIVE

/datum/trait/reduced_biocompat
	name = "Reduced Biocompatibility"
	desc = "For whatever reason, you're one of the unlucky few who don't get as much benefit from modern-day chemicals. Remember to note this down in your medical records! Chems are only 60% as effective on you!"
	cost = -2
	var_changes = list("chem_strength_heal" = 0.6)
	can_take = ORGANICS
	category = TRAIT_TYPE_NEGATIVE

/datum/trait/reduced_biocompat_extreme
	name = "Reduced Biocompatibility, Major"
	desc = "For whatever reason, you're one of the unlucky few who don't get as much benefit from modern-day chemicals. Remember to note this down in your medical records! Chems are only 30% as effective on you!"
	cost = -4
	var_changes = list("chem_strength_heal" = 0.3)
	can_take = ORGANICS

	//Traitgenes
	is_genetrait = TRUE
	hidden = FALSE

	activation_message="You feel no different"
	primitive_expression_messages=list("blinks")
	category = TRAIT_TYPE_NEGATIVE
