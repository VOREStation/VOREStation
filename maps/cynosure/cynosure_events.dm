// The Station Director's office is specific to the Southern Cross, so this needs to go here.
/datum/event2/event/prison_break/bridge
	area_types_to_break = list(
		/area/surface/station/command/operations,
		/area/surface/station/crew_quarters/captain
	)

// So is xenoflora isolation it seems.
/datum/event2/meta/prison_break/xenobio
	irrelevant_areas = list(
		/area/surface/station/rnd/xenobiology/xenoflora,
		/area/surface/station/rnd/xenobiology/xenoflora_isolation
	)

/datum/event2/event/prison_break/xenobio
	area_types_to_ignore = list(
		/area/surface/station/rnd/xenobiology/xenoflora,
		/area/surface/station/rnd/xenobiology/xenoflora_isolation
	)
	ignore_blast_doors = TRUE // Needed to avoid a breach.