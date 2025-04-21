GLOBAL_LIST_INIT(diseases, subtypesof(/datum/disease))

/datum/disease
	//Flags
	var/visibility_flags = 0
	var/disease_flags = CURABLE|CAN_CARRY|CAN_RESIST
	var/spread_flags = DISEASE_SPREAD_AIRBORNE
	var/virus_modifiers = NEEDS_ALL_CURES

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

	// Other
	var/list/viable_mobtypes = list()
	var/mob/living/carbon/affected_mob
	var/list/cures = list()
	var/infectivity = 10
	var/cure_chance = 8
	var/spreading_modifier = 1
	var/permeability_mod = 1
	var/danger = DISEASE_MINOR
	var/list/required_organs = list()
	var/list/strain_data = list()

/datum/disease/Destroy()
	affected_mob = null
	GLOB.active_diseases.Remove(src)
	if(global_flag_check(virus_modifiers, PROCESSING))
		End()
	return ..()

/datum/disease/proc/stage_act()
	if(!affected_mob)
		return FALSE
	var/cure = has_cure()

	if(global_flag_check(virus_modifiers, CARRIER) && !cure)
		return FALSE

	if(!global_flag_check(virus_modifiers, PROCESSING))
		virus_modifiers |= PROCESSING
		Start()

	stage = min(stage, max_stages)

	handle_stage_advance(cure)

	return handle_cure_testing(cure)

/datum/disease/proc/handle_stage_advance(has_cure = FALSE)
	if(!has_cure && prob(stage_prob))
		stage = min(stage + 1, max_stages)
		if(!global_flag_check(virus_modifiers, DISCOVERED) && stage >= CEILING(max_stages * discovery_threshold, 1))
			virus_modifiers |= DISCOVERED

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

	if(global_flag_check(virus_modifiers, NEEDS_ALL_CURES) && cures_found < length(cures))
		return FALSE

	return cures_found

/datum/disease/proc/spread(var/force_spread = 0)
	if(!affected_mob)
		return
	if(affected_mob.is_incorporeal())
		return

	if(!(spread_flags & DISEASE_SPREAD_AIRBORNE) && !force_spread)
		return

	if(affected_mob.stat == DEAD && !global_flag_check(virus_modifiers, SPREAD_DEAD) && !force_spread)
		return

	if(affected_mob.reagents.has_reagent(REAGENT_ID_SPACEACILLIN) || (affected_mob.nutrition > 300 && prob(affected_mob.nutrition/50)))
		return

	var/spread_range = 2

	if(force_spread)
		spread_range = force_spread

	if(spread_flags & DISEASE_SPREAD_AIRBORNE)
		spread_range++

	var/turf/target = affected_mob.loc
	if(istype(target))
		for(var/mob/living/carbon/human/C in oview(spread_range, affected_mob))
			if(C.is_incorporeal())
				continue
			var/turf/current = get_turf(C)
			if(disease_air_spread_walk(target, current))
				C.AirborneContractDisease(src, force_spread)

/proc/disease_air_spread_walk(turf/start, turf/end)
	if(!start || !end)
		return FALSE
	while(TRUE)
		if(end == start)
			return TRUE
		var/turf/Temp = get_step_towards(end, start)
		if(!end.CanZASPass(Temp))
			return FALSE
		end = Temp

/datum/disease/proc/cure()
	if(affected_mob)
		if(disease_flags & CAN_RESIST)
			if(!(type in affected_mob.GetResistances()))
				affected_mob.AddResistances(type)
		remove_virus()
	qdel(src)

/datum/disease/proc/start_cure_timer()
	if(global_flag_check(virus_modifiers, HAS_TIMER))
		return
	if(!(disease_flags & CURABLE))
		return
	virus_modifiers |= HAS_TIMER
	addtimer(CALLBACK(src, PROC_REF(check_natural_immunity)), (1 HOUR) + rand( -20 MINUTES, 30 MINUTES), TIMER_DELETE_ME)

/datum/disease/proc/check_natural_immunity()
	if(!(disease_flags & CURABLE))
		return
	if(prob(rand(10, 15)))
		virus_modifiers &= ~HAS_TIMER
		cure()
		return
	addtimer(CALLBACK(src, PROC_REF(check_natural_immunity)), rand(5 MINUTES, 10 MINUTES), TIMER_DELETE_ME)

/datum/disease/proc/IsSame(datum/disease/D)
	if(ispath(D))
		return istype(src, D)
	return istype(src, D.type)

/datum/disease/proc/Copy()
	var/datum/disease/D = new type()
	D.strain_data = strain_data.Copy()
	return D

/datum/disease/proc/GetDiseaseID()
	return

/datum/disease/proc/IsSpreadByBlood()
	if(spread_flags & DISEASE_SPREAD_BLOOD)
		return TRUE
	return FALSE

/datum/disease/proc/IsSpreadByFluids()
	if(spread_flags & DISEASE_SPREAD_FLUIDS)
		return TRUE
	return FALSE

/datum/disease/proc/IsSpreadByTouch()
	if(spread_flags & DISEASE_SPREAD_CONTACT)
		return TRUE
	return FALSE

/datum/disease/proc/IsSpreadByAir()
	if(spread_flags & DISEASE_SPREAD_AIRBORNE)
		return TRUE
	return FALSE

/datum/disease/proc/remove_virus()
	affected_mob.RemoveDisease(src)

// Called when a disease is added onto a mob
/datum/disease/proc/Start()
	return

// Called when a disease is removed from a mob
/datum/disease/proc/End()
	return

// Called when the mob dies
/datum/disease/proc/OnDeath()
	return
