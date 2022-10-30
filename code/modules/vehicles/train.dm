/obj/vehicle/train
	name = "train"
	dir = 4

	move_delay = 1

	health = 100
	maxhealth = 100
	fire_dam_coeff = 0.7
	brute_dam_coeff = 0.5

	var/passenger_allowed = 1

	var/active_engines = 0
	var/train_length = 0
	var/latch_on_start = 1

	var/obj/vehicle/train/lead
	var/obj/vehicle/train/tow

	var/open_top = TRUE

//-------------------------------------------
// Standard procs
//-------------------------------------------
/obj/vehicle/train/Initialize()
	. = ..()
	for(var/obj/vehicle/train/T in orange(1, src))
		if(latch_on_start)
			latch(T, null)

/obj/vehicle/train/Move()
	var/old_loc = get_turf(src)
	if((. = ..()))
		if(tow)
			tow.Move(old_loc)
	else if(lead)
		unattach()

/obj/vehicle/train/Bump(atom/Obstacle)
	if(!istype(Obstacle, /atom/movable))
		return
	var/atom/movable/A = Obstacle

	if(!A.anchored)
		var/turf/T = get_step(A, dir)
		if(isturf(T))
			A.Move(T)	//bump things away when hit

	if(emagged)
		if(istype(A, /mob/living))
			var/mob/living/M = A
			visible_message("<font color='red'>[src] knocks over [M]!</font>")
			M.apply_effects(5, 5)				//knock people down if you hit them
			M.apply_damages(22 / move_delay)	// and do damage according to how fast the train is going
			if(istype(load, /mob/living/carbon/human))
				var/mob/living/D = load
				to_chat(D, "<font color='red'>You hit [M]!</font>")
				add_attack_logs(D,M,"Ran over with [src.name]")

//trains are commonly open topped, so there is a chance the projectile will hit the mob riding the train instead
/obj/vehicle/train/bullet_act(var/obj/item/projectile/Proj)
	if(has_buckled_mobs() && prob(70))
		var/mob/living/L = pick(buckled_mobs)
		L.bullet_act(Proj)
		return
	..()

/obj/vehicle/train/update_icon()
	if(open)
		icon_state = initial(icon_state) + "_open"
	else
		icon_state = initial(icon_state)

//-------------------------------------------
// Vehicle procs
//-------------------------------------------
/obj/vehicle/train/explode()
	if (tow)
		tow.unattach()
	unattach()
	..()


//-------------------------------------------
// Interaction procs
//-------------------------------------------
/obj/vehicle/train/relaymove(mob/user, direction)
	var/turf/T = get_step_to(src, get_step(src, direction))
	if(!T)
		to_chat(user, "You can't find a clear area to step onto.")
		return 0

	if(user != load)
		if(user in src)		//for handling players stuck in src - this shouldn't happen - but just in case it does
			user.forceMove(T)
			return 1
		return 0

	unload(user, direction)

	to_chat(user, "<font color='blue'>You climb down from [src].</font>")

	return 1

/obj/vehicle/train/MouseDrop_T(var/atom/movable/C, mob/user as mob)
	if(user.buckled || user.stat || user.restrained() || !Adjacent(user) || !user.Adjacent(C) || !istype(C) || (user == C && !user.canmove))
		return
	if(istype(C,/obj/vehicle/train))
		latch(C, user)
	else
		if(!load(C, user))
			to_chat(user, "<font color='red'>You were unable to load [C] on [src].</font>")

/obj/vehicle/train/attack_hand(mob/user as mob)
	if(user.stat || user.restrained() || !Adjacent(user))
		return 0

	if(user != load && (user in src))
		user.forceMove(loc)			//for handling players stuck in src
	else if(load)
		unload(user)			//unload if loaded
	else if(!load && !user.buckled)
		load(user, user)				//else try climbing on board
	else
		return 0

/obj/vehicle/train/verb/unlatch_v()
	set name = "Unlatch"
	set desc = "Unhitches this train from the one in front of it."
	set category = "Vehicle"
	set src in view(1)

	if(!istype(usr, /mob/living/carbon/human))
		return

	if(!usr.canmove || usr.stat || usr.restrained() || !Adjacent(usr))
		return

	unattach(usr)


//-------------------------------------------
// Latching/unlatching procs
//-------------------------------------------

//attempts to attach src as a follower of the train T
//Note: there is a modified version of this in code\modules\vehicles\cargo_train.dm specifically for cargo train engines
/obj/vehicle/train/proc/attach_to(obj/vehicle/train/T, mob/user)
	if (get_dist(src, T) > 1)
		if(user)
			to_chat(user, "<font color='red'>[src] is too far away from [T] to hitch them together.</font>")
		return

	if (lead)
		if(user)
			to_chat(user, "<font color='red'>[src] is already hitched to something.</font>")
		return

	if (T.tow)
		if(user)
			to_chat(user, "<font color='red'>[T] is already towing something.</font>")
		return

	//check for cycles.
	var/obj/vehicle/train/next_car = T
	while (next_car)
		if (next_car == src)
			if(user)
				to_chat(user, "<font color='red'>That seems very silly.</font>")
			return
		next_car = next_car.lead

	//latch with src as the follower
	lead = T
	T.tow = src
	set_dir(lead.dir)

	if(user)
		to_chat(user, "<font color='blue'>You hitch [src] to [T].</font>")

	update_stats()


//detaches the train from whatever is towing it
/obj/vehicle/train/proc/unattach(mob/user)
	if (!lead)
		to_chat(user, "<font color='red'>[src] is not hitched to anything.</font>")
		return

	lead.tow = null
	lead.update_stats()

	to_chat(user, "<font color='blue'>You unhitch [src] from [lead].</font>")
	lead = null

	update_stats()

/obj/vehicle/train/proc/latch(obj/vehicle/train/T, mob/user)
	if(!istype(T) || !Adjacent(T))
		return 0

	var/T_dir = get_dir(src, T)	//figure out where T is wrt src

	if(dir == T_dir) 	//if car is ahead
		src.attach_to(T, user)
	else if(reverse_direction(dir) == T_dir)	//else if car is behind
		T.attach_to(src, user)

//returns 1 if this is the lead car of the train
/obj/vehicle/train/proc/is_train_head()
	if (lead)
		return 0
	return 1

//-------------------------------------------------------
// Stat update procs
//
// Used for updating the stats for how long the train is.
// These are useful for calculating speed based on the
// size of the train, to limit super long trains.
//-------------------------------------------------------
/obj/vehicle/train/update_stats()
	//first, seek to the end of the train
	var/obj/vehicle/train/T = src
	while(T.tow)
		//check for cyclic train.
		if (T.tow == src)
			lead.tow = null
			lead.update_stats()

			lead = null
			update_stats()
			return
		T = T.tow

	//now walk back to the front.
	var/active_engines = 0
	var/train_length = 0
	while(T)
		train_length++
		if (T.powered && T.on)
			active_engines++
		T.update_car(train_length, active_engines)
		T = T.lead

/obj/vehicle/train/proc/update_car(var/train_length, var/active_engines)
	return
