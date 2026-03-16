/*
 * ## DO NOT BRING THIS BACK OR I WILL SMITE YOU
 * This is the precursor to 'do_after'. It was very buggy, allowed spam, and very restrictive at the same time.
 * Pretty much the worst of all worlds.
 * It's been replaced entirely with do_after, now and is just being kept here as a showcase of the old code.
 * The only thing it had different was a target_zone, which is now incorporated into do_after
 *
/proc/do_mob(mob/user , mob/target, time = 30, target_zone = 0, uninterruptible = FALSE, progress = TRUE, ignore_movement = FALSE, exclusive = FALSE)
	if(!user || !target)
		return FALSE
	if(!time)
		return TRUE //Done!
	if(user.status_flags & DOING_TASK)
		to_chat(user, span_warning("You're in the middle of doing something else already."))
		return FALSE //Performing an exclusive do_after or do_mob already
	if(target?.flags & IS_BUSY)
		to_chat(user, span_warning("Someone is already doing something with \the [target]."))
		return FALSE
	var/user_loc = user.loc
	var/target_loc = target.loc

	var/holding = user.get_active_hand()
	var/datum/progressbar/progbar
	if (progress)
		progbar = new(user, time, target)

	var/endtime = world.time+time
	var/starttime = world.time

	if(exclusive & TASK_USER_EXCLUSIVE)
		user.status_flags |= DOING_TASK
	if(target && exclusive & TASK_TARGET_EXCLUSIVE)
		target.flags |= IS_BUSY

	. = TRUE
	while (world.time < endtime)
		stoplag(1)
		if (progress)
			progbar.update(world.time - starttime)
		if(!user || !target)
			. = FALSE
			break
		if(uninterruptible)
			continue

		if(!user || user.incapacitated())
			. = FALSE
			break

		if(user.loc != user_loc && !ignore_movement)
			. = FALSE
			break

		if(target.loc != target_loc && !ignore_movement)
			. = FALSE
			break

		if(user.get_active_hand() != holding)
			. = FALSE
			break

		if(target_zone && user.zone_sel?.selecting != target_zone)
			. = FALSE
			break

	if(exclusive & TASK_USER_EXCLUSIVE)
		user.status_flags &= ~DOING_TASK
	if(exclusive & TASK_TARGET_EXCLUSIVE)
		target?.status_flags &= ~IS_BUSY

	if (progbar)
		qdel(progbar)
