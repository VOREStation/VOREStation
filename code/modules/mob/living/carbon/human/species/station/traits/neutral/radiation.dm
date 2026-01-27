/datum/trait/glowing_radiation
	name = "Radioactive Glow"
	desc = "You emit a glow when exposed to radiation! This does not prevent you from being harmed by radiation."
	cost = 0
	category = TRAIT_TYPE_NEUTRAL
	has_preferences = list("glow_color" = list(TRAIT_PREF_TYPE_COLOR, "Glow color", TRAIT_NO_VAREDIT_TARGET, "#c3f314"))
	added_component_path = /datum/component/radiation_effects
	excludes = list(/datum/trait/radioactive_heal)

/datum/trait/glowing_radiation/apply(var/datum/species/S,var/mob/living/carbon/human/H, var/list/trait_prefs)
	..()
	var/datum/component/radiation_effects/G = H.GetComponent(added_component_path)
	if(trait_prefs)
		G.radiation_color = trait_prefs["glow_color"]
