/decl/surgery


/**
 * Proc: operate
 * Attempts to perform the [src] operation on the [target], using [tool] wielded by [user]
 * @param: tool - The surgical implement
 * @param: target - The organ being surgeried
 * @param: user - The surgeon
 * @returns:
 *   - TRUE if the surgery is successfully performed
 *   - FALSE if the surgery fails FOR ANY REASON
 *     (Actual failures handled by [src])
**/

/decl/surgery/proc/operate(var/obj/item/tool, var/obj/item/organ/target, var/mob/living/user)

	
	return TRUE
	





/****************************************************/	
	// Generate the list of options
	var/list/options = get_available_steps(tool)
	// Build the radial menu

	for(var/decl/surgery/S in surgery_steps)
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
					if(istext(qual))
						calc_duration *= src.get_tool_speed(qual)
					else if(ispath(qual))
						calc_duration *= src.tool_qualities[1] // Hack to get around still matching on types

					if(!do_mob(user, M, calc_duration, zone))
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