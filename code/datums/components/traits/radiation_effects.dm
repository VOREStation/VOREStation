
/* Component that handles species effects for mobs/species when they are afflicted with radiation.
 * Allows for healing, contamination, and immunity.
 */
/datum/component/radiation_effects
	///Below this value, no glow occurs.
	var/radiation_glow_threshold = 50

	///If we spread radiation or not.
	var/contamination = FALSE
	///Range of our contamination, if we contaminate.
	var/contamination_range = 1

	var/glows = TRUE

	///What color we glow.
	var/radiation_color = "#c3f314"
	///Intensity modifier of our glow
	var/intensity_mod = 1
	///Range modifier of our glow
	var/range_mod = 1
	///How much we divide our radiation by to determine how far our glow is.
	var/range_coefficient = 100
	///How much we divide our radiation by to determine how intense our glow is.
	var/intensity_coefficient = 150

	///If we are immune to radiation damage or not.
	var/radiation_immunity = FALSE

	///If we heal from radiation or not
	var/radiation_healing = FALSE

	///If we dissipate radiation or keep it.
	var/radiation_dissipation = TRUE

/datum/component/radiation_effects/Initialize(glows, radiation_glow_minor_threshold, contamination, contamination_range, radiation_color, intensity_mod, range_mod, radiation_immunity, radiation_healing, radiation_dissipation)

	if(!isliving(parent))
		return COMPONENT_INCOMPATIBLE
	if(glows)
		src.glows = glows
	if(radiation_glow_threshold)
		src.radiation_glow_threshold = radiation_glow_threshold
	if(contamination)
		src.contamination = contamination
	if(contamination_range)
		src.contamination_range = contamination_range
	if(radiation_color)
		src.radiation_color = radiation_color
	if(intensity_mod)
		src.intensity_mod = intensity_mod
	if(range_mod)
		src.range_mod = range_mod
	if(radiation_immunity)
		src.radiation_immunity = radiation_immunity
	if(radiation_healing)
		src.radiation_healing = radiation_healing
	if(radiation_dissipation)
		src.radiation_dissipation = radiation_dissipation

/datum/component/radiation_effects/RegisterWithParent()
	RegisterSignal(parent, COMSIG_HANDLE_RADIATION, PROC_REF(process_component))
	RegisterSignal(parent, COMSIG_LIVING_LIFE, PROC_REF(process_glow))

/datum/component/radiation_effects/UnregisterFromParent()
	UnregisterSignal(parent, list(COMSIG_HANDLE_RADIATION, COMSIG_LIVING_LIFE))

/datum/component/radiation_effects/proc/process_glow()
	SIGNAL_HANDLER
	var/mob/living/living_guy = parent
	if(!glows)
		if(glow_override) //Toggled glow off while we were still actively glowing.
			living_guy.glow_override = FALSE
			living_guy.set_light(0)
		return
	if(living_guy.radiation < radiation_glow_threshold)
		living_guy.glow_override = FALSE
		living_guy.set_light(0)
		return

	if(glows)
		var/light_range = CLAMP((living_guy.radiation/range_coefficient) * range_mod, 1, 7) //Min 1, max 7
		var/light_power = max(1, living_guy.radiation/intensity_coefficient) * intensity_mod //No maximum. This can get BRIGHT.

		living_guy.set_light(l_range = light_range, l_power = light_power, l_color = radiation_color, l_on = TRUE)
		living_guy.glow_override = TRUE

/datum/component/radiation_effects/proc/process_component()
	SIGNAL_HANDLER
	var/mob/living/living_guy = parent
	if(QDELETED(parent))
		return

	if(radiation_immunity || radiation_healing)
		//We have to remove radiation here since we're blocking radiation altogether.
		var/rad_removal_mod = 1
		var/rads = living_guy.radiation/25

		if(ishuman(living_guy))
			var/mob/living/carbon/human/human_guy = parent
			rad_removal_mod = human_guy.species.rad_removal_mod
		var/rads_to_utilize = rads * rad_removal_mod

		//If we heal from radiation, we will dissipate (use up) the amount we heal.
		if(radiation_healing)
			living_guy.radiation -= rads_to_utilize
			rads_to_utilize = CLAMP(rads_to_utilize, 1, 10) //Only heal up to 10 rads.
			living_guy.adjust_nutrition(rads_to_utilize)
			living_guy.adjustBruteLoss(-rads_to_utilize)
			living_guy.adjustFireLoss(-rads_to_utilize)
			living_guy.adjustOxyLoss(-rads_to_utilize)
			living_guy.adjustToxLoss(-rads_to_utilize)
			living_guy.updatehealth()

		else if(radiation_dissipation)
			living_guy.radiation -= rads_to_utilize

		return COMPONENT_BLOCK_LIVING_RADIATION

//Subtypes

///Glows and is immune to radiation
/datum/component/radiation_effects/promethean
	radiation_immunity = TRUE

///Heals from radiation. Does not glow.
/datum/component/radiation_effects/diona
	glows = FALSE
	radiation_healing = TRUE
