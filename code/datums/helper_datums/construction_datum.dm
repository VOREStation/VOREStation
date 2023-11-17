#define FORWARD -1
#define BACKWARD 1


// As of August 4th, 2018, these datums are only used in Mech construction.
/datum/construction
	var/list/steps
	var/atom/holder
	var/result
	var/list/steps_desc

/datum/construction/New(atom)
	..()
	holder = atom
	if(!holder) //don't want this without a holder
		spawn
			qdel(src)
	set_desc(steps.len)
	return

/datum/construction/proc/next_step()
	steps.len--
	if(!steps.len)
		spawn_result()
	else
		set_desc(steps.len)
	return

/datum/construction/proc/action(var/obj/item/I,mob/user as mob)
	return

/datum/construction/proc/check_step(var/obj/item/I,mob/user as mob) //check last step only
	var/valid_step = is_right_key(I)
	if(valid_step)
		if(custom_action(valid_step, I, user))
			next_step()
			return 1
	return 0

/datum/construction/proc/is_right_key(var/obj/item/I) // returns current step num if I is of the right type.
	var/list/L = steps[steps.len]
	switch(L["key"])
		if(IS_SCREWDRIVER)
			if(I.has_tool_quality(TOOL_SCREWDRIVER))
				return steps.len
		if(IS_CROWBAR)
			if(I.has_tool_quality(TOOL_CROWBAR))
				return steps.len
		if(IS_WIRECUTTER)
			if(I.has_tool_quality(TOOL_WIRECUTTER))
				return steps.len
		if(IS_WRENCH)
			if(I.has_tool_quality(TOOL_WRENCH))
				return steps.len
		if(IS_WELDER)
			if(I.has_tool_quality(IS_WELDER))
				return steps.len

	if(istype(I, L["key"]))
		return steps.len
	return 0

/datum/construction/proc/custom_action(step, I, user)
	return 1

/datum/construction/proc/check_all_steps(var/obj/item/I,mob/user as mob) //check all steps, remove matching one.
	for(var/i=1;i<=steps.len;i++)
		var/list/L = steps[i];
		if(istype(I, L["key"]))
			if(custom_action(i, I, user))
				steps[i]=null;//stupid byond list from list removal...
				listclearnulls(steps);
				if(!steps.len)
					spawn_result()
				return 1
	return 0


/datum/construction/proc/spawn_result()
	if(result)
		new result(get_turf(holder))
		spawn()
			qdel(holder)
	return

/datum/construction/proc/set_desc(index as num)
	var/list/step = steps[index]
	holder.desc = step["desc"]
	return


// Reversible
/datum/construction/reversible
	var/index

/datum/construction/reversible/New(atom)
	..()
	index = steps.len
	return

/datum/construction/reversible/proc/update_index(diff as num)
	index+=diff
	if(index==0)
		spawn_result()
	else
		set_desc(index)
	return

/datum/construction/reversible/is_right_key(var/obj/item/I) // returns index step
	var/list/L = steps[index]

	switch(L["key"])
		if(IS_SCREWDRIVER)
			if(I.has_tool_quality(TOOL_SCREWDRIVER))
				return FORWARD
		if(IS_CROWBAR)
			if(I.has_tool_quality(TOOL_CROWBAR))
				return FORWARD
		if(IS_WIRECUTTER)
			if(I.has_tool_quality(TOOL_WIRECUTTER))
				return FORWARD
		if(IS_WRENCH)
			if(I.has_tool_quality(TOOL_WRENCH))
				return FORWARD
		if(IS_WELDER)
			if(I.has_tool_quality(IS_WELDER))
				return FORWARD

	switch(L["backkey"])
		if(IS_SCREWDRIVER)
			if(I.has_tool_quality(TOOL_SCREWDRIVER))
				return BACKWARD
		if(IS_CROWBAR)
			if(I.has_tool_quality(TOOL_CROWBAR))
				return BACKWARD
		if(IS_WIRECUTTER)
			if(I.has_tool_quality(TOOL_WIRECUTTER))
				return BACKWARD
		if(IS_WRENCH)
			if(I.has_tool_quality(TOOL_WRENCH))
				return BACKWARD
		if(IS_WELDER)
			if(I.has_tool_quality(IS_WELDER))
				return BACKWARD

	if(istype(I, L["key"]))
		return FORWARD //to the first step -> forward
	else if(L["backkey"] && istype(I, L["backkey"]))
		return BACKWARD //to the last step -> backwards
	return 0

/datum/construction/reversible/check_step(var/obj/item/I,mob/user as mob)
	var/diff = is_right_key(I)
	if(diff)
		if(custom_action(index, diff, I, user))
			update_index(diff)
			return 1
	return 0

/datum/construction/reversible/custom_action(index, diff, I, user)
	return 1