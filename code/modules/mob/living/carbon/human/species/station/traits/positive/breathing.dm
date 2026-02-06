/datum/trait/light_breather
	name ="Light Breather"
	desc = "You need less air for your lungs to properly work.."
	cost = 1

	custom_only = FALSE
	can_take = ORGANICS
	var_changes = list("minimum_breath_pressure" = 12)
	excludes = list(/datum/trait/deep_breather)
	category = TRAIT_TYPE_POSITIVE

/datum/trait/nobreathe
	name = "Breathless"
	desc = "You or your species have adapted to no longer require lungs, and as such no longer need to breathe!"
	cost = 6
	can_take = ORGANICS
	category = TRAIT_TYPE_POSITIVE

	var_changes = list("breath_type" = "null", "poison_type" = "null", "exhale_type" = "null")
	excludes = list(/datum/trait/breathes/phoron,
					/datum/trait/breathes/nitrogen,
					/datum/trait/breathes/carbon_dioxide,
					/datum/trait/light_breather,
					/datum/trait/deep_breather
)

/datum/trait/nobreathe/apply(var/datum/species/S, var/mob/living/carbon/human/H)
	..()
	H.does_not_breathe = 1
	var/obj/item/organ/internal/breathy = H.internal_organs_by_name[O_LUNGS]
	if(!breathy)
		return
	H.internal_organs -= breathy
	qdel(breathy)
