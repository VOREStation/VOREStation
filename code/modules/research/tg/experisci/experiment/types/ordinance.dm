/datum/experiment/ordnance
	name = "Explosives Research"
	description = "An experiment conducted in the phoronics subdepartment."
	exp_tag = EXPERIMENT_TAG_ORDINANCE
	performance_hint = "Perform research using explosive devices."
	allowed_experimentors = list(/obj/machinery/doppler_array)
	var/required_devastation_range = 0
	var/required_heavy_impact_range = 0
	var/required_light_impact_range = 0
	var/explosion_criteria_met = FALSE

/datum/experiment/ordnance/is_complete()
	return explosion_criteria_met

/datum/experiment/ordnance/check_progress()
	var/status_message = "Detonate an explosive of sufficient size and detect it with a doppler array."
	. += EXPERIMENT_PROG_BOOL(status_message, is_complete())

/datum/experiment/ordnance/actionable(datum/component/experiment_handler/experiment_handler)
	return !is_complete()

/datum/experiment/ordnance/perform_experiment_actions(datum/component/experiment_handler/experiment_handler, turf/epicenter, devastation_range, heavy_impact_range, light_impact_range, seconds_taken)
	if(devastation_range < required_devastation_range)
		return FALSE
	if(heavy_impact_range < required_heavy_impact_range)
		return FALSE
	if(light_impact_range < required_light_impact_range)
		return FALSE
	explosion_criteria_met = TRUE
	return TRUE
