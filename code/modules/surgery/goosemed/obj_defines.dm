/**
 * Proc: try_surgery
 * Attempts to initiate the next surgery step for the targeted organ, using [src]
 * It will open up a radial menu that the user selects a surgery step from
 * @param M: the target mob OR the target organ (Just lying on the ground)
 * @param user: the mob holding [src]
 * @return: True if surgery steps are possible OR surgery is in progress, False otherwise
**/
/obj/item/proc/try_surgery(mob/living/human/M, mob/living/user)
	if(user.a_intent == I_HURT)	//check for Hippocratic Oath
		return FALSE

	var/obj/item/organ/O = null
	if(istype(M))
		var/zone = user.zone_sel.selecting
	 	O = M.get_organ(zone)
		// They don't have an organ to operate on
		if(!istype(O))
			to_chat(user, span("warning", "They don't seem to have that...")
			return TRUE
	else if(istype(M, /obj/item/organ))
		O = M
	else
		return FALSE

	// If surgery is already in progress on that organ, cancel
	if(O.busy)
		to_chat(user, span("warning", "Someone is already operating on this!</span>"))
		return TRUE
	
	return O.do_surgery(tool, user)