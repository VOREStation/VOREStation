//generic procs copied from obj/effect/alien
/obj/effect/spider
	name = "web"
	desc = "it's stringy and sticky"
	icon = 'icons/effects/effects.dmi'
	anchored = TRUE
	density = FALSE
	var/health = 15

//similar to weeds, but only barfed out by nurses manually
/obj/effect/spider/ex_act(severity)
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

/obj/effect/spider/attackby(var/obj/item/W, var/mob/user)
	user.setClickCooldown(user.get_attack_speed(W))

	if(LAZYLEN(W.attack_verb))
		visible_message("<span class='warning'>\The [src] has been [pick(W.attack_verb)] with \the [W][(user ? " by [user]." : ".")]</span>")
	else
		visible_message("<span class='warning'>\The [src] has been attacked with \the [W][(user ? " by [user]." : ".")]</span>")

	var/damage = W.force / 4.0

	if(W.has_tool_quality(TOOL_WELDER))
		var/obj/item/weldingtool/WT = W.get_welder()

		if(WT.remove_fuel(0, user))
			damage = 15
			playsound(src, W.usesound, 100, 1)

	health -= damage
	healthcheck()

/obj/effect/spider/spiderling/attack_hand(mob/living/user)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	user.do_attack_animation(src)
	if(prob(20))
		visible_message("<span class='warning'>\The [user] tries to stomp on \the [src], but misses!</span>")
		var/list/nearby = oview(2, src)
		if(length(nearby))
			walk_to(src, pick(nearby), 2)
			return
	visible_message("<span class='warning'>\The [user] stomps \the [src] dead!</span>")
	die()

/obj/effect/spider/bullet_act(var/obj/item/projectile/Proj)
	..()
	health -= Proj.get_structure_damage()
	healthcheck()

/obj/effect/spider/proc/die()
	qdel(src)

/obj/effect/spider/proc/healthcheck()
	if(health <= 0)
		die()

/obj/effect/spider/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if(exposed_temperature > 300 + T0C)
		health -= 5
		healthcheck()

/obj/effect/spider/stickyweb
	icon_state = "stickyweb1"

/obj/effect/spider/stickyweb/Initialize()
	if(prob(50))
		icon_state = "stickyweb2"
	return ..()

/obj/effect/spider/stickyweb/CanPass(atom/movable/mover, turf/target)
	if(istype(mover, /mob/living/simple_mob/animal/giant_spider))
		return TRUE
	else if(istype(mover, /mob/living))
		if(prob(50))
			to_chat(mover, span("warning", "You get stuck in \the [src] for a moment."))
			return FALSE
	else if(istype(mover, /obj/item/projectile))
		return prob(30)
	return TRUE

/obj/effect/spider/eggcluster
	name = "egg cluster"
	desc = "They seem to pulse slightly with an inner life"
	icon_state = "eggs"
	var/amount_grown = 0
	var/spiders_min = 6
	var/spiders_max = 24
	var/spider_type = /obj/effect/spider/spiderling
	var/faction = FACTION_SPIDERS

/obj/effect/spider/eggcluster/Initialize()
	pixel_x = rand(3,-3)
	pixel_y = rand(3,-3)
	START_PROCESSING(SSobj, src)
	return ..()

/obj/effect/spider/eggcluster/New(var/location, var/atom/parent)
	get_light_and_color(parent)
	..()

/obj/effect/spider/eggcluster/Destroy()
	STOP_PROCESSING(SSobj, src)
	if(istype(loc, /obj/item/organ/external))
		var/obj/item/organ/external/O = loc
		O.implants -= src

	return ..()

/obj/effect/spider/eggcluster/process()
	amount_grown += rand(0,2)
	if(amount_grown >= 100)
		var/num = rand(spiders_min, spiders_max)
		var/obj/item/organ/external/O = null
		if(istype(loc, /obj/item/organ/external))
			O = loc

		for(var/i=0, i<num, i++)
			var/obj/effect/spider/spiderling/spiderling = new spider_type(src.loc, src)
			if(O)
				O.implants += spiderling
			spiderling.faction = faction
		qdel(src)

/obj/effect/spider/eggcluster/small
	spiders_min = 1
	spiders_max = 3

/obj/effect/spider/eggcluster/small/frost
	spider_type = /obj/effect/spider/spiderling/frost

/obj/effect/spider/eggcluster/royal
	spiders_min = 2
	spiders_max = 5
	spider_type = /obj/effect/spider/spiderling/varied

/obj/effect/spider/spiderling
	name = "spiderling"
	desc = "It never stays still for long."
	icon_state = "spiderling"
	anchored = FALSE
	layer = HIDING_LAYER
	health = 3
	var/last_itch = 0
	var/amount_grown = 0
	var/obj/machinery/atmospherics/unary/vent_pump/entry_vent
	var/travelling_in_vent = 0
	var/list/grow_as = list(/mob/living/simple_mob/animal/giant_spider, /mob/living/simple_mob/animal/giant_spider/hunter)
	var/faction = FACTION_SPIDERS

	var/stunted = FALSE

/obj/effect/spider/spiderling/frost
	grow_as = list(/mob/living/simple_mob/animal/giant_spider/frost)

/obj/effect/spider/spiderling/varied
	grow_as = list(/mob/living/simple_mob/animal/giant_spider, /mob/living/simple_mob/animal/giant_spider/nurse, /mob/living/simple_mob/animal/giant_spider/hunter,
			/mob/living/simple_mob/animal/giant_spider/frost, /mob/living/simple_mob/animal/giant_spider/electric, /mob/living/simple_mob/animal/giant_spider/lurker,
			/mob/living/simple_mob/animal/giant_spider/pepper, /mob/living/simple_mob/animal/giant_spider/thermic, /mob/living/simple_mob/animal/giant_spider/tunneler,
			/mob/living/simple_mob/animal/giant_spider/webslinger, /mob/living/simple_mob/animal/giant_spider/phorogenic, /mob/living/simple_mob/animal/giant_spider/carrier,
			/mob/living/simple_mob/animal/giant_spider/ion)

/obj/effect/spider/spiderling/New(var/location, var/atom/parent)
	pixel_x = rand(6,-6)
	pixel_y = rand(6,-6)
	START_PROCESSING(SSobj, src)
	//50% chance to grow up
	if(amount_grown != -1 && prob(50))
		amount_grown = 1
	get_light_and_color(parent)
	..()

/obj/effect/spider/spiderling/Destroy()
	STOP_PROCESSING(SSobj, src)
	walk(src, 0) // Because we might have called walk_to, we must stop the walk loop or BYOND keeps an internal reference to us forever.
	return ..()

/obj/effect/spider/spiderling/Bump(atom/user)
	if(istype(user, /obj/structure/table))
		src.loc = user.loc
	else
		..()

/obj/effect/spider/spiderling/die()
	visible_message("<span class='alert'>[src] dies!</span>")
	new /obj/effect/decal/cleanable/spiderling_remains(src.loc)
	..()

/obj/effect/spider/spiderling/healthcheck()
	if(health <= 0)
		die()

/obj/effect/spider/spiderling/process()
	healthcheck()
	if(travelling_in_vent)
		if(istype(src.loc, /turf))
			travelling_in_vent = 0
			entry_vent = null
	else if(entry_vent)
		if(get_dist(src, entry_vent) <= 1)
	//VOREStation Edit Start
			var/obj/machinery/atmospherics/unary/vent_pump/exit_vent = get_safe_ventcrawl_target(entry_vent)
			if(!exit_vent)
				return
			spawn(rand(20,60))
				loc = exit_vent
				var/travel_time = round(get_dist(loc, exit_vent.loc) / 2)
				spawn(travel_time)

					if(!exit_vent || exit_vent.welded)
						loc = entry_vent
						entry_vent = null
						return

					if(prob(50))
						src.visible_message("<span class='notice'>You hear something squeezing through the ventilation ducts.</span>",2)
					sleep(travel_time)

					if(!exit_vent || exit_vent.welded)
						loc = entry_vent
						entry_vent = null
						return
					loc = exit_vent.loc
					entry_vent = null
					var/area/new_area = get_area(loc)
					if(new_area)
						new_area.Entered(src)
	//VOREStation Edit End
	//=================

	if(isturf(loc))
		skitter()

	else if(isorgan(loc))
		if(amount_grown < 0) amount_grown = 1
		var/obj/item/organ/external/O = loc
		if(!O.owner || O.owner.stat == DEAD || amount_grown > 80)
			O.implants -= src
			src.loc = O.owner ? O.owner.loc : O.loc
			src.visible_message("<span class='warning'>\A [src] makes its way out of [O.owner ? "[O.owner]'s [O.name]" : "\the [O]"]!</span>")
			if(O.owner)
				O.owner.apply_damage(1, BRUTE, O.organ_tag)
		else if(prob(1))
			O.owner.apply_damage(1, TOX, O.organ_tag)
			if(world.time > last_itch + 30 SECONDS)
				last_itch = world.time
				to_chat(O.owner, "<span class='notice'>Your [O.name] itches...</span>")
	else if(prob(1))
		src.visible_message("<b>\The [src]</b> skitters.")

	if(amount_grown >= 0)
		amount_grown += rand(0,2)

/obj/effect/spider/spiderling/proc/skitter()
	if(isturf(loc))
		if(prob(25))
			var/list/nearby = trange(5, src) - loc
			if(nearby.len)
				var/target_atom = pick(nearby)
				walk_to(src, target_atom, 5)
				if(prob(25))
					src.visible_message("<span class='notice'>\The [src] skitters[pick(" away"," around","")].</span>")
		else if(amount_grown < 75 && prob(5))
			//vent crawl!
			for(var/obj/machinery/atmospherics/unary/vent_pump/v in view(7,src))
				if(!v.welded)
					entry_vent = v
					walk_to(src, entry_vent, 5)
					break
		if(amount_grown >= 100)
			var/spawn_type = pick(grow_as)
			var/mob/living/simple_mob/animal/giant_spider/GS = new spawn_type(src.loc, src)
			GS.faction = faction
			if(stunted)
				spawn(2)
					GS.make_spiderling()
			qdel(src)

/obj/effect/spider/spiderling/stunted
	stunted = TRUE

	grow_as = list(/mob/living/simple_mob/animal/giant_spider, /mob/living/simple_mob/animal/giant_spider/hunter)

/obj/effect/spider/spiderling/non_growing
	amount_grown = -1

/obj/effect/spider/spiderling/princess
	name = "royal spiderling"
	desc = "There's a special aura about this one."
	grow_as = list(/mob/living/simple_mob/animal/giant_spider/nurse/queen)

/obj/effect/spider/spiderling/princess/New(var/location, var/atom/parent)
	..()
	amount_grown = 50

/obj/effect/decal/cleanable/spiderling_remains
	name = "spiderling remains"
	desc = "Green squishy mess."
	icon = 'icons/effects/effects.dmi'
	icon_state = "greenshatter"

/obj/effect/spider/cocoon
	name = "cocoon"
	desc = "Something wrapped in silky spider web"
	icon_state = "cocoon1"
	health = 60

/obj/effect/spider/cocoon/New()
		icon_state = pick("cocoon1","cocoon2","cocoon3")

/obj/effect/spider/cocoon/Destroy()
	src.visible_message("<span class='warning'>\The [src] splits open.</span>")
	for(var/atom/movable/A in contents)
		A.loc = src.loc
	return ..()
