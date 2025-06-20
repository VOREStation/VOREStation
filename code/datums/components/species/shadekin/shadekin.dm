/datum/component/shadekin
	VAR_PRIVATE/mob/living/owner //So we can use for things that we don't care if we're simple or a human.
	var/dark_energy = 100
	var/max_dark_energy = 100
	var/dark_energy_infinite = FALSE
	var/doing_phase = FALSE // Prevent bugs when spamming phase button
	var/in_phase = FALSE

	///How much energy we generate in the dark
	var/energy_dark = 0.75
	///How much energy we generate in the light
	var/energy_light = 0.25
	///The innate abilities we start with
	var/list/shadekin_abilities = list(/datum/power/shadekin/phase_shift,
									   /datum/power/shadekin/regenerate_other,
									   /datum/power/shadekin/create_shade)
	var/list/shadekin_ability_datums = list()
	dupe_mode = COMPONENT_DUPE_UNIQUE

/datum/component/shadekin/phase_only
	shadekin_abilities = list(/datum/power/shadekin/phase_shift)

/datum/component/shadekin/Initialize()
	if(!isliving(parent))
		return COMPONENT_INCOMPATIBLE
	owner = parent
	add_shadekin_abilities(owner)
	if(ishuman(owner))
		RegisterSignal(owner, COMSIG_SHADEKIN_COMPONENT, PROC_REF(handle_comp))
	else
		RegisterSignal(owner, COMSIG_LIVING_LIFE, PROC_REF(handle_comp))
	for(var/power in shadekin_abilities)
		var/datum/power/shadekin/SKP = new power(src)
		shadekin_ability_datums.Add(SKP)
	add_shadekin_abilities()
	add_hud()
	handle_comp() //First hit is free!

/datum/component/shadekin/Destroy(force)
	if(ishuman(owner))
		UnregisterSignal(owner, COMSIG_SHADEKIN_COMPONENT)
	else
		UnregisterSignal(owner, COMSIG_LIVING_LIFE)
	//todo remove verbs proc
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

//wait, it's all light?
///Allows setting the light and darkness gain.
///@Args: light, darkness
/datum/component/shadekin/proc/set_light_and_darkness(light, darkness)
	if(light)
		energy_light = light
	if(darkness)
		energy_dark = darkness

///Returns the shadekin component of the given mob
/mob/living/proc/get_shadekin_component()
	var/datum/component/shadekin/SK = GetComponent(/datum/component/shadekin)
	if(SK)
		return SK

/// Returns the shadekin's current energy.
/// Returns max_energy if dark_energy_infinite is set to TRUE.
/datum/component/shadekin/proc/shadekin_get_energy()
	if(dark_energy_infinite)
		return max_dark_energy
	return dark_energy

/// Returns the shadekin's maximum energy.
/datum/component/shadekin/proc/shadekin_get_max_energy()
	return max_dark_energy

///Sets the shadekin's energy TO the given value.
/datum/component/shadekin/proc/shadekin_set_energy(var/new_energy)
	if(!isnum(new_energy))
		return
	dark_energy = CLAMP(new_energy, 0, max_dark_energy)

///Sets the shadekin's maximum energy.
/datum/component/shadekin/proc/shadekin_set_max_energy(var/new_max_energy)
	if(!isnum(new_max_energy))
		return //No.
	max_dark_energy = new_max_energy

///Adjusts the shadekin's energy by the given amount.
/datum/component/shadekin/proc/shadekin_adjust_energy(var/amount)
	if(!isnum(amount))
		return //No
	shadekin_set_energy(dark_energy + amount)

///Adds the shadekin abilities to the owner.
/datum/component/shadekin/proc/add_shadekin_abilities()
	if(!owner.ability_master || !istype(owner.ability_master, /obj/screen/movable/ability_master/shadekin))
		owner.ability_master = null
		owner.ability_master = new /obj/screen/movable/ability_master/shadekin(owner)
	for(var/datum/power/shadekin/P in shadekin_ability_datums)
		if(!(P.verbpath in owner.verbs))
			add_verb(owner, P.verbpath)
			owner.ability_master.add_shadekin_ability(
					object_given = owner,
					verb_given = P.verbpath,
					name_given = P.name,
					ability_icon_given = P.ability_icon_state,
					arguments = list()
					)

///Adds the shadekin_display if we don't already have it.
/datum/component/shadekin/proc/add_hud()
	if(owner.shadekin_display)
		return //Already added
	owner.shadekin_display = new /obj/screen/shadekin()
	owner.shadekin_display.screen_loc = ui_shadekin_display
	owner.shadekin_display.icon_state = "shadekin"
	if(owner.client)
		owner.client.screen += owner.shadekin_display

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

///Handles the shadekin's HUD updates.
/datum/component/shadekin/proc/update_shadekin_hud()
	var/turf/T = get_turf(owner)
	if(owner.shadekin_display)
		var/l_icon = 0
		var/e_icon = 0

		owner.shadekin_display.invisibility = INVISIBILITY_NONE
		if(T)
			var/brightness = T.get_lumcount() //Brightness in 0.0 to 1.0
			var/darkness = 1-brightness //Invert
			switch(darkness)
				if(0.80 to 1.00)
					l_icon = 0
				if(0.60 to 0.80)
					l_icon = 1
				if(0.40 to 0.60)
					l_icon = 2
				if(0.20 to 0.40)
					l_icon = 3
				if(0.00 to 0.20)
					l_icon = 4

		switch(shadekin_get_energy())
			if(0 to 24)
				e_icon = 0
			if(25 to 49)
				e_icon = 1
			if(50 to 74)
				e_icon = 2
			if(75 to 99)
				e_icon = 3
			if(100 to INFINITY)
				e_icon = 4

		owner.shadekin_display.icon_state = "shadekin-[l_icon]-[e_icon]"
	return
