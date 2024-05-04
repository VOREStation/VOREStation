
/mob/living/handle_fall(var/turf/landing)
	var/mob/drop_mob = locate(/mob/living, landing)

	if(locate(/obj/structure/stairs) in landing)
		for(var/atom/A in landing)
			if(!A.CanPass(src, src.loc, 1, 0))
				return FALSE
		Move(landing)
		if(isliving(src))
			var/mob/living/L = src
			if(L.pulling)
				L.pulling.forceMove(landing)
		return 1

	for(var/obj/O in loc)
		if(!O.CanFallThru(src, landing))
			return 1

	if(drop_mob && !(drop_mob == src)) //Shitload of checks. This is because the game finds various ways to screw me over.
		var/mob/living/drop_living = drop_mob
		if(drop_living.dropped_onto(src))
			return

	// Then call parent to have us actually fall
	return ..()
/mob/CheckFall(var/atom/movable/falling_atom)
	return falling_atom.fall_impact(src)

/mob/living/proc/dropped_onto(var/atom/hit_atom)
	if(!isliving(hit_atom))
		return 0

	var/mob/living/pred = hit_atom
	var/safe_fall = FALSE
	if(pred.softfall || (istype(pred, /mob/living/simple_mob) && pred.mob_size <= MOB_SMALL))		// TODO: add ability for mob below to be 'soft' and cushion fall
		safe_fall = TRUE

	if(istype(pred, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = pred
		if(H.species.soft_landing)
			safe_fall = TRUE

	var/mob/living/prey = src
	var/fallloc = prey.loc
	if(pred.vore_selected && pred.can_be_drop_pred && prey.can_be_drop_prey && pred.drop_vore && prey.drop_vore)
		pred.feed_grabbed_to_self_falling_nom(pred,prey)
		pred.loc = fallloc
		if(!safe_fall)
			pred.Weaken(8)
		pred.visible_message("<span class='vdanger'>\The [pred] falls right onto \the [prey]!</span>")
	else if(prey.vore_selected && prey.can_be_drop_pred && pred.can_be_drop_prey && pred.drop_vore && prey.drop_vore)
		prey.feed_grabbed_to_self_falling_nom(prey,pred)
		prey.Weaken(4)
		prey.visible_message("<span class='vdanger'>\The [pred] falls right into \the [prey]!</span>")
	else
		pred.loc = prey.loc
		if(!safe_fall)
			pred.Weaken(8)
			prey.Weaken(8)
			playsound(src, "punch", 25, 1, -1)
			var/tdamage
			for(var/i = 1 to 5)			//Twice as less damage because cushioned fall, but both get damaged.
				tdamage = rand(0, 5)
				pred.adjustBruteLoss(tdamage)
				prey.adjustBruteLoss(tdamage)
			pred.updatehealth()
			prey.updatehealth()
			pred.visible_message("<span class='danger'>\The [pred] falls onto \the [prey]!</span>")
		else
			pred.visible_message("<span class='notice'>\The [pred] safely brushes past \the [prey] as they land.</span>")
	return 1

/mob/observer/dead/CheckFall()
	return

/mob/proc/CanZPass(atom/A, direction)
	if(z == A.z) //moving FROM this turf
		return direction == UP //can't go below
	else
		if(direction == UP) //on a turf below, trying to enter
			return 0
		if(direction == DOWN) //on a turf above, trying to enter
			return 1

/turf/simulated/proc/climb_wall()
	set name = "Climb Wall"
	set desc = "Using nature's gifts or technology, scale that wall!"
	set category = "Object"
	set src in oview(1)

	if(!istype(usr, /mob/living)) return	//Why would ghosts want to climb?
	var/mob/living/L = usr
	var/climbing_delay_min = L.climbing_delay
	var/fall_chance = 0
	var/drop_our_held = FALSE
	var/nutrition_cost = 50 //Climbing up is harder!

	//Checking if there's any point trying to climb
	var/turf/above_wall = GetAbove(src)
	if(L.nutrition <= nutrition_cost)
		to_chat(L, SPAN_WARNING("You [L.isSynthetic() ? "lack the energy" : "are too hungry"] for such strenous activities!"))
		return
	if(!above_wall) //No multiZ
		to_chat(L, SPAN_NOTICE("There's nothing interesting over this cliff!"))
		return
	var/turf/above_mob = GetAbove(L)	//Making sure we got headroom
	if(!above_mob.CanZPass(L, UP))
		to_chat(L, SPAN_WARNING("\The [above_mob] blocks your way."))
		return
	if(above_wall.density) //We check density rather than type since some walls dont have a floor on top.
		to_chat(L, SPAN_WARNING("\The [above_wall] blocks your way."))
		return
	if(LAZYLEN(above_wall.contents) > 30) //We avoid checking the contents if it's too cluttered to avoid issues
		to_chat(L, SPAN_WARNING("\The [above_wall] is too cluttered to climb onto!"))
		return
	for(var/atom/A in above_wall.contents)
		if(A.density)
			to_chat(L, SPAN_WARNING("\The [A.name] blocks your way!"))
			return

	//human mobs got species and can wear special equipment
	//We give them some snowflake treatment as a consequence
	if(ishuman(L))
		var/permit_human = FALSE
		var/mob/living/carbon/human/H = L
		if(H.species.climbing_delay < H.climbing_delay)
			climbing_delay_min = H.species.climbing_delay
		var/list/gear = list(H.head, H.wear_mask, H.wear_suit, H.w_uniform,
		H.gloves, H.shoes, H.belt, H.get_active_hand(), H.get_inactive_hand())
		if(H.can_climb || H.species.can_climb)
			permit_human = TRUE
		for(var/obj/item/I in gear)
			if(I.rock_climbing)
				permit_human = TRUE
				if(I.climbing_delay > climbing_delay_min)
					climbing_delay_min = I.climbing_delay //We get the maximum possible speedup out of worn equipment
		if(!permit_human)
			var/sure = tgui_alert(H,"Are you sure you want to try without tools? It's VERY LIKELY \
			you will fall and get hurt. More agile species might have better luck", "Second Thoughts", list("Bring it!", "Stay grounded"))
			if(sure == "Stay grounded") return
			fall_chance = clamp(100 - H.species.agility, 40, 90) //This should be 80 for most species. Traceur would reduce to 10%, so clamping higher
	//If not a human mob, must be simple or silicon. They got a var stored on their mob we can check
	else if(!L.can_climb)
		var/sure = tgui_alert(L,"Are you sure you want to try without tools? It's VERY LIKELY \
			you will fall and get hurt. More agile species might have better luck", "Second Thoughts", list("Bring it!", "Stay grounded"))
		if(sure == "Stay grounded") return
		if(isrobot(L))
			fall_chance = 80 // Robots get no mercy
		else
			fall_chance = 55  //Simple mobs do.
		climbing_delay_min = 2
	//Catslugs are a snowflake case because of references.
	if(istype(L, /mob/living/simple_mob/vore/alienanimals/catslug))
		var/obj/O = L.get_active_hand()
		if(istype(O, /obj/item/weapon/material/twohanded/spear))
			var/choice = tgui_alert(L, "Use your spear to climb faster? This will drop and break it!", "Scug Tactics", list("Yes!", "No"))
			if(choice == "Yes!")
				drop_our_held = TRUE
				climbing_delay_min = 0.75

	//We proceed with the actual climbing!
	// ################### CLIMB TIME BELOW: #############################
	// Climb time is 3.75 for scugs with spears (spear is dropped)
	// Climb time is 5 for Master climbers, Vassilians, Well-geared humans
	// Climb time is 9 for Tajara and Professional Climbers
	// Climb time is 17.5 Seconds for amateur climbers
	// Climb time is 20 seconds for scugs without a spear
	// Climb time is 30 for gearless untrained people
	var/climb_time = (5 * climbing_delay_min) SECONDS
	if(fall_chance)
		to_chat(L, SPAN_WARNING("You begin climbing over \The [src]. Getting a grip is exceedingly difficult..."))
		climb_time += 20 SECONDS
	else
		to_chat(L, SPAN_NOTICE("You begin climbing above \The [src]! "))
		if(climbing_delay_min > 1.25)
			climb_time += 10 SECONDS
		if(climbing_delay_min > 1.0)
			climb_time += 2.5 SECONDS
	if(L.nutrition >= 100 && L.nutrition <= 200)
		to_chat(L, SPAN_NOTICE("Climbing while [L.isSynthetic() ? "low on power" : "hungry"] slows you down"))
		climb_time += 1 SECONDS
	else if(L.nutrition >= nutrition_cost && L.nutrition <= 100)
		to_chat(L, SPAN_DANGER("You [L.isSynthetic() ? "lack enough power" : "are too hungry"] to climb safely!"))
		climb_time +=3 SECONDS
		if(fall_chance < 30)
			fall_chance = 30
	L.visible_message(message = "<b>[L]</b> begins to climb up on <b>\The [src]</b>", self_message = "You begin to clumb up on <b>\The [src]</b>", \
		blind_message = "You hear the sounds of climbing!", runemessage = "Tap Tap")
	var/oops_time = world.time
	var/grace_time = 4 SECONDS
	to_chat(L, SPAN_WARNING("If you get interrupted after [(grace_time / (1 SECOND))] seconds of climbing, you will fall and hurt yourself, beware!"))
	if(do_after(L,climb_time))
		if(prob(fall_chance))
			L.forceMove(above_mob)
			L.visible_message(message = "<b>[L]</b> falls off <b>\The [src]</b>", self_message = SPAN_DANGER("You slipped off <b>\The [src]</b>"), \
				blind_message = "you hear a loud thud!", runemessage = "CRASH!")
		else
			if(drop_our_held)
				L.drop_item(get_turf(L))
			L.forceMove(above_wall)
			L.visible_message(message = "<b>[L]</b> climbed up on <b>\The [src]</b>",	\
				self_message = SPAN_NOTICE("You successfully scaled <b>\The [src]</b>"),	\
				blind_message = "The sounds of climbing cease.", runemessage = "Tap Tap")
		L.adjust_nutrition(-nutrition_cost)
	else if(world.time > (oops_time + grace_time))
		L.forceMove(above_mob)
		L.visible_message(message = "<b>[L]</b> falls off <b>\The [src]</b>", self_message = SPAN_DANGER("You slipped off <b>\The [src]</b>"), \
			blind_message = "you hear a loud thud!", runemessage = "CRASH!")

/mob/living/verb/climb_down()
	set name = "Climb down wall"
	set desc = "attempt to climb down the wall you are standing on, in direction you're looking"
	set category = "IC"

	var/fall_chance = 0	//Increased if we can't actually climb
	var/turf/our_turf = get_turf(src) //floor we're standing on
	var/climbing_delay_min = src.climbing_delay //We take the lowest climbing delay between mob, species and gear.
	var/nutrition_cost = 25	//Descending is easier!


	//Check if we can even try to climb
	if(nutrition <= nutrition_cost)
		to_chat(src, SPAN_WARNING("You [isSynthetic() ? "lack the energy" : "are too hungry"] for such strenous activities!"))
		return
	var/turf/below_wall = GetBelow(our_turf)
	if(!below_wall)	//No multiZ
		to_chat(src, SPAN_NOTICE("There's nothing interesting below us!"))
		return
	if(!istype(below_wall,/turf/simulated)) //Our var is on simulated turfs, we must enforce this
		to_chat(src, SPAN_NOTICE("There's nothing useful to grab onto!"))
		return
	var/turf/simulated/climbing_surface = below_wall
	if(!climbing_surface.density) //passable turfs make no sense to climb
		to_chat(src, SPAN_NOTICE("There's nothing climbable below us!"))
		return
	var/turf/front_of_us = get_step(src, dir) //We get the spot we are facing
	if(!front_of_us.CanZPass(src, DOWN)) //Makes sure where we're climbing isnt blocked by a tile or there's a wall below it.
		to_chat(src, SPAN_NOTICE("\The [front_of_us] blocks your way in this direction!"))
		return
	var/turf/destination = GetBelow(front_of_us)
	if(isopenspace(destination)) //We don't allow descending more than 1 Z at a time
		to_chat(src, SPAN_NOTICE("You're too high up to climb down from here! Find a more gentle descent!"))
		return

	//Determining whether we should be able to climb safely and how fast
	if(ishuman(src))
		var/permit_human = FALSE
		var/mob/living/carbon/human/H = src
		if(H.species.climbing_delay < H.climbing_delay)
			climbing_delay_min = H.species.climbing_delay
		var/list/gear = list(H.head, H.wear_mask, H.wear_suit, H.w_uniform,
		H.gloves, H.shoes, H.belt, H.get_active_hand(), H.get_inactive_hand())
		if(H.can_climb || H.species.can_climb)
			permit_human = TRUE
		for(var/obj/item/I in gear)
			if(I.rock_climbing)
				permit_human = TRUE
				if(I.climbing_delay > climbing_delay_min)
					climbing_delay_min = I.climbing_delay //We get the maximum possible speedup out of worn equipment
		if(!permit_human)
			var/sure = tgui_alert(H,"Are you sure you want to try without tools? It's VERY LIKELY \
			you will fall and get hurt. More agile species might have better luck", "Second Thoughts", list("Bring it!", "Stay grounded"))
			if(sure == "Stay grounded") return
			fall_chance = clamp(100 - H.species.agility, 40, 90) //This should be 80 for most species. Traceur would reduce to 10%, so clamping higher
	//If not a human mob, must be simple or silicon. They got a var stored on their mob we can check
	else if(!src.can_climb)
		var/sure = tgui_alert(src,"Are you sure you want to try without tools? It's VERY LIKELY \
			you will fall and get hurt. More agile species might have better luck", "Second Thoughts", list("Bring it!", "Stay grounded"))
		if(sure == "Stay grounded") return
		if(isrobot(src))
			fall_chance = 80 // Robots get no mercy
		else
			fall_chance = 55  //Simple mobs do.
		climbing_delay_min = 2
	//This time, scugs get no snowflake treatment. We're climbing DOWN, not up!

	//We proceed with the actual climbing!
	// ################### CLIMB TIME BELOW: #############################
	// Climb time is 3.75 for scugs with spears (spear is dropped)
	// Climb time is 5 for Master climbers, Vassilians, Well-geared humans
	// Climb time is 9 for Tajara and Professional Climbers
	// Climb time is 17.5 Seconds for amateur climbers
	// Climb time is 20 seconds for scugs without a spear
	// Climb time is 30 for gearless untrained people
	var/climb_time = (5 * climbing_delay_min) SECONDS
	if(fall_chance)
		to_chat(src, SPAN_WARNING("You begin climbing down along \The [below_wall]. Getting a grip is exceedingly difficult..."))
		climb_time += 20 SECONDS
	else
		to_chat(src, SPAN_NOTICE("You begin climbing down \The [below_wall]! "))
		if(climbing_delay_min > 1.25)
			climb_time += 10 SECONDS
		if(climbing_delay_min > 1.0)
			climb_time += 2.5 SECONDS
	if(nutrition >= 100 && nutrition <= 200) //Values are 50 lower than the warning icon appearing
		to_chat(src, SPAN_NOTICE("Climbing while [isSynthetic() ? "low on power" : "hungry"] slows you down"))
		climb_time += 1 SECONDS
	else if(nutrition >= nutrition_cost && nutrition <= 100)
		to_chat(src, SPAN_DANGER("You [isSynthetic() ? "lack enough power" : "are too hungry"] to climb safely!"))
		climb_time +=3 SECONDS
		if(fall_chance < 30)
			fall_chance = 30

	if(!climbing_surface.climbable)
		to_chat(src, SPAN_DANGER("\The [climbing_surface] is not suitable for climbing! Even for a master climber, this is risky!"))
		if(fall_chance < 75 )
			fall_chance = 75
	src.visible_message(message = "<b>[src]</b> climb down <b>\The [below_wall]</b>",	\
		self_message = "You begin to descend <b>\The [below_wall]</b>", 	\
		blind_message = "You hear the sounds of climbing!", runemessage = "Tap Tap")
	below_wall.audible_message(message = "You hear something climbing up <b>\The [below_wall]</b>", runemessage= "Tap Tap")
	var/oops_time = world.time
	var/grace_time = 3 SECONDS
	to_chat(src, SPAN_WARNING("If you get interrupted after [(grace_time / (1 SECOND))] seconds of climbing, you will fall and hurt yourself, beware!"))
	if(do_after(src,climb_time))
		if(prob(fall_chance))
			src.forceMove(front_of_us)
			src.visible_message(message = "<b>[src]</b> falls off <b>\The [below_wall]</b>", \
				self_message = SPAN_DANGER("You slipped off <b>\The [below_wall]</b>"), \
				blind_message = "you hear a loud thud!", runemessage = "CRASH!")
		else
			src.forceMove(destination)
			src.visible_message(message = "<b>[src]</b> climbed down on <b>\The [below_wall]</b>",	\
				self_message = SPAN_NOTICE("You successfully descended <b>\The [below_wall]</b>"),	\
				blind_message = "The sounds of climbing cease.", runemessage = "Tap Tap")
		adjust_nutrition(-nutrition_cost)
	else if(world.time > (oops_time + grace_time))
		src.forceMove(front_of_us)
		src.visible_message(message = "<b>[src]</b> falls off <b>\The [below_wall]</b>", \
			self_message = SPAN_DANGER("You slipped off <b>\The [below_wall]</b>"), \
			blind_message = "you hear a loud thud!", runemessage = "CRASH!")
