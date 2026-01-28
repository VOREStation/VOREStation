/datum/trait/sensitive_biochem
	name = "Sensitive Biochemistry, Minor"
	desc = "Your biochemistry is a little delicate, rendering you more susceptible to the negative effects of some chemicals. You'll probably want to list this in your medical records, and perhaps in your exploitable info as well. Chemical toxin damage and negative drug effects are 25% stronger on you. Additionally, knockout drugs work 25% faster on you."
	cost = -1
	var_changes = list("chem_strength_tox" = 1.25)

	//Traitgenes
	can_take = ORGANICS
	is_genetrait = FALSE
	hidden = FALSE
	category = TRAIT_TYPE_NEGATIVE

/datum/trait/sensitive_biochem/moderate
	name = "Sensitive Biochemistry, Moderate"
	desc = "Your biochemistry is a quite delicate, rendering you more susceptible to the negative effects of some chemicals. You'll probably want to list this in your medical records, and perhaps in your exploitable info as well. Chemical toxin damage and negative drug effects are 50% stronger on you. Additionally, knockout drugs work 50% faster on you."
	cost = -2
	var_changes = list("chem_strength_tox" = 1.5)

	//Traitgenes
	can_take = ORGANICS
	is_genetrait = FALSE
	category = TRAIT_TYPE_NEGATIVE

/datum/trait/sensitive_biochem/major
	name = "Sensitive Biochemistry, Major"
	desc = "Your biochemistry is a much more delicate, rendering you more susceptible to the negative effects of some chemicals. You'll probably want to list this in your medical records, and perhaps in your exploitable info as well. Chemical toxin damage and negative drug effects are 100% stronger on you. Additionally, knockout drugs work 100% faster on you."
	cost = -3
	var_changes = list("chem_strength_tox" = 2)

	//Traitgenes
	can_take = ORGANICS
	is_genetrait = TRUE
	category = TRAIT_TYPE_NEGATIVE
