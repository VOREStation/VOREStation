// The Station Director's office is specific to the Southern Cross, so this needs to go here.
/datum/event2/event/prison_break/bridge
	area_types_to_break = list(
		/area/bridge,
		/area/bridge_hallway,
		/area/crew_quarters/heads/sc/sd
	)

// So is xenoflora isolation it seems.
/datum/event2/meta/prison_break/xenobio
	irrelevant_areas = list(
		/area/rnd/xenobiology/xenoflora,
		/area/rnd/xenobiology/xenoflora_storage,
		/area/rnd/xenobiology/xenoflora_isolation
	)

/datum/event2/event/prison_break/xenobio
	area_types_to_ignore = list(
		/area/rnd/xenobiology/xenoflora,
		/area/rnd/xenobiology/xenoflora_storage,
		/area/rnd/xenobiology/xenoflora_isolation
	)
	ignore_blast_doors = TRUE // Needed to avoid a breach.