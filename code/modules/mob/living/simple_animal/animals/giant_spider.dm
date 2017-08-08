
#define SPINNING_WEB 1
#define LAYING_EGGS 2
#define MOVING_TO_TARGET 3
#define SPINNING_COCOON 4

//basic spider mob, these generally guard nests
/mob/living/simple_animal/hostile/giant_spider
	name = "giant spider"
	desc = "Furry and black, it makes you shudder to look at it. This one has deep red eyes."
	icon_state = "guard"
	icon_living = "guard"
	icon_dead = "guard_dead"

	faction = "spiders"
	maxHealth = 200
	health = 200
	pass_flags = PASSTABLE
	move_to_delay = 6
	speed = 3

	stop_when_pulled = 0
	turns_per_move = 5
	see_in_dark = 10

	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "punches"

	melee_damage_lower = 15
	melee_damage_upper = 20
	heat_damage_per_tick = 20
	cold_damage_per_tick = 20

	speak_chance = 5
	speak_emote = list("chitters")
	emote_hear = list("chitters")

	meat_type = /obj/item/weapon/reagent_containers/food/snacks/xenomeat/spidermeat

	var/busy = 0
	var/poison_per_bite = 5
	var/poison_chance = 10
	var/poison_type = "spidertoxin"

//nursemaids - these create webs and eggs
/mob/living/simple_animal/hostile/giant_spider/nurse
	desc = "Furry and black, it makes you shudder to look at it. This one has brilliant green eyes."
	icon_state = "nurse"
	icon_living = "nurse"
	icon_dead = "nurse_dead"

	maxHealth = 40
	health = 40

	melee_damage_lower = 5
	melee_damage_upper = 10
	poison_per_bite = 7
	poison_type = "spidertoxin"  // VOREStation edit, original is stoxin. (sleep toxins)

	var/fed = 0
	var/atom/cocoon_target

//hunters have the most poison and move the fastest, so they can find prey
/mob/living/simple_animal/hostile/giant_spider/hunter
	desc = "Furry and black, it makes you shudder to look at it. This one has sparkling purple eyes."
	icon_state = "hunter"
	icon_living = "hunter"
	icon_dead = "hunter_dead"

	maxHealth = 120
	health = 120
	move_to_delay = 4

	melee_damage_lower = 10
	melee_damage_upper = 20

	poison_per_bite = 5

/mob/living/simple_animal/hostile/giant_spider/New(var/location, var/atom/parent)
	get_light_and_color(parent)
	..()

/mob/living/simple_animal/hostile/giant_spider/PunchTarget()
	. = ..()
	if(isliving(.))
		var/mob/living/L = .
		if(L.reagents)
			L.reagents.add_reagent(poison_type, poison_per_bite)
			if(prob(poison_chance))
				L << "<span class='warning'>You feel a tiny prick.</span>"
				L.reagents.add_reagent(poison_type, poison_per_bite)

/mob/living/simple_animal/hostile/giant_spider/nurse/PunchTarget()
	. = ..()
	if(ishuman(.))
		var/mob/living/carbon/human/H = .
		if(prob(5))
			var/obj/item/organ/external/O = pick(H.organs)
			if(!(O.robotic >= ORGAN_ROBOT))
				var/eggcount
				for(var/obj/I in O.implants)
					if(istype(I, /obj/effect/spider/eggcluster))
						eggcount ++
				if(!eggcount)
					var/eggs = new /obj/effect/spider/eggcluster/small(O, src)
					O.implants += eggs
					H << "<span class='warning'>The [src] injects something into your [O.name]!</span>"

/mob/living/simple_animal/hostile/giant_spider/handle_stance()
	. = ..()
	if(ai_inactive) return

	switch(stance)
		if(STANCE_IDLE)
		//1% chance to skitter madly away
			if(!busy && prob(1))
				/*var/list/move_targets = list()
				for(var/turf/T in orange(20, src))
					move_targets.Add(T)*/
				stop_automated_movement = 1
				walk_to(src, pick(orange(20, src)), 1, move_to_delay)
				spawn(5 SECONDS)
					stop_automated_movement = 0
					walk(src,0)

/mob/living/simple_animal/hostile/giant_spider/nurse/proc/GiveUp(var/C)
	spawn(10 SECONDS)
		if(busy == MOVING_TO_TARGET)
			if(cocoon_target == C && get_dist(src,cocoon_target) > 1)
				cocoon_target = null
			busy = 0
			stop_automated_movement = 0

/mob/living/simple_animal/hostile/giant_spider/nurse/Life()
	. = ..()
	if(!. || ai_inactive) return

	if(stance == STANCE_IDLE)
		var/list/can_see = view(src, 10)
		//30% chance to stop wandering and do something
		if(!busy && prob(30))
			//first, check for potential food nearby to cocoon
			for(var/mob/living/C in can_see)
				if(C.stat)
					cocoon_target = C
					busy = MOVING_TO_TARGET
					walk_to(src, C, 1, move_to_delay)
					//give up if we can't reach them after 10 seconds
					GiveUp(C)
					return

			//second, spin a sticky spiderweb on this tile
			var/obj/effect/spider/stickyweb/W = locate() in get_turf(src)
			if(!W)
				busy = SPINNING_WEB
				src.visible_message("<span class='notice'>\The [src] begins to secrete a sticky substance.</span>")
				stop_automated_movement = 1
				spawn(40)
					if(busy == SPINNING_WEB)
						new /obj/effect/spider/stickyweb(src.loc)
						busy = 0
						stop_automated_movement = 0
			else
				//third, lay an egg cluster there
				var/obj/effect/spider/eggcluster/E = locate() in get_turf(src)
				if(!E && fed > 0)
					busy = LAYING_EGGS
					src.visible_message("<span class='notice'>\The [src] begins to lay a cluster of eggs.</span>")
					stop_automated_movement = 1
					spawn(50)
						if(busy == LAYING_EGGS)
							E = locate() in get_turf(src)
							if(!E)
								new /obj/effect/spider/eggcluster(loc, src)
								fed--
							busy = 0
							stop_automated_movement = 0
				else
					//fourthly, cocoon any nearby items so those pesky pinkskins can't use them
					for(var/obj/O in can_see)

						if(O.anchored)
							continue

						if(istype(O, /obj/item) || istype(O, /obj/structure) || istype(O, /obj/machinery))
							cocoon_target = O
							busy = MOVING_TO_TARGET
							stop_automated_movement = 1
							walk_to(src, O, 1, move_to_delay)
							//give up if we can't reach them after 10 seconds
							GiveUp(O)

		else if(busy == MOVING_TO_TARGET && cocoon_target)
			if(get_dist(src, cocoon_target) <= 1)
				busy = SPINNING_COCOON
				src.visible_message("<span class='notice'>\The [src] begins to secrete a sticky substance around \the [cocoon_target].</span>")
				stop_automated_movement = 1
				walk(src,0)
				spawn(50)
					if(busy == SPINNING_COCOON)
						if(cocoon_target && istype(cocoon_target.loc, /turf) && get_dist(src,cocoon_target) <= 1)
							var/obj/effect/spider/cocoon/C = new(cocoon_target.loc)
							var/large_cocoon = 0
							C.pixel_x = cocoon_target.pixel_x
							C.pixel_y = cocoon_target.pixel_y
							for(var/mob/living/M in C.loc)
								if(istype(M, /mob/living/simple_animal/hostile/giant_spider))
									continue
								large_cocoon = 1
								fed++
								src.visible_message("<span class='warning'>\The [src] sticks a proboscis into \the [cocoon_target] and sucks a viscous substance out.</span>")
								M.forceMove(C)
								C.pixel_x = M.pixel_x
								C.pixel_y = M.pixel_y
								break
							for(var/obj/item/I in C.loc)
								I.forceMove(C)
							for(var/obj/structure/S in C.loc)
								if(!S.anchored)
									S.forceMove(C)
									large_cocoon = 1
							for(var/obj/machinery/M in C.loc)
								if(!M.anchored)
									M.forceMove(C)
									large_cocoon = 1
							if(large_cocoon)
								C.icon_state = pick("cocoon_large1","cocoon_large2","cocoon_large3")
						busy = 0
						stop_automated_movement = 0

	else
		busy = 0
		stop_automated_movement = 0

#undef SPINNING_WEB
#undef LAYING_EGGS
#undef MOVING_TO_TARGET
#undef SPINNING_COCOON
