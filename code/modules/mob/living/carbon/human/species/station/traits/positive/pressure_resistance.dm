/datum/trait/lowpressureresminor // Same as original trait with cost reduced, much more useful as filler.
	name = "Low Pressure Resistance, Minor"
	desc = "Your body is more resistant to low pressures and you can breathe better in those conditions. Pretty simple."
	cost = 1
	var_changes = list("hazard_low_pressure" = HAZARD_LOW_PRESSURE*0.66, "warning_low_pressure" = WARNING_LOW_PRESSURE*0.66, "minimum_breath_pressure" = 16*0.66)
	excludes = list(/datum/trait/lowpressureresmajor,/datum/trait/pressureres,/datum/trait/pressureresmajor)
	category = TRAIT_TYPE_POSITIVE

/datum/trait/lowpressureresmajor // Still need an oxygen tank, otherwise you'll suffocate.
	name = "Low Pressure Resistance, Major"
	desc = "Your body is immune to low pressures and you can breathe significantly better in low-pressure conditions, though you'll still need an oxygen supply."
	cost = 2
	var_changes = list("hazard_low_pressure" = HAZARD_LOW_PRESSURE*0, "warning_low_pressure" = WARNING_LOW_PRESSURE*0, "minimum_breath_pressure" = 16*0.33)
	excludes = list(/datum/trait/lowpressureresminor,/datum/trait/pressureres,/datum/trait/pressureresmajor)
	category = TRAIT_TYPE_POSITIVE

/datum/trait/highpressureresminor // Increased high pressure cap as previous amount was neglible.
	name = "High Pressure Resistance, Minor"
	desc = "Your body is more resistant to high pressures. Pretty simple."
	cost = 1
	var_changes = list("hazard_high_pressure" = HAZARD_HIGH_PRESSURE*2, "warning_high_pressure" = WARNING_HIGH_PRESSURE*2)
	excludes = list(/datum/trait/highpressureresmajor,/datum/trait/pressureres,/datum/trait/pressureresmajor)
	category = TRAIT_TYPE_POSITIVE

/datum/trait/highpressureresmajor
	name = "High Pressure Resistance, Major"
	desc = "Your body is significantly more resistant to high pressures. Pretty simple."
	cost = 2
	var_changes = list("hazard_high_pressure" = HAZARD_HIGH_PRESSURE*4, "warning_high_pressure" = WARNING_HIGH_PRESSURE*4)
	excludes = list(/datum/trait/highpressureresminor,/datum/trait/pressureres,/datum/trait/pressureresmajor)
	category = TRAIT_TYPE_POSITIVE

/datum/trait/pressureres
	name = "General Pressure Resistance"
	desc = "Your body is much more resistant to both high and low pressures. Pretty simple."
	cost = 3
	var_changes = list("hazard_high_pressure" = HAZARD_HIGH_PRESSURE*3,
					   "warning_high_pressure" = WARNING_HIGH_PRESSURE*3,
					   "hazard_low_pressure" = HAZARD_LOW_PRESSURE*0.33,
					   "warning_low_pressure" = WARNING_LOW_PRESSURE*0.33,
					   "minimum_breath_pressure" = 16*0.33
					   )
	excludes = list(/datum/trait/lowpressureresminor,/datum/trait/lowpressureresmajor,/datum/trait/highpressureresminor,/datum/trait/highpressureresmajor,/datum/trait/pressureresmajor)
	category = TRAIT_TYPE_POSITIVE

/datum/trait/pressureresmajor // If they have the points and want more freedom with atmos, let them.
	name = "General Pressure Resistance, Major"
	desc = "Your body is significantly more resistant to high pressures and immune to low pressures, though you'll still need an oxygen supply."
	cost = 4
	var_changes = list("hazard_high_pressure" = HAZARD_HIGH_PRESSURE*4,
					   "warning_high_pressure" = WARNING_HIGH_PRESSURE*4,
					   "hazard_low_pressure" = HAZARD_LOW_PRESSURE*0,
					   "warning_low_pressure" = WARNING_LOW_PRESSURE*0,
					   "minimum_breath_pressure" = 16*0.33
					   )
	excludes = list(/datum/trait/lowpressureresminor,/datum/trait/lowpressureresmajor,/datum/trait/highpressureresminor,/datum/trait/highpressureresmajor,/datum/trait/pressureres)
	category = TRAIT_TYPE_POSITIVE
