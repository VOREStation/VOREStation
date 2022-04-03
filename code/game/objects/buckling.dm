

/atom/movable
	var/can_buckle = FALSE
	var/buckle_movable = 0
	var/buckle_dir = 0
	var/buckle_lying = -1 //bed-like behavior, forces mob.lying = buckle_lying if != -1
	var/buckle_require_restraints = 0 //require people to be handcuffed before being able to buckle. eg: pipes
//	var/mob/living/buckled_mob = null
	var/list/mob/living/buckled_mobs = null //list()
	var/max_buckled_mobs = 1


/atom/movable/attack_hand(mob/living/user)
	. = ..()
//	if(can_buckle && buckled_mob)
//		user_unbuckle_mob(user)

	if(can_buckle && has_buckled_mobs())
		if(buckled_mobs.len > 1)
			var/unbuckled = tgui_input_list(user, "Who do you wish to unbuckle?","Unbuckle Who?", buckled_mobs)
			if(user_unbuckle_mob(unbuckled, user))
				return TRUE
		else
			if(user_unbuckle_mob(buckled_mobs[1], user))
				return TRUE

/obj/proc/attack_alien(mob/user as mob) //For calling in the event of Xenomorph or other alien checks.
	return

/obj/attack_robot(mob/living/user)
	if(Adjacent(user) && has_buckled_mobs()) //Checks if what we're touching is adjacent to us and has someone buckled to it. This should prevent interacting with anti-robot manual valves among other things.
		return attack_hand(user) //Process as if we're a normal person touching the object.
	return ..() //Otherwise, treat this as an AI click like usual.

/atom/movable/MouseDrop_T(mob/living/M, mob/living/user)
	. = ..()
	if(can_buckle && istype(M))
		if(user_buckle_mob(M, user))
			return TRUE

/atom/movable/proc/has_buckled_mobs()
	return LAZYLEN(buckled_mobs)


/atom/movable/proc/buckle_mob(mob/living/M, forced = FALSE, check_loc = TRUE)
	if(check_loc && M.loc != loc)
		return FALSE

	if(!can_buckle_check(M, forced))
		return FALSE

	if(M == src)
		stack_trace("Recursive buckle warning: [M] being buckled to self.")
		return

	M.buckled = src
	M.facing_dir = null
	M.set_dir(buckle_dir ? buckle_dir : dir)
	M.update_canmove()
	M.update_floating( M.Check_Dense_Object() )
//	buckled_mob = M
	buckled_mobs |= M

	//VOREStation Add
	if(riding_datum)
		riding_datum.ridden = src
		riding_datum.handle_vehicle_offsets()
	M.update_water()
	//VOREStation Add End

	post_buckle_mob(M)
	M.throw_alert("buckled", /obj/screen/alert/restrained/buckled, new_master = src)
	return TRUE

/atom/movable/proc/unbuckle_mob(mob/living/buckled_mob, force = FALSE)
	if(!buckled_mob) // If we didn't get told which mob needs to get unbuckled, just assume its the first one on the list.
		if(has_buckled_mobs())
			buckled_mob = buckled_mobs[1]
		else
			return

	if(buckled_mob && buckled_mob.buckled == src)
		. = buckled_mob
		buckled_mob.buckled = null
		buckled_mob.anchored = initial(buckled_mob.anchored)
		buckled_mob.update_canmove()
		buckled_mob.update_floating( buckled_mob.Check_Dense_Object() )
		buckled_mob.clear_alert("buckled")
	//	buckled_mob = null
		buckled_mobs -= buckled_mob

		//VOREStation Add
		buckled_mob.update_water()
		if(riding_datum)
			riding_datum.restore_position(buckled_mob)
			riding_datum.handle_vehicle_offsets() // So the person in back goes to the front.
		//VOREStation Add End
		post_buckle_mob(.)

/atom/movable/proc/unbuckle_all_mobs(force = FALSE)
	if(!has_buckled_mobs())
		return
	for(var/m in buckled_mobs)
		unbuckle_mob(m, force)

//Handle any extras after buckling/unbuckling
//Called on buckle_mob() and unbuckle_mob()
/atom/movable/proc/post_buckle_mob(mob/living/M)
	return

//Wrapper procs that handle sanity and user feedback
/atom/movable/proc/user_buckle_mob(mob/living/M, mob/user, var/forced = FALSE, var/silent = FALSE)
	if(!ticker)
		to_chat(user, "<span class='warning'>You can't buckle anyone in before the game starts.</span>")
		return FALSE // Is this really needed?
	if(!user.Adjacent(M) || user.restrained() || user.stat || istype(user, /mob/living/silicon/pai))
		return FALSE
	if(M in buckled_mobs)
		to_chat(user, "<span class='warning'>\The [M] is already buckled to \the [src].</span>")
		return FALSE
	if(!can_buckle_check(M, forced))
		return FALSE

	add_fingerprint(user)
//	unbuckle_mob()

	//can't buckle unless you share locs so try to move M to the obj.
	if(M.loc != src.loc)
		if(M.Adjacent(src) && user.Adjacent(src))
			M.forceMove(get_turf(src))
	//		step_towards(M, src)

	. = buckle_mob(M, forced)
	playsound(src, 'sound/effects/seatbelt.ogg', 50, 1)
	if(.)
		var/reveal_message = list("buckled_mob" = null, "buckled_to" = null) //VORE EDIT: This being a list and messages existing for the buckle target atom.
		if(!silent)
			if(M == user)
				reveal_message["buckled_mob"] = "<span class='notice'>You come out of hiding and buckle yourself to [src].</span>" //VORE EDIT
				reveal_message["buckled_to"] = "<span class='notice'>You come out of hiding as [M.name] buckles themselves to you.</span>" //VORE EDIT
				M.visible_message(\
					"<span class='notice'>[M.name] buckles themselves to [src].</span>",\
					"<span class='notice'>You buckle yourself to [src].</span>",\
					"<span class='notice'>You hear metal clanking.</span>")
			else
				reveal_message["buckled_mob"] = "<span class='notice'>You are revealed as you are buckled to [src].</span>" //VORE EDIT
				reveal_message["buckled_to"] = "<span class='notice'>You are revealed as [M.name] is buckled to you.</span>" //VORE EDIT
				M.visible_message(\
					"<span class='danger'>[M.name] is buckled to [src] by [user.name]!</span>",\
					"<span class='danger'>You are buckled to [src] by [user.name]!</span>",\
					"<span class='notice'>You hear metal clanking.</span>")

		M.reveal(silent, reveal_message["buckled_mob"]) //Reveal people so they aren't buckled to chairs from behind. //VORE EDIT, list arg instead of simple message var for buckled mob
		//Vore edit start
		var/mob/living/L = src
		if(istype(L))
			L.reveal(silent, reveal_message["buckled_to"])
		//Vore edit end

/atom/movable/proc/user_unbuckle_mob(mob/living/buckled_mob, mob/user)
	var/mob/living/M = unbuckle_mob(buckled_mob)
	playsound(src, 'sound/effects/seatbelt.ogg', 50, 1)
	if(M)
		if(M != user)
			M.visible_message(\
				"<span class='notice'>[M.name] was unbuckled by [user.name]!</span>",\
				"<span class='notice'>You were unbuckled from [src] by [user.name].</span>",\
				"<span class='notice'>You hear metal clanking.</span>")
		else
			M.visible_message(\
				"<span class='notice'>[M.name] unbuckled themselves!</span>",\
				"<span class='notice'>You unbuckle yourself from [src].</span>",\
				"<span class='notice'>You hear metal clanking.</span>")
		add_fingerprint(user)
	return M

/atom/movable/proc/handle_buckled_mob_movement(atom/old_loc, direct, movetime)
	for(var/mob/living/L as anything in buckled_mobs)
		if(!L.Move(loc, direct, movetime))
			L.forceMove(loc, direct, movetime)
			L.last_move = last_move
			L.inertia_dir = last_move

		if(!buckle_dir)
			L.set_dir(dir)
		else
			L.set_dir(buckle_dir)

/atom/movable/proc/can_buckle_check(mob/living/M, forced = FALSE)
	if(!buckled_mobs)
		buckled_mobs = list()

	if(!istype(M))
		return FALSE

	if((!can_buckle && !forced) || M.buckled || M.pinned.len || (buckled_mobs.len >= max_buckled_mobs) || (buckle_require_restraints && !M.restrained()))
		return FALSE

	if(has_buckled_mobs() && buckled_mobs.len >= max_buckled_mobs) //Handles trying to buckle yourself to the chair when someone is on it
		to_chat(M, "<span class='notice'>\The [src] can't buckle anymore people.</span>")
		return FALSE

	return TRUE
