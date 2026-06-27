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

// Cure Advanced Diseases
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/datum/goal/medical/virology
	name = "Cure Diseases"
	var/list/cured_diseases = list()

/datum/goal/medical/virology/New()
	. = ..()
	goal_count = rand(10, 20)
	goal_text = "Ensure the galaxy doesn't suffer from a variety of advanced diseases, obtain the cure for [goal_count] of them."
	RegisterSignal(SSdcs, COMSIG_GLOB_ADV_DISEASE_CURED, PROC_REF(handle_disease_cure))

/datum/goal/medical/virology/Destroy(force)
	UnregisterSignal(SSdcs, COMSIG_GLOB_ADV_DISEASE_CURED)
	. = ..()

/datum/goal/medical/virology/check_completion()
	current_count = cured_diseases.len
	. = ..()

/datum/goal/medical/virology/proc/handle_disease_cure(atom/source, id)
	SIGNAL_HANDLER
	if(id in cured_diseases)
		return
	cured_diseases += id

// Donate Blood
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/datum/goal/medical/blood
	name = "Donate Blood"

/datum/goal/medical/blood/New()
	. = ..()
	goal_count = rand(700, 1200)
	goal_text = "Make sure Medical stays well stocked, donate [goal_count] units of blood."
	RegisterSignal(SSdcs, COMSIG_GLOB_DONATE_BLOOD, PROC_REF(handle_donate_blood))

/datum/goal/medical/blood/Destroy(force)
	UnregisterSignal(SSdcs, COMSIG_GLOB_DONATE_BLOOD)
	. = ..()

/datum/goal/medical/blood/proc/handle_donate_blood(atom/source, blood_count)
	SIGNAL_HANDLER
	current_count += blood_count
