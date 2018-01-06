

/atom/movable
	var/can_buckle = 0
	var/buckle_movable = 0
	var/buckle_dir = 0
	var/buckle_lying = -1 //bed-like behavior, forces mob.lying = buckle_lying if != -1
	var/buckle_require_restraints = 0 //require people to be handcuffed before being able to buckle. eg: pipes
	var/mob/living/buckled_mob = null


/atom/movable/attack_hand(mob/living/user)
	. = ..()
	if(can_buckle && buckled_mob)
		user_unbuckle_mob(user)

/obj/proc/attack_alien(mob/user as mob) //For calling in the event of Xenomorph or other alien checks.
	return

/obj/attack_robot(mob/living/user)
	if(Adjacent(user) && buckled_mob) //Checks if what we're touching is adjacent to us and has someone buckled to it. This should prevent interacting with anti-robot manual valves among other things.
		return attack_hand(user) //Process as if we're a normal person touching the object.
	return ..() //Otherwise, treat this as an AI click like usual.

/atom/movable/MouseDrop_T(mob/living/M, mob/living/user)
	. = ..()
	if(can_buckle && istype(M))
		user_buckle_mob(M, user)

/atom/movable/Destroy()
	unbuckle_mob()
	return ..()


/atom/movable/proc/buckle_mob(mob/living/M, forced = FALSE, check_loc = TRUE)
	if((!can_buckle && !forced) || !istype(M) || M.buckled || M.pinned.len || (buckle_require_restraints && !M.restrained()))
		return 0
	if(check_loc && M.loc != loc)
		return 0
	if(buckled_mob) //Handles trying to buckle yourself to the chair when someone is on it
		M  << "<span class='notice'>\The [src] already has someone buckled to it.</span>"
		return 0

	M.buckled = src
	M.facing_dir = null
	M.set_dir(buckle_dir ? buckle_dir : dir)
	M.update_canmove()
	M.update_floating( M.Check_Dense_Object() )
	buckled_mob = M

	post_buckle_mob(M)
	return 1

/atom/movable/proc/unbuckle_mob()
	if(buckled_mob && buckled_mob.buckled == src)
		. = buckled_mob
		buckled_mob.buckled = null
		buckled_mob.anchored = initial(buckled_mob.anchored)
		buckled_mob.update_canmove()
		buckled_mob.update_floating( buckled_mob.Check_Dense_Object() )
		buckled_mob = null

		post_buckle_mob(.)

/atom/movable/proc/post_buckle_mob(mob/living/M)
	return

/atom/movable/proc/user_buckle_mob(mob/living/M, mob/user, var/forced = FALSE, var/silent = FALSE)
	if(!ticker)
		user << "<span class='warning'>You can't buckle anyone in before the game starts.</span>"
	if(!user.Adjacent(M) || user.restrained() || user.stat || istype(user, /mob/living/silicon/pai))
		return
	if(M == buckled_mob)
		return

	add_fingerprint(user)
	unbuckle_mob()

	//can't buckle unless you share locs so try to move M to the obj.
	if(M.loc != src.loc)
		step_towards(M, src)

	. = buckle_mob(M, forced)
	if(.)
		if(!silent)
			if(M == user)
				M.visible_message(\
					"<span class='notice'>[M.name] buckles themselves to [src].</span>",\
					"<span class='notice'>You buckle yourself to [src].</span>",\
					"<span class='notice'>You hear metal clanking.</span>")
			else
				M.visible_message(\
					"<span class='danger'>[M.name] is buckled to [src] by [user.name]!</span>",\
					"<span class='danger'>You are buckled to [src] by [user.name]!</span>",\
					"<span class='notice'>You hear metal clanking.</span>")

/atom/movable/proc/user_unbuckle_mob(mob/user)
	var/mob/living/M = unbuckle_mob()
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

/atom/movable/proc/handle_buckled_mob_movement(newloc,direct)
	if(buckled_mob)
//		if(!buckled_mob.Move(newloc, direct))
		if(!buckled_mob.forceMove(newloc, direct))
			loc = buckled_mob.loc
			last_move = buckled_mob.last_move
			buckled_mob.inertia_dir = last_move
			return FALSE
		else
			buckled_mob.set_dir(dir)
	return TRUE

/atom/movable/Move(atom/newloc, direct = 0)
	. = ..()
	if(. && buckled_mob && !handle_buckled_mob_movement(newloc, direct)) //movement failed due to buckled mob(s)
		. = 0
