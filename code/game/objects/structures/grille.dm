/obj/structure/grille
	name = "grille"
	desc = "A flimsy lattice of metal rods, with screws to secure it to the floor."
	icon = 'icons/obj/structures_vr.dmi' // VOREStation Edit - New icons
	icon_state = "grille"
	density = TRUE
	anchored = TRUE
	pressure_resistance = 5*ONE_ATMOSPHERE
	layer = TABLE_LAYER
	explosion_resistance = 1
	var/health = 10
	var/destroyed = 0


/obj/structure/grille/ex_act(severity)
	qdel(src)

/obj/structure/grille/update_icon()
	if(destroyed)
		icon_state = "[initial(icon_state)]-b"
	else
		icon_state = initial(icon_state)

/obj/structure/grille/Bumped(atom/user)
	if(ismob(user)) shock(user, 70)

/obj/structure/grille/attack_hand(mob/user as mob)

	user.setClickCooldown(user.get_attack_speed())
	playsound(src, 'sound/effects/grillehit.ogg', 80, 1)
	user.do_attack_animation(src)

	var/damage_dealt = 1
	var/attack_message = "kicks"
	if(istype(user,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = user
		if(H.species.can_shred(H))
			attack_message = "mangles"
			damage_dealt = 5

	if(shock(user, 70))
		return

	if(HULK in user.mutations)
		damage_dealt += 5
	else
		damage_dealt += 1

	attack_generic(user,damage_dealt,attack_message)

/obj/structure/grille/CanPass(atom/movable/mover, turf/target)
	if(istype(mover) && mover.checkpass(PASSGRILLE))
		return TRUE
	if(istype(mover, /obj/item/projectile))
		return prob(30)
	return !density

/obj/structure/grille/bullet_act(var/obj/item/projectile/Proj)
	if(!Proj)	return

	//Flimsy grilles aren't so great at stopping projectiles. However they can absorb some of the impact
	var/damage = Proj.get_structure_damage()
	var/passthrough = 0

	if(!damage) return

	//20% chance that the grille provides a bit more cover than usual. Support structure for example might take up 20% of the grille's area.
	//If they click on the grille itself then we assume they are aiming at the grille itself and the extra cover behaviour is always used.
	switch(Proj.damage_type)
		if(BRUTE)
			//bullets
			if(Proj.original == src || prob(20))
				Proj.damage *= between(0, Proj.damage/60, 0.5)
				if(prob(max((damage-10)/25, 0))*100)
					passthrough = 1
			else
				Proj.damage *= between(0, Proj.damage/60, 1)
				passthrough = 1
		if(BURN)
			//beams and other projectiles are either blocked completely by grilles or stop half the damage.
			if(!(Proj.original == src || prob(20)))
				Proj.damage *= 0.5
				passthrough = 1

	if(passthrough)
		. = PROJECTILE_CONTINUE
		damage = between(0, (damage - Proj.damage)*(Proj.damage_type == BRUTE? 0.4 : 1), 10) //if the bullet passes through then the grille avoids most of the damage

	src.health -= damage*0.2
	spawn(0) healthcheck() //spawn to make sure we return properly if the grille is deleted

/obj/structure/grille/attackby(obj/item/W as obj, mob/user as mob)
	if(!istype(W))
		return
	if(istype(W, /obj/item/weapon/rcd)) // To stop us from hitting the grille when building windows, because grilles don't let parent handle it properly.
		return FALSE
	else if(W.is_wirecutter())
		if(!shock(user, 100))
			playsound(src, W.usesound, 100, 1)
			new /obj/item/stack/rods(get_turf(src), destroyed ? 1 : 2)
			qdel(src)
	else if((W.is_screwdriver()) && (istype(loc, /turf/simulated) || anchored))
		if(!shock(user, 90))
			playsound(src, W.usesound, 100, 1)
			anchored = !anchored
			user.visible_message("<span class='notice'>[user] [anchored ? "fastens" : "unfastens"] the grille.</span>", \
								 "<span class='notice'>You have [anchored ? "fastened the grille to" : "unfastened the grille from"] the floor.</span>")
			return

	//window placing begin //TODO CONVERT PROPERLY TO MATERIAL DATUM
	else if(istype(W,/obj/item/stack/material))
		var/obj/item/stack/material/ST = W
		if(!ST.material.created_window)
			return 0

		var/dir_to_set = 1
		if(loc == user.loc)
			dir_to_set = user.dir
		else
			if( ( x == user.x ) || (y == user.y) ) //Only supposed to work for cardinal directions.
				if( x == user.x )
					if( y > user.y )
						dir_to_set = 2
					else
						dir_to_set = 1
				else if( y == user.y )
					if( x > user.x )
						dir_to_set = 8
					else
						dir_to_set = 4
			else
				to_chat(user, "<span class='notice'>You can't reach.</span>")
				return //Only works for cardinal direcitons, diagonals aren't supposed to work like this.
		for(var/obj/structure/window/WINDOW in loc)
			if(WINDOW.dir == dir_to_set)
				to_chat(user, "<span class='notice'>There is already a window facing this way there.</span>")
				return
		to_chat(user, "<span class='notice'>You start placing the window.</span>")
		if(do_after(user,20))
			for(var/obj/structure/window/WINDOW in loc)
				if(WINDOW.dir == dir_to_set)//checking this for a 2nd time to check if a window was made while we were waiting.
					to_chat(user, "<span class='notice'>There is already a window facing this way there.</span>")
					return

			var/wtype = ST.material.created_window
			if (ST.use(1))
				var/obj/structure/window/WD = new wtype(loc, dir_to_set, 1)
				to_chat(user, "<span class='notice'>You place the [WD] on [src].</span>")
				WD.update_icon()
		return
//window placing end

	else if((W.flags & NOCONDUCT) || !shock(user, 70))
		user.setClickCooldown(user.get_attack_speed(W))
		user.do_attack_animation(src)
		playsound(src, 'sound/effects/grillehit.ogg', 80, 1)
		switch(W.damtype)
			if("fire")
				health -= W.force
			if("brute")
				health -= W.force * 0.1
	healthcheck()
	..()
	return


/obj/structure/grille/proc/healthcheck()
	if(health <= 0)
		if(!destroyed)
			density = FALSE
			destroyed = 1
			update_icon()
			new /obj/item/stack/rods(get_turf(src))

		else
			if(health <= -6)
				new /obj/item/stack/rods(get_turf(src))
				qdel(src)
				return
	return

// shock user with probability prb (if all connections & power are working)
// returns 1 if shocked, 0 otherwise

/obj/structure/grille/proc/shock(mob/user as mob, prb)

	if(!anchored || destroyed)		// anchored/destroyed grilles are never connected
		return 0
	if(!prob(prb))
		return 0
	if(!in_range(src, user))//To prevent TK and mech users from getting shocked
		return 0
	var/turf/T = get_turf(src)
	var/obj/structure/cable/C = T.get_cable_node()
	if(C)
		if(electrocute_mob(user, C, src))
			if(C.powernet)
				C.powernet.trigger_warning()
			var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
			s.set_up(3, 1, src)
			s.start()
			if(user.stunned)
				return 1
		else
			return 0
	return 0

/obj/structure/grille/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if(!destroyed)
		if(exposed_temperature > T0C + 1500)
			health -= 1
			healthcheck()
	..()

/obj/structure/grille/attack_generic(var/mob/user, var/damage, var/attack_verb)
	visible_message("<span class='danger'>[user] [attack_verb] the [src]!</span>")
	user.do_attack_animation(src)
	health -= damage
	spawn(1) healthcheck()
	return 1

// Used in mapping to avoid
/obj/structure/grille/broken
	destroyed = 1
	icon_state = "grille-b"
	density = FALSE

/obj/structure/grille/broken/New()
	..()
	health = rand(-5, -1) //In the destroyed but not utterly threshold.
	healthcheck() //Send this to healthcheck just in case we want to do something else with it.

/obj/structure/grille/cult
	name = "cult grille"
	desc = "A matrice built out of an unknown material, with some sort of force field blocking air around it."
	icon_state = "grillecult"
	health = 40 // Make it strong enough to avoid people breaking in too easily.
	can_atmos_pass = ATMOS_PASS_NO // Make sure air doesn't drain.

/obj/structure/grille/broken/cult
	icon_state = "grillecult-b"

/obj/structure/grille/rustic
	name = "rustic grille"
	desc = "A lattice of metal, arranged in an old, rustic fashion."
	icon_state = "grillerustic"

/obj/structure/grille/broken/rustic
	icon_state = "grillerustic-b"


/obj/structure/grille/rcd_values(mob/living/user, obj/item/weapon/rcd/the_rcd, passed_mode)
	switch(passed_mode)
		if(RCD_WINDOWGRILLE)
			// A full tile window costs 4 glass sheets.
			return list(
				RCD_VALUE_MODE = RCD_WINDOWGRILLE,
				RCD_VALUE_DELAY = 2 SECONDS,
				RCD_VALUE_COST = RCD_SHEETS_PER_MATTER_UNIT * 4
			)

		if(RCD_DECONSTRUCT)
			return list(
				RCD_VALUE_MODE = RCD_DECONSTRUCT,
				RCD_VALUE_DELAY = 2 SECONDS,
				RCD_VALUE_COST = RCD_SHEETS_PER_MATTER_UNIT * 2
			)
	return FALSE

/obj/structure/grille/rcd_act(mob/living/user, obj/item/weapon/rcd/the_rcd, passed_mode)
	switch(passed_mode)
		if(RCD_DECONSTRUCT)
			to_chat(user, span("notice", "You deconstruct \the [src]."))
			qdel(src)
			return TRUE
		if(RCD_WINDOWGRILLE)
			if(locate(/obj/structure/window) in loc)
				return FALSE
			to_chat(user, span("notice", "You construct a window."))
			var/obj/structure/window/WD = new the_rcd.window_type(loc)
			WD.anchored = TRUE
			return TRUE
	return FALSE

/obj/structure/grille/take_damage(var/damage)
	health -= damage
	spawn(1) healthcheck()
	return 1

