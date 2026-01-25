/datum/trait/rad_resistance
	name = "Radiation Resistance"
	desc = "You are generally more resistant to radiation, and it dissipates faster from your body."
	cost = 1
	var_changes = list("radiation_mod" = 0.65, "rad_removal_mod" = 3.5, "rad_levels" = RESISTANT_RADIATION_RESISTANCE)
	category = TRAIT_TYPE_POSITIVE

/datum/trait/rad_resistance_extreme
	name = "Radiation Resistance, Major"
	desc = "You are much more resistant to radiation, and it dissipates much faster from your body."
	cost = 2
	var_changes = list("radiation_mod" = 0.5, "rad_removal_mod" = 5, "rad_levels" = MAJOR_RESISTANT_RADIATION_RESISTANCE)
	category = TRAIT_TYPE_POSITIVE

/datum/trait/rad_immune
	name = "Radiation Immunity"
	desc = "For whatever reason, be it a more dense build or some quirk of your genetic code, your body is completely immune to radiation."
	cost = 3
	var_changes = list("radiation_mod" = 0.0, "rad_removal_mod" = 10, "rad_levels" = IMMUNITY_RADIATION_RESISTANCE)
	category = TRAIT_TYPE_POSITIVE

	// Traitgenes
	is_genetrait = TRUE
	hidden = FALSE
	activation_message="Your body feels mundane."

/datum/trait/radioactive_heal
	name = "Radioactive Heal"
	desc = "You heal when exposed to radiation instead of becoming ill. You can also choose to emit a glow when irradiated."
	cost = 6
	is_genetrait = TRUE
	hidden = FALSE
	has_preferences = list("glow_color" = list(TRAIT_PREF_TYPE_COLOR, "Glow color", TRAIT_NO_VAREDIT_TARGET, "#c3f314",),
	"glow_enabled" = list(TRAIT_PREF_TYPE_BOOLEAN, "Glow enabled on spawn", TRAIT_NO_VAREDIT_TARGET, FALSE))
	category = TRAIT_TYPE_POSITIVE

	added_component_path = /datum/component/radiation_effects
	excludes = list(/datum/trait/neutral/glowing_radiation, /datum/trait/rad_resistance, /datum/trait/rad_resistance_extreme, /datum/trait/rad_immune, /datum/trait/negative/rad_weakness)

/datum/trait/radioactive_heal/apply(var/datum/species/S,var/mob/living/carbon/human/H, var/list/trait_prefs)
	..()
	var/datum/component/radiation_effects/G = H.GetComponent(added_component_path)
	if(trait_prefs)
		G.radiation_color = trait_prefs["glow_color"]
		G.glows = trait_prefs["glow_enabled"]
	G.radiation_healing = TRUE
	G.radiation_nutrition = TRUE

/datum/trait/radioactive_heal/unapply(var/datum/species/S,var/mob/living/carbon/human/H, var/list/trait_prefs)
	..() //Does all the removal stuff
	//We then check to see if we still have the radiation component (such as we have a species componennt of it)
	//If so, we remove the healing effect.
	var/datum/component/radiation_effects/G = H.GetComponent(added_component_path)
	if(G)
		G.radiation_healing = initial(G.radiation_healing)
		G.radiation_nutrition = initial(G.radiation_nutrition)
