/datum/trait/weaver
	name = "Weaver"
	desc = "You can produce silk and create various articles of clothing and objects."
	cost = 2
	allowed_species = list(SPECIES_HANNER, SPECIES_CUSTOM) //So it only shows up for custom species and hanner
	custom_only = FALSE
	has_preferences = list("silk_production" = list(TRAIT_PREF_TYPE_BOOLEAN, "Silk production on spawn", TRAIT_NO_VAREDIT_TARGET), \
							"silk_color" = list(TRAIT_PREF_TYPE_COLOR, "Silk color", TRAIT_NO_VAREDIT_TARGET))
	added_component_path = /datum/component/weaver
	excludes = list(/datum/trait/cocoon_tf)
	category = TRAIT_TYPE_POSITIVE

/datum/trait/weaver/apply(var/datum/species/S,var/mob/living/carbon/human/H, var/list/trait_prefs)
	..()
	var/datum/component/weaver/W = H.GetComponent(added_component_path)
	if(S.get_bodytype() == SPECIES_VASILISSAN)
		W.silk_reserve = 500
		W.silk_max_reserve = 1000
	if(trait_prefs)
		W.silk_production = trait_prefs["silk_production"]
		W.silk_color = lowertext(trait_prefs["silk_color"])
