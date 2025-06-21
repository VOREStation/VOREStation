//See comp_helpers.dm for helper procs.
/datum/component/shadekin
	VAR_PRIVATE/mob/living/owner

	//Energy Vars
	///How much energy we have RIGHT NOW
	var/dark_energy = 100
	///How much energy we can have
	var/max_dark_energy = 100
	///Always be at our max_dark_energy
	var/dark_energy_infinite = FALSE
	///How much energy we generate in the dark
	var/energy_dark = 0.75
	///How much energy we generate in the light
	var/energy_light = 0.25
	///If we care about eye color when it comes to factoring in energy
	var/eye_color_influences_energy = TRUE
	///Energy gain from nutrition
	var/nutrition_conversion_scaling = 0.5
	///If we convert nutrition to energy
	var/nutrition_energy_conversion = FALSE

	//Phase Vars
	///Are we currently in a phase transition?
	var/doing_phase = FALSE
	///Are we currently phased?
	var/in_phase = FALSE
	///Do we damage lights on phase?
	var/phase_gentle = FALSE

	//Dark Respite Vars (Unused on Virgo)
	///If we are in dark respite or not
	var/in_dark_respite = FALSE
	var/manual_respite = FALSE
	var/respite_activating = FALSE

	//Dark Tunneling Vars (Unused on Virgo)
	///If we have already made a dark tunnel
	var/created_dark_tunnel = FALSE

	//Dark Maw Vars (Unused on Virgo)
	///Our current active dark maws
	var/list/active_dark_maws = list()

	//Ability Vars
	///The innate abilities we start with
	var/list/shadekin_abilities = list(/datum/power/shadekin/phase_shift,
									   /datum/power/shadekin/regenerate_other,
									   /datum/power/shadekin/create_shade)
	var/list/shadekin_ability_datums = list()
	dupe_mode = COMPONENT_DUPE_UNIQUE

	//Misc Vars
	///Eyecolor
	var/eye_color = BLUE_EYES

/datum/component/shadekin/phase_only
	shadekin_abilities = list(/datum/power/shadekin/phase_shift)

/datum/component/shadekin/full
	shadekin_abilities = list(/datum/power/shadekin/phase_shift,
							  /datum/power/shadekin/regenerate_other,
							  /datum/power/shadekin/create_shade,
							  /datum/power/shadekin/dark_maw,
							  /datum/power/shadekin/dark_respite,
							  /datum/power/shadekin/dark_tunneling)

/datum/component/shadekin/Initialize()
	//normal component bs
	if(!isliving(parent))
		return COMPONENT_INCOMPATIBLE
	owner = parent
	add_shadekin_abilities(owner)
	if(ishuman(owner))
		RegisterSignal(owner, COMSIG_SHADEKIN_COMPONENT, PROC_REF(handle_comp)) //Happens every species tick.
	else
		RegisterSignal(owner, COMSIG_LIVING_LIFE, PROC_REF(handle_comp)) //Happens every life tick (mobs)

	//generates powers and then adds them
	for(var/power in shadekin_abilities)
		var/datum/power/shadekin/SKP = new power(src)
		shadekin_ability_datums.Add(SKP)
	add_shadekin_abilities()

	handle_comp() //First hit is free!

	//decides what 'eye color' we are and how much energy we should get
	set_shadekin_eyecolor() //Gets what eye color we are.
	set_eye_energy() //Sets the energy values based on our eye color.

	//Misc stuff we need to do
	//add_verb(owner, /mob/living/proc/phase_strength_toggle) //Disabled on Virgo
	//add_verb(owner, /mob/living/proc/nutrition_conversion_toggle) //Disabled on Virgo

/datum/component/shadekin/Destroy(force)
	if(ishuman(owner))
		UnregisterSignal(owner, COMSIG_SHADEKIN_COMPONENT)
	else
		UnregisterSignal(owner, COMSIG_LIVING_LIFE)
	//remove_verb(owner, /mob/living/proc/phase_strength_toggle) //Disabled on Virgo
	//remove_verb(owner, /mob/living/proc/nutrition_conversion_toggle) //Disabled on Virgo
	//todo remove verbs proc
	for(var/datum/power in shadekin_ability_datums)
		qdel(power)
	for(var/obj/effect/abstract/dark_maw/dm as anything in active_dark_maws) //if the component gets destroyed so does your precious maws
		if(!QDELETED(dm))
			qdel(dm)
	active_dark_maws.Cut()
	shadekin_abilities.Cut()
	shadekin_ability_datums.Cut()
	owner = null
	. = ..()

///Handles the component running.
/datum/component/shadekin/proc/handle_comp()
	SIGNAL_HANDLER
	if(QDELETED(parent))
		return
	if(owner.stat == DEAD) //dead, don't process.
		return
	handle_shade()

///Handles the shadekin's energy gain and loss.
/datum/component/shadekin/proc/handle_shade()
	//Shifted kin don't gain/lose energy (and save time if we're at the cap)
	var/darkness = 1
	var/dark_gains = 0

	var/turf/T = get_turf(owner)
	if(!T)
		dark_gains = 0
		return

	var/brightness = T.get_lumcount() //Brightness in 0.0 to 1.0
	darkness = 1-brightness //Invert
	var/is_dark = (darkness >= 0.5)

	if(in_phase) //Only humans have ability flags
		dark_gains = 0
	else
		//Heal (very) slowly in good darkness
		if(is_dark)
		//The below sends a DB query...This needs to be fixed before this can be enabled as we're now dealing with signal handlers.
		//Reenable once that mess is taken care of.
		/*
			owner.adjustFireLoss((-0.10)*darkness)
			owner.adjustBruteLoss((-0.10)*darkness)
			owner.adjustToxLoss((-0.10)*darkness)
		*/
			//energy_dark and energy_light are set by the shadekin eye traits.
			//These are balanced around their playstyles and 2 planned new aggressive abilities
			dark_gains = energy_dark
		else
			dark_gains = energy_light

	shadekin_adjust_energy(dark_gains)

	//Update huds
	update_shadekin_hud()


/mob/living/proc/phase_strength_toggle()
	set name = "Toggle Phase Strength"
	set desc = "Toggle strength of phase. Gentle but slower, or faster but destructive to lights."
	set category = "Abilities.Shadekin"

	var/datum/component/shadekin/SK = get_shadekin_component()
	if(!SK)
		return

	if(SK.phase_gentle)
		to_chat(src, span_notice("Phasing toggled to Normal. You may damage lights."))
		SK.phase_gentle = 0
	else
		to_chat(src, span_notice("Phasing toggled to Gentle. You won't damage lights, but concentrating on that incurs a short stun."))
		SK.phase_gentle = 1


/mob/living/proc/nutrition_conversion_toggle()
	set name = "Toggle Energy <-> Nutrition conversions"
	set desc = "Toggle dark energy and nutrition being converted into each other when full"
	set category = "Abilities.Shadekin"

	var/datum/component/shadekin/SK = get_shadekin_component()
	if(SK)
		to_chat(src, span_warning("Only a shadekin can use that!"))
		return FALSE

	if(SK.nutrition_energy_conversion)
		to_chat(src, span_notice("Nutrition and dark energy conversions disabled."))
		SK.nutrition_energy_conversion = 0
	else
		to_chat(src, span_notice("Nutrition and dark energy conversions enabled."))
		SK.nutrition_energy_conversion = 1
