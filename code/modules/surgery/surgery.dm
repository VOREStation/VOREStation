/* SURGERY STEPS */

/obj/
	var/surgery_odds = 0 // Used for tables/etc which can have surgery done of them.

/decl/surgery_step
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
	//How much blood this step can get on surgeon. 1 - hands, 2 - full body.
	var/blood_level = 0

//returns how well tool is suited for this step
/decl/surgery_step/proc/tool_quality(obj/item/tool)
	if(!tool)
		return 0
	if(tool.type in allowed_tools)
		return allowed_tools[tool.type]

	for(var/P in allowed_procs)
		if(tool.get_tool_quality(P))
			return allowed_procs[P]
	return 0


// Checks if this step applies to the user mob at all
/decl/surgery_step/proc/is_valid_target(mob/living/carbon/human/target)
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
/decl/surgery_step/proc/coverage_check(mob/living/user, mob/living/carbon/human/target, obj/item/organ/external/affected, obj/item/tool)
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
/decl/surgery_step/proc/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	return 0

// does stuff to begin the step, usually just printing messages. Moved germs transfering and bloodying here too
/decl/surgery_step/proc/begin_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
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
/decl/surgery_step/proc/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	return

// stuff that happens when the step fails
/decl/surgery_step/proc/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	return null

/proc/spread_germs_to_organ(var/obj/item/organ/external/E, var/mob/living/carbon/human/user)
	if(!istype(user) || !istype(E)) return

	var/germ_level = user.germ_level
	if(user.gloves)
		germ_level = user.gloves.germ_level

	E.germ_level = max(germ_level,E.germ_level) //as funny as scrubbing microbes out with clean gloves is - no.

/obj/item/proc/do_surgery(mob/living/carbon/M, mob/living/user)
	if(!istype(M))
		return FALSE
	if (user.a_intent == I_HURT)	//check for Hippocratic Oath
		return FALSE
	var/zone = user.zone_sel.selecting
	if(zone in M.op_stage.in_progress) //Can't operate on someone repeatedly.
		to_chat(user, "<span class='warning'>You can't operate on this area while surgery is already in progress.</span>")
		return TRUE

	for(var/decl/surgery_step/S in surgery_steps)
		//check if tool is right or close enough and if this step is possible
		var/qual = S.tool_quality(src)
		if(qual)
			var/step_is_valid = S.can_use(user, M, zone, src)
			if(step_is_valid && S.is_valid_target(M))

				if(M == user)	// Once we determine if we can actually do a step at all, give a slight delay to self-surgery to confirm attempts.
					to_chat(user, "<span class='critical'>You focus on attempting to perform surgery upon yourself.</span>")

					if(!do_after(user, 3 SECONDS, M))
						return FALSE

				if(step_is_valid == SURGERY_FAILURE) // This is a failure that already has a message for failing.
					return TRUE
				M.op_stage.in_progress += zone
				S.begin_step(user, M, zone, src)		//start on it
				var/success = TRUE

				// Bad tools make it less likely to succeed.
				//if(!prob(S.tool_chance(src)))
				if((ispath(qual) && !prob(S.allowed_tools[qual])) || \
						(istext(qual) && !prob(S.allowed_procs[qual])))
					success = FALSE

				// Bad or no surface may mean failure as well.
				var/obj/surface = M.get_surgery_surface(user)
				if(!surface || !prob(surface.surgery_odds))
					success = FALSE

				// Not staying still fails you too.
				if(success)
					var/calc_duration = rand(S.min_duration, S.max_duration)
<<<<<<< HEAD
					if(!do_mob(user, M, calc_duration * toolspeed, zone, exclusive = TRUE))
=======
					if(istext(qual))
						calc_duration *= src.get_tool_speed(qual)
					else if(ispath(qual))
						calc_duration *= src.tool_qualities[1] // Hack to get around still matching on types

					if(!do_mob(user, M, calc_duration, zone))
>>>>>>> d3ef2db8b43... Merge pull request #8384 from Atermonera/cynosure_map
						success = FALSE
						to_chat(user, "<span class='warning'>You must remain close to and keep focused on your patient to conduct surgery.</span>")

				if(success)
					S.end_step(user, M, zone, src)
				else
					S.fail_step(user, M, zone, src)

				M.op_stage.in_progress -= zone 									// Clear the in-progress flag.
				if (ishuman(M))
					var/mob/living/carbon/human/H = M
					H.update_surgery()
				return	TRUE  												//don't want to do weapony things after surgery
	return FALSE

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
			var/decl/surgery_step/l = surgery_steps[i]		//Fucking hate
			var/decl/surgery_step/r = surgery_steps[gap+i]	//how lists work here
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