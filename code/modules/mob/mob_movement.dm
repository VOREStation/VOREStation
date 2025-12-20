/mob/proc/setMoveCooldown(var/timeout)
	next_move = max(world.time + timeout, next_move)

/mob/proc/checkMoveCooldown()
	if(world.time < next_move)
		return FALSE // Need to wait more.
	return TRUE

/mob/proc/movement_delay(oldloc, direct)
	. = 0
	if(locate(/obj/item/grab) in src)
		. += 5

	if(lying)
		if(weakened >= 1)
			. += 14			// Very slow when weakened.
		else
			. += 8

	// Movespeed delay based on movement mode
	switch(m_intent)
		if(I_RUN)
			if(drowsyness > 0)
				. += 6
			. += CONFIG_GET(number/run_speed)
		if(I_WALK)
			. += CONFIG_GET(number/walk_speed)

/client/proc/client_dir(input, direction=-1)
	return turn(input, direction*dir2angle(dir))

/client/Northeast()
	diagonal_action(NORTHEAST)
/client/Northwest()
	diagonal_action(NORTHWEST)
/client/Southeast()
	diagonal_action(SOUTHEAST)
/client/Southwest()
	diagonal_action(SOUTHWEST)

/client/proc/diagonal_action(direction)
	switch(client_dir(direction, 1))
		if(NORTHEAST)
			swap_hand()
			return
		if(SOUTHEAST)
			attack_self()
			return
		if(SOUTHWEST)
			if(isliving(usr))
				var/mob/living/carbon/C = usr
				C.toggle_throw_mode()
			else
				to_chat(usr, span_red("This mob type cannot throw items."))
			return
		if(NORTHWEST)
			if(isliving(usr))
				var/mob/living/carbon/C = usr
				if(!C.get_active_hand())
					if(C.pulling)
						C.stop_pulling()
						return
					to_chat(usr, span_red("You have nothing to drop in your hand."))
					return
				drop_item()
			else
				to_chat(usr, span_red("This mob type cannot drop items."))
			return

//This gets called when you press the delete button.
/client/verb/delete_key_pressed()
	set hidden = 1

	if(!usr.pulling)
		to_chat(usr, span_blue("You are not pulling anything."))
		return
	usr.stop_pulling()

/client/verb/swap_hand()
	set hidden = 1
	if(isliving(mob))
		var/mob/living/L = mob
		L.swap_hand()
	if(istype(mob,/mob/living/silicon/robot))
		var/mob/living/silicon/robot/R = mob
		R.cycle_modules()
	return



/client/verb/attack_self()
	set hidden = 1
	if(mob)
		mob.mode()
	return


/client/verb/toggle_throw_mode()
	set hidden = 1
	if(!istype(mob, /mob/living/carbon))
		return
	if (!mob.stat && isturf(mob.loc) && !mob.restrained())
		mob:toggle_throw_mode()
	else
		return


/client/verb/drop_item()
	set hidden = 1
	if(!isrobot(mob) && mob.stat == CONSCIOUS && (isturf(mob.loc) || isbelly(mob.loc)))	// VOREStation Edit: dropping in bellies
		return mob.drop_item()
	return


/client/Center()
	/* No 3D movement in 2D spessman game. dir 16 is Z Up
	if (isobj(mob.loc))
		var/obj/O = mob.loc
		if (mob.canmove)
			return O.relaymove(mob, 16)
	*/
	return

/client/proc/Move_object(direct)
	if(mob && mob.control_object)
		if(mob.control_object.density)
			step(mob.control_object,direct)
			if(!mob.control_object)	return
			mob.control_object.dir = direct
		else
			mob.control_object.forceMove(get_step(mob.control_object,direct))
	return

/**
 * Move a client in a direction
 *
 * Huge proc, has a lot of functionality
 *
 * Mostly it will despatch to the mob that you are the owner of to actually move
 * in the physical realm
 *
 * Things that stop you moving as a mob:
 * * world time being less than your next move_delay
 * * not being in a mob, or that mob not having a loc
 * * missing the n and direction parameters
 * * being in remote control of an object (calls Moveobject instead)
 * * being dead (it ghosts you instead)
 *
 * Things that stop you moving as a mob living (why even have OO if you're just shoving it all
 * in the parent proc with istype checks right?):
 * * having incorporeal_move set (calls Process_Incorpmove() instead)
 * * being grabbed
 * * being buckled  (relaymove() is called to the buckled atom instead)
 * * having your loc be some other mob (relaymove() is called on that mob instead)
 * * Not having MOBILITY_MOVE
 * * Failing Process_Spacemove() call
 *
 * At this point, if the mob is is confused, then a random direction and target turf will be calculated for you to travel to instead
 *
 * Now the parent call is made (to the byond builtin move), which moves you
 *
 * Some final move delay calculations (doubling if you moved diagonally successfully)
 *
 * if mob throwing is set I believe it's unset at this point via a call to finalize
 *
 * Finally if you're pulling an object and it's dense, you are turned 180 after the move
 * (if you ask me, this should be at the top of the move so you don't dance around)
 *
 */
/client/Move(new_loc, direct)
	if(world.time < move_delay) //do not move anything ahead of this check please
		return FALSE
	next_move_dir_add = NONE
	next_move_dir_sub = NONE
	var/old_move_delay = move_delay
	move_delay = world.time + world.tick_lag //this is here because Move() can now be called mutiple times per tick
	if(!direct || !new_loc)
		return FALSE
	if(!mob?.loc)
		return FALSE
	if(HAS_TRAIT(mob, TRAIT_NO_TRANSFORM))
		return FALSE //This is sorta the goto stop mobs from moving trait
	if(!isliving(mob))
		if(SEND_SIGNAL(mob, COMSIG_MOB_CLIENT_PRE_NON_LIVING_MOVE, new_loc, direct) & COMSIG_MOB_CLIENT_BLOCK_PRE_NON_LIVING_MOVE)
			return FALSE
		return mob.Move(new_loc, direct)
	if(mob.stat == DEAD)
		mob.ghostize()
		return FALSE
	if(SEND_SIGNAL(mob, COMSIG_MOB_CLIENT_PRE_LIVING_MOVE, new_loc, direct) & COMSIG_MOB_CLIENT_BLOCK_PRE_LIVING_MOVE)
		return FALSE

	var/mob/living/L = mob //Already checked for isliving earlier
	//if(L.incorporeal_move && !is_secret_level(mob.z)) //Move though walls
	if(L.incorporeal_move) //We do not have the secret level nor ssmapping yet
		Process_Incorpmove(direct)
		return FALSE

	if(mob.remote_control) //we're controlling something, our movement is relayed to it
		return mob.remote_control.relaymove(mob, direct)

	if(isAI(mob))
		var/mob/living/silicon/ai/smoovin_ai = mob
		return smoovin_ai.AIMove(direct)

	if(Process_Grab()) //are we restrained by someone's grip?
		return

	if(mob.buckled) //if we're buckled to something, tell it we moved.
		return mob.buckled.relaymove(mob, direct)

	if(!(L.mobility_flags & MOBILITY_MOVE))
		return FALSE

	if(ismovable(mob.loc)) //Inside an object, tell it we moved
		var/atom/loc_atom = mob.loc
		return loc_atom.relaymove(mob, direct)

	if(!mob.Process_Spacemove(direct))
		SEND_SIGNAL(mob, COMSIG_MOB_CLIENT_MOVE_NOGRAV, args)
		return FALSE

	if(SEND_SIGNAL(mob, COMSIG_MOB_CLIENT_PRE_MOVE, args) & COMSIG_MOB_CLIENT_BLOCK_PRE_MOVE)
		return FALSE

	//We are now going to move
	var/add_delay = mob.cached_multiplicative_slowdown
	var/glide_delay = add_delay
	if(NSCOMPONENT(direct) && EWCOMPONENT(direct))
		glide_delay = FLOOR(glide_delay * sqrt(2), world.tick_lag)
	mob.set_glide_size(DELAY_TO_GLIDE_SIZE(glide_delay)) // set it now in case of pulled objects
	//If the move was recent, count using old_move_delay
	//We want fractional behavior and all
	if(old_move_delay + world.tick_lag > world.time)
		//Yes this makes smooth movement stutter if add_delay is too fractional
		//Yes this is better then the alternative
		move_delay = old_move_delay
	else
		move_delay = world.time

	//Basically an optional override for our glide size
	//Sometimes you want to look like you're moving with a delay you don't actually have yet
	visual_delay = 0
	var/old_dir = mob.dir

	. = ..()

	if((direct & (direct - 1)) && mob.loc == new_loc) //moved diagonally successfully
		add_delay = FLOOR(add_delay * sqrt(2), world.tick_lag)

	var/after_glide = 0
	if(visual_delay)
		after_glide = visual_delay
	else
		after_glide = DELAY_TO_GLIDE_SIZE(add_delay)

	mob.set_glide_size(after_glide)

	move_delay += add_delay
	if(.) // If mob is null here, we deserve the runtime
		if(mob.throwing)
			mob.throwing.finalize(FALSE)

		// At this point we've moved the client's attached mob. This is one of the only ways to guess that a move was done
		// as a result of player input and not because they were pulled or any other magic.
		SEND_SIGNAL(mob, COMSIG_MOB_CLIENT_MOVED, direct, old_dir)

	var/atom/movable/P = mob.pulling
	if(P && !ismob(P) && P.density)
		mob.setDir(REVERSE_DIR(mob.dir))

/**
 * Checks to see if you're being grabbed and if so attempts to break it
 *
 * Called by client/Move()
 */
/client/proc/Process_Grab()
	if(!mob.pulledby)
		return FALSE
	if(mob.pulledby == mob.pulling && mob.pulledby.grab_state == GRAB_PASSIVE) //Don't autoresist passive grabs if we're grabbing them too.
		return FALSE
	if(HAS_TRAIT(mob, TRAIT_INCAPACITATED))
		COOLDOWN_START(src, move_delay, 1 SECONDS)
		return TRUE
	else if(HAS_TRAIT(mob, TRAIT_RESTRAINED))
		COOLDOWN_START(src, move_delay, 1 SECONDS)
		to_chat(src, span_warning("You're restrained! You can't move!"))
		return TRUE
	return mob.resist_grab(TRUE)

/mob/proc/SelfMove(turf/n, direct, movetime)
	return Move(n, direct, movetime)


//Set your incorporeal movespeed
//Important to note: world.time is always in deciseconds. Higher tickrates mean more subdivisions of world.time (20fps = 0.5, 40fps = 0.25)
/client
	var/is_leaving_belly = FALSE
	var/incorporeal_speed = 0.5

/client/verb/set_incorporeal_speed()
	set category = "OOC.Game Settings"
	set name = "Set Incorporeal Speed"

	var/input = tgui_input_number(usr, "Set an incorporeal movement delay between 0 (fastest) and 5 (slowest)", "Incorporeal movement speed", (0.5/world.tick_lag), 5, 0)
	incorporeal_speed = input * world.tick_lag

///Process_Incorpmove
///Called by client/Move()
///Allows mobs to run though walls
/client/proc/Process_Incorpmove(direct)
	if(isbelly(mob.loc) && isobserver(mob))
		if(is_leaving_belly)
			return
		is_leaving_belly = TRUE
		if(tgui_alert(mob, "Do you want to leave your predator's belly?", "Leave belly?", list("Yes", "No")) != "Yes")
			is_leaving_belly = FALSE
			return
		is_leaving_belly = FALSE
	var/turf/mobloc = get_turf(mob)

	if(incorporeal_speed)
		var/mob/my_mob = mob
		if(!my_mob.checkMoveCooldown()) //Only bother with speed if it isn't 0
			return
		my_mob.setMoveCooldown(incorporeal_speed)

	switch(mob.incorporeal_move)
		if(1)
			var/turf/T = get_step(mob, direct)
			if(!T)
				return
			var/area/A = T.loc	//RS Port #658
			if(mob.check_holy(T))
				to_chat(mob, span_warning("You cannot get past holy grounds while you are in this plane of existence!"))
				return
			else if(!istype(mob, /mob/observer/dead) && T.blocks_nonghost_incorporeal)
				return
			//RS Port #658 Start
			if(!check_rights_for(src, R_HOLDER))
				if(isliving(mob) && A.flag_check(AREA_BLOCK_PHASE_SHIFT))
					to_chat(mob, span_warning("Something blocks you from entering this location while phased out."))
					return
				if(isobserver(mob) && A.flag_check(AREA_BLOCK_GHOSTS) && !isbelly(mob.loc))
					to_chat(mob, span_warning("Ghosts can't enter this location."))
					var/area/our_area = mobloc.loc
					if(our_area.flag_check(AREA_BLOCK_GHOSTS) && !isbelly(mob.loc))
						var/mob/observer/dead/D = mob
						D.return_to_spawn()
					return
			mob.forceMove(get_step(mob, direct))
			mob.dir = direct
			//RS Port #658 End
		if(2)
			if(prob(50))
				var/locx
				var/locy
				switch(direct)
					if(NORTH)
						locx = mobloc.x
						locy = (mobloc.y+2)
						if(locy>world.maxy)
							return
					if(SOUTH)
						locx = mobloc.x
						locy = (mobloc.y-2)
						if(locy<1)
							return
					if(EAST)
						locy = mobloc.y
						locx = (mobloc.x+2)
						if(locx>world.maxx)
							return
					if(WEST)
						locy = mobloc.y
						locx = (mobloc.x-2)
						if(locx<1)
							return
					else
						return
				mob.forceMove(locate(locx,locy,mobloc.z))
				spawn(0)
					var/limit = 2//For only two trailing shadows.
					for(var/turf/T in getline(mobloc, mob.loc))
						spawn(0)
							anim(T,mob,'icons/mob/mob.dmi',,"shadow",,mob.dir)
						limit--
						if(limit<=0)	break
			else
				spawn(0)
					anim(mobloc,mob,'icons/mob/mob.dmi',,"shadow",,mob.dir)
				mob.forceMove(get_step(mob, direct))
			mob.dir = direct

	mob.Post_Incorpmove()
	return 1

/mob/proc/Post_Incorpmove()
	return

/mob/proc/get_jetpack()
	return

///Process_Spacemove
///Called by /client/Move()
///For moving in space
///Return 1 for movement 0 for none
/mob/proc/Process_Spacemove(var/check_drift = 0)

	if(is_incorporeal())
		return

	if(!Check_Dense_Object()) //Nothing to push off of so end here
		update_floating(0)
		return 0

	update_floating(1)

	if(restrained()) //Check to see if we can do things
		return 0
	inertia_dir = 0
	return 1

/mob/proc/Check_Dense_Object() //checks for anything to push off in the vicinity. also handles magboots on gravity-less floors tiles

	var/dense_object = 0
	var/shoegrip

	for(var/turf/turf in oview(1,src))
		if(isspace(turf))
			continue

		if(istype(turf,/turf/simulated/floor)) // Floors don't count if they don't have gravity
			var/area/A = turf.loc
			if(istype(A) && A.get_gravity() == 0)
				if(shoegrip == null)
					shoegrip = Check_Shoegrip() //Shoegrip is only ever checked when a zero-gravity floor is encountered to reduce load
				if(!shoegrip)
					continue

		dense_object++
		break

	if(!dense_object && (locate(/obj/structure/lattice) in oview(1, src)))
		dense_object++

	if(!dense_object && (locate(/obj/structure/catwalk) in oview(1, src)))
		dense_object++


	//Lastly attempt to locate any dense objects we could push off of
	//TODO: If we implement objects drifing in space this needs to really push them
	//Due to a few issues only anchored and dense objects will now work.
	if(!dense_object)
		for(var/obj/O in oview(1, src))
			if((O) && (O.density) && (O.anchored))
				dense_object++
				break

	return dense_object

/mob/proc/Check_Shoegrip()
	return 0

/mob/proc/mob_get_gravity(turf/T)
	return get_gravity(src, T)

/mob/proc/update_gravity()
	return

//bodypart selection verbs - Cyberboss
//8: repeated presses toggles through head - eyes - mouth
//7: mouth 8: head  9: eyes
//4: r-arm 5: chest 6: l-arm
//1: r-leg 2: groin 3: l-leg

///Validate the client's mob has a valid zone selected
/client/proc/check_has_body_select()
	return mob && mob.hud_used && istype(mob.zone_sel, /atom/movable/screen/zone_sel)

/**
 * Hidden verbs to set desired body target zone
 *
 * Uses numpad keys 1-9
 */

///Hidden verb to cycle through head zone with repeated presses, head - eyes - mouth. Bound to 8
/client/verb/body_toggle_head()
	set name = "body-toggle-head"
	set hidden = TRUE

	if(!check_has_body_select())
		return

	var/next_in_line
	switch(mob.zone_sel)
		if(BP_HEAD)
			next_in_line = O_EYES
		if(O_EYES)
			next_in_line = O_MOUTH
		else
			next_in_line = BP_HEAD

	var/atom/movable/screen/zone_sel/selector = mob.zone_sel
	selector.set_selected_zone(next_in_line, mob)

///Hidden verb to target the head, unbound by default.
/client/verb/body_head()
	set name = "body-head"
	set hidden = TRUE

	if(!check_has_body_select())
		return

	var/atom/movable/screen/zone_sel/selector = mob.zone_sel
	selector.set_selected_zone(BP_HEAD, mob)

///Hidden verb to target the eyes, bound to 7
/client/verb/body_eyes()
	set name = "body-eyes"
	set hidden = TRUE

	if(!check_has_body_select())
		return

	var/atom/movable/screen/zone_sel/selector = mob.zone_sel
	selector.set_selected_zone(O_EYES, mob)

///Hidden verb to target the mouth, bound to 9
/client/verb/body_mouth()
	set name = "body-mouth"
	set hidden = TRUE

	if(!check_has_body_select())
		return

	var/atom/movable/screen/zone_sel/selector = mob.zone_sel
	selector.set_selected_zone(O_MOUTH, mob)

///Hidden verb to target the right arm, bound to 4
/client/verb/body_r_arm()
	set name = "body-r-arm"
	set hidden = TRUE

	if(!check_has_body_select())
		return

	var/atom/movable/screen/zone_sel/selector = mob.zone_sel
	selector.set_selected_zone(BP_R_ARM, mob)

///Hidden verb to target the chest, bound to 5
/client/verb/body_chest()
	set name = "body-chest"
	set hidden = TRUE

	if(!check_has_body_select())
		return

	var/atom/movable/screen/zone_sel/selector = mob.zone_sel
	selector.set_selected_zone(BP_TORSO, mob)

///Hidden verb to target the left arm, bound to 6
/client/verb/body_l_arm()
	set name = "body-l-arm"
	set hidden = TRUE

	if(!check_has_body_select())
		return

	var/atom/movable/screen/zone_sel/selector = mob.zone_sel
	selector.set_selected_zone(BP_L_ARM, mob)

///Hidden verb to target the right leg, bound to 1
/client/verb/body_r_leg()
	set name = "body-r-leg"
	set hidden = TRUE

	if(!check_has_body_select())
		return

	var/atom/movable/screen/zone_sel/selector = mob.zone_sel
	selector.set_selected_zone(BP_R_LEG, mob)

///Hidden verb to target the groin, bound to 2
/client/verb/body_groin()
	set name = "body-groin"
	set hidden = TRUE

	if(!check_has_body_select())
		return

	var/atom/movable/screen/zone_sel/selector = mob.zone_sel
	selector.set_selected_zone(BP_GROIN, mob)

///Hidden verb to target the left leg, bound to 3
/client/verb/body_l_leg()
	set name = "body-l-leg"
	set hidden = TRUE

	if(!check_has_body_select())
		return

	var/atom/movable/screen/zone_sel/selector = mob.zone_sel
	selector.set_selected_zone(BP_L_LEG, mob)
