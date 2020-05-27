/* Alien Effects!
 * Contains:
 *		effect/alien
 *		Resin
 *		Weeds
 *		Acid
 *		Egg
 */

/*
 * effect/alien
 */
/obj/effect/alien
	name = "alien thing"
	desc = "theres something alien about this"
	icon = 'icons/mob/alien.dmi'

/*
 * Resin
 */
/obj/effect/alien/resin
	name = "resin"
	desc = "Looks like some kind of slimy growth."
	icon_state = "resin"

	density = 1
	opacity = 1
	anchored = 1
	can_atmos_pass = ATMOS_PASS_NO
	var/health = 200
	//var/mob/living/affecting = null

/obj/effect/alien/resin/wall
	name = "resin wall"
	desc = "Purple slime solidified into a wall."
	icon_state = "resinwall" //same as resin, but consistency ho!

/obj/effect/alien/resin/membrane
	name = "resin membrane"
	desc = "Purple slime just thin enough to let light pass through."
	icon_state = "resinmembrane"
	opacity = 0
	health = 120

/obj/effect/alien/resin/New()
	..()
	var/turf/T = get_turf(src)
	T.thermal_conductivity = WALL_HEAT_TRANSFER_COEFFICIENT

/obj/effect/alien/resin/Destroy()
	var/turf/T = get_turf(src)
	T.thermal_conductivity = initial(T.thermal_conductivity)
	..()

/obj/effect/alien/resin/proc/healthcheck()
	if(health <=0)
		density = 0
		qdel(src)
	return

/obj/effect/alien/resin/bullet_act(var/obj/item/projectile/Proj)
	health -= Proj.damage
	..()
	healthcheck()
	return

/obj/effect/alien/resin/attack_generic(var/mob/user, var/damage, var/attack_verb)
	visible_message("<span class='danger'>[user] [attack_verb] the [src]!</span>")
	playsound(src, 'sound/effects/attackblob.ogg', 100, 1)
	user.do_attack_animation(src)
	health -= damage
	healthcheck()
	return

/obj/effect/alien/resin/take_damage(var/damage)
	health -= damage
	healthcheck()
	return

/obj/effect/alien/resin/ex_act(severity)
	switch(severity)
		if(1.0)
			health-=50
		if(2.0)
			health-=50
		if(3.0)
			if (prob(50))
				health-=50
			else
				health-=25
	healthcheck()
	return

/obj/effect/alien/resin/hitby(AM as mob|obj)
	..()
	for(var/mob/O in viewers(src, null))
		O.show_message("<span class='danger'>[src] was hit by [AM].</span>", 1)
	var/tforce = 0
	if(ismob(AM))
		tforce = 10
	else
		tforce = AM:throwforce
	playsound(src, 'sound/effects/attackblob.ogg', 100, 1)
	health = max(0, health - tforce)
	healthcheck()
	..()
	return

/obj/effect/alien/resin/attack_hand()
	usr.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	if (HULK in usr.mutations)
		to_chat(usr, "<span class='notice'>You easily destroy the [name].</span>")
		for(var/mob/O in oviewers(src))
			O.show_message("<span class='warning'>[usr] destroys the [name]!</span>", 1)
		health = 0
	else

		// Aliens can get straight through these.
		if(istype(usr,/mob/living/carbon))
			var/mob/living/carbon/M = usr
			if(locate(/obj/item/organ/internal/xenos/hivenode) in M.internal_organs)
				for(var/mob/O in oviewers(src))
					O.show_message("<span class='warning'>[usr] strokes the [name] and it melts away!</span>", 1)
				health = 0
				healthcheck()
				return

		to_chat(usr, "<span class='notice'>You claw at the [name].</span>")
		for(var/mob/O in oviewers(src))
			O.show_message("<span class='warning'>[usr] claws at the [name]!</span>", 1)
		health -= rand(5,10)
	healthcheck()
	return

/obj/effect/alien/resin/attackby(obj/item/weapon/W as obj, mob/user as mob)

	user.setClickCooldown(user.get_attack_speed(W))
	var/aforce = W.force
	health = max(0, health - aforce)
	playsound(src, 'sound/effects/attackblob.ogg', 100, 1)
	healthcheck()
	..()
	return

/obj/effect/alien/resin/CanPass(atom/movable/mover, turf/target)
	if(istype(mover) && mover.checkpass(PASSGLASS))
		return !opacity
	return !density


/*
 * Weeds
 */
#define NODERANGE 3
#define WEED_NORTH_EDGING "north"
#define WEED_SOUTH_EDGING "south"
#define WEED_EAST_EDGING "east"
#define WEED_WEST_EDGING "west"
#define WEED_NODE_GLOW "glow"
#define WEED_NODE_BASE "nodebase"

/obj/effect/alien/weeds
	name = "growth"
	desc = "Weird organic growth."
	icon_state = "weeds"
	anchored = 1
	density = 0
	plane = TURF_PLANE
	layer = ABOVE_TURF_LAYER

	var/health = 15
	var/obj/effect/alien/weeds/node/linked_node = null
	var/static/list/weedImageCache

/obj/effect/alien/weeds/Initialize(var/mapload, var/node, var/newcolor)
	. = ..()
	if(isspace(loc))
		return INITIALIZE_HINT_QDEL

	linked_node = node
	if(newcolor)
		color = newcolor

	if(icon_state == "weeds")
		icon_state = pick("weeds", "weeds1", "weeds2")

	fullUpdateWeedOverlays()

/obj/effect/alien/weeds/Destroy()
	var/turf/T = get_turf(src)
	// To not mess up the overlay updates.
	loc = null

	for (var/obj/effect/alien/weeds/W in range(1,T))
		W.updateWeedOverlays()

	linked_node = null
	return ..()

/obj/effect/alien/weeds/node
	icon_state = "weednode"
	name = "glowing growth"
	desc = "Weird glowing organic growth."
	layer = ABOVE_TURF_LAYER+0.01
	light_range = NODERANGE

	var/node_range = NODERANGE
	var/set_color = "#321D37"

/obj/effect/alien/weeds/node/Initialize(var/mapload, var/node, var/newcolor)
	. = ..()

	for(var/obj/effect/alien/weeds/existing in loc)
		if(existing == src)
			continue
		else
			qdel(existing)

	linked_node = src

	if(newcolor)
		set_color = newcolor
	if(set_color)
		color = set_color

	START_PROCESSING(SSobj, src) // Only the node processes in a subsystem, the rest are process()'d by the node

/obj/effect/alien/weeds/node/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/effect/alien/weeds/proc/updateWeedOverlays()
	cut_overlays()

	if(!weedImageCache)
		weedImageCache = list()
		weedImageCache[WEED_NORTH_EDGING] = image('icons/mob/alien.dmi', "weeds_side_n", layer=2.11, pixel_y = -32)
		weedImageCache[WEED_SOUTH_EDGING] = image('icons/mob/alien.dmi', "weeds_side_s", layer=2.11, pixel_y = 32)
		weedImageCache[WEED_EAST_EDGING] = image('icons/mob/alien.dmi', "weeds_side_e", layer=2.11, pixel_x = -32)
		weedImageCache[WEED_WEST_EDGING] = image('icons/mob/alien.dmi', "weeds_side_w", layer=2.11, pixel_x = 32)

	var/turf/N = get_step(src, NORTH)
	var/turf/S = get_step(src, SOUTH)
	var/turf/E = get_step(src, EAST)
	var/turf/W = get_step(src, WEST)
	if(istype(N, /turf/simulated/floor) && !locate(/obj/effect/alien) in N.contents)
		add_overlay(weedImageCache[WEED_SOUTH_EDGING])
	if(istype(S, /turf/simulated/floor) && !locate(/obj/effect/alien) in S.contents)
		add_overlay(weedImageCache[WEED_NORTH_EDGING])
	if(istype(E, /turf/simulated/floor) && !locate(/obj/effect/alien) in E.contents)
		add_overlay(weedImageCache[WEED_WEST_EDGING])
	if(istype(W, /turf/simulated/floor) && !locate(/obj/effect/alien) in W.contents)
		add_overlay(weedImageCache[WEED_EAST_EDGING])

/obj/effect/alien/weeds/proc/fullUpdateWeedOverlays()
	for (var/obj/effect/alien/weeds/W in range(1,src))
		W.updateWeedOverlays()

	return

// NB: This is not actually called by a processing subsystem, it's called by the node processing
/obj/effect/alien/weeds/process()
	set background = 1
	var/turf/U = get_turf(src)

	if(isspace(U))
		qdel(src)
		return

	if(!linked_node)
		return

	if(get_dist(linked_node, src) > linked_node.node_range)
		return

	for(var/dirn in cardinal)
		var/turf/T1 = get_turf(src)
		var/turf/T2 = get_step(src, dirn)

		if(!istype(T2) || locate(/obj/effect/alien/weeds) in T2 || istype(T2.loc, /area/arrival) || isspace(T2))
			continue

		if(T1.c_airblock(T2) == BLOCKED)
			continue

		new /obj/effect/alien/weeds(T2, linked_node, color)

/obj/effect/alien/weeds/node/process()
	set background = 1
	. = ..()

	var/list/nearby_weeds = list()
	for(var/obj/effect/alien/weeds/W in orange(node_range, src))
		nearby_weeds |= W

	for(var/nbw in nearby_weeds)
		var/obj/effect/alien/weeds/W = nbw

		if(!W.linked_node)
			W.linked_node = src

		W.color = W.linked_node.set_color

		if(prob(max(10, 60 - (5 * nearby_weeds.len))))
			W.process()

/obj/effect/alien/weeds/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
		if(2.0)
			if (prob(50))
				qdel(src)
		if(3.0)
			if (prob(5))
				qdel(src)
	return

/obj/effect/alien/weeds/attackby(var/obj/item/weapon/W, var/mob/user)
	user.setClickCooldown(user.get_attack_speed(W))
	if(W.attack_verb.len)
		visible_message("<span class='danger'>\The [src] have been [pick(W.attack_verb)] with \the [W][(user ? " by [user]." : ".")]</span>")
	else
		visible_message("<span class='danger'>\The [src] have been attacked with \the [W][(user ? " by [user]." : ".")]</span>")

	var/damage = W.force / 4.0

	if(istype(W, /obj/item/weapon/weldingtool))
		var/obj/item/weapon/weldingtool/WT = W

		if(WT.remove_fuel(0, user))
			damage = 15
			playsound(src, 'sound/items/Welder.ogg', 100, 1)

	health -= damage
	healthcheck()

/obj/effect/alien/weeds/attack_generic(var/mob/user, var/damage, var/attack_verb)
	visible_message("<span class='danger'>[user] [attack_verb] the [src]!</span>")
	user.do_attack_animation(src)
	health -= damage
	healthcheck()
	return

/obj/effect/alien/weeds/take_damage(var/damage)
	health -= damage
	healthcheck()
	return

/obj/effect/alien/weeds/proc/healthcheck()
	if(health <= 0)
		qdel(src)


/obj/effect/alien/weeds/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if(exposed_temperature > 300 + T0C)
		health -= 5
		healthcheck()

#undef NODERANGE
#undef WEED_NORTH_EDGING
#undef WEED_SOUTH_EDGING
#undef WEED_EAST_EDGING
#undef WEED_WEST_EDGING
#undef WEED_NODE_GLOW
#undef WEED_NODE_BASE

/*
 * Acid
 */
/obj/effect/alien/acid
	name = "acid"
	desc = "Burbling corrossive stuff. I wouldn't want to touch it."
	icon_state = "acid"

	density = 0
	opacity = 0
	anchored = 1

	var/atom/target
	var/ticks = 0
	var/target_strength = 0

/obj/effect/alien/acid/New(loc, target)
	..(loc)
	src.target = target

	if(isturf(target)) // Turf take twice as long to take down.
		target_strength = 8
	else
		target_strength = 4
	tick()

/obj/effect/alien/acid/proc/tick()
	if(!target)
		qdel(src)

	ticks += 1

	if(ticks >= target_strength)

		for(var/mob/O in hearers(src, null))
			O.show_message("<span class='alium'>[src.target] collapses under its own weight into a puddle of goop and undigested debris!</span>", 1)

		if(istype(target, /turf/simulated/wall)) // I hate turf code.
			var/turf/simulated/wall/W = target
			W.dismantle_wall(1)
		else
			qdel(target)
		qdel(src)
		return

	switch(target_strength - ticks)
		if(6)
			visible_message("<span class='alium'>[src.target] is holding up against the acid!</span>")
		if(4)
			visible_message("<span class='alium'>[src.target]\s structure is being melted by the acid!</span>")
		if(2)
			visible_message("<span class='alium'>[src.target] is struggling to withstand the acid!</span>")
		if(0 to 1)
			visible_message("<span class='alium'>[src.target] begins to crumble under the acid!</span>")
	spawn(rand(150, 200)) tick()

/*
 * Egg
 */
/var/const //for the status var
	BURST = 0
	BURSTING = 1
	GROWING = 2
	GROWN = 3

	MIN_GROWTH_TIME = 1800 //time it takes to grow a hugger
	MAX_GROWTH_TIME = 3000

/obj/effect/alien/egg
	desc = "It looks like a weird egg"
	name = "egg"
//	icon_state = "egg_growing" // So the egg looks 'grown', even though it's not.
	icon_state = "egg"
	density = 0
	anchored = 1

	var/health = 100
	var/status = BURST //can be GROWING, GROWN or BURST; all mutually exclusive

/obj/effect/alien/egg/New()
/*
	if(config.aliens_allowed)
		..()
		spawn(rand(MIN_GROWTH_TIME,MAX_GROWTH_TIME))
			Grow()
	else
		qdel(src)
*/
/obj/effect/alien/egg/attack_hand(user as mob)

	var/mob/living/carbon/M = user
	if(!istype(M) || !(locate(/obj/item/organ/internal/xenos/hivenode) in M.internal_organs))
		return attack_hand(user)

	switch(status)
		if(BURST)
			to_chat(user, "<span class='warning'>You clear the hatched egg.</span>")
			qdel(src)
			return
/*		if(GROWING)
			to_chat(user, "<span class='warning'>The child is not developed yet.</span>")
			return
		if(GROWN)
			to_chat(user, "<span class='warning'>You retrieve the child.</span>")
			Burst(0)
			return

/obj/effect/alien/egg/proc/GetFacehugger() // Commented out for future edit.
	return locate(/obj/item/clothing/mask/facehugger) in contents

/obj/effect/alien/egg/proc/Grow()
	icon_state = "egg"
//	status = GROWN
	status = BURST
//	new /obj/item/clothing/mask/facehugger(src)
	return
*/
/obj/effect/alien/egg/proc/Burst(var/kill = 1) //drops and kills the hugger if any is remaining
	if(status == GROWN || status == GROWING)
//		var/obj/item/clothing/mask/facehugger/child = GetFacehugger()
		icon_state = "egg_hatched"
/*		flick("egg_opening", src)
		status = BURSTING
		spawn(15)
			status = BURST
			child.loc = get_turf(src)

			if(kill && istype(child))
				child.Die()
			else
				for(var/mob/M in range(1,src))
					if(CanHug(M))
						child.Attach(M)
						break
*/
/obj/effect/alien/egg/bullet_act(var/obj/item/projectile/Proj)
	health -= Proj.damage
	..()
	healthcheck()
	return

/obj/effect/alien/egg/attack_generic(var/mob/user, var/damage, var/attack_verb)
	visible_message("<span class='danger'>[user] [attack_verb] the [src]!</span>")
	user.do_attack_animation(src)
	health -= damage
	healthcheck()
	return

/obj/effect/alien/egg/take_damage(var/damage)
	health -= damage
	healthcheck()
	return


/obj/effect/alien/egg/attackby(var/obj/item/weapon/W, var/mob/user)
	if(health <= 0)
		return
	if(W.attack_verb.len)
		src.visible_message("<span class='danger'>\The [src] has been [pick(W.attack_verb)] with \the [W][(user ? " by [user]." : ".")]</span>")
	else
		src.visible_message("<span class='danger'>\The [src] has been attacked with \the [W][(user ? " by [user]." : ".")]</span>")
	var/damage = W.force / 4.0

	if(istype(W, /obj/item/weapon/weldingtool))
		var/obj/item/weapon/weldingtool/WT = W

		if(WT.remove_fuel(0, user))
			damage = 15
			playsound(src, 'sound/items/Welder.ogg', 100, 1)

	src.health -= damage
	src.healthcheck()


/obj/effect/alien/egg/proc/healthcheck()
	if(health <= 0)
		Burst()

/obj/effect/alien/egg/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if(exposed_temperature > 500 + T0C)
		health -= 5
		healthcheck()