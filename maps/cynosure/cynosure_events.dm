// Area defines on Cynosure differ from previous maps, so these have to be overriden with map-specific lists.
/datum/event2/event/prison_break/bridge
	area_types_to_break = list(
		/area/surface/station/command/operations,
		/area/surface/station/crew_quarters/captain
	)

/datum/event2/meta/prison_break/xenobio
	irrelevant_areas = list(
		/area/surface/station/rnd/xenobiology/xenoflora,
		/area/surface/station/rnd/xenobiology/xenoflora_isolation
	)

/datum/event2/event/prison_break/xenobio
	area_types_to_break = list(/area/surface/station/rnd/xenobiology)
	area_types_to_ignore = list(
		/area/surface/station/rnd/xenobiology/xenoflora,
		/area/surface/station/rnd/xenobiology/xenoflora_isolation
	)
	ignore_blast_doors = TRUE // Needed to avoid a breach.

/datum/event2/meta/prison_break/brig
	relevant_areas = list(
		/area/surface/station/security/prison,
		/area/surface/station/security/hallway,
		/area/surface/station/security/processing,
		/area/surface/station/security/interrogation
	)

/datum/event2/event/prison_break/brig
	area_types_to_break = list(
		/area/surface/station/security/prison,
		/area/surface/station/security/hallway/cell_hallway,
		/area/surface/station/security/hallway/stairwell,
		/area/surface/station/maintenance/substation/security,
		/area/surface/station/security/lobby,
		/area/surface/station/security/processing,
		/area/surface/station/security/interrogation
	)

/datum/event2/event/prison_break/armory
	area_types_to_break = list(
		/area/surface/station/security/brig,
		/area/surface/station/security/warden,
		/area/surface/station/security/evidence_storage,
		/area/surface/station/security/equiptment_storage,
		/area/surface/station/security/armoury,
		/area/surface/station/security/tactical
	)

/datum/event2/meta/prison_break/virology
	relevant_areas = list(
		/area/surface/station/medical/virology
	)

/datum/event2/event/prison_break/virology
	area_types_to_break = list(
		/area/surface/station/medical/virology,
		/area/surface/station/medical/patient_wing,
		/area/surface/station/medical/office
	)
