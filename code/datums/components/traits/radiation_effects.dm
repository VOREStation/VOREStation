
/* Component that handles species effects for mobs/species when they are afflicted with radiation.
 * Allows for glowing, healing, contamination, and immunity.
 */
/datum/component/radiation_effects
	///Below this value, no glow occurs.
	var/radiation_glow_threshold = 50

	///If we spread radiation or not.
	var/contamination = FALSE
	///Strength of our contamination, if we contaminate. Each 1 strength is 100% of the rads we're dissipating.
	var/contamination_strength = 0.1
	///What level our radiation has to be above to begin to contaminate our surroundings.
	var/contamination_threshold = 600

	///If we glow or not.
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

/datum/component/radiation_effects/Initialize(glows, radiation_glow_minor_threshold, contamination, contamination_strength, radiation_color, intensity_mod, range_mod, radiation_immunity, radiation_healing, radiation_dissipation)

	if(!isliving(parent))
		return COMPONENT_INCOMPATIBLE
	if(glows)
		src.glows = glows
	if(radiation_glow_threshold)
		src.radiation_glow_threshold = radiation_glow_threshold
	if(contamination)
		src.contamination = contamination
	if(contamination_strength)
		src.contamination_strength = contamination_strength
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

	add_verb(parent, /mob/living/proc/radiation_control_panel)

/datum/component/radiation_effects/RegisterWithParent()
	RegisterSignal(parent, COMSIG_HANDLE_RADIATION, PROC_REF(process_component))
	RegisterSignal(parent, COMSIG_LIVING_LIFE, PROC_REF(process_glow))
	RegisterSignal(parent, COMSIG_LIVING_IRRADIATE_EFFECT, PROC_REF(handle_irradiate_effect))

/datum/component/radiation_effects/UnregisterFromParent()
	UnregisterSignal(parent, list(COMSIG_HANDLE_RADIATION, COMSIG_LIVING_LIFE, COMSIG_LIVING_IRRADIATE_EFFECT))

/datum/component/radiation_effects/proc/process_glow()
	SIGNAL_HANDLER
	var/mob/living/living_guy = parent
	if(!glows)
		if(living_guy.glow_override) //Toggled glow off while we were still actively glowing.
			living_guy.glow_override = FALSE
			living_guy.set_light(0)
		return
	if(living_guy.radiation < radiation_glow_threshold)
		living_guy.glow_override = FALSE
		living_guy.set_light(0)
		return

	if(glows)
		var/light_range = CLAMP((living_guy.radiation/range_coefficient) * range_mod, 1, 7) //Min 1, max 7
		var/light_power = CLAMP(living_guy.radiation/intensity_coefficient * intensity_mod, 1, 10)

		living_guy.set_light(l_range = light_range, l_power = light_power, l_color = radiation_color, l_on = TRUE)
		living_guy.glow_override = TRUE

///Handles the radiation removal, immunity, and healing effects.
/datum/component/radiation_effects/proc/process_component()
	SIGNAL_HANDLER
	var/mob/living/living_guy = parent
	if(living_guy.radiation > RADIATION_CAP)
		living_guy.radiation = CLAMP(living_guy.radiation,0,RADIATION_CAP)
		living_guy.accumulated_rads = CLAMP(living_guy.accumulated_rads,0,RADIATION_CAP)

	if(QDELETED(parent))
		return

	//Radiation calculation, done here since contamination uses it
	var/rad_removal_mod = 1
	var/rads = living_guy.radiation * 0.04

	if(ishuman(living_guy))
		var/mob/living/carbon/human/human_guy = parent
		rad_removal_mod = human_guy.species.rad_removal_mod
	//End of the calculation.

	if(contamination && living_guy.radiation > contamination_threshold)
		SSradiation.radiate(living_guy, rads * contamination_strength * rad_removal_mod)

	if(radiation_immunity || radiation_healing)
		//We have to remove radiation here since we're blocking radiation altogether.
		var/rads_to_utilize = rads * rad_removal_mod

		//If we heal from radiation, we will dissipate (use up) the amount we heal.
		if(radiation_healing)
			living_guy.radiation -= rads_to_utilize
			living_guy.accumulated_rads -= rads_to_utilize
			rads_to_utilize = CLAMP(rads_to_utilize, 1, 10) //Only heal up to 10 rads.
			living_guy.adjust_nutrition(rads_to_utilize)
			living_guy.adjustBruteLoss(-rads_to_utilize)
			living_guy.adjustFireLoss(-rads_to_utilize)
			living_guy.adjustOxyLoss(-rads_to_utilize)
			living_guy.adjustToxLoss(-rads_to_utilize)
			living_guy.updatehealth()

		else if(radiation_dissipation)
			living_guy.radiation -= rads_to_utilize
			living_guy.accumulated_rads -= rads_to_utilize

		return COMPONENT_BLOCK_LIVING_RADIATION

/datum/component/radiation_effects/proc/handle_irradiate_effect(var/mob/living/living_guy, var/effect, var/effecttype, var/blocked, var/check_protection, var/rad_protection)
	SIGNAL_HANDLER
	///If we're not contaminating, don't worry about this. Proceed like normal.
	if(!contamination || (contamination && living_guy.radiation < contamination_threshold))
		//to_chat(world, "Radiation like normal. Current rads = [living_guy.radiation]. Amount of rads being added = [effect].")
		return

	var/rad_removal_mod = 1
	if(ishuman(living_guy))
		var/mob/living/carbon/human/human_guy = parent
		rad_removal_mod = human_guy.species.rad_removal_mod

	var/radiation_offput = ((living_guy.radiation * 0.04) * contamination_strength * rad_removal_mod)
	var/radiation_to_apply = (effect - radiation_offput)
	if(radiation_to_apply > 0)
		// to_chat(world, "Radiation blocker. Current rads = [living_guy.radiation]. Original = [effect] RTA = [radiation_to_apply] After protection = [radiation_to_apply * rad_protection]. Amount of rads we're offputting = [radiation_offput]")

		//This stops MOST of the radiation we're offputting from hitting us.
		//If we linger in one place for a prolonged period, the area around us will become irradiated and give us a small bit of radiation back. (only got ~1 rad per tick when we were offputting 60 rads for example)
		//However, we'll lose our rads faster than we accumulate.
		living_guy.radiation += max((radiation_to_apply * rad_protection), 0)
		return COMPONENT_BLOCK_IRRADIATION
/datum/component/radiation_effects/promethean
	radiation_immunity = TRUE

/datum/component/radiation_effects/shadekin
	radiation_immunity = TRUE
	glows = FALSE

///Heals from radiation. Does not glow.
/datum/component/radiation_effects/diona
	glows = FALSE
	radiation_healing = TRUE

///TGUI below here
//TGUI Weaver Panel
/datum/component/radiation_effects/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "RadiationConfig", "Radiation Config")
		ui.open()


/mob/living/proc/radiation_control_panel()
	set name = "Radiation Control Panel"
	set desc = "Allows you to adjust the settings of various radioactive settings!"
	set category = "Abilities.Radiation"

	var/datum/component/radiation_effects/rad = get_radiation_component()
	if(!rad)
		to_chat(src, span_warning("You don't have the radiation component! This is a bug! Please report this to a maintainer."))
		return FALSE

	rad.tgui_interact(src)

/datum/component/radiation_effects/tgui_data(mob/user)
	var/data = list(
		"glowing" = glows,
		"radiation_color" = radiation_color,
	)

	return data

/datum/component/radiation_effects/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
	if(..())
		return TRUE

	switch(action)
		if("toggle_color")
			var/set_new_color = tgui_color_picker(ui.user, "Select a color you wish your radioactive glow to be!", "Color Selector", radiation_color)
			if(!set_new_color)
				return FALSE
			radiation_color = set_new_color
			return TRUE
		if("toggle_glow")
			glows = !glows
			to_chat(parent, span_info("You are [glows ? "now" : "no longer"] glowing."))
			return FALSE

/mob/living/proc/get_radiation_component()
	var/datum/component/radiation_effects/rad = GetComponent(/datum/component/radiation_effects)
	if(rad)
		return rad
