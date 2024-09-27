/* SURGERY STEPS */

/obj/
	var/surgery_odds = 0 // Used for tables/etc which can have surgery done of them.

/datum/surgery_step
	var/priority = 0	//steps with higher priority would be attempted first

	var/req_open = 1	//1 means the part must be cut open, 0 means it doesn't

	// type path referencing tools that can be used for this step, and how well are they suited for it
	var/list/allowed_tools = null

	// List of procs that can be called if allowed_tools fails
	var/list/allowed_procs = null

	// type paths referencing races that this step applies to.
	var/list/allowed_species = null
	var/list/disallowed_species = null

	// duration of the step
	var/min_duration = 0
	var/max_duration = 0

	// evil infection stuff that will make everyone hate me
	var/can_infect = 0
	// How much blood this step can get on surgeon. 1 - hands, 2 - full body.
	var/blood_level = 0
	// What the surgery will be called in the rare event of multiple surgery steps being shown to the user.
	var/surgery_name = "CONTACT A DEVELOPER TO NAME THIS STEP."
	// If the surgery stops you from being able to perform another surgery.
	var/list/excludes_steps = list()


//returns how well tool is suited for this step
/datum/surgery_step/proc/tool_quality(obj/item/tool)
	for (var/T in allowed_tools)
		if (istype(tool,T))
			return allowed_tools[T]

	for(var/P in allowed_procs)
		switch(P)
			if(IS_SCREWDRIVER)
				if(tool.has_tool_quality(TOOL_SCREWDRIVER))
					return allowed_procs[P]
			if(IS_CROWBAR)
				if(tool.has_tool_quality(TOOL_CROWBAR))
					return allowed_procs[P]
			if(IS_WIRECUTTER)
				if(tool.has_tool_quality(TOOL_WIRECUTTER))
					return allowed_procs[P]
			if(IS_WRENCH)
				if(tool.has_tool_quality(TOOL_WRENCH))
					return allowed_procs[P]
	return 0


// Checks if this step applies to the user mob at all
/datum/surgery_step/proc/is_valid_target(mob/living/carbon/human/target)
	if(!hasorgans(target))
		return 0

	if(allowed_species)
		for(var/species in allowed_species)
			if(target.species.get_bodytype() == species)
				return 1

	if(disallowed_species)
		for(var/species in disallowed_species)
			if(target.species.get_bodytype() == species)
				return 0

	return 1

// Let's check if stuff blocks us from doing surgery on them
// TODO: make it based on area coverage rather than just forbid spacesuits?
// Returns true if target organ is covered
/datum/surgery_step/proc/coverage_check(mob/living/user, mob/living/carbon/human/target, obj/item/organ/external/affected, obj/item/tool)
	if(!affected)
		return FALSE

	if(affected.organ_tag == BP_HEAD)
		if(target.head && istype(target.head,/obj/item/clothing/head/helmet/space))
			return TRUE
	else
		if(target.wear_suit && istype(target.wear_suit,/obj/item/clothing/suit/space))
			return TRUE

	return FALSE

// checks whether this step can be applied with the given user and target
/datum/surgery_step/proc/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	return 0

// does stuff to begin the step, usually just printing messages. Moved germs transfering and bloodying here too
/datum/surgery_step/proc/begin_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if (can_infect && affected)
		spread_germs_to_organ(affected, user)
	if (ishuman(user) && prob(60))
		var/mob/living/carbon/human/H = user
		if (blood_level)
			H.bloody_hands(target,0)
		if (blood_level > 1)
			H.bloody_body(target,0)
	return

// does stuff to end the step, which is normally print a message + do whatever this step changes
/datum/surgery_step/proc/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	return

// stuff that happens when the step fails
/datum/surgery_step/proc/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	return null



/proc/spread_germs_to_organ(var/obj/item/organ/external/E, var/mob/living/carbon/human/user)
	if(!istype(user) || !istype(E)) return

	var/germ_level = user.germ_level
	if(user.gloves)
		germ_level = user.gloves.germ_level

	E.germ_level = max(germ_level,E.germ_level) //as funny as scrubbing microbes out with clean gloves is - no.


/obj/item/proc/can_do_surgery(mob/living/carbon/M, mob/living/user)
//	if(M == user)
//		return 0
	if(!ishuman(M))
		return 1

	return 1

/obj/item/proc/do_surgery(mob/living/carbon/M, mob/living/user)
	if(!can_do_surgery(M, user))
		return 0
	if(!istype(M))
		return 0
	if (user.a_intent == I_HURT)	//check for Hippocratic Oath
		//Insert intentional hurt medical code here.
		return 0
	var/zone = user.zone_sel.selecting
	if(zone in M.op_stage.in_progress) //Can't operate on someone repeatedly.
		to_chat(user, "<span class='warning'>You can't operate on this area while surgery is already in progress.</span>")
		return 1
	var/obj/surface = M.get_surgery_surface(user)
	if(!surface || !surface.surgery_odds) 	// If the surface has a chance of 0% surgery odds (ground), don't even bother trying to do surgery.
		return 0 							// This is meant to prevent the 'glass shard mouth 60 damage click' exploit. Also saves CPU by doing it here!

	var/list/datum/surgery_step/available_surgeries = list()
	for(var/datum/surgery_step/S in surgery_steps)
		//check if tool is right or close enough and if this step is possible
		if(S.tool_quality(src))
			var/step_is_valid = S.can_use(user, M, zone, src)
			if(step_is_valid && S.is_valid_target(M))
				if(step_is_valid == SURGERY_FAILURE)
					continue
				available_surgeries[S.surgery_name] = S //Adds the surgery name to the list and sets it equal to S. (Ex: "Cauterize" = surgery_step/cauterize)
			continue

	if(!available_surgeries.len) //No available surgeries. Failure.
		return 0

	// Having trouble with an ASSOSCIATED LIST? or REMOVING SOMETHING FROM AN ASSOCIATED LIST? Look here for a quick guide, developed out of frustration.
	// Note: This is an ultra edge case. Like, what is being done here is horrible and is so rare this should never happen again in the code.
	// This block of code caused hours of suffering.

	for(var/surgical_check_name in available_surgeries) 												// Get the name from available_surgeries. available_surgeries = list("NAME" = DATUM)
		var/datum/surgery_step/surgical_check = available_surgeries[surgical_check_name] 				// We then get the datum.
		if(isnull(surgical_check)) 																		// This is here so it doesn't try to keep searching if the thing we're about to check has been deleted.
			continue
		if(surgical_check.excludes_steps.len)															// We check for it's 'excluded_steps' list and see if it has anything in it.
			for(var/removal_candidate_name in available_surgeries) 										// We then look in available_surgeries once again, grabbing the name.
				var/datum/surgery_step/removal_candidate = available_surgeries[removal_candidate_name] 	// We then get the datum while searching.
				if(is_path_in_list(removal_candidate.type, surgical_check.excludes_steps))				// We then check the datum and see if it's a path in the list that we want to remove.
					available_surgeries -= removal_candidate_name										// We then, finally, remove the surgery step.
																										// All of this just to make it so you are forced to do bloodless surgery with a laser scalpel.

	if(M == user)	// Once we determine if we can actually do a step at all, give a slight delay to self-surgery to confirm attempts.
		to_chat(user, "<span class='critical'>You focus on attempting to perform surgery upon yourself.</span>")
		if(!do_after(user, 3 SECONDS, M))
			return 0

	var/datum/surgery_step/selected_surgery
	if(available_surgeries.len > 1) //More than one possible? Ask them which one.
		selected_surgery = tgui_input_list(user, "Select which surgery step you wish to perform", "Surgery Select", available_surgeries) //Shows the name in the list.
	else
		selected_surgery = pick(available_surgeries)

	if(isnull(selected_surgery)) //They clicked 'cancel'
		return 1
	selected_surgery = available_surgeries[selected_surgery] //Sets the name they selected to be the datum.
	// VOREstation edit start
	if(istype(selected_surgery,/datum/surgery_step/generic/amputate))
		var/obj/item/organ/external/affected = M.get_organ(zone)
		to_chat(user, "<span class='danger'>You are preparing to amputate \the [M]'s [affected.name]!</span>")
		if(!do_after(user, 3 SECONDS, M))
			to_chat(user, "<span class='warning'>You reconsider performing an amputation...</span>")
			return 0
	// VOREstation edit end
	M.op_stage.in_progress += zone
	selected_surgery.begin_step(user, M, zone, src)		//start on it
	var/success = TRUE

	// Bad tools make it less likely to succeed.
	if(!prob(selected_surgery.tool_quality(src)))
		success = FALSE

	// Bad surface may mean failure as well.
	if(!prob(surface.surgery_odds))
		success = FALSE

	// Not staying still fails you too.
	if(success)
		var/calc_duration = rand(selected_surgery.min_duration, selected_surgery.max_duration)
		if(!do_mob(user, M, calc_duration * toolspeed, zone, exclusive = TRUE))
			success = FALSE
			to_chat(user, "<span class='warning'>You must remain close to and keep focused on your patient to conduct surgery.</span>")

	if(success)
		selected_surgery.end_step(user, M, zone, src)
	else
		selected_surgery.fail_step(user, M, zone, src)
		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN) //Gets rid of instakill mechanics.

	M.op_stage.in_progress -= zone 									// Clear the in-progress flag.
	if (ishuman(M))
		var/mob/living/carbon/human/H = M
		H.update_surgery()
	return	1	  												//don't want to do weapony things after surgery

/proc/sort_surgeries()
	var/gap = surgery_steps.len
	var/swapped = 1
	while (gap > 1 || swapped)
		swapped = 0
		if(gap > 1)
			gap = round(gap / 1.247330950103979)
		if(gap < 1)
			gap = 1
		for(var/i = 1; gap + i <= surgery_steps.len; i++)
			var/datum/surgery_step/l = surgery_steps[i]		//Fucking hate
			var/datum/surgery_step/r = surgery_steps[gap+i]	//how lists work here
			if(l.priority < r.priority)
				surgery_steps.Swap(i, gap + i)
				swapped = 1

/datum/surgery_status/
	var/eyes	=	0
	var/face	=	0
	var/brainstem = 0
	var/head_reattach = 0
	var/current_organ = "organ"
	var/list/in_progress = list()
