//See comp_helpers.dm for helper procs.
/datum/component/shadekin
	VAR_PRIVATE/mob/living/owner
	dupe_mode = COMPONENT_DUPE_UNIQUE

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
	///Chance to break lights on phase-in
	var/flicker_break_chance = 0
	///Color that lights will flicker to on phase-in. Off by default.
	var/flicker_color
	///Time that lights will flicker on phase-in. Default is 10 times.
	var/flicker_time = 10
	///Range that we flicker lights. Default is 10.
	var/flicker_distance = 10
	///If we can get the 'phase debuff' applied to us. (No using guns, dropping things in hands, etc).
	var/normal_phase = TRUE
	///If we drop items on phase.
	var/drop_items_on_phase = FALSE

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
	///Datum holder. Largely ignore this.
	var/list/shadekin_ability_datums = list()

	//Misc Vars
	///Eyecolor
	var/eye_color = BLUE_EYES
	///For downstream. Enables some extra verbs. Causes things to drop in hand when you phase.
	var/extended_kin = FALSE

/datum/component/shadekin/phase_only
	shadekin_abilities = list(/datum/power/shadekin/phase_shift)

/datum/component/shadekin/full
	shadekin_abilities = list(/datum/power/shadekin/phase_shift,
							  /datum/power/shadekin/regenerate_other,
							  /datum/power/shadekin/create_shade,
							  /datum/power/shadekin/dark_maw,
							  /datum/power/shadekin/dark_respite,
							  /datum/power/shadekin/dark_tunneling)
	extended_kin = TRUE
	drop_items_on_phase = TRUE

/datum/component/shadekin/full/rakshasa
	flicker_time = 0 //Rakshasa don't flicker lights when they phase in.
	dark_energy_infinite = TRUE
	normal_phase = FALSE

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
	if(extended_kin)
		add_verb(owner, /mob/living/proc/nutrition_conversion_toggle)
	add_verb(owner, /mob/living/proc/flicker_adjustment)

/datum/component/shadekin/Destroy(force)
	if(ishuman(owner))
		UnregisterSignal(owner, COMSIG_SHADEKIN_COMPONENT)
	else
		UnregisterSignal(owner, COMSIG_LIVING_LIFE)
	if(extended_kin)
		remove_verb(owner, /mob/living/proc/nutrition_conversion_toggle)
	remove_verb(owner, /mob/living/proc/flicker_adjustment)
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

	if(in_phase)
		dark_gains = 0
	else
		//Heal (very) slowly in good darkness
		if(is_dark)
		//The below sends a DB query...This needs to be fixed before this can be enabled as we're now dealing with signal handlers.
		//Reenable once that mess is taken care of.
			owner.adjustFireLoss((-0.10)*darkness)
			owner.adjustBruteLoss((-0.10)*darkness)
			owner.adjustToxLoss((-0.10)*darkness)
			//energy_dark and energy_light are set by the shadekin eye traits.
			//These are balanced around their playstyles and 2 planned new aggressive abilities
			dark_gains = energy_dark
		else
			dark_gains = energy_light

	shadekin_adjust_energy(dark_gains)

	//Update huds
	update_shadekin_hud()


/mob/living/proc/nutrition_conversion_toggle()
	set name = "Toggle Energy <-> Nutrition conversions"
	set desc = "Toggle dark energy and nutrition being converted into each other when full"
	set category = "Abilities.Shadekin"

	var/datum/component/shadekin/SK = get_shadekin_component()
	if(!SK)
		to_chat(src, span_warning("Only a shadekin can use that!"))
		return FALSE

	if(SK.nutrition_energy_conversion)
		to_chat(src, span_notice("Nutrition and dark energy conversions disabled."))
		SK.nutrition_energy_conversion = 0
	else
		to_chat(src, span_notice("Nutrition and dark energy conversions enabled."))
		SK.nutrition_energy_conversion = 1

/mob/living/proc/flicker_adjustment()
	set name = "Adjust Light Flicker"
	set desc = "Allows you to adjust the settings of the light flicker when you phase in!"
	set category = "Abilities.Shadekin"

	var/datum/component/shadekin/SK = get_shadekin_component()
	if(!SK)
		to_chat(src, span_warning("Only a shadekin can use that!"))
		return FALSE
	var/flicker_timer = tgui_input_number(src, "Adjust how long lights flicker when you phase in! (Min 10 Max 20 times!)", "Set Flicker", SK.flicker_time, 20, 10)
	if(flicker_timer > 20 || flicker_timer < 10)
		to_chat(src,"<span class='warning'>You must choose a number between 10 and 20</span>")
		return
	SK.flicker_time = flicker_timer
	to_chat(src,"<span class='warning'>Flicker timer set to [SK.flicker_time] seconds!</span>")

	var/set_new_color = tgui_color_picker(src,"Select a color you wish the lights to flicker as (Default is #E0EFF0)","Color Selector", SK.flicker_color)
	if(set_new_color)
		SK.flicker_color = set_new_color
	to_chat(src,"<span class='warning'>Flicker color set to [SK.flicker_color]!</span>")

	var/break_chance = tgui_input_number(src, "Adjust the % chance for lights to break when you phase in! (Default 0. Min 0. Max 25)", "Set Break Chance", 0, 25, 0)
	if(break_chance > 25 || break_chance < 0)
		to_chat(src,"<span class='warning'>You must choose a number between 0 and 25</span>")
		return
	SK.flicker_break_chance = break_chance
	to_chat(src,"<span class='warning'>Break chance set to [SK.flicker_break_chance]%</span>")
