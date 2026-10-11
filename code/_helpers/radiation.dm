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

/// Calculates the turf line's radiation resistance between two points
/proc/calculate_radiation_insulation(atom/source, atom/target, datum/radiation_pulse_information/pulse_information, list/cached_rad_insulations)
	var/current_insulation = 1
	for (var/turf/turf_in_between in get_line(source, target) - get_turf(source))
		var/insulation = cached_rad_insulations[turf_in_between]
		if (isnull(insulation))
			insulation = turf_in_between.get_rad_insulation()
			for (var/atom/on_turf as anything in turf_in_between.contents)
				insulation *= on_turf.get_rad_insulation()
			cached_rad_insulations[turf_in_between] = insulation

		current_insulation *= insulation

		if (current_insulation <= pulse_information.threshold)
			break
	return current_insulation

/// Calculate the intensity of rads a turf is recieving. Intended for use with RAD_SOLVE_CHANCE() and RAD_SOLVE_MOBRADS() to calculate either the radiation chance or rads recieved by a mob.
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

/// A common proc used to send COMSIG_ATOM_PROPAGATE_RAD_PULSE to adjacent atoms
/// Only used for uranium (false/tram)walls to spread their radiation pulses
/atom/proc/propagate_radiation_pulse()
	for(var/atom/atom in orange(1,src))
		SEND_SIGNAL(atom, COMSIG_ATOM_PROPAGATE_RAD_PULSE, src)

#undef MEDIUM_RADIATION_THRESHOLD_RANGE
#undef EXTREME_RADIATION_CHANCE


/// Debugging radiation can be painful without manually proc-calling radiation pulses. This allows easy custom radiation emitting objects to be placed and tested based on whatever settings are needed.
/obj/rad_tester
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "type-a-red-portal-b"
	name = "Radiation Debugger"
	var/d_strength = 0
	var/d_minimum_exposure_time = 1
	var/d_chance = 0
	var/d_threshold = RAD_EXTREME_INSULATION
	var/d_range = 0

/obj/rad_tester/Initialize(mapload)
	. = ..()
	START_PROCESSING(SSobj, src)

/obj/rad_tester/Destroy()
	STOP_PROCESSING(SSobj, src)
	. = ..()

/obj/rad_tester/process()
	radiation_pulse(
			src,
			max_range = d_range,
			threshold = d_threshold,
			chance = d_chance,
			minimum_exposure_time = d_minimum_exposure_time SECONDS,
			strength = d_strength
		)

/obj/rad_tester/verb/set_range()
	set src in oview(1)
	set category = "Object"
	set name = "Set Radiation Range"
	d_range = tgui_input_number(usr, "Set range of effect", "Range", d_range, min_value=0, round_value=FALSE)

/obj/rad_tester/verb/set_threshold()
	set src in oview(1)
	set category = "Object"
	set name = "Set Radiation Threshold"
	d_threshold = tgui_input_number(usr, "Set penetration threshold of radiation. RAD_NO_INSULATION is [RAD_NO_INSULATION], RAD_FULL_INSULATION is [RAD_FULL_INSULATION], RAD_EXTREME_INSULATION is [RAD_EXTREME_INSULATION]", "Radiation Chance", d_threshold, min_value=0, max_value = 1, round_value=FALSE)

/obj/rad_tester/verb/set_chance()
	set src in oview(1)
	set category = "Object"
	set name = "Set Radiation Chance"
	d_chance = tgui_input_number(usr, "Set probability of radiation exposure", "Radiation Chance", d_chance, min_value=0, max_value=100, round_value=FALSE)

/obj/rad_tester/verb/set_exposure_time()
	set src in oview(1)
	set category = "Object"
	set name = "Set Minimum Exposure Time"
	d_minimum_exposure_time = tgui_input_number(usr, "Set exposure time needed in seconds", "Exposure Time", d_minimum_exposure_time, min_value=0, round_value=FALSE)

/obj/rad_tester/verb/set_strength()
	set src in oview(1)
	set category = "Object"
	set name = "Set Radiation Strength"
	d_strength = tgui_input_number(usr, "Set radiation strength. Uranium sheets have a strength of [/datum/material/uranium::radioactivity], Supermatter sheets have a strength of [/datum/material/supermatter::radioactivity], engines have strengths in the hundreds.", "Strength", d_strength, min_value=0, round_value=FALSE)
