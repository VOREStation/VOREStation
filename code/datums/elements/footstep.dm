#define SHOULD_DISABLE_FOOTSTEPS(source)

///Footstep element. Plays footsteps at parents location when it is appropriate.
/datum/element/footstep
	element_flags = ELEMENT_DETACH_ON_HOST_DESTROY|ELEMENT_BESPOKE
	argument_hash_start_idx = 2
	///A list containing living mobs and the number of steps they have taken since the last time their footsteps were played.
	var/list/steps_for_living = list()
	///volume determines the extra volume of the footstep. This is multiplied by the base volume, should there be one.
	var/volume
	///e_range stands for extra range - aka how far the sound can be heard. This is added to the base value and ignored if there isn't a base value.
	var/e_range
	///footstep_type is a define which determines what kind of sounds should get chosen.
	var/footstep_type
	///This can be a list OR a soundfile OR null. Determines whatever sound gets played.
	var/footstep_sounds
	///Whether or not to add variation to the sounds played
	var/sound_vary = FALSE

/datum/element/footstep/Attach(datum/target, footstep_type = FOOTSTEP_MOB_BAREFOOT, volume = 0.1, e_range = -8, sound_vary = FALSE)
	. = ..()
	if(!ismovable(target))
		return ELEMENT_INCOMPATIBLE
	src.volume = volume
	src.e_range = e_range
	src.footstep_type = footstep_type
	src.sound_vary = sound_vary

	if(ishuman(target))
		RegisterSignal(target, COMSIG_MOVABLE_MOVED, PROC_REF(play_humanstep))
		steps_for_living[target] = 0
		return

	footstep_sounds = check_footstep_type(footstep_type)

	RegisterSignal(target, COMSIG_MOVABLE_MOVED, PROC_REF(play_simplestep))
	steps_for_living[target] = 0

/datum/element/footstep/proc/check_footstep_type(footstep_type)
	var/footstep_ret
	switch(footstep_type)
		if(FOOTSTEP_MOB_TESHARI)
			footstep_ret = GLOB.lightclawfootstep
		if(FOOTSTEP_MOB_CLAW)
			footstep_ret = GLOB.clawfootstep
		if(FOOTSTEP_MOB_HEAVY)
			footstep_ret = GLOB.heavyfootstep
		if(FOOTSTEP_MOB_SHOE)
			footstep_ret = GLOB.footstep
		if(FOOTSTEP_MOB_SLIME)
			footstep_ret = 'sound/effects/footstep/slime1.ogg'
		if(FOOTSTEP_MOB_SLITHER)
			footstep_ret = 'sound/effects/footstep/crawl1.ogg'
		else
			footstep_ret = GLOB.barefootstep
	return footstep_ret

/datum/element/footstep/Detach(atom/movable/source)
	UnregisterSignal(source, COMSIG_MOVABLE_MOVED)
	steps_for_living -= source
	return ..()

///Prepares a footstep for living mobs. Determines if it should get played. Returns the turf it should get played on. Note that it is always a /turf/simulated
/datum/element/footstep/proc/prepare_step(mob/living/source)
	var/turf/simulated/turf = get_turf(source)
	if(!istype(turf))
		return

	if(source.is_incorporeal())
		return

	if(source.buckled || source.throwing || source.movement_type & (source.is_ventcrawling | source.flying))
		return

	if(source.lying) //play crawling sound if we're lying
		if(turf.footstep)
			playsound(turf, 'sound/effects/footstep/crawl1.ogg', 15 * volume, falloff = 1, vary = sound_vary)
		return

	if(iscarbon(source))
		var/mob/living/carbon/carbon_source = source
		if(!carbon_source.get_organ(BP_L_LEG) && !carbon_source.get_organ(BP_R_LEG))
			return
		if(carbon_source.m_intent == I_WALK)
			return// stealth
	steps_for_living[source] += 1
	var/steps = steps_for_living[source]

	if(steps >= 6)
		steps_for_living[source] = 0
		steps = 0

	if(steps % 2)
		return

	if(steps != 0 && !get_gravity(source)) // don't need to step as often when you hop around
		return

	. = list(
		FOOTSTEP_MOB_SHOE = turf.footstep,
		FOOTSTEP_MOB_BAREFOOT = turf.barefootstep,
		FOOTSTEP_MOB_HEAVY = turf.heavyfootstep,
		FOOTSTEP_MOB_CLAW = turf.clawfootstep,
		STEP_SOUND_PRIORITY = STEP_SOUND_NO_PRIORITY
		)

	var/overriden = SEND_SIGNAL(turf, COMSIG_TURF_PREPARE_STEP_SOUND, .) & FOOTSTEP_OVERRIDEN
	//The turf has no footstep sound (e.g. open space) and none of the objects on that turf (e.g. catwalks) overrides it
	if(!overriden && isnull(turf.footstep))
		return null
	return .

/datum/element/footstep/proc/play_simplestep(mob/living/source, atom/oldloc, direction, forced, list/old_locs, momentum_change)
	SIGNAL_HANDLER

	var/volume_multiplier = 0.3

	if(!isturf(source.loc))
		return

	var/list/prepared_steps = prepare_step(source)
	if(isnull(prepared_steps))
		return

	if(isfile(footstep_sounds) || istext(footstep_sounds))
		playsound(source.loc, footstep_sounds, volume * volume_multiplier, falloff = 1, vary = sound_vary)
		return

	var/turf_footstep = prepared_steps[footstep_type]
	if(isnull(turf_footstep) || !footstep_sounds[turf_footstep])
		return
	playsound(source.loc, pick(footstep_sounds[turf_footstep][1]), footstep_sounds[turf_footstep][2] * volume, TRUE, footstep_sounds[turf_footstep][3] + e_range, falloff = 1, vary = sound_vary)

/datum/element/footstep/proc/play_humanstep(mob/living/carbon/human/source, atom/oldloc, direction, forced, list/old_locs, momentum_change)
	SIGNAL_HANDLER

	var/volume_multiplier = 0.3
	var/range_adjustment = 0

	var/list/prepared_steps = prepare_step(source)
	if(isnull(prepared_steps))
		return

	//cache for sanic speed (lists are references anyways)
	var/footstep_sounds = GLOB.footstep

	if( source.shoes || ( source.wear_suit && (source.wear_suit.body_parts_covered & FEET) ) )
		// we are wearing shoes

		var/shoestep_type = prepared_steps[FOOTSTEP_MOB_SHOE]
		if(!isnull(shoestep_type) && footstep_sounds[shoestep_type]) // shoestep type can be null
			playsound(source.loc, pick(footstep_sounds[shoestep_type][1]),
				footstep_sounds[shoestep_type][2] * volume * volume_multiplier,
				TRUE,
				footstep_sounds[shoestep_type][3] + e_range + range_adjustment, falloff = 1, vary = sound_vary)
	else
		// we are barefoot

		if(source.species.special_step_sounds)
			playsound(source.loc, pick(source.species.special_step_sounds), volume, TRUE, falloff = 1, vary = sound_vary)
		else if (istype(source.species, /datum/species/shapeshifter/promethean))
			playsound(source.loc, 'sound/effects/footstep/slime1.ogg', volume, TRUE, falloff = 1)
		else if (source.custom_footstep == FOOTSTEP_MOB_SLITHER)
			playsound(source.loc, 'sound/effects/footstep/crawl1.ogg', 15 * volume, falloff = 1, vary = sound_vary)
		else
			var/barefoot_type = prepared_steps[FOOTSTEP_MOB_BAREFOOT]
			var/bare_footstep_sounds
			if(source.custom_footstep != FOOTSTEP_MOB_HUMAN)
				bare_footstep_sounds = check_footstep_type(source.custom_footstep)
			else
				bare_footstep_sounds = GLOB.barefootstep
			if(!isnull(barefoot_type) && bare_footstep_sounds[barefoot_type]) // barefoot_type can be null
				playsound(source.loc, pick(bare_footstep_sounds[barefoot_type][1]),
					bare_footstep_sounds[barefoot_type][2] * volume * volume_multiplier,
					TRUE,
					bare_footstep_sounds[barefoot_type][3] + e_range + range_adjustment, falloff = 1, vary = sound_vary)

///Prepares a footstep for machine walking
/datum/element/footstep/proc/play_simplestep_machine(atom/movable/source, atom/oldloc, direction, forced, list/old_locs, momentum_change)
	SIGNAL_HANDLER

	var/turf/simulated/source_loc = get_turf(source)
	if(!istype(source_loc))
		return

	playsound(source_loc, footstep_sounds, 50, falloff = 1, vary = sound_vary)
#undef SHOULD_DISABLE_FOOTSTEPS
