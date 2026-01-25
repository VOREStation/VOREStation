/datum/trait/emp_resist
	name = "EMP Resistance"
	desc = "You are resistant to EMPs"
	cost = 3

	can_take = SYNTHETICS
	custom_only = FALSE
	var_changes = list("emp_dmg_mod" = 0.7, "emp_stun_mod" = 0.7)
	excludes = list(/datum/trait/negative/faultwires, /datum/trait/negative/poorconstruction, /datum/trait/emp_resist_major)
	category = TRAIT_TYPE_POSITIVE

/datum/trait/emp_resist/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	..()
	H.add_modifier(/datum/modifier/trait/empresist)

/datum/trait/emp_resist_major
	name = "Major EMP Resistance"
	desc = "You are very resistant to EMPs"
	cost = 5

	can_take = SYNTHETICS
	custom_only = FALSE
	var_changes = list("emp_dmg_mod" = 0.5, "emp_stun_mod" = 0.5)
	excludes = list(/datum/trait/negative/faultwires, /datum/trait/negative/poorconstruction, /datum/trait/emp_resist)
	category = TRAIT_TYPE_POSITIVE

/datum/trait/emp_resist_major/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	..()
	H.add_modifier(/datum/modifier/trait/empresistb)
