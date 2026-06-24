/datum/goal/medical
	category = GOAL_MEDICAL


// Autopsies
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/datum/goal/medical/autopsies
	name = "Perform Autopsies"
	var/list/scanned_mobs = list() // List of mob NAMES scanned, no refs here

/datum/goal/medical/autopsies/New()
	. = ..()
	goal_count = rand(15,30)
	goal_text = "Perform at least [goal_count] autopsies on deceased monkeys or crew to train medical skills or determine cause of death."
	RegisterSignal(SSdcs,COMSIG_GLOB_AUTOPSY_PERFORMED,PROC_REF(handle_autopsy_perform))

/datum/goal/medical/autopsies/Destroy(force)
	UnregisterSignal(SSdcs,COMSIG_GLOB_AUTOPSY_PERFORMED)
	. = ..()

/datum/goal/medical/autopsies/check_completion()
	current_count = scanned_mobs.len
	. = ..()

/datum/goal/medical/autopsies/proc/handle_autopsy_perform(atom/source, mob/user, mob/target)
	SIGNAL_HANDLER
	if(!target?.dna?.real_name) // Should never happen unless somethings broken horribly
		return
	if(target.dna.real_name in scanned_mobs)
		return
	scanned_mobs += target.dna.real_name
