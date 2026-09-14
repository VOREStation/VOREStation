/// Whether or not it's possible for this atom to be irradiated
#define CAN_IRRADIATE(atom) (ismob(##atom))

/// Calculates the max chance for a radiation_pulse via a radioactive reagent
#define CALCULATE_RAD_MAX_CHANCE(rad_power) (20 + (15 * (rad_power - 1)))

/// Sends out a pulse of radiation, eminating from the source.
/// Radiation is performed by collecting all radiatables within the max range (0 means source only, 1 means adjacent, etc),
/// then makes their way towards them. A number, starting at 1, is multiplied
/// by the insulation amounts of whatever is in the way (for example, walls lowering it down).
/// If this number hits equal or below the threshold, then the target can no longer be irradiated.
/// If the number is above the threshold, then the chance is the chance that the target will be irradiated.
/// As a consumer, this means that max_range going up usually means you want to lower the threshold too,
/// as well as the other way around.
/// If max_range is high, but threshold is too high, then it usually won't reach the source at the max range in time.
/// If max_range is low, but threshold is too low, then it basically guarantees everyone nearby, even if there's walls
/// and such in the way, can be irradiated.
/// You can also pass in a minimum exposure time. If this is set, then this radiation pulse
/// will not irradiate the source unless they have been around *any* radioactive source for that
/// period of time.
/// The chance to get irradiated diminishes over range, and from objects that block radiation.
/// Assuming there is nothing in the way, the chance will determine what the chance is to get irradiated from half of max_range.
/// Example: If chance is equal to 30%, and max_range is equal to 8,
/// then the chance for a thing to get irradiated is 30% if they are 4 turfs away from the pulse source.
/// Also, strength is how much radiation the target will get if they fail their RNG check / linger for too long.
/proc/radiation_pulse(
	atom/source,
	max_range,
	threshold,
	chance = DEFAULT_RADIATION_CHANCE,
	minimum_exposure_time = 0,
	strength = 100
)
	if(!SSradiation.can_fire)
		return

	var/datum/radiation_pulse_information/pulse_information = new
	pulse_information.source_ref = WEAKREF(source)
	pulse_information.max_range = max_range
	pulse_information.threshold = threshold
	pulse_information.chance = chance
	pulse_information.minimum_exposure_time = minimum_exposure_time
	pulse_information.turfs_to_process = RANGE_TURFS(max_range, source)
	pulse_information.strength = strength

	SSradiation.processing += pulse_information

	return TRUE

/datum/radiation_pulse_information
	var/datum/weakref/source_ref
	var/max_range
	var/threshold
	var/chance
	var/minimum_exposure_time
	var/list/turfs_to_process
	var/strength

/datum/radiation_pulse_information/Destroy(force)
	. = ..()
	source_ref = null

#define MEDIUM_RADIATION_THRESHOLD_RANGE 0.5
#define EXTREME_RADIATION_CHANCE 30

/proc/calculate_recieved_radiation_intensity(datum/radiation_pulse_information/pulse_information, distance, current_insulation)
	var/intensity = 0
	// Intensity variable which will describe the radiation pulse.
	// It is used by perceived intensity, which diminishes over range. The chance of the target getting irradiated is determined by perceived_intensity.
	// Intensity is calculated so that the chance of getting irradiated at half of the max range is the same as the chance parameter.
	intensity = -log(1 - min(0.99999, pulse_information.chance / 100)) * (1 + pulse_information.max_range / 2) ** 2
	// Diminishes over range. Used by perceived chance, which is the actual chance to get irradiated.
	var/perceived_intensity = intensity * INVERSE((1 + distance) ** 2) // Diminishes over range.
	perceived_intensity *= (current_insulation - pulse_information.threshold) * INVERSE(1 - pulse_information.threshold) // Perceived intensity decreases as objects that absorb radiation block its trajectory.
	return perceived_intensity

/// Gets the ACTUAL "danger" of radiation pulse based on the remaining strength of the pulse by the time it hits the target.
/proc/get_perceived_radiation_danger(atom/target, datum/radiation_pulse_information/pulse_information, insulation_to_target, pre_calculated_intensity = null)
	var/atom/source = pulse_information.source_ref?.resolve()
	if(QDELETED(source) || QDELETED(target))
		return null

	// We could get irradiated! The only thing stopping us now is chance. Show how intensely we'd get irradiated if we do!
	var/recieved_intensity = pre_calculated_intensity
	if(isnull(recieved_intensity))
		recieved_intensity = FLOOR(pulse_information.strength * RAD_SOLVE_STRENGTH_MOD(calculate_recieved_radiation_intensity(pulse_information, get_dist_euclidean(get_turf(source), get_turf(target)), insulation_to_target)), RAD_ROUNDING_THRESHOLD)

	// Based off the old rad scale pre-rework
	switch(recieved_intensity)
		if(-INFINITY to RAD_LEVEL_LOW)
			return null
		if(RAD_LEVEL_LOW to RAD_LEVEL_MODERATE)
			return PERCEIVED_RADIATION_DANGER_LOW
		if(RAD_LEVEL_MODERATE to RAD_LEVEL_HIGH)
			return PERCEIVED_RADIATION_DANGER_MEDIUM
		if(RAD_LEVEL_HIGH to RAD_LEVEL_VERY_HIGH)
			return PERCEIVED_RADIATION_DANGER_HIGH
		if(RAD_LEVEL_VERY_HIGH to INFINITY)
			return PERCEIVED_RADIATION_DANGER_EXTREME

/// A common proc used to send COMSIG_ATOM_PROPAGATE_RAD_PULSE to adjacent atoms
/// Only used for uranium (false/tram)walls to spread their radiation pulses
/atom/proc/propagate_radiation_pulse()
	for(var/atom/atom in orange(1,src))
		SEND_SIGNAL(atom, COMSIG_ATOM_PROPAGATE_RAD_PULSE, src)

#undef MEDIUM_RADIATION_THRESHOLD_RANGE
#undef EXTREME_RADIATION_CHANCE
