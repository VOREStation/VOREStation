/datum/component/infective
	dupe_mode = COMPONENT_DUPE_ALLOWED
	var/list/datum/disease/diseases
	var/expire_time
	var/required_clean_types = CLEAN_TYPE_DISEASE

/datum/component/infective/Initialize(list/datum/disease/_diseases, expire_in)
	if(islist(_diseases))
		diseases = _diseases
	else
		diseases = list(_diseases)
	if(!diseases.len || isnull(diseases[1]))
		stack_trace("Infective component initialized without any diseases!")
		qdel(src)
	if(expire_in)
		expire_time = world.time + expire_in
		QDEL_IN(src, expire_in)
	if(!ismovable(parent))
		return COMPONENT_INCOMPATIBLE

	var/static/list/disease_connections = list(
		COMSIG_ATOM_ENTERED = PROC_REF(try_infect_crossed),
	)
	AddComponent(/datum/component/connect_loc_behalf, parent, disease_connections)

	RegisterSignal(parent, COMSIG_COMPONENT_CLEAN_ACT, PROC_REF(clean))
	RegisterSignal(parent, COMSIG_MOVABLE_BUMP, PROC_REF(try_infect_collide))

	RegisterSignal(parent, COMSIG_ATOM_EXTRAPOLATOR_ACT, PROC_REF(extrapolation))

	if(isitem(parent))
		RegisterSignal(parent, COMSIG_ITEM_ATTACK, PROC_REF(try_infect_attack))
		// RegisterSignal(parent, COMSIG_FOOD_EATEN, PROC_REF(try_infect_eat)) - TODO: Send signal when eating

/datum/component/infective/proc/clean(datum/source, clean_types)
	SIGNAL_HANDLER

	if(clean_types & required_clean_types)
		qdel(src)
		return TRUE

/datum/component/infective/proc/try_infect_crossed(datum/source, atom/movable/arrived, atom/old_loc, list/atom/old_locs)
	SIGNAL_HANDLER

	if(isliving(arrived))
		try_infect(arrived, BP_L_FOOT)

/*
/datum/component/proc/try_infect_eat(datum/source, mob/living/eater, mob/living/feeder)
	SIGNAL_HANDLER

	for(var/datum/disease/D in diseases)
		eater.ForceContractDisease(D)
	try_infect(feeder, BP_L_ARM)
*/

/datum/component/infective/proc/try_infect_collide(datum/source, atom/A)
	SIGNAL_HANDLER

	var/atom/movable/P = parent
	if(P.throwing)
		// This will be handled by COMSIG_MOVABLE_IMPACT_ZONE, whenever we get that.
		return
	if(isliving(A))
		try_infect(A)

/datum/component/infective/proc/try_infect_attack(datum/source, mob/living/target, mob/living/user)
	SIGNAL_HANDLER

	if(!iscarbon(target))
		try_infect(target)
	try_infect(user, BP_L_ARM)

/datum/component/infective/proc/try_infect(mob/living/L, target_zone)
	for(var/datum/disease/D in diseases)
		L.ContractDisease(D)

/datum/component/infective/proc/extrapolation(datum/source, mob/user, obj/item/extrapolator/extrapolator, dry_run = FALSE, list/result)
	SIGNAL_HANDLER
	EXTRAPOLATOR_ACT_ADD_DISEASES(result, diseases)
