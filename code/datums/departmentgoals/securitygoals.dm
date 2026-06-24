/datum/goal/security
	category = GOAL_SECURITY


// Forensics samples
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/datum/goal/security/forensics_samples
	name = "Collect Forensics Samples"

/datum/goal/security/forensics_samples/New()
	. = ..()
	goal_count = rand(25,50)
	goal_text = "Collect [goal_count] samples using the detective's forensics tools."
	RegisterSignal(SSdcs,COMSIG_GLOB_FORENSICS_COLLECTED,PROC_REF(handle_forensic_collection))

/datum/goal/security/forensics_samples/Destroy(force)
	UnregisterSignal(SSdcs,COMSIG_GLOB_FORENSICS_COLLECTED)
	. = ..()

/datum/goal/security/forensics_samples/proc/handle_forensic_collection(atom/source, atom/target, mob/user)
	SIGNAL_HANDLER
	current_count++
