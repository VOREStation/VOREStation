GLOBAL_LIST_INIT(diseases, subtypesof(/datum/disease))

/datum/disease
	//Flags
	var/visibility_flags = 0
	var/disease_flags = CURABLE|CAN_CARRY|CAN_RESIST
	var/spread_flags = AIRBORNE

	//Fluff
	/// Used for identification of viruses in the Medical Records Virus Database
	var/medical_name
	var/form = "Virus"
	var/name = "No disease"
	var/desc = ""
	var/agent = "some microbes"
	var/spread_text = ""
	var/cure_text = ""

	//Stages
	var/stage = 1
	var/max_stages = 0
	var/stage_prob = 4
	/// The fraction of stages the virus must at least be at to show up on medical HUDs. Rounded up.
	var/discovery_threshold = 0.5
	/// If TRUE, this virus will show up on medical HUDs. Automatically set when it reaches mid-stage.
	var/discovered = FALSE

	// Other
	var/list/viable_mobtypes = list()
	var/mob/living/carbon/affected_mob
	var/list/cures = list()
	var/infectivity = 65
	var/cure_chance = 8
	var/carrier = FALSE
	var/bypasses_immunity = FALSE
	var/virus_heal_resistant = FALSE
	var/permeability_mod = 1
	var/severity = NONTHREAT
	var/list/required_organs = list()
	var/needs_all_cures = TRUE
	var/list/strain_data = list()
	var/allow_dead = FALSE
	var/infect_synthetics = FALSE
	var/processing = FALSE

/datum/disease/Destroy()
	affected_mob = null
	active_diseases.Remove(src)
	if(processing)
		End()
	return ..()

/datum/disease/proc/stage_act()
	if(!affected_mob)
		return FALSE
	var/cure = has_cure()

	if(carrier && !cure)
		return FALSE

	if(!processing)
		processing = TRUE
		Start()

	stage = min(stage, max_stages)

	handle_stage_advance(cure)

	return handle_cure_testing(cure)

/datum/disease/proc/handle_stage_advance(has_cure = FALSE)
	if(!has_cure && prob(stage_prob))
		stage = min(stage + 1, max_stages)
		if(!discovered && stage >= CEILING(max_stages * discovery_threshold, 1))
			discovered = TRUE

/datum/disease/proc/handle_cure_testing(has_cure = FALSE)
	if(has_cure && prob(cure_chance))
		stage = max(stage -1, 1)

	for(var/organ in required_organs)
		if(locate(organ) in affected_mob.internal_organs)
			continue
		if(locate(organ) in affected_mob.organs)
			continue
		cure()
		return FALSE

	if(disease_flags & CURABLE)
		if(has_cure && prob(cure_chance))
			cure()
			return FALSE
	return TRUE

/datum/disease/proc/has_cure()
	if(!(disease_flags & CURABLE))
		return 0

	var/cures_found = 0
	for(var/C_id in cures)
		if(affected_mob.bloodstr.has_reagent(C_id) || affected_mob.ingested.has_reagent(C_id))
			cures_found++

	if(needs_all_cures && cures_found < length(cures))
		return FALSE

	return cures_found

/datum/disease/proc/spread(force_spread = 0)
	if(!affected_mob)
		return

	if((spread_flags & SPECIAL || spread_flags & NON_CONTAGIOUS || spread_flags & BLOOD) && !force_spread)
		return

	if(affected_mob.bloodstr.has_reagent(REAGENT_ID_SPACEACILLIN) || (affected_mob.nutrition > 300 && prob(affected_mob.nutrition/50)))
		return

	var/spread_range = 1

	if(force_spread)
		spread_range = force_spread

	if(spread_flags & AIRBORNE)
		spread_range++

	var/turf/target = affected_mob.loc
	if(istype(target))
		for(var/mob/living/carbon/human/C in oview(spread_range, affected_mob))
			var/turf/current = get_turf(C)
			if(current)
				while(TRUE)
					if(current == target)
						C.ContractDisease(src)
						break
					var/direction = get_dir(current, target)
					var/turf/next = get_step(current, direction)
					if(!current.CanZASPass(next))
						break
					current = next

/datum/disease/proc/cure()
	if(affected_mob)
		if(disease_flags & CAN_RESIST)
			if(!(type in affected_mob.GetResistances()))
				affected_mob.resistances += type
		remove_virus()
	qdel(src)

/datum/disease/proc/IsSame(datum/disease/D)
	if(ispath(D))
		return istype(src, D)
	return istype(src, D.type)

/datum/disease/proc/Copy()
	var/datum/disease/D = new type()
	D.strain_data = strain_data.Copy()
	return D

/datum/disease/proc/GetDiseaseID()
	return type

/datum/disease/proc/IsSpreadByTouch()
	if(spread_flags & CONTACT_FEET || spread_flags & CONTACT_HANDS || spread_flags & CONTACT_GENERAL)
		return TRUE
	return FALSE

/datum/disease/proc/IsSpreadByAir()
	if(spread_flags & AIRBORNE)
		return TRUE
	return FALSE

/datum/disease/proc/remove_virus()
	affected_mob.viruses -= src

/datum/disease/proc/Start()
	return

/datum/disease/proc/End()
	return
