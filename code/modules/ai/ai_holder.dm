// This is a datum-based artificial intelligence for simple mobs (and possibly others) to use.
// The neat thing with having this here instead of on the mob is that it is independant of Life(), and that different mobs
// can use a more or less complex AI by giving it a different datum.
#define AI_NO_PROCESS			0
#define AI_PROCESSING			(1<<0)
#define AI_FASTPROCESSING		(1<<1)

#define START_AIPROCESSING(Datum) if (!(Datum.process_flags & AI_PROCESSING)) {Datum.process_flags |= AI_PROCESSING;SSai.processing += Datum}
#define STOP_AIPROCESSING(Datum) Datum.process_flags &= ~AI_PROCESSING;SSai.processing -= Datum
#define START_AIFASTPROCESSING(Datum) if (!(Datum.process_flags & AI_FASTPROCESSING)) {Datum.process_flags |= AI_FASTPROCESSING;SSaifast.processing += Datum}
#define STOP_AIFASTPROCESSING(Datum) Datum.process_flags &= ~AI_FASTPROCESSING;SSaifast.processing -= Datum

/mob/living
	var/datum/ai_holder/ai_holder = null
	var/ai_holder_type = null // Which ai_holder datum to give to the mob when initialized. If null, nothing happens.

/mob/living/Initialize()
	if(ai_holder_type)
		ai_holder = new ai_holder_type(src)
		if(istype(src, /mob/living/carbon/human))
			var/mob/living/carbon/human/H = src
			H.hud_used = new /datum/hud(H)
			H.create_mob_hud(H.hud_used)
	return ..()

/mob/living/Destroy()
	QDEL_NULL(ai_holder)
	return ..()

/mob/living/Login()
	if(!stat && ai_holder)
		ai_holder.manage_processing(AI_NO_PROCESS)
	return ..()

/mob/living/Logout()
	if(!stat && !key && ai_holder)
		ai_holder.manage_processing(AI_PROCESSING)
	return ..()

/datum/ai_holder
	var/mob/living/holder = null		// The mob this datum is going to control.
	var/stance = STANCE_IDLE			// Determines if the mob should be doing a specific thing, e.g. attacking, following, standing around, etc.
	var/intelligence_level = AI_NORMAL	// Adjust to make the AI be intentionally dumber, or make it more robust (e.g. dodging grenades).
	var/autopilot = FALSE				// If true, the AI won't be deactivated if a client gets attached to the AI's mob.
	var/busy = FALSE					// If true, the ticker will skip processing this mob until this is false. Good for if you need the
										// mob to stay still (e.g. delayed attacking). If you need the mob to be inactive for an extended period of time,
										// consider sleeping the AI instead.
	var/process_flags = 0				// Where we're processing, see flag defines.
	var/list/snapshot = null			// A list used in mass-editing of AI datums, holding a snapshot of the 'before' state
	var/list/static/fastprocess_stances = list(
		STANCE_ALERT,
		STANCE_APPROACH,
		STANCE_FIGHT,
		STANCE_BLINDFIGHT,
		STANCE_REPOSITION,
		STANCE_MOVE,
		STANCE_FOLLOW,
		STANCE_FLEE,
		STANCE_DISABLED
	)
	var/list/static/noprocess_stances = list(
		STANCE_SLEEP
	)


/datum/ai_holder/hostile
	hostile = TRUE

/datum/ai_holder/retaliate
	hostile = TRUE
	retaliate = TRUE

/datum/ai_holder/vv_get_dropdown()
	. = ..()
	if(snapshot)
		VV_DROPDOWN_OPTION("mass_edit_finish", "End Mass Edit")
	else
		VV_DROPDOWN_OPTION("mass_edit_start", "Begin Mass Edit")

/datum/ai_holder/vv_do_topic(list/href_list)
	. = ..()
	IF_VV_OPTION("mass_edit_start")
		if(!check_rights(R_ADMIN))
			return
		if(snapshot)
			to_chat(usr, "<span class='error'>Someone (or you) may have started a mass edit on this AI datum already. Refresh the VV window to get the option to end the mass edit instead.</span>")
			href_list["datumrefresh"] = "\ref[src]"
			return
		snapshot = vars.Copy() //'vars' appears to be special in that vars.Copy produces a flat list of keys with no values. It seems that 'vars[key]' is handled somewhere in the byond engine differently than normal lists.

		// Remove things that may change without admin input during editing. If they aren't present in the snapshot, they aren't eligible for the diff.
		snapshot -= list(
			//other
			"datum_flags",
			"active_timers",
			//main
			"snapshot",
			"stance",
			"process_flags",
			//targeting
			"target",
			"preferred_target",
			"target_last_seen_turf",
			"attackers",
			"lose_target_time",
			//pathfinding
			"path",
			"obstacles",
			"failed_steps",
			//movement
			"destination",
			"failed_breakthroughs",
			"faction_friends",
			//communication
			"threatening",
			"last_conflict_time",
			"last_threaten_time",
			"last_target_time"
		)

		for(var/key in snapshot)
			var/thing = vars[key]
			if(islist(thing)) // This is just too dangerous to do. Maybe in the future we can have a whitelist of lists that are fine to edit.
				thing = null
			snapshot[key] = thing

		VARSET_IN(src, snapshot, null, 2 MINUTES) // Safety
		to_chat(usr, "<span class='notice'>Variable snapshot saved. Begin editing the datum, and end the mass edit from the dropdown menu within 2 minutes. Note that editing the contents of lists is not supported.</span>")
		href_list["datumrefresh"] = "\ref[src]"

	IF_VV_OPTION("mass_edit_finish")
		if(!check_rights(R_ADMIN))
			return

		var/list/before = snapshot //This PROBABLY works, right?
		snapshot = null
		var/list/after = vars.Copy() //'vars' appears to be special in that vars.Copy produces a flat list of keys with no values. It seems that 'vars[key]' is handled somewhere in the byond engine differently than normal lists.
		after &= before //Ignore any dangerous keys. Not a big deal, because just 'before' being safe is enough to exclude the dangerous ones from the diff, but why not
		for(var/key in after)
			var/thing = vars[key]
			if(islist(thing)) // This is just too dangerous to do. Maybe in the future we can have a whitelist of lists that are fine to edit.
				thing = null
			after[key] = thing

		var/list/diff = list()
		for(var/key in before)
			if(before[key] == after[key])
				continue
			diff += key

		if(!diff.len)
			to_chat(usr, "<span class='warning'>You don't appear to have changed anything on the AI datum you were editing.</span>")
			href_list["datumrefresh"] = "\ref[src]"
		else
			var/message = "<span class='notice'>These differences were detected in your varedit. If you notice any that you didn't change, please redo your edit:<br>"
			for(var/key in diff)
				message += "<b>- [key]:</b> [before[key]] => [after[key]]<br>"
			message += "</span>"
			to_chat(usr,message)

		var/original_type = holder.type
		var/list/levels_working = GetConnectedZlevels(holder.z)

		var/list/types = list()
		var/list/split = splittext("[original_type]", "/")
		split -= "" // The first / creates an empty string at the start as it tries to split on [nothing]/mob/living etc
		var/typestring = "/"
		for(var/el in split)
			typestring += el

			types += text2path(typestring)
			typestring += "/"

		var/list/searching = living_mob_list // Started/seeded with this
		var/list/choices = list()
		for(var/typechoice in types)
			var/list/found = list()
			for(var/atom/M as anything in searching) // Isnt't there a helper for this, maybe? I forget.
				if(!(M.z in levels_working))
					continue
				if(!istype(M,typechoice))
					continue
				found += M
			choices["[typechoice] ([found.len])"] = found // Prettified name for the user input below)
			searching = found // Now we only search the list we just made, because of the order of our types list, each subsequent list will be a subset of the one we just finished

		var/choice = tgui_input_list(usr,"Based on your AI holder's mob location, we'll edit mobs on Z [levels_working.Join(",")]. What types do you want to alter?", "Types", choices)
		if(!choice)
			href_list["datumrefresh"] = "\ref[src]"
			return
		var/list/selected = choices[choice]
		for(var/mob/living/L as anything in selected)
			if(!istype(L))
				to_chat(usr,"<span class='warning'>Skipping incompatible mob: [L] [ADMIN_COORDJMP(L)]</span>")
				continue
			if(!L.ai_holder)
				to_chat(usr,"<span class='warning'>Skipping due to no AI: [L] [ADMIN_COORDJMP(L)]</span>")
				continue
			for(var/newvar in diff)
				if(newvar in L.ai_holder.vars)
					L.ai_holder.vars[newvar] = after[newvar]
				else
					to_chat(usr,"<span class='warning'>Skipping unavailable var '[newvar]' on: [L] [ADMIN_COORDJMP(L)]</span>")

		to_chat(usr,"<span class='notice'>Mass AI edit done.</span>")
		href_list["datumrefresh"] = "\ref[src]"

/datum/ai_holder/New(var/new_holder)
	ASSERT(new_holder)
	holder = new_holder
	home_turf = get_turf(holder)
	manage_processing(AI_PROCESSING)
	GLOB.stat_set_event.register(holder, src, .proc/holder_stat_change)
	..()

/datum/ai_holder/Destroy()
	holder = null
	manage_processing(AI_NO_PROCESS)
	home_turf = null
	return ..()

/datum/ai_holder/proc/manage_processing(var/desired)
	if(desired & AI_PROCESSING)
		START_AIPROCESSING(src)
	else
		STOP_AIPROCESSING(src)

	if(desired & AI_FASTPROCESSING)
		START_AIFASTPROCESSING(src)
	else
		STOP_AIFASTPROCESSING(src)

/datum/ai_holder/proc/holder_stat_change(var/mob, old_stat, new_stat)
	if(old_stat >= DEAD && new_stat <= DEAD) //Revived
		manage_processing(AI_PROCESSING)
	else if(old_stat <= DEAD && new_stat >= DEAD) //Killed
		manage_processing(AI_NO_PROCESS)

/datum/ai_holder/proc/update_stance_hud()
	var/image/stanceimage = holder.grab_hud(LIFE_HUD)
	stanceimage.icon_state = "ais_[stance]"
	holder.apply_hud(LIFE_HUD, stanceimage)

/datum/ai_holder/proc/update_paused_hud()
	var/image/sleepingimage = holder.grab_hud(STATUS_HUD)
	var/asleep = 0
	if(busy)
		asleep = 2
	else if (stance == STANCE_SLEEP)
		asleep = 1
	sleepingimage.icon_state = "ai_[asleep]"
	holder.apply_hud(STATUS_HUD, sleepingimage)

// Now for the actual AI stuff.
/datum/ai_holder/proc/set_busy(var/value = 0)
	busy = value
	update_paused_hud()

// Makes this ai holder not get processed.
// Called automatically when the host mob is killed.
// Potential future optimization would be to sleep AIs which mobs that are far away from in-round players.
/datum/ai_holder/proc/go_sleep()
	if(stance == STANCE_SLEEP)
		return
	forget_everything() // If we ever wake up, its really unlikely that our current memory will be of use.
	set_stance(STANCE_SLEEP)
	update_paused_hud()

// Reverses the above proc.
// Revived mobs will wake their AI if they have one.
/datum/ai_holder/proc/go_wake()
	if(stance != STANCE_SLEEP)
		return
	if(!should_wake())
		return
	set_stance(STANCE_IDLE)
	update_paused_hud()

/datum/ai_holder/proc/should_wake()
	if(holder.client && !autopilot)
		return FALSE
	if(holder.stat >= DEAD)
		return FALSE
	return TRUE

// Resets a lot of 'memory' vars.
/datum/ai_holder/proc/forget_everything()
	// Some of these might be redundant, but hopefully this prevents future bugs if that changes.
	lose_follow()
	remove_target()

// 'Tactical' processes such as moving a step, meleeing an enemy, firing a projectile, and other fairly cheap actions that need to happen quickly.
/datum/ai_holder/proc/handle_tactics()
	if(!istype(holder) || QDELETED(holder))
		qdel(src)
		return
	if(holder.key && !autopilot)
		return
	handle_special_tactic()
	handle_stance_tactical()

// 'Strategical' processes that are more expensive on the CPU and so don't get run as often as the above proc, such as A* pathfinding or robust targeting.
/datum/ai_holder/proc/handle_strategicals()
	if(!istype(holder) || QDELETED(holder))
		qdel(src)
		return
	if(holder.key && !autopilot)
		return
	handle_special_strategical()
	handle_stance_strategical()

// Override these for special things without polluting the main loop.
/datum/ai_holder/proc/handle_special_tactic()

/datum/ai_holder/proc/handle_special_strategical()

// For setting the stance WITHOUT processing it
/datum/ai_holder/proc/set_stance(var/new_stance)
	if(holder?.key && !autopilot)
		return
	if(stance == new_stance)
		ai_log("set_stance() : Ignoring change stance to same stance request.", AI_LOG_INFO)
		return

	ai_log("set_stance() : Setting stance from [stance] to [new_stance].", AI_LOG_INFO)
	stance = new_stance
	if(stance_coloring) // For debugging or really weird mobs.
		stance_color()
	update_stance_hud()

	if(new_stance in fastprocess_stances) //Becoming fast
		manage_processing(AI_PROCESSING|AI_FASTPROCESSING)
	else if(new_stance in noprocess_stances)
		manage_processing(AI_NO_PROCESS) //Becoming off
	else
		manage_processing(AI_PROCESSING) //Becoming slow

// This is called every half a second.
/datum/ai_holder/proc/handle_stance_tactical()
	ai_log("========= Fast Process Beginning ==========", AI_LOG_TRACE) // This is to make it easier visually to disinguish between 'blocks' of what a tick did.
	ai_log("handle_stance_tactical() : Called.", AI_LOG_TRACE)

	if(stance == STANCE_SLEEP)
		ai_log("handle_stance_tactical() : Going to sleep.", AI_LOG_TRACE)
		go_sleep()
		return

	if(target && can_see_target(target))
		track_target_position()

	if(stance != STANCE_DISABLED && is_disabled()) // Stunned/confused/etc
		ai_log("handle_stance_tactical() : Disabled.", AI_LOG_TRACE)
		set_stance(STANCE_DISABLED)
		return

	if(stance in STANCES_COMBAT)
		// Should resist?  We check this before fleeing so that we can actually flee and not be trapped in a chair.
		if(holder.incapacitated(INCAPACITATION_BUCKLED_PARTIALLY))
			ai_log("handle_stance_tactical() : Going to handle_resist().", AI_LOG_TRACE)
			handle_resist()

		var/atom/holder_loc = holder.loc
		if(istype(holder_loc, /obj/structure/closet))
			var/obj/structure/closet/C = holder.loc
			ai_log("handle_stance_tactical() : Inside a closet. Going to attempt escape.", AI_LOG_TRACE)
			if(C.sealed)
				holder.resist()
			else
				C.open()
		else if(isbelly(holder_loc))
			ai_log("handle_stance_tactical() : Inside a belly, will move out to turf if owner is stat.", AI_LOG_TRACE)
			var/obj/belly/B = holder_loc
			var/mob/living/L = B.owner
			if(B.owner?.stat)
				var/mob/living/holder = src.holder
				ai_log("handle_stance_tactical() : Owner was stat, moving.", AI_LOG_TRACE)
				holder.forceMove(get_turf(L))
				holder.visible_message("<span class='danger'>[src] climbs out of [L], ready to continue fighting!</span>")
				playsound(holder, 'sound/effects/splat.ogg')

		// Should we flee?
		if(should_flee())
			ai_log("handle_stance_tactical() : Going to flee.", AI_LOG_TRACE)
			set_stance(STANCE_FLEE)
			return

	switch(stance)
		if(STANCE_ALERT)
			ai_log("handle_stance_tactical() : STANCE_ALERT, going to threaten_target().", AI_LOG_TRACE)
			threaten_target()

		if(STANCE_APPROACH)
			ai_log("handle_stance_tactical() : STANCE_APPROACH, going to walk_to_target().", AI_LOG_TRACE)
			walk_to_target()

		if(STANCE_FIGHT)
			ai_log("handle_stance_tactical() : STANCE_FIGHT, going to engage_target().", AI_LOG_TRACE)
			engage_target()

		if(STANCE_MOVE)
			ai_log("handle_stance_tactical() : STANCE_MOVE, going to walk_to_destination().", AI_LOG_TRACE)
			walk_to_destination()

		if(STANCE_REPOSITION) // This is the same as above but doesn't stop if an enemy is visible since its an 'in-combat' move order.
			ai_log("handle_stance_tactical() : STANCE_REPOSITION, going to walk_to_destination().", AI_LOG_TRACE)
			if(!target && !find_target())
				walk_to_destination()

		if(STANCE_FOLLOW)
			ai_log("handle_stance_tactical() : STANCE_FOLLOW, going to walk_to_leader().", AI_LOG_TRACE)
			walk_to_leader()

		if(STANCE_FLEE)
			ai_log("handle_stance_tactical() : STANCE_FLEE, going to flee_from_target().", AI_LOG_TRACE)
			flee_from_target()

		if(STANCE_DISABLED)
			ai_log("handle_stance_tactical() : STANCE_DISABLED.", AI_LOG_TRACE)
			if(!is_disabled())
				ai_log("handle_stance_tactical() : No longer disabled.", AI_LOG_TRACE)
				set_stance(STANCE_IDLE)
			else
				handle_disabled()

	ai_log("handle_stance_tactical() : Exiting.", AI_LOG_TRACE)
	ai_log("========= Fast Process Ending ==========", AI_LOG_TRACE)

// This is called every two seconds.
/datum/ai_holder/proc/handle_stance_strategical()
	ai_log("++++++++++ Slow Process Beginning ++++++++++", AI_LOG_TRACE)
	ai_log("handle_stance_strategical() : Called.", AI_LOG_TRACE)

	//We got left around for some reason. Goodbye cruel world.
	if(!holder)
		qdel(src)

	ai_log("handle_stance_strategical() : LTT=[lose_target_time]", AI_LOG_TRACE)
	if(lose_target_time && (lose_target_time + lose_target_timeout < world.time)) // We were tracking an enemy but they are gone.
		ai_log("handle_stance_strategical() : Giving up a chase.", AI_LOG_DEBUG)
		remove_target()

	if(stance in STANCES_COMBAT)
		request_help() // Call our allies.

	switch(stance)
		if(STANCE_IDLE)
			if(speak_chance) // In the long loop since otherwise it wont shut up.
				handle_idle_speaking()

			if(hostile)
				ai_log("handle_stance_strategical() : STANCE_IDLE, going to find_target().", AI_LOG_TRACE)
				find_target()

			if(should_go_home())
				ai_log("handle_stance_tactical() : STANCE_IDLE, going to go home.", AI_LOG_TRACE)
				go_home()

			else if(should_follow_leader())
				ai_log("handle_stance_tactical() : STANCE_IDLE, going to follow leader.", AI_LOG_TRACE)
				set_stance(STANCE_FOLLOW)

			else if(should_wander())
				ai_log("handle_stance_tactical() : STANCE_IDLE, going to wander randomly.", AI_LOG_TRACE)
				handle_wander_movement()

		if(STANCE_APPROACH)
			if(target)
				ai_log("handle_stance_strategical() : STANCE_APPROACH, going to calculate_path([target]).", AI_LOG_TRACE)
				calculate_path(target)
				walk_to_target()
		if(STANCE_MOVE)
			if(hostile && find_target()) // This will switch its stance.
				ai_log("handle_stance_strategical() : STANCE_MOVE, found target and was inturrupted.", AI_LOG_TRACE)
				return
		if(STANCE_FOLLOW)
			if(hostile && find_target()) // This will switch its stance.
				ai_log("handle_stance_strategical() : STANCE_FOLLOW, found target and was inturrupted.", AI_LOG_TRACE)
				return
			else if(leader)
				ai_log("handle_stance_strategical() : STANCE_FOLLOW, going to calculate_path([leader]).", AI_LOG_TRACE)
				calculate_path(leader)
				walk_to_leader()

	ai_log("handle_stance_strategical() : Exiting.", AI_LOG_TRACE)
	ai_log("++++++++++ Slow Process Ending ++++++++++", AI_LOG_TRACE)


// Helper proc to turn AI 'busy' mode on or off without having to check if there is an AI, to simplify writing code.
/mob/living/proc/set_AI_busy(value)
	if(ai_holder)
		ai_holder.set_busy(value)

/mob/living/proc/is_AI_busy()
	if(!ai_holder)
		return FALSE
	return ai_holder.busy

// Helper proc to check for the AI's stance.
// Returns null if there's no AI holder, or the mob has a player and autopilot is not on.
// Otherwise returns the stance.
/mob/living/proc/get_AI_stance()
	if(!ai_holder)
		return null
	if(client && !ai_holder.autopilot)
		return null
	return ai_holder.stance

// Similar to above but only returns 1 or 0.
/mob/living/proc/has_AI()
	return get_AI_stance() ? TRUE : FALSE

// 'Taunts' the AI into attacking the taunter.
/mob/living/proc/taunt(atom/movable/taunter, force_target_switch = FALSE)
	if(ai_holder)
		ai_holder.receive_taunt(taunter, force_target_switch)

#undef AI_NO_PROCESS
#undef AI_PROCESSING
#undef AI_FASTPROCESSING