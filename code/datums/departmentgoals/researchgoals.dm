/datum/goal/research
	category = GOAL_RESEARCH


// Extract artifacts
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/datum/goal/research/extract_artifacts
	name = "Extract Artifact Powers"

/datum/goal/research/extract_artifacts/New()
	. = ..()
	goal_count = rand(35,50)
	goal_text = "Extract the powers of [goal_count] artifacts to prove RnD's overblown budget is needed."
	RegisterSignal(SSdcs,COMSIG_GLOB_HARVEST_ARTIFACT,PROC_REF(handle_artifact_harvest))

/datum/goal/research/extract_artifacts/Destroy(force)
	UnregisterSignal(SSdcs,COMSIG_GLOB_HARVEST_ARTIFACT)
	. = ..()

/datum/goal/research/extract_artifacts/proc/handle_artifact_harvest(atom/source, obj/item/anobattery/inserted_battery, mob/user)
	SIGNAL_HANDLER
	current_count++


// Extract slimes
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/datum/goal/research/extract_slime_cores
	name = "Extract Slime Cores"

/datum/goal/research/extract_slime_cores/New()
	. = ..()
	goal_count = rand(50,100)
	goal_text = "Extract the cores of [goal_count] slimes, regardless of type."
	RegisterSignal(SSdcs,COMSIG_GLOB_HARVEST_SLIME_CORE,PROC_REF(handle_slime_harvest))

/datum/goal/research/extract_slime_cores/Destroy(force)
	UnregisterSignal(SSdcs,COMSIG_GLOB_HARVEST_SLIME_CORE)
	. = ..()

/datum/goal/research/extract_slime_cores/proc/handle_slime_harvest(atom/source)
	SIGNAL_HANDLER
	current_count++


// Build Mechs
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/datum/goal/research/build_mechs
	name = "Construct Mechs"

/datum/goal/research/build_mechs/New()
	. = ..()
	goal_count = rand(10,20)
	goal_text = "Flex the RnD budget and produce [goal_count] mechs of any type."
	RegisterSignal(SSdcs,COMSIG_GLOB_MECH_CONSTRUCTED,PROC_REF(handle_mech_construction))

/datum/goal/research/build_mechs/Destroy(force)
	UnregisterSignal(SSdcs,COMSIG_GLOB_MECH_CONSTRUCTED)
	. = ..()

/datum/goal/research/build_mechs/proc/handle_mech_construction(atom/source)
	SIGNAL_HANDLER
	current_count++
