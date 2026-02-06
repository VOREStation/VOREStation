/*EMP traits. Noting this down because I was like 'what is the difference between emp_dmg_mod and the modifier?'
 * emp_dmg_mod: If the species has emp_sensitivity bitflag of EMP_BRUTE_DMG, EMP_BURN_DMG, EMP_TOX_DMG, or EMP_OXY_DMG, damage is multiplied by that.
 * As of the time of writing this, the ONLY species with those bitflags are proteans...Meaning this has been a free trait FOREVER for synths.
 * The modifier, however, makes everything inside of you (organs, limbs, items) get EMP'd as if it was 1 severity more severe (or 2 if using the major trait)
*/
/datum/trait/faultwires
	name = "Faulty Wires"
	desc = "Due to poor construction, you have an unfortante weakness to EMPs."
	cost = -3
	custom_only = FALSE
	can_take = SYNTHETICS
	var_changes = list("emp_dmg_mod" = 1.3, "emp_stun_mod" = 1.3, "emp_sensitivity" = (EMP_BLIND | EMP_DEAFEN | EMP_BRUTE_DMG | EMP_BURN_DMG | EMP_CONFUSE))
	excludes = list(/datum/trait/poorconstruction, /datum/trait/emp_resist, /datum/trait/emp_resist_major)
	category = TRAIT_TYPE_NEGATIVE


/datum/trait/faultwires/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	..()
	H.add_modifier(/datum/modifier/trait/empweakness)

/datum/trait/poorconstruction
	name = "Poor Construction"
	desc = "Due to poor construction, you have an hefty weakness to EMPs."
	cost = -5
	custom_only = FALSE
	can_take = SYNTHETICS
	var_changes = list("emp_dmg_mod" = 1.6, "emp_stun_mod" = 1.6, "emp_sensitivity" = (EMP_BLIND | EMP_DEAFEN | EMP_BRUTE_DMG | EMP_BURN_DMG | EMP_CONFUSE | EMP_WEAKEN))
	excludes = list(/datum/trait/faultwires, /datum/trait/emp_resist, /datum/trait/emp_resist_major)
	category = TRAIT_TYPE_NEGATIVE


/datum/trait/poorconstruction/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	..()
	H.add_modifier(/datum/modifier/trait/majorempweakness)
