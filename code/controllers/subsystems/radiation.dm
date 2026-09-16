SUBSYSTEM_DEF(radiation)
	name = "Radiation"
	flags = SS_BACKGROUND | SS_NO_INIT

	wait = 0.5 SECONDS

	/// A list of radiation sources (/datum/radiation_pulse_information) that have yet to process.
	/// Do not interact with this directly, use `radiation_pulse` instead.
	var/list/datum/radiation_pulse_information/processing = list()

/datum/controller/subsystem/radiation/fire(resumed)
	while (processing.len)
		var/datum/radiation_pulse_information/pulse_information = processing[1]

		var/datum/weakref/source_ref = pulse_information.source_ref
		var/atom/source = source_ref?.resolve()
		if (isnull(source))
			processing.Cut(1, 2)
			continue

		pulse(source, pulse_information)

		if (MC_TICK_CHECK)
			return

		processing.Cut(1, 2)

/datum/controller/subsystem/radiation/stat_entry(msg)
	msg = "Pulses:[processing.len]"
	return ..()

/datum/controller/subsystem/radiation/proc/pulse(atom/source, datum/radiation_pulse_information/pulse_information)
	var/list/cached_rad_insulations = list()
	var/list/cached_turfs_to_process = pulse_information.turfs_to_process
	var/turfs_iterated = 0
	for (var/turf/turf_to_irradiate as anything in cached_turfs_to_process)
		turfs_iterated += 1

		for(var/obj/machinery/power/rad_collector in turf_to_irradiate)
			SEND_SIGNAL(rad_collector, COMSIG_IN_RANGE_OF_IRRADIATION, pulse_information, current_insulation)
			continue

		var/current_insulation = calculate_radiation_insulation(source, turf_to_irradiate, pulse_information, cached_rad_insulations)
		for(var/obj/item/geiger/geiger_counter in turf_to_irradiate)
			SEND_SIGNAL(geiger_counter, COMSIG_IN_RANGE_OF_IRRADIATION, pulse_information, current_insulation)

		for(var/mob/living/target in turf_to_irradiate)
			var/list/contents_to_check = target.get_all_contents_type(/obj/item/geiger)
			for(var/obj/item/geiger/geiger_counter in contents_to_check)
				SEND_SIGNAL(geiger_counter, COMSIG_IN_RANGE_OF_IRRADIATION, pulse_information, current_insulation)

			if(!can_irradiate_basic(target))
				continue

			SEND_SIGNAL(target, COMSIG_IN_RANGE_OF_IRRADIATION, pulse_information, current_insulation)

			// Check a second time, because of TRAIT_BYPASS_EARLY_IRRADIATED_CHECK
			if (HAS_TRAIT(target, TRAIT_IRRADIATED))
				continue

			if (current_insulation <= pulse_information.threshold)
				continue

			/// Perceived chance of target getting irradiated.
			var/perceived_chance = 100
			var/pulse_strength

			var/recieved_intensity = calculate_recieved_radiation_intensity(pulse_information, get_dist_euclidean(source, target), current_insulation)
			if(pulse_information.chance < 100)
				perceived_chance = RAD_SOLVE_CHANCE(recieved_intensity)
			pulse_strength = RAD_SOLVE_MOBRADS(pulse_information.strength, recieved_intensity)

			var/irradiation_result = SEND_SIGNAL(target, COMSIG_IN_THRESHOLD_OF_IRRADIATION, pulse_information)
			if (irradiation_result & CANCEL_IRRADIATION)
				continue

			if (pulse_information.minimum_exposure_time && !(irradiation_result & SKIP_MINIMUM_EXPOSURE_TIME_CHECK))
				target.AddComponent(/datum/component/radiation_countdown, pulse_information.minimum_exposure_time)
				continue

			if (!prob(perceived_chance))
				continue

			if (irradiate_after_basic_checks(target, pulse_strength))
				target.investigate_log("was irradiated by [source].", INVESTIGATE_RADIATION)

		if(MC_TICK_CHECK)
			break

	cached_turfs_to_process.Cut(1, turfs_iterated + 1)

/// Will attempt to irradiate the given target, limited through IC means, such as radiation protected clothing.
/datum/controller/subsystem/radiation/proc/irradiate(atom/target, strength)
	if (!can_irradiate_basic(target))
		return FALSE

	irradiate_after_basic_checks(target, strength)
	return TRUE

/datum/controller/subsystem/radiation/proc/irradiate_after_basic_checks(mob/living/target, strength)
	PRIVATE_PROC(TRUE)

	if(!ishuman(target))
		if(ismob(target))
			target.radiation += strength
			return TRUE
		return FALSE

	/// 0 = full protection, 1 = no protection.
	var/rad_vulnerability = 1 - wearing_rad_protected_clothing(target)
	if(rad_vulnerability <= 0)
		return FALSE
	target.radiation += round(strength * rad_vulnerability, 0.1)

//	target.AddComponent(/datum/component/irradiated)
	return TRUE

/// Returns whether or not the target can be irradiated by any means.
/// Does not check for clothing.
/datum/controller/subsystem/radiation/proc/can_irradiate_basic(atom/target)
	if (!CAN_IRRADIATE(target))
		return FALSE

	if (HAS_TRAIT(target, TRAIT_IRRADIATED) && !HAS_TRAIT(target, TRAIT_BYPASS_EARLY_IRRADIATED_CHECK))
		return FALSE

	if (HAS_TRAIT(target, TRAIT_RADIMMUNE))
		return FALSE

	return TRUE

/// Retruns a value from 1 (full protection) to 0 (no protection)
/// If we have 4 limbs and 3 are protected, we would expect to have 0.75 returned.
/datum/controller/subsystem/radiation/proc/wearing_rad_protected_clothing(mob/living/carbon/human/human)
	///Check how many limbs we have.
	var/limb_count = 0
	///Check how many of our limbs are protected.
	var/protected_limbs = 0
	for(var/obj/item/organ/external/limb as anything in human.organs)
		limb_count++

		for(var/obj/item/clothing as anything in human.get_clothing_on_part(limb))
			if(HAS_TRAIT(clothing, TRAIT_RADIATION_PROTECTED_CLOTHING)) //If our clothing
				protected_limbs++
				break

			var/rad_resistance = clothing.armor["rad"]
			if(prob(rad_resistance))
				protected_limbs++
				break

	return (protected_limbs/limb_count)
